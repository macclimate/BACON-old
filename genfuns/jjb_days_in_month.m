function[days starts ends] = jjb_days_in_month(year,pts_per_day)
% this function takes the input of the year of interest, and outputs a
% column vector with the number of days in each month for that year.
% Created Feb 9, 2009 by JJB
% usage: [days] = jjb_in_month(year) where year is a scalar

if nargin == 1
    pts_per_day = 1;
end

if ischar(year)
    year = str2num(year);
end

leapflag = isleapyear(year,0);
len_yr = yr_length(year,1440/pts_per_day,0);

if leapflag==1
    days = [31 29 31 30 31 30 31 31 30 31 30 31]';
else
    days = [31 28 31 30 31 30 31 31 30 31 30 31]';
end
days = days*pts_per_day;

starts = (cumsum([0; days(1:11)])+1);
ends = [starts(2:12,1)-1; len_yr];

