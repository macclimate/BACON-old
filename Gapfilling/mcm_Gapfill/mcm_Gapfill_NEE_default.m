function [] = mcm_Gapfill_NEE_default(site,year,pause_flag)
if nargin <= 2
    pause_flag = 0;
end
disp('Please make sure you''ve run mcm_data_compiler since last changes to the met/flux data.');
if pause_flag == 1;
disp('Hit Enter to confirm > ');
pause;
commandwindow;
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
data.site = site;
NEE_orig = data.NEE; %original data:

%%% Load the master file (if it exists).  Otherwise, make a new one:
% if exist([save_path site '_Gapfill_NEE_default_master.mat'],'file') == 2;
%     load([save_path site '_Gapfill_NEE_default_master.mat']);
% modified 01-May-2012
newfile_flag = 1; % JJB added this on 31-Jan-2016 - I think there are issues with loading the old file
if exist([save_path site '_Gapfill_NEE_default.mat'],'file') == 2 && newfile_flag == 0;
    load([save_path site '_Gapfill_NEE_default.mat']); 
    taglist = master(1).taglist;
    newfile_flag = 0;
else
    %%%% Get an output file ready:
    disp('Preparing a new master file for gapfilling.');
    master(1).Year = data.Year;
     newfile_flag = 1;
    master(1).Year = data.Year;
    master(1).NEE_clean = NaN.*ones(length(data.Year),1);
    master(1).NEE_filled = NaN.*ones(length(data.Year),1);
    master(1).NEE_pred = NaN.*ones(length(data.Year),1);
    master(1).RE_filled = NaN.*ones(length(data.Year),1);
    master(1).RE_pred = NaN.*ones(length(data.Year),1);
    master(1).GEP_filled = NaN.*ones(length(data.Year),1);
    master(1).GEP_pred = NaN.*ones(length(data.Year),1);    
    master(1).Ustar_th = NaN.*ones(length(data.Year),1);

%     master.NEE_clean = NaN.*ones(length(data.Year),1);
%     master.NEE_filled = NaN.*ones(length(data.Year),1);
%     master.NEE_pred = NaN.*ones(length(data.Year),1);
%     master.RE_filled = NaN.*ones(length(data.Year),1);
%     master.RE_pred = NaN.*ones(length(data.Year),1);
%     master.GEP_filled = NaN.*ones(length(data.Year),1);
%     master.GEP_pred = NaN.*ones(length(data.Year),1);
end

%%% Load footprint file:
fpflag_orig = load([footprint_path site '_footprint_flag.mat']);



% data = trim_data_files(data,year_start, year_end,1);


% tmp_fp_flag = footprint_flag.Schuepp70;
% % Flag file for Schuepp 70% footprint:
% fp_flag(:,1) = tmp_fp_flag(tmp_fp_flag(:,1) >= year_start & tmp_fp_flag(:,1) <= year_end,2);
% % Flag file for No footprint:
% fp_flag(:,2) = ones(length(fp_flag(:,1)),1); % The
% data.fp_flag = fp_flag;

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
    try sect_filtlow = str2num(default_header{right_rows(k,1),7}); catch; sect_filtlow = NaN;end
    try sect_filthigh = str2num(default_header{right_rows(k,1),8}); catch; sect_filthigh = NaN;end
    
    if newfile_flag ==1 && k == 1;
            taglist{1,1} = tag;
    end
    %%% Reconcile years to run with those set in default:
    year_start2 = yrs_to_run(1);
    year_end2 = yrs_to_run(end);
    
    % Trim data and footprint files:
    data_in = trim_data_files(data,year_start2, year_end2,1);
    footprint_flag_in = trim_data_files(fpflag_orig.footprint_flag,year_start2, year_end2,0);%%% Prepare the file of annual sums:

    sums = NaN.*ones(year_end2-year_start2+1,7);
    sums(:,1) = (year_start2:1:year_end2)';
    %%% Set the footprint flag:%%%%%%%%
    if strcmp(fp,'off')==1
        fp_flag = ones(length(footprint_flag_in.Year),1);
    else
        fp_flag = eval(['footprint_flag_in.' fp '(:,2)']);
 
    end
    %%% Set the sector filtering flag (can be used to exclude entire
    %%% sectors (if the fp='off'), or apply footprint only on selected
    %%% sectors (if fp ~= 'off').  Can be used for more than one
    %%% sector.
    if isnan(sect_filtlow)
        %         sect_flag = ones(length(footprint_flag_in.Year),1);
    else
        for mm = 1:1:length(sect_filtlow)
            ind = find(data.W_Dir >=sect_filtlow(mm) & data.W_Dir <= sect_filthigh(mm));
            % if fp is off, then we'll just remove sectors:
            if strcmp(fp,'off')==1
                fp_flag(ind) = NaN;
            else
                % if fp is on, then we'll apply footprint only in those sectors
                fp_flag2 = ones(length(footprint_flag_in.Year),1);
                fp_flag2(ind) = fp_flag(ind);
                fp_flag = fp_flag2;
                clear fp_flag2;
            end
        end
    end
    NEE_orig_in = data_in.NEE;
    % Remove NEE data when footprint is beyond the fetch:
    data_in.NEE = NEE_orig_in.*fp_flag;
    
    %%% Set the ustar threshold:%%%%%%%
        ustar_tag = ustar_th;
    dots = strfind(ustar_tag,'.');
    ustar_tag(dots) = 'p';
    clear dots;
    if isempty(str2num(ustar_th))==1
        [Uth f_uth] = eval([ustar_th '(data_in,1);']);
        data_in.Ustar_th = Uth(:,1);
       fig_tag = [site '_' fp '_' ustar_tag '_' num2str(year_start2) '_' num2str(year_end2)];

         print('-dpdf',[fig_path fig_tag '_uth']);   close(f_uth);
    else
        data_in.Ustar_th = str2num(ustar_th).*ones(length(data_in.Year),1);
ustar_tag = 'Const'; % Changing the tag to simply "Const" instead of the number
    end
    
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
        
     
    %%%% Identifies which subcell of master we're writing this data into:
    numcells = length(master);
       ind_rightcell = find(strcmp(tag,taglist)==1);
	% Case 1: No match is found - we're making an additional cell and populating it with blank data
        if isempty(ind_rightcell)==1
            output_cell = numcells+1;
% newcell_flag = 1;
            master(output_cell).Year = data.Year;
            master(output_cell).NEE_clean = NaN.*ones(length(data.Year),1);
            master(output_cell).NEE_filled = NaN.*ones(length(data.Year),1);
            master(output_cell).NEE_pred = NaN.*ones(length(data.Year),1);
            master(output_cell).RE_filled = NaN.*ones(length(data.Year),1);
            master(output_cell).RE_pred = NaN.*ones(length(data.Year),1);
            master(output_cell).GEP_filled = NaN.*ones(length(data.Year),1);
            master(output_cell).GEP_pred = NaN.*ones(length(data.Year),1);
master(output_cell).Ustar_th = NaN.*ones(length(data.Year),1);
taglist{length(taglist)+1,1} = tag;
        else
	% Case 2: A match is found - we'll simply note what the appropriate cell is and carry it forward
% newcell_flag = 0;
            output_cell = ind_rightcell;
        end

        %%% Output results to Master: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Identification data:
        master(output_cell).model = model;
        master(output_cell).ustar_th = ustar_th;
        master(output_cell).fp = fp;
        master(output_cell).tag = tag;
        
        %%% Data:
		ind_puttomaster = find(master(output_cell).Year >= year_start2 & master(output_cell).Year <= year_end2);
        master(output_cell).Year(ind_puttomaster,1) =        results.master.Year ;
        master(output_cell).NEE_clean(ind_puttomaster,1) =   results.master.NEE_clean ;
        master(output_cell).NEE_filled(ind_puttomaster,1) =  results.master.NEE_filled ;
        master(output_cell).NEE_pred(ind_puttomaster,1) =    results.master.NEE_pred ;
        master(output_cell).RE_filled(ind_puttomaster,1) =   results.master.RE_filled ;
        master(output_cell).GEP_filled(ind_puttomaster,1) =  results.master.GEP_filled ;
        master(output_cell).GEP_pred(ind_puttomaster,1) =    results.master.GEP_pred ;
        master(output_cell).RE_pred(ind_puttomaster,1) =     results.master.RE_pred ;
        master(output_cell).Ustar_th(ind_puttomaster,1) =    data_in.Ustar_th ;
        try
            master(output_cell).c_hat = results.master.c_hat;
        catch
        end
%%%% Remember to output master.taglist at the end of function.


%  
%          %%% Stats:
%          try
%              master(k).stats = model_stats(results.master.NEE_pred,results.master.NEE_clean,0);
%          catch
%              master(k).stats = {};
%              disp('no stats outputted - likely because NEE_pred does not exist (as in MDS).');
%          end
%          %%% Sums:
%          master(k).sums = results.master.sums;
%          master(k).sum_labels = results.master.sum_labels;
%          %%% Make a taglist for use in mcm_data_compiler %%%%%%%%%%
%          master(1).taglist{k,1} = tag;
%       
%          %%% Display sums on the screen:
%          disp(results.master.sum_labels);
%          disp(results.master.sums);
%          %%%%% Print the sums to file: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          % 1. Save the sums into a table that can be opened easily by a spreadsheet:
%          fid = fopen([save_path site '_NEE_sums_' tag '_' datestr(now,29) '.dat'],'w+');
%          %%% Print column headers:
%          for j = 1:1:length(sum_labels)
%              fprintf(fid, '%s\t',sum_labels{j,1});
%          end
%          %%% Set up the format code:
%          format_code = '\n %4.0f\t ';
%          for j = 2:1:size(sums,2)
%              format_code = [format_code '%6.1f\t '];
%          end
%          %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t
%          %%% Output the data to file:
%          for j = 1:1:size(master(k).sums,1)
%              fprintf(fid, format_code, master(k).sums(j,:));
%          end
%          fclose(fid);
%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          disp([site ', ' tag ': ' fp ', ' ustar_tag ', ' model ' Successful.']);
        disp([site ', ' tag ': ' fp ', ' ustar_tag ', ' model ' Successful.']);

    catch err1 
		
        try
        disp([id_current ' Failed.']);
        disp([err1.stack.name ', line ' num2str(err1.stack.line)]);
        catch
        disp(['Something went wrong while running ' tag '.'])
        end
    end


end

%% New Configuration - Let's output sums and stats at the very end

sum_labels = {'Year';'NEE_filled';'NEE_pred'; 'GEP_filled';'GEP_pred';'RE_filled';'RE_pred'};
master(1).taglist = taglist;
for k = 1:1:length(taglist) % Cycle through each model type

for j = min(master(1).Year):1:max(master(1).Year) % Cycle through each year:
ind_use = find(master(1).Year == j);
master(k).stats(j-min(master(1).Year)+1,1).year = j;
        %%% Stats:
        try
            master(k).stats(j-min(master(1).Year)+1,1).out = model_stats(master(k).NEE_pred(ind_use),master(k).NEE_clean(ind_use),0);
        catch
            master(k).stats(j-min(master(1).Year)+1,1).out = {};
            disp(['No stats outputted for ' taglist{k,1} ' year = ' num2str(j)]);
            disp('...Likely because NEE_pred does not exist (as in MDS).');
        end
        %%% Sums:
% master(k).sums.yearlist(j-min(master(1).Year)+1,1) = j;
master(k).sum_labels = sum_labels;
    master(k).sums(j-min(master(1).Year)+1,1) = j;
    master(k).sums(j-min(master(1).Year)+1,2) = jjb_round(sum(master(k).NEE_filled(ind_use)).*0.0216,2);
    master(k).sums(j-min(master(1).Year)+1,3) = jjb_round(sum(master(k).NEE_pred(ind_use)).*0.0216,2);
    master(k).sums(j-min(master(1).Year)+1,4) = jjb_round(sum(master(k).GEP_filled(ind_use)).*0.0216,2);
    master(k).sums(j-min(master(1).Year)+1,5) = jjb_round(sum(master(k).GEP_pred(ind_use)).*0.0216,2);
    master(k).sums(j-min(master(1).Year)+1,6) = jjb_round(sum(master(k).RE_filled(ind_use)).*0.0216,2);
    master(k).sums(j-min(master(1).Year)+1,7) = jjb_round(sum(master(k).RE_pred(ind_use)).*0.0216,2);
end

format bank 
format compact;
		%%% Display sums on the screen:
		disp(['============= ' site ' - sums for ' taglist{k,1} ' ================']);
        disp(sum_labels');
        disp(master(k).sums);

		%%%%% Print the sums to file: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1. Save the sums into a table that can be opened easily by a spreadsheet:
        fid = fopen([save_path site '_NEE_sums_' taglist{k,1} '_' datestr(now,29) '.dat'],'w+');
        %%% Print column headers:
        for i = 1:1:length(sum_labels)
            fprintf(fid, '%s\t',sum_labels{i,1});
        end
        %%% Set up the format code:
        format_code = '\n %4.0f\t ';
        for i = 2:1:size(master(k).sums,2)
            format_code = [format_code '%7.1f\t '];
        end
        %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t
        %%% Output the data to file:
        for i = 1:1:size(master(k).sums,1)
            fprintf(fid, format_code, master(k).sums(i,:));
        end
        fclose(fid);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


%          master(k).sums = results.master.sums;
%          master(k).sum_labels = results.master.sum_labels;
%          %%% Make a taglist for use in mcm_data_compiler %%%%%%%%%%
%          master(1).taglist{k,1} = tag;
%       
%          %%% Display sums on the screen:
%          disp(results.master.sum_labels);
%          disp(results.master.sums);
        


%%%%%%%%%%%%%%%%%%% Save the half-hourly flux output: %%%%%%%%%%%%%%%%%%%%
% master(1).taglist = taglist
save([save_path site '_Gapfill_NEE_default.mat'],'master');

disp('done!');
% bacon;
