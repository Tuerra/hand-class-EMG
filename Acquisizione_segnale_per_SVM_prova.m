%% ACQUISIZIONE SEGNALE PER SVM
%Cerchiamo di valutare i marginals del segnale come avevano fatto Lucas &
%co. nel loro studio di segnali EMG multicanale.
%%
clearvars
%Nel nostro caso useremo 8 canali e decomporremo il segnale fino al 4°
%livello. Utiliziamo (off-line), per il training, il segnale acquisito da
%Simulink ("signals"), attraverso il file "Cerebro_Enrico". 

fs=1000;    % (Hz)
w=20;       % freq. di taglio filtro passa-alto
ws=200;     % (ms) larghezza finestra mobile
overlap=199; % overlap della media mobile
wavelet='coif4'; % wavelet per decomposizione
level_dec=4; % livello decomposizione
slice=200; % lunghezza intervalli in cui viene spezzettato il segnale
overdwt=100; % reciproco dell'overlap dell'estrazione dei coefficienti
channel=8; % numero canali
gest=6; % numero gesti (escluso rest)
del=400; % 1/2 lunghezza intervallo da eliminare
repetitions=6; % ripetizioni dei gesti
anticipo=1000;

%{
%Usiamo il un file di acquisizione "daq_x_7_gesture".
%load('daq_1_7_gestures.mat');
%load('daq_2_7_gestures.mat');
%load('daq_3_7_gestures.mat');
%load('daq_4_7_gestures.mat');
signal=getdatasamples(signals,1:signals.Length);
flag=transpose(signal(:,1)); % segnale flag
signal(:,1)=[];
signal=transpose(signal);
%}

%Generiamo il cue signal, 1 kHz
load('cue_signal_10_09.mat')
cue=length(cue_signal); %lunghezza che useremo dopo
cue_signal=[cue_signal;cue_signal; cue_signal; cue_signal; cue_signal; cue_signal; cue_signal; cue_signal; cue_signal; cue_signal; cue_signal];
cue_signal=cue_signal*700;

%Carichiamo il file con le dieci acquisizioni
load('signal_array_10_09_3_final.mat')

%Prime 5 ripetizioni
%{
%Le prime 5 ripetizioni sono quelle che vanno da 70 000 a 70 000*6,
%prendiamo un margine iniziale di mille campioni così da non partire subito
%con un picco del cue_signal

signal=signal_gesture(cue-anticipo:1:cue*repetitions-anticipo-1,:);
cue_signal=cue_signal(cue-anticipo:1:cue*repetitions-anticipo-1);
%}

%Altre 5 ripetizioni
%
%Queste ripetizioni invece vanno da 70 000*6 fino alla fine del segnale

signal=signal_gesture((cue*repetitions)-anticipo:1:length(signal_gesture),:);
cue_signal=cue_signal((cue*repetitions)-anticipo:1:length(signal_gesture));
%}

signal=signal';
cue_signal=cue_signal';
%Acquisiamo i dati del tempo dei flag
Tf=flagtime(cue_signal/700,gest,repetitions-1);
%Tf=Tf/1000;

%Filtraggio
for i=1:1:channel
    a=signal(i,:);
    a=f_notch(a,fs);
    a=f_notch_60(a,fs);
    a=f_butter(a,w,fs);
    a=f_rms(a,ws,overlap);
    signal(i,:)=a;
    clear a    
end

%Grafici segnali filtrati
%{
for i=1:1:8
    plot(signal(i,:))
    hold on
end
%}
%Generiamo il vettore time e ricaviamo la lunghezza del segnale
L=size(signal,2);
%time=1:1:L;
%time=time/1000;

%Generiamo un vettore con tutti i label per ognuno degli intervalli in cui
%abbiamo tagliato il segnale. Per farlo utilizziamo il file Tf ed
%assegniamo ad ognuno dei gesti un valore numerico crescente da 1 a 6
%(rest=0). ATTENZIONE: vanno ancora eliminati i valori transitori.
labvec=zeros(L,1);
h=1;
k=1;
for i=1:1:L
    if i>=Tf(h) && i<=Tf(h+1)
        labvec(i,1)=k;
    elseif i>Tf(h+1)
        k=k+1;
        h=h+2;
        if k>gest
            k=1;
        end
        if h>=length(Tf)
            h=length(Tf)-1;
        end   
    end
end
clear h k

%Dividiamo il segnale in tante "fette" di uguale dimensione(slice) per ogni
%canale, salviamo queste "fette" in una tabella specifica. Una riga di questa
%tabella conterrà le "fette" ottenute, per ogni canale, ad uno stesso
%intervallo temporale.
for i=1:overdwt:L
    if i+slice<=L
        E=i;
    end
end
slicetab=zeros(ceil(E/overdwt),slice*channel);
for i=1:1:channel
a=signal(i,:);
slicetab(1:ceil(E/overdwt),(i-1)*slice+1:i*slice) = a((0:overdwt:E-1)' + (1:slice));
end
clear a
%Manteniamo anche il vettore delle label delle stesse dimensioni in modo da
%assegnare ad ogni fetta ottenuta un valore. Per far questo eliminiamo
%alcuni valori ridondanti.
a=(1:overdwt:E)';
labvec=labvec(a);
clear a


%Eliminiamo ora le righe inerenti ai transitori per fare questo troviamo i
%valori indicati da Tf nella prima colonna di slicetab e quindi eliminiamo
%le righe corrispondenti a quei valori, assieme ad alcuni intervalli di
%contorno. Facciamo lo stesso lavoro anche per labvec.
for i=1:1:length(Tf)
    val=signal(1,Tf(i));
    c=slicetab(:,1:1:slice)==val;
    [row,~]=find(c);
    slicetab(row,:)=0;
    %slicetab(row(end)-2*ceil(slice/overdwt):row(end),:)=0;
    slicetab(row(1):row(1)+2*ceil(slice/overdwt),:)=0;
    labvec(row)=100;
    %labvec(row(end)-2*ceil(slice/overdwt):row(end))=100;
    labvec(row(1):row(1)+2*ceil(slice/overdwt))=100;
    clear c
end
e=any(slicetab,2);
slicetab=slicetab(e,:);
labvec(labvec==100)=[];
clear e val row




%Estraiamo ora i coefficienti, ne calcoliamo i marginals e li salviamo
%sulla matrice delle features (M). Fatto questo, aggiungiamo i label ad M
%sostituendo l'ultima colonna con il vettore labvec

M=zeros(tk,33);

for i=1:1:tk
    h=1;
    for j=1:slice:size(slicetab,2)
        a=slicetab(i,j:1:j+slice-1);
        cd=getcoef(a,wavelet,level_dec);
        m=marginals(cd);
        M(i,h:1:h+level_dec-1)=m;
        h=h+level_dec;
    end
end

%Aggiungiamo all'ultima riga di M il vettore delle label. Quindi facciamo
%un sort dell'ultima riga per ordinarli ed eliminiamo i valori di Rest in
%eccesso, in questo modo avremo una matrice delle feature più omogenea.
M(:,33)=labvec;

notZero=nnz(M(:,end));
mean=round(notZero/gest);
M=sortrows(M,size(M,2));
step=round((find(M(:,end),1)-1)/mean);
for i=1:step:(find(M(:,end),1)-1)
M(i,end)=7;
end
d=any(M(:,33),2);
M=M(d,:);



%Abbiamo ottenuto la nostra matrice delle feature 

%clear a m cd h i j L E tk


clearvars -except M

%run('SVM_crossValidation.m')




