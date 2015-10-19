output_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test/'];
year = 2010;
[heights] = params(year, 'TP39', 'Heights');
h_c = heights(2);
z_m = heights(1);
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;
TP39_master = load(['/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);

load([output_path 'KMtest1_' num2str(year) '_results.mat']);

inputs = out.input;
num_runs = size(inputs,1);
L = NaN.*ones(num_runs,1);ust_pred = NaN.*ones(num_runs,1);
Lstar = NaN.*ones(num_runs,1);
for i = 1:1:num_runs
    p_bar_tmp = inputs(i,1);
    wd_polar_tmp  = inputs(i,2); u_tmp = inputs(i,3); T_a_tmp = inputs(i,4);
    RH_tmp = inputs(i,5); H_tmp = inputs(i,6); LE_tmp = inputs(i,7);
    sig_v_tmp = inputs(i,8); ust_tmp = inputs(i,9);
            [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c, z_m, u_tmp, T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
            Lstar(i,1) = calc_monin_obhukov_L(ust_tmp,T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
end

figure(1);clf;
plot(L,'k.'); hold on;
plot(Lstar,'b.');

figure(2);clf;
plot(L,Lstar,'k.'); hold on;

