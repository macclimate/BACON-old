% mcm_Gapfill_Compare2.m
%%% Required functions, data:
% 1. jjb_get_plot_colors.m
% 2. Load_NACP_data.m
% 3. NACP data
% 

clear all;
close all;
%%% Declare Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Flux/Gapfilling/'];
NACP_path = [ls 'Matlab/Data/NACP/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/Gapfill_Compare/'];
jjb_check_dirs(fig_path);
%%% Labels, Tags, etc.
sites = {'TP39';'TP74';'TP89';'TP02'};
site_tag = [39;74;89;02];
old_uth = [0.3;0.2;0.25;0.15];
stats_list = {'BE'; 'Ei'; 'WrRMSE'};
model_list = {'SiteSpec'; 'FCRN';'ANN_JJB1';'HOWLAND';'MDS_JJB1'};
fp_tags = {'FP_on';'FP_off'};
sum_labels = {'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};

%%% Plot colors:
[clrs clr_guide] = jjb_get_plot_colors;

%% Load Data:
%%% Load stats and sums data from the /Flux/Gapfilling/ Directory:
load([load_path 'NEE_sums.mat']);
load([load_path 'NEE_stats.mat']);

%%% Load the NACP data:
%%% in NACP_sum, NEE = column 2; RE = column 4; GPP = column 5 %%%
[NACP_data NACP_sum NACP_header] = Load_NACP_data(NACP_path, 2003:2007);

%% &&&&&&&&&&&&&&&& PLOTTING &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%%% What combinations do we want to plot?
%%%% 1. For "Old" setup (old u*_thresh values, SiteSpec method, fp_off)
%%%% 2. For "New" setup (JJB u*_thresh , [SiteSpec, FCRN, ANN], fp_on)
%%%% 3. NACP values (for 2003:2007 @ TP39)

%%% What information do we want to show?
%%%% 1. NEE, GEP, RE annual totals
%%%% 2. Stats: [BE WrRMSE WESS Ei]

%%% Notation:
%%%% Different models = different colors
%%%% "old" setup = circle; "new" setup = square; 
NACP_cols = [2; 5; 4]; % Cols for NEE | GEP | RE
sums_cols = [1; 3; 5]; % Cols for NEE | GEP | RE
comp_tags = {'NEE'; 'GEP'; 'RE'};
max_yrs = [2010;2010;2007; 2010];


%% FIGURE 1:
%%% Plot NEE, RE and GEP annual sums for each site:
for i = 1:1:length(sites)
    f1(i) = figure();clf;
    for j = 1:1:3 % Loop through NEE, GEP, RE
    subplot(3,1,j)
    h_tmp = [];
    h1 = [];
    for yr_ctr = 2003:1:max_yrs(i)
         
        %%% Plot the NACP results
        if yr_ctr <=2007 && site_tag(i) == 39
            h_tmp(1,1) = plot(yr_ctr,NACP_sum.FC3(NACP_sum.FC3(:,1)==yr_ctr,NACP_cols(j,1)),'p','MarkerFaceColor',clrs(1,:),'MarkerEdgeColor',clrs(1,:), 'MarkerSize', 9);hold on;
            h_tmp(2,1) = plot(yr_ctr,NACP_sum.FC4(NACP_sum.FC4(:,1)==yr_ctr,NACP_cols(j,1)),'p','MarkerFaceColor',clrs(2,:),'MarkerEdgeColor',clrs(1,:), 'MarkerSize', 9);
           if j == 1
            h_tmp(3,1) = plot(yr_ctr,NACP_sum.MDS(NACP_sum.MDS(:,1)==yr_ctr,NACP_cols(j,1)),'p','MarkerFaceColor',clrs(3,:),'MarkerEdgeColor',clrs(1,:), 'MarkerSize', 9);
           end
        end

        
        %%% Plot the "old" results:
        ind_old = find(sums.flags(:,1) == site_tag(i) & sums.flags(:,5) == yr_ctr & sums.flags(:,2)==1 & sums.flags(:,3)==2 & sums.flags(:,4)==old_uth(i,1));
        h1(1,1) = plot(yr_ctr.*ones(length(ind_old),1),sums.sums(ind_old,sums_cols(j,1)),'o','MarkerFaceColor',clrs(4,:),'MarkerEdgeColor',clrs(4,:), 'MarkerSize', 6); hold on;
        plot_list{1,1} = 'old';

        %%% Plot the "new" results:
        for mod_ctr = 1:1:3
            ind_new = find(sums.flags(:,1) == site_tag(i) & sums.flags(:,5) == yr_ctr & sums.flags(:,2)==mod_ctr & sums.flags(:,3)==1 & sums.flags(:,4)==0.66);
            h1(mod_ctr+1,1) = plot(yr_ctr.*ones(length(ind_new),1),sums.sums(ind_new,sums_cols(j,1)),'s','MarkerFaceColor',clrs(4+mod_ctr,:),'MarkerEdgeColor',clrs(4+mod_ctr,:), 'MarkerSize', 6); hold on;
        plot_list{1+mod_ctr,1} = model_list{mod_ctr,1};
        end
        clear ind*
    end
    h1 = [h1; h_tmp];
    if ~isempty(h_tmp)==1
    plot_list{length(plot_list)+1,1} = 'FC3';
    plot_list{length(plot_list)+1,1} = 'FC4';
    plot_list{length(plot_list)+1,1} = 'MDS';
    end
    if j == 1
    legend(h1, plot_list,'Orientation', 'horizontal');
    end
    title([comp_tags{j,1} ', ' sites{i,1}]);
    axis tight; grid on;
    end
    print('-dpdf',[fig_path sites{i,1} '_sums']);
    saveas(f1(i),[fig_path sites{i,1} '_sums.fig'])
end

%% FIGURE 2:
%%% Plot NEE stats for each site:
for i = 1:1:length(sites)
    f2(i) = figure();clf;
    for j = 1:1:3 % Loop through BE, Ei, WrRMSE:
        stats_to_plot = eval(['stats.' stats_list{j,1}]);
    subplot(3,1,j)
    h1 = [];
    for yr_ctr = 2003:1:max_yrs(i)
           
        %%% Plot the "old" results:
        ind_old = find(stats.flags(:,1) == site_tag(i) & stats.flags(:,5) == yr_ctr & stats.flags(:,2)==1 & stats.flags(:,3)==2 & stats.flags(:,4)==old_uth(i,1));
        h1(1,1) = plot(yr_ctr.*ones(length(ind_old),1),stats_to_plot(ind_old,1),'o','MarkerFaceColor',clrs(4,:),'MarkerEdgeColor',clrs(4,:), 'MarkerSize', 6); hold on;
        plot_list{1,1} = 'old';

        %%% Plot the "new" results:
        for mod_ctr = 1:1:3
            ind_new = find(stats.flags(:,1) == site_tag(i) & stats.flags(:,5) == yr_ctr & stats.flags(:,2)==mod_ctr & stats.flags(:,3)==1 & stats.flags(:,4)==0.66);
            h1(mod_ctr+1,1) = plot(yr_ctr.*ones(length(ind_new),1),stats_to_plot(ind_new,1),'s','MarkerFaceColor',clrs(4+mod_ctr,:),'MarkerEdgeColor',clrs(4+mod_ctr,:), 'MarkerSize', 6); hold on;
        plot_list{1+mod_ctr,1} = model_list{mod_ctr,1};
        end
        clear ind*
    end
    
    if j == 1
    legend(h1, plot_list,'Orientation', 'horizontal');
    end
    title([stats_list{j,1} ', ' sites{i,1}]);
    axis tight; grid on;
    end
    print('-dpdf',[fig_path sites{i,1} '_stats']);
    saveas(f2(i),[fig_path sites{i,1} '_stats.fig'])
end


% 
% %%% Work on ways to plot all of this data:
% clear h1;
% f1 = figure();clf;
% for yr_ctr = 2003:1:2010
%     for mod_ctr = 1:1:3
%     ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.3);
%     h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.66);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
% %     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.25);
% %     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
% %     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1);
% %     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
%     end
%     if yr_ctr <=2007
%     h1(mod_ctr+1,1) = plot(yr_ctr,NACP_sum.FC3(NACP_sum.FC3(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+1,:), 'MarkerSize', 12);
%     h1(mod_ctr+2,1) = plot(yr_ctr,NACP_sum.FC4(NACP_sum.FC4(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+2,:), 'MarkerSize', 12);
%     h1(mod_ctr+3,1) = plot(yr_ctr,NACP_sum.MDS(NACP_sum.MDS(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+3,:), 'MarkerSize', 12);
%     end
%     clear ind*
% end
% % plot_list = model_list;
% plot_list = model_list(1:3,1);
% 
% plot_list{length(plot_list)+1,1} = 'FC3';
% plot_list{length(plot_list)+1,1} = 'FC4';
% plot_list{length(plot_list)+1,1} = 'MDS';
% 
% legend(h1,plot_list)
%     title('square = u*_{TH}JJB, circle = u*_(TH) = 0.3');
% axis([2003 2010 -350 150])
%     
%     %%%%%%
%     
%     clear h1;
% f2 = figure();clf;
% for yr_ctr = 2003:1:2010
%     for mod_ctr = 1:1:3
%     ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.3);
%     h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.66);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
% %     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.25);
% %     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
% %     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2);
% %     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
%     end
%     if yr_ctr <=2007
%     h1(mod_ctr+1,1) = plot(yr_ctr,NACP_sum.FC3(NACP_sum.FC3(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+1,:), 'MarkerSize', 12);
%     h1(mod_ctr+2,1) = plot(yr_ctr,NACP_sum.FC4(NACP_sum.FC4(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+2,:), 'MarkerSize', 12);
%     h1(mod_ctr+3,1) = plot(yr_ctr,NACP_sum.MDS(NACP_sum.MDS(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+3,:), 'MarkerSize', 12);
%     end
%     clear ind*
% end
% % plot_list = model_list;
% plot_list = model_list(1:3,1);
% 
% plot_list{length(plot_list)+1,1} = 'FC3';
% plot_list{length(plot_list)+1,1} = 'FC4';
% plot_list{length(plot_list)+1,1} = 'MDS';
% 
% legend(h1,plot_list)
%     title('square = u*_{TH}JJB, circle = u*_(TH) = 0.3');
%     axis([2003 2010 -350 150])
% 
%     
%     %%%
%         clear h3;
% f3 = figure();clf;
% for yr_ctr = 2003:1:2010
%     for mod_ctr = 1:1:3
%     ind1 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.3);
%     h3(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),WrRMSE(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
%     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.66);
%     plot(yr_ctr.*ones(length(ind2),1),WrRMSE(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
% %     ind3 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.25);
% %     plot(yr_ctr.*ones(length(ind3),1),final_stats(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
% %     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2);
% %     plot(yr_ctr.*ones(length(ind2),1),final_stats(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
%     end
% 
%     clear ind*
% end
% % plot_list = model_list;
% plot_list = model_list(1:3,1);
% 
% legend(h3,plot_list)
%     title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
%     axis([2003 2010 0.12 0.18])
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             clear h4;
% f4 = figure();clf;
% for yr_ctr = 2003:1:2010
%     for mod_ctr = 1:1:3
%     ind1 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.3);
%     h4(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),BE(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
%     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.66);
%     plot(yr_ctr.*ones(length(ind2),1),BE(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
% %     ind3 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.25);
% %     plot(yr_ctr.*ones(length(ind3),1),final_stats(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
% %     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2);
% %     plot(yr_ctr.*ones(length(ind2),1),final_stats(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
%     end
% 
%     clear ind*
% end
% % plot_list = model_list;
% plot_list = model_list(1:3,1);
% 
% legend(h4,plot_list)
%     title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
%     axis([2003 2010 -0.06 0.06])
%     
%     %%%%%%%%%% Annual Respiration
%     clear h1;
% f5 = figure();clf;
% for yr_ctr = 2003:1:2010
%     for mod_ctr = 1:1:3
%     ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.3);
%     h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,5),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.66);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,5),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
% %     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.25);
% %     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
% %     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1);
% %     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
%     end
%    clear ind*
% end
% % plot_list = model_list;
% plot_list = model_list(1:3,1);
% 
% legend(h1,plot_list)
%     title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
% axis([2003 2010 1100 1600])
% grid on;