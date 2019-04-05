function [] = OPEC_process_10min(site, load_path)
%%% OPEC_process_10min.m
%%% usage: OPEC_process_10min(site, load_path)
%%% This function runs the OPEC data conditioner (if necessary) and reads
%%% in all raw 10-min OPEC data, making a master file, or loading the
%%% master file and loading into it if one exists.  The function puts the
%%% data in the appropriate column in the master file, and saves the master
%%% file:
%%%

%%%


%%%
ls = addpath_loadstart;
%%% In cases where less than 2 inputs are given:
if nargin == 0
    load_path = uigetdir([ls 'SiteData/'],'Please navigate to directory with conditioned data in it');
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
elseif nargin == 1
    % check if the single entry is a file or directory
    if exist(site,'file')== 2 || exist(site,'dir')==7
        load_path = site; clear site;
        site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
    else
        load_path = uigetdir([ls 'SiteData/'],'Please navigate to directory with conditioned data in it');
    end
end
if isempty(site)==1
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
end
disp(['Loading data from ' load_path]);

% Put a '/' at the end of the path if it's not there already:
if load_path(end) == '/';
else
    load_path = [load_path '/'];
end

% Load the organizing file for OPEC data:
doc_path = [ls 'Matlab/Data/Flux/OPEC/Docs/OPEC_variable_sorter.csv'];
sorter_list = jjb_hdr_read(doc_path, ',');
master_list = sorter_list(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Investigate the /Converted and /Conditioned directories.  If there are
% more files in the /Converted directory, then we'll ask the user if they
% want to run the conditioner

% Find how many files in /Conditioned/
d_cond = dir(load_path);
d_cond_files = length(d_cond)-2;
% Switch to /Converted directory, Find how many files in /Converted/
t = findstr(load_path,'/Conditioned');
conv_path = [load_path(1:t) 'Converted/'];
d_conv = dir(conv_path);
d_conv_files = length(d_conv)-2;

if d_conv_files > d_cond_files
    disp('There are more files in /Converted/ than in /Conditioned/');
    resp_cond = input('Do you want to run the OPEC data conditioner? <y/n>: ','s');
    if resp_cond == 'y'
        OPEC_data_conditioner(conv_path)
        d_cond = dir(load_path);
        disp('OPEC_data_conditioner_completed');
    else
        disp('Data conditioner not run, but you should really think about it, son.');
    end
else
    disp('Data conditioner not run.');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% use 'read_OPEC_10min' to load each file in the directory, then, place
%%% it all into a single master file
data = [];
for i = 3:1:length(d_cond)
    row_tracker = length(data); % this will keep track of what row the new data starts on:
    tmp_output = read_OPEC_10min([load_path d_cond(i).name]);
    if isempty(tmp_output)
    else
        [r c] = size(tmp_output.data);
        data = [data; NaN.*ones(r,length(sorter_list))];
        
        % Put data into proper column, column by column:
        for j = 1:1:length(tmp_output.labels)
            right_col = find_right_col(sorter_list,char(tmp_output.labels{j,1}));
            if isempty(right_col)==1
                disp(['Could not place "' char(tmp_output.labels{j,1}) '" in master file.']);
            else
                data(row_tracker+1:row_tracker+r,right_col) = tmp_output.data(:,j);
            end
        end
    end
    clear tmp_output;
end
disp('Loading has finished - moving on to placement in master file.');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Placing data in master file:
new_flag = 0;
%%% Check if master file exists:
% if exist([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat'],'file')==2;
% load([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat']);
% else
if exist([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat'],'file')==2;
    resp2 = input('<1> Append to Master or <2> Create new master: ');
    if resp2==2
        new_flag =1;
    else
        load([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat']);
        disp('Master file loaded for appending');
    end
end
if new_flag == 1
    disp('Creating new master file.');
    master = struct;
    [r_sorter c_sorter] = size(sorter_list);
    TV = []; Year = []; Month = []; Day = []; Hour = []; Minute = [];
    for i = 2002:1:2014
        TV = [TV; make_tv(i,10)];
        Year = [Year; i.*ones(yr_length(i,10),1)];
        [Mon_tmp Day_tmp] = make_Mon_Day(i,10);
        Month = [Month; Mon_tmp]; Day = [Day; Day_tmp];
        [HH_tmp MM_tmp] = make_HH_MM(i,10);
        Hour = [Hour; HH_tmp]; Minute = [Minute; MM_tmp];
        clear *_tmp
    end
    master.data = NaN.*ones(length(Year),r_sorter);
    master.data(:,1:6) = [TV Year Month Day Hour Minute];
    clear TV Year Month Day Hour Minute;
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Put the loaded data into an organized master file:

TV_master = (round(master.data(:,1).*1e5))./1e5;
TV_data = (round(data(:,1).*1e5))./1e5;

[junk ind_master ind_data] = intersect(TV_master,TV_data);
master.data(ind_master,7:end) = data(ind_data,7:end);

%%% Save the master file to the /Matlab/Data/Flux/OPEC/<site>/Organized/ Folder:
master.labels = master_list;
jjb_check_dirs([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/'],0);
save([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat'],'master');
disp(['Master file saved to ' ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_10min_master.mat']);
end

%% This subfunction simply finds the right column to place a given data
%%% file into:
function [right_col] = find_right_col(sorter,label_in)
[r c] = size(sorter);
right_col = [];
col_ctr = 3;

while isempty(right_col)==1 && col_ctr <= c
    %     for col_ctr = 3:1:c
    right_col = find(strcmp(label_in,sorter(:,col_ctr))==1);
    col_ctr = col_ctr+1;
end

end