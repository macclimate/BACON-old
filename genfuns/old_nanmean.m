%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% nanmean.m
%%% Calculates the mean of an array, discluding any values that aren't
%%% finite numbers
%%% Created July 05, 2007 by JJB
%%% usage [nanmean] = nanmean(input_array)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nmean] = nanmean(array_in)

[rows cols] = size(array_in);

for i = 1:1:cols
indfin = find(isfinite(array_in(:,i))==1);
nmean(1,i) = mean(array_in(indfin,i));
end
