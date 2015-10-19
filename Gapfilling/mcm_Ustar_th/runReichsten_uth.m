%%% Testing Reichstein u*_th determination:
clear all;
close all;
site = 'TP39';
%%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
% data.site = site;
%%% trim data to fit with the years selected:
%%% Setting final argument to 1 also calculates GDD and VPD:
data = trim_data_files(data,2003, 2009,1);
data.site = site;
close all
% master = mcm_Gapfill_MDS_Reichstein(data,1,0);
master = mcm_Gapfill_MDS_JJB1(data,1,0);
% ctr = 1;
% for year = 2003:1:2009
%     rn = (1:1:yr_length(year,30))';
%     [bstat bsam] = bootstrp(100, @mean,rn);
%     Month_temp = data.Month(data.Year == year);
%     Ts5_temp = data.Ts5(data.Year == year);
%     Ustar_temp = data.Ustar(data.Year == year);
%     RE_flag_temp = data.RE_flag(data.Year == year);
%     NEE_temp = data.NEE(data.Year == year);
%     
%     
%     tic
%     for bsnum = 1:1:100
%     Month_in = Month_temp(bsam(:,bsnum));
%     Ts5_in = Ts5_temp(bsam(:,bsnum));
%     Ustar_in = Ustar_temp(bsam(:,bsnum));
%     RE_flag_in = RE_flag_temp(bsam(:,bsnum));
%     NEE_in = NEE_temp(bsam(:,bsnum));
% 
%     for month = 1:1:12
%         ind = find(Month_in == month);
% [T_mean Ustar_mean Fc_mean Fc_ratio u_th_est final(ctr).u_th(bsnum,month)] = ...
% Reichsten_uth(NEE_in(ind), Ts5_in(ind), Ustar_in(ind), RE_flag_in(ind));
%     end
%     end
%     t = toc;
%     disp(['One year (100 bstraps) done in t = ' num2str(t) ' seconds.']);
% % figure('Name', num2str(year));clf;
% % h = plot(Fc_ratio'); hold on;
% % legend(h,'T1','T2','T3','T4','T5','T6');
% % plot([0 20], [0.95 0.95],'r--');
% % axis([0 20 0 1.2])
% ctr = ctr + 1;
% 
% end
% %%% Plotting:
% clrs = [1 0 0; 0.5 0 0; 0 1 0; 0.8 0.5 0.7; 0 0 1; 0.2 0.1 0.1; ...
%     1 1 0; 0.4 0.5 0.1; 1 0 1; 0.9 0.9 0.4; 0 1 1; 0.4 0.8 0.1];
% close all;
% f1 = figure('Name', 'Years superimposed','Tag','All_yrs');
% all_ustar_th = [];
% ctr = 1;
% for year = 2003:1:2009
%     all_ustar_th = [all_ustar_th; final(1,ctr).u_th(1:100,1:12)];
% figure('Name', ['Monthly u*_{TH}, Year = ' num2str(year)]);clf;
% boxplot(final(1,ctr).u_th(1:100,1:12));figure(gcf);
% 
% figure(f1)
% boxplot(final(1,ctr).u_th(1:100,1:12),'colors', clrs(ctr, :),'medianstyle','target'); hold on;
% 
% ctr = ctr+1;
% end
% 
% figure('Name', 'Monthly u*_{TH}, All Years');clf;
% boxplot(all_ustar_th);figure(gcf);
% tilefigs;
% % % 
% % % 
% % % 
% % % 
% % % h1 = plot(final_u_th'); hold on;
% % % 
% % % mean_u_th = mean(final_u_th);
% % % med_u_th = median(final_u_th);
% % % 
% % % h2(1,1) = plot(mean_u_th','o-','Color',[0.8 0.8 0.8],'LineWidth',4);
% % % h2(2,1) = plot(med_u_th','o-','Color',[0.4 0.4 0.4],'LineWidth',4); 
% % % legend([h1;h2],[num2str((2003:1:2009)'); 'Mean';'Medn']);
% % % grid on;
