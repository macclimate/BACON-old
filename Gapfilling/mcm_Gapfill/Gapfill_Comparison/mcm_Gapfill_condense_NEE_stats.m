function [] = mcm_Gapfill_condense_NEE_stats()

clear all;

% Load all stats and sum information:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Flux/Gapfilling/'];
sites = {'TP39';'TP74';'TP89';'TP02'};
stats_list = {'BE'; 'rRMSE'; 'NRMSE'; 'AIoA'; 'NMAE'; 'Ei'; 'WESS'; 'WrRMSE'};
model_list = {'SiteSpec'; 'FCRN';'ANN_JJB1';'HOWLAND';'MDS_JJB1'};
fp_tags = {'FP_on';'FP_off'};
sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};

for i = 1:1:length(sites)
    tmp = load([load_path sites{i,1} '/NEE_GEP_RE/recalc_stats.mat']);
    eval(['stats_' sites{i,1} ' = tmp;']);
    tmp2 = load([load_path sites{i,1} '/NEE_GEP_RE/recalc_sums.mat']);
    eval(['sums_' sites{i,1} ' = tmp2;']);
    clear tmp*
end
stats_flag = [];
sums_flag = [];
    %%% Set all stats to empty:
    for j = 1:1:length(stats_list)
        eval([stats_list{j,1} ' = [];']);
    end
    final_sums = [];
%%% Turn these structures into a large flag file:
for site_ctr = 1:1:length(sites)
    stats = eval(['stats_' sites{site_ctr,1} '.stats']);
    sums = eval(['sums_' sites{site_ctr,1} '.sums']);
    
    %%% Cycle through each model output:
    for i = 1:1:length(stats);
        site = sites{site_ctr,1};
        model_flag = find(strcmp(model_list,sums(i).model)==1);
        fp_flag = find(strcmp(fp_tags,sums(i).fp)==1);
        ust_tmp = sums(i).u_th(7:end);
        %%% Turn ust_tmp into useable flag:
        if ~isempty(str2num(ust_tmp))
            ustar_flag = str2num(ust_tmp);
        else
            if strcmp(ust_tmp,'Reich') == 1
                ustar_flag = 0.56;
            elseif strcmp(ust_tmp,'JJB') == 1
                ustar_flag = 0.66;
            end
        end
        clear ust_tmp;
        
        flags = [str2num(site(3:4)) model_flag fp_flag ustar_flag];
              
%%%% STATS: %%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
         final_sums = [final_sums; sums(i).sums(1:end,2:end)];
            for kk = 1:1:size(sums(i).sums(1:end,2:end),1)
               sums_flag = [sums_flag; [flags sums(i).sums(kk,1)]]; 
            end
        catch err2
             disp(['Error doing sums for: ' stats(i).model]);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        try
        %%% Create the Flag File:
        %%% Get all-years stats:
        for j = 1:1:length(stats_list)
            eval(['tmp = stats(i).all.stats.' stats_list{j,1} ';']);  
            eval([stats_list{j,1} ' = [' stats_list{j,1} '; tmp];']);
            clear tmp;
        end
        stats_flag = [stats_flag; [flags 9999]];
        
        %%% Get each indiv-year stats:
        for yr_ctr = 1:1:length(stats(i).annual)
        for j = 1:1:length(stats_list)
            eval(['tmp = stats(i).annual(yr_ctr).stats.' stats_list{j,1} ';']);  
            eval([stats_list{j,1} ' = [' stats_list{j,1} '; tmp];']);
            clear tmp;
        end
         stats_flag = [stats_flag; [flags stats(i).annual(yr_ctr).year]];
        end
        catch err1
            disp(['Stats did not work for: ' stats(i).model])
        end
    end
    
        clear stats sums;
end
%% Output the data:
sums.flags = sums_flag;
sums.sums = final_sums;

stats.flags = stats_flag;
    for j = 1:1:length(stats_list)
        eval(['stats.' stats_list{j,1} ' = ' stats_list{j,1}  ';']);
    end

%%% Save to the /Flux/Gapfilling/ Directory:
save([load_path 'NEE_sums.mat'],'sums');
save([load_path 'NEE_stats.mat'],'stats');

%% &&&&&&&&&&&&&&&& PLOTTING &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

% Load the NACP data:
path = '/1/fielddata/Matlab/Data/NACP/';
[data NACP_sum header] = Load_NACP_data(path, 2003:2007);


%%% Work on ways to plot all of this data:
[clrs clr_guide] = jjb_get_plot_colors;
clear h1;
f1 = figure();clf;
for yr_ctr = 2003:1:2010
    for mod_ctr = 1:1:3
    ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.3);
    h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
    ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.66);
    plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
%     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.25);
%     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
    end
    if yr_ctr <=2007
    h1(mod_ctr+1,1) = plot(yr_ctr,NACP_sum.FC3(NACP_sum.FC3(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+1,:), 'MarkerSize', 12);
    h1(mod_ctr+2,1) = plot(yr_ctr,NACP_sum.FC4(NACP_sum.FC4(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+2,:), 'MarkerSize', 12);
    h1(mod_ctr+3,1) = plot(yr_ctr,NACP_sum.MDS(NACP_sum.MDS(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+3,:), 'MarkerSize', 12);
    end
    clear ind*
end
% plot_list = model_list;
plot_list = model_list(1:3,1);

plot_list{length(plot_list)+1,1} = 'FC3';
plot_list{length(plot_list)+1,1} = 'FC4';
plot_list{length(plot_list)+1,1} = 'MDS';

legend(h1,plot_list)
    title('square = u*_{TH}JJB, circle = u*_(TH) = 0.3');
axis([2003 2010 -350 150])
    
    %%%%%%
    
    clear h1;
f2 = figure();clf;
for yr_ctr = 2003:1:2010
    for mod_ctr = 1:1:3
    ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.3);
    h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
    ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.66);
    plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
%     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2 & sums_flag(:,4)==0.25);
%     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==2);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
    end
    if yr_ctr <=2007
    h1(mod_ctr+1,1) = plot(yr_ctr,NACP_sum.FC3(NACP_sum.FC3(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+1,:), 'MarkerSize', 12);
    h1(mod_ctr+2,1) = plot(yr_ctr,NACP_sum.FC4(NACP_sum.FC4(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+2,:), 'MarkerSize', 12);
    h1(mod_ctr+3,1) = plot(yr_ctr,NACP_sum.MDS(NACP_sum.MDS(:,1)==yr_ctr,2),'p','MarkerFaceColor',clrs(mod_ctr+3,:), 'MarkerSize', 12);
    end
    clear ind*
end
% plot_list = model_list;
plot_list = model_list(1:3,1);

plot_list{length(plot_list)+1,1} = 'FC3';
plot_list{length(plot_list)+1,1} = 'FC4';
plot_list{length(plot_list)+1,1} = 'MDS';

legend(h1,plot_list)
    title('square = u*_{TH}JJB, circle = u*_(TH) = 0.3');
    axis([2003 2010 -350 150])

    
    %%%
        clear h3;
f3 = figure();clf;
for yr_ctr = 2003:1:2010
    for mod_ctr = 1:1:3
    ind1 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.3);
    h3(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),WrRMSE(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
    ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.66);
    plot(yr_ctr.*ones(length(ind2),1),WrRMSE(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
%     ind3 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.25);
%     plot(yr_ctr.*ones(length(ind3),1),final_stats(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
%     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2);
%     plot(yr_ctr.*ones(length(ind2),1),final_stats(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
    end

    clear ind*
end
% plot_list = model_list;
plot_list = model_list(1:3,1);

legend(h3,plot_list)
    title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
    axis([2003 2010 0.12 0.18])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear h4;
f4 = figure();clf;
for yr_ctr = 2003:1:2010
    for mod_ctr = 1:1:3
    ind1 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.3);
    h4(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),BE(ind1,1),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
    ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.66);
    plot(yr_ctr.*ones(length(ind2),1),BE(ind2,1),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
%     ind3 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2 & stats_flag(:,4)==0.25);
%     plot(yr_ctr.*ones(length(ind3),1),final_stats(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
%     ind2 = find(stats_flag(:,1) == 39 & stats_flag(:,5) == yr_ctr & stats_flag(:,2)==mod_ctr & stats_flag(:,3)==2);
%     plot(yr_ctr.*ones(length(ind2),1),final_stats(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
    end

    clear ind*
end
% plot_list = model_list;
plot_list = model_list(1:3,1);

legend(h4,plot_list)
    title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
    axis([2003 2010 -0.06 0.06])
    
    %%%%%%%%%% Annual Respiration
    clear h1;
f5 = figure();clf;
for yr_ctr = 2003:1:2010
    for mod_ctr = 1:1:3
    ind1 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.3);
    h1(mod_ctr,1) = plot(yr_ctr.*ones(length(ind1),1),final_sums(ind1,5),'o','MarkerFaceColor',clrs(mod_ctr,:)); hold on;
    ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.66);
    plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,5),'s','MarkerFaceColor',clrs(mod_ctr,:)); hold on;   
%     ind3 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1 & sums_flag(:,4)==0.25);
%     plot(yr_ctr.*ones(length(ind3),1),final_sums(ind3,1),'v','MarkerFaceColor',clrs(mod_ctr,:)); hold on;    
%     ind2 = find(sums_flag(:,1) == 39 & sums_flag(:,5) == yr_ctr & sums_flag(:,2)==mod_ctr & sums_flag(:,3)==1);
%     plot(yr_ctr.*ones(length(ind2),1),final_sums(ind2,1),'x','Color',clrs(mod_ctr,:),'MarkerSize',8);    
    end
   clear ind*
end
% plot_list = model_list;
plot_list = model_list(1:3,1);

legend(h1,plot_list)
    title('square = u*_{TH}JJB, circle = u*_{TH} = 0.3');
axis([2003 2010 1100 1600])
grid on;