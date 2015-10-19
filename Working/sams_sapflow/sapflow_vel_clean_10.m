%This script is designed to remove spikes from sfvel_ data.  Created by:  SLM
%June 9, 2010 - spike removal created by JJB.
%1)  look at spike removal and remove outliers 
%2) run through the NN and gsfvel_ model to fill gaps
%3)  use linear interpolation to fill small gaps
%4)  use NN to fill big gaps
%5)  Somsfvel_imes the NN predicts these will have to be filtered out, and
%those spots linearlly interpolated to gsfvel_ a final number.


%% Msfvel_eorological Variables to be used in Neural Nsfvel_work

load 'C:\MacKay\Masters\data\hhour\Ts_5cm_Drought_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\Rn_HH10_filled_TEMP.csv';
Rn_HH10 = Rn_HH10_filled_TEMP;
load 'C:\MacKay\Masters\data\hhour\VPD_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\SM_root_Dro_HH10_filled.dat'
load 'C:\MacKay\Masters\data\hhour\SM_root_Ref_HH10_filled.dat'

%% Reference Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\sfvel_1_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_2_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_3_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_4_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_5_hh10.dat';

%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Nsfvel_work (NN), before gapfilling with the
%NN

% [ET1_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET1_cleaned_hh10', 30, 'ET');
% save 'C:\MacKay\Masters\data\hhour\model\ET1_fixed_hh10.dat'
% ET1_fixed_hh10   -ASCII

[sfvel_1_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_1_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_1_fixed_hh10.dat'  sfvel_1_fixed_hh10   -ASCII
[sfvel_2_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_2_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_2_fixed_hh10.dat'  sfvel_2_fixed_hh10   -ASCII
[sfvel_3_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_3_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_3_fixed_hh10.dat'  sfvel_3_fixed_hh10   -ASCII
[sfvel_4_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_4_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_4_fixed_hh10.dat'  sfvel_4_fixed_hh10   -ASCII
[sfvel_5_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_5_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_5_fixed_hh10.dat'  sfvel_5_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #1
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_1_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_1_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_1_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_1_hh10_NN.dat'  sfvel_1_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_1');clf;
plot(sfvel_1_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_1_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #2
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_2_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_2_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_2_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_2_hh10_NN.dat'  sfvel_2_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_2');clf;
plot(sfvel_2_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_2_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #3
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_3_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_3_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_3_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_3_hh10_NN.dat'  sfvel_3_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_3');clf;
plot(sfvel_3_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_3_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #4
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_4_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_4_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_4_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_4_hh10_NN.dat'  sfvel_4_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_3');clf;
plot(sfvel_4_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_4_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #5
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_5_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_5_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_5_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_5_hh10_NN.dat'  sfvel_5_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_3');clf;
plot(sfvel_5_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_5_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');


%% Drought Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\sfvel_6_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_7_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_8_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_9_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_10_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_22_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_23_hh10.dat';


%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Nsfvel_work (NN), before gapfilling with the
%NN
[sfvel_6_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_6_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_6_fixed_hh10.dat'  sfvel_6_fixed_hh10   -ASCII
[sfvel_7_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_7_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_7_fixed_hh10.dat'  sfvel_7_fixed_hh10   -ASCII
[sfvel_8_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_8_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_8_fixed_hh10.dat'  sfvel_8_fixed_hh10   -ASCII
[sfvel_9_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_9_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_9_fixed_hh10.dat'  sfvel_9_fixed_hh10   -ASCII
[sfvel_10_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_10_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_10_fixed_hh10.dat'  sfvel_10_fixed_hh10   -ASCII
[sfvel_22_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_22_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_22_fixed_hh10.dat'  sfvel_22_fixed_hh10   -ASCII
[sfvel_23_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_23_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_23_fixed_hh10.dat'  sfvel_23_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #6
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_6_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_6_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_6_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_6_hh10_NN.dat'  sfvel_6_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_6');clf;
plot(sfvel_6_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_6_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');


%SF #7
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_7_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_7_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_7_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_7_hh10_NN.dat'  sfvel_7_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_7');clf;
plot(sfvel_7_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_7_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #8
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_8_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_8_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_8_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_8_hh10_NN.dat'  sfvel_8_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_8');clf;
plot(sfvel_8_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_8_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');


%SF #9
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_9_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_9_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_9_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_9_hh10_NN.dat'  sfvel_9_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_9');clf;
plot(sfvel_9_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_9_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');


%SF #10
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_10_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_10_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_10_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_10_hh10_NN.dat'  sfvel_10_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_10');clf;
plot(sfvel_10_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_10_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #22
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_22_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_22_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_22_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_22_hh10_NN.dat'  sfvel_22_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_22');clf;
plot(sfvel_22_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_22_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #23
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_23_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_23_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_23_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_23_hh10_NN.dat'  sfvel_23_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_23');clf;
plot(sfvel_23_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_23_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');
%% Fall Drought Plot

load 'C:\MacKay\Masters\data\hhour\sfvel_11_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_12_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_13_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_14_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_15_hh10.dat';


[sfvel_11_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_11_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_11_fixed_hh10.dat'  sfvel_11_fixed_hh10   -ASCII
[sfvel_12_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_12_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_12_fixed_hh10.dat'  sfvel_12_fixed_hh10   -ASCII
[sfvel_13_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_13_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_13_fixed_hh10.dat'  sfvel_13_fixed_hh10   -ASCII
[sfvel_14_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_14_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_14_fixed_hh10.dat'  sfvel_14_fixed_hh10   -ASCII
[sfvel_15_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_15_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_15_fixed_hh10.dat'  sfvel_15_fixed_hh10   -ASCII

%SF #11
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_11_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_11_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_11_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_11_hh10_NN.dat'  sfvel_11_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_11');clf;
plot(sfvel_11_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_11_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #12
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_12_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_12_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_12_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_12_hh10_NN.dat'  sfvel_12_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_12');clf;
plot(sfvel_12_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_12_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #13
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_13_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_13_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_13_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_13_hh10_NN.dat'  sfvel_13_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_13');clf;
plot(sfvel_13_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_13_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #14
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_14_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_14_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_14_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_14_hh10_NN.dat'  sfvel_14_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_14');clf;
plot(sfvel_14_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_14_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%SF #15
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_15_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_15_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_15_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_15_hh10_NN.dat'  sfvel_15_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_15');clf;
plot(sfvel_15_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_15_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');

%% Thinned Plot

load 'C:\MacKay\Masters\data\hhour\sfvel_16_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_17_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_18_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_19_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sfvel_20_hh10.dat';

[sfvel_16_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_16_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_16_fixed_hh10.dat'  sfvel_16_fixed_hh10   -ASCII
[sfvel_17_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_17_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_17_fixed_hh10.dat'  sfvel_17_fixed_hh10   -ASCII
[sfvel_18_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_18_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_18_fixed_hh10.dat'  sfvel_18_fixed_hh10   -ASCII
[sfvel_19_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_19_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_19_fixed_hh10.dat'  sfvel_19_fixed_hh10   -ASCII
[sfvel_20_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sfvel_20_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sfvel_20_fixed_hh10.dat'  sfvel_20_fixed_hh10   -ASCII


%SF #16
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_16_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_16_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_16_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_16_hh10_NN.dat'  sfvel_16_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_16');clf;
plot(sfvel_16_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_16_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');



%SF #17
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_17_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_17_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_17_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_17_hh10_NN.dat'  sfvel_17_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_17');clf;
plot(sfvel_17_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_17_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');


%SF #18
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_18_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_18_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_18_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_18_hh10_NN.dat'  sfvel_18_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_18');clf;
plot(sfvel_18_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_18_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');



%SF #19
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_19_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_19_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_19_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_19_hh10_NN.dat'  sfvel_19_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_19');clf;
plot(sfvel_19_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_19_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');



%SF #20
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sfvel_20_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsfvel_ = sfvel_20_fixed_hh10(ind_use);
nsfvel_ = newfit(nn_inputs',nn_targsfvel_',30);
nsfvel_=train(nsfvel_,nn_inputs',nn_targsfvel_');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsfvel_,sim_inputs');
sfvel_20_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sfvel_20_hh10_NN.dat'  sfvel_20_hh10_est   -ASCII
%end
figure('Name','modeled sfvel_20');clf;
plot(sfvel_20_fixed_hh10(ind_sim),'b'); hold on;
plot(sfvel_20_hh10_est','r.-');
legend('measured sfvel_','Estimated sfvel_');
