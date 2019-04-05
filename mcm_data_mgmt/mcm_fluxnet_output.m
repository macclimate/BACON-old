function [] = mcm_fluxnet_output(year, site, data_type, process_flag)
%%% mcm_fluxnet_output.m
% The purpose of this function is to create standardized outputs for each
% year and each site, which are formatted according to the ORNL and Global
% FLUXNET standard format.
%%% What this function does:
% 1. open master files
% 2. go through a pre-established list of desired variables (with orders inserted)
% 3. Read from column 13 (M)
% 4. calculate VPD given other inputs
% 5. calculate DOY (round down of dtime); dtime should start at 1
% 6. Tsdepths are 2 | 5 ; SWC depths are 5 | 10
% 7. Get CO2 height (from params.m)
% 8. Write all of these variables to a final output in the standard format.
%%%
% usage: mcm_fluxnet_output(year, site, data_type, process_flag)
% inputs:
% year: single or range of years to be processed (e.g. 2008; 2008:2018)
% site: site label (using TPxx notation)
% data_type (either 'main' (default) or 'sapflow')
% process_flag:
%%%% 1 = create individual year files only;
%%%% 2 = create all-years file only
%%%% 3 = create individual year and all-years file (default)


%%% File naming convention:
% <SITE_ID>_<RESOLUTION>_<TS-START>_<TS-END>_<OPTIONAL>.csv
% <SITE_ID>: Use the AmeriFlux / Fluxnet Site ID in the form CC-AAA. CC is the country code (e.g., US, CA, etc). AAA is the three alphanumeric characters associated with the site. The site ID is determined as part of the site registration process.
% <RESOLUTION>: The time interval used throughout the file. Allowed resolutions are HH (for half-hourly) or HR (for hourly). If you need to upload data at a resolution other than half-hourly or hourly, please contact us at ameriflux-support@lbl.gov.
% <TS-START>: The timestamp for the file�s earliest data in format of YYYYMMDDHHMM. It is the same as the first entry in the TIMESTAMP_START column.
% <TS-END>: The timestamp of the last data entry in format of YYYYMMDDHHMM. It is the same as the last entry of the TIMESTAMP_END column.
% <OPTIONAL>: A parameter to indicate additional information. The only optional parameter currently allowed is NS (Non-Standard). Use this optional parameter to upload files containing variables that are not yet part of the standardized variable labels (see Data Variable: Base names).

if nargin == 2
    data_type = 'main';
    process_flag = 3;
elseif nargin ==3
    process_flag = 3;
end

if strcmp(data_type, 'sapflow')==1
    site = [site '_' data_type];
end

if isempty(process_flag)==1
    process_flag = 3;
end

if isempty(year)==1
    year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
end
if ischar(year)==1
    year = str2double(year);
end

[year_start, year_end] = jjb_checkyear(year);


% Declare paths:
ls_dir = addpath_loadstart;
out_dir =       [ls_dir 'Matlab/Data/Fluxnet/'];
master_dir =    [ls_dir 'Matlab/Data/Master_Files/'];
gdrive_dir = '/home/arainlab/Google Drive/TPFS Data/Fluxnet/';

% Check to make sure the target directory exists. Make one if it doesn't.
if ispc~=1
    jjb_check_dirs([out_dir site],1);
    jjb_check_dirs([gdrive_dir site],1);
end
site_info  = ...
    {'TP39', 'CA-TP4','1939 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    'TP74', 'CA-TP3', '1974 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    'TP89', 'CA-TP2', '1989 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    'TP02', 'CA-TP1', '2002 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    'TPD', 'CA-TPD',  'Deciduous Broadleaf' ,'Deciduous Broadleaf Forest (DBF)'; ...
    'TP39_sapflow', 'CA-TP4_sf','1939 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    'TP74_sapflow', 'CA-TP4_sf','1974 Plantation White Pine','Evergreen Needleleaf Forest (ENF)'; ...
    };

rightrow = find(strcmp(site,site_info(:,1))==1);
sitename_out = site_info{rightrow,2};   % Fluxnet site name
forest_desc = site_info{rightrow,3};    % forest description
eco_type = site_info{rightrow,4};       % ecosystem type

% Load data from the master file:
if exist([master_dir  site '/' site '_data_master.mat'], 'file')== 2
    disp('Loading master file.');
    load([master_dir  site '/' site '_data_master.mat']);
else
    disp('Cannot locate the master file.  Check path in mcm_fluxnet_output.m')
    return
end

%%% Create a list of variables to write to the final output file
%%%% NEED TO SWITCH TO COLUMN 14!!
var_list = master.labels(:,14);
var_list = strrep(var_list,'NaN','');
cols_to_write = find(cellfun('isempty',var_list(:,1))~=1);

%%% Build TIMESTAMP_START and TIMESTAMP_END
% [year_start, year_end]
first_year = master.data(1,1);
last_year = master.data(end,1);
[ts_start, ts_end] = jjb_make_fluxnet_time(first_year:last_year, 30);

%% Do any corrections/adjustments that might be needed for this data:
% 1. Convert snow depth to cm
col_snow = find(strncmp(var_list,'D_SNOW',6)==1);
if ~isempty(col_snow)==1
    master.data(:,col_snow) = master.data(:,col_snow).*100;
end
% 2. Convert SWC to 0-100 scale (from original 0-1 range)
col_swc = find(strncmp(var_list,'SWC',3)==1);
for i = 1:1:size(col_swc)
    master.data(:,col_swc(i))= master.data(:,col_swc(i)).*100;
end
% 2b. Invert sign of WTD
col_wtd = find(strncmp(var_list,'WTD',3)==1);
if ~isempty(col_wtd)==1
    master.data(:,col_wtd) = master.data(:,col_wtd).*-1;
end

% 3. Shift data from UTC to Local Standard time (i.e. EST).
% We need to add 10 data points from the start of next year to the end
% of the year of interest.
tmp_data(:,1:6) = master.data(:,1:6); % copy over time values as-is
tmp_data(:,7:size(master.data,2)) = [master.data(11:end,7:end) ;NaN.*ones(10,size(master.data,2)-6)];
% 4. Replace NaNs with -9999
% tmp_data(isnan(tmp_data)==1)=-9999;

if process_flag >=2
    %% Added 26-April, 2018 (JJB): Export a single file containing all years requested in the call
    %%% Find first and last year with data:
    % time_int = 30; % At this point, all output files are thirty minute interval
    Ta_col = find(strncmp(var_list,'TA_',3)==1);
    beg_yr = tmp_data(find(~isnan(tmp_data(:,Ta_col(1))),1,'first'),1);
    end_yr = tmp_data(find(~isnan(tmp_data(:,Ta_col(1))),1,'last'),1); end_yr = min(end_yr,str2double(datestr(now,'yyyy'))-1);
    
    %%% Trim the master file to the beginning and ending years
    ind_ts = find(tmp_data(:,1)>=beg_yr & tmp_data(:,1)<=end_yr);
    
    % Construct the filename for the all-years file
    fname_tmp = [sitename_out '_HH_' num2str(ts_start(ind_ts(1),1)) '_' num2str(ts_end(ind_ts(end),1))];
    %%% Open/create the output file:
    fid_out = fopen([out_dir site '/' fname_tmp '.csv'],'w');
    fprintf(fid_out,'%s',['TIMESTAMP_START,TIMESTAMP_END,']);
    for k = 1:1:size(cols_to_write,1)-1
        fprintf(fid_out,'%s',[var_list{cols_to_write(k,1)} ',']);
    end
    fprintf(fid_out,'%s\n',[var_list{cols_to_write(k+1,1)}]);
    % Make the blank output file. We know we need to add in two extra
    % columns for TIMESTAMP_START and TIMESTAMP_END
    array_out = [ts_start(ind_ts,:),ts_end(ind_ts,:)];
    format_out = '%12d,%12d';
    for k = 1:1:size(cols_to_write,1)
        %         array_out(:,k+2) = num2cell(tmp_data(ind_ts,cols_to_write(k)));
        array_out(:,k+2) = tmp_data(ind_ts,cols_to_write(k));
        format_out = [format_out ',' master.labels{cols_to_write(k),7}];
        %     format_out = [format_out ',%s'];
    end
    
    for k = 1:1:size(array_out,1)-1
        %         fprintf(fid_out,'%s\n',sprintf(format_out,array_out(k,:)));
        to_print = sprintf(format_out,array_out(k,:));
        to_print = strrep(to_print,'NaN','-9999');
        to_print = strrep(to_print,' ','');
        fprintf(fid_out,'%s\n',to_print);
    end
    to_print = sprintf(format_out,array_out(k+1,:));
    to_print = strrep(to_print,'NaN','-9999');
    to_print = strrep(to_print,' ','');
    fprintf(fid_out,'%s',to_print);
    
    %     fprintf(fid_out,'%s\n',sprintf(format_out,array_out(k+1,:)));
    fclose(fid_out);
    
    % Write success message
    disp(['Completed all-years file for ' sitename_out '. File located in ' out_dir site '/' fname_tmp '.csv']);
    clear fname_tmp;
    
end
%% This will be inside of a yearly loop (in case multiple years are entered)
% %%% Trim the master file to the required years:
% ind_ts = tmp_data(:,1)>=year_start & tmp_data(:,1)<=year_end;
% tmp_data = tmp_data(ind_ts==1,:);
if process_flag ~=2
    clear ind_ts;
    
    for j = year_start:1:year_end
        clear YYYY_label array_out;
        YYYY_label = num2str(j);
        disp(['Now Working on Site: ' site ', Year: ' YYYY_label '.'])
        ind_ts = find(tmp_data(:,1)==j);
        % Retrieve site data from params.m
        %     site_loc = params(j, site, 'Location'); % lat | long | elev
        
        % Construct the filename
        fname_tmp = [sitename_out '_HH_' num2str(ts_start(ind_ts(1),1)) '_' num2str(ts_end(ind_ts(end),1))];
        %%% Open/create the output file:
        fid_out = fopen([out_dir site '/' fname_tmp '.csv'],'w');
        
        % Write the header - variable names:
        fprintf(fid_out,'%s',['TIMESTAMP_START,TIMESTAMP_END,']);
        for k = 1:1:size(cols_to_write,1)-1
            fprintf(fid_out,'%s',[var_list{cols_to_write(k,1)} ',']);
        end
        fprintf(fid_out,'%s\n',[var_list{cols_to_write(k+1,1)}]);
        
        % Close the file:
        %     fclose(fid_out);
        
        %%%%%%%%%%%% Part 2: Write the data to an array %%%%%%%%%%%%%%%
        % Make the blank output file. We know we need to add in two extra
        % columns for TIMESTAMP_START and TIMESTAMP_END
        array_out = [ts_start(ind_ts,:),ts_end(ind_ts,:)];
        format_out = '%12d,%12d';
        
        % Retrieve site data from params.m
        %     heights = params(j, site, 'Heights'); % zmeas | ztree
        
        for k = 1:1:size(cols_to_write,1)
            %         array_out(:,k+2) = num2cell(tmp_data(ind_ts,cols_to_write(k)));
            array_out(:,k+2) = tmp_data(ind_ts,cols_to_write(k));
            format_out = [format_out ',' master.labels{cols_to_write(k),7}];
            %     format_out = [format_out ',%s'];
        end
        
        for k = 1:1:size(array_out,1)-1
            %         fprintf(fid_out,'%s\n',sprintf(format_out,array_out(k,:)));
            to_print = sprintf(format_out,array_out(k,:));
            to_print = strrep(to_print,'NaN','-9999');
            to_print = strrep(to_print,' ','');
            fprintf(fid_out,'%s\n',to_print);
        end
        to_print = sprintf(format_out,array_out(k+1,:));
        to_print = strrep(to_print,'NaN','-9999');
        to_print = strrep(to_print,' ','');
        fprintf(fid_out,'%s',to_print);
        
        %     fprintf(fid_out,'%s\n',sprintf(format_out,array_out(k+1,:)));
        fclose(fid_out);
        %%% Part 3: Append the array to the final output file:
        %     dlmwrite([out_dir site '/' sitename_out '_' num2str(j) '_L2.csv'],array_out,'delimiter',',', 'precision', '%f','-append');
        
        % Write success message
        disp(['Completed. File located in ' out_dir site '/' fname_tmp '.csv']);
        clear fname_tmp;
        
    end
end
% Copy directory to Google Drive
stat = unix(['cp -vr ' out_dir site '/ "' gdrive_dir '"']);
if stat ~=0
    disp('Could not copy files to Google Drive-synced folder. Check for problems');
else
    disp(['Uploaded Master files to Google Drive-synced folder: ' gdrive_dir site]);
end