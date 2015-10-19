site = 'TP39';
%%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
data = trim_data_files(data,2003, 2009,1);
data.site = site;
data.SM = data.SM_a_filled;
close all
    Rraw = NaN.*data.NEE;
    data.Ustar_th = 0.3.*ones(length(data.Ustar),1);
NEE_clean(data.PAR < 15 & data.Ustar < data.Ustar_th, 1) = NaN;

    ind_Rraw = find((data.Ustar >= data.Ustar_th & ~isnan(data.NEE) & data.PAR < 15 & data.Year == 2006) |... % growing season
        (data.Ustar >= data.Ustar_th & ~isnan(data.NEE) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)) & ~isnan(data.SM) & data.Year == 2006 );                             % non-growing season

Rraw(ind_Rraw) = data.NEE(ind_Rraw);

R_param = Rraw(ind_Rraw);
Ts_param = data.Ts5(ind_Rraw);
SM_param = data.SM(ind_Rraw);

options.costfun ='OLS'; options.min_method ='NM';
[c_hat, y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = ...
    fitresp([2 3], 'fitresp_3A', Ts_param , R_param, data.Ts5(data.Year == 2006), [], options);

resid = R_param - y_hat;
bins = (-20:1:20)';
[n xout] = hist(resid, bins);

%%% Make random noise using idea of normally distributed residuals:
std_Re = std(resid);
Re_noise = random('norm',0,std_Re,17520,100);
[n2 xout2] = hist(Re_noise(:,1), bins);

figure(1);clf
bar(bins, n2/length(Re_noise), 'FaceColor', [1 0 0]);hold on;
bar(bins,n/length(resid)); hold on;

c_hat_sim = NaN.*ones(100,2);
y_pred_sim = NaN.*ones(length(Ts_param),100);
stats_sim = NaN.*ones(100,4);
err_sim = NaN.*ones(100,1);
for i = 1:1:100
    y_sim = y_pred + Re_noise(:,i);
    [c_hat_tmp, y_hat_tmp, y_pred_tmp, stats_tmp, sigma_tmp, err_tmp, exitflag_tmp, num_iter_tmp] = ...
    fitresp([2 3], 'fitresp_3A', data.Ts5(data.Year == 2006) , y_sim, data.Ts5(data.Year == 2006), [], options);

c_hat_sim(i,1:2) = c_hat_tmp;
y_pred_sim(1:17520,i) = y_pred_tmp;
stats_sim(i,1:4) = [stats_tmp.RMSE stats_tmp.MAE stats_tmp.BE stats_tmp.R2];
err_sim(:,1) = err_tmp;
clear *_tmp;
end


