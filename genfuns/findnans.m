function [nans num_nans] = findnans(vars_out)
%% Run a loop to see where and if there are gaps in the data:


[rows cols] = size(vars_out);

for k = 1:1:cols
    nans(k).ind = find(isnan(vars_out(:,k)));
    num_nans(1,k) = length(nans(k).ind);
end