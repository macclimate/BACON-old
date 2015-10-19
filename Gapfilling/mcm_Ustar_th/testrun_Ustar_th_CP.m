clear all; 
close all;
load('/home/brodeujj/Projects/fielddata/Matlab/Data/Master_Files/TP39/TP39_gapfill_data_in.mat');

data = trim_data_files(data,2005,2011,1);

% Run the Ustar_th method:
plot_flag = 1;
window_mode = 'monthly';
num_bs = 50;

[Ustar_th f_out diagn] = mcm_Ustar_th_CP(data, plot_flag,window_mode,num_bs);

