%This script is designed to take the daily average of PPT
%%%%Created on February 26, 2009%%%%


% --- get time ---
days = 1;

%%%%%%%%%%%%% 2003 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- get time vector ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX = dt;

%To load data%

PPT= load('C:/DATA/metdata 2008/TP39_2008.038');

JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');

% --- get PPT ---
PPT =  PPT; % mm
[PPTsum,PPTmean,TimeX] = integzBC1(dt(~isnan(PPT)),PPT(~isnan(PPT)),1:365,days); 
PPTsum	=	PPTsum'; 
save 'C:\DATA\condensed\daily\PPT_DM.dat'  PPTsum   -ASCII

%% Plot and see the data
y =zeros(365,1);

load 'C:\DATA\condensed\daily\PPT_DM.dat';

figure (1);
clf;
handles = barweb(PPT_DM, PPTsum, [], [], [], [], [], [gray], [], []);
legend('PPT',1);
AXIS([214 365 0 60]);
xlabel 'DOY';
ylabel 'Precipitation(mm)';
title 'Precipitation 2008'

figure (2);
hold on;
bar(PPT_DM);
legend('PPT',1);
AXIS([214 365 0 60]);
xlabel 'DOY';
ylabel 'Precipitation(mm)';
title 'Precipitation for August through December 2008'

