function [starts len gaplist] = jjb_gapfinder(x, gap_type)
%% jjb_gapfinder.m
%%% This function is used to find all gaps within a dataset.
% 'gap_type' refers to whether the gaps are represented as zeros or NaNs,
% or other...
if nargin==1
    gap_type = NaN;
end

starts = NaN.*ones(size(x,1), size(x,2));
len = starts;
gaplist = starts;

for i = 1:1:size(x,2)
    
    if isnan(gap_type) == 1;
        ind_nan = find(isnan(x(:,i)));
    else
        ind_nan = find(x(:,i)==gap_type);
    end
    gaplist(1:length(ind_nan),i) = ind_nan;
    ctr = 1;
    for j = 1:1:length(ind_nan)
        if j == 1
            starts(ctr,i) = ind_nan(j,1);
            len(ctr,i) = 1;
        else
            if ind_nan(j,1)-ind_nan(j-1,1)== 1
                len(ctr,i) = len(ctr,i) + 1;
            else
                ctr = ctr+1;
                starts(ctr,i) = ind_nan(j,1);
                len(ctr,i) = 1;
            end
        end
    end
    
    len_nans(i,1) = ctr;
    
    clear ind_nan;
    
    
end
% disp('done');
%%% Trim starts and len
starts = starts(1:max(len_nans),:);
len = len(1:max(len_nans),:);

