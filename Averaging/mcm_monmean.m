function [mon_means] = mcm_monmean(data_in, year)
%% mcm_monmean.m
%%% This function takes hhourly data and calculates monthly means using the
%%% associated functions:
% jjb_days_in_month.m 
%%% isleapyear.m
%
% Ouput mon_means comprises 2 columns -- column 1 contains mean values,
% while column 2 contains nanmean values
% usage: [mon_means] = mcm_monmean(data_in, year)
% where data_in is a full year's column vector
% and year is the year from which the data came.

% Created Mar 11, 2009 by JJB
% Revision History:
%

[days] = jjb_days_in_month(year);
hhrs = days.*48; % converts days into half-hours

    st = 1;
for i = 1:1:length(days) % cycles from months 1 -- 12

    mon_means(i,1) = mean(data_in(st:st+hhrs(i)-1,1));
    mon_means(i,2) = nanmean(data_in(st:st+hhrs(i)-1,1));
    
    st = st + hhrs(i);
   
end


