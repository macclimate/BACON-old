function[] = mcm_start

if ispc == 1
    loadstart = '';
else
    loadstart = '/1/fielddata/';
end

% assignin('base', 'loadstart', loadstart)

addpath (genpath([loadstart 'Matlab/Scripts/']));
addpath (genpath([loadstart 'Matlab/biomet.net/']));

path
datestr(now)
cd ([loadstart 'Matlab/Scripts'])
addpath_loadstart;
mcm_start_mgmt