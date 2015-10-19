function [status] = jjb_check_dirs(path_to_files, auto_flag)
%%% jjb_check_dirs.m
%%% usage: [status] = jjb_check_dirs(path_to_files)
%%%
%%% This function checks to ensure that each directory in path_to_dir
%%% exists.  If it doesn't exist, it prompts the user to allow it to make
%%% the folder.
%%% If auto_flag is set to 1, it will automatically make the
%%% directories without prompting.
%%% The program will output 1 if the directory has been created.
%%% Created by JJB.  Nov 5, 2010.

%%% status 
%%% Testing Material %%%%%%%%%%%%%%%%%%%%%%%%%%%
% path_to_files = '/home/brodeujj/1/fielddata/Matlab/Figs/Gapfilling/MDS_JJB1/TP39/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1 || isempty(auto_flag)
    auto_flag = 0;
end
status = 0;
%% Main Program:
%%% Add slashes to front and back if they don't exist
if strcmp(path_to_files(1),'/')~=1
    path_to_files = ['/' path_to_files];
end
if strcmp(path_to_files(end),'/')~=1
    path_to_files = [path_to_files '/' ];
end

%%% Find slashes in path:
slash = find(path_to_files== '/');
folder_name = '/';
%%% Loop through the directories:
for i = 1:1:length(slash)-1
    folder_name = [folder_name path_to_files(slash(i)+1:slash(i+1))];
    %%% Find if the folder exists:
    if exist(folder_name, 'dir')~=7
        disp(['Folder ' folder_name ' does not exist.'])
        if auto_flag == 1
            disp('Automatically creating folder (auto_flag set to 1).');
            %%% Make the directory:
            unix(['mkdir ' folder_name]);
            status = 1;
        else
            resp = input('Press enter to make this directory. Enter any other key to skip > ','s');
            if isempty(resp)==1
                %%% Make the directory:
                unix(['mkdir ' folder_name]);
                status = 1;
            else
                disp(['Directory ' folder_name ' not created.']);
            end
        end
        
    end
end
end