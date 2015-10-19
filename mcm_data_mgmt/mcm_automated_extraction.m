function [] = mcm_automated_extraction(exit_override)
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
                'TP39','chamber';...
                 'TPD','CPEC'};
log_filenames = {};
checkfiles = {};
year_to_check = str2num(datestr(now-30,'yyyy'));
for i = 1:1:size(to_process,1)
    disp(['Working on site: ' to_process{i,1}])
    log_filenames{1,length(log_filenames)+1} = mcm_auto_extractor(to_process{i,1},to_process{i,2});

tmp_checkfiles = mcm_checkfiles(to_process{i,1}, year_to_check, to_process{i,2},0);
checkfiles{1,length(checkfiles)+1} = tmp_checkfiles{1,1};
checkfiles{1,length(checkfiles)+1} = tmp_checkfiles{1,2};
clear tmp_checkfiles;
end

%%% This command will be run automatically once a week:
% matlab -r mcm_weekly_extraction -nodesktop -nosplash
disp('Extraction finished.  Now trying to send logfiles.');
%%% Email the group the log files:
try
% recips = {'arainm@mcmaster.ca', 'thornerf@mcmaster.ca','chanfc@mcmaster.ca', 'skubelra@mcmaster.ca',...
%         'jason.brodeur@gmail.com','mac.climate@gmail.com'};
subject = 'Data Extraction Logs';
message = ['Please Find attached the log files from the latest extraction of CPEC and chamber data.' ...
    'Please Check these logs for processing errors, and be sure to burn off the processed data.' ...
    'Also attached are the updated check lists for data files.'];
attach = [log_filenames checkfiles];

sendmail(recips,subject,message,attach)
catch
    disp('Something went wrong trying to execute sendmail.');
end

if exit_override == 0
exit;
end