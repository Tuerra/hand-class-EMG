%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%-----  AVERAGE dei QUADRATI  -----%%%%%%%%%%%%%%%%%%%%%%
function sqrt_channel_1=f_rms(q_channel_1,wSize, overlap)

if overlap>=wSize
    disp('Errore')
elseif overlap==(wSize-1)
    %media mobile dei quadrati con overlap massimo
    y_channel_1 = movmean(q_channel_1.^2, [0 wSize]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%--RADICE DELLA MEDIA DEI QUADRATI--%%%%%%%%%%%
    sqrt_channel_1 = y_channel_1.^(1/2);
else 
    %media mobile dei quadrati con overlap
    y_channel_1 = movmean(q_channel_1.^2, [0 wSize]); 
    L=length(q_channel_1);
    step=wSize-overlap;
    windowEnd = 0:step:L-1;
    y_channel_1= y_channel_1(windowEnd);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%--RADICE DELLA MEDIA DEI QUADRATI--%%%%%%%%%%%
    sqrt_channel_1 = y_channel_1.^(1/2);
end
end