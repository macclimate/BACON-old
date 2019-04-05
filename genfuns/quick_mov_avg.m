function [out_x, out_y] = quick_mov_avg(data_in, win_size)

interval = floor(win_size./2);
ctr = 1;
for k = interval+1:interval:length(data_in)
    if k + interval <= length(data_in)  
    else
        interval = length(data_in)-k;
    end
        out_x(ctr,1) = k;
        out_y(ctr,1) = nanmedian(data_in(k-interval:k+interval,1));
ctr = ctr + 1;
end
    
    