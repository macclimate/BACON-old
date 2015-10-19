%%% Declare Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Data_Analysis/SM_analysis/'];
Ustar_th = 0.15;
% if exist([load_path 'TP02_SM_sythesis_results.mat'],'file')~=2;
%%% Load data:
disp('Loading TP02 data analysis file:')
TP02 = load([load_path 'TP02_SM_analysis_data.mat']);
close all;
figure(1);clf;
plot(TP02.data.NEE(TP02.data.Year >= 2008));

figure('Name','NEE');clf;
plot(TP02.data.NEE(TP02.data.Year == 2008),'b'); hold on;
h1(1) = plot(TP02.data.NEE_OPEC(TP02.data.Year == 2008),'b'); hold on;
h1(2) = plot(TP02.data.NEE(TP02.data.Year == 2009),'r'); hold on;
legend('2008', '2009')

TP02_2008_CO2 = load(['/home/brodeujj/1/fielddata/Matlab/Data/Flux/CPEC/TP02/Final_Cleaned/TP02_2008.CO2_irga']);
TP02_2009_CO2 = load(['/home/brodeujj/1/fielddata/Matlab/Data/Flux/CPEC/TP02/Final_Cleaned/TP02_2009.CO2_irga']);
figure('Name','CO_{2} Concentrations');clf;
plot(TP02_2008_CO2,'b'); hold on;
plot(TP02_2009_CO2,'r');
legend('2008', '2009')

TP02_2008_Fc = load(['/home/brodeujj/1/fielddata/Matlab/Data/Flux/CPEC/TP02/Final_Cleaned/TP02_2008.Fc']);
TP02_2009_Fc = load(['/home/brodeujj/1/fielddata/Matlab/Data/Flux/CPEC/TP02/Final_Cleaned/TP02_2009.Fc']);
figure('Name','Fc');clf;
plot(TP02_2008_Fc,'b'); hold on;
plot(TP02_2009_Fc,'r');
legend('2008', '2009')
