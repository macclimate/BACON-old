function [] = mcm_automated_gdrivemasterbackup()
% This function archives the master data files shared on Google Drive in
% /1/fielddata/GDrive/....'
% This is to be run on an automated basis (monthly?)


%Timestamp:
tstamp = (datestr(now-30,'yyyymmdd'));

%%% Set Paths:
ls = addpath_loadstart;
source_dir = [ls 'GDrive/Site_Data/Master_Files/Most_Recent_Data/'];
target_dir = [ls 'GDrive/Site_Data/Master_Files/Previous_Collections/master_files_' tstamp '/'];

%%% If targer dir exists, remove it and recreate empty one:
if exist(target_dir,'dir')==7
    unix(['rm -R ' target_dir])
end
mkdir(target_dir)


% Get inventory of source directory
d = dir(source_dir);

% Go through source directory, copy all files over to the target
for i = 1:1:length(d)
    if d(i).isdir == 0
   unix(['cp ' source_dir d(i).name ' ' target_dir d(i).name]);
    end
end
    
% Zip the target directory and then remove it:
cd([ls 'GDrive/Site_Data/Master_Files/Previous_Collections/']);
if exist([ls 'GDrive/Site_Data/Master_Files/Previous_Collections/master_files_' tstamp '.zip'],'file')==2
    unix(['rm ' ls 'GDrive/Site_Data/Master_Files/Previous_Collections/master_files_' tstamp '.zip'])
end
s2 = unix(['zip -r -q ' 'master_files_' tstamp '.zip ' 'master_files_' tstamp ]);

if s2 == 0
    disp(['Files zipped successfully.']);
else
    disp(['Files not zipped successfully.']);
end

% Delete the original directory:
unix(['rm -R ' target_dir])
exit;
end