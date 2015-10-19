%%%% Load data:
clearvars;close all;
year = 2010;

ls = addpath_loadstart;
master_path = [ls 'Matlab/Data/Master_Files/'];
trenched_path = [ls 'Matlab/Data/Met/Final_Cleaned/TP39_trenched/'];
chamber_path = [ls 'Matlab/Data/Flux/ACS/TP39_chamber/Final_Cleaned/'];
clrs = jjb_get_plot_colors;

% Load trenched plot data:
tr = load([trenched_path 'TP39_trenched_met_cleaned_' num2str(year) '.mat']);
TP39_all = load([master_path 'TP39/TP39_data_master_' num2str(year) '.mat']);
TP39 = load([master_path 'TP39/TP39_gapfill_data_in.mat']);
TP39.data = trim_data_files(TP39.data,year,year,1);

sf = load([master_path 'TP39_sapflow/TP39_sapflow_data_master_' num2str(year) '.mat']);
ch = load([chamber_path 'TP39_chamber_ACS_cleaned_' num2str(year) '.mat']);

%%% efflux is in cell 6.
Ts = TP39.data.Ts5;
SM = TP39.data.SM_a_filled;


f_ch = figure();clf;
f_ch2A = figure();clf;
f_ch2B = figure();clf;

for i = 1:1:8
   efflux = ch.master.data{6}(1:length(Ts),i);
ind = find(~isnan(efflux.*SM.*Ts));%create an index where the efflux, Ts and SM all have data points

Xin = [Ts(ind,1) SM(ind,1)];%create x input
Yin = efflux(ind,1);%create y input
Yfill = Yin;
X_eval = [Ts SM];
options.costfun ='OLS'; options.min_method ='NM'; options.f_coeff = [NaN NaN NaN NaN];%this chooses the optimization and cost funtions, 
                                                                                                       %coefficients can be changed from NaN to a fixed number is desired
[c_hat_3B(i,:), y_hat_3B, y_pred_3B, stats_3B{i}, sigma_3B, err_3B, exitflag_3B, num_iter_3B] = ...
    fitresp([3 2 1 50], 'fitresp_3B', Xin, Yin, X_eval, [], options);%choose model type for Ts and Efflux and SM and norm. efflux
Yfill3B(:,i) = efflux;
Yfill3B(isnan(efflux)==1) = y_pred_3B(isnan(efflux)==1);
sum_ypred3B(i,1) = sum(y_pred_3B);

[c_hat_2A(i,:), y_hat_2A, y_pred_2A, stats_2A{i}, sigma_2A, err_2A, exitflag_2A, num_iter_2A] = ...
    fitresp([10 0.15 15], 'fitresp_2A', Xin, Yin, X_eval, [], options);%choose model type for Ts and Efflux and SM and norm. efflux
Yfill2A(:,i) = efflux;
Yfill2A(isnan(efflux)==1,i) = y_pred_2A(isnan(efflux)==1);
sum_ypred2A(i,1) = sum(y_pred_2A);

[c_hat_2B(i,:), y_hat_2B, y_pred_2B, stats_2B{i}, sigma_2B, err_2B, exitflag_2B, num_iter_2B] = ...
    fitresp([10 0.15 15 1 1], 'fitresp_2B', Xin, Yin, X_eval, [], options);%choose model type for Ts and Efflux and SM and norm. efflux
Yfill2B(:,i) = efflux;
Yfill2B(isnan(efflux)==1,i) = y_pred_2B(isnan(efflux)==1);
sum_ypred2B(i,1) = sum(y_pred_2B);

figure(f_ch);
hch(i) = plot(y_pred_3B,'Color',clrs(i,:));hold on;
    
figure(f_ch2A);
hch2A(i) = plot(y_pred_2A,'Color',clrs(i,:));hold on;

figure(f_ch2B);
hch2B(i) = plot(y_pred_2B,'Color',clrs(i,:));hold on;

    
end
figure(f_ch);
legend(num2str((1:8)'));title('Q10 / 3B');
figure(f_ch2A);
legend(num2str((1:8)'));title('Logi / 2A');
figure(f_ch2B);
legend(num2str((1:8)'));title('Logi / 2B');


sum2A = (nansum(Yfill2A).*0.0216)';
sum2B = (nansum(Yfill2B).*0.0216)';
sum3B = (nansum(Yfill3B).*0.0216)';

sum_ypred2A= sum_ypred2A*0.0216;
sum_ypred2B= sum_ypred2B*0.0216;
sum_ypred3B= sum_ypred3B*0.0216;