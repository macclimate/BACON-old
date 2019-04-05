%% Gives soil pit data to Sam:
clear all;

loadstart = addpath_loadstart;

[Year, JD, HHMM, dt] = jjb_makedate(2009, 30);

load_dir = [loadstart 'Matlab/Data/Met/Cleaned3/TP39/TP39_2009.'];

cols_to_load = [ (81:82)' ; (87:1:108)'];
right_exts = create_label(cols_to_load,3);

for j = 1:1:length(cols_to_load)
    
    met_vars(:,j) = eval(['load(''' load_dir right_exts(j,:) ''')']);
    
end
For_Sam = [Year JD HHMM dt met_vars];

% fid = fopen([loadstart 'Matlab/Data/Distributed/Sam_TP39_Soil_' date
% '.dat']);

% format_code = '%4.0f\t %3.0f\t %2.0f\t %7.4f\t %4.0f\t %4.2f\t %3.1f\t
% %4.1f\t %5.1f\t %4.2f\t\n';

save([loadstart 'Matlab/Data/Distributed/Sam_TP39_Soil_' date '.dat'], 'For_Sam','-ASCII');
