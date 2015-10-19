%This script is designed to remove spikes from sf data.  Created by:  SLM
%June 9, 2010 - spike removal created by JJB.
%1)  look at spike removal and remove outliers 
%2) run through the NN and gsf model to fill gaps
%3)  use linear interpolation to fill small gaps
%4)  use NN to fill big gaps
%5)  Somsfimes the NN predicts these will have to be filtered out, and
%those spots linearlly interpolated to gsf a final number.


%% Msfeorological Variables to be used in Neural Nsfwork

load 'C:\MacKay\Masters\data\hhour\Ts_5cm_Drought_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\Rn_HH10_filled_TEMP.csv';
Rn_HH10 = Rn_HH10_filled_TEMP;
load 'C:\MacKay\Masters\data\hhour\VPD_HH10_filled.dat';
load 'C:\MacKay\Masters\data\hhour\SM_root_Dro_HH10_filled.dat'
load 'C:\MacKay\Masters\data\hhour\SM_root_Ref_HH10_filled.dat'

%% Reference Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\sf1_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf2_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf3_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf4_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf5_hh10.dat';

%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Nsfwork (NN), before gapfilling with the
%NN

% [ET1_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', ET1_cleaned_hh10, 30, 'ET');
% save 'C:\MacKay\Masters\data\hhour\model\ET1_fixed_hh10.dat'
% ET1_fixed_hh10   -ASCII

[sf1_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf1_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf1_fixed_hh10.dat'  sf1_fixed_hh10   -ASCII
[sf2_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf2_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf2_fixed_hh10.dat'  sf2_fixed_hh10   -ASCII
[sf3_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf3_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf3_fixed_hh10.dat'  sf3_fixed_hh10   -ASCII
[sf4_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf4_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf4_fixed_hh10.dat'  sf4_fixed_hh10   -ASCII
[sf5_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf5_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf5_fixed_hh10.dat'  sf5_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #1
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf1_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf1_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf1_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf1_hh10_NN.dat'  sf1_hh10_est   -ASCII
%end
figure('Name','modeled sf1');clf;
plot(sf1_fixed_hh10(ind_sim),'b'); hold on;
plot(sf1_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #2
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf2_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf2_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf2_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf2_hh10_NN.dat'  sf2_hh10_est   -ASCII
%end
figure('Name','modeled sf2');clf;
plot(sf2_fixed_hh10(ind_sim),'b'); hold on;
plot(sf2_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #3
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf3_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf3_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf3_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf3_hh10_NN.dat'  sf3_hh10_est   -ASCII
%end
figure('Name','modeled sf3');clf;
plot(sf3_fixed_hh10(ind_sim),'b'); hold on;
plot(sf3_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #4
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf4_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf4_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf4_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf4_hh10_NN.dat'  sf4_hh10_est   -ASCII
%end
figure('Name','modeled sf3');clf;
plot(sf4_fixed_hh10(ind_sim),'b'); hold on;
plot(sf4_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #5
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf5_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf5_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf5_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf5_hh10_NN.dat'  sf5_hh10_est   -ASCII
%end
figure('Name','modeled sf3');clf;
plot(sf5_fixed_hh10(ind_sim),'b'); hold on;
plot(sf5_hh10_est','r.-');
legend('measured sf','Estimated sf');


%% Drought Plot

%Step one:  Load the data 
load 'C:\MacKay\Masters\data\hhour\sf6_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf7_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf8_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf9_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf10_hh10.dat';
% load 'C:\MacKay\Masters\data\hhour\sf22_hh10.dat';
% load 'C:\MacKay\Masters\data\hhour\sf23_hh10.dat';


%Step two:  Remove the spikes from the data (due to the nature of sapflow
%data, some 'good' data will be removed.  To fix this, you will linearly
%interpolate after you run the Neural Nsfwork (NN), before gapfilling with the
%NN
[sf6_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf6_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf6_fixed_hh10.dat'  sf6_fixed_hh10   -ASCII
[sf7_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf7_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf7_fixed_hh10.dat'  sf7_fixed_hh10   -ASCII
[sf8_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf8_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf8_fixed_hh10.dat'  sf8_fixed_hh10   -ASCII
[sf9_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf9_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf9_fixed_hh10.dat'  sf9_fixed_hh10   -ASCII
[sf10_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf10_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf10_fixed_hh10.dat'  sf10_fixed_hh10   -ASCII
% [sf22_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf22_hh10, 30, 'ET');
% save 'C:\MacKay\Masters\data\hhour\model\sf22_fixed_hh10.dat'  sf22_fixed_hh10   -ASCII
% [sf23_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf23_hh10, 30, 'ET');
% save 'C:\MacKay\Masters\data\hhour\model\sf23_fixed_hh10.dat'  sf23_fixed_hh10   -ASCII

%Step three:  Run the NN for EACH sensor

%SF #6
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf6_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf6_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf6_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf6_hh10_NN.dat'  sf6_hh10_est   -ASCII
%end
figure('Name','modeled sf6');clf;
plot(sf6_fixed_hh10(ind_sim),'b'); hold on;
plot(sf6_hh10_est','r.-');
legend('measured sf','Estimated sf');


%SF #7
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf7_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf7_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf7_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf7_hh10_NN.dat'  sf7_hh10_est   -ASCII
%end
figure('Name','modeled sf7');clf;
plot(sf7_fixed_hh10(ind_sim),'b'); hold on;
plot(sf7_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #8
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf8_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf8_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf8_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf8_hh10_NN.dat'  sf8_hh10_est   -ASCII
%end
figure('Name','modeled sf8');clf;
plot(sf8_fixed_hh10(ind_sim),'b'); hold on;
plot(sf8_hh10_est','r.-');
legend('measured sf','Estimated sf');


%SF #9
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf9_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf9_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf9_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf9_hh10_NN.dat'  sf9_hh10_est   -ASCII
%end
figure('Name','modeled sf9');clf;
plot(sf9_fixed_hh10(ind_sim),'b'); hold on;
plot(sf9_hh10_est','r.-');
legend('measured sf','Estimated sf');


%SF #10
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf10_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf10_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf10_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf10_hh10_NN.dat'  sf10_hh10_est   -ASCII
%end
figure('Name','modeled sf10');clf;
plot(sf10_fixed_hh10(ind_sim),'b'); hold on;
plot(sf10_hh10_est','r.-');
legend('measured sf','Estimated sf');

% %SF #22
% ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf22_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
% nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
% nn_targsf = sf22_fixed_hh10(ind_use);
% nsf = newfit(nn_inputs',nn_targsf',30);
% nsf=train(nsf,nn_inputs',nn_targsf');
% ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
% 
% sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% % Predict LE using NN output
% [Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
% sf22_hh10_est = Y';
% save 'C:\MacKay\Masters\data\hhour\model\sf22_hh10_NN.dat'  sf22_hh10_est   -ASCII
% %end
% figure('Name','modeled sf22');clf;
% plot(sf22_fixed_hh10(ind_sim),'b'); hold on;
% plot(sf22_hh10_est','r.-');
% legend('measured sf','Estimated sf');
% 
% %SF #23
% ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf23_fixed_hh10.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
% nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Dro_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
% nn_targsf = sf23_fixed_hh10(ind_use);
% nsf = newfit(nn_inputs',nn_targsf',30);
% nsf=train(nsf,nn_inputs',nn_targsf');
% ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Dro_HH10_filled.*VPD_HH10_filled));
% 
% sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Dro_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% % Predict LE using NN output
% [Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
% sf23_hh10_est = Y';
% save 'C:\MacKay\Masters\data\hhour\model\sf23_hh10_NN.dat'  sf23_hh10_est   -ASCII
% %end
% figure('Name','modeled sf23');clf;
% plot(sf23_fixed_hh10(ind_sim),'b'); hold on;
% plot(sf23_hh10_est','r.-');
% legend('measured sf','Estimated sf');
%% Fall Drought Plot

load 'C:\MacKay\Masters\data\hhour\sf11_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf12_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf13_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf14_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf15_hh10.dat';


[sf11_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf11_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf11_fixed_hh10.dat'  sf11_fixed_hh10   -ASCII
[sf12_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf12_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf12_fixed_hh10.dat'  sf12_fixed_hh10   -ASCII
[sf13_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf13_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf13_fixed_hh10.dat'  sf13_fixed_hh10   -ASCII
[sf14_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf14_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf14_fixed_hh10.dat'  sf14_fixed_hh10   -ASCII
[sf15_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf15_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf15_fixed_hh10.dat'  sf15_fixed_hh10   -ASCII

%SF #11
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf11_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf11_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf11_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf11_hh10_NN.dat'  sf11_hh10_est   -ASCII
%end
figure('Name','modeled sf11');clf;
plot(sf11_fixed_hh10(ind_sim),'b'); hold on;
plot(sf11_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #12
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf12_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf12_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf12_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf12_hh10_NN.dat'  sf12_hh10_est   -ASCII
%end
figure('Name','modeled sf12');clf;
plot(sf12_fixed_hh10(ind_sim),'b'); hold on;
plot(sf12_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #13
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf13_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf13_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf13_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf13_hh10_NN.dat'  sf13_hh10_est   -ASCII
%end
figure('Name','modeled sf13');clf;
plot(sf13_fixed_hh10(ind_sim),'b'); hold on;
plot(sf13_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #14
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf14_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf14_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf14_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf14_hh10_NN.dat'  sf14_hh10_est   -ASCII
%end
figure('Name','modeled sf14');clf;
plot(sf14_fixed_hh10(ind_sim),'b'); hold on;
plot(sf14_hh10_est','r.-');
legend('measured sf','Estimated sf');

%SF #15
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf15_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf15_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf15_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf15_hh10_NN.dat'  sf15_hh10_est   -ASCII
%end
figure('Name','modeled sf15');clf;
plot(sf15_fixed_hh10(ind_sim),'b'); hold on;
plot(sf15_hh10_est','r.-');
legend('measured sf','Estimated sf');

%% Thinned Plot

load 'C:\MacKay\Masters\data\hhour\sf16_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf17_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf18_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf19_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\sf20_hh10.dat';

[sf16_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf16_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf16_fixed_hh10.dat'  sf16_fixed_hh10   -ASCII
[sf17_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf17_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf17_fixed_hh10.dat'  sf17_fixed_hh10   -ASCII
[sf18_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf18_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf18_fixed_hh10.dat'  sf18_fixed_hh10   -ASCII
[sf19_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf19_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf19_fixed_hh10.dat'  sf19_fixed_hh10   -ASCII
[sf20_fixed_hh10] = mcm_CPEC_outlier_removal('TP39', sf20_hh10, 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\sf20_fixed_hh10.dat'  sf20_fixed_hh10   -ASCII


%SF #16
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf16_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf16_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf16_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf16_hh10_NN.dat'  sf16_hh10_est   -ASCII
%end
figure('Name','modeled sf16');clf;
plot(sf16_fixed_hh10(ind_sim),'b'); hold on;
plot(sf16_hh10_est','r.-');
legend('measured sf','Estimated sf');



%SF #17
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf17_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf17_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf17_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf17_hh10_NN.dat'  sf17_hh10_est   -ASCII
%end
figure('Name','modeled sf17');clf;
plot(sf17_fixed_hh10(ind_sim),'b'); hold on;
plot(sf17_hh10_est','r.-');
legend('measured sf','Estimated sf');


%SF #18
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf18_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf18_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf18_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf18_hh10_NN.dat'  sf18_hh10_est   -ASCII
%end
figure('Name','modeled sf18');clf;
plot(sf18_fixed_hh10(ind_sim),'b'); hold on;
plot(sf18_hh10_est','r.-');
legend('measured sf','Estimated sf');



%SF #19
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf19_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf19_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf19_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf19_hh10_NN.dat'  sf19_hh10_est   -ASCII
%end
figure('Name','modeled sf19');clf;
plot(sf19_fixed_hh10(ind_sim),'b'); hold on;
plot(sf19_hh10_est','r.-');
legend('measured sf','Estimated sf');



%SF #20
ind_use = find(~isnan(Ts_5cm_Drought_HH10_filled.*sf20_fixed_hh10.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));
nn_inputs = [Rn_HH10(ind_use) Ts_5cm_Drought_HH10_filled(ind_use) SM_root_Ref_HH10_filled(ind_use) VPD_HH10_filled(ind_use)];
nn_targsf = sf20_fixed_hh10(ind_use);
nsf = newfit(nn_inputs',nn_targsf',30);
nsf=train(nsf,nn_inputs',nn_targsf');
ind_sim = find(~isnan(Ts_5cm_Drought_HH10_filled.*Rn_HH10.*SM_root_Ref_HH10_filled.*VPD_HH10_filled));

sim_inputs = [Rn_HH10(ind_sim) Ts_5cm_Drought_HH10_filled(ind_sim) SM_root_Ref_HH10_filled(ind_sim) VPD_HH10_filled(ind_sim)];
% Predict LE using NN output
[Y,Pf,Af,E,perf] = sim(nsf,sim_inputs');
sf20_hh10_est = Y';
save 'C:\MacKay\Masters\data\hhour\model\sf20_hh10_NN.dat'  sf20_hh10_est   -ASCII
%end
figure('Name','modeled sf20');clf;
plot(sf20_fixed_hh10(ind_sim),'b'); hold on;
plot(sf20_hh10_est','r.-');
legend('measured sf','Estimated sf');
