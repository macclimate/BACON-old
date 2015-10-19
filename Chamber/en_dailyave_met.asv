%This script is designed to take the daily averages of the Soil Temperature
%at depths of 2cm, 5cm, 10cm, 20cm
%%%%Created on February 26, 2009%%%%

close all; clear all; clc

% --- get time ---
days = 1;

%%%%%%%%%%%%% 2008 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- get time vector ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX = dt;

%To load data%


Ts_2= load('C:/DATA/metdata 2008/TP39_2008.087');
Ts_5= load('C:/DATA/metdata 2008/TP39_2008.091');
Ts_10= load('C:/DATA/metdata 2008/TP39_2008.089');
Ts_20= load('C:/DATA/metdata 2008/TP39_2008.090');

JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');

% --- get Ts_2, oC ---
Ts_2 =  Ts_2; % oC 
[Ts_2sum,Ts_2mean,TimeX] = integzBC1(dt(~isnan(Ts_2)),Ts_2(~isnan(Ts_2)),1:365,days); 
Ts_2mean	=Ts_2mean'; 
save 'C:\DATA\condensed\daily\Ts_2_DM.dat' Ts_2mean  -ASCII

% --- get Ta_5, oC ---
Ts_5 =  Ts_5; % oC 
[Ts_5sum,Ts_5mean,TimeX] = integzBC1(dt(~isnan(Ts_5)),Ts_5(~isnan(Ts_5)),1:365,days); 
Ts_5Mean	=Ts_5mean'; 
save 'C:\DATA\condensed\daily\Ts_5_DM.dat' Ts_5Mean   -ASCII

% --- get Ts_10, oC ---
Ts_10 =  Ts_10; % oC 
[Ts_10sum,Ts_10mean,TimeX] = integzBC1(dt(~isnan(Ts_10)),Ts_10(~isnan(Ts_10)),1:365,days); 
Ts_10Mean	=	Ts_10mean'; 
save 'C:\DATA\condensed\daily\Ts_10_DM.dat' Ts_10Mean   -ASCII
% 
% --- get Ts_20, oC ---
Ts_20 =  Ts_20; % oC 
[Ts_20sum,Ts_20mean,TimeX] = integzBC1(dt(~isnan(Ts_20)),Ts_20(~isnan(Ts_20)),1:365,days); 
Ts_20Mean	=	Ts_20mean'; 
save 'C:\DATA\condensed\daily\Ts_20_DM.dat'  Ts_20Mean   -ASCII



%% Plot and see the data

load 'C:\DATA\condensed\daily\Ts_2_DM.dat';
load 'C:\DATA\condensed\daily\Ts_5_DM.dat';
load 'C:\DATA\condensed\daily\Ts_10_DM.dat';
load 'C:\DATA\condensed\daily\Ts_20_DM.dat';

figure (1);
hold on;
plot (Ts_2_DM, 'r', 'linewidth',2);
plot (Ts_5_DM, 'b', 'linewidth',2);
plot (Ts_10_DM,'g', 'linewidth',2);
plot (Ts_20_DM,'c', 'linewidth',2);
legend('Ts2','Ts5','Ts10','Ts20',1);
AXIS([214 365 -5 40]);
xlabel ('DOY');
ylabel ('Soil Temperature (oC)');
title ('Soil Temperature at Varying Depths')

figure (2);
hold on;
plot (Ts_2_DM, 'r', 'linewidth',2);
plot (Ts_5_DM, 'b', 'linewidth',2);
plot (Ts_10_DM,'g', 'linewidth',2);
plot (Ts_20_DM,'c', 'linewidth',2);
legend('Ts2','Ts5','Ts10','Ts20',1);
AXIS([0 365 -5 40]);
xlabel ('DOY');
ylabel ('Soil Temperature (oC)');
title ('Soil Temperature at Varying Depths')


%%%% Soil Moisure at Varying Depths%%%

close all; clear all; clc

% --- get time ---
days = 1;

%%%%%%%%%%%%% 2008 %%%%%%%%%%%%%%%
% --- get time vector ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX = dt;

%To load data%


SM_5= load('C:/DATA/metdata 2008/TP39_2008.099');
SM_10= load('C:/DATA/metdata 2008/TP39_2008.100');
SM_20= load('C:/DATA/metdata 2008/TP39_2008.101');

JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');


% --- get SM_5, oC ---
SM_5 =  SM_5; % oC 
[SM_5sum,SM_5mean,TimeX] = integzBC1(dt(~isnan(SM_5)),SM_5(~isnan(SM_5)),1:365,days); 
SM_5Mean	=SM_5mean'; 
save 'C:\DATA\condensed\daily\SM_5_DM.dat' SM_5Mean   -ASCII

% --- get SM_10, oC ---
SM_10 =  SM_10; % oC 
[SM_10sum,SM_10mean,TimeX] = integzBC1(dt(~isnan(SM_10)),SM_10(~isnan(SM_10)),1:365,days); 
SM_10Mean	=	SM_10mean'; 
save 'C:\DATA\condensed\daily\SM_10_DM.dat' SM_10Mean   -ASCII
% 
% --- get SM_20, oC ---
SM_20 =  SM_20; % oC 
[SM_20sum,SM_20mean,TimeX] = integzBC1(dt(~isnan(SM_20)),SM_20(~isnan(SM_20)),1:365,days); 
SM_20Mean	=	SM_20mean'; 
save 'C:\DATA\condensed\daily\SM_20_DM.dat'  SM_20Mean   -ASCII



%% Plot and see the data

load 'C:\DATA\condensed\daily\SM_5_DM.dat';
load 'C:\DATA\condensed\daily\SM_10_DM.dat';
load 'C:\DATA\condensed\daily\SM_20_DM.dat';

figure (3);
hold on;
plot (SM_5_DM, 'b', 'linewidth',2);
plot (SM_10_DM,'g', 'linewidth',2);
plot (SM_20_DM,'c', 'linewidth',2);
legend('SM5','SM10','SM20',1);
AXIS([214 365 0 0.30]);
xlabel ('DOY');
ylabel ('Soil Moisture (m3 m-3)');
title ('Soil Moisture at Varying Depths')

figure (4);
hold on;
plot (SM_5_DM, 'b', 'linewidth',2);
plot (SM_10_DM,'g', 'linewidth',2);
plot (SM_20_DM,'c', 'linewidth',2);
legend('SM5','SM10','SM20',1);
AXIS([0 365 0 .30]);
xlabel ('DOY');
ylabel ('Soil Moisture (m3 m-3)');
title ('Soil Moisture at Varying Depths')

close all; clear all; clc

%%Ambiant Temperature

% --- get time ---
days = 1;

%%%%%%%%%%%%% 2008 %%%%%%%%
% --- get time vector ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX = dt;

%To load data%

AbvCnpy= load('C:/DATA/metdata 2008/TP39_2008.007');
Cnpy= load('C:/DATA/metdata 2008/TP39_2008.008');
BlwCnpy= load('C:/DATA/metdata 2008/TP39_2008.009');


% --- get AbvCnpy, oC ---
AbvCnpy =  AbvCnpy; % oC 
[AbvCnpysum,AbvCnpymean,TimeX] = integzBC1(dt(~isnan(AbvCnpy)),AbvCnpy(~isnan(AbvCnpy)),1:365,days); 
AbvCnpymean	=AbvCnpymean'; 
save 'C:\DATA\condensed\daily\AbvCnpy_DM.dat' AbvCnpymean  -ASCII

% --- get Cnpy, oC ---
Cnpy =  Cnpy; % oC 
[Cnpysum,Cnpymean,TimeX] = integzBC1(dt(~isnan(Cnpy)),Cnpy(~isnan(Cnpy)),1:365,days); 
CnpyMean	=Cnpymean'; 
save 'C:\DATA\condensed\daily\Cnpy_DM.dat' CnpyMean   -ASCII

% --- get BlwCnpy, oC ---
BlwCnpy =  BlwCnpy; % oC 
[BlwCnpysum,BlwCnpymean,TimeX] = integzBC1(dt(~isnan(BlwCnpy)),BlwCnpy(~isnan(BlwCnpy)),1:365,days); 
BlwCnpyMean	=	BlwCnpymean'; 
save 'C:\DATA\condensed\daily\BlwCnpy_DM.dat' BlwCnpyMean   -ASCII


%% Plot and see the data

load 'C:\DATA\condensed\daily\AbvCnpy_DM.dat';
load 'C:\DATA\condensed\daily\Cnpy_DM.dat';
load 'C:\DATA\condensed\daily\BlwCnpy_DM.dat';


figure (5);
hold on;
plot (AbvCnpy_DM, 'r', 'linewidth',2);
plot (Cnpy_DM, 'b', 'linewidth',2);
plot (BlwCnpy_DM,'g', 'linewidth',2);
legend('AbvCnpy','Cnpy','Blwcnpy',1);
AXIS([214 365 -20 35]);
xlabel ('DOY');
ylabel ('Ambient Temperature (oC)');
title ('Ambient Temperature')

figure (6);
hold on;
plot (AbvCnpy_DM, 'r', 'linewidth',2);
plot (Cnpy_DM, 'b', 'linewidth',2);
plot (BlwCnpy_DM,'g', 'linewidth',2);
legend('AbvCnpy','Cnpy','Blwcnpy',1);
AXIS([0 365 -20 35]);
xlabel ('DOY');
ylabel ('Ambient Temperature (oC)');
title ('Ambient Temperature')

