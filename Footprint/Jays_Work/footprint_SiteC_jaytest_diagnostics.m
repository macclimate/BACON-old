% L looks good - stable at night, unstable during the day.
% Wind directions look correct.  Did histogram of wd.
%%% This is how you plot rose diagram for wind data:
%%%figure(5);clf; jjb_wind_rose((wd_polar./pi()).*180,u)

year = 2006;
output_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test'];

% TP39_master = load(['/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
% TP39_CPEC = load(['/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Cleaned/TP39_CPEC_cleaned_' num2str(year) '.mat']);
TP39_master = load(['/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
TP39_CPEC = load(['/home/brodeujj/Matlab/Data/KM_footprint_test/Input/TP39_CPEC_cleaned_' num2str(year) '.mat']);
TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
[fetch] = params(year,'TP39', 'Fetch');
[angles_out dist_out] = fetchdist(fetch);
figure(11);clf;polar(angles_out, dist_out);
%%% Site parameters:
[heights] = params(year, 'TP39', 'Heights');
h_c = heights(2);
z_m = heights(1);
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;

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
PAR = TP39_master.master.data(:,118);
ind_data = prod([u wd p_bar T_a RH H LE sig_v ust],2);
L = NaN.*ones(length(ind_data),1);
ust_pred = NaN.*ones(length(ind_data),1);

        for i = 1:1:length(L)
            if ~isnan(ind_data(i,1))
        [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c, z_m, u(i,1), T_a(i,1), RH(i,1), p_bar(i,1), H(i,1), LE(i,1));
            end
        end
        
% plot L value alongside PAR (to see day/night values)        
figure(1);clf;
plot(PAR,'k');hold on;
plot(L,'.'); axis([1 17568 -1000 1000])
% Compare predicted and measured ustar:
figure(2);clf;
plot(ust, ust_pred,'k.'); hold on;
plot([0 2],[0 2],'b--');
axis([0 2 0 2]) 
ylabel('ustar_pred');xlabel('ustar_meas');
% Wind histograms:
figure(3);clf;hist(wd)
figure(4);clf;hist(wd_polar)
figure(5);clf; jjb_wind_rose((wd_polar./pi()).*180,u)