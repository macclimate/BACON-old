function [std_pred] = NEE_random_error_estimator_v3(data,tol, Ustar_th, plot_flag)

if nargin < 4
    plot_flag = 0;
end

if ~isfield(data, 'site') 
    data.site = input('Enter Site Name: ', 's');
end

% Calculate VPD if it doesn't exist
if isfield(data,'VPD')==0;
    data.VPD = VPD_calc(data.RH, data.Ta);
end
% Calculate GDD if it doesn't exist:
if isfield(data,'GDD')==0;
    [junk data.GDD] = GDD_calc(data.Ta,10,48,[]);
end

%% Relationship for Respiration (i.e. Nighttime and Non-Growing Season)
% ind_param_RE = find((data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 15) |... % growing season
%      (data.Ustar >= Ustar_th & ~isnan(data.NEE) & data.Ts5 < -1  ) );                                   % non-growing season
ind_param_RE = find(data.Ustar >= data.Ustar_th & data.RE_flag == 2 & ~isnan(data.Ts5.*data.NEE));


 X_in = [data.Ts5(ind_param_RE) data.SM_a(ind_param_RE) data.PAR(ind_param_RE)];
 Y_in = data.NEE(ind_param_RE);
 stdev_in = ones(length(X_in),1);
 X_eval = [data.Ts5 data.SM data.PAR];

 options.costfun ='OLS'; options.min_method ='NM'; options.f_coeff = [NaN NaN NaN];
[c_hat_RE, y_hat_RE, pred_RE, stats_RE, sigma_RE, err_RE, exitflag_RE, num_iter_RE] = ...
    fitresp([9 0.2 12], 'fitresp_2A', X_in, Y_in, X_eval, stdev_in, options);

               
%%% In this version, we'll try and just use model residuals to give us an
%%% idea of the spread of the data:
error_RE = Y_in - y_hat_RE;

if plot_flag == 1
figure('Name', 'Error Distribution - RE')
subplot(211)
%%% Create histogram of error to check distribution:
[y_RE xout_RE] = hist(error_RE,100);
bar(xout_RE,y_RE)
ylabel('count');
xlabel('Error Bins');

subplot(212);
%%% Create scatterplot -- let's see if data is homoscedastic:
plot(y_hat_RE, error_RE,'b.');
xlabel('Predicted RE value');
ylabel('Error');
axis([0 20 -10 10]);
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

%%% Output of jjb_mov_window_stats:
% 1 - Centre of window for x
% 2 - Centre of y for window
% 3 - Median of y for window
% 4 - Stdev  of y for window
% 5 - # of y pts used in window
[RE_std]= jjb_mov_window_stats(y_hat_RE,error_RE, avg_interval, avg_window);
ind_use_RE_std = find(RE_std(:,5)>min_samples);

if plot_flag == 1
figure('Name', 'RE vs. std dev of error');
plot(RE_std(ind_use_RE_std,1),RE_std(ind_use_RE_std,4),'b.'); title('RE vs. std dev (in NEE)')
end

%% Calculate GEP from NEE and R:
GEPraw = pred_RE - data.NEE;

%%% Model GEP based on PAR, Ts, Ta, VPD, 
% ind_param_GEP = find(data.Ts5 >= -1 & data.VPD > 0 & data.Ta > -5 & data.PAR > 20 & ~isnan(GEPraw) & data.Ustar > Ustar_th ...
%     & data.dt > 95 & data.dt < 325 & data.GDD > 8);
        ind_param_GEP = find(~isnan(GEPraw.*data.Ts5.*data.PAR) & data.GEP_flag==2 & data.VPD > 0 & data.Ustar > data.Ustar_th);      
               
 options.costfun ='OLS'; options.min_method ='NM'; options.f_coeff = NaN.*ones(1,6);
[c_hat_GEPL6, y_hat_GEPL6, pred_GEP_all, stats_GEPL6 sigma_GEPL6, err_GEPL6, exitflag_GEPL6, num_iter_GEPL6] = ...
    fitGEP([0.05 35 2 4 -2 -0.8], 'fitGEP_1H1_2L6', [data.PAR(ind_param_GEP) data.Ts5(ind_param_GEP) data.VPD(ind_param_GEP)], ... 
    GEPraw(ind_param_GEP), [data.PAR data.Ts5 data.VPD], [], options);
           
% ind_GEP = find(data.PAR >= 20 & ((data.dt > 85 & data.dt < 330 & (data.GDD > 8 | data.Ts5 >= 1 & data.Ta > 2)) ...
%                 | data.dt > 330 & data.Ts5 >= 1.25 & data.Ta > 2));
        ind_GEP = find(data.GEP_flag>=1);
pred_GEP(1:length(data.Year),1)= 0;
pred_GEP(ind_GEP,1) = pred_GEP_all(ind_GEP,1);

%%% Error in GEP prediction
error_GEP = GEPraw(ind_param_GEP) - y_hat_GEPL6;

if plot_flag == 1
figure('Name', 'Error Distribution - GEP')
subplot(211)
%%% Create histogram of error to check distribution:
[y_GEP xout_GEP] = hist(error_GEP,100);
bar(xout_GEP,y_GEP)
ylabel('count');
xlabel('Error Bins');

subplot(212);
%%% Create scatterplot -- let's see if data is homoscedastic:
plot(y_hat_GEPL6, error_GEP,'b.');
xlabel('Predicted RE value');
ylabel('Error');
axis([0 40 -10 10]);
end

%%% Output of jjb_mov_window_stats:
% 1 - Centre of window for x
% 2 - Centre of y for window
% 3 - Median of y for window
% 4 - Stdev  of y for window
% 5 - # of y pts used in window
[GEP_std]= jjb_mov_window_stats(y_hat_GEPL6,error_GEP, avg_interval, avg_window);
ind_use_GEP_std = find(GEP_std(:,5)>min_samples);

if plot_flag == 1
figure('Name', 'GEP vs. std dev of error');
plot(GEP_std(ind_use_GEP_std,1),GEP_std(ind_use_GEP_std,4),'b.'); title('GEP vs. std dev (in NEE)')
end

%% Put together the estimated error in GEP and RE to span all of NEE:
GEP_std(:,1) = GEP_std(:,1).*-1;
NEE_std = [GEP_std ; RE_std];
[B IX] = sort(NEE_std,1,'descend');
NEE_std = NEE_std(IX(:,1),:);
ind_use_NEE_std = find(NEE_std(:,5)>min_samples);

if plot_flag == 1
figure('Name', 'NEE vs. std dev');
plot(NEE_std(ind_use_NEE_std,1),NEE_std(ind_use_NEE_std,4),'b.'); title('NEE vs. std dev (in NEE)'); hold on;
end

%% Fit lines through trends on both sides of 0:
NEE_pred = pred_RE - pred_GEP;
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
