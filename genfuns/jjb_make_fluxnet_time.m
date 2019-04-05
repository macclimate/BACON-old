function [ts_start, ts_end] = jjb_make_fluxnet_time(years_in, time_int)
% Created by JJB

if nargin < 2; time_int = 30; end
% Generates a starting timestamp and an ending timestamp
[year_start, year_end] = jjb_checkyear(years_in);

YYYY = []; MM = []; DD = []; hh = []; mm = [];

for i = year_start:1:year_end
    %         TV = [TV; make_tv(i,30)];
    YYYY = [YYYY; [i.*ones(yr_length(i,time_int)-1,1);i+1]];
    
    [Mon_tmp, Day_tmp] = make_Mon_Day(i,time_int,2);
    MM = [MM; Mon_tmp]; DD = [DD; Day_tmp];
    
    [HH_tmp, MM_tmp] = make_HH_MM(i,time_int,2);
    hh = [hh; HH_tmp]; mm = [mm; MM_tmp];
    
    clear *_tmp
end

ts_start = [[(hh(1).*1e2)+(DD(1).*1e4)+(MM(1).*1e6)+(YYYY(1).*1e8)];...
    [mm+(hh.*1e2)+(DD.*1e4)+(MM.*1e6)+(YYYY.*1e8)]];
ts_end = ts_start(2:end);
ts_start = ts_start(1:end-1);