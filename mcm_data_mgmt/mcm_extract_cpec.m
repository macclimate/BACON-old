function [] = mcm_extract_cpec(site, load_path,automove_flag)
% mcm_extract_cpec.m
% This function is called by mcm_start_mgmt, and used to call the functions
% mcm_extract_datafiles and mcm_extract_hhourfiles, which take downloaded
% data and sorts them into the proper folders inside of the /SiteData/
% directory.  After data is put in the proper folders, the downloaded data
% (which should be in the /DUMP_Data/ directory), is moved into the
% /To_Burn/ directory.
% Created May 2009 by JJB
% Revision History:
%
% May 27, 2009:
% Modified script so that it also writes data into /Raw_Data_Archive
% folder, where it will be kept for long-term storage. (JJB)
%
%

%% Declare Paths
if nargin < 3
automove_flag = 0;
end
    
if ispc == 1;
%     if exist('G:/')==7;
%         start_path = 'G:/';
%         disp('loading from portable hard drive.')
%     else
%         start_path = 'D:/';
%         disp('loading from fixed hard disk.');
%     end
else
   
        start_path = addpath_loadstart;
        
end

disp(['running mcm_extract_cpec -- start_path = ' start_path]);


%% Sort out starting paths - search for the data and hhour folders
%%% in different formats (since different folders have data in different
%%% formats):

% Specify the proper path to move data to the "To_Burn Folder"
if ispc == 1;
slsh = find(load_path == '\'); % works for windows computers.
else
slsh = find(load_path == '/'); 
end
tag = load_path(slsh(end)+1:end);

burn_path = [start_path 'To_Burn/' site '/'];
jjb_check_dirs(burn_path,automove_flag);
archive_path = [start_path 'Raw_Data_Archive/' site '/'];
jjb_check_dirs(archive_path,automove_flag);

data_save_path = [start_path 'SiteData/' site '/MET-DATA/data/'];
jjb_check_dirs(data_save_path,automove_flag);
hhour_save_path = [start_path 'SiteData/' site '/MET-DATA/hhour_field/'];
jjb_check_dirs(hhour_save_path,automove_flag);

%%% data load path
if exist([load_path '/MET-DATA/data/'])==7;
    data_load_path = [load_path '/MET-DATA/data/'];
    disp(['Found the /data folder at: ' load_path '/MET-DATA/data/']);
run_data_flag = 1;
    
elseif exist([load_path '/met-data/data/'])==7;
    data_load_path = [load_path '/met-data/data/'];
    disp(['Found the /data folder at: ' load_path '/met-data/data/']);
run_data_flag = 1;
elseif exist([load_path '/' tag '/met-data/data/'])==7;
    data_load_path = [load_path '/' tag '/met-data/data/'];
    disp(['Found the /data folder at: ' load_path '/' tag '/met-data/data/']);
    run_data_flag = 1;
elseif exist([load_path '/' tag '/MET-DATA/data/'])==7;
    data_load_path = [load_path '/' tag '/MET-DATA/data/'];
    disp(['Found the /data folder at: ' load_path '/' tag '/MET-DATA/data/']);
    run_data_flag = 1;
else
    disp('I can''t find the /data folder.  It will not be processed');
    data_load_path = '';
    run_data_flag = 0;
end




%% hhour files
if exist([load_path '/MET-DATA/hhour/'])==7;
    hhour_load_path = [load_path '/MET-DATA/hhour/'];
    disp(['Found the /hhour folder at: ' load_path '/MET-DATA/hhour/']);
run_hhour_flag = 1;
elseif exist([load_path '/met-data/hhour/'])==7;
    hhour_load_path = [load_path '/met-data/hhour/'];
    disp(['Found the /hhour folder at: ' load_path '/met-data/hhour/']);
run_hhour_flag = 1;
elseif exist([load_path '/' tag '/met-data/hhour/'])==7;
    hhour_load_path = [load_path '/' tag '/met-data/hhour/'];
    disp(['Found the /hhour folder at: ' load_path '/' tag '/met-data/hhour/']);
run_hhour_flag = 1;
elseif exist([load_path '/' tag '/MET-DATA/hhour/'])==7;
    hhour_load_path = [load_path '/' tag '/MET-DATA/hhour/'];
    disp(['Found the /hhour folder at: ' load_path '/' tag '/MET-DATA/hhour/']);
    run_hhour_flag = 1;
else
    disp('I can''t find the /hhour folder. It will not be processed.');
    hhour_load_path = '';
    run_hhour_flag = 0;
end

%% Run both extractors

if run_hhour_flag == 0 && run_data_flag == 0
    disp('Did not find any data - Halting');
    return;
end

if run_data_flag ==1;
mcm_extract_datafiles(data_load_path, data_save_path, site);
end

if run_hhour_flag ==1;
mcm_extract_hhourfiles(hhour_load_path, hhour_save_path, site);
end


%% Move Data to the /To Burn Folder:

if exist([burn_path '/' tag])==7
    jjb_play_sounds('error');
    commandwindow;
    disp('folder already exists in the "To_Burn" folder')
    if automove_flag == 0
        resp = input('Enter <e> to exit or enter to continue: ','s');
        if strcmp(resp,'e')==1
            finish
        else
        end
    end
else
    %     mkdir([burn_path '/' tag])
end
commandwindow;
if automove_flag == 0
jjb_play_sounds('continue');
resp2 = input('Press enter to move data to "To_Burn" Folder, press any other key to abort data move.');
else
    resp2 = [];
end

if isempty(resp2)==1

    if ispc ==1
        [s,mess,messid] = copyfile(load_path, [archive_path tag]);
        [s2,mess2,messid2] = movefile(load_path, burn_path,'f');
        
%         dos(['COPY /-Y ',load_path ' ' archive_path]);
%         dos(['MOVE /-Y ',load_path ' ' burn_path]);
    else
        disp('Now copying folder to the "Raw Data Archive" directory -- This may take a few minutes')
        unix(['cp  -r ' load_path ' ' archive_path]);
        
        disp('Now moving folder to the "To_Burn" directory -- This may take a few minutes')
        unix(['mv  -f ' load_path ' ' burn_path]);
%         [s,mess,messid] = copyfile(load_path, [archive_path tag]);
%         [s2,mess2,messid2] = movefile(load_path, burn_path,'f');

    end
disp('done!');
    % movefile(load_path, burn_path);
else
    finish
    disp('Folder not moved to "To_Burn"');
end
if automove_flag == 0
jjb_play_sounds('done')
end