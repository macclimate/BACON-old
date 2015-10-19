%% This script takes master CCP final met files and rips them into column
%%% vectors
%%% Created June 18, 2008 by JJB.

ls = addpath_loadstart;
path = [ls 'Matlab/Data/CCP/Final_dat/'];

D = dir(path);

for i = 3:1:length(D)
    
temp = load([path D(i).name]);

site = D(i).name(1:4); yr = D(i).name(12:15);
disp(['Ripping site ' site ', year ' yr '.']);

save_path = [ls 'Matlab/Data/Met/Final_Cleaned/CCP/' site '/' site '_' yr];
jjb_write_columns(temp,save_path)
clear temp site yr;
end
