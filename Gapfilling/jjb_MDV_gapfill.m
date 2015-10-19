function [y_filled] = jjb_MDV_gapfill(y, win_size, pts_day)
%% jjb_MDV_gapfill.m
%%% Fills gaps in a data set using a mean diurnal variation (MDV) approach,
%%% which averages values from corresponding 1/2hr periods for a specified
%%% period of days before and after
%%% y: The dependent variable looking to be filled
%%% win_size: The total, 2-sided size of the MDV window in days
%%%           e.g. Using 1/2hr data, a win_size value of 4 will average
%%%           values for 2 days (96pts) before, and 2 days (96) after the
%%%           point to be filled.
%%% pts_day: Specifies the number of points to make up a day (default = 48)
%%% Created Oct. 16, 2007 by JJB
%%
if nargin == 2
    pts_day = 48;
end
half_win_size = (win_size*pts_day)/2;
data_shifts = (half_win_size*-1:pts_day:half_win_size)';

%% Change length of y variable to add 1/2 window sized data to the front
%%% and back of it
y_plus(1:half_win_size,1) = NaN;
y_plus(half_win_size+1:length(y)+half_win_size,1) = y(1:length(y),1);
y_plus(length(y)+half_win_size+1:length(y)+(2*half_win_size),1) = NaN;

%%% Make a new variable to store calculated data
y_MDV = y_plus;

%%% Find where NaN values exist in the original data
ind = find(isnan(y_plus(half_win_size+1:length(y)+half_win_size)));
ind = ind +half_win_size;
%%% Take NaN mean of data at each corresponding 1/2hr

for j = 1:1:length(ind)
    y_MDV(ind(j)) =  nanmean(y_plus(ind(j)+data_shifts));
end
    
    
    
    y_filled = y_MDV(half_win_size+1:length(y_MDV)-half_win_size,1);
    
    
    