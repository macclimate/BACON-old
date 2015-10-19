function [] = mcm_automated_calc_fluxes(exit_override)
if nargin == 0
    exit_override = 0;
else
    if isempty(exit_override)==1; exit_override = 0; end
end

%%% Get recipient email list:
[tmp] = mcm_mgmt_ini;
recips = tmp.recips;

to_process =    {'TP39','CPEC'; ...
    'TP74','CPEC'; ...
    'TP02','CPEC'; ...
    'TP39','chamber'; ...
    'TPD','CPEC';...
    };
ls = addpath_loadstart;
log_path = [ls 'Documentation/Logs/mcm_automated_calc_fluxes/'];
%% Check to find the last time this program was run:
if exist([log_path 'calc_tracker.mat'],'file')==2
    load([log_path 'calc_tracker.mat']);
else
    calc_tracker = [];
end

if isempty(calc_tracker)==1
    days_back = 90;
    disp('file <calc_tracker> not found. Going back 90 days in calculations.');
else
    try
        last_run = calc_tracker(end,:);
        et = etime(clock,last_run);
        days_back = ceil(et./(60*60*24))+2;
        days_back = days_back + 45;
    catch
        days_back = 45;
        disp('something went wrong calculating <days_back>.  Using 45 as default.');
        
    end
end

if days_back <=0 || isnan(days_back)
    days_back = 45;
    disp('Variable <days_back> was set wrong - using 45 as default');
end

% Create a log file:
fid = fopen([log_path 'auto_calculation_log_' datestr(now,29) '.txt'],'a');



%% Set the start and end dates
date_start =  datestr(floor(now) - days_back,'yyyy,mm,dd');
date_end = datestr(floor(now), 'yyyy,mm,dd');
dates = {date_start; date_end};

for i = 1:1:size(to_process,1)
    try
    mcm_calc_fluxes(to_process{i,1},to_process{i,2},dates,1);
    fprintf(fid,'%s\n',['Calculation completed for: ' to_process{i,1} ', ' to_process{i,2} '. Dates: ' date_start ' to ' date_end '.']);
    catch e_calc
    msgString = getReport(e_calc);
    fprintf(fid,'%s\n',['Error calculating for: ' to_process{i,1} ', ' to_process{i,2} '. Dates: ' date_start ' to ' date_end '.']);
    fprintf(fid,'%s\n','Error report below: ');
    fprintf(fid,'%s\n',msgString);
    clear msgString;
    end
    
end

%% Save the latest run date to calc_tracker
calc_tracker(end+1,:) = clock;
save([log_path 'calc_tracker.mat'],'calc_tracker');

%% Convert the .mat hhour files into an annual timeseries:
try
    for i = 1:1:size(to_process,1)
        disp(['Converting .mat to annual timeseries for site: ' to_process{i,1}]);
        switch to_process{i,2}
            case 'CPEC'
                mcm_CPEC_mat2annual(date_end(1:4),to_process{i,1},1);
            case 'chamber'
                mcm_chamber_mat2annual(date_end(1:4),[to_process{i,1} '_chamber'],-1);
        end
        fprintf(fid,'%s\n',['Annual timeseries made for: ' to_process{i,1} ', ' to_process{i,2} '.']);
        
    end
catch
    disp(['Error converting for ' to_process{i,1} ' ' to_process{i,2} '. Exiting.']);
    fprintf(fid,'%s\n',['Error creating timeseries for: ' to_process{i,1} ', ' to_process{i,2} '.']);
end

fclose(fid);

%%% Email the group the log files:
try
%     recips = {'arainm@mcmaster.ca', 'thornerf@mcmaster.ca','chanfc@mcmaster.ca', 'skubelra@mcmaster.ca',...
%         'jason.brodeur@gmail.com','mac.climate@gmail.com'};
    subject = 'Data Calculation Logs';
    message = ['Please Find attached the log files from the latest calculation of CPEC and chamber fluxes.' ...
        'Please Check these logs for processing errors.'];
    attach = {[log_path 'auto_calculation_log_' datestr(now,29) '.txt']};
    sendmail(recips,subject,message,attach)
catch
    disp('Something went wrong trying to execute sendmail.');
end

if exit_override == 0
exit;
end
%%% This command will be run automatically once a month:
% matlab -r mcm_monthly_calc_fluxes -nodesktop -nosplash
