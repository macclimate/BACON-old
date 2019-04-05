function [] = mcm_documentation_compiler(exit_override)

if nargin == 0
    exit_override = 0;
else
    if isempty(exit_override)==1; exit_override = 0; end
end

ls = addpath_loadstart;
cd ([ls 'Matlab/']);

save_path = [ls 'Documentation/BACON_Documentation_Archive/'];
log_path = [ls 'Documentation/Logs/mcm_documentation_compiler/'];
dstr = datestr(now, 30);
dstr = dstr(1:8);
diary([log_path 'Compiling_Log_' dstr '.txt']);
%%% List of all locations where BACON documentation exists, and label to be
%%% associated with it.
%%% Append more diretories to the end as needed:
% doc_locns = {[ls 'Matlab/Scripts'], 'Scripts'; ...
%             [ls 'Matlab/Data/Met/Docs'], 'Met-Docs'; ...
%             [ls 'Matlab/Data/Met/Raw1/Docs'], 'Met-Raw1-Docs'; ...
%             [ls 'Matlab/Data/Met/Cleaned3/Docs'], 'Met-Cleaned3-Docs'; ...
%             [ls 'Matlab/Data/Met/Final_Cleaned/Docs'], 'Met-Final-Cleaned-Docs'; ...
%             [ls 'Matlab/Data/Met/Final_Filled/Docs'], 'Met-Final-Filled-Docs'; ...
%             [ls 'Matlab/Data/Flux/CPEC/Docs'], 'CPEC-Docs'; ...
%             [ls 'Matlab/Data/Flux/Gapfilling_Docs'], 'Gapfilling-Docs'; ...
%             [ls 'Matlab/Data/Flux/OPEC/Docs'], 'OPEC-Docs'; ...
%             [ls 'Matlab/Data/Master_Files/Docs'], 'Master-Files-Docs'; ...
%         [ls 'Matlab/ubc_PC_setup/Site_Specific/TP39'], 'UBC-PC-Setup-TP39'; ...
% [ls 'Matlab/ubc_PC_setup/Site_Specific/TP74'], 'UBC-PC-Setup-TP74'; ...
% [ls 'Matlab/ubc_PC_setup/Site_Specific/TP02'], 'UBC-PC-Setup-TP02'; ...
%             };
%%%% Modified on 01-May-2012
%%%% Revised on 20-May-2018 [jjb] - backed up entire ubc_PC_setup, instead
%%%% of specific site folders.

doc_locns = {[ls 'Matlab/Scripts'], 'Scripts'; ...
            [ls 'Matlab/Config'], 'Matlab-Config';...
            [ls 'Documentation/Logs'], 'Documentation-Logs';...
            [ls 'Matlab/ubc_PC_setup'], 'ubc-PC-setup'; ...
            [ls 'Matlab/biomet.net'], 'biomet.net'; ...
            };
%             [ls 'Matlab/ubc_PC_setup/Site_Specific/TP74'], 'UBC-PC-Setup-TP74'; ...
%             [ls 'Matlab/ubc_PC_setup/Site_Specific/TP02'], 'UBC-PC-Setup-TP02'; ...
            
        
%%% Step 1: Move the previous zipped file into archive:
disp(['Moving Previous .zip file from /Most_Recent to /Archive, if it exists:']);
d = dir([save_path 'Most_Recent/']);
if length(d) == 3
    [junk1, junk2, ext] = fileparts(d(3).name);
    if strcmp(ext,'.zip')==1
        unix(['mv ' save_path 'Most_Recent/' d(3).name ' ' save_path 'Archive/' d(3).name]);
          disp([d(3).name ' moved to ' save_path 'Archive/']);        
        
    else
        disp(['File in ' save_path 'Most_Recent/ is not a .zip file.']);
    disp(['Most_Recent .zip file not moved to ' save_path 'Archive/']);
    end
elseif length(d) >3
    disp(['There are too many files in ' save_path 'Most_Recent/.'])
    disp(['Please clear this out of all files/folders other than the .zip file'])
    disp(['Most_Recent .zip file not moved to ' save_path 'Archive/']);
else
    disp(['No previous .zip file to move to /Archive/']);
end

%%% Step 2: copy all documentation directories to /Most_Recent and then
%%% zip.
unix(['mkdir ' save_path 'Most_Recent/' dstr ]);
disp(['Copying all documentation directories to /Most_Recent/']);

for i = 1:1:size(doc_locns,1)
    s(i,1) = unix(['mkdir ' save_path 'Most_Recent/' dstr '/' doc_locns{i,2}]);
    s(i,2) = unix(['cp -r ' doc_locns{i,1} '/* ' save_path 'Most_Recent/' dstr '/' doc_locns{i,2} '/']);
end
s_sum = sum(s(:));

if s_sum == 0
    disp(['All documentation directories copied successfully.']);
% Now, compress the documentation directory:

disp('Zipping up the documentation directories:');
cd ([save_path 'Most_Recent/']);
s2 = unix(['zip -r -q ' dstr '.zip ' dstr ]);
else
    disp(['Something had gone wrong with directory copying - not zipping']);
end

if s2 == 0
    disp(['File zipped successfully.']);
else
    disp(['File not zipped successfully.']);
end
% Successful or unsuccessful, delete the folder we just zipped:
% We do this because we don't want that data sitting in there either way..
% If it's unsuccessful, we'll have to run it again, which means we don't
% want that data being copied to the /Archive directory..
unix(['rm -r ' save_path 'Most_Recent/' dstr ]);
    cd ([ls 'Matlab/Scripts/']);
diary off;
if exit_override == 0
exit;
end