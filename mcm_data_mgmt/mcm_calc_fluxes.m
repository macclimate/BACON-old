function mcm_calc_fluxes(site, data_type,dates, auto_flag)
% mcm_calc_fluxes.m
% This script allows the user to calculate fluxes (whether CPEC, OPEC or
% chamber data), from raw data files (in /SiteData/data/).  It collects the
% necessary information about site, and type of data, and then runs the 
% appropriate program to calculate fluxes.
%
% This script is most easily used within mcm_start_mgmt GUI.
%
% Created 16 May, 2009 by JJB.
% Revision History
% 15-Jan-2010 by JJB - Modified to include only linux paths, in order to
% make function useable on new system.
% 15-Jul-2010 by JJB - Modified to make sure it adds the /PC_Specific/
% directory to the path (although I don't think this does a whole lot.....)
%
% 6-Jul-2011 by JJB: Added an input argument "dates".  This variable is
% optional and is a cell array that holds the starting and ending dates for
% processing:
% e.g dates = {'2010,09,01','2010,10,01'} would process between Sep 1 and
% Oct 1

if nargin == 2
    dates = {};
    auto_flag = 0;
elseif nargin == 3
    auto_flag = 0;
end

if strcmp('chamber',data_type) == 1
    site = [site '_chamber'];
end

%% Navigate to the proper directory:
ls = addpath_loadstart;

% if ispc == 1;
    % Enter lines in here to tell the program what to do if it's running on
    % a windows-based system...
% else
    start_path = [ls 'Matlab/'];
    data_path = [ls 'SiteData/' site '/MET-DATA/'];
% end

% Check to see if /hhour folder exists.  If not, make it:
jjb_check_dirs([data_path 'hhour/'],auto_flag);


%%% Get Starting and ending dates for calculation:
if isempty(dates)
commandwindow;
start_date = input('Enter Starting Date for Calculations: (e.g. <YYYY,MM,DD>): ','s');
end_date = input('Enter Ending Date for Calculations: (e.g. <YYYY,MM,DD>): ','s');
else
    if size(dates,1) == 1
   start_date = dates{1,1};
   end_date = dates{1,2};
    else
   start_date = dates{1,1};
   end_date = dates{2,1};        
    end
end
biomet_path = [start_path 'BIOMET.NET/MATLAB/'];
%%% Try to add the PC_Specific/ directory to the path:
addpath([biomet_path 'SoilChambers/']);
addpath([biomet_path 'BOREAS/']);
addpath([biomet_path 'BIOMET/']);
addpath([biomet_path 'NEW_MET/']);
addpath([biomet_path 'MET/']);
addpath([biomet_path 'New_eddy/']);
addpath([biomet_path 'SystemComparison/']);
try addpath([start_path 'ubc_PC_setup/Site_Specific/' site '/']); catch; disp('Can''t add ubc_PC_setup/Site_Specific/ directory to path');end
try addpath([start_path 'ubc_PC_setup/PC_Specific/' site '/']);catch; disp('Can''t add ubc_PC_setup/PC_Specific/ directory to path'); end

%%% Change the current path to the data directory:
eval(['cd ' start_path 'ubc_PC_setup/Site_Specific/' site '/']) 

switch data_type
    case 'chamber'
        eval([ 'ACS_calc_and_save(datenum(' start_date '):datenum(' end_date '),16,''' data_path ''',1,0);']);
        disp(['Results can be found in ' ls 'SiteData/' site '/MET-DATA/hhour/']);
    case 'CPEC'
        eval(['new_calc_and_save(datenum(' start_date '):datenum(' end_date '))']);
        disp(['Results can be found in ' ls 'SiteData/' site '/MET-DATA/hhour/']);
    case 'OPEC'
        disp('Program is not set up for processing OPEC data yet.');
    otherwise
        disp('Program does not support processing that type of data');
end

%%% Remove Biomet paths:
rmpath ([biomet_path 'SoilChambers/']);
rmpath ([biomet_path 'BOREAS/']);
rmpath ([biomet_path 'BIOMET/']);
rmpath ([biomet_path 'NEW_MET/']);
rmpath ([biomet_path 'MET/']);
rmpath ([biomet_path 'New_eddy/']);
rmpath ([biomet_path 'SystemComparison/']);
try rmpath([start_path 'ubc_PC_setup/Site_Specific/' site '/']);catch; end
try rmpath([start_path 'ubc_PC_setup/PC_Specific/' site '/']);catch; end