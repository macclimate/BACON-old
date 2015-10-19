%% This script is designed to remove spikes from ET data.  Created by:  SLM
%%  -  STEP #2 (spike removal) and #3 (NN model) IN THE SAPFLOW Process
%June 9, 2010 - spike removal created by JJB.
%1)  look at spike removal and remove outliers 
%2) run through the NN and get model to fill gaps
%3)  use linear interpolation to fill small gaps
%4)  use NN to fill big gaps
%5)  Sometimes the NN predicts these will have to be filtered out, and
%those spots linearlly interpolated to get a final number.

%% Meteorological Variables to be used in Neural Network

load 'C:\MacKay\Masters\data\hhour\Ts_5cm_Ref_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\PAR_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\VPD_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\SM_root_Dro_HH10_filled.dat'
load 'C:\MacKay\Masters\data\hhour\SM_root_Ref_HH10_filled.dat'

%% Reference Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\ET1_cleaned_hh10.dat';
ET1_cleaned_hh10(16656:16704) = NaN;
ET1_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET2_cleaned_hh10.dat';
ET2_cleaned_hh10(16656:16704) = NaN;
ET2_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET3_cleaned_hh10.dat';
ET3_cleaned_hh10(16656:16704) = NaN;
ET3_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET4_cleaned_hh10.dat';
ET4_cleaned_hh10(16656:16704) = NaN;
ET4_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET5_cleaned_hh10.dat';
ET5_cleaned_hh10(16656:16704) = NaN;
ET5_cleaned_hh10(8353:8448) = NaN;

%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Network (NN), before gapfilling with the
%NN
[ET1_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET1_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET1_fixed_hh10.dat'  ET1_fixed_hh10   -ASCII
[ET2_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET2_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET2_fixed_hh10.dat'  ET2_fixed_hh10   -ASCII
[ET3_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET3_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET3_fixed_hh10.dat'  ET3_fixed_hh10   -ASCII
[ET4_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET4_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET4_fixed_hh10.dat'  ET4_fixed_hh10   -ASCII
[ET5_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET5_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET5_fixed_hh10.dat'  ET5_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #1
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET1_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET1_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET1_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET1_hh10_NN.dat'  ET1_hh10_est   -ASCII
%end
figure('Name','modeled ET1');clf;
plot(ET1_fixed_hh10(ind_sim),'b'); hold on;
plot(ET1_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #2
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET2_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET2_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET2_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET2_hh10_NN.dat'  ET2_hh10_est   -ASCII
%end
figure('Name','modeled ET2');clf;
plot(ET2_fixed_hh10(ind_sim),'b'); hold on;
plot(ET2_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #3
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET3_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET3_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET3_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET3_hh10_NN.dat'  ET3_hh10_est   -ASCII
%end
figure('Name','modeled ET3');clf;
plot(ET3_fixed_hh10(ind_sim),'b'); hold on;
plot(ET3_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #4
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET4_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET4_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET4_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET4_hh10_NN.dat'  ET4_hh10_est   -ASCII
%end
figure('Name','modeled ET3');clf;
plot(ET4_fixed_hh10(ind_sim),'b'); hold on;
plot(ET4_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #5
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET5_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET5_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET5_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET5_hh10_NN.dat'  ET5_hh10_est   -ASCII
%end
figure('Name','modeled ET3');clf;
plot(ET5_fixed_hh10(ind_sim),'b'); hold on;
plot(ET5_hh10_est','r.-');
legend('measured ET','Estimated ET');


%% Drought Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\ET6_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET7_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET8_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET9_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET10_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET22_cleaned_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\ET23_cleaned_hh10.dat';


%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Network (NN), before gapfilling with the
%NN
[ET6_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET6_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET6_fixed_hh10.dat'  ET6_fixed_hh10   -ASCII
[ET7_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET7_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET7_fixed_hh10.dat'  ET7_fixed_hh10   -ASCII
[ET8_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET8_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET8_fixed_hh10.dat'  ET8_fixed_hh10   -ASCII
[ET9_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET9_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET9_fixed_hh10.dat'  ET9_fixed_hh10   -ASCII
[ET10_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET10_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET10_fixed_hh10.dat'  ET10_fixed_hh10   -ASCII
[ET22_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET22_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET22_fixed_hh10.dat'  ET22_fixed_hh10   -ASCII
[ET23_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET23_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET23_fixed_hh10.dat'  ET23_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #6
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET6_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET6_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET6_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET6_hh10_NN.dat'  ET6_hh10_est   -ASCII
%end
figure('Name','modeled ET6');clf;
plot(ET6_fixed_hh10(ind_sim),'b'); hold on;
plot(ET6_hh10_est','r.-');
legend('measured ET','Estimated ET');


%SF #7
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET7_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET7_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET7_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET7_hh10_NN.dat'  ET7_hh10_est   -ASCII
%end
figure('Name','modeled ET7');clf;
plot(ET7_fixed_hh10(ind_sim),'b'); hold on;
plot(ET7_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #8
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET8_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET8_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET8_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET8_hh10_NN.dat'  ET8_hh10_est   -ASCII
%end
figure('Name','modeled ET8');clf;
plot(ET8_fixed_hh10(ind_sim),'b'); hold on;
plot(ET8_hh10_est','r.-');
legend('measured ET','Estimated ET');


%SF #9
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET9_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET9_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET9_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET9_hh10_NN.dat'  ET9_hh10_est   -ASCII
%end
figure('Name','modeled ET9');clf;
plot(ET9_fixed_hh10(ind_sim),'b'); hold on;
plot(ET9_hh10_est','r.-');
legend('measured ET','Estimated ET');


%SF #10
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET10_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET10_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET10_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET10_hh10_NN.dat'  ET10_hh10_est   -ASCII
%end
figure('Name','modeled ET10');clf;
plot(ET10_fixed_hh10(ind_sim),'b'); hold on;
plot(ET10_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #22
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET22_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET22_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET22_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET22_hh10_NN.dat'  ET22_hh10_est   -ASCII
%end
figure('Name','modeled ET22');clf;
plot(ET22_fixed_hh10(ind_sim),'b'); hold on;
plot(ET22_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #23
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET23_fixed_hh10.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET23_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET23_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET23_hh23_NN.dat'  ET23_hh10_est   -ASCII
%end
figure('Name','modeled ET23');clf;
plot(ET23_fixed_hh10(ind_sim),'b'); hold on;
plot(ET23_hh10_est','r.-');
legend('measured ET','Estimated ET');
%% Fall Drought Plot

load 'C:\MacKay\Masters\data\hhour\ET11_cleaned_hh10.dat';
ET11_cleaned_hh10(16656:16704) = NaN;
ET11_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET12_cleaned_hh10.dat';
ET12_cleaned_hh10(16656:16704) = NaN;
ET12_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET13_cleaned_hh10.dat';
ET13_cleaned_hh10(16656:16704) = NaN;
ET13_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET14_cleaned_hh10.dat';
ET14_cleaned_hh10(16656:16704) = NaN;
ET14_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET15_cleaned_hh10.dat';
ET15_cleaned_hh10(16656:16704) = NaN;
ET15_cleaned_hh10(8353:8448) = NaN;


[ET11_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET11_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET11_fixed_hh10.dat'  ET11_fixed_hh10   -ASCII
[ET12_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET12_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET12_fixed_hh10.dat'  ET12_fixed_hh10   -ASCII
[ET13_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET13_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET13_fixed_hh10.dat'  ET13_fixed_hh10   -ASCII
[ET14_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET14_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET14_fixed_hh10.dat'  ET14_fixed_hh10   -ASCII
[ET15_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET15_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET15_fixed_hh10.dat'  ET15_fixed_hh10   -ASCII

%SF #11
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET11_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET11_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET11_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET11_hh10_NN.dat'  ET11_hh10_est   -ASCII
%end
figure('Name','modeled ET11');clf;
plot(ET11_fixed_hh10(ind_sim),'b'); hold on;
plot(ET11_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #12
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET12_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET12_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET12_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET12_hh10_NN.dat'  ET12_hh10_est   -ASCII
%end
figure('Name','modeled ET12');clf;
plot(ET12_fixed_hh10(ind_sim),'b'); hold on;
plot(ET12_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #13
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET13_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET13_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET13_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET13_hh10_NN.dat'  ET13_hh10_est   -ASCII
%end
figure('Name','modeled ET13');clf;
plot(ET13_fixed_hh10(ind_sim),'b'); hold on;
plot(ET13_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #14
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET14_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET14_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET14_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET14_hh10_NN.dat'  ET14_hh10_est   -ASCII
%end
figure('Name','modeled ET14');clf;
plot(ET14_fixed_hh10(ind_sim),'b'); hold on;
plot(ET14_hh10_est','r.-');
legend('measured ET','Estimated ET');

%SF #15
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET15_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET15_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET15_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET15_hh10_NN.dat'  ET15_hh10_est   -ASCII
%end
figure('Name','modeled ET15');clf;
plot(ET15_fixed_hh10(ind_sim),'b'); hold on;
plot(ET15_hh10_est','r.-');
legend('measured ET','Estimated ET');

%% Thinned Plot

load 'C:\MacKay\Masters\data\hhour\ET16_cleaned_hh10.dat';
ET16_cleaned_hh10(16656:16704) = NaN;
ET16_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET17_cleaned_hh10.dat';
ET17_cleaned_hh10(16656:16704) = NaN;
ET17_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET18_cleaned_hh10.dat';
ET18_cleaned_hh10(16656:16704) = NaN;
ET18_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET19_cleaned_hh10.dat';
ET19_cleaned_hh10(16656:16704) = NaN;
ET19_cleaned_hh10(8353:8448) = NaN;
load 'C:\MacKay\Masters\data\hhour\ET20_cleaned_hh10.dat';
ET20_cleaned_hh10(16656:16704) = NaN;
ET20_cleaned_hh10(8353:8448) = NaN;

[ET16_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET16_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET16_fixed_hh10.dat'  ET16_fixed_hh10   -ASCII
[ET17_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET17_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET17_fixed_hh10.dat'  ET17_fixed_hh10   -ASCII
[ET18_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET18_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET18_fixed_hh10.dat'  ET18_fixed_hh10   -ASCII
[ET19_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET19_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET19_fixed_hh10.dat'  ET19_fixed_hh10   -ASCII
[ET20_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET20_cleaned_hh10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\ET20_fixed_hh10.dat'  ET20_fixed_hh10   -ASCII


%SF #16
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET16_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET16_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET16_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET16_hh10_NN.dat'  ET16_hh10_est   -ASCII
%end
figure('Name','modeled ET16');clf;
plot(ET16_fixed_hh10(ind_sim),'b'); hold on;
plot(ET16_hh10_est','r.-');
legend('measured ET','Estimated ET');



%SF #17
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET17_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET17_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET17_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET17_hh10_NN.dat'  ET17_hh10_est   -ASCII
%end
figure('Name','modeled ET17');clf;
plot(ET17_fixed_hh10(ind_sim),'b'); hold on;
plot(ET17_hh10_est','r.-');
legend('measured ET','Estimated ET');


%SF #18
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET18_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET18_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET18_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET18_hh10_NN.dat'  ET18_hh10_est   -ASCII
%end
figure('Name','modeled ET18');clf;
plot(ET18_fixed_hh10(ind_sim),'b'); hold on;
plot(ET18_hh10_est','r.-');
legend('measured ET','Estimated ET');



%SF #19
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET19_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET19_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET19_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET19_hh10_NN.dat'  ET19_hh10_est   -ASCII
%end
figure('Name','modeled ET19');clf;
plot(ET19_fixed_hh10(ind_sim),'b'); hold on;
plot(ET19_hh10_est','r.-');
legend('measured ET','Estimated ET');



%SF #20
ind_use = find(~isnan(Ts_5cm_Ref_HH10_filled.*ET20_fixed_hh10.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [PAR_HH10_filled(ind_use) Ts_5cm_Ref_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_target = ET20_fixed_hh10(ind_use);
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');
ind_sim = find(~isnan(Ts_5cm_Ref_HH10_filled.*PAR_HH10_filled.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [PAR_HH10_filled(ind_sim) Ts_5cm_Ref_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
ET20_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\ET20_hh10_NN.dat'  ET20_hh10_est   -ASCII
%end
figure('Name','modeled ET20');clf;
plot(ET20_fixed_hh10(ind_sim),'b'); hold on;
plot(ET20_hh10_est','r.-');
legend('measured ET','Estimated ET');
