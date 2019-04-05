function [row_std] = row_nanstd(matrix_in)
%% row_nanmean.m
%%% Comments here about what the script (or function) does, what data has
%%% to be inputted and what is outputted.
%%% usage: row_mean = row_nanmean(matrix_in)
%%% Created by JJB on Feb 24, 2008.

matrix_in_tr = matrix_in'; %% Transpose matrix

row_std(:,1) = nanstd(matrix_in_tr);
