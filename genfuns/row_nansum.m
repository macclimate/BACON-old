function [row_sum] = row_nansum(matrix_in)
%% row_nanmean.m
%%% Comments here about what the script (or function) does, what data has
%%% to be inputted and what is outputted.
%%% usage: row_sum = row_nansum(matrix_in)
%%% Created by JJB on Feb 24, 2008.

matrix_in_tr = matrix_in'; %% Transpose matrix

row_sum(:,1) = nansum(matrix_in_tr);