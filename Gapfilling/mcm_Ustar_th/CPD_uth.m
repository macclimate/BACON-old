function [out] = CPD_uth(Fc, T, Ustar, RE_flag)
%%% CPD_uth.m
% removed from output: final_u_th dt_mean;
%%% usage: [u_th_est final_u_th] = CPD_uth(Fc, T, Ustar, RE_flag)
%%% This function performs the u* threshold determination scheme proposed
%%% by Barr(2013).  This function works in the following manner:
%%% 1. Data is used only for periods when respiration is the only exchange
%%% occuring (nighttime or daytime non-growing-season)
%%% 2. Data is sorted into 4 Temperature quantiles
%%% 3. Data in each T quantile is sorted into 50+ u* classes
%%% 4. Mean Fc in each u* class is calculated.
%%% 5. A change-point detection method is used to determine the change
%%%     point in the u* vs. Fc relationship for each u* bin.
%%% 6. The final seasonal u*_th estimate is acheived by fitting a sine
%%%     function to the data.
%%% 7. The final annual u*_th estimate is the mean of all accepted u*_th
%%%     for the T classes.
Fc_orig = Fc;
% dt = dt(RE_flag==2 & ~isnan(Fc_orig));
T = T(RE_flag ==2 & ~isnan(Fc_orig));
Fc = Fc(RE_flag ==2 & ~isnan(Fc_orig));
Ustar = Ustar(RE_flag ==2 & ~isnan(Fc_orig));

% dt_mean = mean(dt);

if length(Fc) <600
%     u_th_est(1:4)=NaN; final_u_th= NaN;
    disp('Length of Fc < 600. Aborting this run');
    out.u_th_est= NaN.*ones(4,1);
    out.p_out = NaN.*ones(4,1);
    return;  
elseif length(Fc)>=600 && length(Fc)<800
    num_strata = 30;
elseif length(Fc)>=800 && length(Fc)<1000
    num_strata = 40;
else
    num_strata = 50;
end        
%% Step 1: Sort data into T Quantiles and then u* quantiles
[T_sort1 ind_sort1] = sort(T, 'ascend');
Fc_sort1 = Fc(ind_sort1); Ustar_sort1 = Ustar(ind_sort1);

%%% Separate data into 4 temperature quantiles:
[quant_index1] = jjb_quantile_index(length(T_sort1), 4);

%%% Cycle through the T quantiles
for q1 = 1:1:length(quant_index1)
    ind_st = quant_index1(q1,1);
    ind_end = quant_index1(q1,2);
    
    Ustar_sort1_tmp = Ustar_sort1(ind_st:ind_end,1);
    Ustar_sort1_use = Ustar_sort1_tmp(~isnan(Ustar_sort1_tmp),1);
    T_sort1_tmp = T_sort1(ind_st:ind_end,1);
    T_sort1_use = T_sort1_tmp(~isnan(Ustar_sort1_tmp),1);
    Fc_sort1_tmp = Fc_sort1(ind_st:ind_end,1);
    Fc_sort1_use = Fc_sort1_tmp(~isnan(Ustar_sort1_tmp),1);
    
    
    %     %%% Correlation coefficient for T and u* (Use later):
    %     try
    %         T_ust_corr(q1,1) = corr(T_sort1_use,Ustar_sort1_use);
    %     catch
    %         T_ust_corr(q1,1) = NaN;
    %     end
    
    %%% Sort Ustar within each Temperature quantile
    [Ustar_sort2 ind_sort2] = sort(Ustar_sort1_use, 'ascend');
    [quant_index2] = jjb_quantile_index(length(Ustar_sort2), num_strata);
    
    T_sort2 = T_sort1_use(ind_sort2);
    Fc_sort2 = Fc_sort1_use(ind_sort2);
    
    %%%% Go through each u* bin, make averages:
    for q2 = 1:1:length(quant_index2)
        ind_st2 = quant_index2(q2,1);
        ind_end2 = quant_index2(q2,2);
        %%%% Average Tempature:
        if isempty(T_sort2(ind_st2:ind_end2,1))== 1; T_mean(q1,q2) = NaN;
        else T_mean(q1,q2) = nanmedian(T_sort2(ind_st2:ind_end2,1)); end
        %%%% Average u*
        if isempty(Ustar_sort2(ind_st2:ind_end2,1))== 1; Ustar_mean(q1,q2) = NaN;
        else Ustar_mean(q1,q2) = nanmedian(Ustar_sort2(ind_st2:ind_end2,1)); end
        %%%% Average Fc
        if isempty(Fc_sort2(ind_st2:ind_end2,1))== 1; Fc_mean(q1,q2) = NaN;
        else Fc_mean(q1,q2) = nanmedian(Fc_sort2(ind_st2:ind_end2,1)); end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Fit a linear model to data between 1 and c
    % Need to specify: n, n_b
    n_b = 3; % These are assumed based on Wang2003-JC
    Fmax50_percentiles = {90, 5.303; 95, 6.876; 99, 10.664};
    % ctr = 1; % use ctr or just start at 2 and make dummy NaN first entries?
    % x will be the u* bin centres.  y will be the mean NEE value at each bin centre.
    % n is the number of bins
    n = size(quant_index2,1);
    p = NaN.*ones(n,2);
    y_hat = NaN.*ones(n);
    SSE2b = NaN.*ones(n,1);
    SSE1b = NaN.*ones(n,1);
    Fscore = NaN.*ones(n,1);
    x = Ustar_mean(q1,1:end)';
    y = Fc_mean(q1,1:end)';
    for c = 2:1:(n-1)
        p(c,:) = polyfit(x(1:c,1),y(1:c,1),1);
        y_hat(1:c,c) = p(c,2) + p(c,1).*x(1:c,1);
        y_hat(c:end,c) = p(c,2) + p(c,1).*x(c,1);
        SSE2b(c,1) = sum((y(:,1)-mean(y_hat(:,c))).^2);
        SSE1b(c,1) = sum((y(1:c,1)-p(c,2)-(p(c,1).*x(1:c,1))).^2) ...
            + sum((y(c:end,1)-p(c,2)-(p(c,1).*x(c,1))).^2);
        %     Fscore_tmp = (SSE2b(c,1)-SSE1b(c,1))./( SSE1b(c,1) ./ (n-n_b));
        
        Fscore(c,1) = (SSE2b(c,1)-SSE1b(c,1))./( SSE1b(c,1) ./ (n-n_b));
        %     ctr = ctr + 1;
    end
    Fscore(isinf(Fscore)) = NaN;
    if nanmax(Fscore) > Fmax50_percentiles{2,2}
        ind_max = Fscore == nanmax(Fscore);
        Fscore_max(q1,1) = nanmax(Fscore);
        u_th_est(q1,1) = Ustar_mean(ind_max);
        p_out(q1,1) = p(ind_max,1);
    else
        Fscore_max(q1,1) = NaN;
        u_th_est(q1,1) = NaN;
        p_out(q1,1) = NaN;
    end
end

% final_u_th = nanmean(u_th_est);
out.u_th_est= u_th_est;
out.p_out = p_out;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 2: Quality Control
% 2a 

%%% Cycle through the u* quantiles for each T quantile


%% Step 2: Criteria for selecting appropriate u*_th:

% good_rows = zeros(size(Fc_mean,1),1);
% for tclass = 1:1:size(Fc_mean,1)
%
%     for uclass = 1:1:size(Fc_mean,2)-1
%         Fc_ratio(tclass,uclass) = Fc_mean(tclass,uclass)./(mean(Fc_mean(tclass, uclass+1:end)));
%     end
%
%     right_col = find(Fc_ratio(tclass,:)>=0.99, 1,'first');
%     if isempty(right_col)
%         u_th_est(tclass,1) = inf; %Ustar_mean(tclass,size(Fc_mean,2));
%         good_rows(tclass,1) = -1;
%     elseif T_ust_corr(tclass,1) > 0.4 || isnan(T_ust_corr(tclass,1))==1
%         u_th_est(tclass,1) = NaN;
%         good_rows(tclass,1) = 0;
%     else
%         u_th_est(tclass,1) = Ustar_mean(tclass, right_col);
%         good_rows(tclass,1) = 1;
%     end
% end
%
% final_u_th = median(u_th_est(good_rows==1,1));
% if length(find(good_rows==1)) < 2
%     disp(['Reichstein_uth.m --> Warning: u*_{TH} estimated from ' num2str(length(find(good_rows==1))) ' of a possible ' num2str(size(Fc_mean,1)) ' T classes.']);
% end
end