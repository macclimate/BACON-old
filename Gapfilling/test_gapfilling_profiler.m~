% Test_Gapfilling_profiler
tic
ls = addpath_loadstart;
load([ls 'Matlab/Data/Master_Files/TP39/TP39_gapfill_data_in.mat']);
data = trim_data_files(data,2008,2010,1);
data.Ustar_th = 0.325;
data.NEE_std = NEE_random_error_estimator_v6(data,[],0.325,-9);
data.costfun = 'WSS';

[final_out1 f_out1] = mcm_Gapfill_SiteSpec(data, [], -9);
[final_out2 f_out2] = mcm_Gapfill_MDS_Reichstein(data, -9);
[final_out3 f_out3] = mcm_Gapfill_FCRN(data, [], -9);
[final_out4 f_out4] = mcm_Gapfill_LRC_JJB1_noVPD(data, -9);
[final_out5 f_out5] = mcm_Gapfill_LRC_Lasslop_noVPD(data, -9);
[final_out6 f_out6] = mcm_Gapfill_MDS_JJB1(data, -9);
t = toc;

allsums = [final_out1.master.sums; final_out2.master.sums; final_out3.master.sums; final_out4.master.sums; final_out5.master.sums;  final_out6.master.sums];

for i = 1:1:6
    tmp_clean = eval(['final_out' num2str(i) '.master.NEE_clean;']);
    tmp_pred = eval(['final_out' num2str(i) '.master.NEE_pred;']);
    
stats_tmp = model_stats(tmp_pred,tmp_clean);

end

figure(3);clf;
ind = find(data.RE_flag == 2 & (data.Ustar >= data.Ustar_th | data.PAR > 15));
plot(ind,data.NEE(ind),'k.'); hold on;
clrs = jjb_get_plot_colors;
for i = 1:1:6
tmp = eval(['final_out' num2str(i) '.master.RE_pred;']);
    h1(i) = plot(tmp,'Color',clrs(i,:));hold on;
clear tmp;
end
legend(h1,num2str((1:1:i)'));

figure(4);clf;
clrs = jjb_get_plot_colors;
for i = 1:1:6
tmp = eval(['final_out' num2str(i) '.master.GEP_pred;']);
    h2(i) = plot(tmp,'Color',clrs(i,:));hold on;
clear tmp;
end
legend(h2,num2str((1:1:i)'));