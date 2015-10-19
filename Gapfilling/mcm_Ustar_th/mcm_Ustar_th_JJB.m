function [Ustar_th f_out] = mcm_Ustar_th_JJB(data, plot_flag,window_mode)

if nargin == 1
    plot_flag = 1;
    window_mode = 'biweekly';
elseif nargin == 2
    window_mode = 'biweekly';    
end

if isempty(window_mode)==1
    window_mode = 'biweekly';
end

switch window_mode
    case 'seas' 
        win_size = 90*48;
        centres(:,1) = (45*48:win_size:17520);
        
%         seasons = [1 3; 4 6; 7 9; 10 12]; % Starting and ending months for seasons
    case 'monthly'
%         seasons = (1:1:12)';
        win_size = 30*48;
        centres(:,1) = (15*48:win_size:17520);

    case 'biweekly'
        win_size = 16*48;
        centres(:,1) = (10*48:win_size:17520);
        
end

if isfield(data,'year_start')==1
year_start = data.year_start;
year_end = data.year_end;
else
    year_start = min(data.Year);
    year_end = max(data.Year);
    disp('No field for year_start and year_end.');
    disp(['Using year_start = ' num2str(year_start) ', and year_end = ' num2str(year_end)]);
end
Ustar_th = NaN.*ones(length(data.Year),1);

%% Part 1: Establish the appropriate u* threshold:
%%% 1 Reichstein, 2005 approach, but calculated for different intervals:
ctr = 1;
data.recnum = NaN.*ones(length(data.PAR),1);
% win_size = 16*48;
% centres(:,1) = (10*48:16*48:17520);
for year = year_start:1:year_end
    data.recnum(data.Year == year) = 1:1:yr_length(year,30);
    dt_ctr = 1;
    for dt_centres = 1:1:length(centres)%:win_size:yr_length(year,30,0)%seas = 1:1:4
        
        ind_bot = max(1,centres(dt_centres)-win_size);
        ind_top = min(centres(dt_centres)+win_size,yr_length(year,30,0));
        ind = find(data.Year == year & data.recnum >= ind_bot & data.recnum <= ind_top);
%         out = Reichsten_uth(data.NEE(ind), data.Ts5(ind),
%         data.Ustar(ind), data.RE_flag(ind));
%         biweek_u_th(dt_ctr,ctr) = out.final_u_th;
          [u_th_est biweek_u_th(dt_ctr,ctr)] = JJB_uth(data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
%         [u_th_est biweek_u_th(dt_ctr,ctr)] = Reichsten_uth(data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
        dt_ctr = dt_ctr+1;
    end
    ctr = ctr+1;
end

%%% Average for each data window over all years (using median or mean):
Ustar_th_all = nanmedian(biweek_u_th,2);
Ustar_th_all2 = nanmean(biweek_u_th,2);
ctr = 1;
L = '';
for year = year_start:1:year_end
%%% interpolate between points:
% step 1: interpolate out to the ends:
use_pts = (1:1:(yr_length(year,30)-centres(end))+(centres(1)))';
ust_fill = [Ustar_th_all2(end); Ustar_th_all2(1)];
x = [1; use_pts(end)];
ust_interp = interp1(x,ust_fill,use_pts);
centres_tmp = [1; centres; yr_length(year,30)];
Ustar_th_all_tmp = [ust_interp(yr_length(year,30)-centres(end)+1); Ustar_th_all2; ust_interp(yr_length(year,30)-centres(end))];
Ustar_th_interp = interp1(centres_tmp,Ustar_th_all_tmp,(1:1:yr_length(year,30))');
Ustar_th(data.Year == year,1) = Ustar_th_interp;
ctr = ctr+1;
clear centres_tmp Ustar_th_all_tmp Ustar_th_interp ust_interp x ust_fill use_pts;
L = [L '''' num2str(year) '''' ','];
end
L = [L '''' 'Median' '''' ',' '''' 'Mean' ''''];

if plot_flag == 1
    clrs = jjb_get_plot_colors;
   f_out = figure(1);clf; 
   for k = 1:1:ctr-1
       h1(k) = plot(centres,biweek_u_th(:,k),'.-','Color',clrs(k,:));hold on;
   end
   h1(k+1) = plot(centres,Ustar_th_all,'-','LineWidth',5,'Color',[0.5 0.5 0.5]); hold on;
   h1(k+2) = plot(centres,Ustar_th_all2,'-','LineWidth',5,'Color',[1 0 0.5]); hold on;
   eval(['legend(h1,' L ')']);
%    legend(h1,'2003','2004','2005','2006','2007','2008','2009','Median','Mean')
   ylabel('u^{*}', 'FontSize',16)
   set(gca, 'FontSize',14);
%    print('-dpdf',[fig_path 'u*_th']);
% close all;
end
end
function [u_th_est final_u_th] = JJB_uth(Fc, T, Ustar, RE_flag)
%%% Reichsten_uth.m
%%% usage: [u_th_est final_u_th] = Reichsten_uth(Fc, T, Ustar, RE_flag)
%%% This function performs the u* threshold determination scheme proposed
%%% by Reichstein (2005).  This function works in the following manner:
%%% 1. Data is used only for periods when respiration is the only exchange
%%% occuring (nighttime or daytime non-growing-season)
%%% 2. Data is sorted into 6 Temperature quantiles
%%% 3. Data in each T quantile is sorted into 20 u* classes
%%% 4. Mean Fc in each u* class is calculated.
%%% 5. u*_th is determined as the lowest u* class where the Mean Fc value
%%% is equal to 99% (or 95%) of the mean of the higher classes' Fc.
%%% 6. Provided that the correlation between T and u* are low for the given
%%% T class, the suggested u*_th is accepted.
%%% 7. The final u*_th estimate is the median of all accepted u*_th for the
%%% T classes.
%%%

T = T(RE_flag ==1);
Fc = Fc(RE_flag ==1);
Ustar = Ustar(RE_flag ==1);

%% Step 1: Sort data into T Quantiles and then u* quantiles
[T_sort1 ind_sort1] = sort(T, 'ascend');
Fc_sort1 = Fc(ind_sort1); Ustar_sort1 = Ustar(ind_sort1);

%%% Separate data into 6 quantiles:
[quant_index1] = jjb_quantile_index(length(T_sort1), 6);

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
    
    
    %%% Correlation coefficient for T and u* (Use later):
    try
        T_ust_corr(q1,1) = corr(T_sort1_use,Ustar_sort1_use);
    catch
        T_ust_corr(q1,1) = NaN;
    end
    
    %%% Sort Ustar within each Temperature quantile
    [Ustar_sort2 ind_sort2] = sort(Ustar_sort1_use, 'ascend');
    [quant_index2] = jjb_quantile_index(length(Ustar_sort2), 20);
    
    T_sort2 = T_sort1_use(ind_sort2);
    Fc_sort2 = Fc_sort1_use(ind_sort2);
    
    %%% Cycle through the u* quantiles for each T quantile
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
end

%% Step 2: Criteria for selecting appropriate u*_th:

good_rows = zeros(size(Fc_mean,1),1);
for tclass = 1:1:size(Fc_mean,1)
    
    for uclass = 1:1:size(Fc_mean,2)-1
        Fc_ratio(tclass,uclass) = Fc_mean(tclass,uclass)./(mean(Fc_mean(tclass, uclass+1:end)));
    end
    
    right_col = find(Fc_ratio(tclass,:)>=0.99, 1,'first');
    if isempty(right_col)
        u_th_est(tclass,1) = inf; %Ustar_mean(tclass,size(Fc_mean,2));
        good_rows(tclass,1) = -1;
    elseif T_ust_corr(tclass,1) > 0.4 || isnan(T_ust_corr(tclass,1))==1
        u_th_est(tclass,1) = NaN;
        good_rows(tclass,1) = 0;
    else
        u_th_est(tclass,1) = Ustar_mean(tclass, right_col);
        good_rows(tclass,1) = 1;
    end
end

final_u_th = median(u_th_est(good_rows==1,1));
if length(find(good_rows==1)) < 2
    disp(['Reichstein_uth.m --> Warning: u*_{TH} estimated from ' num2str(length(find(good_rows==1))) ' of a possible ' num2str(size(Fc_mean,1)) ' T classes.']);
end
end