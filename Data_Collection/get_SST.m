function [] = get_SST()
% get_SST.m
%%% This function downloads GOES satellite imagery kmls files from noaa, 
%
%
% Created Nov 13, 2011 by JJB

%%% Set Paths:
ls = addpath_loadstart;
savepath = [ls 'Matlab/Data/wx_kmz/SST/'];
start_URL = 'http://modata.ceoe.udel.edu/dev/mcimino/MODIS/GSFC/Regions/World/8_day/';
logpath = [savepath 'SST_extraction_log.txt'];

%%% Open the log file:
f1 = fopen(logpath,'a');

%%% Variables that we will be saving:
files_to_get = {'current.png','8-day'};
%%% Get the time stamp into the format we want:
t_now = datestr(now+4/24,30);
t_now = t_now(1:end-2);
t_now = strrep(t_now,'T','-');

%%% Sequentially extract and save the kml files:
for i = 1:1:size(files_to_get,1)
    fname = ['SST-' files_to_get{i,2} '_' t_now '.png'];
    [filestr, status] = urlwrite([start_URL files_to_get{i,1}],[savepath fname]);
    if status == 1
        fprintf(f1,'%s\n',[files_to_get{i,2} ' saved for ' t_now '.']);
    else
        fprintf(f1,'%s\n',['Error saving ' files_to_get{i,2} 'for ' t_now '.']);
    end
end


%%% Close the log file:
fclose(f1);
%%% Exit MATLAB
exit;
