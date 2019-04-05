function [pw_total] = jjb_make_rw_pw(data_meas, data_model, win_size, increment)


ind = (1:1:length(data_meas))';

pw_total = NaN.*ones(length(ind),1);

centres = (win_size+1:increment:length(ind)-win_size-1)';

for j = 1:1:length(centres)
    tmp_data_meas = data_meas(centres(j)-win_size:centres(j)+win_size,1);
    tmp_data_model = data_model(centres(j)-win_size:centres(j)+win_size,1);
    
% If at least 10 data points in the window are good, take average
    if numel(find(~isnan(tmp_data_meas.*tmp_data_model))) > 10 % currently 
        pw_total(centres(j),1) = nanmean(tmp_data_meas./tmp_data_model);
    else
        pw_total(centres(j),1) = NaN;
    end
    clear tmp*
end