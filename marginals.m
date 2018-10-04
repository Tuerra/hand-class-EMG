%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    MARGINALS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcola il valore dei "marginals" del segnale e restituisce un vetore
%contenente questi valori. La dimensione del vettore sarà (1, S) dove S è
%pari al massimo livello di decomposizione.
function M_k=marginals(cDetail)
S=size(cDetail,1); %estraiamo il livello di decomposizione
M_k=zeros(1,S);
    for i=1:1:S
        a=length(cDetail(i,:));
%Questi marginals corrispondono alla somma dei valori assoluti dei vari
%coefficienti ottenuti per un singolo livello di decomposizione. Nel nostro
%caso corrispondono alla somma dei valori assoluti degli elementi di una
%riga della matrice cd
        m=0;
        for j=1:1:a
           m=abs(cDetail(i,j))+m ;
        end
        M_k(1,i)=m;
    end
end