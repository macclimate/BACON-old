function[met_master hdr_cell_tmpt yr_len num_cols dir_data] = CR1000_metloader(site, year,load_path)
loadstart = addpath_loadstart;
if ischar(year) == false
    yr_str = num2str(year);
else
    yr_str = year;
    year = str2num(year);
end
%% DECLARE PATHS

%%% Loads paths for Sapflow data
% if strcmp(site,'sf')==true        %%%% check if processing sapflow or met data
%     %%% Defines the path where the raw data file is to be loaded
%     pth_data_start = ([ loadstart 'Matlab/Data/Met/Raw1/Sapflow/' yr_str '/']);
%     %%% Establish Output directories for master file, 5min, 30min and 1 hour column vectors
%     output_dir = ([ loadstart 'Matlab/Data/Met/Organized2/Sapflow/Master/']);    % Master file
%
%     % elseif strcmp(site,'TP_PPT')==true        %%%% check if processing Fish Hatchery Precip Data
%     % pth_data_start = ([ loadstart 'Matlab/Data/Met/Raw1/' site '/' yr_str '/']);
%     % %%% Establish Output directories for master file, 5min, 30min and 1 hour column vectors
%     % output_dir = ([ loadstart 'Matlab/Data/Met/Organized2/' site '/Master/']);    % Master file
%
% else
% pth_hdr = ('C:/Home/Matlab/Data/Met/Raw1/Docs/'); %% declare the folder where column header .txt files are located
%%% Defines the path where the raw data file is to be loaded
% pth_data_start = ([ loadstart 'Matlab/Data/Met/Raw1/' site '/' yr_str '/' ]);        % Defines the path where the raw data file is to be loaded
%%% Establish Output directories for master file, 5min, 30min and 1 hour column vectors
output_dir = [ loadstart 'Matlab/Data/Met/Organized2/' site '/Master/'];    % Master File
jjb_check_dirs(output_dir,0);
% end

%%% Declare the header .txt (or .csv) files and data files are located
% pth_hdr_start = ([ loadstart 'Matlab/Data/Met/Raw1/Docs/']);
pth_hdr_start = ([ loadstart 'Matlab/Config/Met/Organizing-Header_OutputTemplate/']); %01-May-2012 Changed to /Config/ directory

[dir_data] = uigetdir(load_path,'Select directory to process data');

% [file_tmpt dir_tmpt] = uigetfile('*.csv','Select Output Template file for atmo data',pth_hdr_start);
% pth_tmpt = [dir_tmpt file_tmpt];
pth_tmpt = [pth_hdr_start site '_OutputTemplate.csv']; % changed this to be automatic.

% pth_names = [loadstart 'Matlab/Data/Met/Raw1/Docs/' site '_CR1000_Namefile.csv']; % Changed 01-May-2012
pth_names = [pth_hdr_start site '_CR_Namefile.csv']; % Changed 01-May-2012

%% OPEN HEADER FILES %%%%%%%%%%%%%%%%%%%%%%%
%%% Open the output template file
[hdr_cell_tmpt] = jjb_hdr_read(pth_tmpt ,',',3);
%%% Open the variable name conversion file
[hdr_names] = jjb_hdr_read(pth_names,',',2);

%%% Cycle through the hdr_names file and make sure that there are no
%%% quotation marks around the variable names:
for i = 1:1:length(hdr_names);
    tmp_name1 = hdr_names{i,1};      tmp_name2 = hdr_names{i,2};
    tmp_name1(tmp_name1 == '"')= ''; tmp_name2(tmp_name2 == '"')= '';
    hdr_names{i,1} = tmp_name1;      hdr_names{i,2} = tmp_name2;
    clear tmp_name1 tmp_name2
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   LOADING OR CREATING MASTER FILE:
% Determine length of columns needed if master file needs to be created:
% if strcmp(site,'TP39')==true
%     num_cols = 110;
% elseif strcmp(site,'TP_PPT')==true
%     num_cols = 30;
% else
%     num_cols = 60;
% end
num_cols = size(hdr_cell_tmpt,1);

% Determine Year length:
[junk(:,1) junk(:,2) junk(:,3) junk(:,4)]  = jjb_makedate(str2double(yr_str),30);
yr_len = length(junk);
clear junk
% Find out if master file exists, or if one needs to be made:
if exist([output_dir site 'master' yr_str '.mat']);                           % Check if the output master file already exists
    disp ('Master .mat File exists --- Opening for appending')
    load([output_dir site 'master' yr_str '.mat']); % If master file exists, open it for appending
    
    if strcmp(site,'TP_PPT')==true
        TV = make_tv(str2num(yr_str),30);
        [Year JD HHMM] =jjb_makedate(str2num(yr_str),30);
    else
        TV = make_tv(str2num(yr_str),5);
        [Year JD HHMM] =jjb_makedate(str2num(yr_str),5);
    end
    
    
elseif exist([output_dir site 'master' yr_str '.dat']);                           % Check if the output master file already exists
    disp ('Master File exists --- Opening for appending')
    met_master = load([output_dir site 'master' yr_str '.dat']); % If master file exists, open it for appending
    
    if strcmp(site,'TP_PPT')==true
        TV = make_tv(str2num(yr_str),30);
        [Year JD HHMM] =jjb_makedate(str2num(yr_str),30);
    else
        TV = make_tv(str2num(yr_str),5);
        [Year JD HHMM] =jjb_makedate(str2num(yr_str),5);
    end
    
else
    disp('Master File does not exist --- Creating file')                      % If master file does not exist,
    if strcmp(site,'TP_PPT')==true
        met_master(1:yr_len,1:num_cols) = NaN;
    else
        met_master(1:yr_len*6,1:num_cols) = NaN;                                % create a matrix with 60 (0r 110) empty NaN columns for every 5 minutes in a year
    end
    %%%% Added August 20, 2010 by JJB & SLM - Program checks the size
    %%%% of met_master against the size of the output template, and
    %%%% adds columns to the master file if needed.
    if size(met_master,2) < num_cols
        cols2add = num_cols - size(met_master,2);
        met_master = [met_master NaN.*ones(size(met_master,1),cols2add)];
    end
    
    
    
    % make a time vector using make_tv function, place it into the first
    % column of master file
    if strcmp(site,'TP_PPT')==true
        TV = make_tv(str2double(yr_str),30);
        [Year, JD, HHMM, dt] =jjb_makedate(str2double(yr_str),30);
    else
        TV = make_tv(str2double(yr_str),5);
        [Year, JD, HHMM, dt] =jjb_makedate(str2double(yr_str),5);
    end
    met_master(:,1) = TV;
    met_master(:,2) = Year(:,1);
    met_master(:,3) = JD(:,1);
    met_master(:,4) = HHMM(:,1);
end

%% **************************** LOAD data files from selected directory:
D = dir(dir_data);
filedata = struct;
good_file(1:length(D),1) = 0;
for j = 1:1:length(D)
    if D(j).isdir == 0 && D(j).name(end) ~= '~';
        good_file(j,1) = 1;
    end
end
load_files = find(good_file == 1);
clear good_file
%% Loop through files:
for fn = 1:1:length(load_files)
    disp(['Reading ' dir_data '/' D(load_files(fn)).name]);
    fid = fopen([dir_data '/' D(load_files(fn)).name]);
    filedata(fn).filename = D(load_files(fn)).name;
    
    %%% FIRST PART - Separates first 4 lines from rest
    for j = 1:1:4;
        tline = fgets(fid);
        
        if j == 2   % second line has variable names (others are not used)
            filedata(fn).coms = find(tline == ',');
            filedata(fn).coms = [0 filedata(fn).coms length(tline)+1];
            %%% Extract Names
            for i = 1:1:length(filedata(1,fn).coms)-1
                tmp_varname = tline(filedata(fn).coms(i)+1:filedata(fn).coms(i+1)-1);
                tmp_varname(tmp_varname == '"') = ''; %remove quotation marks.
                filedata(1,fn).varnames{i,1} = cellstr(tmp_varname);
                clear tmp_varname;
            end
            clear tline;
        end
        if j == 3   % Third line has variable units (others are not used)
            filedata(fn).coms2 = find(tline == ',');
            filedata(fn).coms2 = [0 filedata(fn).coms2 length(tline)+1];
            %%% Extract Names
            for i = 1:1:length(filedata(1,fn).coms2)-1
                tmp_units = tline(filedata(fn).coms2(i)+1:filedata(fn).coms2(i+1)-1);
                tmp_units(tmp_units == '"') = ''; %remove quotation marks.
                filedata(1,fn).units{i,1} = cellstr(tmp_units);
                clear tmp_units;
            end
            clear tline;
        end
        if j == 4   % Fourth line has variable record type
            filedata(fn).coms3 = find(tline == ',');
            filedata(fn).coms3 = [0 filedata(fn).coms3 length(tline)+1];
            %%% Extract Names
            for i = 1:1:length(filedata(1,fn).coms3)-1
                tmp_rectype = tline(filedata(fn).coms3(i)+1:filedata(fn).coms3(i+1)-1);
                tmp_rectype(tmp_rectype == '"') = ''; %remove quotation marks.
                filedata(1,fn).rectype{i,1} = cellstr(tmp_rectype);
                clear tmp_rectype;
            end
            clear tline;
        end
        
    end
    
    %%% Change rectype to the same length as coms-1, if it's too short:
    if length(filedata(1,fn).rectype) < length(filedata(fn).coms)-1
        num2add = length(filedata(fn).coms)-1 - length(filedata(1,fn).rectype);
        orig_length = length(filedata(1,fn).rectype);
        for mn = 1:1:num2add
        filedata(1,fn).rectype{orig_length+mn,1}{1,1} = '';    
        end
    end
   %%% Change rectype to the same length as coms-1, if it's too short:
    if length(filedata(1,fn).units) < length(filedata(fn).coms)-1
        num2add = length(filedata(fn).coms)-1 - length(filedata(1,fn).units);
        orig_length = length(filedata(1,fn).units);
        for mn = 1:1:num2add
        filedata(1,fn).units{orig_length+mn,1}{1,1} = '';    
        end
    end    
    
    %%% Create format file for textread to separate data:
    format_string = '%s';
    for k = 2:1:length(filedata(fn).coms)-1
        switch char(filedata(1,fn).rectype{k,1})
            case {'TMx', 'TMn'}
        format_string = [format_string ' %s'];
                    
            otherwise
        format_string = [format_string ' %n'];
        end
    end
    
    
    %% Condition Data:
    %%% Take out all quotation marks, and any strings that we don't want in there
    %%% (e.g. 'Inf', 'INF', 'NAN') -- replace all with 'NaN'
    %%% Weather Station (MCM_WX) data uses "INF" as well as "NaN"
    %%% Get the position of the pointer, in case we have to go back there:
    fid2 = fopen([loadstart 'Matlab/Data/Met/tmp.dat'],'w+');
    %     pntr_start_pos = ftell(fid);
    eofstat2 = 0;
    ctr = 1;
    %             if strcmp(site,'MCM_WX')==1
    while eofstat2 == 0;
        %         disp(ctr);
        %         tmp_ptr_pos_before = ftell(fid);
        tline2 = fgets(fid);
        %         tmp_ptr_pos_after = ftell(fid);
        %         if tmp_ptr_pos_before==tmp_ptr_pos_after
        %             eofstat2 = 1;
        %         else
        %                   tline2 =   '"2008-10-14 09:45:00",11496,288,148.6,"INF",129.8,28.62,Inf,NAN,-29.21,-25.54,-37.32,13.97,14.79,12.88,392.2,435.4,20.43,120,-43.18,0.193,540.8,464,76.83,22.01,19.64,19.68,19.59,19.64,70.87,71.8,69.9,14.2,1.617,2.286,23.13,5.087,227.8,14.27,18.31,227.8,14.27,29.92,238.7,3.81,277.6,100.3,101.7,101.7,101.7,0';
%        if ctr == 662
%        disp('halt')
%        end
        
        tline2(tline2 == '"') = ''; % gets rid of quotation mark
        % Added in -INF to accomodate problems with the weather station
        % data - had to be added to the start, since it contains 'INF',
        % which would get processed first.
        text_to_remove = {'-INF';'INF'; 'Inf'; 'NAN'};
        for m = 1:1:length(text_to_remove)
            tline2 = strrep(tline2,char(text_to_remove(m,1)),'NaN');
        end
        %             fseek(fid,tmp_ptr_pos_before,'bof');
        fprintf(fid2,['%' num2str(length(tline2)) 's'],tline2);
        %             fseek(fid,tmp_ptr_pos_after,'bof');
        %             if ctr > 7520
        %                 disp('hold');
        %             end
        %
        
        clear tline2 tmp_ptr*;
        eofstat2 = feof(fid);
        ctr = ctr+1;
        %         end
    end
    
    %             end
    %%% Puts the pointer back where it was before we started
    %%% conditioning it.
    fseek(fid2,0,'bof');
    eofstat = 0;
    row_ctr = 1;
    clear tmp_data;
    while eofstat == 0;
        %%% Read all data fields using textscan:
        try
            % The CommentStyle command is critical for ignoring "NaN" values in
            % the data file, which MATLAB thinks is a string because of the
            % quotation marks.
            
            tmp_data = textscan(fid2,format_string,200,'Delimiter',',','EmptyValue', NaN,'CommentStyle', {'N', 'N'});
            %%% Timestamp from data:
            rows_to_add = length(tmp_data{1,1});
            timestamp(row_ctr:row_ctr+rows_to_add-1,:) = char(tmp_data{1,1});
            for k = 2:1:length(tmp_data)
                % fixes the case where one column may be shorter than the rest
                % (I don't know why this would happen, but it does).
                if length(tmp_data{1,k}) < rows_to_add
                    tmp_switch = tmp_data{1,k};
                    tmp_switch = [tmp_switch ; NaN.*ones(rows_to_add - length(tmp_data{1,k}))];
                    tmp_data{1,k} = tmp_switch;
                    clear tmp_switch
                end
                
                data(row_ctr:row_ctr+rows_to_add-1,k) = tmp_data{1,k}; % start at column 2 and then add timevec back in later
            end
            row_ctr = row_ctr + rows_to_add;
            clear tmp_data rows_to_add;
            eofstat = feof(fid2);
        catch
            disp(['Error on row ' num2str(row_ctr) ' of file ' filedata(fn).filename ', skipping file.']);
            %             disp(row_ctr);
            %             s = input('error');
            eofstat = 1;
        end
    end
    
    fclose(fid);
    fclose(fid2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% This section was changed on July 13, 2012 by JJB.
    %%% There was a weird bug with Wx station data, where a faulty
    %%% timestamp
    %%% Convert time_stamp into a timevector
% %         input_date(:,1) = JJB_DL2Datenum(str2num(timestamp(:,2:5)), str2num(timestamp(:,7:8)), ...
% %             str2num(timestamp(:,10:11)), str2num(timestamp(:,13:14)), str2num(timestamp(:,16:17)), 00);
    input_date(:,1) = JJB_DL2Datenum(str2num(timestamp(:,1:4)), str2num(timestamp(:,6:7)), ...
        str2num(timestamp(:,9:10)), str2num(timestamp(:,12:13)), str2num(timestamp(:,15:16)), 00);
    
%     input_date2 = NaN.*ones(size(timestamp,1),1);
%     for i = 1:1:length(timestamp)
%        try
%         input_date2(i,1) = datenum(str2num(timestamp(i,1:4)), str2num(timestamp(i,6:7)), ...
%         str2num(timestamp(i,9:10)), str2num(timestamp(i,12:13)), str2num(timestamp(i,15:16)), 00);
%        catch
% %            input_date2(i,1) = NaN;
%        end
%     end
    
% Perform a check here to make sure input_date and timestamp are the same
% number of rows --if not, it might hint at a problem.
if size(timestamp,1) ~= size(input_date,1)
    disp('''timestamp'' and ''input_date'' variables are not the same length in CR1000_metloader.m');
    disp('You will want to go check this out, or alert someone of this problem');
end

    %%%% Round input_date and TV to 5 decimal places - to avoid timevector mismatch
    input_date = (round(input_date.*100000))./100000;
    TV = (round(TV.*100000))./100000;
    
%         input_date = (round(input_date.*100000000))./100000000;
%     TV = (round(TV.*100000000))./100000000;
    
    % %%% Find intersection points between dates in input_data and TV:
    [row_common row_in row_master] = intersect(input_date(:,1), TV);
    
    % A flag to see if the data is daily or not - if it's daily, we'll only
    % look to fill data that is at 1440 mins
    if isempty(strfind(filedata(fn).filename,'Daily'))==1
        daily_flag = 0;
    else
        daily_flag = 1;
        disp(['Note that ' filedata(fn).filename ' is a daily file...']);
        disp('Data from this file will only be used to update variables specified as 1440 minutes in the output template.');
    end
    
    for vars = 1:1:length(filedata(fn).varnames) % cycles through all columns in raw data file
        name_row = find(strcmp(hdr_names(:,1),filedata(fn).varnames{vars})==1); % finds row in namefile where variable name exists
        %         if isempty(name_row)==1;
        %             filedata(fn).varnames(vars,1) = ['"' filedata(fn).varnames(vars,1) '"'];
        %             name_row = find(strcmp(hdr_names(:,1),filedata(fn).varnames{vars})==1); % finds row in namefile where variable name exists
        %         end
        if strcmp(char(hdr_names(name_row,2)),{''})==1 % This fixes a weird bug with TP02 data where empty titles have {''} as an entry
            right_name = [];
        else
            right_name = char(hdr_names(name_row,2)); % converts variable name to its final storage name
        end
        if isempty(right_name)
        else
            
            try
                right_name(right_name =='"') = '';
                right_col = find(strcmp(hdr_cell_tmpt(:,2),right_name)==1);
                timestep = str2double(hdr_cell_tmpt{right_col,3});
                
                if timestep==30 && daily_flag ==1
%                     disp(['Variable ' right_name ' Skipped because it is daily data.']);
                else
                met_master(row_master,right_col) = data(row_in,vars);
                end
                clear right_col timestep
            catch
                disp(['variable ' char(right_name) ' not processed.']);
            end
        end
        clear name_row right_name timestamp input_date;
        
        
    end
    
    
    
    clear names timestamp
    clear data input_date row_common row_in row_master;
end
