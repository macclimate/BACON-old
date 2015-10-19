ls = addpath_loadstart;

load_path = [ls 'Matlab/Data/Flux/Gapfilling/TP39/'];
    

model_list = {'SiteSpec'; 'FCRN';'ANN_JJB1';'HOWLAND';'MDS_JJB1'};
fp_tags = {'FP_on';'FP_off'};
[clrs clr_guide] = jjb_get_plot_colors;

%%% Make a flag file, load and organize stats 
%%% Model Flags:
% SiteSpec = 1;
% FCRN = 2;
% ANN = 3;
% HOWLAND = 4;
% MDS = 5
%%% Footprint Flags:
% On = 1;
% Off = 2;
%%% Ustar_th Flags:
% constant = decimal (actual threshold)
% Reichstein = 0.622;
% JJB = 0.722;

% Load stats file:
load([load_path 'Gapfilling_Main_stats.mat']);
flag_file = [];
stats_list = {'BE'; 'rRMSE'; 'NRMSE'; 'AIoA'; 'NMAE'; 'Ei'; 'ESS'; 'beta'; 'R2'};
for j = 1:1:length(stats_list)
            eval([stats_list{j,1} ' = [];']);
end

%%% Load from the main stats file:
for i = 1:1:length(stats);
    if isempty(stats(i).stats)
    else
        %%% Create the Flag File:
        model_flag = find(strcmp(model_list,stats(i).model)==1);
        fp_flag = find(strcmp(fp_tags,stats(i).fp)==1);
        ust_tmp = stats(i).ustar(7:end);
        if ~isempty(str2num(ust_tmp))
            ustar_flag = str2num(ust_tmp);
        else
            if strcmp(ust_tmp,'Reich') == 1
                ustar_flag = 0.56;
            elseif strcmp(ust_tmp,'JJB') == 1
                ustar_flag = 0.66;
            end
        end
        
        flag_file = [flag_file; [model_flag fp_flag ustar_flag]];
        clear ust_tmp;
        
        %%% Now, get stats:
        for j = 1:1:length(stats_list)
            eval(['tmp = stats(i).stats.' stats_list{j,1} ';']);
            eval([stats_list{j,1} ' = [' stats_list{j,1} '; tmp];']);
            clear tmp;
        end
    end
end

clear stats;
% Load ANN stats:
load([load_path 'Gapfilling_Main_stats_ANN_JJB1.mat']);
%%% Load from the ANN stats file:
for i = 1:1:length(stats);
    if isempty(stats(i).stats)
    else
        %%% Create the Flag File:
        model_flag = find(strcmp(model_list,stats(i).model)==1);
        fp_flag = find(strcmp(fp_tags,stats(i).fp)==1);
        ust_tmp = stats(i).ustar(7:end);
        if ~isempty(str2num(ust_tmp))
            ustar_flag = str2num(ust_tmp);
        else
            if strcmp(ust_tmp,'Reich') == 1
                ustar_flag = 0.56;
            elseif strcmp(ust_tmp,'JJB') == 1
                ustar_flag = 0.66;
            end
        end
        
        flag_file = [flag_file; [model_flag fp_flag ustar_flag]];
        clear ust_tmp;
        
        %%% Now, get stats:
        for j = 1:1:length(stats_list)
            eval(['tmp = stats(i).stats.' stats_list{j,1} ';']);
            eval([stats_list{j,1} ' = [' stats_list{j,1} '; tmp];']);
            clear tmp;
        end
    end
end




f1 = figure('Name', 'Ei');
for k = 1:1:length(model_list)
    ind = find(flag_file(:,1)==k);
    if ~isempty(ind)
        h1(k) = plot3(flag_file(ind,2),flag_file(ind,3),Ei(ind),'o','MarkerFaceColor',clrs(k,:));hold on;
    else
        h1(k) = plot3(1,0.5,median(Ei),'.','Color',[1 1 1]);
    end
end
grid on;
xlabel('fp'); set(gca, 'XTick',[1 1.1 1.9 2],'XTickLabel', {'FP-on';'';''; 'FP-off'});
ylabel('ustar'); set(gca, 'YTick',[0.25:0.05:0.4 0.622 0.722],'YTickLabel', {'0.25'; '0.3';'0.35';'0.4';'Reich';'JJB'});
zlabel('Ei');
axis([1 2 0.2 0.8 min(Ei) max(Ei)])
legend(h1,model_list);

%%%
f2 = figure('Name', 'BE');
for k = 1:1:length(model_list)
    ind = find(flag_file(:,1)==k);
    if ~isempty(ind)
        h1(k) = plot3(flag_file(ind,2),flag_file(ind,3),BE(ind),'o','MarkerFaceColor',clrs(k,:));hold on;
    else
        h1(k) = plot3(1,0.5,median(BE),'.','Color',[1 1 1]);
    end
end
grid on;
xlabel('fp'); set(gca, 'XTick',[1 1.1 1.9 2],'XTickLabel', {'FP-on';'';''; 'FP-off'});
ylabel('ustar'); set(gca, 'YTick',[0.25:0.05:0.4 0.622 0.722],'YTickLabel', {'0.25'; '0.3';'0.35';'0.4';'Reich';'JJB'});
zlabel('BE');
axis([1 2 0.2 0.8 min(BE) max(BE)])
legend(h1,model_list);


%%% Analyze Sums:



