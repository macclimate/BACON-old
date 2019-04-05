function [output] = jjb_mov_window_stats(x_in, y_in, increment, win_size)
% jjb_mov_window_stats.m
% This function will calculate average stats, std, median for a dataset
% with a moving window of desired increment and window size.
% usage: out = jjb_mov_window_stats(x_in, y_in, increment, win_size)
% Where:
% x_in is the data to move the window through
% y_in is the data you want average/stdev/median calculated for at each
% interval
% increment: how far to move the window each time
% win_size: The size of window on each side of increment to include data
%
% Output:
% Column 1 - Centre of window for x
% Column 2 - mean of y for window
% 3 - median " " " 
% 4 - stdev """
% 5 - number of points used in relationship
% Created Feb 19, 2010 by JJB
%
%

% Revision History:
%
%
%

min_x = min(x_in);
max_x = max(x_in);

centres = (min_x : increment : max_x)';

for j = 1:1:length(centres)
    % set top and bottom
    if centres(j) - win_size < min_x
        bot = min_x;
    else
        bot = centres(j) - win_size;
    end
    if centres(j) + win_size > max_x
        top = max_x;
    else
        top = centres(j) + win_size;
    end
    %%% Find where x falls in between intervals
    ind = find(x_in >= bot & x_in < top & ~isnan(x_in) & ~isnan(y_in));
    x_out(j,1) = centres(j);
    y_out(j,1:4) = [mean(y_in(ind)) median(y_in(ind)) std(y_in(ind)) length(ind)];
    clear bot top ind
end
    output = [x_out y_out];
