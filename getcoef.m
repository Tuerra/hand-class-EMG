%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    GETCOEF   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ricevuto un segnale in ingresso (assieme alle wavelet da usare ed al
%livello di decomposzione) ne estrae i coefficienti.
function [cDetail]= getcoef(signal,wavelet_1, level_dec)
S=level_dec; %livello di decomposizione
[C,L] = wavedec(signal,S,wavelet_1);
cDetail=zeros(S,L(S+1));
    for i=1:1:S
            a=size(detcoef(C,L,i),2);
            cDetail(i,1:a)=detcoef(C,L,i); %cD
    end
end