function [HH, MM] = make_HH_MM(year, time_int,format_flag)
% usage: [Mon Day] = make_Mon_Day(year, time_int)
% format_flag = 1: last output for a given day has HHMM of 2400 of same day
% format_flag = 2: last output for a given day has HHMM of 0000 of next day

if nargin < 3
    format_flag = 1;
end
[junk, junk, HHMM, junk] = jjb_makedate(year, time_int,format_flag);

HH = floor(HHMM./100);

HHMM_str = num2str(HHMM);
MM = str2num(HHMM_str(:,3:4));

