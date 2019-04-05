%% jjb_load_precip
%%% This script loads delhi precip data and outputs monthly sums and means
%%% for each year:
% Load data:
data = dlmread('C:\HOME\MATLAB\Data\Ancillary Data\Delhi_Day_Precip_2002_2007.csv');

[PPT2003_mon_sum PPT2003_mon_mean] = jjb_month_stats(2003,data(1:365,2));
[PPT2004_mon_sum PPT2004_mon_mean] = jjb_month_stats(2004,data(1:366,3));
[PPT2005_mon_sum PPT2005_mon_mean] = jjb_month_stats(2005,data(1:365,4));
[PPT2006_mon_sum PPT2006_mon_mean] = jjb_month_stats(2006,data(1:365,5));

save('C:\HOME\MATLAB\Data\Data_Analysis\Precip_data\PPT2003_mon_sum.dat','PPT2003_mon_sum','-ASCII');
save('C:\HOME\MATLAB\Data\Data_Analysis\Precip_data\PPT2004_mon_sum.dat','PPT2004_mon_sum','-ASCII');
save('C:\HOME\MATLAB\Data\Data_Analysis\Precip_data\PPT2005_mon_sum.dat','PPT2005_mon_sum','-ASCII');
save('C:\HOME\MATLAB\Data\Data_Analysis\Precip_data\PPT2006_mon_sum.dat','PPT2006_mon_sum','-ASCII');



