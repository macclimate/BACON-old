function [] = mcm_movwin_find_shift(x_in, y_in, window_size, increment)

% if nargin < 3
%     wi
%     
%     
% end

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
    ind = find(x_in >= bot & x_in < top);
    
    x_out(j,1) = centres(j);
    y_out(j,1:4) = [mean(y_in(ind)) median(y_in(ind)) std(y_in(ind)) length(ind)];
    clear bot top ind
end
    output = [x_out y_out];
