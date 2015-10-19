function [] = add_remove_biomet(flag)
%%% What this function does:
% if flag = 1 then the biomet.net toolbox is added to the matlab path
% if flag = 0 then the biomet.net toolbox is removed from the matlab path

ls = addpath_loadstart;

if ispc == 1;
    % Enter lines in here to tell the program what to do if it's running on
    % a windows-based system...
else
    start_path = [ls 'Matlab/'];
end

if nargin == 0
    flag = 0;
end

switch flag
    case 0 % Remove biomet.net folders
        rmpath(genpath ([start_path 'biomet.net/Matlab/']));
        path
        disp('biomet.net toolbox removed from Matlab path');
        
    case 1 % Add biomet.net folders
        addpath(genpath ([start_path 'biomet.net/Matlab/']));
        path
        disp('biomet.net toolbox added to Matlab path');
    otherwise
        disp('input needs to be either 0 or 1. Nothing happened.');
        
end