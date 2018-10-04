%% TRAINING
%controllare di aver spostato il ramo del file simulink su training

%Parametri per l'estrazione
fs=1000;
wavelet='db3'; % wavelet per decomposizione
level_dec=4; % livello decomposizione
slice=192; % lunghezza intervalli in cui viene spezzettato il segnale
overdwt=192; % reciproco dell'overlap dell'estrazione dei coefficienti
channel=8; % numero canali
gest=6; % numero gesti (escluso rest)
repetitions=6; % ripetizioni dei gesti
nFold=10; % numero gruppi per cross-validation
humDelay=1;

%acquisizione dati
filtSignal=filtSignal(1:length(cue_signal),:);
signal=transpose(filtSignal(humDelay:1:end,:));

%acquisizione tempi dei gesti
Tf=flagtime(cue_signal',gest,repetitions); %%% da cambiare il flag in arrivo

%lunghezza segnale
L=length(signal); 
%generiamo il vettore delle label
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
%canale.
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
%assegnare ad ogni fetta ottenuta un valore.
labvec=labvec((1:overdwt:E)');
clear a
labels=labvec;
%Eliminiamo i transitori
for i=1:1:length(Tf)
    c=slicetab(:,1:1:slice)==signal(1,Tf(i));
    [row,~]=find(c);
    slicetab(row,:)=0;
    %slicetab(row(end)-2*ceil(slice/overdwt):row(end),:)=0;
    slicetab(row(1):row(1)+2*ceil(slice/overdwt),:)=0;
    labvec(row)=100;
    %labvec(row(end)-2*ceil(slice/overdwt):row(end))=100;
    labvec(row(1):row(1)+2*ceil(slice/overdwt))=100;
    clear c
end
slicetab=slicetab(any(slicetab,2),:);
labvec(labvec==100)=[];
clear row

%determiniamo la lunghezza della matrice delle feature
if size(slicetab,1)==length(labvec)
    tk=length(labvec);
else
    disp('Errore');
end

%Estraiamo i coefficienti e generiamo la matrice delle feature
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

%aggiungiamo il vettore delle label 
M(:,33)=labvec;

%bilanciamo il numero di valori di rest a quello delle altri classi
mean=round(nnz(M(:,end))/gest);
M=sortrows(M,size(M,2));
step=round((find(M(:,end),1)-1)/mean);
for i=1:step:(find(M(:,end),1)-1)
M(i,end)=7;
end
d=any(M(:,33),2);
M=M(d,:);
clear mean

%mischiamo in ordine casuale le feature
train = M(randperm(length(M)),:);

%normalizziamo i valori per ottenere il modello
sM = mean(train(:,1:end-1));
sS = std(train(:,1:end-1));
train(:,1:end-1) = train(:,1:end-1) - repmat(sM,size(train(:,1:end-1),1),1);
train(:,1:end-1) = train(:,1:end-1) ./ repmat(sS,size(train(:,1:end-1),1),1);

%facciamo una cross-validation per ottenere i migliori valori di C e gamma
[bestC,bestG,bestErr,guessed] = crossValidate(train(:,end),train(:,1:end-1),'c',@err_BER,nFold);

%generiamo il modello sulla base di questi parametri
model = svmtrain(train(:,end), train(:,1:end-1),sprintf('-c %f -g %f',bestC,bestG));

%poiché simulink non accetta matrici sparse salviamo il modello in un formato adatto
[sparse_i,sparse_j,sparse_val]=find(model.SVs);
sparse_matrix_indexes=[sparse_i,sparse_j,sparse_val];
model.SVs=sparse_matrix_indexes;









