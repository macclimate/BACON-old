function [day_avg nan_list] = daily_sum(data, freq)
% This is a very simple function that takes the daily sum of a data set
% that is inputted into it.  It assumes data points divide equally into all days  
% usage [day_avg] = daily_sum(data, freq) where data is input data and freq
% is the number of measurements a day (e.g. hhourly is 48)
% NOTE - data must be a single column vector:
% Created Jan 30, 2009 by JJB




% first step: Check the length of the input file.
[rows cols] = size(data);
if  cols > 1 && rows > 1
    disp ('input file can only be a single column variable')
    finish
elseif cols > rows
    data = data';
end



remainder = rem(length(data),freq);
if  remainder == 0
else
data = [data; NaN.*ones(freq-remainder)];
end

data_rs = reshape(data,freq,[]);

for j = 1:1:length(data)./freq;
    
    num_nans = find(isnan(data_rs(:,j)));
    nan_list(j,1) = length(num_nans);
    clear num_nans;
end

day_avg = nansum(data_rs);
day_avg = day_avg';