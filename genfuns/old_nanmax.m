%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% nanmax.m
%%% Calculates the max of an array, discluding any values that aren't
%%% finite numbers
%%% Created Oct 28, 2007 by JJB
%%% usage [nanmax] = nanmax(input_array)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nmax] = nanmax(array_in)

[rows cols] = size(array_in);
nmax = NaN.*ones(1,cols);

for i = 1:1:cols
indfin = isfinite(array_in(:,i))==1;
nmax(1,i) = max(array_in(indfin,i));
end
