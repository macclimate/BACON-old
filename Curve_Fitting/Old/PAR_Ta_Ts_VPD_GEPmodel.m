function [GEP_model GEPraw pw coeff] = PAR_Ta_Ts_VPD_GEPmodel(data, RE_in, SM, stdev, s_star, Ustar_th, param_flag, constraint, day_constraints)



if nargin == 8 || isempty(day_constraints)
    day_constraints = [0 367];
end
% test_Ts = (-5:1:30)';
% test_PAR = (0:100:2500)';
% clrs = [1 0 0; 0.5 0 0; 0 1 0; 0.8 0.5 0.7; 0 0 1; 0.2 0.1 0.1; ...
%     1 1 0; 0.4 0.5 0.1; 1 0 1; 0.9 0.9 0.4; 0 1 1; 0.4 0.8 0.1];

%% GEP calculation:
GEPraw = RE_in - data.NEE;
GEPraw(data.PAR<20) = NaN;
GEPraw(data.Ustar < Ustar_th) = NaN; % do ustar filtering during the day
GEP_pred = NaN.*ones(length(GEPraw),1);
year_start = min(data.Year);
year_end = max(data.Year);
% Calculate VPD if it doesn't exist
if isfield(data,'VPD')==0;
    data.VPD = VPD_calc(data.RH, data.Ta);
end
data.VPD(data.VPD < 0) = 0;

if strcmp(param_flag,'all')==1

%         ind_GEP_param = find(data.Ts5 > 0.5 & data.Ta > 0 & data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
%             data.Ustar > Ustar_th & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) & ~isnan(SM));
           ind_GEP_unconstrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2)  & ~isnan(stdev));
           
            ind_GEP_constrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2) & SM > s_star & ~isnan(stdev));
        
        if strcmp(constraint,'on') == 1
            ind_GEP_param = ind_GEP_constrained;
        else
            ind_GEP_param = ind_GEP_unconstrained;            
        end
        
        [coeff, Y_hat, R2, sigma] = fitmain([0.03 25 1.12 0.15 1.4 0.7 -2 -.8], 'fitlogi_GEP', ...
            [data.PAR(ind_GEP_param) data.Ta(ind_GEP_param) data.Ts5(ind_GEP_param) data.VPD(ind_GEP_param)], ...
            GEPraw(ind_GEP_param), stdev(ind_GEP_param,1));

        GEP_pred = (coeff(1)*coeff(2)*data.PAR./(coeff(1)*data.PAR + ...
            coeff(2))).* (1./(1 + exp(coeff(3)-coeff(4).*data.Ta))) .* ...
            (1./(1 + exp(coeff(5)-coeff(6).*data.Ts5))) .* ...
            (1./(1 + exp(coeff(7)-coeff(8).*data.VPD)));
    
elseif isnumeric(param_flag)==1        
            ind_GEP_unconstrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2)  & ~isnan(stdev) ...
             & data.Year >= min(param_flag) & data.Year <= max(param_flag));
           
            ind_GEP_constrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2) & SM > s_star & ~isnan(stdev) ...
             & data.Year >= min(param_flag) & data.Year <= max(param_flag));
        
        if strcmp(constraint,'on') == 1
            ind_GEP_param = ind_GEP_constrained;
        else
            ind_GEP_param = ind_GEP_unconstrained;            
        end
        
        [coeff, Y_hat, R2, sigma] = fitmain([0.03 25 1.12 0.15 1.4 0.7 -2 -.8], 'fitlogi_GEP', ...
            [data.PAR(ind_GEP_param) data.Ta(ind_GEP_param) data.Ts5(ind_GEP_param) data.VPD(ind_GEP_param)], ...
            GEPraw(ind_GEP_param), stdev(ind_GEP_param,1));

        GEP_pred = (coeff(1)*coeff(2)*data.PAR./(coeff(1)*data.PAR + ...
            coeff(2))).* (1./(1 + exp(coeff(3)-coeff(4).*data.Ta))) .* ...
            (1./(1 + exp(coeff(5)-coeff(6).*data.Ts5))) .* ...
            (1./(1 + exp(coeff(7)-coeff(8).*data.VPD)));
  
        
else

    ctr = 1;
    for year = year_start:1:year_end

%         ind_GEP_param = find(data.PAR > 20 & data.VPD > 0 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
%             data.Ustar > Ustar_th & ~isnan(data.VPD) &  ~isnan(data.PAR) & ~isnan(data.Ta) & ~isnan(SM) & data.Year == year);
%            ind_GEP_param = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
%             data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) & ~isnan(SM) ...
%             & data.dt >day_constraints(1) & data.dt < day_constraints(2) & data.Year == year);
           
        ind_GEP_unconstrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2) & data.Year == year & ~isnan(stdev));
           
            ind_GEP_constrained = find(data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
            data.Ustar > Ustar_th & data.VPD > 0 & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) ...
            & data.dt >day_constraints(1) & data.dt < day_constraints(2) & SM > s_star & data.Year == year & ~isnan(stdev));
        
        if strcmp(constraint,'on') == 1
            ind_GEP_param = ind_GEP_constrained;
        else
            ind_GEP_param = ind_GEP_unconstrained;            
        end

%         ind_GEP_param = find(data.PAR > 20 & data.VPD > 0 & ~isnan(data.Ts5) & ~isnan(GEPraw) & data.dt > 100 & data.dt < 300 & ...
%             data.Ustar > Ustar_th & ~isnan(data.VPD) &  ~isnan(data.PAR) & ~isnan(data.Ta) & ~isnan(SM) & data.Year == year);

        % ind_GEP_param2 = find(data.Ts5 > 0.5 & data.Ta > 0 & data.PAR > 20 & ~isnan(data.Ts5) & ~isnan(GEPraw) & ...
        %     data.Ustar > Ustar_th & ~isnan(data.VPD) & ~isnan(data.PAR) & ~isnan(data.Ta) & SM > s_star);


        % [P.gep_par_coeff P.gep_par_y P.gep_par_r2 P.gep_par_sigma] = hypmain1([0.03 25 ], 'fit_hyp1', data.PAR(ind_GEP_param), GEPraw(ind_GEP_param));

        [coeff(ctr,:), Y_hat, R2, sigma] = fitmain([0.03 25 1.12 0.15 1.4 0.7 -2 -.8], 'fitlogi_GEP', ...
            [data.PAR(ind_GEP_param) data.Ta(ind_GEP_param) data.Ts5(ind_GEP_param) data.VPD(ind_GEP_param)], ...
            GEPraw(ind_GEP_param), stdev(ind_GEP_param,1));

        GEP_pred(data.Year == year,1) = (coeff(ctr,1)*coeff(ctr,2)*data.PAR(data.Year == year)./(coeff(ctr,1)*data.PAR(data.Year == year) + ...
            coeff(ctr,2))).* (1./(1 + exp(coeff(ctr,3)-coeff(ctr,4).*data.Ta(data.Year == year)))) .* ...
            (1./(1 + exp(coeff(ctr,5)-coeff(ctr,6).*data.Ts5(data.Year == year)))) .* ...
            (1./(1 + exp(coeff(ctr,7)-coeff(ctr,8).*data.VPD(data.Year == year))));
        ctr = ctr+1;
        clear Y_hat R2 sigma ind_GEP_param
    end

end
% GEPmeas/GEPpred
GEP_model = GEP_pred; 
clear GEP_pred;
pw = jjb_make_rw_pw(GEPraw,GEP_model, 72, 1); % 48 changed from 96....

%%% Stats for the model:
[RMSE_GEP rRMSE_GEP MAE_GEP BE_GEP] = model_stats(GEP_model, GEPraw,'off');
disp(['RMSE_GEP = ' num2str(RMSE_GEP) '; MAE_GEP = ' num2str(MAE_GEP) '; BE_GEP = ' num2str(BE_GEP)]);