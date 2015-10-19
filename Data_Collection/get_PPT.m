function [] = get_PPT()
% get_PPT.m
%%% This function downloads precipitation data from noaa.
%
%
% Created Nov 13, 2011 by JJB

%%% Set Paths:
ls = addpath_loadstart;
savepath = [ls 'Matlab/Data/wx_kmz/PPT/'];
start_URL = 'http://www.srh.noaa.gov/gis/kml/cocorahs/';
logpath = [savepath 'PPT_extraction_log.txt'];

%%% Open the log file:
f1 = fopen(logpath,'a');

%%% Variables that we will be saving:
vars_to_save = {'cocorahsPrecip', 'PPT'};

%%% Get the time stamp into the (UTC) format we want:
t_now = datestr(now+4/24,30);
t_now = t_now(1:end-2);
t_now = strrep(t_now,'T','-');

% Saves the data only every 6 hours:
hr = str2double(t_now(end-3:end));
hr_round = floor(hr/100).*100;

switch hr_round
    case {0,600,1200,1800}
        
        %%% Sequentially extract and save the kmz files:
        for i = 1:1:size(vars_to_save,1)
            fname = [vars_to_save{i,2} '_' t_now '.kmz'];
            [filestr, status] = urlwrite([start_URL vars_to_save{i,1} '.kmz'],[savepath fname]);
            if status == 1
                fprintf(f1,'%s\n',[vars_to_save{i,2} ' saved for ' t_now '.']);
            else
                fprintf(f1,'%s\n',['Error saving ' vars_to_save{i,2} 'for ' t_now '.']);
            end
        end
        
        %%% Close the log file:
        fclose(f1);
        
    otherwise
end

%%% Exit MATLAB
exit;
