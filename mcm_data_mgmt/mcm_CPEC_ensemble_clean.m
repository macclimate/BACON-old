function [array_out up_thresh down_thresh] = mcm_CPEC_ensemble_clean(array_in, sdev_mult, win_size, time_int)
%%% win_size is in days
%%% time_int is time interval between data points (in minutes)
%%% sdev_mult is the multiplier for standard deviation to determine outlier
% Right now, the cleaner uses median instead of mean as an indicator of
% central tendency.
% usage: [array_out] = junk_OPEC_ensembleclean(array_in, sdev_mult, win_size, time_int)
%
%

if nargin == 3;
    time_int = 30;
end

pts_per_day = 1440./time_int;
num_days = win_size;
win_size = win_size*(1440./time_int);
offset = pts_per_day.*floor(win_size/(2*pts_per_day));

ens_avg(1:length(array_in),1) = NaN;
ens_med(1:length(array_in),1) = NaN;
ens_std(1:length(array_in),1) = NaN;
ens_avg2(1:length(array_in),1) = NaN;
ens_med2(1:length(array_in),1) = NaN;
ens_std2(1:length(array_in),1) = NaN;
ens_avgf(1:length(array_in),1) = NaN;
ens_medf(1:length(array_in),1) = NaN;
ens_stdf(1:length(array_in),1) = NaN;

ctr = 1;

for i = 1:win_size:length(array_in)-1 
 if ctr > 1 
     if length(array_in) - i >= offset
  [ens_avg2(i-offset:i+(win_size)-1-offset,1) ens_std2(i-offset:i-offset+(win_size)-1,1) ens_med2(i-offset:i-offset+(win_size)-1,1)] = ...
      jjb_ensemble_avg(array_in(i-offset:i-offset+(win_size)-1,1), time_int, num_days);
     else
  [ens_avg2(i-offset:length(ens_avg2),1) ens_std2(i-offset:length(ens_avg2),1) ens_med2(i-offset:length(ens_avg2),1)] = ...
      jjb_ensemble_avg(array_in(i-offset:end,1), time_int, length(array_in(i-offset:end))./(1440./time_int));       
     end
 end
 
    if length(array_in) - i >= win_size     
[ens_avg(i:i+(win_size)-1,1) ens_std(i:i+(win_size)-1,1) ens_med(i:i+(win_size)-1,1)] = ...
    jjb_ensemble_avg(array_in(i:i+(win_size)-1,1), time_int, num_days);
    else
[ens_avg(i:end,1) ens_std(i:end,1) ens_med(i:end,1)] = ...
    jjb_ensemble_avg(array_in(i:end,1), time_int, length(array_in(i:end))./(1440./time_int));
    end
ctr = ctr+1;
end

%%% Makes ensemble averages that are an average from overlapping windows:
ens_avgf(~isnan(ens_avg) & ~isnan(ens_avg2),1) = (ens_avg(~isnan(ens_avg) & ~isnan(ens_avg2)) + ens_avg2(~isnan(ens_avg) & ~isnan(ens_avg2)))./2;
ens_medf(~isnan(ens_med) & ~isnan(ens_med2),1) = (ens_med(~isnan(ens_med) & ~isnan(ens_med2)) + ens_med2(~isnan(ens_med) & ~isnan(ens_med2)))./2;
ens_stdf(~isnan(ens_std) & ~isnan(ens_std2),1) = (ens_std(~isnan(ens_std) & ~isnan(ens_std2)) + ens_std2(~isnan(ens_std) & ~isnan(ens_std2)))./2;

ens_avgf(isnan(ens_avgf) & ~isnan(ens_avg),1) = ens_avg(isnan(ens_avgf) & ~isnan(ens_avg));
ens_avgf(isnan(ens_avgf) & ~isnan(ens_avg2),1) = ens_avg2(isnan(ens_avgf) & ~isnan(ens_avg2));
ens_medf(isnan(ens_medf) & ~isnan(ens_med),1) = ens_med(isnan(ens_medf) & ~isnan(ens_med));
ens_medf(isnan(ens_medf) & ~isnan(ens_med2),1) = ens_med2(isnan(ens_medf) & ~isnan(ens_med2));
ens_stdf(isnan(ens_stdf) & ~isnan(ens_std),1) = ens_std(isnan(ens_stdf) & ~isnan(ens_std));
ens_stdf(isnan(ens_stdf) & ~isnan(ens_std2),1) = ens_std2(isnan(ens_stdf) & ~isnan(ens_std2));


up_thresh = ens_medf + ens_stdf*sdev_mult;
down_thresh = ens_medf - ens_stdf*sdev_mult;

array_out = array_in;
array_out(array_in > up_thresh | array_in < down_thresh) = NaN;