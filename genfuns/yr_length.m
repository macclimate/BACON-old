function [numpts] = yr_length(year, interval, verbose_flag)
% Outputs the number of points in a year based on the inputted interval (in
% minutes).  Default interval is 30 mintues (if no interval is specified)
if nargin == 1;
    interval = 30;
    verbose_flag = 0;
elseif nargin == 2;
    verbose_flag = 0;
end

mult = 1440/interval;
numpts = 0;

for j = 1:1:length(year)

if isleapyear(year(j),verbose_flag) == 1;
    numpts_tmp = 366.*mult;
else
    numpts_tmp = 365.*mult;
end
numpts = numpts+numpts_tmp;
clear numpts_tmp;
end