%% This script is used to get daily averaged & summed GEP values for all 
%  sites from  2003--2007.  This data will be distributed to UofT.
clear all;
close all;
loadstart = addpath_loadstart;

load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP39.mat']);
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP74.mat']);
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP89.mat']);
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP02.mat']);

TP39_GEP_sum(1:366,1:5) = NaN; TP39_GEP_mean(1:366,1:5) = NaN;
TP74_GEP_sum(1:366,1:5) = NaN; TP74_GEP_mean(1:366,1:5) = NaN;
TP89_GEP_sum(1:366,1:5) = NaN; TP89_GEP_mean(1:366,1:5) = NaN;
TP02_GEP_sum(1:366,1:5) = NaN; TP02_GEP_mean(1:366,1:5) = NaN;

for yr_loop = 2003:1:2007
    yr_ctr = yr_loop-2002;
    
    TP39_tmp = TP39(yr_ctr).GEP;     TP74_tmp = TP74(yr_ctr).GEP; 
    TP89_tmp = TP89(yr_ctr).GEP;     TP02_tmp = TP02(yr_ctr).GEP;     
    figure(yr_ctr); clf;
    plot(TP39_tmp)
    hold on;
    plot(TP74_tmp,'r')
    plot(TP89_tmp,'g')
    plot(TP02_tmp,'c')

    
    day_ctr = 1;
    for i = 1:48:length(TP39_tmp)
        TP39_GEP_sum(day_ctr, yr_ctr) = nansum(TP39_tmp(i:i+47))*0.0216;
        TP39_GEP_mean(day_ctr, yr_ctr) = nanmean(TP39_tmp(i:i+47))*0.0216;
        TP74_GEP_sum(day_ctr, yr_ctr) = nansum(TP74_tmp(i:i+47))*0.0216;
        TP74_GEP_mean(day_ctr, yr_ctr) = nanmean(TP74_tmp(i:i+47))*0.0216;
        TP89_GEP_sum(day_ctr, yr_ctr) = nansum(TP89_tmp(i:i+47))*0.0216;
        TP89_GEP_mean(day_ctr, yr_ctr) = nanmean(TP89_tmp(i:i+47))*0.0216;
        TP02_GEP_sum(day_ctr, yr_ctr) = nansum(TP02_tmp(i:i+47))*0.0216;
        TP02_GEP_mean(day_ctr, yr_ctr) = nanmean(TP02_tmp(i:i+47))*0.0216;

        day_ctr = day_ctr + 1;
        
        
    end
    clear TP39_tmp TP74_tmp TP89_tmp TP02_tmp;
    
    figure(yr_ctr+5)
    plot(TP39_GEP_sum(:,yr_ctr));
      hold on;
    plot(TP74_GEP_sum(:,yr_ctr),'r')
    plot(TP89_GEP_sum(:,yr_ctr),'g')
    plot(TP02_GEP_sum(:,yr_ctr),'c')

        
end


save([loadstart 'Matlab/Data/Distributed/TP39_GEP_dailysum_2003_2007.dat'],'TP39_GEP_sum','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP39_GEP_dailymean_2003_2007.dat'],'TP39_GEP_mean','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP74_GEP_dailysum_2003_2007.dat'],'TP74_GEP_sum','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP74_GEP_dailymean_2003_2007.dat'],'TP74_GEP_mean','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP89_GEP_dailysum_2003_2007.dat'],'TP89_GEP_sum','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP89_GEP_dailymean_2003_2007.dat'],'TP89_GEP_mean','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP02_GEP_dailysum_2003_2007.dat'],'TP02_GEP_sum','-ASCII');
save([loadstart 'Matlab/Data/Distributed/TP02_GEP_dailymean_2003_2007.dat'],'TP02_GEP_mean','-ASCII');



