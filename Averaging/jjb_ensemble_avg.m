function [ens_avg ens_std ens_med] = jjb_ensemble_avg(data_in, time_int, days_output)
%%% This function 
%%% Input must be made in even-days
%%% 

%%% Written by JJB, Oct-9, 2009.
%%% booyah. Oh yeah.
if nargin == 2;
   flag = 0;
else
    flag = 1;
end

pts_per_day = 1440./time_int;

ens = reshape(data_in,pts_per_day,[]);
ens = ens';
[rows cols] = size(ens);

ens_avg = NaN.*ones(cols,1);
ens_std = NaN.*ones(cols,1);
ens_med = NaN.*ones(cols,1);

for i = 1:1:cols
ens_avg(i,1) = nanmean(ens(:,i));
ens_std(i,1) = nanstd(ens(:,i));
ens_med(i,1) = nanmedian(ens(:,i));
end

%%% This part repeats the average for a given number of days:
if flag == 1;
     ens_avg_mult = ens_avg;
     ens_std_mult = ens_std;
     ens_med_mult = ens_med;
    for j = 2:1:days_output
ens_avg_mult = [ens_avg_mult; ens_avg];
ens_std_mult =[ens_std_mult ; ens_std];
ens_med_mult = [ens_med_mult; ens_med];
    end
    ens_avg = ens_avg_mult;
    ens_std = ens_std_mult;
    ens_med = ens_med_mult;
end