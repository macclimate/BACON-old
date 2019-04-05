function [nan_sum] = nansum(data_in)
%% nansum.m
%%% This function calculates the sum of all non-NaN fields in a vector or matrix
%%% Created Sept 19, 2007 by JJB

%% Body of program

[rows cols] = size(data_in);
for i = 1:1:cols
nan_sum(1,i) = sum(data_in(~isnan(data_in(:,i)),i));
end
