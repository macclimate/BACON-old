function [mon_sum mon_mean] = jjb_month_stats(year,data_in)
%% This function calculates both monthly sums and means for the inputted
%% variable of choice using half-hourly data.
%%% INPUTS:
%%% year - the year for averaging

if isnumeric(year)
else
    year = str2double(year);
end

if length(data_in) == 365 || length(data_in) == 366;
[junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(year,1440);
disp('I see you are using daily data -- interesting... for a pansy!');
day_mult = 1;
elseif length(data_in) == 17520 || length(data_in) == 17568;
[junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(year,30);
disp('Half-hourly data?  Only losers do not use 20Hz data!');
day_mult = 48;
end

if length(dt) == 17568 || length(dt) == 366;
    month_days = [31 29 31 30 31 30 31 31 30 31 30 31]'.*day_mult;
    ends = cumsum(month_days);
else
    month_days = [31 28 31 30 31 30 31 31 30 31 30 31]'.*day_mult;
    ends = cumsum(month_days);
end

start = 1;

for k = 1:12
    mon_sum(k,1) = nansum(data_in(start:ends(k),1));
    mon_mean(k,1) = nanmean(data_in(start:ends(k),1));
    
    start = start + month_days(k);
end

