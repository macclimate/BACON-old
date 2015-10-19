function [Mon Day] = make_Mon_Day(year, time_int)
% usage: [Mon Day] = make_Mon_Day(year, time_int)

[Year, JD, HHMM, dt] = jjb_makedate(year, time_int);

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
 
% if dt(2) == dt(1)
%     ind = find(dt==dt(1));
%     increment = 1./ind;
%     for j = 1:increment:length(dt);
        