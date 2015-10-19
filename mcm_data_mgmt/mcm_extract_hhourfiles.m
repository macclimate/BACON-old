function mcm_extract_hhourfiles(source_path, dest_path, site)
% mcm_extract_hhourfiles.m
% This function is called by mcm_extract_CPEC (called from mcm_start_mgmt),
% and sorts incoming downloaded 1/2 hour averaged data, checks for their 
% existence in the master directory (/SiteData/), and either copies the 
% file over, or does nothing, depending on the file status in the master file.
% 
% What this program does:
% Checks downloaded data for:
% 1. That they have the proper data tags (means from the proper site)
% 2. That the data exists already in the master /SiteData/hhour_field directory -- 
%       -- if the file doesn't exist, it is copied in the master directory.
%       -- If the file exists in the master directory, it only moves it if
%       the new file is larger than the current file in /SiteData/
% Created May, 2009 by JJB
% Revision History:
%
%
%
%
%
%
% 

%% Tags for Data
% switch site
%     case 'TP39'
%         tag(1) = cellstr('.hHJP02.mat');
%     case 'TP74'
%         tag(1) = cellstr('.hMCM2.mat');
%     case 'TP02'
%         tag(1) = cellstr('.hMCM3.mat');
%     case 'TP39_chamber'
%         tag(1) = cellstr('.ACS_Flux_16.mat');
% end
tag = mcm_get_fluxsystem_info(site, 'hhour_field_extensions');



%%% Step 1 -- Load the source /data folder and look inside:
d = dir(source_path);
move_flag = zeros(length(d),1); tag_flag = zeros(length(d),1); final_flag = zeros(length(d),1);
% source_fullname = cell; dest_fullname = cell; 
file_list = struct;
source_sizes = zeros(length(d),1); dest_sizes = zeros(length(d),1); 

if length(d) > 2 % If d is larger than 2, we know there is data in the folder

    %%%%%%%%%% Get information about existing hhour files
           d_dest = dir(dest_path);
           
           if length(d_dest) <= 2
               dest_fullname = [];
           else
         for k = 3:1:length(d_dest)
                    dest_sizes(k,1) = d_dest(k).bytes;
                    dest_fullname(k,:) = cellstr(d_dest(k).name);
         end                
           end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Step 2: Look inside each folder inside of /data:
    
    for i = 3:1:length(d)

     clear junk*

        if d(i).isdir ~= 1;
%                 [junk1, junk3, file_list(i).ext, junk2] = fileparts(d(i).name); % get tag
                source_sizes(i,1) = d(i).bytes;
                source_fullname(i,1) = cellstr(d(i).name);
                tmp = char(source_fullname(i,1));
                b = find(tmp == '.',1,'first');
                file_list(i).ext = tmp(1,b:end);
                clear b tmp;
               %%% Step 3: Make flags for data tags:
                if sum(strcmp(file_list(i).ext,tag)) > 0
                    tag_flag(i,1) = 1;
                    else
                    tag_flag(i,1) = 0;
                end
                
                 ind_copy = find(strcmp(source_fullname(i,1),dest_fullname)==1);

                if isempty(ind_copy) && source_sizes(i,1) > 0 % if no copy of the file is found in destination:
                    move_flag(i,1) = 1;
                else
                    if source_sizes(i,1) > dest_sizes(ind_copy,1) %& source_sizes(i,1) > 0 
                        move_flag(i,1) = 1; % if source file is larger than dest file -- we move it.
                    else
                        move_flag(i,1) = 0; % if same file is already in destination:
                    end
                end
        end
    end
    
   final_flag = move_flag.*tag_flag; % if final_flag is 1, then we can move it over:
end
                


%%% Move data (if needed);
if sum(final_flag) > 0;
    ind_move = find(final_flag == 1); % gives list of files to move
    
    disp('copying hhour files (if needed)')
    for k = 1:1:length(ind_move)
        try
            
            if ispc == 1;
         [s,mess,messid] = copyfile([source_path d(ind_move(k)).name], [dest_path d(ind_move(k)).name]);
%        [status,result] = dos(['copy /Y ' source_path d(ind_move(k)).name ' ' dest_path d(ind_move(k)).name ],'-echo');
            
            else
       [status,result] = unix(['cp ' source_path d(ind_move(k)).name ' ' dest_path d(ind_move(k)).name ],'-echo');
            end
       
       %         copyfile([source_path d(ind_move(k)).name], [dest_path d(ind_move(k)).name]);
        catch

            disp(['failed copy for file ' source_path d(i).name '/' d2(ind_move(k)).name]);
        
        
        end
    end
    disp(['total of ' num2str(length(ind_move)) ' hhour files copied.'])
else
    disp('no hhour data copied ');
end        
                