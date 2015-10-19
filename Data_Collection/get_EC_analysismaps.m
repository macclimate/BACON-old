function [] = get_EC_analysismaps()
% get_EC_analysismaps.m
% This function retrieves Environment Canada surface analysis maps.  To be
% run once daily to collect all maps from a given day.
% Created Jan 27, 2012 by JJB

%%% Set Paths:
ls = addpath_loadstart;
savepath = [ls 'Matlab/Data/wx_kmz/ECmaps/'];
start_URL = 'http://www.weatheroffice.gc.ca/data/analysis/';
logpath = [savepath 'EC_extraction_log.txt'];

files_to_get_NA = {'947_100.gif', '00z'; '951_100.gif', '06z'; ...
    '935_100.gif', '12z'; '941_100.gif', '18z'};

files_to_get_Can = {'jac00_100.gif', '00z'; 'jac06_100.gif', '06z'; ...
    'jac12_100.gif', '12z'; 'jac18_100.gif', '18z'};


%%% Open the log file:
f1 = fopen(logpath,'a');
t_now = datestr(now,1);


%%% Sequentially extract and save the NA SAPL files:
for i = 1:1:size(files_to_get_NA,1)
    fname = ['EC_NA_SAmap_' t_now '_' files_to_get_NA{i,2} '.gif'];
    [filestr, status] = urlwrite([start_URL files_to_get_NA{i,1}],[savepath 'NA/' fname]);
    if status == 1
        fprintf(f1,'%s\n',[files_to_get_NA{i,2} ' saved for ' t_now '.']);
    else
        fprintf(f1,'%s\n',['Error saving ' files_to_get_NA{i,2} 'for ' t_now '.']);
    end
end

%%% Sequentially extract and save the Can SAPL files:
for i = 1:1:size(files_to_get_Can,1)
    fname = ['EC_Can_SAmap_' t_now '_' files_to_get_Can{i,2} '.gif'];
    [filestr, status] = urlwrite([start_URL files_to_get_Can{i,1}],[savepath 'Can/' fname]);
    if status == 1
        fprintf(f1,'%s\n',[files_to_get_Can{i,2} ' saved for ' t_now '.']);
    else
        fprintf(f1,'%s\n',['Error saving ' files_to_get_Can{i,2} 'for ' t_now '.']);
    end
end

