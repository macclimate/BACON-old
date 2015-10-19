function [] = mcm_automated_clean_plot(exit_override)
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
    'TPD','CPEC';...
    };


ls = addpath_loadstart;
log_path = [ls 'Documentation/Logs/mcm_automated_clean_plot/'];


%% Create a log file:
fid = fopen([log_path 'auto_clean_plot_log_' datestr(now,29) '.txt'],'a');

%% Set the start and end dates
year = str2num(datestr(now,10));

for i = 1:1:size(to_process,1)
    try
        mcm_metclean(year,to_process{i,1},'met',1);
    catch e_met   
    msgString = getReport(e_met);
    fprintf(fid,'%s\n',['Error calculating for: ' to_process{i,1} ', met data.']);
    fprintf(fid,'%s\n','Error report below: ');
    fprintf(fid,'%s\n',msgString);
    clear msgString;    
    end
    
    try
        mcm_fluxclean(year,to_process{i,1},1);
    catch e_flux
    msgString = getReport(e_flux);
    fprintf(fid,'%s\n',['Error calculating for: ' to_process{i,1} ', flux data.']);
    fprintf(fid,'%s\n','Error report below: ');
    fprintf(fid,'%s\n',msgString);
    clear msgString;    
    end   
end

%% Email the group the log files:
try
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
