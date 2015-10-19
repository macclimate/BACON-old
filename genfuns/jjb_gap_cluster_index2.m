function [Ci Ci_exp Ci_adj] = jjb_gap_cluster_index2(data_in)
%%%%%%%%% for Ci:
%%% value of 1 = completely dispersed
%%% value of 0 = completely clumped:
%%%%%%%%% for Ci_adj
%%% value of 2 = completely dispersed
%%% value pf 1 = completely random
%%% value of 0 = completely clumped:


[starts len] = jjb_gapfinder(data_in);

Ci = NaN.*ones(size(data_in,2),1);
Ci_exp = NaN.*ones(size(data_in,2),1);
Ci_adj = NaN.*ones(size(data_in,2),1);

for i = 1:1:size(len,2)
    ind = find(~isnan(len(:,i)));
    dists = len(ind,i)+1;
    
    Ci(i,1) = (sum(dists)-1)./sum(len(ind,i)) - 1;    
    %%% Proportion of data that is good data:
    p_nan = 1 - (sum(len(ind,i))./ size(data_in,1));    
    
%     Ci(i,1) = 1 - ( (num_clusters - 1) ./ (size(data_in,1)./2 - 1) );
%     
    %%% Expected value of Ci (if gaps are random):
    Ci_exp(i,1) = p_nan;
    %%% Adjusted Ci value:
    Ci_adj(i,1) = Ci(i,1)./Ci_exp(i,1);
        clear dists ind;
end
