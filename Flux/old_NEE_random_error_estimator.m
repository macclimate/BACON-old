function [std_pred] = NEE_random_error_estimator(data, tol, Ustar_th, plot_flag)
% NEE_uncert_estimator.m
% This function 
% Data should be in a structure file with the form: data.<variable_name> of
% arbitrary length (as long as data.Year and data.dt are there, they can be
% any length)
% inputs:
% 1. structure file with all variables as next level
% 2. tolerances for differences in PAR, Ta, Ts, WS, NEE, SM, WDir, VPD
% 3. A ustar threshold, above which we can assume profile to be well-mixed
if nargin < 4
    plot_flag = 0;
end

if ~isfield(data, 'site') 
    data.site = input('Enter Site Name: ', 's');
end

std_pred(1:length(data.Year),1) = NaN;
if isempty(tol)
    Ta_tol = 3;
    PAR_tol = 100;
    Ts_tol = 1;
    SM_tol = 0.01;
    WS_tol = 1.5;
    VPD_tol = 0.2;
end

% Calculate VPD if it doesn't exist
if isfield(data,'VPD')==0;
    data.VPD = VPD_calc(data.RH, data.Ta);
end
% Calculate GDD if it doesn't exist:
if isfield(data,'GDD')==0;
    [junk data.GDD] = GDD_calc(data.Ta,10,48,[]);
end

%% Create Comparison of conditions of one day, and the day before it.
ind_all = (1:1:length(data.Year)-48)';
ind_d_after = (49:1:length(data.Year))';

%%% Compare PAR
PAR_diff = abs(data.PAR(ind_all)-data.PAR(ind_d_after));    n_PAR_diff = length(find(PAR_diff < PAR_tol));
%%% Compare T_air
Ta_diff = abs(data.Ta(ind_all)-data.Ta(ind_d_after));       n_Ta_diff = length(find(Ta_diff < Ta_tol));
%%% Compare Ts
Ts_diff = abs(data.Ts5(ind_all)-data.Ts5(ind_d_after));     n_Ts_diff = length(find(Ts_diff < Ts_tol));
%%% Compare WS
WS_diff = abs(data.WS(ind_all)-data.WS(ind_d_after));       n_WS_diff = length(find(WS_diff < WS_tol));
%%% Compare NEE
NEE_diff = data.NEE(ind_all)-data.NEE(ind_d_after);         
%%% Compare SM
SM_diff = abs(data.SM_a(ind_all) - data.SM_a(ind_d_after)); n_SM_diff = length(find(SM_diff < SM_tol));
%%% Compare RH
VPD_diff = abs(data.VPD(ind_all) - data.VPD(ind_d_after));  n_VPD_diff = length(find(VPD_diff < VPD_tol));
%%% Compare ustar

n_Ustar_th = length(find(data.Ustar >= Ustar_th));
%% Relationship for Respiration (i.e. Nighttime and Non-Growing Season)
ind_param_RE = find((data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 15) |... % growing season
     (data.Ustar >= Ustar_th & ~isnan(data.NEE) & data.Ts5 < -1  ) );                                   % non-growing season

 X_in = [data.Ts5(ind_param_RE) data.SM_a(ind_param_RE) data.PAR(ind_param_RE)];
 Y_in = data.NEE(ind_param_RE);
 stdev_in = ones(length(X_in),1);
 X_eval = [data.Ts5 data.SM data.PAR];

 options.costfun ='OLS'; options.min_method ='NM'; 
[c_hat_RE, y_hat_RE, pred_RE, stats_RE, sigma_RE, err_RE, exitflag_RE, num_iter_RE] = ...
    fitresp([9 0.2 12], 'fitresp_2A', X_in, Y_in, X_eval, stdev_in, options);

ind_goodpair_RE = find( (Ta_diff < Ta_tol & Ts_diff < Ts_tol & WS_diff < WS_tol & PAR_diff < PAR_tol & SM_diff < SM_tol & VPD_diff < VPD_tol & ...
                        data.Ustar(1:length(data.Ustar)-48) > Ustar_th & ~isnan(NEE_diff) & ~isnan(pred_RE(1:length(data.Ustar)-48) )) ...
                   & ( (data.PAR(1:length(data.Ustar)-48) < 15) | (data.Ts5(1:length(data.Ustar)-48) < -0.5 & data.Ta(1:length(data.Ustar)-48) < 0) ) );

%%% Calculate Error Term
stdev_RE = std(NEE_diff(ind_goodpair_RE));
error_RE = (stdev_RE.*(NEE_diff(ind_goodpair_RE))) ./ sqrt(2) ;
%%% Calculate Beta value
% Beta_RE = stdev_RE./sqrt(2);

if plot_flag == 1
%%% Create histogram of error to check distribution:
[y_RE xout_RE] = hist(error_RE,100);
figure('Name', 'Error Distribution - RE')
bar(xout_RE,y_RE)
end

if strcmp(data.site,'TP89')==1
    avg_interval = 2.5;
    avg_window = 1.25;
    min_samples = 20;
else
    avg_interval = 0.5;
    avg_window = 0.5;
    min_samples = 40;    
end

[RE_std]= jjb_mov_window_stats(pred_RE(ind_goodpair_RE),NEE_diff(ind_goodpair_RE), avg_interval, avg_window);
ind_use_RE_std = find(RE_std(:,5)>min_samples);

if plot_flag == 1

figure('Name', 'RE vs. std dev of error');
plot(RE_std(ind_use_RE_std,1),RE_std(ind_use_RE_std,4),'b.'); title('RE vs. std dev (in NEE)')
end
%% Calculate GEP from NEE and R:
GEPraw = pred_RE - data.NEE;

%%% Model GEP based on PAR, Ts, Ta, VPD, 
ind_param_GEP = find(data.Ts5 >= -5 & data.VPD > 0 & data.Ta > -5 & data.PAR > 20 & ~isnan(GEPraw) & data.Ustar > Ustar_th ...
    & data.dt > 95 & data.dt < 325 & data.GDD > 8);
% ind_param_GEP = find(data.Ts5 >= -2 & data.VPD > 0 & data.Ta > -5 & data.PAR > 20 & ~isnan(GEPraw) & data.Ustar > Ustar_th ...
%     & data.dt > 95 & data.dt < 325);
% [c_hat_GEP3, y_hat_GEP3, y_pred_GEP3, stats_GEP3 sigma_GEP3, err_GEP3, exitflag_GEP3, num_iter_GEP3] = ...
%     fitGEP([0.03 35 -0.3 7.5 -2 -0.8], 'fitGEP_1H1_1L1fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
% 
% [c_hat_GEP4, y_hat_GEP4, y_pred_GEP4, stats_GEP4 sigma_GEP4, err_GEP4, exitflag_GEP4, num_iter_GEP4] = ...
%     fitGEP([0.03 35 0 -0.3 7.5 1 1.12 0.15 -2 -0.8], 'fitGEP_1H1_1L1_2L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.Ta(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.Ta data.VPD], [], 'OLS');
% 
% [c_hat_GEP5, y_hat_GEP5, y_pred_GEP5, stats_GEP5 sigma_GEP5, err_GEP5, exitflag_GEP5, num_iter_GEP5] = ...
%     fitGEP([0.03 35 -0.15 -0.3 7.5 -2 -0.8], 'fitGEP_1H1_1L1fixed2_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
% 
% [c_hat_GEP6, y_hat_GEP6, y_pred_GEP6, stats_GEP6 sigma_GEP6, err_GEP6, exitflag_GEP6, num_iter_GEP6] = ...
%     fitGEP([0.03 35 -0.3 7.5 -0.3 7.5 -2 -0.8], 'fitGEP_1H1_2L1fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.Ta(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.Ta data.VPD], [], 'OLS');
% 
% [c_hat_GEP7, y_hat_GEP7, y_pred_GEP7, stats_GEP7 sigma_GEP7, err_GEP7, exitflag_GEP7, num_iter_GEP7] = ...
%     fitGEP([0.03 35 -0.3 7.5 -2 -0.8], 'fitGEP_1H1_1L1fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');

% [c_hat_GEPL1, y_hat_GEPL1, y_pred_GEPL1, stats_GEPL1 sigma_GEPL1, err_GEPL1, exitflag_GEPL1, num_iter_GEPL1] = ...
%     fitGEP([0.03 35 -0.3 7.5 -2 -0.8], 'fitGEP_1H1_1L1fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
% 
% [c_hat_GEPL2, y_hat_GEPL2, y_pred_GEPL2, stats_GEPL2 sigma_GEPL2, err_GEPL2, exitflag_GEPL2, num_iter_GEPL2] = ...
%     fitGEP([0.03 35 1 2 2 -2 -0.8], 'fitGEP_1H1_1L2fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
% 
% [c_hat_GEPL3, y_hat_GEPL3, y_pred_GEPL3, stats_GEPL3 sigma_GEPL3, err_GEPL3, exitflag_GEPL3, num_iter_GEPL3] = ...
%     fitGEP([0.03 35 50 -2 -0.8], 'fitGEP_1H1_1L3fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
% 
% [c_hat_GEPL5, y_hat_GEPL5, y_pred_GEPL5, stats_GEPL5 sigma_GEPL5, err_GEPL5, exitflag_GEPL5, num_iter_GEPL5] = ...
%     fitGEP([0.03 35 20 10 -2 -0.8], 'fitGEP_1H1_1L5fixed_1L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
%     GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], 'OLS');
 options.costfun ='OLS'; options.min_method ='NM'; 
[c_hat_GEPL6, y_hat_GEPL6, pred_GEP_all, stats_GEPL6 sigma_GEPL6, err_GEPL6, exitflag_GEPL6, num_iter_GEPL6] = ...
    fitGEP([0.03 35 2 4 -2 -0.8], 'fitGEP_1H1_2L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
    GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], options);

ind_GEP = find(data.PAR >= 20 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
                | data.dt > 330 & data.Ts5 >= 1.25 & data.Ta > 2));

pred_GEP(1:length(data.Year),1)= 0;
pred_GEP(ind_GEP,1) = pred_GEP_all(ind_GEP,1);

%     [c_hat_GEP, y_hat_GEP, R2_GEP, sigma_GEP] = fitmain([0.03 25 1.12 0.15 1.4 0.7 -2 -.8], 'fitlogi_GEP', ...
%         [data.PAR(ind_param_GEP) ones(length(ind_param_GEP),1) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], GEPraw(ind_param_GEP));
%     [c_hat_GEP2, y_hat_GEP2, R2_GEP2, sigma_GEP2] = fitmain([0.03 30 1.12 0.15 -.7 7 -2 -.8], 'fitlogi_GEP_logi1', ...
%         [data.PAR(ind_param_GEP) data.Ta(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], GEPraw(ind_param_GEP));
% 
%     pred_GEP = (c_hat_GEP(1)*c_hat_GEP(2)*data.PAR./(c_hat_GEP(1)*data.PAR + ...
%         c_hat_GEP(2))).* (1./(1 + exp(c_hat_GEP(3)-c_hat_GEP(4).*data.Ta))) .* ...
%         (1./(1 + exp(c_hat_GEP(5)-c_hat_GEP(6).*data.Ts5))) .* ...
%         (1./(1 + exp(c_hat_GEP(7)-c_hat_GEP(8).*data.VPD)));

ind_goodpair_GEP = find(Ta_diff < Ta_tol & Ts_diff < Ts_tol & WS_diff < WS_tol & PAR_diff < PAR_tol & SM_diff < SM_tol & VPD_diff < VPD_tol  ...
                   & data.Ustar(1:length(data.Ustar)-48) > Ustar_th./2 &  ~isnan(NEE_diff) & ~isnan(pred_GEP(1:length(pred_GEP)-48)) ...
                   &  data.PAR(1:length(data.Ustar)-48) > 20 & data.Ts5(1:length(data.Ustar)-48) > 2 & data.Ta(1:length(data.Ustar)-48) > 2 ...
                   & data.VPD(1:length(data.VPD)-48) > 0 & data.dt(1:length(data.dt)-48) > 95 & data.dt(1:length(data.dt)-48) < 325 ...
                   & data.GDD(1:length(data.dt)-48) > 10);

%                              
%%% Calculate Error Term
stdev_GEP = std(NEE_diff(ind_goodpair_GEP));
error_GEP = (stdev_GEP.*(NEE_diff(ind_goodpair_GEP))) ./ sqrt(2) ;
%%% Calculate Beta value
% Beta_RE = stdev_RE./sqrt(2);

if plot_flag == 1

%%% Create histogram of error to check distribution:
[y_GEP xout_GEP] = hist(error_GEP,100);
figure('Name', 'Error Distribution - GEP')
bar(xout_GEP,y_GEP)
end

[GEP_std]= jjb_mov_window_stats(pred_GEP(ind_goodpair_GEP),NEE_diff(ind_goodpair_GEP), avg_interval, avg_window);
ind_use_GEP_std = find(GEP_std(:,5)>min_samples);
% else
% [GEP_std]= jjb_mov_window_stats(pred_GEP(ind_goodpair_GEP),NEE_diff(ind_goodpair_GEP), 0.5, 0.5);
% ind_use_GEP_std = find(GEP_std(:,5)>30);
% end
if plot_flag == 1
figure('Name', 'GEP vs. std dev of error');
plot(GEP_std(ind_use_GEP_std,1),GEP_std(ind_use_GEP_std,4),'b.'); title('GEP vs. std dev (in NEE)')
end

GEP_std(:,1) = GEP_std(:,1).*-1;
NEE_std = [GEP_std ; RE_std];
[B IX] = sort(NEE_std,1,'descend');
NEE_std = NEE_std(IX(:,1),:);
ind_use_NEE_std = find(NEE_std(:,5)>min_samples);
if plot_flag == 1

figure('Name', 'NEE vs. std dev');
plot(NEE_std(ind_use_NEE_std,1),NEE_std(ind_use_NEE_std,4),'b.'); title('NEE vs. std dev (in NEE)'); hold on;
end

% kurt_GEP = kurtosis(error_GEP)
% kurt_RE = kurtosis(error_RE)
% skew_GEP = skewness(error_GEP)
% skew_RE = skewness(error_RE)

% figure(20);clf;
% plot(pred_GEP(ind_goodpair_GEP),NEE_diff(ind_goodpair_GEP),'g.');
% hold on;
% plot(pred_RE(ind_goodpair_RE),NEE_diff(ind_goodpair_RE),'r.')
NEE_pred = pred_RE - pred_GEP;
%% Fit lines through trends on both sides of 0:
% 1. RE:
ind_RE_std = find(NEE_std(:,1) > 0 & NEE_std(:,5) > min_samples);
M_RE = [ones(length(ind_RE_std),1), NEE_std(ind_RE_std,1)];
coeff_RE = M_RE\NEE_std(ind_RE_std,4); % first is intercept, second is slope
RE_std_pred = coeff_RE(1) + NEE_std(ind_RE_std,1).*coeff_RE(2);
if plot_flag == 1
plot(NEE_std(ind_RE_std,1),RE_std_pred,'r--')
end
% 2. GEP:
ind_GEP_std = find(NEE_std(:,1) < 0 & NEE_std(:,5) > min_samples);
M_GEP = [ones(length(ind_GEP_std),1), NEE_std(ind_GEP_std,1)];
coeff_GEP = M_GEP\NEE_std(ind_GEP_std,4); % first is intercept, second is slope
GEP_std_pred = coeff_GEP(1) + NEE_std(ind_GEP_std,1).*coeff_GEP(2);
if plot_flag == 1
plot(NEE_std(ind_GEP_std,1),GEP_std_pred,'r--')
end
%% Now, predict std for every data point, depending on whether we expect positive or negative
%%% NEE
ind_pos_NEE = find(NEE_pred >=0);
std_pred(ind_pos_NEE,1) = coeff_RE(1) + NEE_pred(ind_pos_NEE).*coeff_RE(2);

ind_neg_NEE = find(NEE_pred < 0);
std_pred(ind_neg_NEE,1) = coeff_GEP(1) + NEE_pred(ind_neg_NEE).*coeff_GEP(2);

if isnan(std_pred(1,1))==1;
    std_pred(1:8,1) = std_pred(9,1);
end

if ~isempty(find(isnan(std_pred)))==1
disp(['number of nans in predicted std = ' num2str(length(find(isnan(std_pred))))]);
end
