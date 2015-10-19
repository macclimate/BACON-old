load('/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/KM_TP39_2010_results.mat');

% want col 7.
TP39_master = load(['/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_2010.mat']);
TP39_CPEC = load(['/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Cleaned/TP39_CPEC_cleaned_2010.mat']);
TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
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
Year = TP39_master.master.data(:,1);
Mon = TP39_master.master.data(:,2);
Day = TP39_master.master.data(:,3);
HH = TP39_master.master.data(:,4);
MM = TP39_master.master.data(:,5);
PAR = TP39_master.master.data(:,118);

[fetch] = params(2010,'TP39', 'Fetch');
[angles_out dist_out] = fetchdist(fetch);

%%%%%%%%%%% 
%%%%%%% Histograms
bins = [0:200:2000]';

% ALL DATA
figure(7);clf;
polar(wd_polar,out.Xdist(:,5),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('ALL POINTS');

% NIGHTTIME
figure(8);clf;
ind_n = find(PAR<100);
polar(wd_polar(ind_n),out.Xdist(ind_n,5),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('NIGHT');

% DAYTIME
figure(9);clf;
ind_d = find(PAR>100);
polar(wd_polar(ind_d),out.Xdist(ind_d,5),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('DAY');

%%% ALL
n_all = histc(out.Xdist(:,5),bins);
figure(10);clf;
bar(bins,n_all./sum(n_all));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_all./sum(n_all))),'r-')
title('ALL POINTS');

%%% NIGHT
n_n = histc(out.Xdist(ind_n,5),bins);
figure(11);clf;
bar(bins,n_n./sum(n_n));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_n./sum(n_n))),'r-')
title('NIGHT');

%%% DAY
n_d = histc(out.Xdist(ind_d,5),bins);
figure(12);clf;
bar(bins,n_d./sum(n_d));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_d./sum(n_d))),'r-')
title('DAY');

%% 80%
% ALL DATA
figure(1);clf;
polar(wd_polar,out.Xdist(:,7),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('ALL POINTS');

% NIGHTTIME
figure(2);clf;
ind_n = find(PAR<100);
polar(wd_polar(ind_n),out.Xdist(ind_n,7),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('NIGHT');

% DAYTIME
figure(3);clf;
ind_d = find(PAR>100);
polar(wd_polar(ind_d),out.Xdist(ind_d,7),'bx');
hold on;
polar(angles_out,dist_out,'r-');
axis([-2000 2000 -2000 2000])
title('DAY');

%%%%%%% Histograms
bins = [0:200:2000]';

%%% ALL
n_all = histc(out.Xdist(:,5),bins);
figure(4);clf;
bar(bins,n_all./sum(n_all));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_all./sum(n_all))),'r-')
title('ALL POINTS');

%%% NIGHT
n_n = histc(out.Xdist(ind_n,7),bins);
figure(5);clf;
bar(bins,n_n./sum(n_n));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_n./sum(n_n))),'r-')
title('NIGHT');

%%% DAY
n_d = histc(out.Xdist(ind_d,7),bins);
figure(6);clf;
bar(bins,n_d./sum(n_d));
axis([100 2100 0 1]);
hold on;
plot(bins+100,1-cumsum((n_d./sum(n_d))),'r-')
title('DAY');

