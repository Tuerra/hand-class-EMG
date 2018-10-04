%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    FILTRO NOTCH   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function emg_channel_1_notch=f_notch(emg_channel_1, fs)
f_pli=50; % frequenza che si vuole filtrare con il notch
val_att = 10; % valore di attenuazione (lasciare invariato)
Q = 50; % parametro di qualità (lasciare invariato)
wo = f_pli/(fs/2); % pulsazione zero (lasciare invariato) [fs è indicata precedentemente]
bw = wo/Q; % banda (lasciare invariato)
[b_notch,a_notch] = iirnotch(wo,bw,val_att);

emg_channel_1_notch = filter(b_notch,a_notch,emg_channel_1);
end