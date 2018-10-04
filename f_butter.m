%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%   FILTRO BUTTER   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%filtro passa-alto

function emg_channel_1_butter=f_butter(emg_channel_1,w, fs)
[b_butter,a_butter] = butter(9,w/(fs/2),'high'); % w è la freq del passa alto

emg_channel_1_butter = filter(b_butter,a_butter,emg_channel_1);
end