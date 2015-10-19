function [] = mcm_data_compiler(year, site,quickflag)
% clear all;
% close all;
% year = 2008:2009;
% site = 'TP39';
% if nargin < 3
%     quickflag = 0;
% end
%%% mcm_data_compiler.m
% The purpose of this function is to compile data from different sources:
% - met data from the site
% - precipitation data (from FH or wherever available)
% - flux data (both CPEC and OPEC if available)

% Should have output be:
% a) structure file separated by year and then by variable
% b) single structure with all variables
% c) an output file for CCP submission (can link to GUI)

% What we'll need:
% 1. Filled Met - Ta, PAR, WS, WDir, RH, APR, Ts* (*if possible)
% 2. Final_Cleaned Met - All other important variables (for gap-filling),
% and all variables (for CCP output)
% 3. Cleaned and Filled fluxes

%%%
% First Created December 2009 by JJB
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
if nargin < 3 
    quickflag = 0;
end

if nargin ==3 && isempty(year)
        year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
end

% Makes sure that year is a string:
if ischar(year)
    disp('please put year into program as an integer (e.g. 2008) or set of integers (e.g. 2008:2009).')
    year = input('Enter year: > ');
end

% if nargin == 1
%     site = year;
%     clear year;
%     quickflag = 1;
% end

%% &&&&&&&&&&&&&&& Declare Paths: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% %%%% Input Paths:
ls = addpath_loadstart;
met_final_cleaned_path =    [ls 'Matlab/Data/Met/Final_Cleaned/' site '/'];
met_final_filled_path =     [ls 'Matlab/Data/Met/Final_Filled/' site '/'];
met_calc_path =             [ls 'Matlab/Data/Met/Calculated4/' site '/'];
%
ppt_final_cleaned_path =    [ls 'Matlab/Data/Met/Cleaned3/TP_PPT/'];
ppt_final_filled_path =     [ls 'Matlab/Data/Met/Final_Filled/TP_PPT/'];
%
cpec_final_cleaned_path =   [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/'];
cpec_final_calc_path =[ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
%
% opec_final_cleaned_path =    [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Cleaned/'];
opec_final_calc_path = [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Calculated/'];

%%%% Footprint File Path:
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%% Output Paths:
master_out_path =           [ls 'Matlab/Data/Master_Files/'];
CCP_out_path =              [ls 'Matlab/Data/CCP/'];

%% &&&&&&&&&&&&&&& Load data and Headers: &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%%% Load All-years Master File:
if exist([master_out_path '/' site '/' site '_data_master.mat'], 'file')== 2;
    disp('Found master all-years file. Loading. ');
    load([master_out_path '/' site '/' site '_data_master.mat']);
else
    disp('Could not find master all-years file. Creating one.');
    master.data = [];
    master.labels = [];
    %     return;
end

%%% Load Header for the site:
header = jjb_hdr_read([master_out_path '/Docs/' site '_master_list.csv'],',');
[r_header c_header] = size(header);
% Add more rows of NaNs if header has more variables than master is aware
% of:
[r c] = size(master.data);
if c == 0
    %%% Make a 30-minute master file:
    dt = []; Year = []; Month = []; Day = []; Hour = []; Minute = [];
    for i = 2002:1:2014
        %         TV = [TV; make_tv(i,30)];
        Year = [Year; i.*ones(yr_length(i,30),1)];
        [Mon_tmp Day_tmp] = make_Mon_Day(i,30);
        Month = [Month; Mon_tmp]; Day = [Day; Day_tmp];
        [HH_tmp MM_tmp] = make_HH_MM(i,30);
        Hour = [Hour; HH_tmp]; Minute = [Minute; MM_tmp];
        [junk1_tmp, junk2_tmp, junk3_tmp, dt_tmp] = jjb_makedate(i, 30);
        dt = [dt; dt_tmp];
        clear *_tmp
    end
    master.data = NaN.*ones(length(Year),r_header);
    master.data(:,1:6) = [Year Month Day Hour Minute dt];
    clear dt Year Month Day Hour Minute;
    %%% Save the master file to speed up re-running time when debugging
    master.labels = header; % Overwrite the labels with the header:
    save([master_out_path '/' site '/' site '_data_master.mat'], 'master');
    disp('Saved Master File.');
elseif c>0 && length(header)>c
    master.data = [master.data NaN.*ones(r,length(header)-c)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if quickflag ==1
    cpec_gf_NEE = [];
    cpec_gf_NEE2 = [];
    cpec_gf_LE_H = [];
else
    %%% Locate the proper filled flux files:
    disp('Is the FCRN-filled carbon data on separate files?');
    FCRN_data_flag = input('Enter <1> for separate files, or <0> if all data is on a single file, 9 to skip: ');
    if FCRN_data_flag == 0
        [file_data1, dir_data1] = uigetfile('*.mat','Select FCRN gap-filled carbon data file for all years',cpec_final_calc_path);
        pth_data = [dir_data1 file_data1];
        cpec_gf_NEE = load(pth_data);
    else
        cpec_gf_NEE = [];
    end
    
    disp('Is the PI-pref-filled carbon data on separate files?');
    PI_data_flag = input('Enter <1> for separate files, or <0> if all data is on a single file, 9 to skip: ');
    if PI_data_flag ==0
        [file_data2, dir_data2] = uigetfile('*.mat','Select PI-pref gap-filled carbon data file for all years',cpec_final_calc_path);
        pth_data = [dir_data2 file_data2];
        cpec_gf_NEE2 = load(pth_data);
    else
        cpec_gf_NEE2 = [];
    end
    
    disp('Is the filled LE and H data on separate files?');
    LE_H_data_flag = input('Enter <1> for separate files, or <0> if all data is on a single file, 9 to skip: ');
    if LE_H_data_flag ==0
        [file_data3, dir_data3] = uigetfile('*.mat','Select gap-filled LE,H data file for all years',cpec_final_calc_path);
        pth_data = [dir_data3 file_data3];
        cpec_gf_LE_H = load(pth_data);
    else
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
% data_type = char(header{:,4});
for k = 1:1:length(year)
    %year(k)
    disp(['Working on year: ' num2str(year(k)) '.']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load met data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 1. Data from /Final_Cleaned/
    %     if year(k) > 2007 || (year(k) > 2006 && strcmp(site, 'TP39')==1)
    %     if proceed.met_cleaned >0
    
    %%% Find all cases where 'met' is in 4th column of header, and 'Final_Cleaned'
    %%% is in 5th column
    met_cols_final_cleaned = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
    %%% Load the master file:
    try
        met_cleaned = load([met_final_cleaned_path site '_met_cleaned_' num2str(year(k)) '.mat']);
        if ~iscell(met_cleaned.master.labels)
            met_cleaned_labels = cellstr(met_cleaned.master.labels);
        else
            met_cleaned_labels = met_cleaned.master.labels;
        end
    catch
        disp('Could not load met cleaned data')
    end
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(met_cols_final_cleaned)
        var_to_find = char(header(met_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        
        try
            right_col = min(find(strncmp(met_cleaned_labels(:,1),var_to_find,length(var_to_find))==1));
            master.data(master.data(:,1)==year(k), met_cols_final_cleaned(i)) = met_cleaned.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(met_cols_final_cleaned(i))) '.']);
            
        catch
            disp(['Cannot find variable ' var_to_find ' in /Met/Final_Cleaned/ file. Master Name = ' char(header(met_cols_final_cleaned(i)))])
            %     fill_data = NaN.*ones(
        end
    end
    clear met_cleaned met_cols_final_cleaned right_col met_cleaned_labels;
    %     end
    %% 2. Data from /Calculated4/:
    %     if year(k) > 2007
    %     if proceed.met_calc >0
    
    %%% Find all cases where 'met' is in 4th column of header, and 'Calculated4'
    %%% is in 5th column
    
    met_cols_calc4 = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Calculated4',length('Calculated4'))==1);
    %%% At this point, there is no master file to load, just individual files
    %%% (SHF only), so we'll just go through and load the singular files.  At a
    %%% later point there may have to be a master loaded, but that will have to
    %%% be added in at that point.
    %%% Modified July, 2010 by JJB - now load a master file for each
    %%% site/year
    try
        soil_calc = load([met_calc_path site '_SHF_master_' num2str(year(k)) '.mat']);
        if ~iscell(soil_calc.master.labels)
            soil_labels = cellstr(soil_calc.master.labels);
        else
            soil_labels = soil_calc.master.labels;
        end
        
    catch
        disp('Could not load calculated soil data (SHF)')
    end
    
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(met_cols_calc4)
        var_to_find = char(header(met_cols_calc4(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = min(find(strncmp(soil_labels(:,1),var_to_find,length(var_to_find))==1));
            master.data(master.data(:,1)==year(k), met_cols_calc4(i)) = soil_calc.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(met_cols_calc4(i))) '.']);
            
        catch
            disp(['Cannot find variable ' var_to_find ' in /Met/Calculated4/ file. Master Name = ' char(header(met_cols_calc4(i)))])
        end
    end
    clear met_cols_calc4 soil_calc soil_labels;
    %         for i = 1:1:length(met_cols_calc4)
    %             extension = char(header(met_cols_calc4(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
    %             try
    %                 tmp_calc = load([met_calc_path site '_' num2str(year(k)) extension]);
    %                 master.data(master.data(:,1)==year(k), met_cols_calc4(i)) = tmp_calc;
    %                 disp(['Successfully updated variable: ' char(header(met_cols_calc4(i))) '.']);
    %
    %                 clear tmp_calc;
    %             catch
    %                 disp(['Cannot find variable ' extension ' in /Met/Calculated4/. Master Name = ' char(header(met_cols_calc4(i)))])
    %                 %     fill_data = NaN.*ones(
    %             end
    %         end
    %     end
    %% 3. Data from /Final_Filled:
    %     if year(k) > 2007
    %     if proceed.met_filled >0
    %%% Find all cases where 'met' is in 4th column of header, and 'Calculated4'
    %%% is in 5th column
    met_cols_final_filled = find(strncmp(header(:,4),'met',length('met'))==1 & strncmp(header(:,5),'Final_Filled',length('Final_Filled'))==1);
    try
        met_filled= load([met_final_filled_path site '_met_filled_' num2str(year(k)) '.mat']);
        if ~iscell(met_filled.master.labels)
            met_filled_labels = cellstr(met_filled.master.labels);
        else
            met_filled_labels = met_filled.master.labels;
            
        end
    catch
        disp('Could not load met filled data')
    end
    
    for i = 1:1:length(met_cols_final_filled)
        var_to_find = char(header(met_cols_final_filled(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = find(strncmp(met_filled_labels(:,1),var_to_find,length(var_to_find))==1);
            master.data(master.data(:,1)==year(k), met_cols_final_filled(i)) = met_filled.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(met_cols_final_filled(i))) '.']);
        catch
            disp(['Cannot find variable ' var_to_find ' in /Met/Final_Filled/ file. Master Name = ' char(header(met_cols_final_filled(i)))])
            %     fill_data = NaN.*ones(
        end
    end
    clear met_cols_final_filled met_filled_labels var_to_find right_col
    %     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load ppt data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% At this point there is only really one type of data to load up - GEONOR.
    %     if year(k) > 2007
    %     if proceed.ppt_filled > 0
    met_cols_ppt = find(strncmp(header(:,4),'ppt',length('ppt'))==1 & strncmp(header(:,5),'Final_Filled',length('Final_Filled'))==1);
    
    try
        ppt_filled = load([ppt_final_filled_path 'TP_PPT_filled_' num2str(year(k)) '.mat']);
        if ~iscell(ppt_filled.master.labels)
            ppt_labels = cellstr(ppt_filled.master.labels);
        else
            ppt_labels = ppt_filled.master.labels;
        end
    catch
        disp('Could not load Filled (GEONOR) PPT Data.')
    end
    
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(met_cols_ppt)
        var_to_find = char(header(met_cols_ppt(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1);
            
            %             right_col = min(find(strncmp(ppt_labels(:,1),var_to_find,length(var_to_find))==1));
            master.data(master.data(:,1)==year(k), met_cols_ppt(i)) = ppt_filled.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(met_cols_ppt(i))) '.']);
            
        catch
            disp(['Cannot find variable ' var_to_find ' in /Met/Final_Filled/TP_PPT/ file. Master Name = ' char(header(met_cols_ppt(i)))])
        end
    end
    clear met_cols_ppt ppt_labels ppt_filled;
    
    
    %         for i = 1:1:length(met_cols_ppt)
    %             extension = char(header(met_cols_ppt(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
    %             try
    %                 tmp_calc = load([ppt_final_filled_path 'TP_PPT_' num2str(year(k)) extension]);
    %                 master.data(master.data(:,1)==year(k), met_cols_ppt(i)) = tmp_calc;
    %                 disp(['Successfully updated variable: ' char(header(met_cols_ppt(i))) '.']);
    %
    %                 clear tmp_calc;
    %             catch
    %                 disp(['Cannot find variable ' extension ' in /TP_PPT/. Master Name = ' char(header(met_cols_ppt(i)))])
    %                 %     fill_data = NaN.*ones(
    %             end
    %         end
    
    %     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Load CPEC data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% 1. Data from /Final_Cleaned/
    %     if year(k) > 2007
    %     if proceed.flux_cleaned > 0 && proceed.flux_cleaned < 2;
    cpec_cols_final_cleaned = find(strncmp(header(:,4),'cpec',length('cpec'))==1 & strncmp(header(:,5),'Final_Cleaned',length('Final_Cleaned'))==1);
    
    try
        cpec_cleaned = load([cpec_final_cleaned_path site '_CPEC_cleaned_' num2str(year(k)) '.mat']);
        if ~iscell(cpec_cleaned.master.labels)
            cpec_cleaned_labels = cellstr(cpec_cleaned.master.labels);
        else
            cpec_cleaned_labels =  cpec_cleaned.master.labels;
        end
    catch
        disp('Could not load cpec cleaned data')
    end
    
    for i = 1:1:length(cpec_cols_final_cleaned)
        var_to_find = char(header(cpec_cols_final_cleaned(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        
        try
            right_col = find(strncmp(cpec_cleaned_labels(:,1),var_to_find,length(var_to_find))==1);
            master.data(master.data(:,1)==year(k), cpec_cols_final_cleaned(i)) = cpec_cleaned.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(cpec_cols_final_cleaned(i))) '.']);
            
        catch
            disp(['Cannot find variable ' var_to_find ' in /CPEC/Final_Cleaned/ file. Master Name = ' char(header(cpec_cols_final_cleaned(i)))])
            %     fill_data = NaN.*ones(
        end
    end
    clear cpec_cleaned cpec_cols_final_cleaned cpec_cleaned_labels var_to_find;
    %     end
    %% 2. Data from /Final_Calculated/
    %     if proceed.flux_calc > 0;
    cpec_cols_final_calc = find(strncmp(header(:,4),'cpec',length('cpec'))==1 & strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    
    %%% Loads FCRN-gapfilled NEE, RE and GEP files, as selected by user:
    try
        if FCRN_data_flag == 1
            [file_data1, dir_data1] = uigetfile('*.mat',['Select FCRN gap-filled NEE data file for ' num2str(year(k))],cpec_final_calc_path);
            pth_data = [dir_data1 file_data1];
            cpec_gf_NEE = load(pth_data);
        end
        NEE_filled_col = find(strncmp(header(:,3),'NEE_filled', length('NEE_filled'))==1 & strncmp(header(:,4),'calc',length('calc'))==1,1,'first');
        master.data(master.data(:,1)==year(k), NEE_filled_col) = ...
            cpec_gf_NEE.master.data(cpec_gf_NEE.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE.master.labels,'NEE_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        %         master.data(master.data(:,1)==year(k), NEE_filled_col) = cpec_gf_NEE.master.data.NEE_filled(cpec_gf_NEE.master.data.Year==year(k));
        RE_filled_col = find(strncmp(header(:,3),'RE_filled', length('RE_filled'))==1 & strncmp(header(:,4),'calc',length('calc'))==1,1,'first');
        master.data(master.data(:,1)==year(k), RE_filled_col) = ...
            cpec_gf_NEE.master.data(cpec_gf_NEE.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE.master.labels,'RE_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        %         master.data(master.data(:,1)==year(k), RE_filled_col) = cpec_gf_NEE.master.data.RE_filled(cpec_gf_NEE.master.data.Year==year(k));
        GEP_filled_col = find(strncmp(header(:,3),'GEP_filled', length('GEP_filled'))==1 & strncmp(header(:,4),'calc',length('calc'))==1,1,'first');
        master.data(master.data(:,1)==year(k), GEP_filled_col) = ...
            cpec_gf_NEE.master.data(cpec_gf_NEE.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE.master.labels,'GEP_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        %         master.data(master.data(:,1)==year(k), GEP_filled_col) = cpec_gf_NEE.master.data.GEP_filled(cpec_gf_NEE.master.data.Year==year(k));
        %     cpec_NEE_gapfilled = load([cpec_final_calc_path site '_CPEC_final_calculated_' num2str(year(k)) '.mat'])
        %     cpec_calc = load([cpec_final_calc_path site '_CPEC_final_calculated_' num2str(year(k)) '.mat']);
        % cpec_calc_labels = cellstr(cpec_calc.master.labels);
        disp('Successfully updated FCRN-filled carbon flux variables -- ignore warnings below');
    catch
        disp('Could not load FCRN Gap-filled Carbon data')
    end
    
    %%% Loads PI-pref-gapfilled NEE, RE and GEP files, as selected by user:
    try
        if PI_data_flag == 1
            
            [file_data2, dir_data2] = uigetfile('*.mat','Select PI-pref gap-filled NEE data file',cpec_final_calc_path);
            pth_data = [dir_data2 file_data2];
            cpec_gf_NEE2 = load(pth_data);
        end
        NEE_filled_col2 = find(strncmp(header(:,3),'NEE_filled_PI_pref', length('NEE_filled_PI_pref'))==1 & strncmp(header(:,4),'calc',length('calc'))==1);
        master.data(master.data(:,1)==year(k), NEE_filled_col2) = ...
            cpec_gf_NEE2.master.data(cpec_gf_NEE2.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE2.master.labels,'NEE_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        
        %         master.data(master.data(:,1)==year(k), NEE_filled_col2) = cpec_gf_NEE2.master.data.NEE_filled(cpec_gf_NEE2.master.data.Year==year(k));
        RE_filled_col2 = find(strncmp(header(:,3),'RE_filled_PI_pref', length('RE_filled_PI_pref'))==1 & strncmp(header(:,4),'calc',length('calc'))==1);
        master.data(master.data(:,1)==year(k), RE_filled_col2) = ...
            cpec_gf_NEE2.master.data(cpec_gf_NEE2.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE2.master.labels,'RE_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        
        %         master.data(master.data(:,1)==year(k), RE_filled_col2) = cpec_gf_NEE2.master.data.RE_filled(cpec_gf_NEE2.master.data.Year==year(k));
        GEP_filled_col2 = find(strncmp(header(:,3),'GEP_filled_PI_pref', length('GEP_filled_PI_pref'))==1 & strncmp(header(:,4),'calc',length('calc'))==1);
        master.data(master.data(:,1)==year(k), GEP_filled_col2) = ...
            cpec_gf_NEE2.master.data(cpec_gf_NEE2.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_NEE2.master.labels,'GEP_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        
        %         master.data(master.data(:,1)==year(k), GEP_filled_col2) = cpec_gf_NEE2.master.data.GEP_filled(cpec_gf_NEE2.master.data.Year==year(k));
        
        %     cpec_NEE_gapfilled = load([cpec_final_calc_path site '_CPEC_final_calculated_' num2str(year(k)) '.mat'])
        %     cpec_calc = load([cpec_final_calc_path site '_CPEC_final_calculated_' num2str(year(k)) '.mat']);
        % cpec_calc_labels = cellstr(cpec_calc.master.labels);
        disp('Successfully updated PI-Pref filled carbon flux variables -- ignore warnings below');
        
    catch
        disp('Could not load PI-Pref Gap-filled Carbon data')
    end
    
    
    %%% Load the gap-filled LE and H data:
    try
        if LE_H_data_flag == 1
            
            [file_data3, dir_data3] = uigetfile('*.mat','Select gap-filled LE,H data file',cpec_final_calc_path);
            pth_data = [dir_data3 file_data3];
            cpec_gf_LE_H = load(pth_data);
        end
        LE_filled_col = find(strncmp(header(:,3),'LE_filled', length('LE_filled'))==1 & strncmp(header(:,4),'calc',length('calc'))==1);
        master.data(master.data(:,1)==year(k), LE_filled_col) = ...
            cpec_gf_LE_H.master.data(cpec_gf_LE_H.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_LE_H.master.labels,'LE_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        %         master.data(master.data(:,1)==year(k), LE_filled_col) = cpec_gf_LE_H.master.data.LE_filled(cpec_gf_LE_H.master.data.Year==year(k));
        
        H_filled_col = find(strncmp(header(:,3),'H_filled', length('H_filled'))==1 & strncmp(header(:,4),'calc',length('calc'))==1);
        %         master.data(master.data(:,1)==year(k), H_filled_col) = cpec_gf_LE_H.master.data.H_filled(cpec_gf_LE_H.master.data.Year==year(k));
        master.data(master.data(:,1)==year(k), H_filled_col) = ...
            cpec_gf_LE_H.master.data(cpec_gf_LE_H.master.data(:,1) == year(k),mcm_find_right_col(cpec_gf_LE_H.master.labels,'H_filled')) ; % (cpec_gf_LE_H.master.data.Year==year(k));
        disp('Successfully updated filled LE, H flux variables -- ignore warnings below');
        
    catch
        disp('Could not load / Error Loading filled LE, H Data')
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Try to load the other variables:
    var_to_find = char(header(cpec_cols_final_calc(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
    % Load the master file:
    try
        CPEC_calc = load([cpec_final_calc_path site '_CPEC_calculated_' num2str(year(k)) '.mat']);
        if ~iscell(CPEC_calc.master.labels)
            CPEC_calc_labels = cellstr(CPEC_calc.master.labels);
        else
            CPEC_calc_labels = CPEC_calc.master.labels;
        end
    catch
        disp('Could not load CPEC calculated data.')
    end
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(cpec_cols_final_calc)
        var_to_find = char(header(cpec_cols_final_calc(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = min(find(strncmp(CPEC_calc_labels(:,1),var_to_find,length(var_to_find))==1));
            master.data(master.data(:,1)==year(k), cpec_cols_final_calc(i)) = CPEC_calc.master.data(:,right_col);
            disp(['Successfully updated variable: ' char(header(cpec_cols_final_calc(i))) '.']);
        catch
            if isempty(findstr(var_to_find, 'filled'))
                disp(['Cannot find variable ' var_to_find '. Ignore if this is a filled variable.'])
            end
        end
    end
    clear CPEC_calc cpec_cols_final_calc right_col CPEC_calc_labels var_to_find;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Load OPEC data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    opec_cols_final_calc = find(strncmp(header(:,4),'opec',length('opec'))==1 & strncmp(header(:,5),'Final_Calculated',length('Final_Calculated'))==1);
    % Load the master file:
    try
        OPEC_calc = load([opec_final_calc_path site '_OPEC_final_calc.mat']);
        if ~iscell(OPEC_calc.master.labels)
            OPEC_calc_labels = cellstr(OPEC_calc.master.labels);
        else
            OPEC_calc_labels = OPEC_calc.master.labels;
        end
    catch
        disp('Could not load OPEC calculated data.')
    end
    %%% Look for the variable names listed in the 3rd column, and put
    %%% them into the appropriate spot in the master file:
    for i = 1:1:length(opec_cols_final_calc)
        var_to_find = char(header(opec_cols_final_calc(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end;
        try
            right_col = min(find(strncmp(OPEC_calc_labels(:,1),var_to_find,length(var_to_find))==1));
            
            master.data(master.data(:,1)==year(k), opec_cols_final_calc(i)) = OPEC_calc.master.data(OPEC_calc.master.data(:,2)==year(k),right_col);
            disp(['Successfully updated variable: ' char(header(opec_cols_final_calc(i))) '.']);
        catch
            if isempty(findstr(var_to_find, 'filled'))
                disp(['Cannot find variable ' char(header(opec_cols_final_calc(i))) '....'])
            end
        end
    end
    clear OPEC_calc opec_cols_final_calc right_col OPEC_calc_labels var_to_find;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Place Footprint Flag Data:
    if ~isempty(footprint_flag)
        fp_cols = find(strncmp(header(:,4),'footprint',length('footprint'))==1 );
        for i = 1:1:length(fp_cols)
            var_to_find = char(header(fp_cols(i),3)); try var_to_find(var_to_find(1,:)==' ') = ''; catch; end
            try
                eval(['master.data(master.data(:,1)==year(k), fp_cols(i)) = footprint_flag.' ...
                    var_to_find '(footprint_flag.' var_to_find '(:,1)==year(k),2);';])
                disp(['Successfully loaded ' var_to_find '.']);
                
            catch
                disp(['Cound not load ' var_to_find '.']);
            end
        end
        clear fp_cols  var_to_find
    else
        disp('Footprint data was not loaded.  Therefore, not saved');
    end
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% Consolidate Flux data (OPEC and CPEC): %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Into single variables with all data : %%%%%%%%%%%%%%%%%%%%%
    % The following variables will be consolidated at this point:
    % NEE, FC, LE, H, Ustar (more can be added later if required):
    vars = {'NEE'; 'FC'; 'LE'; 'H'; 'Ustar'};
    
    for j = 1:1:size(vars,1)
        master_col = mcm_find_right_col(header(:,1), char(vars(j,1)));
        CPEC_data = master.data(master.data(:,1)==year(k), mcm_find_right_col(header(:,1), [char(vars(j,1)) '_CPEC']));
        OPEC_data = master.data(master.data(:,1)==year(k), mcm_find_right_col(header(:,1), [char(vars(j,1)) '_OPEC']));
        
        data_tmp = NaN.*ones(length(find(master.data(:,1)==year(k))),1);
        data_tmp = CPEC_data;
        data_tmp(isnan(data_tmp),1) = OPEC_data(isnan(data_tmp),1);
        
        master.data(master.data(:,1)==year(k),master_col) = data_tmp;
        plot(master.data(:,master_col))
        clear data_tmp CPEC_data OPEC_data master_col
        
    end
    
    
end




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Export data for different needs: %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Save Master File:
if quickflag ==1
    disp('Quickflag is set to 1.  Saving files will mean that no gap-filled data is saved');
    resp3 = input('Do you still want to continue to save? (y/n) ; ','s');
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
    disp('Data not saved....');
else
    master.labels = header; % Overwrite the labels with the header:
    save([master_out_path '/' site '/' site '_data_master.mat'], 'master');
    disp('Saved Master File.');
    
    master_all = master;
    clear master;
    %% 2. Save Yearly Master Files:
    year_start = min(master_all.data(:,1));
    year_end = max(master_all.data(:,1));
    
    for j = year_start:1:year_end
        master.data = master_all.data(master_all.data(:,1)==j,:);
        master.labels = header;
        save([master_out_path '/' site '/' site  '_data_master_' num2str(j) '.mat'], 'master');
        clear master;
        disp(['Saved Annual file for ' num2str(j)])
    end
    
    %% 3.Create a file for gap-filling work:
    clear gf_test
    gf_test(1:6,1) = 1;
    for k = 7:1:length(header)
        gf_test(k,1) = ~isempty(char(header(k,6)));
        gf_test2(k,1) = strcmp(char(header(k,6)),'NaN');
    end
    gf_test2(1:6,1) = 0;
    
    ind = find(gf_test==1 & gf_test2==0);
    vars_to_output = header(ind,6);
    
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),6)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    save([master_out_path '/' site '/' site  '_gapfill_data_in.mat'], 'data');
    disp('Saved File for Gapfilling Work');
    
    % gf_cols = find(~isempty(char(header(:,6))));%,'gf',length('gf'))==1 );
    % labels = header(gf_cols,1);
    
    %% 4. Create a file for Jay's SM analysis work (corresponding to col 7 in header)
    clear jbout_test data;
    jbout_test(1:6,1) = 1;
    for k = 7:1:length(header)
        jbout_test(k,1) = ~isempty(char(header(k,7)));
        jbout_test2(k,1) = strcmp(char(header(k,7)),'NaN');
    end
    jbout_test2(1:6,1) = 0;
    ind = find(jbout_test==1 & jbout_test2==0);
    vars_to_output = header(ind,7);
    
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),7)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    save([master_out_path '/' site '/' site  '_SM_analysis_data.mat'], 'data');
    disp('Saved File for Jay''s SM Work');
    
    
    % %% 5. (Temporary) Make a file that is in EST and can be used in old scripts
    % %%%%% (e.g. TP39.mat, TP02.mat, etc...);
    % [r c] = size(master_all.data);
    % master_EDT(:,1:6) = master_all.data(:,1:6);
    % master_EDT(:,7:c) = [master_all.data(9:r,7:c) ; NaN.*ones(8,c-6)  ];
    %
    % gf_test(1:6,1) = 1;
    % for k = 7:1:length(header)
    %     gf_test(k,1) = ~isempty(char(header(k,6)));
    % end
    % ind = find(gf_test==1);
    % vars_to_output = header(ind,6);
    %
    % % Make a structure variable??
    % for yr = 2003:1:2008
    %     yr_ctr = yr-2002;
    %     for k = 1:1:length(ind);
    %         eval([site '(' num2str(yr_ctr)  ').' char(header(ind(k),6)) ' = master_EDT(master_EDT(:,1)==' num2str(yr)  ',' num2str(ind(k)) ');'])
    %     end
    % end
    %
    % save([master_out_path '/' site '/' site  '.mat'], site);
    % % disp('Saved File for Gapfilling Work');
    
    %% 6. Create a file for Altaf's work (corresponding to col 8 in header)
    clear aaout_test data;
    aaout_test(1:6,1) = 1;
    for k = 7:1:length(header)
        aaout_test(k,1) = ~isempty(char(header(k,8)));
        aaout_test2(k,1) = strcmp(char(header(k,8)),'NaN');
    end
    aaout_test2(1:6,1) = 0;
    
    ind = find(aaout_test==1 & aaout_test2 == 0);
    vars_to_output = header(ind,8);
    
    % Make a structure variable??
    for k = 1:1:length(ind);
        eval(['data.' char(header(ind(k),8)) ' = master_all.data(:,' num2str(ind(k)) ');'])
    end
    save([master_out_path '/' site '/' site  '_AA_analysis_data.mat'], 'data');
    disp('Saved File for Altaf''s Work');
    
    
    
end
disp('done');



% Junk
%     %% Declare Paths and rules for what data can be updated:
%     %%% Start with permisson to load all files (by default)
%       proceed.met_cleaned = 1; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 1; proceed.ppt_filled = 1; proceed.flux_cleaned = 1; proceed.flux_calc = 1;
%     if year(k) < 2006
%         proceed.met_cleaned = 0; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 0; proceed.ppt_filled = 0; proceed.flux_cleaned = 0; proceed.flux_calc = 1;
%     elseif year(k) == 2006
%         switch site
%             case 'TP39'
%                 proceed.met_cleaned = 0; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 0; proceed.ppt_filled = 0; proceed.flux_cleaned = 1; proceed.flux_calc = 1;
%             otherwise
%                 proceed.met_cleaned = 0; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 0; proceed.ppt_filled = 0; proceed.flux_cleaned = 0; proceed.flux_calc = 1;
%         end
%     elseif year(k) == 2007
%         switch site
%             case 'TP39'
%                 proceed.met_cleaned = 1; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 0; proceed.ppt_filled = 0; proceed.flux_cleaned = 1; proceed.flux_calc = 1;
%             otherwise
%                 proceed.met_cleaned = 0; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 0; proceed.ppt_filled = 0; proceed.flux_cleaned = 2; proceed.flux_calc = 1;
%         end
%     elseif year(k) > 2007
%         proceed.met_cleaned = 1; proceed.met_filled = 1; proceed.met_calc = 1; proceed.ppt_cleaned = 1; proceed.ppt_filled = 1; proceed.flux_cleaned = 1; proceed.flux_calc = 1;
%     end
%
%     switch proceed.met_cleaned
%         case 1
%             met_final_cleaned_path =    [ls 'Matlab/Data/Met/Final_Cleaned/' site '/']; otherwise;  met_final_cleaned_path =    [];
%     end
%
%     switch proceed.met_filled
%         case 1
%             met_final_filled_path =    [ls 'Matlab/Data/Met/Final_Filled/' site '/']; otherwise; met_final_filled_path =    [];
%     end
%
%     switch proceed.met_calc
%         case 1
%             met_calc_path =             [ls 'Matlab/Data/Met/Calculated4/' site '/'];    otherwise;   met_calc_path =             [];
%     end
%
%     switch proceed.ppt_cleaned
%         case 1
%             ppt_final_cleaned_path =             [ls 'Matlab/Data/Met/Cleaned3/TP_PPT/'];  otherwise;  ppt_final_cleaned_path =             [];
%     end
%
%     switch proceed.ppt_filled
%         case 1
%             ppt_final_filled_path =     [ls 'Matlab/Data/Met/Final_Filled/TP_PPT/']; otherwise;  ppt_final_filled_path =             [];
%     end
%
%     switch proceed.flux_cleaned
%         case 1
%             cpec_final_cleaned_path =   [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/']; otherwise;  cpec_final_cleaned_path =             [];
%     end
%
%     switch proceed.flux_calc
%         case 1
%             cpec_final_calc_path =[ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/']; otherwise;  cpec_final_calc_path =             [];
%     end
