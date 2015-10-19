function [] = mcm_Gapfill_NEE_default_old(site,year,pause_flag)
if nargin <= 2
    pause_flag = 0;
end
disp('Please make sure you''ve run mcm_data_compiler since last changes to the met/flux data.');
if pause_flag == 1;
disp('Hit Enter to confirm > ');
pause;
end

% if nargin == 1 || isempty(year)
%     year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
% end
% year_start = min(year);
% year_end = max(year);
% clear year
%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/NEE_GEP_RE/Default/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/Default/'];
header_path = [ls 'Matlab/Config/Flux/Gapfilling/Defaults/']; %Added 01-May-2012
jjb_check_dirs(save_path,1);
jjb_check_dirs(fig_path,1);

%% Load data files:
sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};
% data_labels = {'NEE_clean';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};

%%% Load the master gapfilling input file:
load([load_path site '_gapfill_data_in.mat']);

%%% Load the master file (if it exists).  Otherwise, make a new one:
% if exist([save_path site '_Gapfill_NEE_default_master.mat'],'file') == 2;
%     load([save_path site '_Gapfill_NEE_default_master.mat']);
% modified 01-May-2012
if exist([save_path site '_Gapfill_NEE_default.mat'],'file') == 2;
    load([save_path site '_Gapfill_NEE_default.mat']);    
else
    %%%% Get an output file ready:
    master.Year = data.Year;
    master.NEE_clean = NaN.*ones(length(data.Year),1);
    master.NEE_filled = NaN.*ones(length(data.Year),1);
    master.NEE_pred = NaN.*ones(length(data.Year),1);
    master.RE_filled = NaN.*ones(length(data.Year),1);
    master.RE_pred = NaN.*ones(length(data.Year),1);
    master.GEP_filled = NaN.*ones(length(data.Year),1);
    master.GEP_pred = NaN.*ones(length(data.Year),1);
end



%%% The first data trimming: Trim the data to the years entered to fill:
data.site = site;
data = trim_data_files(data,year_start, year_end,1);
NEE_orig = data.NEE; %original data:

%%% Load footprint file:
load([footprint_path site '_footprint_flag.mat'])
% tmp_fp_flag = footprint_flag.Schuepp70;
% % Flag file for Schuepp 70% footprint:
% fp_flag(:,1) = tmp_fp_flag(tmp_fp_flag(:,1) >= year_start & tmp_fp_flag(:,1) <= year_end,2);
% % Flag file for No footprint:
% fp_flag(:,2) = ones(length(fp_flag(:,1)),1); % The
% data.fp_flag = fp_flag;
%%% Trim footprint flag file:
footprint_flag = trim_data_files(footprint_flag,year_start, year_end,0);

%% Load defaults for each site.
%%% Distill whether there are different groups of data to process by
%%% looking for differences in rows of the default file:

default_header = jjb_hdr_read([header_path 'NEE_Gapfilling_Defaults.csv'],',');
% right_cols = find(strcmp(site,default_header(1,:))==1);
right_rows = find(strcmp(site,default_header(:,1))==1);
% right_rows = 7; % TAKE THIS BACK OUT!
for k = 1:1:length(right_rows);
    clear ustar_th model fp tag data.Ustar_th fp_flag ustar_tag results;
    close all;
    yrs_to_run = eval(default_header{right_rows(k,1),2})';
    ustar_th = default_header{right_rows(k,1),3};
    model = default_header{right_rows(k,1),4};
    fp =  default_header{right_rows(k,1),5};
    tag =  default_header{right_rows(k,1),6};
    
    %%% Reconcile years to run with those set in default:
    year_start2 = max(year_start, yrs_to_run(1));
    year_end2 = min(year_end, yrs_to_run(end));
    
%     if year_start2 > year_end2
%         disp(['Not running ' site ', ' tag ': ' fp ', ' ustar_tag ', ' model]);
%         disp('-- not suitable for specified time period.');
%     else
    % Trim data and footprint files:
    data_in = trim_data_files(data,year_start2, year_end2,1);
    footprint_flag_in = trim_data_files(footprint_flag,year_start2, year_end2,0);%%% Prepare the file of annual sums:
sums = NaN.*ones(year_end2-year_start2+1,7);
sums(:,1) = (year_start2:1:year_end2)';
    %%% Set the footprint flag:%%%%%%%%
    if strcmp(fp,'off')==1
        fp_flag = ones(length(footprint_flag_in.Year),1);
    else
        fp_flag = eval(['footprint_flag_in.' fp '(:,2)']);
    end
    NEE_orig_in = data_in.NEE;
    % Remove NEE data when footprint is beyond the fetch:
    data_in.NEE = NEE_orig_in.*fp_flag;
    
    %%% Set the ustar threshold:%%%%%%%
    if isempty(str2num(ustar_th))==1
        data_in.Ustar_th = eval([ustar_th '(data_in,1);']);
    else
        data_in.Ustar_th = str2num(ustar_th).*ones(length(data_in.Year),1);
    end
    %%% Make a ustar tag:
    ustar_tag = ustar_th;
    dots = strfind(ustar_tag,'.');
    ustar_tag(dots) = 'p';
    clear dots;
    
    %%%%%%% Estimate random error: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig_tag = [site '_' fp '_' ustar_tag '_' num2str(year_start2) '_' num2str(year_end2)];
    [data_in.NEE_std f_fit f_std] = NEE_random_error_estimator_v6(data_in,[],[],0);
    % Print the 2-D fit figure:
    figure(f_fit); view([28.5 18])
    print('-dpdf',[fig_path fig_tag '_std_fit']);   close(f_fit);
    % Print the timeseries of Std Dev figure:
    figure(f_std); print('-dpdf',[fig_path fig_tag '_std_pred']);  close(f_std);
    
    %%%%%%%%%%% Run The Gapfilling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    id_current = ['Working on: ' site ', ' tag ': ' fp ', ' ustar_tag ', ' model];
    disp(id_current);
    
    try
        [results fig_out] = feval(['mcm_Gapfill_' model], data_in,[],0); % e.g. mcm_Gapfill_SiteSpec(data,[],0);
    figure(fig_out); print('-dpdf',[fig_path fig_tag '_' tag '_results']);  close(fig_out);
        
        
        %%% Output results to Master: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Identification data:
        master(k).model = model;
        master(k).ustar_th = ustar_th;
        master(k).fp = fp;
        master(k).tag = tag;
        
        %%% Data:
        master(k).Year =        results.master.Year ;
        master(k).NEE_clean =   results.master.NEE_clean ;
        master(k).NEE_filled =  results.master.NEE_filled ;
        master(k).NEE_pred =    results.master.NEE_pred ;
        master(k).RE_filled =   results.master.RE_filled ;
        master(k).GEP_filled =  results.master.GEP_filled ;
        master(k).GEP_pred =    results.master.GEP_pred ;
        master(k).RE_pred =     results.master.RE_pred ;
        
        %%% Stats:
        try
            master(k).stats = model_stats(results.master.NEE_pred,results.master.NEE_clean,0);
        catch
            master(k).stats = {};
            disp('no stats outputted - likely because NEE_pred does not exist (as in MDS).');
        end
        
        %%% Sums:
        master(k).sums = results.master.sums;
        
        %%% Make a taglist for use in mcm_data_compiler %%%%%%%%%%
        master(1).taglist{k,1} = tag;
        %%%%% Print the sums to file: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1. Save the sums into a table that can be opened easily by a spreadsheet:
        fid = fopen([save_path site '_NEE_sums_' tag '_' datestr(now,29) '.dat'],'w+');
        
        %%% Print column headers:
        for j = 1:1:length(sum_labels)
            fprintf(fid, '%s\t',sum_labels{j,1});
        end
        %%% Set up the format code:
        format_code = '\n %4.0f\t ';
        for j = 2:1:size(sums,1)
            format_code = [format_code '%6.1f\t '];
        end
        %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t
        %%% Output the data to file:
        for j = 1:1:size(master(k).sums,1)
            fprintf(fid, format_code, master(k).sums(j,:));
        end
        fclose(fid);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp([site ', ' tag ': ' fp ', ' ustar_tag ', ' model ' Successful.']);
        
    catch err1 
        try
        disp([id_current ' Failed.']);
        disp([err1.stack.name ', line ' num2str(err1.stack.line)]);
        catch
        disp(['Something went wrong while running ' tag '.'])
        end
    end
%     end
end

%%%%%%%%%%%%%%%%%%% Save the half-hourly flux output: %%%%%%%%%%%%%%%%%%%%
save([save_path site '_Gapfill_NEE_default.mat'],'master');

disp('done!');
