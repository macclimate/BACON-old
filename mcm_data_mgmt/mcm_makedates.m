function [TV Year dt Mon Day HH MM ] = mcm_makedates(year, time_int)
if ischar(year)
    year = str2num(year);
end

if nargin == 1
    time_int = 30
end

[HH MM] = make_HH_MM(year, time_int);
[Year, junk, junk, dt] = jjb_makedate(year, time_int);
[Mon Day] = make_Mon_Day(year, time_int);
[TV] = make_tv(year,time_int);

end