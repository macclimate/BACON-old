function [Mon, Day] = make_Mon_Day(year, time_int, format_flag)
% usage: [Mon Day] = make_Mon_Day(year, time_int)
% format_flag = 1: last output for a given day has DD,MM of same day (i.e.
% 2400)
% format_flag = 2: last output for a given day has DD,MM of next day (i.e.
% 0000)


if nargin < 3
    format_flag = 1;
end
[Year, JD, HHMM, dt] = jjb_makedate(year, time_int, format_flag);

dt = (round(dt.*1000))./1000;

 [days] = jjb_days_in_month(year);
 
 days_cum =[0 ;cumsum(days(1:11))];
 

 for k = 1:1:length(dt)
     Mon(k,1) = find(dt(k) >= days_cum+1,1,'last');
     Day(k,1) = floor(dt(k)) - days_cum(Mon(k,1));
 end
 if time_int == 1440
       Day = [1; Day(1:length(Day)-1)];
        Mon = [Mon(1); Mon(1:length(Mon)-1)];
  
 else
      Day = [Day(1); Day(1:length(Day)-1)];
   Mon = [Mon(1); Mon(1:length(Mon)-1)];
 end
 
 % Convert to format 2, if required
 if format_flag ==2
     Mon = [Mon(2:end);1];
     Day = [Day(2:end);1];
 end
 
% if dt(2) == dt(1)
%     ind = find(dt==dt(1));
%     increment = 1./ind;
%     for j = 1:increment:length(dt);
        