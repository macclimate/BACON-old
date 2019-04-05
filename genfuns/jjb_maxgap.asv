function [max_gap] = jjb_maxgap(x)
%% jjb_maxgap.m
%%% This function finds the largest continuous gap in a dataset.
ctr = 1;
gap_len(1) = 1;
ind_nan = find(isnan(x));
for i = 2:1:length(ind_nan)
    if ind_nan(i)-1 == ind_nan(i-1)
        gap_len(ctr) = gap_len(ctr)+1;
    else
        gap_len(ctr) = gap_len(ctr);
        ctr = ctr+1;
        gap_len(ctr) = 1;
    end
end

max_gap = max(gap_len);


