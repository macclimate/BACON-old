function y = monsum(t,x,id)
%this function calculates monthly average
%
%(C) Bill Chen									File created:  May. 10, 1999
%													Last modified: May. 10, 1990
%
% Input:  t  --- DOY
%			 x  --- daily average value
%			 id --- = 0 365 days (such 1994 1997)
%					  = 1	366 days (such 1996)

month_day = [31 28+id 31 30 31 30 31 31 30 31 30 31];
for k = 1:12
   st  = sum(month_day(1:(k-1)))+ 1;
   ed  = sum(month_day(1:k));
   ind = find(t >= st & t< ed+1);
   y(k)= sum(x(ind));
end
