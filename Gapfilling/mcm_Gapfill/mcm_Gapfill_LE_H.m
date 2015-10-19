function [final_out fig_out] = mcm_Gapfill_LE_H(data, plot_flag, debug_flag)
% mcm_Gapfill_LE_H.m
% usage: [] = mcm_LE_H_Gapfill(site, year_start, year_end, Ustar_th)
%%% This function is the main function used to gapfill LE and H data from
%%% flux towers. This will run on all sites, and for any given years and
%%% OPEC or CPEC data.  
%%% Gap-filling is accomplished in 2 different means:
%%% 1. A neural network (NN) is used, where met data and raw flux (LE, H)
%%% are used to train the neural network.  Met data is then fed into the NN
%%% to predict fluxes for the given years.   Gaps in fluxes are then filled
%%% with NN predictions.  If NaNs exist in the input data, then there may
%%% still possibly be gaps in the filled flux data.
%%% 2. Following this, any small gaps that may still exist are filled by
%%% using either a windowed linear regression, or a moving-window MDV
%%% approach.  These filling methods are executed via
%%% mcm_Gapfill_LE_H_WLR_MDV.m
%%% Created Aug 1, 2010 by JJB.

%%% Revision History:
%
%
%
%
%
%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1;
    plot_flag = 1;
    debug_flag = 0;
elseif nargin == 2
    debug_flag = 0;
end
if isempty(plot_flag)==1
    plot_flag = 0;
end
if plot_flag == 1;
    ls = addpath_loadstart;
    fig_path = [ls 'Matlab/Figs/Gapfilling/MDS_Reichstein/' data.site '/'];
    jjb_check_dirs(fig_path);

    %%% Pre-defined variables, mostly for plotting:
%     test_Ts = (-10:2:26)';
%     test_PAR = (0:200:2400)';
    [clrs guide] = jjb_get_plot_colors; 
end

year_start = data.year_start;
year_end = data.year_end;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fill LE:
disp('running NN for LE');
%%% Step 1: Train the NN: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Index of data for NN training (no NaNs in met or flux data):
ind_use = find(~isnan(data.Ts5.*data.WS.*data.LE.*data.Rn_filled.*data.SM_a_filled.*data.VPD));
% Input and target data for training:
nn_inputs = [data.Rn_filled(ind_use) data.WS(ind_use) data.Ts5(ind_use) data.SM_a_filled(ind_use) data.VPD(ind_use)];
nn_target = data.LE(ind_use);
% Run training:
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');

%%% Step 2: Use trained NN for prediction purposes:
% Index for prediction -- find where no NaNs in met data:
ind_sim = find(~isnan(data.Ts5.*data.WS.*data.Rn_filled.*data.SM_a_filled.*data.VPD));
sim_inputs = [data.Rn_filled(ind_sim) data.WS(ind_sim) data.Ts5(ind_sim) data.SM_a_filled(ind_sim) data.VPD(ind_sim)];
% Run NN to predict LE
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
Y = Y';
% Assign predicted data to proper row in ouput (makes rows of predicted
% variable match the rows of the input LE file:
NN_LE_est = NaN.*ones(length(data.LE),1);
NN_LE_est(ind_sim) = Y;
%%% At this point, maybe we should spike-clean the modeled LE data, since
%%% it can sometimes be noisy when the ANN works on it (especially in the
%%% off-season).
[LE_model_cleaned] = mcm_CPEC_outlier_removal(data.site, NN_LE_est, 30, 'LE',1);

%%% Fill gaps in LE with predicted data:
data.LE_filled = data.LE;
data.LE_filled(isnan(data.LE_filled),1) = LE_model_cleaned(isnan(data.LE_filled),1);

if plot_flag == 1
%%% Plot predicted vs observed:
figure('Name','Measured and Modeled LE','Tag','LE');
figure(findobj('Tag','LE'));clf;
subplot(211);
plot(data.LE,NN_LE_est,'k.'); hold on;
ylabel('NN-Predicted LE')
xlabel('Observed LE');
end
%%% Check for NaNs in LE_filled data.  If they exist, run
%%% mcm_Gapfill_LE_H_WLR_MDV.m to fill via MDV, WLR.
if length(find(isnan(data.LE_filled)))>=1
    [junk LE_filled] = mcm_Gapfill_LE_H_WLR_MDV(data,0);
    data.LE_filled(isnan(data.LE_filled),1) = LE_filled(isnan(data.LE_filled),1);
end

if plot_flag == 1
%%% Plot original and filled:
figure(findobj('Tag','LE'));
subplot(212);
plot(data.LE_filled,'r'); hold on;
plot(data.LE','b.');
legend('filled LE','Orig LE');
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fill H:
disp('running NN for H');
%%% Step 1: Train the NN: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Index of data for NN training (no NaNs in met or flux data):
ind_use = find(~isnan(data.PAR.*data.Rn_filled.*data.LE_filled.*data.Ta.*data.H));
% Input and target data for training:
nn_inputs = [data.Rn_filled(ind_use) data.PAR(ind_use) data.Ta(ind_use) data.LE_filled(ind_use)];
nn_target = data.H(ind_use);
% Run training:
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');

%%% Step 2: Use trained NN for prediction purposes:
% Index for prediction -- find where no NaNs in met data:
ind_sim = find(~isnan(data.PAR.*data.LE_filled.*data.Rn_filled.*data.Ta));
sim_inputs = [data.Rn_filled(ind_sim) data.PAR(ind_sim) data.Ta(ind_sim) data.LE_filled(ind_sim)];
% Run NN to predict LE
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
Y = Y';
% Assign predicted data to proper row in ouput (makes rows of predicted
% variable match the rows of the input LE file:
NN_H_est = NaN.*ones(length(data.H),1);
NN_H_est(ind_sim) = Y;
%%% At this point, maybe we should spike-clean the modeled H data, since
%%% it can sometimes be noisy when the ANN works on it (especially in the
%%% off-season).
[H_model_cleaned] = mcm_CPEC_outlier_removal(data.site, NN_H_est, 30, 'H_Gapfill',1);

%%% Fill gaps in LE with predicted data:
data.H_filled = data.H;
data.H_filled(isnan(data.H_filled),1) = H_model_cleaned(isnan(data.H_filled),1);

if plot_flag == 1
%%% Plot predicted vs observed:
figure('Name','Measured and Modeled H','Tag','H');
figure(findobj('Tag','H'));clf;
subplot(211)
plot(data.H,NN_H_est,'k.'); hold on;
ylabel('NN-Predicted H')
xlabel('Observed H');
end

%%% Check for NaNs in H_filled data.  If they exist, run
%%% mcm_Gapfill_LE_H_WLR_MDV.m to fill via MDV, WLR.
if length(find(isnan(data.H_filled)))>=1
    [H_filled junk] = mcm_Gapfill_LE_H_WLR_MDV(data,0);
    data.H_filled(isnan(data.H_filled),1) = H_filled(isnan(data.H_filled),1);
end


%%% Plot original and filled:
fig_out = figure();
title('Original and Filled LE, H');
subplot(211);
plot(data.LE_filled,'r'); hold on;
plot(data.LE','b.');
legend('filled LE','Orig LE');
subplot(212);
plot(data.H_filled,'r'); hold on;
plot(data.H','b.');
legend('filled H','raw H');

%% %%%%%%%%%%%%%% Create the output ('master') file: %%%%%%%%%%%%%%%%%%
final_out = struct;
sum_labels = {'Year';'LE_filled';'ET_filled';'H_filled'; 'LE_pred'; 'ET_pred'; 'H_pred'};

master.Year = data.Year;
master.LE_filled = data.LE_filled;
master.LE_pred = NN_LE_est;
master.ET_filled = LE_to_ET(data.LE_filled,data.Ta);
master.ET_pred = LE_to_ET(NN_LE_est,data.Ta);
master.H_filled = data.H_filled;
master.H_pred = NN_H_est;

    %%% Do Sums:
    ctr = 1;
    for year = year_start:1:year_end
        master.sums(ctr,1) = year;
        master.sums(ctr,2) = nansum(master.LE_filled(data.Year==year));
        master.sums(ctr,3) = nansum(master.ET_filled(data.Year==year));
        master.sums(ctr,4) = nansum(master.H_filled(data.Year==year));
        master.sums(ctr,2) = nansum(master.LE_pred(data.Year==year));
        master.sums(ctr,3) = nansum(master.ET_pred(data.Year==year));
        master.sums(ctr,4) = nansum(master.H_pred(data.Year==year));
        
        ctr = ctr + 1;
    end
final_out.master = master;
final_out.master.sum_labels = sum_labels;
final_out(1).tag = 'LE_H';   
    
disp('mcm_Gapfill_LE_H done!');
end

