function [] = mcm_Gapfill_LE_H_default(site,year,pause_flag)
if nargin <= 2
    pause_flag = 0;
end

disp('Please make sure you''ve run mcm_data_compiler since last changes to the met/flux data.');

if pause_flag == 1;
disp('Hit Enter to confirm > ');
pause;
end

if nargin == 1 || isempty(year)
    year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
end
year_start = min(year);
year_end = max(year);
clear year
%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/LE_H/Default/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/Default/'];
header_path = [ls 'Matlab/Config/Flux/Gapfilling/Defaults/']; %Added 01-May-2012

jjb_check_dirs(save_path,1);
jjb_check_dirs(fig_path,1);

%% Load data files:
% sum_labels = {'Year';'LE_filled';'ET_filled';'H_filled'};
sum_labels = {'Year';'LE_filled';'ET_filled';'H_filled'; 'LE_pred'; 'ET_pred'; 'H_pred'};
% data_labels = {'LE_filled';'ET_filled';'H_filled'};

%%% Load the master gapfilling input file:
load([load_path site '_gapfill_data_in.mat']);

%%% Load the master file (if it exists).  Otherwise, make a new one:
% if exist([save_path site '_Gapfill_LE_H_default_master.mat'],'file') == 2;
%     load([save_path site '_Gapfill_LE_H_default_master.mat']);
if exist([save_path site '_Gapfill_LE_H_default.mat'],'file') == 2;
    load([save_path site '_Gapfill_LE_H_default.mat']);    
else
%%%% Get an output file ready:
master.Year = data.Year;
master.LE_filled = NaN.*ones(length(data.Year),1);
master.ET_filled = NaN.*ones(length(data.Year),1);
master.H_filled = NaN.*ones(length(data.Year),1);
master.LE_pred = NaN.*ones(length(data.Year),1);
master.ET_pred = NaN.*ones(length(data.Year),1);
master.H_pred = NaN.*ones(length(data.Year),1);
end

%%% Prepare the file of annual sums:
sums = NaN.*ones(year_end-year_start+1,4);
sums(:,1) = (year_start:1:year_end)';

%%% The first data trimming: Trim the data to the years entered to fill:
data.site = site;
data = trim_data_files(data,year_start, year_end,1);
LE_orig = data.LE;
H_orig = data.H;
%%% Load footprint file:
load([footprint_path site '_footprint_flag.mat'])
%%% Trim footprint flag file:
footprint_flag = trim_data_files(footprint_flag,year_start, year_end,0);

%% Load defaults for each site.
%%% Distill whether there are different groups of data to process by
%%% looking for differences in rows of the default file:

default_header = jjb_hdr_read([header_path 'LE_H_Gapfilling_Defaults.csv'],',');
% right_cols = find(strcmp(site,default_header(1,:))==1);
right_rows = find(strcmp(site,default_header(:,1))==1);

for k = 1:1:length(right_rows);
    clear ustar_th model fp tag data.Ustar_th fp_flag ustar_tag results;
    close all;
    ustar_th = default_header{right_rows(k,1),3};
    model = default_header{right_rows(k,1),4};
    fp =  default_header{right_rows(k,1),5};
    tag =  default_header{right_rows(k,1),6};
    
    %%% Set the footprint flag:%%%%%%%%
    if strcmp(fp,'off')==1
        fp_flag = ones(length(footprint_flag.Year),1);
    else
        fp_flag = eval(['footprint_flag.' fp '(:,2)']);
    end
    % Remove NEE data when footprint is beyond the fetch:
    data.LE = LE_orig.*fp_flag;
    data.H = H_orig.*fp_flag;
    
    %%% Set the ustar threshold:%%%%%%%
    if isempty(str2num(ustar_th))==1
        data.Ustar_th = eval([ustar_th '(data,0);']);
    else
        data.Ustar_th = str2num(ustar_th).*ones(length(data.Year),1);
    end
    %%% Make a ustar tag:
    ustar_tag = ustar_th;
    dots = strfind(ustar_tag,'.');
    ustar_tag(dots) = 'p';
    clear dots;
        
    %%%%%%%%%%% Run The Gapfilling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    id_current = [site ', ' fp ', ' ustar_tag ', ' model];
    disp(['Working on: ' id_current]);
    
    try
        [results fig_out] = feval(['mcm_Gapfill_' model], data,[],0); % e.g. mcm_Gapfill_LE_H(data,[],0);
        fig_tag = [site '_' fp '_' ustar_tag '_' num2str(year_start) '_' num2str(year_end)];
        figure(fig_out); print('-dpdf',[fig_path fig_tag '_' tag 'LE_H_results']);  close(fig_out);
        
        %%% Output results to Master: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Identification data:
        master(k).model = model;
        master(k).ustar_th = ustar_th;
        master(k).fp = fp;
        master(k).tag = tag;
        
        %%% Data:
        master(k).Year =        results.master.Year ;
        master(k).LE_filled =   results.master.LE_filled ;
        master(k).ET_filled =  results.master.ET_filled ;
        master(k).H_filled =   results.master.H_filled ;
        master(k).LE_pred =   results.master.LE_pred ;
        master(k).ET_pred =  results.master.ET_pred ;
        master(k).H_pred =   results.master.H_pred ;
        
        %%% Stats:
        try
            master(k).stats_LE = model_stats(results.master.LE_pred,data.LE,0);
            master(k).stats_H  = model_stats(results.master.H_pred,data.H,0);
        catch
            master(k).stats_LE = {};
            master(k).stats_H =  {};
            disp('no stats outputted - There was an error somewhere.');
        end
        
        %%% Sums:
        master(k).sums = results.master.sums;
        
        %%% Make a taglist for use in mcm_data_compiler %%%%%%%%%%
        master(1).taglist{k,1} = tag;
        %%%%% Print the sums to file: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1. Save the sums into a table that can be opened easily by a spreadsheet:
        fid = fopen([save_path site '_LE_H_sums_' tag '_' datestr(now,29) '.dat'],'w+');
        
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
        disp([id_current ' Successful.']);
        
    catch err1 
        disp([id_current ' Failed.']);
        disp([err1.stack(1).name ', line ' num2str(err1.stack(1).line)]);
        pause
    end
end

%%%%%%%%%%%%%%%%%%% Save the half-hourly flux output: %%%%%%%%%%%%%%%%%%%%
save([save_path site '_Gapfill_LE_H_default.mat'],'master');

disp('done!');
% bacon;
end
