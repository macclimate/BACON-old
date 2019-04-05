function [start_dt] = OPEC_find_intervals(data_in, time_interval, smallest_gap)
% Set the smallest gap that determines a new period of measurement:
%%% 500 for 30 minute data, and scaled appropriately for other time
%%% intervals
if nargin ==1;
    time_interval = 30;
    smallest_gap = floor(500*(30/time_interval));
elseif nargin == 2;
    smallest_gap = floor(500*(30/time_interval));

end




% smallest_gap = floor(500*(30/time_interval));


ind = find(~isnan(data_in));
ind_p1 = [ind(2:length(ind)); NaN];
gaps = ind_p1 - ind;
new_starts = find(gaps > smallest_gap);


start_dt(:,1) = [NaN.*ones(length(new_starts)+1,1)];
start_dt(:,2) = [ind(new_starts); ind(end)];

for k = 2:1:length(start_dt);
   ind_t(k,1) = find(ind > start_dt(k-1,2),1,'first');
end
start_dt(:,1) = [ind(1); ind(ind_t(2:end))];
