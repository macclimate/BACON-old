function [] = met2plot(year)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This program plots time-averaged met variables collected from the Met2
%%%% Station, to allow for easy and quick inspection of sensor operation.
%%%% # of days in year is necessary to scale the x (time) axis properly.
%%%% Created May 24, 2007 by JJB
%%%% Modified May 28, 2007 by JJB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;

if mod(year,400)==0
    days_in_year = 366;
    
elseif mod(year,4) ==0
    days_in_year = 366;
    
else 
    days_in_year = 365;
end

%%%% Declare paths for each time averaged variable %%%%
path5 = (['C:\Home\Matlab\Data\Met\Organized2\Met2\Column\5min\Met2_' num2str(year) '.']);


path30 = (['C:\Home\Matlab\Data\Met\Organized2\Met2\Column\30min\Met2_' num2str(year) '.']);


pathday = (['C:\Home\Matlab\Data\Met\Organized2\Met2\Column\1440min\Met2_' num2str(year) '.']);


%%%% Load Timevectors for 5 min, 30 min and 1 day column vectors & convert into fractions of a year %%%%
tv_5 = load([path5 'tv']);
tv_5int = days_in_year./length(tv_5); %%% determines increments of year for each TV entry
tv_5(1:length(tv_5),1) = (tv_5int:tv_5int:days_in_year)';
tv_5(1:length(tv_5),1) = tv_5+1;

tv_30 = load([path30 'tv']);
tv_30int = days_in_year./length(tv_30); %%% determines increments of year for each TV entry
tv_30(1:length(tv_30),1) = (tv_30int:tv_30int:days_in_year)';
tv_30(1:length(tv_30),1) = tv_30+1;

tv_day = load([pathday 'tv']);
tv_dayint = days_in_year./length(tv_day); %%% determines increments of year for each TV entry
tv_day(1:length(tv_day),1) = (tv_dayint:tv_dayint:days_in_year)';
tv_day(1:length(tv_day),1) = tv_day+1;


%%%% FIGURE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Par_up5 (.005) and Par_down5 (.006) together
par_up5 = load([path5 '005']);
par_down5 = load([path5 '006']);
figure(1)
clf;
h1 = plot(tv_5,par_up5,'k-');
hold on
h2 = plot(tv_5,par_down5./20,'r-');
ylabel('PAR up, PAR down/20');
%% set(gca,'XTickLabel',[datestr(tv_5)]);
H = [h1 h2];
legend(H, 'PAR up', 'Par down / 20');
title('Incoming & Outgoing Radiation');

clear par_up5 par_down5 h1 h2 H;

%%%% FIGURE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Battery Voltage (.016) & Program Signal (.017)

batt_volt = load([pathday '016']);
prog_sig = load([pathday '017']);
figure (2)
clf;
subplot(2,1,1);
plot(tv_day,batt_volt,'k-');
ylabel('Battery Voltage, V');
title('Daily Diagnostic Variables');

subplot(2,1,2);
plot(tv_day,prog_sig,'k-');
ylabel('Prog Signature');


clear batt_volt prog_sig
%%%% FIGURE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot 30 min avg for Air TC (.007), RH (.008), Wspeed (.009) and
%%%% Wdir (.010)
air_TC = load([path30 '007']);
RH = load([path30 '008']);
WS = load([path30 '009']);
Wdir = load([path30 '010']);

figure (3)
clf;

%% Subplot 1 - TC
subplot(3,1,1)
plot(tv_30, air_TC, 'r-');
ylabel('Air Temp, C');
title('HMP Air Temp & RH');

%% Subplot 2 - RH
subplot(3,1,2)
plot(tv_30, RH, 'b-');
ylabel('Rel. Humidity, %');

%% Subplot 3 - Comparison
subplot(3,1,3)
h_air = plot(tv_30, air_TC, 'r-');
hold on
h_rh = plot(tv_30, (RH-75)./3, 'b-');
H = [h_air h_rh];
legend(H,'Air Temp, C','RH (Scaled)')

clear air_TC RH WS Wdir H;

clear batt_volt prog_sig
%%
%%%% FIGURE 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot 30 min avg for ParUp (.011), parDown (.012), NR (.013) and
%%%% H1 and H2 (.014, .015)
par_up30 = load([path30 '011']);
par_down30 = load([path30 '012']);
NR = load([path30 '013']);
HF1 = load([path30 '014']);
HF2 = load([path30 '015']);

figure (4)
clf;


% Subplot 1 - PAR
subplot (4,1,1);
h_pu30 = plot(tv_30,par_up30,'k-');
hold on
h_pd30 = plot(tv_30,par_down30./20,'r-');
ylabel('PAR up, PAR down/20');
H = [h_pu30 h_pd30];
legend(H, 'PAR up', 'Par down / 20');
title('Radiation and Heat Flux')
clear H;

% Subplot 2 - Net Radiation
subplot (4,1,2);
h_NR = plot(tv_30, NR, 'r-');
legend(h_NR, 'NR');
ylabel('Net Radiation');

% Subplot 3 - Compare HFluxes
subplot(4,1,3);
h_HF1 = plot(tv_30, HF1, 'k-');
hold on;
h_HF2 = plot(tv_30, HF2, 'g-');
H = [h_HF1 h_HF2];
legend(H, 'HF1', 'HF2');
ylabel('Heat Flux W/m2');
clear H;

% Subplot 4 - Compare H and NR
subplot (4,1,4)
h_HF1 = plot(tv_30, HF1, 'k-');
hold on;
h_HF2 = plot(tv_30, HF2, 'g-');
h_NR = plot(tv_30, NR./20, 'r-');
H = [h_HF1 h_HF2 h_NR];
legend(H, 'HF1', 'HF2', 'NR/20');
ylabel('H Flux & Net Radiation');

clear par_up30 par_down30 NR HF1 HF2 H;
%%
%%%% FIGURE 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Soil Temperatures from pits A and B
Ts100a = load([path30 '018']);
Ts50a = load([path30 '019']);
Ts20a = load([path30 '020']);
Ts10a = load([path30 '021']);
Ts5a = load([path30 '022']);
Ts2a = load([path30 '023']);

Ts100b = load([path30 '024']);
Ts50b = load([path30 '025']);
Ts20b = load([path30 '026']);
Ts10b = load([path30 '027']);
Ts5b = load([path30 '028']);
Ts2b = load([path30 '029']);

figure (5)
clf;


% Subplot 1 - Pit A
subplot(2,1,1);
h_100a = plot(tv_30, Ts100a, 'Color', [0 0 0], 'LineStyle','-');
hold on;
h_50a = plot(tv_30, Ts50a, 'Color', [1 0 1], 'LineStyle','-');
h_20a = plot(tv_30, Ts20a, 'Color', [0 1 1], 'LineStyle','-');
h_10a = plot(tv_30, Ts10a, 'Color', [1 0 0], 'LineStyle','-');
h_5a = plot(tv_30, Ts5a, 'Color', [0 1 0], 'LineStyle','-');
h_2a = plot(tv_30, Ts2a, 'Color', [0 0 1], 'LineStyle','-');
Ha = [h_100a h_50a h_20a h_10a h_5a h_2a];
legend(Ha, 'Ts 100cm','50','20','10','5','2');
axis([tv_30(1) tv_30(length(tv_30)) -5 30])
ylabel('Pit A Soil Temperatures, C');
title('Soil Temperature Profiles')

% Subplot 2 - Pit B
subplot(2,1,2);
h_100b = plot(tv_30, Ts100b, 'Color', [0 0 0], 'LineStyle','-');
hold on;
h_50b = plot(tv_30, Ts50b, 'Color', [1 0 1], 'LineStyle','-');
h_20b = plot(tv_30, Ts20b, 'Color', [0 1 1], 'LineStyle','-');
h_10b = plot(tv_30, Ts10b, 'Color', [1 0 0], 'LineStyle','-');
h_5b = plot(tv_30, Ts5b, 'Color', [0 1 0], 'LineStyle','-');
h_2b = plot(tv_30, Ts2b, 'Color', [0 0 1], 'LineStyle','-');

Hb = [h_100b h_50b h_20b h_10b h_5b h_2b];
legend(Hb, 'Ts 100cm','50','20','10','5','2');
axis([tv_30(1) tv_30(length(tv_30)) -5 30])
ylabel('Pit B Soil Temperatures, C');

clear Ts100a Ts50a Ts20a Ts10a Ts5a Ts2a; 
clear Ts100b Ts50b Ts20b Ts10b Ts5b Ts2b;
%%
%%%% FIGURE 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Soil Moisture from Pits A and B

% M100a = load([path30 '050']);
M50a = load([path30 '030']);
M20a = load([path30 '031']);
M10a = load([path30 '032']);
M5a = load([path30 '033']);

M50b = load([path30 '034']);
M20b = load([path30 '035']);
M10b = load([path30 '036']);
M5b = load([path30 '037']);
% 
figure (6)
clf;


% Subplot 1 - Pit A
subplot(2,1,1);
% h_M100a = plot(tv_30, M100a, 'Color', [1 0.5 0.5], 'LineStyle','-');
h_M50a = plot(tv_30, M50a, 'Color', [1 0 1], 'LineStyle','-');
hold on;

h_M20a = plot(tv_30, M20a, 'Color', [0 1 1], 'LineStyle','-');
h_M10a = plot(tv_30, M10a, 'Color', [1 0 0], 'LineStyle','-');
h_M5a = plot(tv_30, M5a, 'Color', [0 1 0], 'LineStyle','-');
HMa = [ h_M50a h_M20a h_M10a h_M5a];
legend(HMa, '50','20','10','5');
axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
ylabel('Pit A Soil Moisture, %');
title('Soil Moisture Profiles');

% Subplot 2 - Pit B
subplot(2,1,2);

h_M50b = plot(tv_30, M50b, 'Color', [1 0 1], 'LineStyle','-');
hold on;
h_M20b = plot(tv_30, M20b, 'Color', [0 1 1], 'LineStyle','-');
h_M10b = plot(tv_30, M10b, 'Color', [1 0 0], 'LineStyle','-');
h_M5b = plot(tv_30, M5b, 'Color', [0 1 0], 'LineStyle','-');
HMb = [ h_M50b h_M20b h_M10b h_M5b];
legend(HMb, 'M 50cm','20','10','5');
axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
ylabel('Pit B Soil Moisture, %');

clear M50a M20a M10a M5a; 
clear M50b M20b M10b M5b;
%%
%%%% FIGURE 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Tree Bole Temperatures (.038 to .048) %%%%%%%%%%%%
TreeT1 = load([path30 '038']);
TreeT2 = load([path30 '039']);
TreeT3 = load([path30 '040']);
TreeT4 = load([path30 '041']);
TreeT5 = load([path30 '042']);

TreeT6 = load([path30 '043']);
TreeT7 = load([path30 '044']);
TreeT8 = load([path30 '045']);
TreeT9 = load([path30 '046']);
TreeT10 = load([path30 '047']);

TreeT11 = load([path30 '048']);
air_TC = load([path30 '007']);

figure (7)
clf;
hold on;

h_T1 = plot(tv_30, TreeT1, 'Color', [1 0 1], 'LineStyle','-');
h_T2 = plot(tv_30, TreeT2, 'Color', [0 1 1], 'LineStyle','-');
h_T3 = plot(tv_30, TreeT3, 'Color', [1 0.5 1], 'LineStyle','-');
h_T4 = plot(tv_30, TreeT4, 'Color', [0.2 0.8 0.3], 'LineStyle','-');
h_T5 = plot(tv_30, TreeT5, 'Color', [1 0 0], 'LineStyle','-');

h_T6 = plot(tv_30, TreeT6, 'Color', [0 1 0], 'LineStyle','-');
h_T7 = plot(tv_30, TreeT7, 'Color', [0 0 1], 'LineStyle','-');
h_T8 = plot(tv_30, TreeT8, 'Color', [0 0 0], 'LineStyle','-');
h_T9 = plot(tv_30, TreeT9, 'Color', [0.7 0.7 0.7], 'LineStyle','-');
h_T10 = plot(tv_30, TreeT10, 'Color', [0.5 0.4 0.9], 'LineStyle','-');

h_T11 = plot(tv_30, TreeT11, 'Color', [0.9 0.1 0.5], 'LineStyle','-');
% h_air = plot(tv_30, air_TC, 'Color', [0.9 0.9 0.9], 'LineStyle','-');

HT = [h_T1 h_T2 h_T3 h_T4 h_T5 h_T6 h_T7 h_T8 h_T9 h_T10 h_T11];
legend(HT, 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11'); 
title('Tree Bole Temps & Air Temp');
ylabel('Temperature, C');

clear HT TreeT1 TreeT2 TreeT3 TreeT4 TreeT5 TreeT6;
clear TreeT7 TreeT8 TreeT9 TreeT10 TreeT11;
%%