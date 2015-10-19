function [master] = mcm_Gapfill_MDS_Reichstein(data, ind_param_th, plot_flag)
%%% This function fills NEE data using the Euroflux standard
%%% protocols, using the MDS approach, as outlined by Reichstein, 2005.  
%%% Created in its current form by JJB, Oct 22, 2010.
%%% usage: [master] = mcm_Gapfill_MDS(data, Ustar_th, plot_flag)
if plot_flag == 1;
%%% Pre-defined variables, mostly for plotting:
test_Ts = (-10:2:26)';
test_PAR = (0:200:2400)';
clrs = [1 0 0; 0.5 0 0; 0 1 0; 0.8 0.5 0.7; 0 0 1; 0.2 0.1 0.1; ...
    1 1 0; 0.4 0.5 0.1; 1 0 1; 0.9 0.9 0.4; 0 1 1; 0.4 0.8 0.1];
% test_VPD = (0:0.2:3)';
% test_SM = (0.045:0.005:0.10)';
end

year_start = data.year_start;
year_end = data.year_end;
%% Part 1: Establish the appropriate u* threshold:
%%% 1a: The Reichstein, 2005 approach:
seas = [1 3; 4 6; 7 9; 10 12]; % Starting and ending months for seasons
ctr = 1;
for year = year_start:1:year_end

    for seas = 1:1:4
    ind = find(data.Year == year & data.Month >= seas(ctr,1) & data.Month <= seas(ctr, 2));
    
    
    end
    
    
    ctr = ctr+1;
end


end

function [] = Reichsten_uth(Fc, T, Ustar)
[T_sort1 ind_sort1] = sort(T, 'ascend');
Fc_sort1 = Fc(ind_sort1); Ustar_sort1 = Ustar(ind_sort1);

%%% Separate data into 6 quantiles:
[quant_index1] = jjb_quantile_index(length(T_sort1), 6);

%%% Cycle through the T quanties
for q1 = 1:1:length(quant_index1)
    ind_st = quant_index1(q1,1);
    ind_end = quant_index1(q1,2);
    %%% Sort Ustar within each Temperature quantile
    [Ustar_sort2 ind_sort2] = sort(Ustar_sort1(ind_st:ind_end), 'ascend');
    [quant_index2] = jjb_quantile_index(length(Ustar_sort2), 20);
    
    %%% Cycle through the u* quantiles for each T quantile
    for q2 = 1:1:length(quant_index2)
        ind_st2 = quant_index2(q2,1);
        ind_end2 = quant_index2(q2,2);
        %%%% Average Tempature:
        if isempty(Ustar(ind_sort1(ind_sort2),1))== 1; Ustar_mean(q1,q2) = NaN;
        else Ustar_mean(q1,q2) = nanmean(Ustar(ind_sort1(ind_sort2),1)); end
        %%%% Average u*
        if isempty(Ustar(ind_sort1(ind_sort2),1))== 1; Ustar_mean(q1,q2) = NaN;
        else Ustar_mean(q1,q2) = nanmean(Ustar(ind_sort1(ind_sort2),1)); end
        %%%% Average Fc
        if isempty(Fc(ind_sort1(ind_sort2),1))== 1; Fc_mean(q1,q2) = NaN;
        else Fc_mean(q1,q2) = nanmean(Fc(ind_sort1(ind_sort2),1)); end
    end
    
    
    
end
end