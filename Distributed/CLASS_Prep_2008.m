% CLASS_Prep_2008.m

% Altaf needs the following data in tab-delimited ASCII double format:
% Year
% Day
% hour
% min
% SWdown (W/m2)
% LWdown (W/m2)
% Precipitation (mm/h-hour)
% Tair (C)
% Windspeed (m/s)
% Pressure (kPa)
% Specific Humidity (kg/kg)
clear all; close all;
ls = addpath_loadstart;
year = 2008;
s_num = year - 2002;

% Most of these files should be available through the TP39.mat file:
load([ls 'Matlab/Data/Data_Analysis/rEC/TP39.mat']);
data1 = load([ls 'Matlab/Data/Met/Organized2/TP39/HH_Files/TP39_HH_2008.mat']);
data2 = load([ls 'Matlab/Data/Met/Organized2/TP39/HH_Files/TP39_HH_2009.mat']);
TP_PPT = load([ls 'Matlab/Data/Met/Final_Filled/TP_PPT/TP_PPT_2008.dat']);

% need to shift data points
% met master columns:
% % SWdown (W/m2) - col 20
% LWdown (W/m2) - col 24
% Precipitation (mm/h-hour) - cols 17, 38


% TP39(6).Month = TP39(2).Month;
% TP39(6).Day = TP39(2).Day;
% TP39(6).Hour = TP39(2).Hour;
% TP39(6).Minute = TP39(2).Minute;
% save([ls 'Matlab/Data/Data_Analysis/rEC/TP39.mat'],'TP39');
CLASS_out(:,1) = TP39(s_num).Year;
CLASS_out(:,2) = floor(TP39(s_num).dt - 1/50);
CLASS_out(:,3) = TP39(s_num).Hour;
CLASS_out(:,4) = TP39(s_num).Minute;

CLASS_out(:,8) = [TP39(s_num).Ta(9:end,1) ; data2.master_30min.data(1:8,7)];
CLASS_out(:,9) = [TP39(s_num).WS(9:end,1) ; data2.master_30min.data(1:8,13)];
CLASS_out(:,10) = [TP39(s_num).APR(9:end,1) ; data2.master_30min.data(1:8,84)];
RH = [TP39(s_num).RH(9:end,1) ; data2.master_30min.data(1:8,10)];
PAR = [TP39(s_num).PAR(9:end,1) ; data2.master_30min.data(1:8,15)];
%%% Calculate specific humidity (q):
CLASS_out(:,11) = RH_to_SpecHum(CLASS_out(:,8), RH, CLASS_out(:,10));

%%% SW down
SWdown = data1.master_30min.data(:,20);
% SW_shift = jjb_timeshifter(SWdown,8);

SW_check = find(isnan(SWdown));
% Fill SW data if needed by linear regression with PAR:
if ~isempty(SW_check)
    [SWdown_filled SW_model] = jjb_WLR_gapfill(PAR, SWdown, 5000);
end
CLASS_out(:,5) = SWdown_filled;
%
%%% LW down
LWdown = data1.master_30min.data(:,24);
% LW_shift = jjb_timeshifter(LWdown,8);
LW_check = find(isnan(LWdown));
if ~isempty(LW_check)
    [LWdown_filled] = jjb_MDV_gapfill(LWdown, 10, 48);
end

CLASS_out(:,6) = LWdown_filled;

figure(2);clf;
plot(LWdown_filled,'b'); hold on;
plot(LWdown,'r');

%%% Precipitation
TP_PPT_check = find(isnan(TP_PPT));
if ~isempty(TP_PPT_check);
    disp('NaNs in TP_PPT data -- fix this' );
end

CLASS_out(:,7) = TP_PPT;

% save([ls 'Matlab/Data/Distributed/TP39_CLASS_input_2008_UTC.dat'],'CLASS_out','-ASCII','-DOUBLE');
save([ls 'Matlab/Data/Distributed/TP39_CLASS_input_2008_EDT.dat'],'CLASS_out','-ASCII','-DOUBLE');

