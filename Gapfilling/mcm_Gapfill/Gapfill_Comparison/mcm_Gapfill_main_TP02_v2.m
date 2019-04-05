function [] = mcm_Gapfill_main_TP02_v2 %(site, year)
%%% mcm_Gapfill_main.m
%%% Run combinations of:
% 1. Footprint filtering
% 2. Ustar filtering method
% 3. Random Error Estimation
%%%%%%%%%%%%% REMOVE THIS %%%%%%%%%%%%%
% if nargin == 0 || isempty(site)
    site = 'TP02';
% end
 year = 2003:2010;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if nargin == 1 || isempty(year)
%     year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
% end
year_start = min(year);
year_end = max(year);

%% Declare Paths and Load the data:
%%% Paths:
ls = addpath_loadstart
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/'];
settings_path = [ls 'Matlab/Data/Flux/Gapfilling/'];

%%% Try to load the settings file:
try
    tmp = jjb_hdr_read([settings_path 'mcm_Gapfill_' site '_v2_settings.txt'],',');
catch
    tmp = [];
    disp('Settings file not found.  Running all models.');
end

if ~isempty(tmp)
    try
    models_to_use = eval(tmp{1,1});
    ustar_th_const = eval(tmp{2,1});
    ustar_th_const = ustar_th_const';
    clear tmp;
    catch
    models_to_use = 1:1:14;
    ustar_th_const = (0.10:0.05:0.25)';
    end
else
    models_to_use = 1:1:14;
    ustar_th_const = (0.10:0.05:0.25)';   
end

%%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
data = trim_data_files(data,year_start, year_end,1);
data.site = site; close all
% orig.data = data; % save the original data:
NEE_orig = data.NEE;

%% &&&&&&&&&&&& REMOVE THIS ONCE ALL 2010 DATA IS INCLUDED: &&&&&&&&&&&&&&

if year_start <= 2010 && year_end >= 2010
    nan_data = find(isnan(data.Ta(data.Year == 2010,1)));
    if length(nan_data) > 100
        to_fill = {'Ta';'RH';'PAR';'WS';'Ts2';'Ts5';'SM_a_filled'; 'VPD'; 'GDD'; 'recnum'};
        for k = 1:1:length(to_fill)
            eval([ 'ind = find(isnan(data.' to_fill{k,1} ') & data.Year == 2010);']);
            ind_fill = ind-yr_length(2009);
            eval(['data.' to_fill{k,1} '(ind,1) = data.' to_fill{k,1} '(ind_fill,1);']);
            clear ind ind_fill;
        end
    end
end


%% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% 1.  SiteSpec; 
% 2.  FCRN; 
% 3.  HOWLAND;
% 4.  MDS_JJB1;
% 5.  LRC_Lasslop_noVPD; 
% 6.  LRC_Lasslop_noVPDall; 
% 7.  LRC_Lasslop_VPD; 
% 8.  LRC_JJB1_noVPD; 
% 9.  LRC_JJB1_noVPDall; 
% 10. LRC_JJB1_VPD;
% 11. LRC_NR_noVPD_const; 
% 12. LRC_NR_noVPD_unconst; 
% 13. LRC_NR_VPD_const; 
% 14. LRC_NR_VPD_unconst;


%%%%%%%%%%%%%% Tags: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp_tags = {'FP_on';'FP_off'};
% model_tags = {'SiteSpec'; 'FCRN';'ANN_JJB1';'HOWLAND';'LRC_JJB1';...
%     'LRC_Lasslop';'LRC_NR';'MDS_JJB1';'MDS_Reichstein'};
% model_tags = {'SiteSpec'; 'FCRN';'ANN_JJB1';'HOWLAND';'MDS_JJB1'};
model_tags = {'SiteSpec'; 'FCRN';'HOWLAND';'MDS_JJB1'; ...
    'LRC_Lasslop_noVPD'; 'LRC_Lasslop_noVPDall'; 'LRC_Lasslop_VPD';...
    'LRC_JJB1_noVPD'; 'LRC_JJB1_noVPDall'; 'LRC_JJB1_VPD';
    'LRC_NR_noVPD_const'; 'LRC_NR_noVPD_unconst'; 'LRC_NR_VPD_const'; 'LRC_NR_VPD_unconst'};

for k = 1:1:length(models_to_use)
   model_tags2{k,1} = model_tags{models_to_use(k)};
end
clear model_tags;
model_tags = model_tags2;
clear model_tags2;

sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Other Settings:
% switch site
%     case 'TP39'
%         %    ustar_th_const = (0.2:0.05:0.45)';
%         ustar_th_const = (0.25:0.05:0.40)'; %0.35% Just for testing purposes
%     case 'TP74'
%         %    ustar_th_const = (0.15:0.05:0.40)';
%         ustar_th_const = (0.15:0.05:0.30)'; % Just for testing purposes
%     case 'TP02'
%         %    ustar_th_const = (0.1:0.05:0.35)';
%         ustar_th_const = (0.10:0.05:0.25)'; % Just for testing purposes
%     case 'TP89'
%         ustar_th_const = (0.25:0.05:0.40)'; % Just for testing purposes
%         
% end

%% Load Footprint file:
load([footprint_path site '_footprint_flag.mat'])
tmp_fp_flag = footprint_flag.Schuepp70;
% Flag file for Schuepp 70% footprint:
fp_flag(:,1) = tmp_fp_flag(tmp_fp_flag(:,1) >= data.year_start & tmp_fp_flag(:,1) <= data.year_end,2);
% Flag file for No footprint:
fp_flag(:,2) = ones(length(fp_flag(:,1)),1); % The


%% Open up a log file to track success/failure of gapfilling:
fid_log = fopen([save_path 'Gapfilling_Log_' datestr(now, 29) '.txt'],'w+');
%% %%%%%%%%%%%%%%%%%%%%%% MAIN LOOP:
%%% Cycle through footprints:
%%% If fp_ctr = 1, apply footprint
%%% If fp_ctr = 2, no footprint
stats = struct;
stats_ctr = 1;
for fp_ctr = 1:1:length(fp_tags) %%%%%%%%%%%%% CHANGE THIS BACK!!!!! %%%%%
    data.NEE = NEE_orig.*fp_flag(:,fp_ctr); % Remove bad data:
    %%% Cycle through Ustar thesholds:
    for uth_ctr = 1:1:length(ustar_th_const)+2
        clear data.Ustar_th;
        if uth_ctr == length(ustar_th_const)+1
            data.Ustar_th = mcm_Ustar_th_Reich(data,0);
            ustar_tag = 'ustar_Reich';
        elseif uth_ctr == length(ustar_th_const)+2
            data.Ustar_th = mcm_Ustar_th_JJB(data,0);
            ustar_tag = 'ustar_JJB';
        else
            data.Ustar_th = ustar_th_const(uth_ctr,1).*ones(length(data.Year),1);
            ustar_tag = ['ustar_' num2str(ustar_th_const(uth_ctr,1))];
            dots = strfind(ustar_tag,'.');
            ustar_tag(dots) = 'p';
            clear dots;
        end
        %         disp(['Working on: ' fp_tags{fp_ctr,1} ', ' ustar_tag]);
        %%% Estimate random error:
        fig_tag = [fp_tags{fp_ctr,1} '_' ustar_tag];
        [data.NEE_std f_fit f_std] = NEE_random_error_estimator_v6(data,[],[],0);
        figure(f_fit); view([28.5 18])
        print('-dpdf',[fig_path fig_tag '_std_fit']);   close(f_fit);
        figure(f_std); print('-dpdf',[fig_path fig_tag '_std_pred']);  close(f_std);
        
        %%% Cycle through each gap-filling method.  Save results and
        %%% figures:
        for model_ctr = 1:1:length(model_tags)
            tic;
            id_current = ['Working on: ' site ', ' fp_tags{fp_ctr,1} ', ' ustar_tag ', ' model_tags{model_ctr,1}];
            disp(id_current);
            fprintf(fid_log, '%s\n', id_current);
            save_tag = [model_tags{model_ctr,1} '-' fp_tags{fp_ctr,1} '-' ustar_tag];
            % Evaluate the gapfilling function:
            try
                [results fig_out] = feval(['mcm_Gapfill_' model_tags{model_ctr,1}], data,[],0); % e.g. mcm_Gapfill_SiteSpec(data,[],0);
                fprintf(fid_log,'%s\n', 'Successful.')
                % Save output figure:
                
                
                for i = 1:1:length(fig_out)
                    print('-dpdf',[fig_path save_tag '_fig' num2str(i)])
                end
                close(fig_out);
                %%% Save the data:
                % 1. Save half-hourly flux output:
                results(1).toc = toc;
                save([save_path 'NEE_GEP_RE/' save_tag '_results.mat'],'results');
                % 2. Export a table of annual sums:
                for j = 1:1:length(results)
                    fid = fopen([save_path 'NEE_GEP_RE/' results(j).tag '-' fp_tags{fp_ctr,1} '-' ustar_tag '_sums.mat'],'w+');
                    format_code1 = '%s\t %s\n';
                    
                    stats(stats_ctr).site  = site;
                    stats(stats_ctr).model = results(j).tag;
                    stats(stats_ctr).fp = fp_tags{fp_ctr,1};
                    stats(stats_ctr).ustar = ustar_tag;
                    %%% Added 14-Dec-2010: Some methods (i.e. the MDS
                    %%% methods), do produce NEE_pred, so we can't really
                    %%% do stats on them.
                    try
                    stats(stats_ctr).stats = model_stats(results(j).master.NEE_pred,results(j).master.NEE_clean,0);
                    catch junk1
                        disp('no stats outputted - likely because NEE_pred does not exist.');
                    stats(stats_ctr).stats = struct;
                    end                    
                    
                    %%% Print Identifiers
                    fprintf(fid, format_code1, 'site',  site);
                    fprintf(fid, format_code1, 'model', results(j).tag);
                    fprintf(fid, format_code1, 'FP',    fp_tags{fp_ctr,1});
                    fprintf(fid, format_code1, 'u*_th', ustar_tag);
                    %%% Print column headers:
                    for k = 1:1:length(sum_labels)
                        fprintf(fid, '%10s\t',sum_labels{k,1});
                    end
                    format_code2 = '\n %4.0f\t ';
                    for k = 2:1:size(results(j).master.sums,1)
                        format_code2 = [format_code2 '%6.1f\t '];
                    end
                    %%% Output the sums to file:
                    for k = 1:1:size(results(j).master.sums,1)
                        fprintf(fid, format_code2, results(j).master.sums(k,:));
                    end
                    fclose(fid);
                end
               clear results;

            catch model_err
                %%% Write error information to the log file:
                if exist(model_err.identifier)==1 && exist(model_err.message)==1
                fprintf(fid_log, '%s\n', [model_err.identifier '--> ' model_err.mesage]);
                stack = struct2cell(model_err.stack);
                out_stack = '';
                for i = 1:1:size(stack,2)
                    out_stack = [out_stack 'function ' stack{2,i} ', line ' stack{3,i} '; '];
                end
                fprint(fid_log, '%s\n', out_stack);
                                clear out_stack model_err;
                else
                   fprintf(fid_log,  '%s\n', 'Unknown error');
                end

                
            end
            stats_ctr = stats_ctr + 1;
        end
        
    end
    %%%%%%%%% Try to run the LE, H Gapfilling:
    try
        save_tag_LE = ['mcm_Gapfill_LE_H' '-' fp_tags{fp_ctr,1} '-' ustar_tag];
        id_LE = ['Working on: ' site ', ' fp_tags{fp_ctr,1} ', ' ustar_tag ', mcm_Gapfill_LE_H'];
        disp(id_LE);
        fprintf(fid_log, '%s\n', id_LE);
        results2 = mcm_Gapfill_LE_H(data,0,0);
        save([save_path 'LE_H/' save_tag_LE '_results.mat'],'results2');
        fprintf(fid_log,'%s\n', 'Successful.')
        
        clear results2;
    catch model_err2
        %%% Write error information to the log file:
                if exist(model_err.identifier)==1 && exist(model_err.message)==1

        fprintf(fid_log, '%s\n', [model_err2.identifier '--> ' model_err2.mesage]);

        stack = struct2cell(model_err2.stack);
        out_stack = '';
        for i = 1:1:size(stack,2)
            out_stack = [out_stack 'function ' stack{2,i} ', line ' stack{3,i} '; '];
        end
        fprint(fid_log, '%s\n', out_stack);
        clear out_stack model_err2;
                else
                   fprintf(fid_log,  '%s\n', 'Unknown error');
                end
    end
end
fclose(fid_log);
%%% save stats file:
save([save_path 'Gapfilling_Main_stats.mat'],'stats');
%%% 1. Fill for LE, H
disp('All done!');
