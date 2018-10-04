%% soft UB-Hand


f0=[100;100;100;100;100];
f0_wrist=[100;100;100;100];

%%%% FINGER
h_finger=[5.25 5.8 0;-5.25 5.8 0;0 1 4.75;0 -5.5 0;0 1 -8.075];

h11=5.25;h12=5.8;h13=0;
h21=-5.25;h22=5.8;h23=0;
h31=0;h32=1;h33=4.75;
h41=0;h42=-5.5;h43=0;
h51=0;h52=1;h53=-8.075;

pseudo_inv_h_finger=pinv(h_finger);
pseudo_inv_trasp_h_finger=pinv(transp(h_finger));

null_base_finger=null(transp(h_finger));

null_sum_finger=null_base_finger(:,1)+null_base_finger(:,2);

%%%% THUMB
h_thumb=[7.34 -11 0;7.34 11 0;0 0 6;-7.34 0 0;0 0 -9.8];

pseudo_inv_h_thumb=pinv(h_thumb);
pseudo_inv_trasp_h_thumb=pinv(transp(h_thumb));

null_base_thumb=null(transp(h_thumb));

null_sum_thumb=null_base_thumb(:,1)+null_base_thumb(:,2);

%%%% WRIST
h_wrist=[19 0;-19 0;0 12.25;0 -12.25];

pseudo_inv_h_wrist=pinv(h_wrist);
pseudo_inv_trasp_h_wrist=pinv(transp(h_wrist));

null_base_wrist=null(transp(h_wrist));

null_sum_wrist=0.8*null_base_wrist(:,1)+null_base_wrist(:,2);

%%%% sample time specifications
t=Ts;
Temg=0.0005;
media=ones(1,200)*(1/200);
