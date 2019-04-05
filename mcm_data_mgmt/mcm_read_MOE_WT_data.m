function [] = mcm_read_MOE_WT_data
%% mcm_read_MOE_WT_data.m
% This function loads Ontario MOE water table data, and organizes it into
% the appropriate time marker and column in a master file. This file is set
% up to process data from the following wells:
% 1) Well 171-2 is located to the East of the intersection of
% Charlotteville West Quarterline Road & St. Johns Rd. West
% 2) Well 169-1 is located South of the intersection of
% Old Hwy 24 & Regional Hwy 59
%
% The master file is saved to
% /1/fielddata/Matlab/Data/MOE_Water_Table/Organized2/WT_Master.mat
% - This file contains data (master.data) and a cell array with variable
% names (master.col_names).
%
% NOTES: Input files must be in .csv format with the following column
% format:
% |Casing ID | Date + Time | Water Level | etc.....
%

% Created May 18, 2010 by JJB
%
% *********REVISION HISTORY:
%
%
%
%
% **************************


%%
% Set paths:
ls = addpath_loadstart;
save_path = [ls 'Matlab/Data/MOE_Water_Table/Organized2/'];
% Set Info:
info.datum_171 = 245.49; % datum height for well 171
info.datum_169 = 230.26; % datum height for well 169
names_to_find = {'CASING_ID';'DATE_TIME';'WATER_LEVEL_CORRECTED_FOR_BP'};
col_names = {'TimeVec';'Year';'Month';'Day';'dt';'HHMM';...
    'Level-171'; 'Level-169'; 'WT_Height-171';'WT_Height-169'};

% Make time vectors for years 2002-2014:
Year = []; HHMM = []; dt = []; mon = []; day = []; TV = [];
for i = 2002:1:2014
    [Year_tmp, junk_tmp, HHMM_tmp, dt_tmp] = jjb_makedate(i, 60);
    [mon_tmp day_tmp] = make_Mon_Day(i, 60);
    [TV_tmp] = make_tv(i,60);
    Year = [Year; Year_tmp];
    %         JD = [JD; JD_tmp];
    HHMM = [HHMM; HHMM_tmp];
    dt = [dt; dt_tmp];
    mon = [mon; mon_tmp];
    day = [day; day_tmp];
    TV = [TV; TV_tmp];
    clear *_tmp;
end

%% Check for the master file -- If it doesn't exist, then make one:
if exist([ls 'Matlab/Data/MOE_Water_Table/Organized2/WT_Master.mat'],'file')==2
    load([ls 'Matlab/Data/MOE_Water_Table/Organized2/WT_Master.mat']);
    disp(['Now loading ' ls 'Matlab/Data/Organized2/MOE_Water_Table/WT_Master.mat']);
    
else
    disp(['Cannot find ' ls 'Matlab/Data/Organized2/MOE_Water_Table/WT_Master.mat.  Creating New Master File.']);
    master = struct;
    master.data = [TV Year mon day dt HHMM NaN.*ones(length(TV),9)]; % makes 15 columns available
    master.col_names = col_names;
end

%% Process input data file:
% Allow the user to select the file to process:
[file_name, dir_name] = uigetfile('*.csv','Select Water Table File',[ls 'Matlab/Data/MOE_Water_Table/']);
pth = [dir_name file_name];

% Load the file
fid = fopen(pth);
continueflag = 0;
eofstat = 0;
% Read the column names:
while continueflag == 0 && eofstat == 0;
    [ptr_pos] = ftell(fid);
    tline = fgets(fid);
    
    tline(tline=='"') = ''; % Remove quotation marks
    if strncmp(tline,'CASING_ID',9)==1
        
        continueflag = 1;
        coms = find(tline == ',');
        % create format string:
        fseek(fid,ptr_pos,'bof');
        format_string = '%s';
        format_string2 = '%s %s';
        for i = 1:1:length(coms)
            format_string = [format_string ' %s'];
            if i > 1
                format_string2 = [format_string2 ' %n'];
            end
        end
        input_cols = textscan(fid, format_string,1,'Delimiter',',');
        input_cols = input_cols';
    end
    eofstat = feof(fid);
end


%% Read the data within the file:
timestamp = [];
site_ID = [];
data = [];
row_ctr = 0;
while eofstat == 0;
    data_to_fill = [];
    try
        if row_ctr == 56600;
            disp('here');
        end
        tmp_data = textscan(fid, format_string2,200,'Delimiter',',','EmptyValue', NaN,'CommentStyle', {'N', 'N'});
        rows_to_add = length(tmp_data{1,1});
        
        timestamp = [timestamp ;char(tmp_data{1,2})];
        tmp_ID = char(tmp_data{1,1});
        site_ID = [site_ID ;str2num(tmp_ID(:,6:8))];clear tmp_ID;
        
        for k = 3:1:length(coms)+1
            % fixes the case where one column may be shorter than the rest
            % (I don't know why this would happen, but it does).
            if length(tmp_data{1,k}) < rows_to_add
                tmp_switch = tmp_data{1,k};
                tmp_switch = [tmp_switch ; NaN.*ones(rows_to_add - length(tmp_data{1,k}))];
                tmp_data{1,k} = tmp_switch;
                clear tmp_switch
            end
            
            data_to_fill = [data_to_fill tmp_data{1,k}]; % start at column 2 and then add timevec back in later
        end
        eofstat = feof(fid);
        row_ctr = row_ctr + rows_to_add;
        data = [data; data_to_fill];
        clear data_to_fill;
        clear tmp_data rows_to_add;
        
    catch
        eofstat = feof(fid);
        if eofstat == 1;
        else
            disp(row_ctr);
            s = input('error');
        end
        %         endeofstat = feof(fid);
    end
    
end

%%% Convert the timestamp into a timevector:
ts_YYYY = str2num(timestamp(:,1:4));
ts_MM = str2num(timestamp(:,6:7));
ts_DD = str2num(timestamp(:,9:10));
ts_HH = str2num(timestamp(:,12:13));
input_date(:,1) = JJB_DL2Datenum(ts_YYYY, ts_MM, ts_DD, ts_HH, 00, 00);

%% Match up the times from input with the master -- put all the data in
%%% the right place:

%%% Round input_date and TV to 5 decimal places - to avoid timevector mismatch
input_date = (round(input_date.*100000))./100000;
TV = (round(TV.*100000))./100000;
% Find common rows for TV and recorded times:
[row_common row_in row_master] = intersect(input_date(:,1), TV);
% Find whether its for well 171 or 169
rows_171 = find(site_ID(row_in) == 171);
rows_169 = find(site_ID(row_in) == 169);
% Find the columns each data is supposed to go into
col_171_Level = find(strcmp(col_names,'Level-171')==1);
col_169_Level = find(strcmp(col_names,'Level-169')==1);
col_171_Height = find(strcmp(col_names,'WT_Height-171')==1);
col_169_Height = find(strcmp(col_names,'WT_Height-169')==1);
% Paste the level data into the appropriate column in master.data file
master.data(row_master(rows_171),col_171_Level) = data(row_in(rows_171),1);
master.data(row_master(rows_169),col_169_Level) = data(row_in(rows_169),1);
% Calculate Height from Datum Level:
master.data(:,col_171_Height) = master.data(:,col_171_Level) - info.datum_171;
master.data(:,col_169_Height) = master.data(:,col_169_Level) - info.datum_169;

%% Save the data file:
save([save_path 'WT_Master.mat'],'master');
disp('Organized file saved!')
