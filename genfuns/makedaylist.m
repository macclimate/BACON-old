function [day_list] = makedaylist(year)
%%% This function makes a string list of all days in a year that are used
%%% to load hhour files.

if ischar(year)
    yr_str = year;
    year = str2num(year);
else
    yr_str = num2str(year);
end

YY = yr_str(3:4);
[Mon Day] = make_Mon_Day(year, 1440);
if isleapyear(year) == 1; num_days = 366; else num_days = 365; end

for k = 1:1:num_days
    MM = create_label(Mon(k,1),2); DD = create_label(Day(k,1),2);
    day_list(k,:) = [YY MM DD];
    clear MM DD
end