function [] = OPEC_process_EdiRe(site, load_path)
%%% OPEC_process_EdiRe.m
%%% usage: OPEC_process_EdiRe(site, load_path)
%%% This function runs the OPEC data conditioner (if necessary) and reads
%%% in all raw EdiRe OPEC data, making a master file, or loading the
%%% master file and loading into it if one exists.  The function puts the
%%% data in the appropriate column in the master file, and saves the master
%%% file:
%%%
close all;
%%%
ls = addpath_loadstart;
%%% In cases where less than 2 inputs are given:
if nargin == 0
    [filename pathname] = uigetfile([ls 'EdiRe/OPEC_Calculations/' site '/*.*'],'Please navigate to directory with conditioned data in it');
    load_path = [pathname filename];
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
elseif nargin == 1
    % check if the single entry is a file or directory
    if exist(site,'file')== 2 || exist(site,'dir')==7
        load_path = site; clear site;
        site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
    else
        [filename pathname] = uigetfile([ls 'EdiRe/OPEC_Calculations/' site '/*.*'],'Please navigate to directory with conditioned data in it');
        load_path = [pathname filename];
    end
end
if isempty(site)==1
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
end
disp(['Loading file: ' load_path]);


% Load the organizing file for OPEC data:
doc_path = [ls 'Matlab/Data/Flux/OPEC/Docs/OPEC_EdiRe_variable_sorter.csv'];
sorter_list = jjb_hdr_read(doc_path, ',');
master_list = sorter_list(:,2);

%%% Check if file master exists.  If so, load it:
if exist([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_EdiRe_master.mat'],'file')==2;
    load([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_EdiRe_master.mat']);
    disp('Master file loaded for appending');
else
    disp('Creating new master file.');
    master = struct;
    [r_sorter c_sorter] = size(sorter_list);
    TV = []; Year = []; Month = []; Day = []; Hour = []; Minute = [];
    for i = 2002:1:2014
        TV = [TV; make_tv(i,30)];
        Year = [Year; i.*ones(yr_length(i,30),1)];
        [Mon_tmp Day_tmp] = make_Mon_Day(i,30);
        Month = [Month; Mon_tmp]; Day = [Day; Day_tmp];
        [HH_tmp MM_tmp] = make_HH_MM(i,30);
        Hour = [Hour; HH_tmp]; Minute = [Minute; MM_tmp];
        clear *_tmp
    end
    master.data = NaN.*ones(length(Year),r_sorter);
    master.data(:,1:6) = [TV Year Month Day Hour Minute];
    clear TV Year Month Day Hour Minute;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% use 'read_OPEC_EdiRe' to load the file, then, place it into a single
%%% master file

%%% Task 1: read the file, get the output, and then make sure the output is
%%% structured with columns corresponding to the master file:
data = [];

tmp_output = read_OPEC_EdiRe(load_path);

if isempty(tmp_output)
else
    [r c] = size(tmp_output.data);
    data = [data; NaN.*ones(r,length(sorter_list))];   
     for j = 1:1:length(tmp_output.labels)
%          if j == 49
%         disp('here');
%         end 
        right_col = find_right_col(sorter_list,char(tmp_output.labels{j,1}));
       
        
        if isempty(right_col)==1
            disp(['Could not place "' char(tmp_output.labels{j,1}) '" in master file.']);
        else
            data(:,right_col) = tmp_output.data(:,j);
        end
    end  
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
save([ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_EdiRe_master.mat'],'master');
disp(['Master file saved to ' ls 'Matlab/Data/Flux/OPEC/' site '/Organized/' site '_OPEC_EdiRe_master.mat']);

% 
% 
% if isempty(tmp_output)
% else
%     [r c] = size(tmp_output.data);
%     data = [data; NaN.*ones(r,length(sorter_list))];
%     
%     % Put data into proper column, column by column:
%     for j = 1:1:length(tmp_output.labels)
%         right_col = find_right_col(sorter_list,char(tmp_output.labels{j,1}));
%         if isempty(right_col)==1
%             disp(['Could not place "' char(tmp_output.labels{j,1}) '" in master file.']);
%         else
%             data(row_tracker+1:row_tracker+r,right_col) = tmp_output.data(:,j);
%         end
%     end
% end

figure('Name','Existing and Used Data');clf;
plot(TV_data)
hold on;
plot(ind_data,TV_data(ind_data),'r.')
legend('Existing Data','Used')
ylabel('TimeVec value');
end
%% This subfunction simply finds the right column to place a given data
%%% file into:
function [right_col] = find_right_col(sorter,label_in)
[r c] = size(sorter);
right_col = [];
col_ctr = 2;

while isempty(right_col)==1 && col_ctr <= c
    %     for col_ctr = 3:1:c

    right_col = find(strcmp(label_in,sorter(:,col_ctr))==1);
    col_ctr = col_ctr+1;
end

end