function [] = test_REparam_TP39()

ls = addpath_loadstart;
% ls = '/work/brodeujj/';

sites = {'TP39'};
coeff_LH_logi = [3 10; 0.01 0.5; 4 20; 1 20; 20 300];
coeff_LH_Q10 = [0.5 6; 0.1 5; 1 20; 20 300];

num_MC = 100;

for site_ctr = 1:1:length(sites)
    site = sites{site_ctr,1};
    path = [ls 'Matlab/Data/Master_Files/' site '/'];
    save_path = [ls 'Matlab/Data/Error/Param_test/'];
    diary_path =[ls '/Matlab/Standalone/Param_test/' site '/'];
    diary([diary_path site '_log_' datestr(now,30) '.txt']);
    % load master file, trim it to 2003--2010:
    load([path site '_SM_analysis_data.mat']);
    data.site = site;
    data = trim_data_files(data,2003,2010,1);
    data.costfun = 'WSS';
    
    %%% %%%%%%%%%%%%%%%%%%%%%%%
    % Find where each year starts
    ctr = 1;
    for yr = 2003:1:2010
        yr_starts(ctr,1) = find(data.Year==yr,1,'first');
        ctr = ctr + 1;
    end
    yr_starts(ctr) = length(data.Year)+1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Estimate Ustar Threshold:
    data.Ustar_th = mcm_Ustar_th_JJB(data,0);
    % data2.Ustar_th = mcm_Ustar_th_JJB(data2,1);
    
    % Estimate Standard Deviation of NEE:
    data.NEE_std = NEE_random_error_estimator_v6(data,[],[],0);
    
    % Create an index of raw RE data to use for parameterization:
    ind_param_REall = find(data.Ustar >= data.Ustar_th & data.RE_flag == 2 & ...
        ~isnan(data.Ts5.*data.SM_a_filled.*data.NEE.*data.NEE_std) & data.NEE > -7);
    
%     coeff_in_logi = NaN.*ones(num_MC,5);    coeff_out_logi = NaN.*ones(num_MC,5);
%     exitflag_logi= NaN.*ones(num_MC,1); WrRMSE_logi= NaN.*ones(num_MC,1);
%     WESS_logi= NaN.*ones(num_MC,1);     BE_logi= NaN.*ones(num_MC,1);
%     RE_sums_logi = NaN.*ones(num_MC,8);
%     
%     coeff_in_Q10 = NaN.*ones(num_MC,4); coeff_out_Q10 = NaN.*ones(num_MC,4);
%     exitflag_Q10= NaN.*ones(num_MC,1); WrRMSE_Q10= NaN.*ones(num_MC,1);
%     WESS_Q10= NaN.*ones(num_MC,1);     BE_Q10= NaN.*ones(num_MC,1);
%     RE_sums_Q10 = NaN.*ones(num_MC,8);
%     
master.tmp = struct;
    %% Run Monte-Carlo:
 tic;           
    for MC = 1:1:num_MC
        master.tmp.coeff_in_logi(MC,1:5) = rand(5,1).*(coeff_LH_logi(:,2)-coeff_LH_logi(:,1)) + coeff_LH_logi(:,1);
        master.tmp.coeff_in_Q10(MC,1:4) = rand(4,1).*(coeff_LH_Q10(:,2)-coeff_LH_Q10(:,1)) + coeff_LH_Q10(:,1);
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_logi(MC,1:5), 'fitresp_2B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_logi(MC,1:5) =  c_hat_RE_tmp;
        master.tmp.exitflag_logi(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_logi(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_logi(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_logi(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_logi(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_Q10(MC,1:4), 'fitresp_3B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_Q10(MC,1:4) =  c_hat_RE_tmp;
        master.tmp.exitflag_Q10(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_Q10(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_Q10(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_Q10(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_Q10(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_logi(MC,1:3), 'fitresp_2A', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_logi_Ts(MC,1:3) =  c_hat_RE_tmp;
        master.tmp.exitflag_logi_Ts(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_logi_Ts(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_logi_Ts(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_logi_Ts(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_logi_Ts(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_Q10(MC,1:2), 'fitresp_3A', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_Q10_Ts(MC,1:2) =  c_hat_RE_tmp;
        master.tmp.exitflag_Q10_Ts(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_Q10_Ts(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_Q10_Ts(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_Q10_Ts(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_Q10_Ts(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
       clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM'; options.f_coeff = [5 NaN.*ones(1,4)];
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_logi(MC,2:5), 'fitresp_2B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_logi_cTf(MC,1:5) =  c_hat_RE_tmp;
        master.tmp.exitflag_logi_cTf(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_logi_cTf(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_logi_cTf(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_logi_cTf(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_logi_cTf(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';options.f_coeff = [2 NaN.*ones(1,3)];
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_Q10(MC,2:4), 'fitresp_3B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_Q10_cTf(MC,1:4) =  c_hat_RE_tmp;
        master.tmp.exitflag_Q10_cTf(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_Q10_cTf(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_Q10_cTf(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_Q10_cTf(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_Q10_cTf(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);

       clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM'; options.f_coeff = [NaN.*ones(1,3) 8 NaN];
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_logi(MC,[1:3 5]), 'fitresp_2B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_logi_cSf(MC,1:5) =  c_hat_RE_tmp;
        master.tmp.exitflag_logi_cSf(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_logi_cSf(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_logi_cSf(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_logi_cSf(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_logi_cSf(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        clear *_tmp options; options.costfun =data.costfun; options.min_method ='NM';options.f_coeff = [NaN.*ones(1,2) 8 NaN];
        [c_hat_RE_tmp, y_hat_RE_tmp, y_pred_RE_tmp, stats_RE_tmp, sigma_RE_tmp, err_RE_tmp, exitflag_RE_tmp, num_iter_RE_tmp] = ...
            fitresp(master.tmp.coeff_in_Q10(MC,[1:2 4]), 'fitresp_3B', [data.Ts5(ind_param_REall) data.SM_a_filled(ind_param_REall)] , data.NEE(ind_param_REall), [data.Ts5 data.SM_a_filled], data.NEE_std(ind_param_REall), options);
        master.tmp.coeff_out_Q10_cSf(MC,1:4) =  c_hat_RE_tmp;
        master.tmp.exitflag_Q10_cSf(MC,1) = exitflag_RE_tmp;
        master.tmp.WrRMSE_Q10_cSf(MC,1) = stats_RE_tmp.WrRMSE;
        master.tmp.WESS_Q10_cSf(MC,1) = stats_RE_tmp.WESS;
        master.tmp.BE_Q10_cSf(MC,1) = stats_RE_tmp.BE;
        master.tmp.RE_sums_Q10_cSf(MC,1:8) = calc_ann_sums(yr_starts, y_pred_RE_tmp);
        
        clear *_tmp;
        
        if rem(MC,5)==0
            t = toc;
           disp([num2str(MC) ' runs completed in ' num2str(t) ' seconds.']); 
           tic;
        end
    end
    
    
end
%%
%%% Output the results.

site_tmp = site;
eval([site_tmp ' =  master.tmp;']);
save([save_path site '_param_test.mat'],site_tmp);

clear site_tmp master;

diary off;

end

%%
function [ann_sums] = calc_ann_sums(yr_starts, RE_in)
ann_sums = NaN.*ones(1,length(yr_starts)-1);
for i = 1:1:length(yr_starts)-1
    ann_sums(1,i) = sum(RE_in(yr_starts(i):yr_starts(i+1)-1,1)).*0.0216;
end
end
