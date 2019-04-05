function [pred_y] = jjb_log_normalize(x_in, y_in)
%%% This function performs a log transform of data, outputting the slope
%%% and intercept, as well as the predicted values for y. The argument
%%% 'shift_flag' allows negative data to be shifted upwards by its minimum
%%% for negative data
% usage: [] = jjb_log_normalize(x_in, y_in, )
if min(x_in) < 0;
    x_shift = abs(min(x_in)) +0.01;
else
    x_shift = 0;
end
    x_in_s = x_in + x_shift;
    
if min(y_in) < 0;
        y_shift = abs(min(y_in)) +0.01;
else
    y_shift = 0;
end
    y_in_s = y_in + y_shift;

    %%%
    
lnx = log(x_in_s); lny = log(y_in_s);

ind_xy = find(~isnan(x_in_s.*y_in_s));

p_xy = polyfit(lnx(ind_xy), lny(ind_xy),1);

pred_lny = polyval(p_xy,lnx);

pred_y = exp(pred_lny) - y_shift;

figure(99);clf;
plot(x_in,y_in,'b.');hold on;
plot(x_in, pred_y,'g.');
end
