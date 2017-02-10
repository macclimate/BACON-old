 function [final_out f_out] = mcm_Gapfill_SiteSpec(data, Ustar_th, plot_flag)

%%% Pre-defined variables, mostly for plotting:
f_out = [];
test_Ts = (-10:2:26)';
test_PAR = (0:200:2400)';
[clrs] = jjb_get_plot_colors;
% test_VPD = (0:0.2:3)';
% test_SM = (0.045:0.005:0.10)';
year_start = data.year_start;
year_end = data.year_end;
%%%%%%%%
warning off all
%%%%%%%%
%% Ustar Threshold -- default is simple fixed threshold
%%% Enforced if data.Ustar_th does not exist:
if isfield(data,'Ustar_th')
    if plot_flag ~=-9
        disp('u*_{TH} already established -- not calculated.');
    end
else
    data.Ustar_th = Ustar_th.*ones(length(data.Year),1);
end

%%% Standard Deviation Estimates:
%%% If the field exists, then we'll assume we want to use WSS.
%%% 1. If NEE_std does not exist, use OLS:
if isfield(data,'NEE_std')==0
    data.costfun = 'OLS';
    data.NEE_std = ones(length(data.Year),1);
else
    % If it does exist, check if data.costfun exists:
    if isfield(data,'costfun')==1
        % If data.costfun exists, do nothing - we're all set
        if strcmp(data.costfun,'OLS')==1
            data.NEE_std = ones(length(data.Year),1);
        end
    else
        % If it doesn't, assume we want WSS, since there is std data:
        data.costfun = 'WSS';
    end
end

if isfield(data,'min_method')==1
else
    data.min_method = 'NM';
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Part 1: Respiration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Specify the half-hours that can be used to parameterize the respiration
%%% model (no NaNs, and certainty that there is no photosynthesis taking
%%% place:

%     ind_param(1).RE_all_old = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std) & data.PAR < 15) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std.*data.SM_a_filled) & ((data.Ts2<0.5 & data.Ta < 2)|(data.Ts2<2 & data.Ta < 0)) ) );                                   % non-growing season
%     ind_param(1).RE_all = find(data.Ustar >= data.Ustar_th & data.RE_flag == 2 & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std));
    ind_param(1).RE_all = find((data.PAR >= 15 |data.Ustar >= data.Ustar_th) & data.RE_flag == 2 & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std));

%    ind_param(1).RE_all = find((data.PAR >= 15 |data.Ustar >= data.Ustar_th) & data.RE_flag == 2 & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std) & data.Year ==2012);

   %%% Removed April 21, 2011 by JJB -- we don't need separate handling
    %%% for different sites now.  Also, updated the criteria:
% %%% In the case of TP39, Take nighttime data at any time of year, and
% %%% day+night data during the non-growing season:
% if strcmp(data.site,'TP39') == 1;
%     ind_param(1).RE_all = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.SM_a_filled) & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ~isnan(data.SM_a_filled) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)  ) );                                   % non-growing season
%     
%     %%% For the other sites, use the same approach, but for years when the
%     %%% OPEC system would have been used, we have to filter out any periods
%     %%% when air temperature was low enough that the "winter-uptake" problem
%     %%% will skew gapfilling results.  We will keep this threshold at 5 right now, since
%     %%% we are using all years of data - should be able to get enough data
%     %%% to make it work.
% else
%     ind_param(1).RE_all = find((data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.SM_a_filled) & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 & ((data.Year <= 2007 & data.Ta > 5) | (data.Year >= 2008 & data.Ta > -30)) ) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ~isnan(data.SM_a_filled) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2) & ((data.Year <= 2007 & data.Ta > 5) | (data.Year >= 2008 & data.Ta > -30)))   );                                   % non-growing season
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set options and run the parameterization for Respiration models:
% First step - run the model with all-years lumped together for
% parameterization.  This gives us the average SM response that we carry
% forward to the individual year models.



clear global;
%%% Run the Q10 model, with Ts + SM parameterization:
options.costfun =data.costfun; options.min_method = data.min_method;
[c_hat(1).RE1all, y_hat(1).RE1all, y_pred(1).RE1all, stats(1).RE1all, sigma(1).RE1all, err(1).RE1all, exitflag(1).RE1all, num_iter(1).RE1all] = ...
    fitresp([2 3 8 180], 'fitresp_3B', [data.Ts5(ind_param(1).RE_all) data.SM_a_filled(ind_param(1).RE_all)] , data.NEE(ind_param(1).RE_all), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param(1).RE_all), options);
clear global;
%%% Run the Q10 model, parameterizing only with Ts
options.costfun =data.costfun; options.min_method = data.min_method; options.f_coeff = [NaN NaN];
[c_hat(1).RE1all_Tsonly, y_hat(1).RE1all_Tsonly, y_pred(1).RE1all_Tsonly, stats(1).RE1all_Tsonly, sigma(1).RE1all_Tsonly, err(1).RE1all_Tsonly, exitflag(1).RE1all_Tsonly, num_iter(1).RE1all_Tsonly] = ...
    fitresp([2 3], 'fitresp_3A', [data.Ts5(ind_param(1).RE_all)] , data.NEE(ind_param(1).RE_all), [data.Ts5], data.NEE_std(ind_param(1).RE_all), options);


%%% Commented April 27, 2011 by JJB - go with consistent formulation:
fixed_RE_SM_coeffs = [NaN NaN c_hat(1).RE1all(3:4)];
     starting_coeffs = [2 3];
%%% For TP39, we will fix the SM coefficients -- keeps the response to SM
%%% constant
% if strcmp(data.site, 'TP39') == 1
%     fixed_RE_SM_coeffs = [NaN NaN c_hat(1).RE1all(3:4)];
%     starting_coeffs = [2 3];
%     
%     %%% For all other sites, we will fix the SM coefficients, as well as the
%     %%% second Ts-response coefficient -- Adds stability to the year-to-year
%     %%% parameterization
% else
%     fixed_RE_SM_coeffs = [NaN c_hat(1).RE1all(2:4)]; % changed this from 3:4 to 2:4 so that Q10 is fixed for all years.
%     starting_coeffs = [2];
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Output variables:
%%% 1. Raw RE data (during useable periods of NEE [u* OK])
%%% 2,3. Modeled RE data for both the Ts+SM and Ts_only models:
Rraw(1:length(data.NEE),1) = NaN;
RE_model(1:length(data.NEE),1) = NaN;
RE_model_Tsonly(1:length(data.NEE),1) = NaN;

%%% Find periods when measured NEE is acceptable to use as raw RE:
%  ind_Rraw_old = find((data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 ) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) &  ((data.Ts2<0.5 & data.Ta < 2)|(data.Ts2<2 & data.Ta < 0)) ) );% non-growing season
 ind_Rraw = find((data.PAR >= 15 |data.Ustar >= data.Ustar_th) & data.GEP_flag == 0 & ~isnan(data.NEE)); % all-seasons

    
    % if strcmp(data.site,'TP39')==1
%     ind_Rraw = find((data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 ) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)) );                             % non-growing season
% else
%     ind_Rraw = find((data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 & ((data.Year <= 2007 & data.Ta > 5) | (data.Year >= 2008 & data.Ta > -30))) |... % growing season
%         (data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2) & ((data.Year <= 2007 & data.Ta > 5) | (data.Year >= 2008 & data.Ta > -20))) );                             % non-growing season
% end
Rraw(ind_Rraw) = data.NEE(ind_Rraw);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Run through each year, finding suitable data for parameterization in
%%% given year:
ctr = 1;
ind_param = struct;
c_hat = struct; y_hat = struct; y_pred = struct; stats = struct;
sigma = struct; err = struct; exitflag = struct; num_iter = struct;

for year = year_start:1:year_end
%         ind_param(ctr).RE = find((data.Year == year & data.Ustar >= data.Ustar_th & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std) & data.PAR < 15 ) |... % growing season
%             (data.Year == year & data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std.*data.SM_a_filled) & ((data.Ts2<0.5 & data.Ta < 2)|(data.Ts2<2 & data.Ta < 0))  ) );                                   % non-growing season
        ind_param(ctr).RE = find(data.Year == year & (data.PAR >= 15 |data.Ustar >= data.Ustar_th) & data.RE_flag == 2 & ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std));
                
    %%% Removed April 21, 2011 by JJB -- we don't need separate handling
    %%% for different sites now.  Also, updated the criteria:
%     if strcmp(data.site, 'TP39') == 1
%         ind_param(ctr).RE = find((data.Year == year &data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.SM_a_filled) & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 ) |... % growing season
%             (data.Year == year & data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ~isnan(data.SM_a_filled) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)  ) );                                   % non-growing season
%     else
%         ind_param(ctr).RE = find((data.Year == year &data.Ustar >= data.Ustar_th & ~isnan(data.Ts5) & ~isnan(data.SM_a_filled) & ~isnan(data.NEE.*data.NEE_std) & data.PAR < 15 &( (data.Year <= 2007 & data.Ta > 3) | (data.Year >= 2008 & data.Ta > -20) ) ) |... % growing season
%             (data.Year == year & data.Ustar >= data.Ustar_th & ~isnan(data.NEE.*data.NEE_std) & ~isnan(data.SM_a_filled) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2) & ( (data.Year <= 2007 & data.Ta > 3) | (data.Year >= 2008 & data.Ta > -20) ) ) );                                   % non-growing season
%     end
    
    % Run Minimization:
    
    %     %%% Run the Logi model, with Ts + SM parameterization:
    % [c_hat(ctr).RE, y_hat(ctr).RE, y_pred(ctr).RE, stats(ctr).RE, sigma(ctr).RE, err(ctr).RE, exitflag(ctr).RE, num_iter(ctr).RE] = ...
    %     fitresp([8 0.2 12], 'fitresp_2A', data.Ts5(ind_param(ctr).RE), data.NEE(ind_param(ctr).RE), data.Ts5(data.Year == year), data.NEE_std(ind_param(ctr).RE), 'WSS', 'NM');
    %     %%% Run the Logi model, with Ts only parameterization:
    % options.costfun ='WSS'; options.min_method = data.min_method; options.f_coeff = [NaN NaN NaN NaN]
    % [c_hat(ctr).RE1, y_hat(ctr).RE1, y_pred(ctr).RE1, stats(ctr).RE1, sigma(ctr).RE1, err(ctr).RE1, exitflag(ctr).RE1, num_iter(ctr).RE1] = ...
    %     fitresp([2 3 8 180], 'fitresp_3B', [data.Ts5(ind_param(ctr).RE) data.SM_a_filled(ind_param(ctr).RE)] , data.NEE(ind_param(ctr).RE), [data.Ts5(data.Year == year) data.SM_a_filled(data.Year == year)], data.NEE_std(ind_param(ctr).RE), options);
    clear global;
    %%% Run the Q10 model, with Ts + SM parameterization:
    options.costfun =data.costfun; options.min_method = data.min_method; options.f_coeff = fixed_RE_SM_coeffs;
    [c_hat(ctr).RE, y_hat(ctr).RE, y_pred(ctr).RE, stats(ctr).RE, sigma(ctr).RE, err(ctr).RE, exitflag(ctr).RE, num_iter(ctr).RE] = ...
        fitresp(starting_coeffs, 'fitresp_3B', [data.Ts5(ind_param(ctr).RE) data.SM_a_filled(ind_param(ctr).RE)] , data.NEE(ind_param(ctr).RE), [data.Ts5(data.Year == year) data.SM_a_filled(data.Year == year)], data.NEE_std(ind_param(ctr).RE), options);
    clear global;
    %%% Run the Q10 model, with Ts-only parameterization:
    options.costfun =data.costfun; options.min_method = data.min_method;options.f_coeff = [NaN NaN];
    [c_hat(ctr).RE_Tsonly, y_hat(ctr).RE_Tsonly, y_pred(ctr).RE_Tsonly, stats(ctr).RE_Tsonly, sigma(ctr).RE_Tsonly, err(ctr).RE_Tsonly, exitflag(ctr).RE_Tsonly, num_iter(ctr).RE_Tsonly] = ...
        fitresp([2 3], 'fitresp_3A', [data.Ts5(ind_param(ctr).RE) data.SM_a_filled(ind_param(ctr).RE)] , data.NEE(ind_param(ctr).RE), [data.Ts5(data.Year == year) data.SM_a_filled(data.Year == year)], data.NEE_std(ind_param(ctr).RE), options);
    
    %%% Fill the modeled RE data with predicted values:
    RE_model(data.Year == year,1) = y_pred(ctr).RE;
    RE_model_Tsonly(data.Year == year, 1) = y_pred(ctr).RE_Tsonly;
    % RE_model2(data.Year == year,1) = y_pred(ctr).RE2;
    % RE_model3(data.Year == year,1) = y_pred(ctr).RE3;
    ctr = ctr+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:
%%% For cases where there are gaps in the Ts+SM model data:
%%% When gaps exist in the Ts + SM model output, we have to use the Ts-only
%%% model data.  There may be offsets in the output of these two models.
%%% To avoid this, we'll use the Alan Barr windowed gapfilling method to get a
%%% time-varying parameter that allows us to adjust the Ts-only model to remove
%%% biases between it and the Ts+SM model:
rw = jjb_AB_gapfill(RE_model_Tsonly, RE_model,  [],200, 10, 'off', [], [], 'rw');
%%% Adjust Ts-only modeled RE by TVP:
RE_model_Tsonly = RE_model_Tsonly.*rw(:,2);
%%% Fill gaps in Ts+SM model by the Ts-only model output:
RE_model(isnan(RE_model),1) = RE_model_Tsonly(isnan(RE_model),1);

if plot_flag == 1
    %%% Plot the relationships for RE-Ts for each year:
    figure('Name', 'Annual REvsTs');clf;
    ctr = 1;
    for year = year_start:1:year_end
        f_handle = 'fitresp_3B';
        test_Ts_y =    feval(f_handle,c_hat(ctr).RE,[test_Ts ones(length(test_Ts))]);
        % (c_hat(ctr).RE(1))./(1 + exp(c_hat(ctr).RE(2).*(c_hat(ctr).RE(3)-test_Ts)));
        plot(test_Ts, test_Ts_y,'-','Color', clrs(ctr,:)); hold on;
        ctr = ctr+1;
    end
    legend(num2str((year_start:1:year_end)'));
    
    %%% Plot estimates with raw data:
    figure('Name','RE - raw vs. modeled');clf;
    plot(Rraw,'k');hold on;
    plot(RE_model_Tsonly,'b');
    plot(RE_model,'r')
    legend('raw','model-Tsonly', 'model-Ts+SM')
    
    %%% Calculate stats for each:
    [RE_stats(1,1) RE_stats(1,2) RE_stats(1,3) RE_stats(1,4)] = model_stats(RE_model_Tsonly, Rraw,'off');
    [RE_stats(2,1) RE_stats(2,2) RE_stats(2,3) RE_stats(2,4)] = model_stats(RE_model, Rraw,'off');
    %%% display stats on screen:
    disp('Stats for Each RE Model:');
    disp('              RMSE    |    rRMSE |     MAE     |   BE ');
    disp(['model-Tsonly: ' num2str(RE_stats(1,:))]);
    disp(['model-Ts+SM: ' num2str(RE_stats(2,:))]);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% PHOTOSYNTHESIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Similar to respiration, we will fill gaps in GEP using a multi-variable
%%% model (PAR, Ts, VPD, SM).  To do this, we first parameterize using
%%% all-years of data, in order to get the general response of GEP to the
%%% scaling environmental variables (Ts, VPD, SM).  After this, we will fix
%%% the relationships for these variables, and then run the model
%%% year-by-year, allowing the PAR-GEP relationship (capacity) to change.

%%% Raw GEP is difference between modeled RE and measured NEE:
GEPraw = RE_model - data.NEE;
%%% Set GEP to zero when PAR < 15:
% GEPraw(data.PAR < 15) = NaN;
%%% Updated May 19, 2011 by JJB:
GEPraw(data.PAR < 15 | (data.PAR <= 150 & data.Ustar < data.Ustar_th) ) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%
GEP_model = zeros(length(GEPraw),1);
GEP_pred = NaN.*ones(length(GEPraw),1);
GEP_pred_fixed = NaN.*ones(length(GEPraw),1);
GEP_pred_fixed_noSM = NaN.*ones(length(GEPraw),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Index for all hhours available for parameterization of an all-years
%%% relationship:
% ind_param(1).GEPallold = find(data.Ts2 > 0.5 & data.Ta > 2 & data.PAR > 15 & ~isnan(GEPraw.*data.NEE_std.*data.SM_a_filled) & data.VPD > 0 & data.Ustar > data.Ustar_th);
ind_param(1).GEPall = find(~isnan(GEPraw.*data.NEE_std.*data.SM_a_filled.*data.Ts5.*data.PAR) & data.GEP_flag==2 & data.VPD > 0);

clear options global;
%%% Set inputs for all-years parameterization
options.costfun =data.costfun; options.min_method = data.min_method;
X_in = [data.PAR(ind_param(1).GEPall) data.Ts5(ind_param(1).GEPall) data.VPD(ind_param(1).GEPall) data.SM_a_filled(ind_param(1).GEPall)];
X_eval = [data.PAR data.Ts5 data.VPD data.SM_a_filled];
%%% Run all-years parameterization:
[c_hat(1).GEPall, y_hat(1).GEPall, y_pred(1).GEPall, stats(1).GEPall, sigma(1).GEPall, err(1).GEPall, exitflag(1).GEPall, num_iter(1).GEPall] = ...
    fitGEP([0.1 40 2 0.5 -2 -0.8 8 180], 'fitGEP_1H1_3L6', X_in,GEPraw(ind_param(1).GEPall),  X_eval, data.NEE_std(ind_param(1).GEPall), options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fix the coefficients for environmental scaling variables:
GEP_fixed_coeffs = c_hat(1).GEPall(3:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Run through each year, finding suitable data for parameterization in
%%% given year:
if plot_flag == 1
    figure('Name','GEP-PAR relationship');clf
end
ctr = 1;
for year = year_start:1:year_end
    %%% Index of good data to use for model parameterization:
%     ind_param(ctr).GEP = find(data.Ts2 > 1 & data.Ta > 2 & data.PAR > 15 & ~isnan(GEPraw) & data.Year == year & ~isnan(data.NEE_std) ...
%         & ~isnan(data.SM_a_filled) & data.VPD > 0);
  ind_param(ctr).GEP = find(data.Year == year & ~isnan(GEPraw.*data.NEE_std.*data.SM_a_filled.*data.Ts5.*data.PAR) & data.GEP_flag==2 & data.VPD > 0);

    X_in = [data.PAR(ind_param(ctr).GEP) data.Ts5(ind_param(ctr).GEP) data.VPD(ind_param(ctr).GEP) data.SM_a_filled(ind_param(ctr).GEP)];
    X_eval = [data.PAR(data.Year == year) data.Ts5(data.Year == year) data.VPD(data.Year == year) data.SM_a_filled(data.Year == year)];
    clear global;
    %%% use fitGEP_1H1_3L6 function to get coefficients for GEP relationship:
    options.costfun =data.costfun; options.min_method = data.min_method; options.f_coeff = NaN.*ones(1,8);
    [c_hat(ctr).GEP, y_hat(ctr).GEP, y_pred(ctr).GEP, stats(ctr).GEP, sigma(ctr).GEP, err(ctr).GEP, exitflag(ctr).GEP, num_iter(ctr).GEP] = ...
        fitGEP([0.1 40 2 4 -2 -0.8 8 180], 'fitGEP_1H1_3L6', X_in,GEPraw(ind_param(ctr).GEP),  X_eval, data.NEE_std(ind_param(ctr).GEP), options);
    clear global;
    %%% use fitGEP_1H1_3L6 function with fixed scalars to get coefficients for GEP relationship:
    options.costfun =data.costfun; options.min_method = data.min_method; options.f_coeff = [NaN NaN GEP_fixed_coeffs];
    [c_hat(ctr).GEPfixed, y_hat(ctr).GEPfixed, y_pred(ctr).GEPfixed, stats(ctr).GEPfixed, sigma(ctr).GEPfixed, err(ctr).GEPfixed, exitflag(ctr).GEPfixed, num_iter(ctr).GEPfixed] = ...
        fitGEP([0.1 40], 'fitGEP_1H1_3L6', X_in,GEPraw(ind_param(ctr).GEP),  X_eval, data.NEE_std(ind_param(ctr).GEP), options);
    clear global;
    %%% We need a dataset to fill in gaps in predicted GEP when we don't have
    %%% soil moisture -- we'll do this by just setting SM to 0.2 (no reduction
    %%% effect), and then we'll take care of any differences at a later point:
    X_eval2 = X_eval;
    X_eval2(isnan(X_eval2(:,4)),4) = 0.2;
    [c_hat(ctr).GEPfixed_noSM, y_hat(ctr).GEPfixed_noSM, y_pred(ctr).GEPfixed_noSM, stats(ctr).GEPfixed_noSM, sigma(ctr).GEPfixed_noSM, err(ctr).GEPfixed_noSM, exitflag(ctr).GEPfixed_noSM, num_iter(ctr).GEPfixed_noSM] = ...
        fitGEP([0.1 40], 'fitGEP_1H1_3L6', X_in,GEPraw(ind_param(ctr).GEP),  X_eval2, data.NEE_std(ind_param(ctr).GEP), options);
    
    % [GEP_coeff(ctr,:) GEP_pred GEP_r2 GEP_sigma] = hypmain1([0.01 10 0.1], 'fit_hyp1', data.PAR(ind_param_GEP), GEPraw(ind_param_GEP), data.NEE_std(ind_param_GEP));
    %%% Estimate GEP for the given year:
    GEP_pred(data.Year == year,1) = y_pred(ctr).GEP;
    GEP_pred_fixed(data.Year == year,1) = y_pred(ctr).GEPfixed;
    GEP_pred_fixed_noSM(data.Year == year,1) = y_pred(ctr).GEPfixed_noSM;
    
    %GEP_coeff(ctr,1).*data.PAR(data.Year==year,1).*GEP_coeff(ctr,2)./...
    %    (GEP_coeff(ctr,1).*data.PAR(data.Year==year,1) + GEP_coeff(ctr,2));
    %%% GEP relationship for plotting:
    test_PAR_y = c_hat(ctr).GEP(1).*test_PAR.*c_hat(ctr).GEP(2)./...
        (c_hat(ctr).GEP(1).*test_PAR + c_hat(ctr).GEP(2));
    test_PAR_yfixed = c_hat(ctr).GEPfixed(1).*test_PAR.*c_hat(ctr).GEPfixed(2)./...
        (c_hat(ctr).GEPfixed(1).*test_PAR + c_hat(ctr).GEPfixed(2));
    if plot_flag == 1
        %%% Plot relationships:
        subplot(1,2,1)
        plot(test_PAR, test_PAR_y,'-','Color', clrs(ctr,:)); hold on;
        subplot(1,2,2)
        plot(test_PAR, test_PAR_yfixed,'-','Color', clrs(ctr,:)); hold on;
    end
    clear GEP_r2 GEP_sigma test_PAR_y;
    ctr = ctr+1;
end
if plot_flag == 1
    legend(num2str((year_start:1:year_end)'));
end
%%% Use Time-varying-parameter to fill during periods when we don't have SM:
pw = jjb_AB_gapfill(GEP_pred_fixed_noSM, GEP_pred_fixed, [],200, 10, 'off', [], [], 'rw');
GEP_pred_fixed_noSM_adj = GEP_pred_fixed_noSM.*pw(:,2);
GEP_pred_fixed(isnan(GEP_pred_fixed),1) = GEP_pred_fixed_noSM_adj(isnan(GEP_pred_fixed),1);

%%% Clean up any problems that may exist in the data:
% ind_GEP = find(data.PAR >= 15 & ((data.dt > 85 & data.dt < 330 & (data.Ts2 >= 1 & data.Ta > 2)) ...
%     | (data.dt > 330 | data.dt < 85) & data.Ts2 >= 2 & data.Ta > 2));
% ind_GEP = find(data.PAR >= 15 &  ((data.Ts2 >= 1 & data.Ta > 2) | (data.Ts2 > 0 & data.Ta > 5) ));
ind_GEP = find(data.GEP_flag>=1);

% ((data.Ts2<0.5 & data.Ta < 2)|(data.Ts2<2 & data.Ta < 0))
%%% GEP_model is the final modeled GEP timeseries.
GEP_model(ind_GEP) = GEP_pred_fixed(ind_GEP);

if plot_flag == 1
    %%% Plot estimates with raw data:
    figure('Name','GEP - raw vs. modeled');clf;
    plot(GEPraw,'k');hold on;
    plot(GEP_pred,'c');
    plot(GEP_pred_fixed,'r');
    plot(GEP_model,'b');
    legend('raw','pred -variable scalar','pred-fixed scalars', 'final-modeled')
    
    %%% Calculate stats for each:
    [GEP_stats(1,1) GEP_stats(1,2) GEP_stats(1,3) GEP_stats(1,4)] = model_stats(GEP_model, GEPraw,'off');
    [GEP_stats(2,1) GEP_stats(2,2) GEP_stats(2,3) GEP_stats(2,4)] = model_stats(GEP_pred_fixed, GEPraw,'off');
    %%% display stats on screen:
    disp('Stats for Each GEP Model:');
    disp('                     RMSE    |    rRMSE  |  MAE     |    BE ');
    disp(['final-modeled:      ' num2str(GEP_stats(1,:))]);
    disp(['pred-fixed scalars: ' num2str(GEP_stats(2,:))]);
end
%% Compile coefficient values for easy-reading:
% coeff_list = fieldnames(c_hat(1));
% 
% for i = 1:1:length(coeff_list)
%     
%     for j = 1:1:length(c_hat)
%         try
%             eval(['c_hat_' char(coeff_list(i)) '(j,:) = c_hat(j).' char(coeff_list(i)) ';']);
%         catch
%             eval(['c_hat_' char(coeff_list(i)) '(j,:) = NaN;']);
%         end
%     end
% end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  Final Filling & Output  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Clean NEE (ustar filtering):
NEE_raw = data.NEE;
NEE_clean = NEE_raw;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The following was changed to 150 on May 19, 2011 by JJB
% This change was implemented to reduce the GEP < 0 events that occur at 
% sundown/sunup that get included into NEE, but get excluded from GEP (set
% to zero).  This change will make things more consistent between NEE and
%  (RE_filled - GEP_filled).
NEE_clean((data.PAR < 15 & data.Ustar < data.Ustar_th) | ...
    (data.PAR < 150 & data.GEP_flag>=1 & data.Ustar< data.Ustar_th),1) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NEE_clean = data.NEE_clean;
%%% Fill RE - Use raw data when Ustar > threshold; otherwise, use model+tvp
RE_filled(1:length(Rraw),1) = RE_model;
%%%% modified by JJB, 20160206 so to remove Rraw<0 and replace with modeled:
RE_filled(Rraw>0,1) = Rraw(Rraw>0,1);

%%%% Uncomment this:
% RE_filled(~isnan(Rraw),1) = Rraw(~isnan(Rraw),1);

%%% Fill GEP:
% start with filled GEP equal to all zeroes
GEP_filled = zeros(length(GEPraw),1);
% fill any nans in GEPraw with GEP_model:
%%%%%%%%%% Updated May 19, 2011 by JJB (see above for explanation)
GEPraw(isnan(GEPraw) | GEPraw < 0,1) = GEP_model(isnan(GEPraw) | GEPraw < 0,1);
% GEPraw(isnan(GEPraw) | GEPraw < 0 | (data.PAR <= 150 & data.Ustar < data.Ustar_th),1) = ...
%     GEP_model(isnan(GEPraw) | GEPraw < 0 | (data.PAR <= 150 & data.Ustar < data.Ustar_th),1);

% Now, substitute GEPraw into GEP_filled when applicable (set by ind_GEP)
% ind_GEP = find(data.PAR >= 15 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
%     | data.dt > 330 & data.Ts5 >= 1.25 & data.Ta > 2));
% ind_GEP = find(data.PAR >= 15 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
%     | (data.dt > 330 | data.dt < 85) & data.Ts2 >= 1 & data.Ta > 2));
ind_GEP = find(data.GEP_flag>=1);


GEP_filled(ind_GEP) = GEPraw(ind_GEP);
% GEP_filled(data.PAR < 15 | GEP_filled < 0) = NaN;
% GEP_filled(isnan(GEP_filled),1) = GEP_model(isnan(GEP_filled),1);

%%% Fill NEE:
NEE_filled = NEE_clean;
NEE_filled(isnan(NEE_filled),1) = RE_filled(isnan(NEE_filled),1) - GEP_filled(isnan(NEE_filled),1);

%% Plot filled data:
if plot_flag ~= -9
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
end
%% The final loop to calculate annual sums and check for holes remaining in data:
final_out = struct;
sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};

%%% Assign data to master file:
master.Year = data.Year;
master.NEE_clean = NEE_clean;
master.NEE_filled = NEE_filled;
master.NEE_pred = RE_model-GEP_model;
master.RE_filled = RE_filled;
master.GEP_filled = GEP_filled;
master.GEP_pred = GEP_model;
master.RE_pred = RE_model;
master.c_hat = c_hat;
%%% Do Sums:
ctr = 1;
for year = year_start:1:year_end
    if year == 2002;
        NEE_filled(1:8,1) = NEE_filled(9,1);
        RE_filled(1:8,1) = RE_filled(9,1);
        GEP_filled(1:8,1) = GEP_filled(9,1);
    end
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
final_out.tag = 'SiteSpec';

if plot_flag ~=-9
    disp('mcm_Gapfill_SiteSpec done!');
end
end
