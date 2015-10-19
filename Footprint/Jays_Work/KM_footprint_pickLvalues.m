output_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test/'];
year = 2010;
[heights] = params(year, 'TP39', 'Heights');
h_c = heights(2);
z_m = heights(1);
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;

TP39_master = load(['/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
TP39_CPEC = load(['/home/brodeujj/Matlab/Data/KM_footprint_test/Input/TP39_CPEC_cleaned_' num2str(year) '.mat']);
TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
%%% Site Variables:
p_bar = TP39_master.master.data(:,120);
wd = TP39_master.master.data(:,67);
u =  TP39_master.master.data(:,119);
T_a =  TP39_master.master.data(:,116);
RH =  TP39_master.master.data(:,117);
H =  TP39_master.master.data(:,10);
LE =  TP39_master.master.data(:,9);
sig_v = TP39_CPEC.master.data(:,24);
ust = TP39_master.master.data(:,11);
wd_polar = CSWind2Polar(wd);
Mon = TP39_master.master.data(:,2);
Day = TP39_master.master.data(:,3);
HH = TP39_master.master.data(:,4);
MM = TP39_master.master.data(:,5);

L = NaN.*ones(length(u),1);ust_pred = NaN.*ones(length(u),1);
Lstar = NaN.*ones(length(u),1);
for i = 1:1:length(u)
            [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c, z_m, u(i,1), T_a(i,1), RH(i,1), p_bar(i,1), H(i,1), LE(i,1));
            Lstar(i,1) = calc_monin_obhukov_L(ust(i,1),T_a(i,1), RH(i,1), p_bar(i,1), H(i,1), LE(i,1));
end
out.L = L;
out.Lstar = Lstar;
out.ust_pred = ust_pred;
out.ust = ust;

save([output_path 'L_pred_2010'],'out');
figure(1);clf;
plot(L); axis([1 17520 -2000 500]);
hold on;
plot(Lstar,'r');

figure(2);clf;
plot(L,Lstar,'k.');
axis([-2000 500 -2000 500]);

figure(3);clf;
plot(ust,'b'); hold on;
plot(ust_pred,'r');
axis([1 17520 -0.5 3]);

figure(4);clf;
plot(ust,ust_pred,'b.'); hold on;
axis([-0.5 3 -0.5 3]);