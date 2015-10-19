function [davg wavg mavg savg yavg] = jjb_time_averaging(data_in, scaling_factor, pts_per_day)
%%% jjb_time_averaging.m
%%% This function calculates the daily, weekly, monthly, seasonal and
%%% annual means of an inputted annual half-hourly datafile.
%%% inputs:
% data_in - column vector you wish to be averaged
% scaling_factor - conversion factor that may be necessary to change units
% (e.g. for umol CO2 to g C, it is 0.0216).
% pts_per_day - number of data points per day (daily data=1, hhourly=48)
%%% Revised Feb 11, 2011 by JJB.

if nargin == 1;
    scaling_factor = 1;
    pts_per_day = 48; % half-hourly is default
end

%%% Determine the number of days in the year from the length:
if length(data_in)/pts_per_day == 365
[days_in_m m_starts m_ends]= jjb_days_in_month(2003, pts_per_day);
elseif length(data_in)/pts_per_day == 366
[days_in_m m_starts m_ends]= jjb_days_in_month(2004, pts_per_day);
end
% days_in_month(:,1) = (cumsum([0; days_in_m(1:11)])+1).*pts_per_day - (pts_per_day-1);
% days_in_month(:,2) = [days_in_month(2:12,1)-1; length(data_in)];
% days_in_month = [days_in_month; length(data_in)];

% Step 1 - daily_averaging:
rs_d = reshape(data_in,pts_per_day,[]);
davg = (nanmean(rs_d,1))';
davg = davg.*scaling_factor;
clear rs_d

% Step 2 - Weekly averaging:
a = rem(length(data_in),(pts_per_day*7));
data_in_tmp = data_in(1:end-a);
rs_w = reshape(data_in_tmp,pts_per_day.*7,[]);
wavg = (nanmean(rs_w))';
wavg = wavg.*scaling_factor;

clear rs_m
% Step 3 - Monthly Averaging:
for i = 1:1:12
    mavg(i,1) = nanmean(data_in(m_starts(i,1):m_ends(i,1),1),1);
end
mavg = mavg.*scaling_factor;

% Step 4 - Seasonal Averaging
seas_starts = (1:91.25:300)';
seas_starts = round(seas_starts.*pts_per_day);
seas_ends = [seas_starts(2:4)-1; length(data_in)];
for i = 1:1:4
savg(i,1) = nanmean(data_in(seas_starts(i):seas_ends(i),1),1);
end
savg = savg*scaling_factor;
% Step 5 - Annual Mean:
yavg = nanmean(data_in(:,1)).*scaling_factor;