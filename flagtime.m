%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    FLAG TIME   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ricevuto un vettore in ingresso rileva gli intervalli in cui i valori sono
%maggiori di zero e salva su un vettore riga Tf gli indici degli elementi
%iniziali e finali di questi intervalli. Con N si intende il numero di
%gesti eseguiti, mentre con R il numero di ripetizioni fatte Tf sarà di dimensioni 2N.
function [Tf]= flagtime(flag,N,R)
s=length(flag);
Tf=zeros(1,N*R*2);
k=1; %indice per l'inserimento dei dati in Tf

%Analizza tutto un vettore e si attiva quando due elementi consecutivi sono
%diversi. In base al valore degli elementi (0 o 1) salva l'indice di questi
%nella matrice Tf.
for i=2:1:s
    if flag(1,i)~=flag(1,i-1)
        if flag(1,i)>0
            Tf(k)=i;
            k=k+1;
        else
            Tf(k)=i-1;
            k=k+1;
        end
    end
end
Tf(Tf==0)=[];
end

        
