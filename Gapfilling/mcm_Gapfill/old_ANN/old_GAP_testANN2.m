% GAP_testANN2.m
%%% This is the second script written for the GAP paper.
%%% The purpose of this script is to compare the ANN with the other methods
%%% of NEE estimation
%%% Goals:
% 1. Write smaller nested-functions that can apply the NEE estimation
% methods
% 2. Run the ANN, FCRN, MCM, HOWLAND, Intercept, and get results:

clear all;

%% Beginning stuff:
site = 'TP39'; year_start = 2003; year_end = 2009; fp_type = 'none'; Ustar_th = 0.325;
clrs = [11 29 138; ... %   1.  dark Blue
    253 127 26; ... %    2. orange
    213 0 25;   ... %    3. dark red
    192 14 198; ... %    4. purple
    25 191 64; ...  %    5. green
    186 191 200; ...%    6. grey
    36 193 227; ... %    7. light blue
    255 183 176; ...%    8. salmon
    102 73 41;   ...%    9. brown
    255 235 11; ... %    10. yellow
    3 97 19; ...    %    11. forest green
    241 16 249; ... %    12. hot purple
    219 151 32;  ...%    13. Burnt Orange
    45 203 175; ... %    14. Teal 
    234 66 15;  ... %    15. Orangered
    234 130 161 ... %    16. Pink
    ]./255;

%%% Declare Paths and Load Data:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/' site '_gapfill_data_in.mat'];
save_path = [ls 'Matlab/Data/GAP_Paper/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/' site '_footprint_flag.mat'];
load(load_path);

data = trim_data_files(data,year_start, year_end, 1);
data.site = site;
data.DOY = round(data.dt);

NEE_cleaned = NaN.*ones(length(data.NEE),1);
%%% Tags:
Tags1 = {'1_30';'1_50';'1_30noyr'};                 symbs1 = {'o';'o';'o'};
Tags2 = {'2_10';'2_30';'2_50'};                     symbs2 = {'s';'s';'s'};
Tags3 = {'3a';'3b';'3c';'3d';'3e';'3f'};            symbs3 = {'p';'p';'p';'p';'p';'p'};
Tags4 = {'4_Sch60';'4_Sch70'; '4_Hs60'; '4_Hs70'};  symbs4 = {'d';'d';'d';'d'};
Tags = [Tags1; Tags2; Tags3; Tags4]; symbs = [symbs1; symbs2; symbs3; symbs4];
%%%%%%% Do Footprint Filtering (if activated); %%%%%%%%%%%%%%%

if strcmpi(fp_type, 'none') == 1;
else
    % Load the footprint flag file:
    load(footprint_path)
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    %%% Remove NEE values when outside of footprint:
    data.NEE = data.NEE.*data.fp_flag;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Make cleaned NEE file:
ind_cleaned = find(~isnan(data.NEE) & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th)));
NEE_cleaned(ind_cleaned,1) = data.NEE(ind_cleaned);
clear ind_cleaned;


%% Run different methods:
%%% For ANN models, need to specify:
%%%% inputs, targets, and include data.Year
target = NEE_cleaned;
year_list = data.Year;
year_start = min(data.Year);
year_end = max(data.Year);

%%%%%%%%%%%%%%%%%% IF NEEDED -- Load NNETS -- else run them all:
loadflag = input('Do you want to try and load NNs?: <1> if yes, <enter> if no. > ');
if loadflag == 1
    for i = 1:1:length(Tags)
        try
            eval(['load(''' save_path 'nnet' Tags{i,1} '.mat'');']);
        catch
            disp(['Could not load nnet' Tags{i,1}]);
        end
    end
else
    %%%%%%%%%%%%%%% Run 1: All-years.  Vary # of nodes and use of data.Year
    %%%%%%%%%%%% 30 nodes
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.Year];
    nnet1_30 = ANN_Gapfill(inputs, target, year_list, 1, 30, 'nnet1_30');
    %%%%%%%%%% Increase nodes to 50
    nnet1_50 = ANN_Gapfill(inputs, target, year_list, 1, 50, 'nnet1_50');
    %%%%%%%%%%%% 30 nodes, but exclude data.Year as variable:
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD];
    nnet1_30noyr = ANN_Gapfill(inputs, target, year_list, 1, 30, 'nnet1_30noyr');
    
    
    %%%%%%%%%% Run 2: Indiv-years.  Indiv Years. Vary # of nodes
    %%%%%%%%%%%% 10 Nodes:
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD];
    nnet2_10 = ANN_Gapfill(inputs, target, year_list, 2, 10, 'nnet2_10');
    %%%%%%%%%%%% 30 Nodes:
    nnet2_30 = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet2_30');
    %%%%%%%%%%%% 50 Nodes:
    nnet2_50 = ANN_Gapfill(inputs, target, year_list, 2, 50, 'nnet2_50');
    
    %%%%%%%%%% Run 3: Indiv-years.  Vary the Variables used.
    %%%%%%%%%% Keep 30 nodes for now:
    %%%%%%% Use all available variables
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.GDD data.DOY];
    nnet3a = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3a');
    %%%%%%%%%% Exclude DOY
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.GDD];
    nnet3b = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3b');
    %%%%%%%%%% Exclude DOY, GDD
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD];
    nnet3c = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3c');
    %%%%%%%%%% Exclude DOY, GDD, VPD
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled];
    nnet3d = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3d');
    %%%%%%%%%% Exclude DOY, GDD, VPD, SM
    inputs = [data.PAR data.Ts5 data.Ta];
    nnet3e = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3e');
    %%%%%%%%%% Exclude DOY, GDD, VPD, SM, Ta
    inputs = [data.PAR data.Ts5];
    nnet3f = ANN_Gapfill(inputs, target, year_list, 2, 30, 'nnet3f');
    
    %%%%%%%%%% Run 4: Apply footprint and assess performance
    load(footprint_path)
    inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.GDD];
    
    %%% For Schuepp - 60
    fp_type = 'Schuepp60';
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    NEE_cleaned_Sch60 = NEE_cleaned.*data.fp_flag;
    nnet4_Sch60 = ANN_Gapfill(inputs, NEE_cleaned_Sch60, year_list, 2, 30, 'nnet4_Sch60');
    
    %%% For Schuepp - 70
    fp_type = 'Schuepp70';
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    NEE_cleaned_Sch70 = NEE_cleaned.*data.fp_flag;
    nnet4_Sch70 = ANN_Gapfill(inputs, NEE_cleaned_Sch70, year_list, 2, 30, 'nnet4_Sch70');
    
     %%% For Hsieh - 60
    fp_type = 'Hsieh60';
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    NEE_cleaned_Hs60 = NEE_cleaned.*data.fp_flag;
    nnet4_Hs60 = ANN_Gapfill(inputs, NEE_cleaned_Hs60, year_list, 2, 30, 'nnet4_Hs60');
       
     %%% For Hsieh - 70
    fp_type = 'Hsieh70';
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    NEE_cleaned_Hs70 = NEE_cleaned.*data.fp_flag;
    nnet4_Hs70 = ANN_Gapfill(inputs, NEE_cleaned_Hs70, year_list, 2, 30, 'nnet4_Hs70');
    
    
    
    %%% Save Nnets
    for i = 1:1:length(Tags)
        eval(['save(''' save_path 'nnet' Tags{i,1} '.mat'',''nnet' Tags{i,1} ''');']);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculate Stats and sums.
% [year sums RMSE BE R2]
% for i = 1:1:length(Tags)
%    eval(['sums_stats_' Tags{i,1} ' =  NEE_sums_stats(nnet' Tags{i,1} '.(1).NEE_sim, NEE_cleaned, year_list);']);
%    eval(['abs_BE(:,i) = abs(sums_stats_' Tags{i,1} '(:,4)).*17520.*0.0216;']);
%    eval(['sums_stats_' Tags{i,1} '(:,6) =  abs_BE(:,i);']);
% end


%%% Plot Results for Run 1:
plot_types = {'sums';'RMSE';'BE';'R2'};
for k = 1:1:length(plot_types) % we want 5 figures:
    f(k,1) = start_figure([plot_types{k} '_Run1'],[plot_types{k} '_Run1']);
    for i = 1:1:length(Tags1)
        figure(f(k,1));
        eval(['h1(i) = plot(nnet' Tags1{i,1} '(1).sumstats(:,1), nnet' Tags1{i,1} '(1).sumstats(:,k+1), ''ko'',''MarkerFaceColor'', clrs(i,:),''MarkerSize'', 8); hold on;']);
        
        if k == 3 % if we're plotting BE:
            for BE_ctr = -0.3:0.05:0.3
                plot([year_start:1:year_end],[BE_ctr.*ones(year_end- year_start+1,1)],'--','Color',clrs(9,:));
                text(year_end,BE_ctr,[' ' num2str(round(BE_ctr*17520*0.0216))],'Color',clrs(9,:),'FontSize',15);
            end
        end
    end
    legend(h1, Tags1,4); grid on;
    clear h1
end

%%% Plot Results for Run 2:
plot_types = {'sums';'RMSE';'BE';'R2'};
for k = 1:1:length(plot_types) % we want 5 figures:
    f2(k,1) = start_figure([plot_types{k} '_Run2'],[plot_types{k} '_Run2']);
    for i = 1:1:length(Tags2)
        figure(f2(k,1));
        eval(['h1(i) = plot(nnet' Tags2{i,1} '(1).sumstats(:,1), nnet' Tags2{i,1} '(1).sumstats(:,k+1), ''ko'',''MarkerFaceColor'', clrs(i,:),''MarkerSize'', 8); hold on;']);
        if k == 3 % if we're plotting BE:
            for BE_ctr = -0.3:0.05:0.3
                plot([year_start:1:year_end],[BE_ctr.*ones(year_end- year_start+1,1)],'--','Color',clrs(9,:));
                text(year_end,BE_ctr,[' ' num2str(round(BE_ctr*17520*0.0216))],'Color',clrs(9,:),'FontSize',15);
            end
        end
    end
    legend(h1, Tags2,4); grid on;
    clear h1
end

%%% Plot Results for Run 3:
plot_types = {'sums';'RMSE';'BE';'R2'};
for k = 1:1:length(plot_types) % we want 5 figures:
    f3(k,1) = start_figure([plot_types{k} '_Run3'],[plot_types{k} '_Run3']);
    for i = 1:1:length(Tags3)
        figure(f3(k,1));
        eval(['h1(i) = plot(nnet' Tags3{i,1} '(1).sumstats(:,1), nnet' Tags3{i,1} '(1).sumstats(:,k+1), ''ko'',''MarkerFaceColor'', clrs(i,:),''MarkerSize'', 8); hold on;']);
        if k == 3 % if we're plotting BE:
            for BE_ctr = -0.3:0.05:0.3
                plot([year_start:1:year_end],[BE_ctr.*ones(year_end- year_start+1,1)],'--','Color',clrs(9,:));
                text(year_end,BE_ctr,[' ' num2str(round(BE_ctr*17520*0.0216))],'Color',clrs(9,:),'FontSize',15);
            end
        end
    end
    legend(h1, Tags3,4); grid on;
    clear h1
end

%%% Plot Results for Run 4:
plot_types = {'sums';'RMSE';'BE';'R2'};
for k = 1:1:length(plot_types) % we want 5 figures:
    f4(k,1) = start_figure([plot_types{k} '_Run4'],[plot_types{k} '_Run4']);
    for i = 1:1:length(Tags4)
        figure(f4(k,1));
        eval(['h1(i) = plot(nnet' Tags4{i,1} '(1).sumstats(:,1), nnet' Tags4{i,1} '(1).sumstats(:,k+1), ''ko'',''MarkerFaceColor'', clrs(i,:),''MarkerSize'', 8); hold on;']);
        if k == 3 % if we're plotting BE:
            for BE_ctr = -0.3:0.05:0.3
                plot([year_start:1:year_end],[BE_ctr.*ones(year_end- year_start+1,1)],'--','Color',clrs(9,:));
                text(year_end,BE_ctr,[' ' num2str(round(BE_ctr*17520*0.0216))],'Color',clrs(9,:),'FontSize',15);
            end
        end
    end
    legend(h1, Tags4,4); grid on;
    clear h1
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot Results for All Runs Combined:
plot_types = {'sums';'RMSE';'BE';'R2'};
for k = 1:1:length(plot_types) % we want 5 figures:
    f4(k,1) = start_figure([plot_types{k} '_all'],[plot_types{k} '_all']);
    for i = 1:1:length(Tags)
        figure(f4(k,1));
        eval(['h1(i) = plot(nnet' Tags{i,1} '(1).sumstats(:,1)-(i*0.01), nnet' Tags{i,1} '(1).sumstats(:,k+1), ''' symbs{i,1} ''', ''MarkerEdgeColor'', ''k'',''MarkerFaceColor'', clrs(i,:),''MarkerSize'', 8); hold on;']);
        if k == 3 % if we're plotting BE:
            for BE_ctr = -0.3:0.05:0.3
                plot([year_start:1:year_end],[BE_ctr.*ones(year_end- year_start+1,1)],'--','Color',clrs(9,:));
                text(year_end,BE_ctr,[' ' num2str(round(BE_ctr*17520*0.0216))],'Color',clrs(9,:),'FontSize',15);
            end
        end
    end
    legend(h1, Tags,3); grid on;
    
    clear h1
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(99);clf;
plot(NEE_sim3f,'k');
hold on;
plot(NEE_sim3b,'r');
plot(NEE_cleaned,'b.');