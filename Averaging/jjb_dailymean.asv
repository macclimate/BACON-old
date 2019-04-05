%% This program calculates daily mean values for cleaned fluxes and 
%% meteorological variables..
% INPUTS:
% days -- number of days to integrate means over (e.g. '1' is daily avg
clear all;
close all;

days = 1;
site = 1;
model = 4;
counter = 1;
path = ['C:\HOME\MATLAB\Data\Data_Analysis\M' num2str(site) '_allyears\'];
for year = 2003:1:2007
disp(year)
%% load data for given year    
data = load([path 'M' num2str(site) 'output_model' num2str(model) '_' num2str(year) '.dat']);
%SPECIFY DATA COLUMNS
% dt = data(:,1); NEP = data(:,2).*0.0216 ; R = data(:,3).*0.0216; 
% GEP = data(:,4).*0.0216; Ta = data(:,5); Ts = data(:,6); SM = data(:,7);
% PAR = data(:,8);
dt = data(:,1); NEP = data(:,3).*0.0216 ; R = data(:,4).*0.0216; 
GEP = data(:,5).*0.0216; Ta = data(:,6); Ts = data(:,7); SM = data(:,9);
PAR = data(:,9);


clear data;

%% Run integzBC1 program to integrate to daily values
  
[NEPavg(counter).sum,NEPavg(counter).mean,NEPavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(NEP)),NEP(~isnan(NEP)),1:length(dt)/48,days);

[Ravg(counter).sum,Ravg(counter).mean,Ravg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(R)),R(~isnan(R)),1:length(dt)/48,days);

[GEPavg(counter).sum,GEPavg(counter).mean,GEPavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(GEP)),GEP(~isnan(GEP)),1:length(dt)/48,days);

[Taavg(counter).sum,Taavg(counter).mean,Taavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(Ta)),Ta(~isnan(Ta)),1:length(dt)/48,days);

[Tsavg(counter).sum,Tsavg(counter).mean,Tsavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(Ts)),Ts(~isnan(Ts)),1:length(dt)/48,days);

[SMavg(counter).sum,SMavg(counter).mean,SMavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(SM)),SM(~isnan(SM)),1:length(dt)/48,days);

[PARavg(counter).sum,PARavg(counter).mean,PARavg(counter).Tstamp,] ... 
 = integzBC1(dt(~isnan(PAR)),PAR(~isnan(PAR)),1:length(dt)/48,days);

NEP_year = NEPavg(counter).mean';
save([path 'Means\M' num2str(site)  '_NEP_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'NEP_year','-ASCII');
% NEP_year_sum = NEPavg(counter).sum';
% save([path 'Means\M' num2str(site)  '_NEP_' num2str(year) '_model' num2str(model) '_' num2str(days) 'daysum.dat'],'NEP_year_sum','-ASCII');
R_year = Ravg(counter).mean';
save([path 'Means\M' num2str(site) '_R_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'R_year','-ASCII');
GEP_year = GEPavg(counter).mean';
save([path 'Means\M' num2str(site) '_GEP_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'GEP_year','-ASCII');
Ta_year = Taavg(counter).mean';
save([path 'Means\M' num2str(site) '_Ta_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'Ta_year','-ASCII');
Ts_year = Tsavg(counter).mean';
save([path 'Means\M' num2str(site) '_Ts_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'Ts_year','-ASCII');
SM_year = SMavg(counter).mean';
save([path 'Means\M' num2str(site) '_SM_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'SM_year','-ASCII');
PAR_year = PARavg(counter).mean';
save([path 'Means\M' num2str(site) '_PAR_' num2str(year) '_model' num2str(model) '_' num2str(days) 'dayavg.dat'],'PAR_year','-ASCII');

%% Do monthly means (while we're here).

[NEP_mon_sum NEP_mon_mean] = jjb_month_stats(year,NEP);
[GEP_mon_sum GEP_mon_mean] = jjb_month_stats(year,GEP);
[R_mon_sum R_mon_mean] = jjb_month_stats(year,R);
[Ta_mon_sum Ta_mon_mean] = jjb_month_stats(year,Ta);
[Ts_mon_sum Ts_mon_mean] = jjb_month_stats(year,Ts);
[SM_mon_sum SM_mon_mean] = jjb_month_stats(year,SM);
[PAR_mon_sum PAR_mon_mean] = jjb_month_stats(year,PAR);

save([path 'Means\M' num2str(site)  '_NEP_' num2str(year) '_model' num2str(model) '_monsum.dat'],'NEP_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_NEP_' num2str(year) '_model' num2str(model) '_monmean.dat'],'NEP_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_GEP_' num2str(year) '_model' num2str(model) '_monsum.dat'],'GEP_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_GEP_' num2str(year) '_model' num2str(model) '_monmean.dat'],'GEP_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_R_' num2str(year) '_model' num2str(model) '_monsum.dat'],'R_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_R_' num2str(year) '_model' num2str(model) '_monmean.dat'],'R_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_Ta_' num2str(year) '_model' num2str(model) '_monsum.dat'],'Ta_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_Ta_' num2str(year) '_model' num2str(model) '_monmean.dat'],'Ta_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_Ts_' num2str(year) '_model' num2str(model) '_monsum.dat'],'Ts_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_Ts_' num2str(year) '_model' num2str(model) '_monmean.dat'],'Ts_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_SM_' num2str(year) '_model' num2str(model) '_monsum.dat'],'SM_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_SM_' num2str(year) '_model' num2str(model) '_monmean.dat'],'SM_mon_mean','-ASCII');
save([path 'Means\M' num2str(site)  '_PAR_' num2str(year) '_model' num2str(model) '_monsum.dat'],'PAR_mon_sum','-ASCII');
save([path 'Means\M' num2str(site)  '_PAR_' num2str(year) '_model' num2str(model) '_monmean.dat'],'PAR_mon_mean','-ASCII');


counter = counter + 1;


clear NEP_year R_year GEP_year Ta_year Ts_year SM_year PAR_year;
clear NEP GEP dt R PAR Ts Ta SM;
clear NEP_mon_sum NEP_mon_mean GEP_mon_sum GEP_mon_mean R_mon_sum R_mon_mean;
clear Ta_mon_sum Ta_mon_mean Ts_mon_sum Ts_mon_mean SM_mon_sum SM_mon_mean;
clear PAR_mon_sum PAR_mon_mean;
end
% Reset counter to be recording of number of years processed:
counter = counter - 1;


% 
% 
% for i = 1:1:counter
%     
% save([path 'Means\NEP_'     
% 
% 
% 
% end

NEP_all = [NEPavg(1).sum NEPavg(2).sum NEPavg(3).sum NEPavg(4).sum NEPavg(5).sum];
% dt_all = [NEPavg(1).Tstamp NEPavg(2).Tstamp NEPavg(3).Tstamp NEPavg(4).Tstamp NEPavg(5).Tstamp];
dt = 1:1:length(NEP_all);
figure(1); clf
plot(dt,NEP_all,'.')
Xticks = [1 366 732 1097 1462];
Xticklab = ['Jan 03'; 'Jan 04'; 'Jan 05'; 'Jan 06';'Jan 07'];
set(gca, 'XTick',Xticks,'XTickLabel',Xticklab, 'FontSize',16);
ylabel('NEP (g C m^{-2}d^{-1})');
axis([1 1826 -6 8])
print('-dbmp','C:/miflux')
% set(gca,'YGrid','on')