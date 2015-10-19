function [] = jjb_check_dirs(path_to_files, auto_flag)
%%% jjb_check_dirs.m
%%% usage: jjb_check_dirs(path_to_files)
%%%
%%% This function checks to ensure that each directory in path_to_dir
%%% exists.  If it doesn't exist, it makes that folder
%%% Created by JJB.  Nov 5, 2010.
%%% Updated May 17, 2012 by JJB - Now fully windows compatible.

%%% Testing Material %%%%%%%%%%%%%%%%%%%%%%%%%%%
% path_to_files = '/home/brodeujj/1/fielddata/Matlab/Figs/Gapfilling/MDS_JJB1/TP39/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1 || isempty(auto_flag)
    auto_flag = 0;
end
%% Main Program:
%%% Add slashes to front and back if they don't exist
if strcmp(path_to_files(1),'/')~=1 || strcmp(path_to_files(1),'\')~=1
    if ispc==1
    else
    path_to_files = ['/' path_to_files];
    end
else
    if ispc==1
      path_to_files = path_to_files(2:end); 
    end
end
if strcmp(path_to_files(end),'/')~=1 && strcmp(path_to_files(end),'\')~=1
    path_to_files = [path_to_files '/' ];
end

%%% Replace windows slashes with universal ones:
path_to_files = strrep(path_to_files,'\','/');

%%% Find slashes in path:
slash = find(path_to_files== '/');
if ispc == 1
    folder_name = path_to_files(1:3);
else
folder_name = '/';
end
%%% Loop through the directories:
for i = 1:1:length(slash)-1
    folder_name = [folder_name path_to_files(slash(i)+1:slash(i+1))];
    %%% Find if the folder exists:
    if exist(folder_name, 'dir')~=7
        disp(['Folder ' folder_name ' does not exist.'])
        if auto_flag == 1
            disp('Automatically creating folder (auto_flag set to 1).');
            %%% Make the directory:
            if ispc ==1
                dos(['mkdir ' folder_name]);
            else
                unix(['mkdir ' folder_name]);
            end
        else
            resp = input('Press enter to make this directory. Enter any other key to skip > ','s');
            if isempty(resp)==1
                %%% Make the directory:
                if ispc ==1
                    folder_name = strrep(folder_name,'/','\');
                    dos(['mkdir ' folder_name(1:end-1)]);
                else
                    unix(['mkdir ' folder_name]);
                end
            else
                disp(['Directory ' folder_name ' not created.']);
            end
        end
        
    end
end
end