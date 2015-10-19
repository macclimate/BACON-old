function [SM_est] = SM_estimate(SM)
SM_est = SM;

ind_nan = find(isnan(SM_est));

for i = 1:1:length(ind_nan)
    if ind_nan(i)>1
    SM_est(ind_nan(i),1) = SM_est(ind_nan(i)-1,1);
    end
end