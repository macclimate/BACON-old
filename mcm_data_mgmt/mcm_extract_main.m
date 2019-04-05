function [] = mcm_extract_main(site, data_type, year)
% 8-Dec-2010 - removed load_path as 3rd argument
if isempty(year)==1
    commandwindow;
    year = input('Only one year at a time permitted.  Enter Year: > ');
end
%% ************************ mcm_extract_main.m ***************************
% This function is designed to help the user take downloaded data and
% extract into the proper folder or master file.
%
% options for data_type: 'met', 'chamber', 'CPEC', 'OPEC', 'sapflow'
% options for site: 'TP39', 'TP74', 'TP89', 'TP02','TP_PPT'
%%% Get the starting directory:
load_path_start = [addpath_loadstart 'DUMP_Data'];
% load_path = uigetdir(load_path_start,'Select data directory.');

switch data_type
    case 'chamber'
        load_path = uigetdir(load_path_start,'Select data directory.  Press OK when you see MET-DATA directory.');
        mcm_extract_cpec([site '_chamber'], load_path);
    case {'met','WX', 'TP_PPT'}
        % load_path = uigetdir([load_path_start '/Met'],'Select data directory, or Press OK if data file is in this directory.');
        load_path = [load_path_start '/Met'];
        mcm_metloader(site,year, load_path);
    case 'CPEC'
        load_path = uigetdir(load_path_start,'Select data directory.  Press OK when you see MET-DATA directory.');
        mcm_extract_cpec(site, load_path);
    case 'OPEC'
        %       mcm_extract_opec
    case {'sapflow','trenched','OTT','NRL', 'PPT'}
        load_path = [load_path_start '/Met'];
        mcm_metloader([site '_' data_type],year, load_path);
%         % load_path = uigetdir([load_path_start '/Met'],'Select data directory, or Press OK if data file is in this directory.');
%         
%         
%     case 'trenched'
%         % load_path = uigetdir([load_path_start '/Met'],'Select data directory, or Press OK if data file is in this directory.');
%         load_path = [load_path_start '/Met'];
%         mcm_metloader([site '_trenched'],year, load_path);
%     case 'OTT'
%         %         load_path = uigetdir([load_path_start '/Met'],'Select data directory, or Press OK if data file is in this directory.');
%         load_path = [load_path_start '/Met'];
%         mcm_metloader([site '_OTT'],year, load_path);
%     case 'NRL'
        
    otherwise
        disp('mcm_extract_main.m: This function not enabled for this type of file')
end




