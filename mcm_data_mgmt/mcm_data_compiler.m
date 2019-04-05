function [] = mcm_data_compiler(year, site, data_type,quickflag)

%%% mcm_data_compiler.m
% The purpose of this function is to compile data from different sources:
% - met data from the site
% - precipitation data (from FH or wherever available)
% - flux data (both CPEC and OPEC if available)
%
% Should have output be:
% a) structure file separated by year and then by variable
% b) single structure with all variables
% c) an output file for CCP submission (can link to GUI)
%
% What we'll need:
% 1. Filled Met - Ta, PAR, WS, WDir, RH, APR, Ts* (*if possible)
% 2. Final_Cleaned Met - All other important variables (for gap-filling),
% and all variables (for CCP output)
% 3. Cleaned and Filled fluxes
%
%%% Inputs:
% year - can be single year, list of years (e.g. 2005:2008), or blank (prompts for years)
% site - site label ('TP39', TPD, etc.)
% data_type - options are: 
%%% - 'all' (compiles met and flux), or
%%% - 'sapflow' (compiles sapflow data
% quickflag:
%%% quickflag = 1 -- first compile operation (met + flux)
%%% quickflag = -1 -- first compile, no prompts
%%% quickflag = 2 -- full compile (met + flux + gapfilled)
%%% quickflag = -2 -- full compile, no prompts
%%% quickflag = -9 -- full compile, no prompts, FROM SCRATCH (master files recreated)
%%%
% First Created December 2009 by JJB
%
%

%%% Revision History
%%% July, 2010 - Added 'quickflag' option, that lets us skip the filled flux
% data, for times when we are running the compiler to only compile cleaned
% fluxes and met data (e.g. before running footprint)
%%% 8-Dec-2010 - Removing the compiling of FCRN and SiteSpec gapfilled data
%%% into the master file.  Instead, the user will select (either inside or
%%% outside the program), which gapfilling method results they want to be
%%% used as the 'gapfilled' quantities.
%
%
clc;
if nargin ==3
    quickflag = 2;
elseif nargin == 2
    quickflag = 2;
data_type = '';
elseif nargin == 1
    site = year;
    year = [];
end



if nargin <=4 && isempty(year)
    year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
end

%%% If data_type is 'sapflow', we'll change the site to be <site>_sapflow:
if strcmp(data_type,'sapflow')==1
    site = [site '_sapflow'];
end

% Makes sure that year is a string:
if ischar(year)
    disp('please put year into program as an integer (e.g. 2008) or set of integers (e.g. 2008:2009).')
    year = input('Enter year: > ');
end
sitename_converter = ...
    {'TP39' 'ON-WPP39'; ...
    'TP74' 'ON-WPP74'; ...
    'TP89' 'ON-WPP89'; ...
    'TP02' 'ON-WPP02'; ...
    'TP_PPT' 'ON-WPP_PPT'; ...
    'TPD' 'ON-TPD'; ...
    'MCM_WX' 'MCM_WX'; ...    
    };

if strcmp(data_type,'sapflow')==1
    CCP_site = '';
else
CCP_site = sitename_converter{find(strcmp(site,sitename_converter(:,1))==1),2};
end
%% &&&&&&&&&&&&&&& Declare Paths: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% %%%% Input Paths:
ls = addpath_loadstart;
met_final_cleaned_path =    [ls 'Matlab/Data/Met/Final_Cleaned/' site '/'];
met_final_filled_path =     [ls 'Matlab/Data/Met/Final_Filled/' site '/'];
met_calc_path =             [ls 'Matlab/Data/Met/Calculated4/' site '/'];
%
% ppt_final_cleaned_path =    [ls 'Matlab/Data/Met/Cleaned3/TP_PPT/'];
ppt_final_filled_path =     [ls 'Matlab/Data/Met/Final_Filled/TP_PPT/'];
tpd_ppt_final_cleaned_path = [ls 'Matlab/Data/Met/Final_Cleaned/TPD_PPT/'];
%
cpec_final_cleaned_path =   [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/'];
cpec_final_calc_path =[ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
cpec_gapfilling_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/'];
%
% opec_final_cleaned_path =    [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Cleaned/'];
opec_final_calc_path = [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Calculated/'];

%%%% Footprint File Path:
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%% Output Paths:
master_out_path =           [ls 'Matlab/Data/Master_Files/'];

if strcmp(ls,'\\130.113.210.243\fielddata\')==1
    gdrive_path = '\\130.113.210.243\arainlab\Google Drive/TPFS Data/Master_Files/';
else
gdrive_path = '/home/arainlab/Google Drive/TPFS Data/Master_Files/';
end

%%%% Master Header Path:
master_header_path = [ls 'Matlab/Config/Master_Files/']; % Added 01-May-2012
%%%% Log Path:
log_path = [ls 'Documentation/Logs/mcm_data_compiler/']; % Added 01-May-2012
jjb_check_dirs(log_path,0);
jjb_check_dirs([master_out_path site '/'],1);

if ~isempty(CCP_site)
CCP_out_path = [ls 'Matlab/Data/CCP/CCP_output/' CCP_site '/'];
jjb_check_dirs(CCP_out_path,1);
end
%% OPEN UP LOG FILE:
diary([log_path site '_Log_' datestr(now,30) '.txt']);
%% &&&&&&&&&&&&&&& Load data and Headers: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%%% Load All-years Master File:
if exist([master_out_path  site '/' site '_data_master.mat'], 'file')== 2;
    if quickflag == -1 || quickflag == -2
        load_flag=0;
    elseif quickflag == -9
        load_flag = 1;
    else
    commandwindow;
    disp('Found master all-years file. Hit:');
    disp('<enter> to load and continue, or');
    disp('<1> to DELETE master file and start from scratch.');
    load_flag = input('> ');
    end
    
    
    if load_flag == 1
        unix(['rm ' master_out_path  site '/' site '_data_master.mat']);
        disp('Master File Deleted, starting from Scratch');
        master.data = [];
        master.labels = [];
    else
        load([master_out_path  site '/' site '_data_master.mat']);
        disp('Master File Loaded Successfully. Updating...');
    end
else
%     %%% Check to see if the folder for this item exists.  If not, create
%     %%% one:
% %     if exist([master_out_path site],'dir')~=7
% %         mkdir([master_out_path site]);
% %         disp(['Folder ' site ' not found in ' master_out_path '. Creating.'])
% %     end
    
    disp('Could not find master all-years file. Creating one.');
    master.data = [];
    master.labels = [];
    
end

%%% Load Header for the site:
header = jjb_hdr_read([master_header_path site '_master_list.csv'],',');
[r_header c_header] = size(header);
% Add more rows of NaNs if header has more variables than master is aware
% of:
yr_end = 2020;
yr_start = 2002;  

switch site
    case 'MCM_WX'
        time_int = 15;
        yr_start = 2008;         
    case 'TPD'
       time_int = 30;
        yr_start = 2011;    
    case 'TP_PPT'
       time_int = 30;
        yr_start = 2008;  
    case 'TP89'
        time_int = 30;
        yr_end = 2008; 
    case 'TP39_sapflow'
        time_int = 30;
        yr_start = 2009;
    case 'TP74_sapflow'
        time_int = 30;
        yr_start = 2011;
    otherwise
        time_int = 30;
%         yr_start = 2002;
end


[r c] = size(master.data);
if c == 0
    %%% Make a 30-minute master file:
    dt = []; Year = []; Month = []; Day = []; Hour = []; Minute = [];
    for i = yr_start:1:yr_end
        %         TV = [TV; make_tv(i,30)];
        Year = [Year; i.*ones(yr_length(i,time_int),1)];
        [Mon_tmp Day_tmp] = make_Mon_Day(i,time_int);
        Month = [Month; Mon_tmp]; Day = [Day; Day_tmp];
        [HH_tmp MM_tmp] = make_HH_MM(i,time_int);
        Hour = [Hour; HH_tmp]; Minute = [Minute; MM_tmp];
        [junk1_tmp, junk2_tmp, junk3_tmp, dt_tmp] = jjb_makedate(i, time_int);
        dt = [dt; dt_tmp];
        clear *_tmp
    end
    master.data = NaN.*ones(length(Year),r_header);
    master.data(:,1:6) = [Year Month Day Hour Minute dt];
    clear dt Year Month Day Hour Minute;
    %%% Save the master file to speed up re-running time when debugging
    master.labels = header; % Overwrite the labels with the header:
    %     save([master_out_path '/' site '/' site '_data_master.mat'], 'master');
    jjb_check_dirs([master_out_path site]);
    save([master_out_path site '/' site '_data_master.mat'], 'master');
    
    disp('Saved Master File.');
elseif c>0 && length(header)>c
    master.data = [master.data NaN.*ones(r,length(header)-c)];
end
%%%%%%%%%%%%%%%%% Load gap-filled data (if quickflag ==2) %%%%%%%%%%%%%%%%%
if abs(quickflag) ==1
    cpec_gf_NEE = [];
    cpec_gf_LE_H = [];
else
    %%% Locate the proper filled flux files:
    try
        cpec_gf_NEE = load([cpec_gapfilling_path 'NEE_GEP_RE/Default/' site '_Gapfill_NEE_default.mat']);
    catch
        cpec_gf_NEE = [];
    end
    
    try
        cpec_gf_LE_H = load([cpec_gapfilling_path 'LE_H/Default/' site '_Gapfill_LE_H_default.mat']);
    catch
        cpec_gf_LE_H = [];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Footprint Data outside of loop:
try
    load([footprint_path site '_footprint_flag.mat']);
catch
    footprint_flag = [];
end

%% %%%%%%%%%%%%%%%%%%%%% MAIN LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load data year by year and place into appropriate spot in master file

% data_type = char(header{:,4});
for k = 1:1:length(year)
    %year(k)
    disp('=============================================='); %line break
    disp([site '. Working on year: ' num2str(year(k)) '.']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load met data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 1. Data from /Final_Cleaned/
    %     if year(k) > 2007 || (year(k) > 2006 && strcmp(site, 'TP39')==1)
    %     if proceed.met_cleaned >0
    disp('---- Final Cleaned Met ----');
    %%% Find all cases where 'met' is in 4th column of header, and 'Final_Cleaned'
    %%% is in 5th column
    met_cols_final_cleaned = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
    %%% Load the master file:
    if ~isempty(met_cols_final_cleaned)
        try
            met_cleaned = load([met_final_cleaned_path site '_met_cleaned_' num2str(year(k)) '.mat']);
            if ~iscell(met_cleaned.master.labels)
                met_cleaned_labels = cellstr(met_cleaned.master.labels);
            else
                met_cleaned_labels = met_cleaned.master.labels;
            end
        catch
            disp('***Could not load met cleaned data')
        end
        %%% Look for the variable names listed in the 3rd column, and put
        %%% them into the appropriate spot in the master file:
        for i = 1:1:length(met_cols_final_cleaned)
            var_to_find = char(header(met_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            
            try
                %             right_col = min(find(strncmp(met_cleaned_labels(:,1),var_to_find,length(var_to_find))==1));
                right_col = find(strcmp(var_to_find,met_cleaned_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 190, or adjusting filenames');
                end
                
                master.data(master.data(:,1)==year(k), met_cols_final_cleaned(i)) = met_cleaned.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(met_cols_final_cleaned(i))) '.']);
                
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Cleaned/ file. Master Name = ' char(header(met_cols_final_cleaned(i)))])
                %     fill_data = NaN.*ones(
            end
        end
    else
        disp('None to process from here.');
    end
    clear met_cleaned met_cols_final_cleaned right_col met_cleaned_labels;
    
    %     end
    %% 2. Data from /Calculated4/:
    %     if year(k) > 2007
    %     if proceed.met_calc >0
    
    %%% Find all cases where 'met' is in 4th column of header, and 'Calculated4'
    %%% is in 5th column
    disp('---- Final Calculated Met ----');
    
    met_cols_calc4 = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Calculated4',length('Calculated4'))==1);
    %%% At this point, there is no master file to load, just individual files
    %%% (SHF only), so we'll just go through and load the singular files.  At a
    %%% later point there may have to be a master loaded, but that will have to
    %%% be added in at that point.
    %%% Modified July, 2010 by JJB - now load a master file for each
    %%% site/year
    if ~isempty(met_cols_calc4)
        try
            if strcmp(data_type,'sapflow')==1;
            soil_calc = load([met_calc_path site '_calculated_' num2str(year(k)) '.mat']);
            else
            soil_calc = load([met_calc_path site '_SHF_master_' num2str(year(k)) '.mat']);
            end
            if ~iscell(soil_calc.master.labels)
                soil_labels = cellstr(soil_calc.master.labels);
            else
                soil_labels = soil_calc.master.labels;
            end
            
        catch
            disp('***Could not load calculated soil data (SHF)')
        end
        
        %%% Look for the variable names listed in the 3rd column, and put
        %%% them into the appropriate spot in the master file:
        for i = 1:1:length(met_cols_calc4)
            var_to_find = char(header(met_cols_calc4(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            %         try
            %             right_col = min(find(strncmp(soil_labels(:,1),var_to_find,length(var_to_find))==1));
            %                 if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
            %                 disp('Try changing strncmp to strcmp on line ~ 234, or adjusting filenames'); end
            try
                right_col = find(strcmp(var_to_find,soil_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 249, or adjusting filenames');
                end
                master.data(master.data(:,1)==year(k), met_cols_calc4(i)) = soil_calc.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(met_cols_calc4(i))) '.']);
                
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Calculated4/ file. Master Name = ' char(header(met_cols_calc4(i)))])
            end
        end
    else
        disp('None to process from here.');
    end
    clear met_cols_calc4 soil_calc soil_labels;
    
    %% 3. Data from /Final_Filled:
    %%% Find all cases where 'met' is in 4th column of header, and 'Calculated4'
    %%% is in 5th column
    disp('---- Final Filled Met ----');
    
    met_cols_final_filled = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Final_Filled',length('Final_Filled'))==1);
    if ~isempty(met_cols_final_filled)
        try
            met_filled= load([met_final_filled_path site '_met_filled_' num2str(year(k)) '.mat']);
            if ~iscell(met_filled.master.labels)
                met_filled_labels = cellstr(met_filled.master.labels);
            else
                met_filled_labels = met_filled.master.labels;
            end
        catch
            disp('***Could not load met filled data')
        end
        
        for i = 1:1:length(met_cols_final_filled)
            var_to_find = char(header(met_cols_final_filled(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            %             right_col = find(strncmp(met_filled_labels(:,1),var_to_find,length(var_to_find))==1);
            %                             if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
            %                 disp('Try changing strncmp to strcmp on line ~ 266, or adjusting filenames'); end
            try
                right_col = find(strcmp(var_to_find,met_filled_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 286, or adjusting filenames');
                end
                master.data(master.data(:,1)==year(k), met_cols_final_filled(i)) = met_filled.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(met_cols_final_filled(i))) '.']);
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Filled/ file. Master Name = ' char(header(met_cols_final_filled(i)))])
                %     fill_data = NaN.*ones(
            end
        end
    else
        disp('None to process from here.');
    end
    clear met_cols_final_filled met_filled_labels var_to_find right_col
    %     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% TP39-specific data: Trenched and OTT Data %%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(site,'TP39')==1
        disp('---- Trenched & OTT ----');
        
        %%%% PART 1: OTT Data:
        %%% Try to upload Water Table Height from /Calulated4/TP39_OTT:
        try
            WT_Depth = load([ls 'Matlab/Data/Met/Calculated4/TP39_OTT/TP39_OTT_' num2str(year(k)) '.WT_Depth']);
            right_col = find(strncmp(header(:,3),'WT_Depth', length('WT_Depth'))==1 & ...
                strncmp(header(:,4),'ott', length('ott'))==1 & strncmp(header(:,5),'Final_Calculated', length('Final_Calculated'))==1);
            if numel(right_col)>1; disp('Multiple destination columns for WT_Depth.');
                disp('Try changing strncmp to strcmp on line ~ 286, or adjusting filenames'); end
            master.data(master.data(:,1)==year(k), right_col) = WT_Depth;
            clear WT_Depth right_col;
            disp('OTT Water Table Depth Updated.');
        catch
            disp('***OTT WT_Depth not updated');
        end
        %%% Upload the rest of the variables from OTT:
        ott_cols_final_cleaned = find(strncmp(header(:,4),'ott',length('ott'))==1 & ...
            strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
        
        try
            ott_cleaned = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39_OTT/TP39_OTT_met_cleaned_' num2str(year(k)) '.mat']);
            if ~iscell(ott_cleaned.master.labels)
                ott_cleaned_labels = cellstr(ott_cleaned.master.labels);
            else
                ott_cleaned_labels = ott_cleaned.master.labels;
            end
        catch
            disp('***Could not load TP39_OTT Final_Cleaned data.')
        end
        
        for i = 1:1:length(ott_cols_final_cleaned)
            var_to_find = char(header(ott_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            try
                %             right_col = find(strncmp(ott_cleaned_labels(:,1),var_to_find,length(var_to_find))==1);
                %                             if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
                %                 disp('Try changing strncmp to strcmp on line ~ 315, or adjusting filenames'); end
                right_col = find(strcmp(var_to_find,ott_cleaned_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 341, or adjusting filenames');
                end
                master.data(master.data(:,1)==year(k), ott_cols_final_cleaned(i)) = ott_cleaned.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(ott_cols_final_cleaned(i))) '.']);
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Cleaned/TP39_OTT/ file. Master Name = ' char(header(ott_cols_final_cleaned(i)))])
                %     fill_data = NaN.*ones(
            end
        end
        clear ott_cols_final_cleaned ott_cleaned_labels var_to_find right_col
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% PART 2: Trenched Data:
        trenched_cols_final_cleaned = find(strncmp(header(:,4),'trenched',length('trenched'))==1 & ...
            strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
        
        try
            trenched_cleaned = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39_trenched/TP39_trenched_met_cleaned_' num2str(year(k)) '.mat']);
            if ~iscell(trenched_cleaned.master.labels)
                trenched_cleaned_labels = cellstr(trenched_cleaned.master.labels);
            else
                trenched_cleaned_labels = trenched_cleaned.master.labels;
            end
        catch
            disp('***Could not load TP39_trenched Final_Cleaned data.')
        end
        
        for i = 1:1:length(trenched_cols_final_cleaned)
            var_to_find = char(header(trenched_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            try
                %             right_col = find(strncmp(trenched_cleaned_labels(:,1),var_to_find,length(var_to_find))==1);
                %                 if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
                %                 disp('Try changing strncmp to strcmp on line ~ 344, or adjusting filenames'); end
                %
                right_col = find(strcmp(var_to_find,trenched_cleaned_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 378, or adjusting filenames');
                end
                master.data(master.data(:,1)==year(k), trenched_cols_final_cleaned(i)) = trenched_cleaned.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(trenched_cols_final_cleaned(i))) '.']);
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Cleaned/TP39_trenched/ file. Master Name = ' char(header(trenched_cols_final_cleaned(i)))])
                %     fill_data = NaN.*ones(
            end
        end
        clear trenched_cols_final_cleaned trenched_cleaned_labels var_to_find right_col
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load ppt data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% For TPD, include data from TPD_PPT: %%%%%%%%%%%%%%%%
    disp('---- PPT Data ----');

    switch site
        case 'TPD'
     met_cols_ppt = find(strncmp(header(:,4),'tpd_ppt',length('tpd_ppt'))==1 & strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
       if ~isempty(met_cols_ppt)
        try
            tpd_ppt = load([tpd_ppt_final_cleaned_path 'TPD_PPT_met_cleaned_' num2str(year(k)) '.mat']);
            if ~iscell(tpd_ppt.master.labels)
                ppt_labels = cellstr(tpd_ppt.master.labels);
            else
                ppt_labels = tpd_ppt.master.labels;
            end
        catch
            disp('***Could not load Cleaned TPD_PPT Data.')
        end
       
        %%% Look for the variable names listed in the 3rd column, and put
        %%% them into the appropriate spot in the master file:
        for i = 1:1:length(met_cols_ppt)
            var_to_find = char(header(met_cols_ppt(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            try
                %             right_col = find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1);
                right_col = find(strcmp(var_to_find,ppt_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 490, or adjusting filenames');
                end
                
                %             right_col = min(find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1));
                master.data(master.data(:,1)==year(k), met_cols_ppt(i)) = tpd_ppt.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(met_cols_ppt(i))) '.']);
                
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Cleaned/TPD_PPT/ file. Master Name = ' char(header(met_cols_ppt(i)))])
            end
        end
    else
        disp('None to process from here.');
    end
    clear met_cols_ppt ppt_labels tpd_ppt;
    end
    
    
    
    %%% Load GEONOR data: %%%%%%%%%%%%%%
    
    met_cols_ppt = find(strncmp(header(:,4),'ppt',length('ppt'))==1 & strncmp(header(:,5),'Final_Filled',length('Final_Filled'))==1);
    if ~isempty(met_cols_ppt)
        try
            ppt_filled = load([ppt_final_filled_path 'TP_PPT_filled_' num2str(year(k)) '.mat']);
            if ~iscell(ppt_filled.master.labels)
                ppt_labels = cellstr(ppt_filled.master.labels);
            else
                ppt_labels = ppt_filled.master.labels;
            end
        catch
            disp('***Could not load Filled (GEONOR) PPT Data.')
        end
        
        %%% Look for the variable names listed in the 3rd column, and put
        %%% them into the appropriate spot in the master file:
        for i = 1:1:length(met_cols_ppt)
            var_to_find = char(header(met_cols_ppt(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            try
                %             right_col = find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1);
                right_col = find(strcmp(var_to_find,ppt_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 419, or adjusting filenames');
                end
                
                %             right_col = min(find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1));
                master.data(master.data(:,1)==year(k), met_cols_ppt(i)) = ppt_filled.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(met_cols_ppt(i))) '.']);
                
            catch
                disp(['***Cannot find variable ' var_to_find ' in /Met/Final_Filled/TP_PPT/ file. Master Name = ' char(header(met_cols_ppt(i)))])
            end
        end
    else
        disp('None to process from here.');
    end
    clear met_cols_ppt ppt_labels ppt_filled;
    
    %% Added 30-Jan-2015 by JJB: compile parameter data where it's been
    %%% flagged for inclusion in the master list csv 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Load Parameter data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       disp('---- Parameters ----');

    param_cols = find(strncmp(header(:,4),'params',length('params'))==1);

    if ~isempty(param_cols)
              
        %%% Load using information from the 3rd column (data to load) and 5th column (column in loaded data):
        for i = 1:1:length(param_cols)
           var_to_find = char(header(param_cols(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
   
            try
                data_to_load = header{param_cols(i),3}; % String with name to input into params
            right_col = str2num(header{param_cols(i),5}); % column number to load
            eval(['params_data = params(' num2str(year(k)) ',''' site ''',''' data_to_load ''');']);
            master.data(master.data(:,1)==year(k), param_cols(i)) = params_data(:,right_col);
             disp(['Successfully updated variable: ' char(header(param_cols(i))) '.']);

            catch
            disp(['***Error updating ' var_to_find ' . Master Name = ' char(header(param_cols(i)))])
    
            end
        end
    else
      disp('No parameter data selected to compile.');  
    end
          
    clear param_cols var_to_find params_data;
    
    
   %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Load CPEC data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% 1. Data from /Final_Cleaned/
    disp('---- CPEC Final Cleaned ----');
    
    cpec_cols_final_cleaned = find(strncmp(header(:,4),'cpec',length('cpec'))==1 & strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
    if ~isempty(cpec_cols_final_cleaned)
        try
            cpec_cleaned = load([cpec_final_cleaned_path site '_CPEC_cleaned_' num2str(year(k)) '.mat']);
            if ~iscell(cpec_cleaned.master.labels)
                cpec_cleaned_labels = cellstr(cpec_cleaned.master.labels);
            else
                cpec_cleaned_labels =  cpec_cleaned.master.labels;
            end
        catch
            disp('***Could not load cpec cleaned data')
        end
        
        for i = 1:1:length(cpec_cols_final_cleaned)
            var_to_find = char(header(cpec_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
            
            try
                %             right_col = find(strncmp(cpec_cleaned_labels(:,1),var_to_find,length(var_to_find))==1);
                %             if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
                %                 disp('Try changing strncmp to strcmp on line ~ 415, or adjusting filenames'); end
                right_col = find(strcmp(var_to_find,cpec_cleaned_labels(:,1))==1);
                if numel(right_col)>1;
                    right_col = min(right_col);
                    disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                    disp('Try changing strncmp to strcmp on line ~ 461, or adjusting filenames');
                end
                master.data(master.data(:,1)==year(k), cpec_cols_final_cleaned(i)) = cpec_cleaned.master.data(:,right_col);
                disp(['Successfully updated variable: ' char(header(cpec_cols_final_cleaned(i))) '.']);
                
            catch
                disp(['***Cannot find variable ' var_to_find ' in /CPEC/Final_Cleaned/ file. Master Name = ' char(header(cpec_cols_final_cleaned(i)))])
                %     fill_data = NaN.*ones(
            end
        end
    else
        disp('None to process from here.');
    end
    
    clear cpec_cleaned cpec_cols_final_cleaned cpec_cleaned_labels var_to_find;
    
    %% 2. Data from /Final_Calculated/
    %%%%%%%  Gap-Filled NEE, GEP, RE data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('---- CPEC Final Calculated ----');
    
    cpec_cols_final_gf = find(strncmp(header(:,4),'gapfilled_NEE',length('gapfilled_NEE'))==1); %& strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    if ~isempty(cpec_cols_final_gf)
        for j = 1:1:length(cpec_cols_final_gf)
            clear filled_type tag_to_find right_struct err_gf;
            filled_type = header{cpec_cols_final_gf(j),3};
            tag_to_find = header{cpec_cols_final_gf(j),5};
            try
                right_struct = find(strcmp(tag_to_find,cpec_gf_NEE.master(1).taglist)==1);
                master.data(master.data(:,1)==year(k), cpec_cols_final_gf(j)) = ...
                    eval(['cpec_gf_NEE.master(right_struct).' filled_type '(cpec_gf_NEE.master(right_struct).Year == year(k),1);']);
                disp(['Successfully Updated ' filled_type ' for ' tag_to_find]);
            catch err_gf
                if abs(quickflag)==2
                disp(['***Problem updating ' filled_type ' for ' tag_to_find]);
                disp([err_gf.stack(1).name ', line ' num2str(err_gf.stack(1).line)]);
                else
                disp(['***' tag_to_find ' not updated in ' filled_type ' - quickflag = 1' ]);
                end
            end
        end
    else
        disp('None to process from here.');
    end
    clear cpec_cols_final_gf
    
    %%%%%%%  GapFilled LE, H data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cpec_cols_final_gf = find(strncmp(header(:,4),'gapfilled_LE_H',length('gapfilled_LE_H'))==1); %& strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    if ~isempty(cpec_cols_final_gf)
        
        for j = 1:1:length(cpec_cols_final_gf)
            clear filled_type tag_to_find right_struct err_gf;
            filled_type = header{cpec_cols_final_gf(j),3};
            tag_to_find = header{cpec_cols_final_gf(j),5};
            try
                right_struct = find(strcmp(tag_to_find,cpec_gf_LE_H.master(1).taglist)==1);
                master.data(master.data(:,1)==year(k), cpec_cols_final_gf(j)) = ...
                    eval(['cpec_gf_LE_H.master(right_struct).' filled_type '(cpec_gf_LE_H.master(right_struct).Year == year(k),1);']);
                disp(['Successfully Updated ' filled_type ' for ' tag_to_find]);
            catch err_gf
                if abs(quickflag)==2
                disp(['***Problem updating ' filled_type ' for ' tag_to_find]);
                disp([err_gf.stack(1).name ', line ' num2str(err_gf.stack(1).line)]);
                else
                disp(['***' tag_to_find ' not updated in ' filled_type ' - quickflag = 1' ]);
                end
            end
        end
    else
        disp('None to process from here.');
    end
    clear cpec_cols_final_gf
    
    %%%%%%% Load the other variables: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cpec_cols_final_calc = find(strncmp(header(:,4),'cpec',length('cpec'))==1 & strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    % Load the master file:
    if ~isempty(cpec_cols_final_calc)
    try
        CPEC_calc = load([cpec_final_calc_path site '_CPEC_calculated_' num2str(year(k)) '.mat']);
        if ~iscell(CPEC_calc.master.labels)
            CPEC_calc_labels = cellstr(CPEC_calc.master.labels);
        else
            CPEC_calc_labels = CPEC_calc.master.labels;
        end
    catch
        disp('***Could not load CPEC calculated data.')
    end
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(cpec_cols_final_calc)
        var_to_find = char(header(cpec_cols_final_calc(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = min(find(strncmp(CPEC_calc_labels(:,1),var_to_find,length(var_to_find))==1));
            if numel(right_col)>1; disp(['Multiple destination columns for ' var_to_find '.']);
                disp('Try changing strncmp to strcmp on line ~ 484, or adjusting filenames'); end
            master.data(master.data(:,1)==year(k), cpec_cols_final_calc(i)) = CPEC_calc.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(cpec_cols_final_calc(i))) '.']);
        catch
            if isempty(findstr(var_to_find, 'filled'))
                disp(['***Cannot find variable ' var_to_find ' in /Final_Calculated/ CPEC data.'])
            end
        end
    end
    else
        disp('None to process from here.');
    end    
    clear CPEC_calc cpec_cols_final_calc right_col CPEC_calc_labels var_to_find;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Load OPEC data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('---- OPEC Final Calculated / Cleaned ----');
    
    opec_cols_final_calc = find(strncmp(header(:,4),'opec',length('opec'))==1 & strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    % Load the master file:
    if ~isempty(opec_cols_final_calc)
    try
        OPEC_calc = load([opec_final_calc_path site '_OPEC_final_calc.mat']);
        if ~iscell(OPEC_calc.master.labels)
            OPEC_calc_labels = cellstr(OPEC_calc.master.labels);
        else
            OPEC_calc_labels = OPEC_calc.master.labels;
        end
    catch
        disp('***Could not load OPEC calculated data.')
    end
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(opec_cols_final_calc)
        var_to_find = char(header(opec_cols_final_calc(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            %             right_col = min(find(strncmp(OPEC_calc_labels(:,1),var_to_find,length(var_to_find))==1));
            right_col = find(strcmp(var_to_find,OPEC_calc_labels(:,1))==1);
            if numel(right_col)>1;
                right_col = min(right_col);
                disp(['Multiple destination columns for ' var_to_find '. Taking First Instance.']);
                disp('Try changing strncmp to strcmp on line ~ 461, or adjusting filenames');
            end
            master.data(master.data(:,1)==year(k), opec_cols_final_calc(i)) = OPEC_calc.master.data(OPEC_calc.master.data(:,2)==year(k),right_col);
            disp(['Successfully updated variable: ' char(header(opec_cols_final_calc(i))) '.']);
        catch
            if isempty(findstr(var_to_find, 'filled'))
                disp(['***Cannot find variable ' char(header(opec_cols_final_calc(i))) ' in /Final_Calculated/ OPEC data.'])
            end
        end
    end
        else
        disp('None to process from here.');
    end
    clear OPEC_calc opec_cols_final_calc right_col OPEC_calc_labels var_to_find;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Place Footprint Flag Data:
    disp('---- Footprint ----');
    
    if ~isempty(footprint_flag)
        fp_cols = find(strncmp(header(:,4),'footprint',length('footprint'))==1 );
        for i = 1:1:length(fp_cols)
            var_to_find = char(header(fp_cols(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end
            try
                eval(['master.data(master.data(:,1)==year(k), fp_cols(i)) = footprint_flag.' ...
                    var_to_find '(footprint_flag.' var_to_find '(:,1)==year(k),2);';])
                disp(['Successfully loaded ' var_to_find '.']);
                
            catch
                disp(['***Cound not load ' var_to_find '.']);
            end
        end
        clear fp_cols  var_to_find
    else
        disp('***Footprint data was not loaded.  Therefore, not saved');
    end
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% Consolidate Flux data (OPEC and CPEC): %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Into single variables with all data : %%%%%%%%%%%%%%%%%%%%%
    % The following variables will be consolidated at this point:
    % NEE, FC, LE, H, Ustar (more can be added later if required):
    switch site 
        case {'TP39','TP74','TP89','TP02','TPD'}
               
    num_errs = 0;
    %     try
    vars = {'NEE'; 'FC'; 'LE'; 'H'; 'Ustar'; 'dcdt'; 'dcdt_1h'; 'dcdt_2h'; 'CO2_top'; 'CO2_cpy'};
    new_varnames = {'NEE_all'; 'FC_all'; 'LE_all'; 'H_all'; 'Ustar_all'; 'dcdt_all'; 'dcdt_1h_all'; 'dcdt_2h_all'; 'CO2_top_all'; 'CO2_cpy_all'};
    
    for j = 1:1:size(vars,1)
        err_flag = 0;
        try
            master_col = mcm_find_right_col(header(:,3), char(new_varnames(j,1)));
            CPEC_data = master.data(master.data(:,1)==year(k), mcm_find_right_col(header(:,1), [char(vars(j,1)) '_CPEC']));
            try
                OPEC_data = master.data(master.data(:,1)==year(k), mcm_find_right_col(header(:,1), [char(vars(j,1)) '_OPEC']));
            catch
                err_flag = 1;
            end
            if err_flag ==1 || isempty(OPEC_data)==1
                OPEC_data = NaN.*ones(size(CPEC_data,1),1);
            end
            
            data_tmp = NaN.*ones(length(find(master.data(:,1)==year(k))),1);
            data_tmp = CPEC_data;
            data_tmp(isnan(data_tmp),1) = OPEC_data(isnan(data_tmp),1);
            
            master.data(master.data(:,1)==year(k),master_col) = data_tmp;
            %         plot(master.data(:,master_col))
            clear data_tmp CPEC_data OPEC_data master_col
        catch
            disp(['Problem consolidating ' new_varnames{j,1} ' - possibly because it does not exist.']);
            num_errs = num_errs + 1;
        end
        
    end
    
    if num_errs == length(vars)
        disp('***OPEC and CPEC flux data were not consolidated.');
        disp('***If this is a site with flux data, something is likely wrong.')
    elseif num_errs > 0 && num_errs < length(vars)
        disp(['Consolidation completed with ' num2str(num_errs) ' errors.'])
    elseif num_errs == 0
        disp('Successfully Consolidated OPEC and CPEC data.');
    end
        otherwise
%         disp('***OPEC and CPEC flux data were not consolidated.');
    end
    
    %         disp('Successfully Consolidated OPEC and CPEC data (if necessary).');
    %     catch
    %         disp('***OPEC and CPEC flux data were not consolidated.');
    %         disp('***If this is a site with flux data, something is likely wrong.')
    %     end
    
    %% Make NEP Field
    %%% Flip the sign of NEE_all and put it into NEP_all:
        switch site 
        case {'TP39','TP74','TP89','TP02','TPD'}
    try
        master_col_in = mcm_find_right_col(header(:,3), 'NEE_all');
        master_col_out = mcm_find_right_col(header(:,3), 'NEP_all');
        data_in_tmp = master.data(master.data(:,1)==year(k),master_col_in);
        master.data(master.data(:,1)==year(k),master_col_out) = data_in_tmp.*-1;
        
        clear data_in_tmp master_col_in master_col_out
        disp('Successfully created NEP from NEE');
    catch
        disp('**** Error - Could not create NEP from NEE');
    end
        end  
        
        
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Export data for different needs: %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Save Master File:
if quickflag ==1
    disp('Quickflag is set to 1.  Saving files will mean that no gap-filled data is saved');
    resp3 = input('Do you still want to continue to save? (y/n): > ','s');
    switch resp3
        case 'y'
            save_flag = 1;
        otherwise
            save_flag = 0;
    end
else
    save_flag = 1;
    
end

if save_flag == 0
    disp('***Data not saved....');
else
    master.labels = header; % Overwrite the labels with the header:
    save([master_out_path site '/' site '_data_master.mat'], 'master');
    % also save a copy to the /1/fielddata/GDrive/Master Files/Most Recent Data/ Directory -- changed from /Latest_Posted_Data directory:
    save([gdrive_path site '/' site '_data_master.mat'], 'master');
    % 
    disp('Saved Master File to its directory, and the /GDrive/ directory.');
    
    master_all = master;
    clear master;
    %% 2. Save Yearly Master Files:
    year_start = min(master_all.data(:,1));
    year_end = max(master_all.data(:,1));
    
    for j = year_start:1:year_end
        master.data = master_all.data(master_all.data(:,1)==j,:);
        master.labels = header;
        save([master_out_path site '/' site  '_data_master_' num2str(j) '.mat'], 'master');
        clear master;
        disp(['Saved Annual file for ' num2str(j)])
    end
    
    %% 3.Create a file for gap-filling work:
    if strcmp(site,'MCM_WX')==1 || strcmp(site,'TP_PPT')==1
    else
    
    clear gf_test
    gf_test(1:6,1) = 1;
    for k = 7:1:length(header)
        gf_test(k,1) = ~isempty(char(header(k,8)));
        gf_test2(k,1) = strcmp(char(header(k,8)),'NaN');
    end
    gf_test2(1:6,1) = 0;
    
    ind = find(gf_test==1 & gf_test2==0);
    vars_to_output = header(ind,8);
    data = struct;
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),8)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    data.site = site;
    save([master_out_path site '/' site  '_gapfill_data_in.mat'], 'data');
    disp('Saved File for Gapfilling Work');
    
    %% 4. Create a file for Jay's SM analysis work (corresponding to col 7 in header)
    clear jbout_test data;
    jbout_test(1:6,1) = 1;
    for k = 7:1:length(header)
        jbout_test(k,1) = ~isempty(char(header(k,9)));
        jbout_test2(k,1) = strcmp(char(header(k,9)),'NaN');
    end
    jbout_test2(1:6,1) = 0;
    ind = find(jbout_test==1 & jbout_test2==0);
    vars_to_output = header(ind,9);
    
    % Make a structure variable??
    data = struct;
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),9)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    data.site = site;
    save([master_out_path site '/' site  '_SM_analysis_data.mat'], 'data');
    disp('Saved File for Jay''s SM Work');
    
    %% 5. Create a file for Altaf's work (corresponding to col 8 in header)
    clear aaout_test data;
    aaout_test(1:6,1) = 1;
    for k = 7:1:length(header)
        aaout_test(k,1) = ~isempty(char(header(k,10)));
        aaout_test2(k,1) = strcmp(char(header(k,10)),'NaN');
    end
    aaout_test2(1:6,1) = 0;
    
    ind = find(aaout_test==1 & aaout_test2 == 0);
    vars_to_output = header(ind,10);
    data = struct;
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),10)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    data.site = site;
    save([master_out_path site '/' site  '_AA_analysis_data.mat'], 'data');
    disp('Saved File for Altaf''s Work');
    
    
    %% 6. Create a file for factorial experiment work:
    clear fct_test
    fct_test(1:6,1) = 1;
    for k = 7:1:length(header)
        fct_test(k,1) = ~isempty(char(header(k,11)));
        fct_test2(k,1) = strcmp(char(header(k,11)),'NaN');
    end
    fct_test2(1:6,1) = 0;
    
    ind = find(fct_test==1 & fct_test2==0);
    vars_to_output = header(ind,11);
    data = struct;
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),11)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    data.site = site;
    save([master_out_path site '/' site  '_fct_data.mat'], 'data');
    disp('Saved File for Factorial Work');
    
    %% 7. Create a file for Janelle's work:
    clear fct_test
    fct_test(1:6,1) = 1;
    for k = 7:1:length(header)
        fct_test(k,1) = ~isempty(char(header(k,12)));
        fct_test2(k,1) = strcmp(char(header(k,12)),'NaN');
    end
    fct_test2(1:6,1) = 0;
    
    ind = find(fct_test==1 & fct_test2==0);
    vars_to_output = header(ind,12);
    data = struct;
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),12)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    data.site = site;
    save([master_out_path site '/' site  '_Janelle_data.mat'], 'data');
    disp('Saved File for Janelle''s Work');    
    
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 7. Copy the /Master_Files/<site> directory to /home/arainlab/Google Drive/TPFS Data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if abs(quickflag)>1
        stat = unix(['cp -vr ' master_out_path site '/ "/home/arainlab/Google Drive/TPFS Data/Master_Files/"']);
        if stat ~=0
            disp('Could not copy files to Google Drive-synced folder. Check for problems');
        else
            disp('Uploaded Master files to Google Drive-synced folder (/home/arainlab/Google Drive/TPFS Data/Master_Files).');
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 8. Output Results to CCP format: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if quickflag ==2
    if ~isempty(CCP_site)
    disp('Do you want to output this data to CCP format?');
    disp('**Note, this may take quite some time...');
    commandwindow;
    ccp_go = input('Enter <1> to output, or <enter> to skip: > ');
    if ccp_go == 1
        try
            mcm_CCP_output(year,site,CCP_out_path,[]);
            disp('CCP data ouputted successfully.');
        catch CCP_err
            disp('***Error outputting CCP data (see below):')
            disp([CCP_err.stack.name ', line ' num2str(CCP_err.stack.line)]);
        end
    else
        disp('CCP data not selected for output.');
    end
    end
    end
end
disp('done');
diary off;
end

