function [final_out f_out] = mcm_Gapfill_ANN_JJB1(data, plot_flag, debug_flag)
%%% This function performs gap-filling using an ANN design.
%%% Ustar threshold determination may either be static, or dynamic.
%%% The function first separates RE-only data (no GEP), and derives an
%%% estimate for ecosystem respiration
%%% The function then estimates NEE using a similar approach.
%%% Created in its current form, Nov 4, 2010 by JJB.

if nargin == 1;
    plot_flag = 1;
    debug_flag = 0;
elseif nargin == 2
    debug_flag = 0;
end
%%%%%%%%
warning off all
%%%%%%%%
if plot_flag == 1;
    ls = addpath_loadstart;
    fig_path = [ls 'Matlab/Figs/Gapfilling/ANN_JJB1/' data.site '/'];
    jjb_check_dirs(fig_path);    
    %%% Pre-defined variables, mostly for plotting:
%     test_Ts = (-10:2:26)';
%     test_PAR = (0:200:2400)';
    [clrs clr_guide] = jjb_get_plot_colors;
end

year_start = data.year_start;
year_end = data.year_end;
data.REW = VWC_to_REW(data.SM_a_filled, 0.3, 0.01);
data.REW(data.REW>1) = 1;
%% Part 1: Establish the appropriate u* threshold:
if isfield(data,'Ustar_th')
    disp('u*_{TH} already established -- not calculated.');
else
    [data.Ustar_th f_ustar_th] = mcm_Ustar_th_JJB(data,1);
end
% data.recnum(data.Year == year) = 1:1:yr_length(year,30);

% ctr = 1;
% data.recnum = NaN.*ones(length(data.PAR),1);
% win_size = 16*48;
% centres(:,1) = (10*48:16*48:17520);
% for year = year_start:1:year_end
% data.recnum(data.Year == year) = 1:1:yr_length(year,30);
%     dt_ctr = 1;
%     for dt_centres = 10*48:16*48:yr_length(year,30)%seas = 1:1:4
%         ind_bot = max(1,dt_centres-win_size);
%         ind_top = min(dt_centres+win_size,yr_length(year,30));
%         ind = find(data.Year == year & data.recnum >= ind_bot & data.recnum <= ind_top);
%         [u_th_est biweek_u_th(dt_ctr,ctr)] = Reichsten_uth(data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
%         dt_ctr = dt_ctr+1;
%     end
%     ctr = ctr+1;
% end
% 
% %%% Average for each data window over all years (using median or mean):
% Ustar_th_all = nanmedian(biweek_u_th,2);
% Ustar_th_all2 = nanmean(biweek_u_th,2);
% ctr = 1;
% L = '';
% for year = year_start:1:year_end
% %%% interpolate between points:
% % step 1: interpolate out to the ends:
% use_pts = (1:1:(yr_length(year,30)-centres(end))+(centres(1)))';
% ust_fill = [Ustar_th_all2(end); Ustar_th_all2(1)];
% x = [1; use_pts(end)];
% ust_interp = interp1(x,ust_fill,use_pts);
% centres_tmp = [1; centres; yr_length(year,30)];
% Ustar_th_all_tmp = [ust_interp(yr_length(year,30)-centres(end)+1); Ustar_th_all2; ust_interp(yr_length(year,30)-centres(end))];
% Ustar_th_interp = interp1(centres_tmp,Ustar_th_all_tmp,(1:1:yr_length(year,30))');
% data.Ustar_th(data.Year == year,1) = Ustar_th_interp;
% ctr = ctr+1;
% clear centres_tmp Ustar_th_all_tmp Ustar_th_interp ust_interp x ust_fill use_pts;
% L = [L '''' num2str(year) '''' ','];
% end
% L = [L '''' 'Median' '''' ',' '''' 'Mean' ''''];
% 
% if plot_flag == 1
%    figure(1);clf; 
%    for k = 1:1:ctr-1
%        h1(k) = plot(centres,biweek_u_th(:,k),'.-','Color',clrs(k,:));hold on;
%    end
%    h1(k+1) = plot(centres,Ustar_th_all,'-','LineWidth',5,'Color',[0.5 0.5 0.5]); hold on;
%    h1(k+2) = plot(centres,Ustar_th_all2,'-','LineWidth',5,'Color',[1 0 0.5]); hold on;
%    eval(['legend(h1,' L ')']);
% %    legend(h1,'2003','2004','2005','2006','2007','2008','2009','Median','Mean')
%    ylabel('u^{*}', 'FontSize',16)
%    set(gca, 'FontSize',14);
%    print('-dpdf',[fig_path 'u*_th']);
% close all;
% end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% RESPIRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if debug_flag ~= 2
    RE_raw = NaN.*data.NEE;
    % changed April 21, 2011 by JJB:
%     ind_param.RE = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 15 ) |... % growing season
%         ( data.Ustar >= data.Ustar_th & ~isnan(data.NEE) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)  ) );  % non-growing season
%     ind_param.RE = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std) & data.PAR < 15) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std.*data.SM_a_filled) & ((data.Ts2<0.5 & data.Ta < 2)|(data.Ts2<2 & data.Ta < 0)) ) );                                   % non-growing season
    ind_param.RE = find((data.PAR >= 15 |data.Ustar >= data.Ustar_th) & data.RE_flag == 2 & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std));
    RE_raw(ind_param.RE,1) = data.NEE(ind_param.RE,1);
    RE_filled_indiv = RE_raw; % to be filled by running ANN to indiv yrs
%     RE_filled_all = RE_raw;   % to be filled by running ANN to all yrs simultaneously
    RE_filled_all2 = RE_raw;   % to be filled by running ANN to all yrs simultaneously
    target_RE = RE_raw;
    inputs_RE_indiv = [data.Ts5 data.SM_a_filled];
%     inputs_RE_all = [data.Ts5 data.Ta data.SM_a_filled data.Year];
    inputs_RE_all2 = [data.Ts5 data.SM_a_filled data.Year];
    inputs_RE_all2_Tsonly = [data.Ts5 data.Year];
    
    %%% Run the NN for individual years
    % Input Arguments to ANN_Gapfill:
    % 1. Input met data; 2. Data to model(RE, NEE); 3. Year list(data.Year)
    % 4. Run type (2=indiv years, 1=all years); 5. Num nodes; 6. Name Tag
    %%%%%% 8-Dec-2010 - disabled the individual years runs for RE:%%%%%%%%%%
    nnet_RE_indiv(1).NEE_sim = NaN.*ones(length(data.Ts5),1);
%     nnet_RE_indiv = ANN_Gapfill(inputs_RE_indiv, target_RE, data.Year,2,30, 'nnet_RE_indiv');
%     RE_filled_indiv(isnan(RE_filled_indiv),1) = nnet_RE_indiv(1).NEE_sim(isnan(RE_filled_indiv),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %     nnet_RE_all = ANN_Gapfill(inputs_RE_all, target_RE, data.Year,1,30, 'nnet_RE_all');
% % %     RE_filled_all(isnan(RE_filled_all),1) = nnet_RE_all(1).NEE_sim(isnan(RE_filled_all),1);
    nnet_RE_all2 = ANN_Gapfill(inputs_RE_all2, target_RE, data.Year,1,40, 'nnet_RE_all2');
% Changed this on 20160206 (JJB) -> added  | RE_filled_all2<0 
    RE_filled_all2(isnan(RE_filled_all2) | RE_filled_all2<0,1) = nnet_RE_all2(1).NEE_sim(isnan(RE_filled_all2) | RE_filled_all2<0,1);
    RE_pred_all2 = nnet_RE_all2(1).NEE_sim(:,1);
    
    %%% Run for Ts-only
    nnet_RE_all2_Tsonly = ANN_Gapfill(inputs_RE_all2_Tsonly, target_RE, data.Year,1,40, 'nnet_RE_all2-Tsonly');
% Changed this on 20160206 (JJB) -> added  | RE_filled_all2<0 
    RE_filled_all2(isnan(RE_filled_all2) | RE_filled_all2<0,1) = nnet_RE_all2_Tsonly(1).NEE_sim(isnan(RE_filled_all2) | RE_filled_all2<0,1);
    RE_pred_all2(isnan(RE_pred_all2)) = nnet_RE_all2_Tsonly(1).NEE_sim(isnan(RE_pred_all2),1);
        
end
%%% Plot both RE model output:
if plot_flag == 1;
figure(2);clf;
subplot(211);
plot(ind_param.RE,RE_raw(ind_param.RE),'k.-'); hold on;
plot(nnet_RE_all2(1).NEE_sim,'g', 'LineWidth',3);hold on;
plot(nnet_RE_indiv(1).NEE_sim,'b');hold on;
% plot(nnet_RE_all(1).NEE_sim,'r');hold on;
axis([1 length(RE_raw) -10 30])
subplot(212);
[AX h1 h2] = plotyy((1:1:length(data.recnum)),data.Ts5,(1:1:length(data.recnum)), data.REW,@line,@line);
set(AX(1),'XLim',[1 length(data.recnum)],'YLim',[-5 25])
set(AX(2),'XLim',[1 length(data.recnum)],'YLim',[0.1 1])
set(h2, 'LineWidth',3)
print('-dpdf',[fig_path 'RE_estimates']);
end
%%% Choose here which REs to use:
    RE_filled = RE_filled_all2;
    RE_pred = RE_pred_all2;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% NEE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NEE_clean = data.NEE;
% NEE_clean(data.PAR < 15 & data.Ustar < data.Ustar_th, 1) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The following was changed to 150 on May 19, 2011 by JJB
% This change was implemented to reduce the GEP < 0 events that occur at 
% sundown/sunup that get included into NEE, but get excluded from GEP (set
% to zero).  This change will make things more consistent between NEE and
%  (RE_filled - GEP_filled).
NEE_clean((data.PAR < 15 & data.Ustar < data.Ustar_th) | ...
    (data.PAR < 150 & data.GEP_flag>=1 & data.Ustar< data.Ustar_th),1) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind_NEE = find(~isnan(NEE_clean));
NEE_filled = NEE_clean;
NEE_filled_all = NEE_clean;
%%% Run ANN:
target_NEE = NEE_clean;
inputs_NEE = [data.PAR data.Ts5 data.Ta data.REW data.VPD data.GDD];
inputs_NEE_all = [data.PAR data.Ts5 data.Ta data.REW data.VPD data.GDD data.Year];

inputs_NEE_all_noSM = [data.PAR data.Ts5 data.Ta data.VPD data.GDD data.Year];


%%%%%% 8-Dec-2010 - disabled the individual years runs for NEE:%%%%%%%%%%
% nnet_NEE = ANN_Gapfill(inputs_NEE, target_NEE, data.Year, 2, 30, 'nnet_NEE');
% NEE_filled(isnan(NEE_filled),1) = nnet_NEE(1).NEE_sim(isnan(NEE_filled),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nnet_NEE_all = ANN_Gapfill(inputs_NEE_all, target_NEE, data.Year, 1, 30, 'nnet_NEE_all');
NEE_filled_all(isnan(NEE_filled_all),1) = nnet_NEE_all(1).NEE_sim(isnan(NEE_filled_all),1);
NEE_pred_all = nnet_NEE_all(1).NEE_sim(:,1);

%%% Run for no-SM:
nnet_NEE_all_noSM = ANN_Gapfill(inputs_NEE_all_noSM, target_NEE, data.Year, 1, 30, 'nnet_NEE_all-noSM');
NEE_filled_all(isnan(NEE_filled_all),1) = nnet_NEE_all_noSM(1).NEE_sim(isnan(NEE_filled_all),1);
NEE_pred_all(isnan(NEE_pred_all)) = nnet_NEE_all_noSM(1).NEE_sim(isnan(NEE_pred_all),1);

%%% Plot both NEE model output:
if plot_flag == 1;
figure(3);clf;
subplot(211);
plot(ind_NEE,NEE_clean(ind_NEE),'k.-'); hold on;
plot(nnet_NEE_all(1).NEE_sim,'g', 'LineWidth',3);hold on;
plot(nnet_RE_indiv(1).NEE_sim,'b');hold on;
% plot(nnet_RE_all(1).NEE_sim,'r');hold on;
axis([1 length(RE_raw) -30 20])
subplot(212);
[AX h1 h2] = plotyy((1:1:length(data.recnum)),data.Ts5,(1:1:length(data.recnum)), data.REW,@line,@line);
set(AX(1),'XLim',[1 length(data.recnum)],'YLim',[-5 25])
set(AX(2),'XLim',[1 length(data.recnum)],'YLim',[0.1 1])
set(h2, 'LineWidth',3)
print('-dpdf',[fig_path 'NEE_estimates']);
end;
%%% Choose here which NEE to use:
    NEE_filled = NEE_filled_all;
    NEE_pred = NEE_pred_all;

%% Try and get GEP estimates by using filled RE and filled NEE:
if debug_flag ~=2
    GEP_filled = zeros(length(NEE_filled),1);
    GEP_est = RE_pred - NEE_filled; % Changed this on 20160206 (JJB) - changed RE_filled to RE_pred.
% ind_GEP = find(data.PAR >= 15 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
%     | (data.dt > 330 | data.dt < 85) & data.Ts2 >= 1 & data.Ta > 2)); 
ind_GEP = find(data.GEP_flag>=1);

%     ind_GEP = data.PAR >= 15 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
%         | data.dt > 330 & data.Ts5 >= 1.25 & data.Ta > 2);
    GEP_filled(ind_GEP,1) = GEP_est(ind_GEP,1);
    GEP_filled(GEP_filled < 0) = 0;
    
    if plot_flag == 1;
figure(4);clf;
subplot(211);
plot(ind_GEP,GEP_est(ind_GEP),'k.-'); hold on;
plot(GEP_filled,'b', 'LineWidth',2);hold on;
axis([1 length(GEP_filled) -30 20])
subplot(212);
[AX h1 h2] = plotyy((1:1:length(data.recnum)),data.PAR,(1:1:length(data.recnum)), data.REW,@line,@line);
set(AX(1),'XLim',[1 length(data.recnum)],'YLim',[0 2300])
set(AX(2),'XLim',[1 length(data.recnum)],'YLim',[0.1 1])
set(h2, 'LineWidth',3)
print('-dpdf',[fig_path 'GEP_estimates']);
       
    end
    
end

%% Plot the final output:
    f_out = figure('Name', 'Final Filled Data');clf
    subplot(2,1,1); title('NEE');
    plot(NEE_filled); hold on;
    plot(NEE_clean,'k.')
    legend('filled','measured');
    subplot(2,1,2);
    hold on;
    plot(RE_filled,'r')
    plot(-1.*GEP_filled,'g')
    legend('RE','GEE');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% SAVE THE FINAL NEE, GEP, RE DATA and SUMS: %%%%%%%%%%%%%%%%
final_out = struct;
sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};

if debug_flag ~=2
    %%% Assign data to master file:
    master.Year = data.Year;
    master.NEE_filled = NEE_filled;
    master.NEE_clean = NEE_clean;
    master.NEE_pred = NEE_pred;
    master.RE_filled = RE_filled;
    master.GEP_filled = GEP_filled;
    master.GEP_pred = GEP_est;
    master.RE_pred = RE_pred;
    %%% Do Sums:
    ctr = 1;
    for year = year_start:1:year_end
        master.sums(ctr,1) = year;
        master.sums(ctr,2) = sum(master.NEE_filled(data.Year==year)).*0.0216;
        master.sums(ctr,3) = sum(master.NEE_pred(data.Year==year)).*0.0216;
        master.sums(ctr,4) = sum(master.GEP_filled(data.Year==year)).*0.0216;
        master.sums(ctr,5) = sum(master.GEP_pred(data.Year==year)).*0.0216;
        master.sums(ctr,6) = sum(master.RE_filled(data.Year==year)).*0.0216;
        master.sums(ctr,7) = sum(master.RE_pred(data.Year==year)).*0.0216;
        
        ctr = ctr + 1;
    end
final_out.master = master;
final_out.master.sum_labels = sum_labels;
final_out(1).tag = 'ANN_JJB1';   
end
disp('mcm_Gapfill_ANN_JJB1 done!');

% save([ls 'Matlab/Data/Gapfilling/TP39/ANN_JJB1_fill_2003-2009.mat'], 'master')
end
