function [] = run_mcm_footprint_backup(site) %, year_start, year_end)
%%% run_mcm_footprint.m
%%% usage: [] = run_mcm_footprint(site)
%%% This function is the top footprint calculation function.  It executes
%%% the main footprint program (mcm_footprint.m), with pre-set input
%%% parameters -- these can be modified as necessary.
%%% Created: June, 2010 by JJB.
% 
%
% Revision History:
% 
% Aug 3, 2010, JJB 
%  - Commented function.  Changed year end to 2014 (from
% 2012), so it better matches the setup of rest of the files.
%  - Added a line to display the Ustar threshold used.


% Set Starting parameters
year_start = 2002;
year_end = 2014;
disp(['site = ' site]);
% Set default ustar threshold
switch site
    case 'TP39'
        Ustar_th = 0.35;
    case 'TP74'
        Ustar_th = 0.25;
    case 'TP89'
        Ustar_th = 0.3;
    case 'TP02'
        Ustar_th = 0.15;
end
% Give the user option to change from the default value:
disp('Must set u_{*} threshold.');
resp = input(['Press <enter> to use default (' num2str(Ustar_th) '), or <1> to enter new threshold: ']);
if ~isempty(resp)
    Ustar_th = input('Enter New u_{*} threshold: ');
end
% Set up cumulative flux source distance acceptance thresholds (e.g. the
% proportion of measured flux that must come from within the footprint in
% order for a given measurement to be deemed acceptable for use.
XCrit_list = [0.6 0.7 0.8];

% Set Footprint Types:
fptypes = {'Schuepp';'Hsieh'};

%%% Set Paths:
ls = addpath_loadstart;
fig_path = [ls 'Matlab/Figs/Footprint/'];
path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%% Load the data file, trim off unnecessary years:
load([path site '_gapfill_data_in.mat']);
data = trim_data_files(data,year_start, year_end);

%% Run the footprint program... 
%%% For each input year, footprint model, and XCrit value:
year_list = [];
for year = year_start:1:year_end
year_list = [year_list; year.*ones(yr_length(year),1)];
end
for XCrit_ctr = 1:1:length(XCrit_list)
    XCrit = XCrit_list(XCrit_ctr);
for fp_ctr = 1:1:2
    disp(['Now running ' char(fptypes(fp_ctr,1)) ' for XCrit = ' num2str(XCrit_list(XCrit_ctr)) '.']);
    [flag_file, max_fetch, Xpct_all] = ...
        mcm_footprint(data, site, year_start, year_end, fptypes{fp_ctr,1}, XCrit, Ustar_th,'off');
    eval(['footprint_flag.' fptypes{fp_ctr,1} num2str(XCrit.*100) ' =[year_list flag_file];']);
%     disp(['footprint_flag.' fptypes{fp_ctr,1} num2str(XCrit.*100) '
%     =[year_list flag_file];']);
    clear flag_file max_fetch Xpct_all 
end
    clear XCrit;
end

%%% Save the Output Data:
save([save_path site '_footprint_flag.mat'],'footprint_flag');
disp(['footprint flag file saved as: ' save_path site '_footprint_flag.mat']);