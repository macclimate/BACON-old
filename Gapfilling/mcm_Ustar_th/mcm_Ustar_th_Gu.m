function [Ustar_th f_out diagn] = mcm_Ustar_th_Gu(data, n,plot_flag, num_bs)

if nargin == 1
    plot_flag = 1;
    n = 25;
    num_bs = 100;
elseif nargin == 2
    plot_flag = 1;
    num_bs = 100;
elseif nargin == 3
    num_bs = 100;
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
Ustar_th_seas = NaN.*ones(length(data.Year),1);
seas = [1 3; 4 6; 7 9; 10 12];
seas_labels = {'JFM'; 'AMJ'; 'JAS'; 'OND'};
data_in = struct;
plot_xticks = [];
ttime = [];
plot_labels = {};
u_th_list_outer = cell(year_end-year_start+1,length(seas));

Ustar_th = NaN.*ones(length(data.Year),4);

yr_ctr = 1;
for year = year_start:1:year_end
    for i = 1:1:length(seas)
        %       disp(['year = ' num2str(year) '; seas = ' num2str(i)]);
        % if year == 2007 && i == 1;
        %     disp('paused');
        % end
        ind = find(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
        %         [u_th_low u_th_high u_th_list_outer{yr_ctr,i}] = Ustar_th_Gu(data_in,n);
        out = bootstrp(num_bs,@Ustar_th_Gu,data.NEE(ind), data.NEEstd(ind),data.Ustar(ind), data.Ts5(ind), data.RE_flag(ind),n);
        
        % Restructure the output
        out_array = struct2array(out);
        % Replace 0s with NaNs
        tmp_out_array = (reshape(out_array,3,num_bs))';
        tmp_out_array(tmp_out_array(:,1)==0,1)=NaN;
        u_th_out(:,:,i) = tmp_out_array;
        %     u_th_out(:,:,i) = (reshape(out_array,3,num_bs))';
        
        clear out out_array;
        Ustar_th_seas(ind,1)= nanmean(u_th_out(:,1,i));
        %         clear u_th_low;
        %         plot_labels{end+1,1} = [num2str(year) '-' seas_labels{i,1}];
        %         plot_xticks(end+1,1) = find(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2),1,'first');
        %     ttime(yr_ctr,i) = toc;
    end
    
    %%% 1. Determine Annual Mean and 90% CI:
    %     for i = 1:1:num_bs
    % %         tmp = u_th_out(i,:,:);
    %         tmp = u_th_out(:,1,i);
    %         u_th_mean(i,1) = nanmean(tmp(:));
    %     end
    tmp = u_th_out(:,1,:);
    tmp(isinf(tmp)) = NaN;
    
    % Structure of seasonal data:
    % nrows = num_bs, [Seas mean|seas 5% (min)|seas 95% (max)]
    u_th_seas = [tmp(:,:,1) tmp(:,:,2) tmp(:,:,3) tmp(:,:,4)];
    u_th_mean_seas = (nanmean(u_th_seas,1))';
    pctiles = (prctile(u_th_seas,[5 95]))';
    u_th_mean_seas(:,2:3) = pctiles;
    
    % Structure of annual estimates:
    % nrows = num_bs, [Annual mean|ann 5% (min)|ann 95% (max)]
    u_th_mean = nanmean(u_th_seas,2);
    u_th_mean_annual = mean(u_th_mean);
    pctiles = prctile(u_th_mean,[5 95]);
    u_th_mean_annual(2:3) = pctiles;
    
    % Also output the median value
    u_th_median = nanmedian(u_th_seas,2); % Take the median of seasonal estimates
    u_th_median_annual = mean(u_th_mean); % But then take mean of all num_bs runs:
    pctiles = prctile(u_th_median,[5 95]);
    u_th_median_annual(2:3) = pctiles;
    
    % Also output the max value
    u_th_max = nanmax(u_th_seas,[],2); % Take the max of seasonal estimates
    u_th_max_annual = mean(u_th_mean); % But then take mean of all num_bs runs:
    pctiles = prctile(u_th_max,[5 95]);
    try
        u_th_max_annual(2:3) = pctiles;
    catch
        u_th_max_annual(2:3) = NaN;
    end
    % Output a Ustar_th vector, the same length as the input data:
    % [mean uth | 5% uth | 95% uth | savg uth]
    Ustar_th(data.Year==year,1:3) = repmat(u_th_mean_annual,length(find(data.Year==year)),1);
    
    %%% Put ancillary information into another variable:
    diagn.u_th_all{yr_ctr,1} = u_th_out;
    diagn.u_th_mean{yr_ctr,1} = u_th_mean;
    diagn.u_th_mean_annual{yr_ctr,1} = u_th_mean_annual;
    diagn.u_th_seas{yr_ctr,1} = u_th_seas;
    diagn.u_th_mean_seas{yr_ctr,1} = u_th_mean_seas;
    diagn.u_th_median{yr_ctr,1} = u_th_median;
    diagn.u_th_median_annual{yr_ctr,1} = u_th_median_annual;
    diagn.u_th_max{yr_ctr,1} = u_th_max;
    diagn.u_th_max_annual{yr_ctr,1} = u_th_max_annual;
    
    yr_ctr = yr_ctr + 1;
end
% Paste seasonal Ustar_th vector into Ustar_th:
Ustar_th(:,4) = Ustar_th_seas;


if plot_flag == 1
    clrs = jjb_get_plot_colors;
    f_out = figure(1);clf;
    ctr = 1;
    for year = year_start:1:year_end
        h1(ctr,1) = plot(data.dt(data.Year==year,1),Ustar_th(data.Year==year,1),'--',...
            'LineWidth',2,'Color',clrs(ctr,:));
        hold on;
        plot(data.dt(data.Year==year,1),Ustar_th(data.Year==year,4),'-','Color',clrs(ctr,:));
        ctr = ctr + 1;
    end
    ylabel('u^{*}_{TH}', 'FontSize',16)
    xlabel('DOY');
    legend(h1,num2str((year_start:1:year_end)'));
else f_out = 0;
end
% if plot_flag == 1
%     %     clrs = jjb_get_plot_colors;
%     f_out = figure(1);clf;
%     plot(Ustar_th,'k-','LineWidth',2)
%     ylabel('u_{*TH}', 'FontSize',16);
%     try
%     format_ticks(gca,plot_labels,[],plot_xticks+(plot_xticks(2)./2),[],90,[]);
%     catch
%     set(gca,'XTick',plot_xticks+(plot_xticks(2)./2),'XTickLabel',plot_labels);
%     end
% end
end

% function [u_th_low u_th_high u_th_list_outer] = Ustar_th_Gu(data, n,plot_flag)
% function [out] = Ustar_th_Gu(data, n,plot_flag)
function [out] = Ustar_th_Gu(NEE, NEEstd,Ustar, Ts5, RE_flag, n)

if nargin <6
    n = 25;
    % elseif nargin == 2
    %     plot_flag = 1;
end

%%
% Step 1: Initialization:
u_th_low_outer = min(Ustar(~isnan(Ustar.*NEE)));
u_th_high_outer = 999;
out_esc_flag = 0;
% u_th_outer_low_prev = 0;
% u_th_outer_high_prev = 999;
u_th_list_outer = [];
%%%%%%%%%% Outer loop starts here: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while out_esc_flag == 0
    u_th_list_outer(end+1,1:2) = [u_th_low_outer u_th_high_outer];
    
    try
        %%%  Step 2: Perform check to see that median nighttime ustar is above u_th_low:
        [ust_med_flag ust_med] = median_ustar_check(Ustar,u_th_low_outer, RE_flag);
        %%% Index of useable data:
        ind_param = find(~isnan(NEE.*NEEstd.*Ts5.*ust_med_flag) & ...
            RE_flag==2 & Ustar > u_th_low_outer & Ustar < u_th_high_outer  );
    catch
        disp('Not enough points for proper analysis - Aborting - Line 178');
        out.u_th_low = NaN;
        out.u_th_high = NaN;
        out.n_runs_outer = NaN;
        return
    end
    % NEE = NEE(ind_param);
    %%% Model this data with a Ts-related function
    clear global;
    options.costfun ='OLS'; options.min_method ='NM';
    [c_hat, y_hat, y_pred, ~, ~, ~, ~, ~] = ...
        fitresp([8 0.2 10], 'fitresp_2A', Ts5(ind_param), NEE(ind_param), Ts5, NEEstd(ind_param), options);
    ind_use = find(~isnan(NEE.*y_pred.*Ustar) & RE_flag == 2);   %inserted
    
    %%% Step 3: Normalize the measured values with the modeled values
    NEE_norm = NEE(ind_use)./y_pred(ind_use);          % changed ind_param to ind_use
    %%% Step 4: Outlier detection test (3 stdevs)
    std_NEE = nanstd(NEE_norm);
    NEE_norm(NEE_norm < ( 1-3.*std_NEE) | NEE_norm > (1+3.*std_NEE)) = NaN;
    %%% Step 5: Rank from low to high ustar:
    % First, make an index of the values that are still good -
    ind_ok = find(~isnan(NEE_norm));
    % These make our reference sample:
    NEE_ref = NEE_norm(ind_ok);
    Ustar_ref = Ustar(ind_use(ind_ok));  % changed ind_param to ind_use
    ust_med_ref = ust_med(ind_use(ind_ok));   % changed ind_param to ind_use
    % % sort the NEE and ustar data:
    % [Ustar_sort ind_sort] = sort(Ustar_ref);
    % NEE_sort = NEE_ref(ind_sort);
    
    in_esc_flag = 0;
    %     u_th_low_prev = u_th_low_outer;
    %     u_th_high_prev = u_th_high_outer;
    %         low_pt_ctr = 0;
    %         high_pt_ctr = length(find(Ustar_ref > u_th_low_inner & Ustar_ref < u_th_high_inner))+1;
    
    
    u_th_low_inner =  min(Ustar(~isnan(Ustar.*NEE)));     % changed from = u_th_low_outer
    u_th_high_inner = 999;  % changed from = u_th_high_outer;
    u_th_list_inner = [];
    
    %% %%%%%%%%%%%%%%%%% Inner Loop: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while in_esc_flag == 0;
        try
            u_th_list_inner(end+1,1:2) = [u_th_low_inner u_th_high_inner];
            % Filter out by u* threshold for settings in the inner loop:
            ind_uth2 = find(Ustar_ref > u_th_low_inner & Ustar_ref < u_th_high_inner & ust_med_ref > u_th_low_inner);
            % sort the NEE and ustar data:
            [Ustar_sort ind_sort] = sort(Ustar_ref(ind_uth2));
            NEE_sort = NEE_ref(ind_uth2(ind_sort),1);
        catch
            disp('Not enough points for proper analysis - Aborting - Line 222');
            out.u_th_low = NaN;
            out.u_th_high = NaN;
            out.n_runs_outer = NaN;
            return
        end
        %%% Step 9: Moving sample index:
        %         ind_ms_low = (low_pt_ctr+1:1:low_pt_ctr+n)';
        %%% Steps 10-12: comparison of NEE in lower moving sample with reference value --
        %%% left-tail t-test:
        low_st_pt = 0;
        low_flag = 0;
        while low_flag == 0;
            try
                [h_low p_low ci_low stats_low] = ttest2(NEE_sort(low_st_pt+1:low_st_pt+n),NEE_ref,0.1,'left','unequal');
            catch
                disp('Not enough points for proper analysis - Aborting - Line 238');
                out.u_th_low = NaN;
                out.u_th_high = NaN;
                out.n_runs_outer = NaN;
                return;
            end
            if low_st_pt >= length(NEE_sort)* (2/3)
                low_flag = 9;
            elseif h_low == 1 %&& low_st_pt < length(NEE_sort.* (2/3))
                low_st_pt = low_st_pt + 1;
                %             low_flag = 0;
            else
                if low_st_pt == 0
                    u_th_low_inner = u_th_list_inner(end,1);
                else
                    u_th_low_inner = median(Ustar_sort(low_st_pt+1:low_st_pt+n));
                end
                low_flag = 1;
            end
        end
        %%% Step 9: Moving sample index for high end:
        %         ind_ms_high = (high_pt_ctr-1:-1:high_pt_ctr-n)';
        %%% Steps 10-12: comparison of NEE in lower moving sample with reference value --
        %%% right-tail t-test:
        high_st_pt = length(NEE_sort)+1;
        high_flag = 0;
        while high_flag == 0;
            try
                [h_high p_high ci_high stats_high] = ttest2(NEE_sort(high_st_pt-n:high_st_pt-1),NEE_ref,0.1,'right','unequal');
            catch
                disp('Not enough points for proper analysis - Aborting - Line 268');
                out.u_th_low = NaN;
                out.u_th_high = NaN;
                out.n_runs_outer = NaN;
                return;
            end
            
            if high_st_pt <= length(NEE_sort)*(1/3)
                high_flag = 9;
            elseif h_high == 1 %&& high_st_pt > length(NEE_sort.* (1/3))
                high_st_pt = high_st_pt - 1;
                %             high_flag = 0;
            else
                if high_st_pt == length(NEE_sort)+1
                    u_th_high_inner = u_th_list_inner(end,2);
                else
                    u_th_high_inner = median(Ustar_sort(high_st_pt-n:high_st_pt-1));
                end
                high_flag = 1;
                
            end
        end
        
        
        %
        %         try
        %             h_high = ttest2(NEE_sort(end-n+1:end),NEE_ref,0.1,'right','unequal');
        %         catch
        %             pause;
        %         end
        %
        %         if h_high == 1
        %             %             high_pt_ctr = high_pt_ctr - 1;
        %             high_flag = 0;
        %         else
        %             if u_th_list_inner(end,1) == 999
        %                 u_th_high_inner = 999;
        %             else
        %                 u_th_high_inner = median(Ustar_sort(end-n+1:end));
        %             end
        %             high_flag = 1;
        %         end
        
        if high_flag==1 && low_flag ==1
            low_diff = u_th_low_inner - u_th_list_inner(end,1);
            high_diff = u_th_high_inner - u_th_list_inner(end,2);
            
            if abs(low_diff) < 0.0001 && abs(high_diff) < 0.0001
                in_esc_flag = 1;
                u_th_low_outer = u_th_low_inner;
                u_th_high_outer = u_th_high_inner;
            else
                in_esc_flag = 0;
                %                 u_th_high_prev = u_th_high_inner;
                %                 u_th_low_prev = u_th_low_inner;
            end
            %         elseif high_flag == 1 && low_flag == 0;
            %             %             u_th_high_prev = u_th_high_inner;
            %             NEE_sort = NEE_sort(2:end,1);
            %             Ustar_sort = Ustar_sort(2:end,1);
            %             in_esc_flag = 0;
            %         elseif low_flag == 1 && high_flag == 0;
            %             %             u_th_low_prev = u_th_low_inner;
            %             NEE_sort = NEE_sort(1:end-1,1);
            %             Ustar_sort = Ustar_sort(1:end-1,1);
            %             in_esc_flag = 0;
        else
            %             NEE_sort = NEE_sort(2:end-1,1);
            %             Ustar_sort = Ustar_sort(2:end-1,1);
            %             in_esc_flag = 0;
            disp(['No convergence: low_flag = ' num2str(low_flag) ', high flag = ' num2str(high_flag) '.'])
            out.u_th_low = NaN;
            out.u_th_high = NaN;
            out.n_runs_outer = NaN;
            return;
        end
    end
    %% Back to Outer Loop:
    %%% Check if the new values converge with the previous estimates:
    low_diff_outer = u_th_low_outer - u_th_list_outer(end,1);
    high_diff_outer = u_th_high_outer - u_th_list_outer(end,2);
    if abs(low_diff_outer) < 0.0001 && abs(high_diff_outer) < 0.0001
        out_esc_flag = 1;
        u_th_low = u_th_low_outer;
        u_th_high = u_th_high_outer;
    else
        %%% Check for a repeater pattern:
        if size(u_th_list_outer,1)>5
            list_round = jjb_round(u_th_list_outer,4);
            
            m1 = find((list_round(1:end,1) == jjb_round(u_th_low_outer,4)) & ...
                (list_round(1:end,2) == jjb_round(u_th_high_outer,4)));
            m2 = find((list_round(end,1) == list_round(1:end-1,1)) & ...
                (list_round(end,2) == list_round(1:end-1,2)));
            if ~isempty(m1)==1 && ~isempty(m2)==1
                out_esc_flag = 1;
                u_th_low = mean([u_th_low_outer; u_th_list_outer(end,1)],1);
                u_th_high = mean([u_th_high_outer; u_th_list_outer(end,2)],1);
            else
                out_esc_flag = 0;
            end
        else
            %         u_th_outer_low_prev = u_th_low_outer;
            %         u_th_outer_high_prev = u_th_high_outer;
            out_esc_flag = 0;
        end
    end
end
out.u_th_low = u_th_low;
out.u_th_high = u_th_high;
out.n_runs_outer = size(u_th_list_outer,2);
end

function [ust_med_flag ust_med3] = median_ustar_check(Ustar,u_th_low, REflag)
ust_med_flag = ones(length(Ustar),1);
%%% we want to use only times when RE_flag ==2
REflag2 = ones(length(REflag),1);
REflag2(REflag~=2) = NaN;
Ustar = Ustar.*REflag2;

ust_rs = reshape(Ustar,48,[]);
ust_med = nanmedian(ust_rs,1);
ust_med2 = repmat(ust_med,48,1);
ust_med3 = ust_med2(:);
ust_med_flag(ust_med3 < u_th_low) = NaN;
end






