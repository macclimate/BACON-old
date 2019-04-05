function [] = SHARC_test_NN()
site = 'TP39';
year = 2003:2010;
year_start = min(year);
year_end = max(year);

%% Declare Paths and Load the data:
%%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/'];

%%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
data = trim_data_files(data,year_start, year_end,1);
data.site = site; close all

data.Ustar_th = 0.325.*ones(length(data.Year),1);

[data.NEE_std f_fit f_std] = NEE_random_error_estimator_v6(data,[],[],0);

[final_out f_out] = mcm_Gapfill_ANN_JJB1(data, [], 0);

disp('done!!');
