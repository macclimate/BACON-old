function [HH MM] = make_HH_MM(year, time_int)
% usage: [Mon Day] = make_Mon_Day(year, time_int)

[junk, junk, HHMM, junk] = jjb_makedate(year, time_int);

HH = floor(HHMM./100);

HHMM_str = num2str(HHMM);
MM = str2num(HHMM_str(:,3:4));

