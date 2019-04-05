function [Eo_interp] = Eo_interp_JJB(data, plot_flag)

if nargin == 1
    plot_flag = [];
end

if isempty(plot_flag)==1;
    plot_flag = 0;
%     fR = [];
end

Ts_in = data.Ts5; %%% Using 2cm soil temperature as temperature for regression.
%%%
RE_raw = NaN.*data.NEE;
xi = (1:1:length(RE_raw))';
ind_param.RE = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 15 ) |... % growing season
    ( data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)  ) );  % non-growing season
RE_raw(ind_param.RE,1) = data.NEE(ind_param.RE,1);
%     RE_filled = NaN.*ones(length(RE_raw),1);
options.min_method ='NM'; options.f_coeff = [];options.costfun = data.costfun;
win_size = round(12*48/2); % 12 days of hhours (divided by 2 to make one-sided)
incr = (2*48); % increment by 2 days
wrap_RE = [RE_raw(end-win_size+1:end,1); RE_raw; RE_raw(1:win_size,1)];
wrap_Ts = [Ts_in(end-win_size+1:end,1); Ts_in; Ts_in(1:win_size,1)];
wrap_ind = [xi(length(xi)-win_size+1:end,1); xi; xi(1:win_size,1)];
wrap_NEE_std = [data.NEE_std(end-win_size+1:end,1); data.NEE_std; data.NEE_std(1:win_size,1)];
centres = (win_size+1:incr:length(wrap_ind)-win_size)';
Eo_wrap = NaN.*ones(length(wrap_ind),2);
rRMSE_wrap = NaN.*ones(length(wrap_ind),2);
if centres(end) < length(wrap_RE)-win_size; centres = [centres; length(wrap_RE)-win_size]; end
%%%% Variables to use within loop:
c_hat_RE = NaN.*ones(length(centres),2);
stats_RE = NaN.*ones(length(centres),2);
rel_error_RE = NaN.*ones(length(centres),1);
num_pts = NaN.*ones(length(centres),1);

%%% Windowed Parameterization for Eo (Eo_short): %%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:1:length(centres)
    try
        RE_temp = wrap_RE(centres(i)-win_size:centres(i)+win_size);
        Ts_temp = wrap_Ts(centres(i)-win_size:centres(i)+win_size);
        NEE_std_temp = wrap_NEE_std(centres(i)-win_size:centres(i)+win_size);
        ind_use = find(~isnan(RE_temp.*NEE_std_temp));
        RE_use = RE_temp(ind_use);
        Ts_use = Ts_temp(ind_use);
        NEE_std_use = NEE_std_temp(ind_use);
        num_pts(i,1) = length(RE_use);
        if num_pts(i,1) < 10
            c_hat_RE(i,1:2) = NaN;
            stats_RE(i,1:2) = NaN;
            rel_error_RE(i,1) = NaN;
        elseif (max(Ts_use) - min(Ts_use)) < 5
            c_hat_RE(i,1:2) = NaN;
            stats_RE(i,1:2) = NaN;
            rel_error_RE(i,1) = NaN;
        else
            % Run parameterization, gather c_hat values:
            clear global;
            [c_hat_RE(i,:), y_hat(i).RE, y_pred(i).RE, stats(i).RE, sigma(i).RE, err(i).RE, exitflag(i).RE, num_iter(i).RE] = ...
                fitresp([10 100], 'fitresp_1C', Ts_use , RE_use, wrap_Ts(centres(i)-win_size:centres(i)+win_size),NEE_std_use, options);
            % gather stats:
            stats_RE(i,1:2) = [stats(i).RE.rRMSE stats(i).RE.MAE];
            rel_error_RE(i,1) = std(y_pred(i).RE)./nanmean(y_pred(i).RE);
            if c_hat_RE(i,2) > 75 && c_hat_RE(i,2) < 450 && stats_RE(i,1) < 0.65
                Eo_wrap(centres(i)-win_size:centres(i)+win_size, rem(i,2)+1) = c_hat_RE(i,2);
                rRMSE_wrap(centres(i)-win_size:centres(i)+win_size, rem(i,2)+1) = stats_RE(i,1);
            end
        end
        
    catch
        disp(i);
    end
    clear *_temp *_use;
end

%%%
%%% There will be occasions where we get 2 estimates of Eo for a given
%%% half-hour.  Resolve this by taking a weighted mean of the two values,
%%% inversely weighted by the value of rRMSE associated with the Eo
%%% measurement:
sum_rRMSE = nansum(rRMSE_wrap,2); sum_rRMSE(sum_rRMSE==0) = NaN;
rRMSE_weights = [rRMSE_wrap(:,2)./sum_rRMSE rRMSE_wrap(:,1)./sum_rRMSE ];
ind_r1 = find(rRMSE_weights(:,1) == 1);
ind_r2 = find(rRMSE_weights(:,2) == 1);
rRMSE_weights(ind_r1,1) = NaN; rRMSE_weights(ind_r1,2) = 1;
rRMSE_weights(ind_r2,2) = NaN; rRMSE_weights(ind_r2,1) = 1;
weighted_Eomean = nansum([Eo_wrap(:,1).*rRMSE_weights(:,1) Eo_wrap(:,2).*rRMSE_weights(:,2)],2 );
weighted_Eomean(weighted_Eomean == 0,1) = NaN;
Eo_mean = nanmean(Eo_wrap,2);

if plot_flag == 1;
    figure(5);clf
    plot(Eo_mean,'b');hold on;
    plot(weighted_Eomean,'r');
    legend('Un-weighted', 'rRMSE-weighted');
    clear sum_rRMSE rRMSE_weights ind_r*
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fill in gaps in Eo by using previous values for each of the windows:
% First, fill in what we can using previous data:
for i = 1:1:length(centres)
    %%% Find the last non-NAN number of Eo:
    last_good = weighted_Eomean(find(~isnan( weighted_Eomean(1:centres(i)-win_size,1) ) ,1, 'last'),1);
    if ~isempty(last_good)
        if ~isempty(find(isnan(weighted_Eomean(centres(i)-win_size:centres(i)+win_size)), 1))
            weighted_Eomean(centres(i)-win_size:centres(i)+win_size) = last_good;
        end
    end
    clear last_good;
end

for i = 1:1:length(centres)
    %%% Find the last non-NAN number of Eo:
    last_good = weighted_Eomean(find(~isnan( weighted_Eomean(1:centres(i)-win_size,1) ) ,1, 'last'),1);
    if isempty(last_good)
        % if it's empty, that means we have to take the last good at
        % the end of the year:
        last_good = weighted_Eomean(find(~isnan(weighted_Eomean),1,'last'),1);
    end
    if ~isempty(find(isnan(weighted_Eomean(centres(i)-win_size:centres(i)+win_size)), 1))
        weighted_Eomean(centres(i)-win_size:centres(i)+win_size) = last_good;
    else
    end
    clear last_good;
end

% Trim weighted_Eomean to the proper size:
Eo_weighted = weighted_Eomean(win_size+1:length(weighted_Eomean)-win_size,1);
clear weighted_Eomean;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 1a: All-year parametization for Eo (Eo_long):
RE_param = RE_raw(~isnan(RE_raw.*data.NEE_std));
Ts_param = Ts_in(~isnan(RE_raw.*data.NEE_std));
NEE_std_param = data.NEE_std(~isnan(RE_raw.*data.NEE_std));
% Run parameterization, gather c_hat values:
clear global;
[c_hat_RE_all, y_hat_RE_all, y_pred_RE_all, stats_RE_all, sigma_RE_all, err_RE_all, exitflag_RE_all, num_iter_RE_all] = ...
    fitresp([10 100], 'fitresp_1C', Ts_param , RE_param, Ts_in,NEE_std_param, options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot rRMSE vs rel error:
if plot_flag == 1;
    f3 = figure(3);clf;
    plot(rel_error_RE,stats_RE(:,1),'k.');
    ylabel('rRMSE'); xlabel('rel error')
    
    %%% Plot rel error, rRMSE vs Eo
    f4 = figure(4);clf;
    subplot(211)
    plot(rel_error_RE,c_hat_RE(:,2),'b.')
    title('relative error vs E_{0}');
    ylabel('E_{0}'); xlabel('rel error');
    axis([0 1.5 -200 1000 ]);
    subplot(212)
    plot(stats_RE(:,1),c_hat_RE(:,2),'g.')
    title('rRMSE vs E_{0}');
    ylabel('E_{0}'); xlabel('rRMSE');
    axis([0.2 1 -200 1000 ]);
end
%%%% Looking at this, it may be more suitable to use rRMSE cutoff of 0.65
%%%% (65%), instead of a relative error cutoff, since the relative error is
%%%% going to be directly determined by the value of Eo.

%%% Step 1b: Estimate Dynamic Eo:
%%% Filter out to use only good periods (Eo 50-450, rel error < %50)
% ind_use_Eo1 = find(c_hat_RE(:,2) > 50 & c_hat_RE(:,2) < 450 & rel_error_RE < 0.5);
ind_use_Eo = find(c_hat_RE(:,2) > 75 & c_hat_RE(:,2) < 500 & stats_RE(:,1) < 0.65);

Eo_use = c_hat_RE(ind_use_Eo,2);
centres_use = centres(ind_use_Eo,1);
%%% Interpolate Between good estimates of Eo:
Eo_interp = interp1(centres_use-win_size,Eo_use,xi);
%%% Fill in NaNs outside first and last data points:
early_nans = find(xi < xi(end)/2 & isnan(Eo_interp));
Eo_interp(early_nans, 1) = Eo_interp(find(~isnan(Eo_interp),1,'first'),1);
late_nans = find(xi >= xi(end)/2 & isnan(Eo_interp));
Eo_interp(late_nans, 1) = Eo_interp(find(~isnan(Eo_interp),1,'last'),1);

%%% Plot results for Eo:
if plot_flag == 1;
    f2 = figure(2);clf;
    ctr = 1;
    for year = year_start:1:year_end
        if year_start-year_end > 7
            subplot(5,2,ctr);
        else
            subplot(4,2,ctr);
        end
        plot([1 17568],[c_hat_RE_all(1,2) c_hat_RE_all(1,2)],'r--','LineWidth', 1.5); hold on;
        ind_st(ctr,1) = find(data.Year==year,1,'first');
        ind_end(ctr,1) = find(data.Year==year,1,'last');
        centres_tmp = centres_use(centres_use >= ind_st(ctr,1) & centres_use <= ind_end(ctr,1));
        Eo_tmp = Eo_use(centres_use >= ind_st(ctr,1) & centres_use <= ind_end(ctr,1));
        plot(centres_tmp-ind_st(ctr,1)+1,Eo_tmp,'.','Color',clrs(ctr,:));hold on;
        plot(xi(ind_st(ctr,1)-ind_st(ctr,1)+1:ind_end(ctr,1)-ind_st(ctr,1)+1,1),...
            Eo_weighted(ind_st(ctr,1):ind_end(ctr,1),1),'--','Color',clrs(ctr,:), 'LineWidth',2);
        h1(ctr,1) = plot(xi(ind_st(ctr,1)-ind_st(ctr,1)+1:ind_end(ctr,1)-ind_st(ctr,1)+1,1),...
            Eo_interp(ind_st(ctr,1):ind_end(ctr,1),1),'-','Color',clrs(ctr,:));
        title(num2str(year));
        ylabel('E_{0}');
        set(gca,'YTick', [0:100:500]);
        if ctr == 1
            title('E_{0} estimates - no VPD');
        end
        ctr = ctr+1;
    end
    % legend('boxoff')
    print('-dpdf',[fig_path 'LRC_noVPD_Eo_annual']);
    
    f1 = figure(1);clf;
    plot(centres_use,Eo_use(:,1),'go'); hold on;
    plot([xi(1) xi(end)],[c_hat_RE_all(1,2) c_hat_RE_all(1,2)],'c--','LineWidth', 1.5);
    plot(xi,Eo_interp, 'b-');
    plot(xi,Eo_weighted,'r-');
    title(['Years ' num2str(year_start) '-' num2str(year_end) ', E_{0} estimates - no VPD']);
    set(gca,'XTick', ind_st, 'XTickLabel', {year_start:1:year_end}, 'FontSize', 14);
    axis([1 xi(end) 50 450])
    legend('Obs E_{0}','Eo-annual','Inerp E_{0}','Weighted E_{0}',3,'Orientation','Horizontal');
    print('-dpdf',[fig_path 'LRC_noVPD_Eo_all']);
end