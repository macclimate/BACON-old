function [Ci Ci_exp Ci_adj] = jjb_gap_cluster_index(data_in)

[starts len] = jjb_gapfinder(data_in);

Ci = NaN.*ones(size(data_in,2),1);
Ci_exp = NaN.*ones(size(data_in,2),1);
Ci_adj = NaN.*ones(size(data_in,2),1);

for i = 1:1:size(len,2)
    num_clusters = length(find(~isnan(len(:,i))));
    
    Ci(i,1) = 1 - ( (num_clusters - 1) ./ (size(data_in,1)./2 - 1) );
    
    %%% Proportion of data that is bad data:
    p_nan = length(find(isnan(data_in(:,i))))./ size(data_in,1);
    %%% Expected value of Ci (if gaps are random):
    Ci_exp(i,1) = 2.*p_nan.^2 - 2.*p_nan  + 1;
    %%% Adjusted Ci value:
    Ci_adj(i,1) = Ci(i,1)./Ci_exp(i,1);
        
end
