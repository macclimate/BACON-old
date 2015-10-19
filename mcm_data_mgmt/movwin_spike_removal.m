function [ind_bad_tracker array_out] = movwin_spike_removal(array_in,stdev_mult,win_size, time_int)

if nargin == 2
    time_int = 30;
    win_size = 10;
elseif nargin == 3
    time_int = 30;
end
% Changes the window size from days to total number of data points 
% (Thus, the default window size is 480 data points.
win_size_days = win_size;
win_size = win_size*(1440./time_int);

data_in = [array_in(end-floor(win_size./2)+1:end); array_in; array_in(1:floor(win_size./2))];  
ind_orig = [zeros(length(array_in(end-floor(win_size./2)+1:end)),1); ....
    ones(length(array_in),1); zeros(length(array_in(1:floor(win_size./2))),1)];
thresh_low = NaN.*ones(length(data_in),1);
thresh_high = NaN.*ones(length(data_in),1);
for i = 0:win_size:length(data_in)-win_size
    data_rs = reshape(data_in(i+1:i+win_size),(1440./time_int),[]);
%     ens_mean = nanmean(data_rs,2);
    ens_med = nanmedian(data_rs,2);
    ens_std = nanstd(data_rs,0,2);
%     ens_numhh = sum(~isnan(data_rs),2);
    thresh_low(i+1:i+win_size,1) = repmat(ens_med-stdev_mult.*ens_std,win_size_days,1);
    thresh_high(i+1:i+win_size,1) = repmat(ens_med+stdev_mult.*ens_std,win_size_days,1);
end

thresh_low = thresh_low(ind_orig==1,1);
thresh_high = thresh_high(ind_orig==1,1);

array_out = array_in;
array_out(array_in > thresh_high) = NaN;
array_out(array_in < thresh_low) = NaN;

% Tracker:
ind_bad_tracker = ones(length(array_out),1);
ind_bad_tracker(array_in > thresh_high) = NaN;
ind_bad_tracker(array_in < thresh_low) = NaN;
