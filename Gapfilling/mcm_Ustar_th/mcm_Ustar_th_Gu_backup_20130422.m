function [Ustar_th f_out ttime] = mcm_Ustar_th_Gu(data, n,plot_flag)

if nargin == 1
    plot_flag = 1;
    n = 25;
elseif nargin == 2
    plot_flag = 1;
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
seas = [1 3; 4 6; 7 9; 10 12];
seas_labels = {'JFM'; 'AMJ'; 'JAS'; 'OND'};
data_in = struct;
plot_xticks = [];
ttime = [];
plot_labels = {};
u_th_list_outer = cell(year_end-year_start+1,length(seas));
yr_ctr = 1;
for year = year_start:1:year_end
    for i = 1:1:length(seas)
        tic
        data_in.Ustar = data.Ustar(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
        data_in.Ts5 = data.Ts5(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
        data_in.RE_flag = data.RE_flag(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
        data_in.NEEstd = data.NEEstd(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
        data_in.NEE = data.NEE(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2));
% %         if year == 2007 && i == 2
% %             pause
% %         end
        [u_th_low u_th_high u_th_list_outer{yr_ctr,i}] = Ustar_th_Gu(data_in,n);
        Ustar_th(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2),1)= u_th_low;
        clear u_th_low;
        plot_labels{end+1,1} = [num2str(year) '-' seas_labels{i,1}];
        plot_xticks(end+1,1) = find(data.Year == year & data.Month >= seas(i,1) & data.Month <= seas(i,2),1,'first');
    ttime(yr_ctr,i) = toc;
    end
    yr_ctr = yr_ctr + 1;
end

if plot_flag == 1
    %     clrs = jjb_get_plot_colors;
    f_out = figure(1);clf;
    plot(Ustar_th,'k-','LineWidth',2)
    ylabel('u_{*TH}', 'FontSize',16);
    try
    format_ticks(gca,plot_labels,[],plot_xticks+(plot_xticks(2)./2),[],90,[]);
    catch
    set(gca,'XTick',plot_xticks+(plot_xticks(2)./2),'XTickLabel',plot_labels);
    end
end
end

function [u_th_low u_th_high u_th_list_outer] = Ustar_th_Gu(data, n,plot_flag)
if nargin == 1
    plot_flag = 1;
    n = 25;
elseif nargin == 2
    plot_flag = 1;
end

%%
% Step 1: Initialization:
u_th_low_outer = 0;
u_th_high_outer = 999;
out_esc_flag = 0;
% u_th_outer_low_prev = 0;
% u_th_outer_high_prev = 999;
u_th_list_outer = [];
%%%%%%%%%% Outer loop starts here: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while out_esc_flag == 0
    u_th_list_outer(end+1,1:2) = [u_th_low_outer u_th_high_outer];
    
    %%%  Step 2: Perform check to see that median nighttime ustar is above u_th_low:
    [ust_med_flag ust_med] = median_ustar_check(data.Ustar,u_th_low_outer, data.RE_flag);
    %%% Index of useable data:
    ind_param = find(~isnan(data.NEE.*data.NEEstd.*data.Ts5.*ust_med_flag) & ...
        data.RE_flag==2 & data.Ustar > u_th_low_outer & data.Ustar < u_th_high_outer  );
    % NEE = data.NEE(ind_param);
    %%% Model this data with a Ts-related function
    clear global;
    options.costfun ='OLS'; options.min_method ='NM';
    [c_hat, y_hat, y_pred, ~, ~, ~, ~, ~] = ...
        fitresp([8 0.2 10], 'fitresp_2A', data.Ts5(ind_param), data.NEE(ind_param), data.Ts5, data.NEEstd(ind_param), options);
    ind_use = find(~isnan(data.NEE.*y_pred.*data.Ustar) & data.RE_flag == 2);   %inserted
    
    %%% Step 3: Normalize the measured values with the modeled values
    NEE_norm = data.NEE(ind_use)./y_pred(ind_use);          % changed ind_param to ind_use
    %%% Step 4: Outlier detection test (3 stdevs)
    std_NEE = nanstd(NEE_norm);
    NEE_norm(NEE_norm < ( 1-3.*std_NEE) | NEE_norm > (1+3.*std_NEE)) = NaN;
    %%% Step 5: Rank from low to high ustar:
    % First, make an index of the values that are still good -
    ind_ok = find(~isnan(NEE_norm));
    % These make our reference sample:
    NEE_ref = NEE_norm(ind_ok);
    Ustar_ref = data.Ustar(ind_use(ind_ok));  % changed ind_param to ind_use
    ust_med_ref = ust_med(ind_use(ind_ok));   % changed ind_param to ind_use
    % % sort the NEE and ustar data:
    % [Ustar_sort ind_sort] = sort(Ustar_ref);
    % NEE_sort = NEE_ref(ind_sort);
    
    in_esc_flag = 0;
    %     u_th_low_prev = u_th_low_outer;
    %     u_th_high_prev = u_th_high_outer;
    %         low_pt_ctr = 0;
    %         high_pt_ctr = length(find(Ustar_ref > u_th_low_inner & Ustar_ref < u_th_high_inner))+1;
    
    
    u_th_low_inner = 0;     % changed from = u_th_low_outer
    u_th_high_inner = 999;  % changed from = u_th_high_outer;
    u_th_list_inner = [];
    
    %% %%%%%%%%%%%%%%%%% Inner Loop: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while in_esc_flag == 0;
        u_th_list_inner(end+1,1:2) = [u_th_low_inner u_th_high_inner];
        % Filter out by u* threshold for settings in the inner loop:
        ind_uth2 = find(Ustar_ref > u_th_low_inner & Ustar_ref < u_th_high_inner & ust_med_ref > u_th_low_inner);
        % sort the NEE and ustar data:
        [Ustar_sort ind_sort] = sort(Ustar_ref(ind_uth2));
        NEE_sort = NEE_ref(ind_uth2(ind_sort),1);
        
        %%% Step 9: Moving sample index:
        %         ind_ms_low = (low_pt_ctr+1:1:low_pt_ctr+n)';
        %%% Steps 10-12: comparison of NEE in lower moving sample with reference value --
        %%% left-tail t-test:
        low_st_pt = 0;
        low_flag = 0;
        while low_flag == 0;
            [h_low p_low ci_low stats_low] = ttest2(NEE_sort(low_st_pt+1:low_st_pt+n),NEE_ref,0.1,'left','unequal');
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
            [h_high p_high ci_high stats_high] = ttest2(NEE_sort(high_st_pt-n:high_st_pt-1),NEE_ref,0.1,'right','unequal');
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
            u_th_low = NaN; u_th_high = NaN;
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
            if ~isempty(m1+m2)==1
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






