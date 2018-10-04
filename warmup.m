%% INIZIALIZZAZIONE
%script da lanciare prima di far partire il programma per la
%classificazione online.

%blocco "EMG system"
load('START_parametri_simulink.mat')

%filtraggio
fs=1000; %sample rate (Hz)
Q=15; %quality factor notch
notch=50; %frequenza filtraggio notch
w=20; %frequenza di taglio passa alto
ws=200; %larghezza finestra mobile RMS

%DWT
level_dec=4; %livello di decomposizione
interval=192; %
n1=interval/2;
n2=interval/(2^2);
n3=interval/(2^3);
n4=interval/(2^4);
overlap='no';
if strcmp(overlap,'no')
    over=0;
else
    over=interval/2;
end

%mano robotica
run('KinematicData.m')
run('matrix_h_hand_config.m')

%posizioni mano
%{
OpenHand= [0 0 0  0 0 0  0 0 0  0 0 0  0 0 0];
PowerGrasp=250*[ 0.2247 0.1098 0.3023  0 0.352 0.3178  0 0.4422 0.2971 0 0.3792 0.2754 0 0.3905 0.3292];
ThreeFingers=[ 0 0 0  0 0 0  0 0 0  0 90 6 0 0 90 60];
UlnarPinch=[ 0 40 20  0 0 0  0 0 0  0 70 10  0 70 10];
PrecisionGrip=[ 0 40 20 0 70 10 0 70 10 0 0 0 0 0 0];
IndexPointing=250*[ 0.2247 0.1098 0.3023  0 0 0  0 0.4422 0.2971 0 0.3792 0.2754 0 0.3905 0.3292];
%}

%parametri di deafult per poter far partire simulazione
sM=0;
sS=0;
model=0;






