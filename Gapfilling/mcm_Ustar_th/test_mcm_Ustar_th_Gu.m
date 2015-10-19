% test_mcm_Ustar_th_Gu.m

load('/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_gapfill_data_in.mat');
data = trim_data_files(data,2003,2010,1);
data.NEEstd = NEE_random_error_estimator_v6(data,[],0.3,-9);
[Ustar_th f_plot ttime] = mcm_Ustar_th_Gu(data, 25);
ustar_tmp = data.Ustar;
%%% Separate - try to replace Ustar_th with sigma_w and see what happens:
data.Ustar = data.w_std;
[sigma_th f_plot2 ttime2] = mcm_Ustar_th_Gu(data, 25);

%%% Try out mcm_ustar_th_JJB using sigma_w instead of ustar:
[sigma_th_JJB f_out] = mcm_Ustar_th_JJB(data, 1,'seas');
data.Ustar = ustar_tmp;
[ustar_th_JJB f_out2] = mcm_Ustar_th_JJB(data, 1,'monthly');


% ths = unique(Ustar_th);
% Ustar_th_seas = reshape(ths,4,[]);

clrs = jjb_get_plot_colors;
figure(3);clf;
for i = 2003:1:2010
    h(i-2002) = plot(Ustar_th(data.Year == i),'-','Color',clrs(i-2002,:));hold on;
end
    legend(h,num2str((2003:1:2010)'));

% % Specifies the divisions for which u*th will be calculated separately
% seas = [1 3; 4 6; 7 9; 10 12];
% for i = 1:1:length(seas)
% data_in.Ustar = data.Ustar(data.Month >= seas(i,1) & data.Month <= seas(i,2));
% data_in.Ts5 = data.Ts5(data.Month >= seas(i,1) & data.Month <= seas(i,2));
% data_in.RE_flag = data.RE_flag(data.Month >= seas(i,1) & data.Month <= seas(i,2));
% data_in.NEEstd = data.NEEstd(data.Month >= seas(i,1) & data.Month <= seas(i,2));
% data_in.NEE = data.NEE(data.Month >= seas(i,1) & data.Month <= seas(i,2));
% [u_th_low(i,1) u_th_high(i,1) u_th_list_outer(i).out] = mcm_Ustar_th_Gu(data_in);
% 
% end
