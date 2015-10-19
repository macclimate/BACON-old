function [] = mcm_output_wxstn(year)

if ischar(year)==1
    yr_str = year;
else
    yr_str = num2str(year);
end
year = str2double(yr_str);

%%% Paths:
ls = addpath_loadstart;
met_cleaned_path = [ls 'Matlab/Data/Met/Final_Cleaned/MCM_WX/'];

%%% Time data:
[tvec YYYY Mon Day dt hhmm hh mm JD] = jjb_maketimes(year, 15);

%%% Load the master file:
load([met_cleaned_path 'MCM_WX_met_cleaned_2011.mat'])
master.labels = cellstr(master.labels);

%% Writing Data:

%%% Write the column headers