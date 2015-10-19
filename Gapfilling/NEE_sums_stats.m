function [varargout] = NEE_sums_stats(NEE_sim, NEE_cleaned, year_list)
%%% This function calculates annual sums and important annual statistics
%%% for NEE(or RE or GEP) data.
%%% Created September 21, 2010 by JJB
%%% usage: [year sums RMSE BE R2] = NEE_sums_stats(NEE_sim, NEE_cleaned, year_list)
%%%    OR: data_out = NEE_sums_stats(NEE_sim, NEE_cleaned, year_list),
%%%    where data_out is simply a matrix of all output argumets shown above

year_start = min(year_list);
year_end = max(year_list);
year = [];
ctr = 1;
for yr = year_start:1:year_end
    
     sums(ctr,1) = sum(NEE_sim(year_list == yr),1).*0.0216;
    
    [RMSE(ctr,1) rRMSE(ctr,1) MAE(ctr,1) BE(ctr,1) R2(ctr,1)] = ...
        model_stats(NEE_sim(year_list==yr), NEE_cleaned((year_list==yr)), []);
    
    year = [year ; yr];
    ctr = ctr + 1;
end


%% Prepares the output in the desired format
data_out = [year sums RMSE BE R2];

if nargout == 1
    varargout = {data_out};
elseif nargout > 1
    for i = 1:1:nargout
    varargout{i} = data_out(:,i);
    end
end