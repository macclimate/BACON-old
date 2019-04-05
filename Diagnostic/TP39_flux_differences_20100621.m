% Let's try and find what is wrong with 2003 data:

ls = addpath_loadstart;
path = [ls 'Matlab/Data/Master_Files/TP39/TP39_data_master_2003.mat'];
load(path);

figure(1);clf
plot(master.data(:,7))

%%% Test what the problem may be with newly calculated flux data for TP39:
orig = load('/1/fielddata/DUMP_Data/TP39/Data_to_sort_2002--2005/CPEC/daily_Feb_2009/Fc06.dat');
tmp = load('/1/fielddata/Matlab/Data/Master_Files/TP39_data_master_backup_20100527.mat');
old = tmp.master.data(tmp.master.data(:,1)==2006,11);
clear tmp;
new = load('/1/fielddata/SiteData/TP39/MET-DATA/annual/TP39_2006.Fc');

corr_factor = load('/1/fielddata/SiteData/TP39/MET-DATA/backups/Fc_corr_2006.dat');
figure(1);clf;
plot(old,'r');hold on;
plot(orig,'b');hold on;
plot(new.*corr_factor,'g');
axis([1 17520 -30 25])

figure(2);clf;
plot(orig, new.*corr_factor,'b.')
axis([-35 35 -35 35])


%%%% 
NEE_new = load('/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Calculated/TP39_2006.NEE_raw');
tmp = load('/1/fielddata/Matlab/Data/Master_Files/TP39_AA_analysis_data_20100407.mat');
NEE_old = tmp.data.NEE(tmp.data.Year==2006);
ustr = tmp.data.Ustar(tmp.data.Year==2006);


figure(1);clf;
plot(NEE_new(ustr > 0.35)); hold on;
plot(NEE_old(ustr > 0.35),'r');

(nansum(NEE_new(ustr > 0.35)).*0.0216)
(nansum(NEE_old(ustr > 0.35)).*0.0216)


%%%% For Emily

data_old = load('/1/fielddata/Matlab/Data/Master_Files/TP39_AA_analysis_data_20100407.mat');
data_new = load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_AA_analysis_data.mat');


figure(3);clf;
plot(data_old.data.NEE);hold on;
plot(data_new.data.NEE_filled_PI_pref,'r');hold on;

sum_NEE_2009_old = sum(data_old.data.NEE_filled_PI_pref(data_old.data.Year == 2009)).*0.0216;
sum_NEE_2009_new = sum(data_new.data.NEE_filled_PI_pref(data_new.data.Year == 2009)).*0.0216;

sum_GEP_2009_old = sum(data_old.data.GEP_filled_PI_pref(data_old.data.Year == 2009)).*0.0216;
sum_GEP_2009_new = sum(data_new.data.GEP_filled_PI_pref(data_new.data.Year == 2009)).*0.0216;

sum_RE_2009_old = sum(data_old.data.RE_filled_PI_pref(data_old.data.Year == 2009)).*0.0216;
sum_RE_2009_new = sum(data_new.data.RE_filled_PI_pref(data_new.data.Year == 2009)).*0.0216;


a = load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_2009.mat');