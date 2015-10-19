%%% Load the data:
clear all; close all
%%% Enter the path where the master data file is (note that right now it is
%%% set as one directory above the folder /Cleaned_Efflux/, where the 
%%% chamber data is:
path = '/home/brodeujj/1/fielddata/Matlab/Data/Emily/';
%%% Load data from the /Cleaned_Efflux/ directory:
C2 = load([path 'Cleaned_Efflux/C2_efflux_2009_clean.dat']); % Reference chamber 1:
C4 = load([path 'Cleaned_Efflux/C4_efflux_2009_clean.dat']); % Drought chamber 1:
C5 = load([path 'Cleaned_Efflux/C5_efflux_2009_clean.dat']); % Reference chamber 2:
C6 = load([path 'Cleaned_Efflux/C6_efflux_2009_clean.dat']); % Drought chamber 2:
%%% Load SM and Ts data from the same directory:
SM_dro = load([path 'Cleaned_Efflux/SM_root_Drought_HH09.dat']);
SM_ref = load([path 'Cleaned_Efflux/SM_root_Ref_HH09.dat']);
Ts = load([path 'Cleaned_Efflux/Ts_5cm_Ref_HH09.dat']);

%%% efflux will have the following columns [C2 C4 C5 C6]
efflux(:,1) = C2;
efflux(:,2) = C4;
efflux(:,3) = C5;
efflux(:,4) = C6;
clear C2 C4 C5 C6;

C_tags = {'C2';'C4';'C5';'C6'};
%%% Soil moisture columns line up with appropriate chamber:
SM = [SM_ref SM_dro SM_ref SM_dro];

%%% Check if the master file exists (saved at the end of the program). 
%%% If it does, load it, and skip the calculations.  
%%% If not, then do calculations
if exist([path 'MC_workspace.mat'], 'file')==2
    resp = input('The MC file exists.  Enter <1> to load it, <enter> to not > ');
    if resp == 1;
        calc_flag = 0;
    else
        calc_flag = 1;
    end
    load([path 'MC_workspace.mat']);
end

if calc_flag == 1
%% Step 1: Loop through each chamber, fitting the Ts and Ts+SM models to the data:
%%% We will also calculate residuals, take standard deviation so that we
%%% can recreate the noise later.
for i = 1:1:4
    clear global; % clears global variables..
    
    ind_Ts = find(~isnan(efflux(:,i).*Ts));
    ind_SM = find(~isnan(efflux(:,i).*Ts.*SM(:,i)));
    
    %%% Mean coefficients for Ts-Rs relationship:
    options.costfun ='OLS'; options.min_method ='NM';
    [c_hat_tmp, y_hat_tmp, y_pred_tmp, stats_tmp, sigma_tmp, err_tmp, exitflag_tmp, num_iter_tmp] = ...
        fitresp([2 3], 'fitresp_3A', Ts(ind_Ts) , efflux(ind_Ts,i), Ts, [], options);
    c_hat_mean_Ts(i,1:2) = c_hat_tmp;
    err_mean_Ts(i,1:4) = err_tmp;

    y_pred_mean_Ts(:,i) = y_pred_tmp;
    y_hat(i).mean_Ts = y_hat_tmp;
    stats_mean_Ts(i,1:4) = [stats_tmp.RMSE stats_tmp.MAE stats_tmp.BE stats_tmp.R2];
    
    % Residual:
    resid(i).mean_Ts = efflux(ind_Ts,i) - y_hat(i).mean_Ts;
    std_mean_Ts(1,i) = std(resid(i).mean_Ts);

    clear *_tmp;
    
    % Make random noise for each chamber using Ts model:
    noise(i).Ts = random('norm',0,std_mean_Ts(1,i),size(efflux,1),100);

    
    %%% Mean coefficients for Ts+SWC-Rs relationship:
    options.costfun ='OLS'; options.min_method ='NM';
    [c_hat_tmp, y_hat_tmp, y_pred_tmp, stats_tmp, sigma_tmp, err_tmp, exitflag_tmp, num_iter_tmp] = ...
        fitresp([2 3 1 30], 'fitresp_3B', [Ts(ind_SM) SM(ind_SM,i)] , efflux(ind_SM,i), [Ts SM(:,i)], [], options);
    c_hat_mean_SM(i,1:4) = c_hat_tmp;
    err_mean_SM(i,1) = err_tmp;

    y_pred_mean_SM(:,i) = y_pred_tmp;
    stats_mean_SM(i,1:4) = [stats_tmp.RMSE stats_tmp.MAE stats_tmp.BE stats_tmp.R2];
    y_hat(i).mean_SM = y_hat_tmp;
    
    % Residual:
    resid(i).mean_SM = efflux(ind_SM,i) - y_hat(i).mean_SM;
     std_mean_SM(1,i) = std(resid(i).mean_SM);

    clear ind* *_tmp
    
        % Make random noise for each chamber using Ts+SM model:
    noise(i).SM = random('norm',0,std_mean_SM(1,i),size(efflux,1),100);

end



%% Step 2:  Now, we can add the 'mean' y_pred values to the noise to get 
%%% 100 synthetic data sets, then reacquire the best-fit paramaters and stats
    for i = 1:1:4
        ind_Ts = find(~isnan(Ts));
        ind_SM = find(~isnan(Ts.*SM(:,i)));
        tic
        
        for j = 1:1:100
            % Synthetic data - Add 'mean: predicted to noise:
            efflux_Ts = y_pred_mean_Ts(:,i)+noise(i).Ts(:,j);
            efflux_SM = y_pred_mean_SM(:,i)+noise(i).SM(:,j);
            
            % Ts Model:
            options.costfun ='OLS'; options.min_method ='NM';
            [c_hat_tmp, y_hat_tmp, y_pred_tmp, stats_tmp, sigma_tmp, err_tmp, exitflag_tmp, num_iter_tmp] = ...
                fitresp([2 3], 'fitresp_3A', Ts(ind_Ts) , efflux_Ts(ind_Ts), Ts, [], options);
            c_hat(i).Ts(j,1:2) = c_hat_tmp;
            err_Ts(j,i) = err_tmp;
            y_pred(i).Ts(:,j) = y_pred_tmp;
            stats(i).Ts(j,1:4) = [stats_tmp.RMSE stats_tmp.MAE stats_tmp.BE stats_tmp.R2];
            
            filled_efflux_Ts_tmp = y_pred(i).Ts(:,j);
            filled_efflux_Ts_tmp(~isnan(efflux_Ts),1) = efflux_Ts(~isnan(efflux_Ts),1);
            sum_Ts(j,i) = nansum(filled_efflux_Ts_tmp);
            clear *_tmp
            % Ts+SM Model:
            options.costfun ='OLS'; options.min_method ='NM';
            [c_hat_tmp, y_hat_tmp, y_pred_tmp, stats_tmp, sigma_tmp, err_tmp, exitflag_tmp, num_iter_tmp] = ...
                fitresp([2 3 1 30], 'fitresp_3B', [Ts(ind_SM) SM(ind_SM,i)] , efflux_SM(ind_SM), [Ts SM(:,i)], [], options);
            c_hat(i).SM(j,1:4) = c_hat_tmp;
            err_SM(j,i) = err_tmp;
            y_pred(i).SM(:,j) = y_pred_tmp;
            stats(i).SM(j,1:4) = [stats_tmp.RMSE stats_tmp.MAE stats_tmp.BE stats_tmp.R2];
            filled_efflux_SM_tmp = y_pred(i).SM(:,j);
            filled_efflux_SM_tmp(~isnan(efflux_SM),1) = efflux_SM(~isnan(efflux_SM),1);
            sum_SM(j,i) = nansum(filled_efflux_SM_tmp);
            
            clear *_tmp efflux_Ts efflux_SM;
        end
        t(i,1) = toc;
        disp(['Chamber ' num2str(i) ' done in ' num2str(t(i,1)) 'seconds.']);
        clear ind*;
    end
    %%% save the entire workspace after running through the calculations:
    save([path 'MC_workspace.mat']);
end

% Convert Sums to grams C:
    sum_Ts_g = sum_Ts.*0.0216;
    sum_SM_g = sum_SM.*0.0216;
    
%% Plotting:
    hist_bins = (-10:1:10)';
    figure(1);clf; % Residuals for Ts-only function
    figure(2);clf; % Residuals for Ts+SM function
    figure(3);clf; % Histogram of annual sums 
    figure(4);clf; % Histogram of total sum of squares error
    figure(5);clf; % Histogram of RMSE
    figure(6);clf; % Histogram of R2
    for i = 1:1:4
    figure(1); subplot(2,2,i)
    [n xout] = hist(resid(i).mean_Ts,hist_bins);
    bar(hist_bins, n/length(resid(i).mean_Ts),'FaceColor', [0 0 1])
    axis([-10 10 0 0.8])
    title('Ts only Model');
     xlabel('Residual /mumol CO2')
    ylabel('frequency');
     title(['Chamber: ' C_tags{i,1}])
        
    figure(2); subplot(2,2,i)
    [n2 xout2] = hist(resid(i).mean_SM,hist_bins);
    bar(hist_bins, n2/length(resid(i).mean_SM),'FaceColor', [0.5 0.5 0.2])
    axis([-10 10 0 0.8])
        title('Ts+SM Model');

      xlabel('Residual /mumol CO2')
    ylabel('frequency');
     title(['Chamber: ' C_tags{i,1}])       
        
        figure(3);
    subplot(2,2,i);
    [n, xout] = hist(sum_SM_g(:,i)); bar(xout, n/100, 'b'); hold on;
    [n, xout] = hist(sum_Ts_g(:,i)); bar(xout, n/100, 'r'); hold on;    
    xlabel('Annual Sum (g C m^{-2} s^{-1})')
    ylabel('frequency');
        legend('Ts+SM', 'Ts only');
        title(['Chamber: ' C_tags{i,1}])
        
        figure(4);
    subplot(2,2,i);
    [n, xout] = hist(err_SM(:,i)); bar(xout, n/100, 'b'); hold on;
    [n, xout] = hist(err_Ts(:,i)); bar(xout, n/100, 'r'); hold on;    
    xlabel('sum of squared error')
    ylabel('frequency');
        legend('Ts+SM', 'Ts only');
        title(['Chamber: ' C_tags{i,1}])
        
        figure(5);
    subplot(2,2,i);
    [n, xout] = hist(stats(i).SM(:,1)); bar(xout, n/100, 'b'); hold on;
    [n, xout] = hist(stats(i).Ts(:,1)); bar(xout, n/100, 'r'); hold on;    
    xlabel('RMSE')
    ylabel('frequency');
        legend('Ts+SM', 'Ts only');
        title(['Chamber: ' C_tags{i,1}])
        
        figure(6);
    subplot(2,2,i);
    [n, xout] = hist(stats(i).SM(:,4)); bar(xout, n/100, 'b'); hold on;
    [n, xout] = hist(stats(i).Ts(:,4)); bar(xout, n/100, 'r'); hold on;    
    xlabel('R^{2}')
    ylabel('frequency');
        legend('Ts+SM', 'Ts only');
        title(['Chamber: ' C_tags{i,1}])        
        
    end
    