function [R_model Rraw rw coeff] = Ts_SM_RE_logistic(data, SM, stdev,Ustar_th, param_flag, day_constraints)
%% Ts_SM_RE_logistic.m
%%% This function allows the user to model ecosystem respiration using both
%%% Ts and SM.  The user has the option to parameterize each year
%%% individually (param_flag = 'single'), or all years at the same time
%%% (param_flag = 'all').  
% usage: [R_model Rraw rw] = Ts_SM_RE_logistic(data, SM, Ustar_th, param_flag)
%
% outputs:
% R_model -> modeled respiration.
% Rraw --> raw respiration (ustar threshold passing)
% rw ---> moving-window derived ratio of Rmodel/Rraw 
% coeff --> values of coefficients 
%
% inputs:
% data --> structure variable with all necessary data of same length in
% branch down from data (e.g. data.Ta, data.Year, etc)
% SM --> column vector of selected SM variable (same length as all vars in
%           data)
% Ustar_th --> u* threshold
% param_flag --> set as 'single' or 'all' for parameterizing year-by-year,
%               or based on all data, respectively.
%
% Created Feb 20, 2010 by JJB.

% ===== Revision History =============
%
%
%
% ====================================

if nargin > 6
    disp('You don''t need to include a setting for ''constraint'' in this function, or s_star. ');
    return
end
if nargin == 5 || isempty(day_constraints)
    day_constraints = [0 367];
end

% test_Ts = (-5:1:30)';
% clrs = [1 0 0; 0.5 0 0; 0 1 0; 0.8 0.5 0.7; 0 0 1; 0.2 0.1 0.1; ...
%     1 1 0; 0.4 0.5 0.1; 1 0 1; 0.9 0.9 0.4; 0 1 1; 0.4 0.8 0.1];
% figure(88);clf;
%%% Make variable Rraw - Raw Respiration
Rraw(1:length(data.NEE),1) = NaN;
R.est_Ts(1:length(data.NEE),1) = NaN;

%%% Establish R_raw - now doing it outside of loop for case where only
%%% parameterizing by a couple years from whole set of data:
ind_Rraw = find(data.Ustar >= Ustar_th & ~isnan(data.NEE) & data.PAR < 20 & data.NEE > -5);
  Rraw(ind_Rraw,1) = data.NEE(ind_Rraw,1);
 
%%% Start and end years
year_start = min(data.Year);
year_end = max(data.Year);

%% Parameterizes for all years at once:
if strcmp(param_flag,'all') == 1;

    % The index for all raw data:
    ind_resp_gs = find(data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 20 ...
    & data.NEE > -5 & data.Ts5 >= -5 & ~isnan(SM) & ~isnan(stdev) & data.dt >day_constraints(1) & data.dt < day_constraints(2));
    ind_param = ind_resp_gs;
    % The index for unconstrained SM periods - used to parameterize:
    %     ind_constrained = find(data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 20 & data.NEE > -5 & data.Ts5 >= -5 & SM >= s_star);
    %
    %     if strcmp(constraint,'on') == 1;
    %         ind_param = ind_constrained;
    %     else
    %         ind_param = ind_resp_gs;
    %     end

    % Raw, good data (unconstrained or not):
%     Rraw(ind_resp_gs,1) = data.NEE(ind_resp_gs);

    % 1. Fit Logistic curve between RE and Ts for all selected years:
    [coeff,R.y,R.r2,R.sigma] = fitmain([10 .1 10 8 180], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1),stdev(ind_param,1));
%         [coeff,R.y,R.r2,R.sigma] = fitmain([10 .3 10 43 376], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1));
    % Estimate Respiration for all days, all years:
    R.est_Ts_SM(:,1)=((coeff(1))./(1 + exp(coeff(2).*(coeff(3)-data.Ts5)))) ...
        .* (1./(1 + exp(coeff(4)-coeff(5).*SM)));

    
elseif isnumeric(param_flag)==1
    ind_resp_gs = find(data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 20 ...
    & data.NEE > -5 & data.Ts5 >= -5 & ~isnan(SM) & ~isnan(stdev) & data.Year >= min(param_flag) & data.Year <= max(param_flag)...
    & data.dt >day_constraints(1) & data.dt < day_constraints(2));
    ind_param = ind_resp_gs;
    % The index for unconstrained SM periods - used to parameterize:
    %     ind_constrained = find(data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 20 & data.NEE > -5 & data.Ts5 >= -5 & SM >= s_star);
    %
    %     if strcmp(constraint,'on') == 1;
    %         ind_param = ind_constrained;
    %     else
    %         ind_param = ind_resp_gs;
    %     end

    % Raw, good data (unconstrained or not):
%     Rraw(ind_resp_gs,1) = data.NEE(ind_resp_gs);

    % 1. Fit Logistic curve between RE and Ts for all selected years:
    [coeff,R.y,R.r2,R.sigma] = fitmain([10 .3 10 8 180], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1),stdev(ind_param,1));
%         [coeff,R.y,R.r2,R.sigma] = fitmain([10 .3 10 43 376], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1));
    % Estimate Respiration for all days, all years:
    R.est_Ts_SM(:,1)=((coeff(1))./(1 + exp(coeff(2).*(coeff(3)-data.Ts5)))) ...
        .* (1./(1 + exp(coeff(4)-coeff(5).*SM)));
    
    %% Parameterizes one year at a time:
else
    ctr = 1;
    for year = year_start:1:year_end
        %%%% Make index for useable respiration data find useable growing-season data
        ind_resp_gs = find(data.Year == year & data.Ustar >= Ustar_th & ~isnan(data.Ts5) ...
            & ~isnan(data.NEE) & data.PAR < 20 & data.NEE > -5 & data.Ts5 >= -5  & ~isnan(SM)  & ~isnan(stdev) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2));
        ind_param = ind_resp_gs;
        %         ind_constrained = find(data.Year == year & data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.PAR < 20 & data.NEE > -5 & data.Ts5 >= -5 & SM >= s_star);
%         if strcmp(constraint,'on') == 1;
%             ind_param = ind_constrained;
%         else
%             ind_param = ind_resp_gs;
%         end

        %%%% find useable non-growing-season data
        % ind_resp_nongs = find(data.Ustar >= Ustar_th & ~isnan(data.Ts5) & ~isnan(data.NEE) & data.Ts5 < 0 & SM >= s_star);
        % ind_resp = sort([ind_resp_gs; ind_resp_nongs]);
        %         ind_resp = ind_resp_gs;

%         Rraw(ind_resp_gs,1) = data.NEE(ind_resp_gs);

        %%%%%%%%%%%%%% Model Respiration
        % 1. Fit Logistic curve between RE and Ts for all selected years:
        [coeff(ctr,:),R.y,R.r2,R.sigma] = fitmain([10 .3 10 8 180], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1),stdev(ind_param,1));
%         [coeff(ctr,:),R.y,R.r2,R.sigma] = fitmain([10 .3 10 43 376], 'fitlogi_R_Ts_SM', [data.Ts5(ind_param,1) SM(ind_param,1)], data.NEE(ind_param,1));
        %       [R.coeff,R.y,R.r2,R.sigma] = fitmain([10 .3 10], 'fitlogi5', data.Ts5(ind_param,1), data.NEE(ind_param,1));
        % Estimate Respiration for all days, all years:
        R.est_Ts_SM(data.Year==year,1)=((coeff(ctr,1))./(1 + exp(coeff(ctr,2).*(coeff(ctr,3)-data.Ts5(data.Year==year))))) ...
            .* (1./(1 + exp(coeff(ctr,4)-coeff(ctr,5).*SM(data.Year==year))));

        % % %%%%%%% Respiration for plotting:
        % test_R = R.coeff(1)./(1+exp(R.coeff(2)*(R.coeff(3)-test_Ts)));
        % figure(88);
        % plot(data.Ts5(ind_resp),Rraw(ind_resp),'k.'); hold on;
        % h(ctr) = plot(test_Ts, test_R,'-','Color',clrs(ctr,:), 'LineWidth',2);
        % grid on;
        % yr_str(ctr,:) = num2str(year);
        ctr = ctr+1;

        clear test_R ind_resp ind_resp_gs ind_constrained ind_param
    end

end
% legend(h,yr_str);

%% %%%% Ratio of measured to modeled value: %%%%%%%%%%%
% R.rw_Ts = jjb_AB_gapfill(R.est_Ts, Rraw, (1:1:length(R.est_Ts))',200, 10, 'off', [], [], 'rw');
R_model = R.est_Ts_SM;
rw = jjb_make_rw_pw(Rraw,R_model, 72, 1); % 48 changed from 96....
% RE_est_Ts_rw = R.est_Ts .* R.rw_Ts(:,2);



% figure('Name', 'RE_{raw} / RE_{model}, r_w'); clf
% plot(R.rw_Ts);hold on;

% %%% Stats for each model:
[RMSE_Ts rRMSE_Ts MAE_Ts BE_Ts] = model_stats(R_model, Rraw,'off');
%
disp('RMSE,            MAE,             BE');
[RMSE_Ts MAE_Ts BE_Ts]
% rw = R.rw_Ts;