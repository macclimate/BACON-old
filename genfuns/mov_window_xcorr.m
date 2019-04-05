function [output] = mov_window_xcorr(x, y, num_lags,win_size,increment)
if nargin ==3
win_size = 200;
increment = 20;
end

output = [];
centres = (win_size+1 : increment : length(x)-win_size)';
xy = x.*y;
for j = 1:1:length(centres)
    clear *_tmp;

    x_tmp = x(centres(j)-win_size: centres(j)+win_size);
    y_tmp = y(centres(j)-win_size: centres(j)+win_size);
    xy_tmp = xy(centres(j)-win_size: centres(j)+win_size);
    
    if length(find(~isnan(xy_tmp))) > 0.95*2*win_size; % need 95% of data to make it work
        x_tmp(isnan(x_tmp),1) = 0;        y_tmp(isnan(y_tmp),1) = 0;
        [ccorr_tmp lags_tmp] = xcorr_JB(x_tmp, y_tmp, num_lags);
        max_ccorr_tmp = max(ccorr_tmp);
%         lags = [lags lags_tmp'];
%         ccorr = [ccorr ccorr_tmp];
        ccorr_tmp = ccorr_tmp./(max(ccorr_tmp));
        pts_to_shift_tmp = lags_tmp(1,ccorr_tmp == 1);
        output = [output ; centres(j) pts_to_shift_tmp max_ccorr_tmp];
    else
        output = [output ; NaN.*ones(1,3)];
    end
end




%
%     output = [x_out y_out];
%
%
%
%
% %%% Step 1: Find Continuous segments in each timeseries:
% start_ind = 1;
% end_ind = 0;
% output = [];
%
% xy = x.*y;
%
% for i = 1:1:length(xy)
%
%     if ~isnan(xy(i)); end_ind = end_ind+1;
%         if i == length(xy)
%             num_pts = end_ind - start_ind + 1;
%             output = [output; start_ind end_ind num_pts];
%
%         end
%     else
%         %        end_ind = max(end_ind, start_ind);
%         num_pts = end_ind - start_ind + 1;
%         output = [output; start_ind end_ind num_pts];
%         start_ind = i+1;
%         end_ind = i;
%
%     end
%
% end
%
% ind = find(output(:,3)>=num_lags.*2.5);
% output = [output NaN.*ones(size(output,1),1)];
% ccorr = []; lags = [];
%
% for j = 1:1:length(ind)
%         clear *_tmp;
%
%         [ccorr_tmp lags_tmp] = xcorr(x(output(ind(j),1):output(ind(j),2)), y(output(ind(j),1):output(ind(j),2)), num_lags);
%         lags = [lags lags_tmp'];
%         ccorr = [ccorr ccorr_tmp];
%         ccorr(:,j) = ccorr(:,j)./(max(ccorr(:,j)));
% output(ind(j),4) = lags(ccorr(:,j) == 1,j);
% end
%
% output_final = output(~isnan(output(:,4)),:);
