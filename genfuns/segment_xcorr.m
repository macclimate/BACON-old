function [output_final] = segment_xcorr(x, y, num_lags)

%%% Step 1: Find Continuous segments in each timeseries:
start_ind = 1;
end_ind = 0;
output = [];

xy = x.*y;

for i = 1:1:length(xy)
    
    if ~isnan(xy(i)); end_ind = end_ind+1;
        if i == length(xy)
            num_pts = end_ind - start_ind + 1;
            output = [output; start_ind end_ind num_pts];
            
        end
    else
        %        end_ind = max(end_ind, start_ind);
        num_pts = end_ind - start_ind + 1;
        output = [output; start_ind end_ind num_pts];
        start_ind = i+1;
        end_ind = i;

    end
    
end

ind = find(output(:,3)>=num_lags.*2.5);
output = [output NaN.*ones(size(output,1),1)];
ccorr = []; lags = [];

for j = 1:1:length(ind)
        clear *_tmp;

        [ccorr_tmp lags_tmp] = xcorr(x(output(ind(j),1):output(ind(j),2)), y(output(ind(j),1):output(ind(j),2)), num_lags);
        lags = [lags lags_tmp'];
        ccorr = [ccorr ccorr_tmp];
        ccorr(:,j) = ccorr(:,j)./(max(ccorr(:,j)));
output(ind(j),4) = lags(ccorr(:,j) == 1,j);
end

output_final = output(~isnan(output(:,4)),:);

% disp('end');
