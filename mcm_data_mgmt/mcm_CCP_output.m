function [] = mcm_CCP_output(year,site,CCP_out_path, master,ftypes_torun)
%%% This function will:
% 1. Output data at Monthly scale
% 2. Create and Add JD and EndTime to all output matricies
% 3. Create Variable name and Unit headers (surrounded by parentheses)
% 4. Output separate files for each type of data: (Met1, Met2, Met3, Flux1,
%       Flux2, Flux3, SM2, SM3)
% 5. Appropriate name to files:
% ON-TPxx_FlxTwr_Met2_2003-04-00.csv



%%% If we give The program only 2 inputs (site, year), and leave the others
%%% empty, then it'll know that it's being called from the GUI,
%%% and will load that data it needs:
tic;

[year_start year_end] = jjb_checkyear(year);
% if isempty(year)==1
%     year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
% end
%
% % Makes sure that year is a string:
% if ischar(year)==1
%     disp('please put year into program as an integer (e.g. 2008) or set of integers (e.g. 2008:2009).')
%     year = input('Enter year: > ');
% end
sitename_converter = ...
    {'TP39' 'ON-WPP39'; ...
    'TP74' 'ON-WPP74'; ...
    'TP89' 'ON-WPP89'; ...
    'TP02' 'ON-WPP02'; ...
    'TP_PPT' 'ON-WPP_PPT';...
    'MCM_WX' 'MCM_WX';...
    'TPD'   'ON-TPD'};

sitename_out = sitename_converter{find(strcmp(site,sitename_converter(:,1))==1),2};

if nargin == 2
    CCP_out_path = '';
    master = [];
    ftypes_torun = 'all';
elseif nargin >2 && nargin <5
    ftypes_torun = 'all';
end

ls = addpath_loadstart;
master_out_path =           [ls 'Matlab/Data/Master_Files/'];
gdrive_path = '/home/arainlab/Google Drive/TPFS Data/CCP_Annual_Files/';
% jjb_check_dirs([gdrive_path site],1);

if isempty(CCP_out_path)==1 || isempty(master)==1
    % Declare Paths:
    CCP_annual_out_path = [ls 'Matlab/Data/CCP/CCP_output/CCP_Annual_Files/' sitename_out '/'];
    CCP_out_path =              [ls 'Matlab/Data/CCP/CCP_output/' sitename_out '/'];
    jjb_check_dirs(CCP_out_path,0);
    jjb_check_dirs(CCP_annual_out_path,0);
    
end

%%% Load the data:
if exist([master_out_path  site '/' site '_data_master.mat'], 'file')== 2;
    disp('Loading master file.');
    load([master_out_path  site '/' site '_data_master.mat']);
else
    disp('Can not locate the master file.  Check path in mcm_CCP_output.m')
    return
end

if isempty(ftypes_torun)==1
    ftypes_torun = 'all';
end
%%% Establish start and end years
% year_start = min(year);
% year_end = max(year);

%%%% Labels for naming files and columns:

% Change TP to WPP:
switch site
    case 'TPD'
        site_tmp = 'TPD';
    otherwise
site_tmp = ['WPP' site(3:end)];
end
site_label = ['ON-' site_tmp];
time_int = 30;
subsite_label = 'FlxTwr';

%%% Substitute in some things for different sites:
unit_str1 = '(n/a),(n/a),(n/a),(UTC),(UTC),(HrMn_UTC),';
switch site
    case 'TP_PPT'
        subsite_label = 'PPT_Stn';
        % Change TP to WPP:
    case 'MCM_WX'
        %         site_tmp = site;
        site_label = site;
        subsite_label = 'Met_Stn';
        time_int = 15;
%         unit_str1 = '(n/a),(n/a),(n/a),(EST),(EST),(HrMn_EST),';
                unit_str1 = '(n/a),(n/a),(n/a),(EST),(EST),(HrMn_EST),';

end
% if strcmp(site,'TP_PPT')==1
%     subsite_label = 'PPT_Stn';
% else
%     subsite_label = 'FlxTwr';
% end

%%% Two more tags that will go on all data:
cert_code = 'CPI';
tmp1 = datestr(now,30);
rev_date = tmp1(1:8);
end_stamp = [cert_code ',' rev_date];
clear tmp1 cert_code rev_date;

%% Main Part:
%%% Find all data types in the master file, and where they occur:
ftypes = unique_str(master.labels(:,6),1);


for j = year_start:1:year_end
    clear YYYY_label
    YYYY_label = num2str(j);
    disp(['Now Working on Site: ' site ', Year: ' YYYY_label '.'])
    
    
%     [YYYY JD HHMM dt] = jjb_makedate(j,time_int);
    [tvec YYYY MM DD dt HHMM hh mm JD] = jjb_maketimes(j, time_int);
    % Shrink output data file to only the specified year:
    clear data_out;
    data_out = master.data(master.data(:,1)==j,:);
    %%% Replace Nans with -999:
    data_out(isnan(data_out)) = -999;
    
    %             ind_out = find(data_out(:,2)==m);
    
    
    %% Write annual Files:
    for i = 1:1:size(ftypes,1)
        
        clear dtype_label;
        dtype_label = ftypes{i,1};
        
        clear filename;
        filename = [site_label '_' subsite_label '_' dtype_label '_' YYYY_label '.csv'];
        % April 11, 2011: Changed program so that annual files saved to the
        % /CCP_Annual_Files/ directory
        fid = fopen([CCP_annual_out_path filename],'w');
        %%%%%%%%%%%%%% Make the headers: %%%%%%%%%%%%%%%%%%%%%%
        %%% Print first part of column names:    
        tmp_out = 'DataType,Site,SubSite,Year,Day,End_Time,';
        switch site
            case 'MCM_WX'
               tmp_out = 'DataType,Site,SubSite,Year,JulianDay,End_Time,';
        end
        fprintf(fid,'%s',tmp_out);
        clear tmp_out;
        %%% Prints the rest of the Column Names
        nee_cols = [];
        for k = 1:1:length(ftypes{i,2})
            clear name_out;
            name_out = master.labels{ftypes{i,2}(k,1),1};
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Added March 26, 2011 by JJB.
            %%% Attempt to convert all instances of NEE into NEP.
            %%% The first job is to find where we get
            %%% 'NetEcosystemExchange' or 'NEE' in a string in the
            %%% Column Names. We'll record the columns at which this
            %%% occurs, and use that knowledge to multiply all data
            %%% columns by -1 when we write the data:
            % Commented April 27, 2011 by JJB - Apparently, we don't
            % need to change this one.
            %             nee_ind1 = strfind(name_out,'NetEcosystemExchange');
            %             if ~isempty(nee_ind1)
            %                 tmp_name = ['NetEcosystemProductivity' name_out(21:end)];
            %                 name_out = tmp_name; clear tmp_name nee_ind1;
            %                 nee_cols = [nee_cols; k];
            %             end
            nee_ind2 = strfind(name_out,'NEE');
            if ~isempty(nee_ind2)
                name_out(nee_ind2+2) = 'P';
                nee_cols = [nee_cols; k]; % list of columns that have NEE
                clear nee_ind2;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if k == length(ftypes{i,2})
                name_out = [name_out ',CertificationCode,RevisionDate'];
                fprintf(fid,'%s\n',name_out);
            else
                name_out = [name_out ','];
                fprintf(fid,'%s',name_out);
            end
        end
        %%%  Print first part of units (line 2):
        tmp_out = unit_str1;%'(n/a),(n/a),(n/a),(UTC),(UTC),(HrMn_UTC),';
        fprintf(fid,'%s',tmp_out);
        clear tmp_out;
        %%% Prints the rest of the Units:
        for k = 1:1:length(ftypes{i,2})
            clear name_out;
            name_out = master.labels{ftypes{i,2}(k,1),2};
            name_out = ['(' name_out ')']; % put units in parentheses
            if k == length(ftypes{i,2})
                name_out = [name_out ',(n/a),(YYYYMMDD)'];
                fprintf(fid,'%s\n',name_out);
            else
                name_out = [name_out ','];
                fprintf(fid,'%s',name_out);
            end
        end
        %%%%%%%%%%%%%%%% Print the data to file: %%%%%%%%%%%%%%%%%%%%%%
        for line_num = 1:1:size(data_out,1)
            % First part (Site details):
            tmp_out = [dtype_label ',' site_label ',' subsite_label ','];
            fprintf(fid,'%s',tmp_out);
            clear tmp_out;
            % Second Part (Time details):
            fprintf(fid,'%4d',YYYY(line_num,1)); fprintf(fid,'%s',',');
            fprintf(fid,'%3d',JD(line_num,1)); fprintf(fid,'%s',',');
            fprintf(fid,'%4d',HHMM(line_num,1)); fprintf(fid,'%s',',');
            % Third Part (Actual Data):
            for k = 1:1:length(ftypes{i,2})
                %%% Print the value to file
                %%% Get the proper format from the master file:
                clear format_out;
                format_out = master.labels{ftypes{i,2}(k,1),7};
                %%%% Reverse sign of NEE to convert to NEP:
                mult = 1;
                if ~isempty(find(nee_cols==k, 1)) && data_out(line_num,ftypes{i,2}(k,1)) ~= -999
                    mult = -1;
                end
                fprintf(fid,format_out,mult.*data_out(line_num,ftypes{i,2}(k,1)));
                fprintf(fid,'%s',',');
                %%% If it's the last variable, go to a new line
                if k == length(ftypes{i,2})
                    fprintf(fid,'%s\n',end_stamp);
                    %                         format_out = [format_out '\n'];
                    %                         fprintf(fid,format_out,data_out(ind_out(line_num),ftypes{i,2}(k,1)));
                    %%% If it's not, then just put a comma at the end:
                else
                    %                         fprintf(fid,format_out,data_out(ind_out(line_num),ftypes{i,2}(k,1)));
                    
                end
            end
        end
        fclose(fid);
    end
    
    %% Write Monthly Files:
    disp('No Monthly Files have been created. This was discontinued by JJB on 31-Jan-2016.');
    % ################ BLOCK COMMETED BY JJB on 31-Jan-2016 - remove the
    % line '%{'below to re-enable
    %{ 
    for m = 1:1:12
        clear MM_label;
        MM_label = create_label(m,2);
        % index of the data to use:
        %         ind_out = find(master.data(:,1)==j & master.data(:,2)==m);
        ind_out = find(data_out(:,2)==m);
        
        for i = 1:1:size(ftypes,1)
            
            clear dtype_label;
            dtype_label = ftypes{i,1};
            
            clear filename;
            filename = [site_label '_' subsite_label '_' dtype_label '_' YYYY_label '-' MM_label '-00.csv'];
            fid = fopen([CCP_out_path filename],'w');
            %%%%%%%%%%%%%% Make the headers: %%%%%%%%%%%%%%%%%%%%%%
            %%% Print first part of column names:
            tmp_out = 'DataType,Site,SubSite,Year,Day,End_Time,';
            switch site
                case 'MCM_WX'
                    tmp_out = 'DataType,Site,SubSite,Year,JulianDay,End_Time,';
            end
            fprintf(fid,'%s',tmp_out);
            clear tmp_out;
            %%% Prints the rest of the Column Names
            nee_cols = [];
            for k = 1:1:length(ftypes{i,2})
                clear name_out;
                name_out = master.labels{ftypes{i,2}(k,1),1};
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% Added March 26, 2011 by JJB.
                %%% Attempt to convert all instances of NEE into NEP.
                %%% The first job is to find where we get
                %%% 'NetEcosystemExchange' or 'NEE' in a string in the
                %%% Column Names. We'll record the columns at which this
                %%% occurs, and use that knowledge to multiply all data
                %%% columns by -1 when we write the data:
                % Commented April 27, 2011 by JJB - Apparently, we don't
                % need to change this one.
                %                 nee_ind1 = strfind(name_out,'NetEcosystemExchange');
                %                 if ~isempty(nee_ind1)
                %                     tmp_name = ['NetEcosystemProductivity' name_out(21:end)];
                %                     name_out = tmp_name; clear tmp_name nee_ind1;
                %                     nee_cols = [nee_cols; k];
                %                 end
                nee_ind2 = strfind(name_out,'NEE');
                if ~isempty(nee_ind2)
                    name_out(nee_ind2+2) = 'P';
                    nee_cols = [nee_cols; k]; % list of columns that have NEE
                    clear nee_ind2;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if k == length(ftypes{i,2})
                    name_out = [name_out ',CertificationCode,RevisionDate'];
                    fprintf(fid,'%s\n',name_out);
                else
                    name_out = [name_out ','];
                    fprintf(fid,'%s',name_out);
                end
            end
            %%%  Print first part of units (line 2):
            tmp_out = unit_str1;%'(n/a),(n/a),(n/a),(UTC),(UTC),(HrMn_UTC),';
            fprintf(fid,'%s',tmp_out);
            clear tmp_out;
            %%% Prints the rest of the Units:
            for k = 1:1:length(ftypes{i,2})
                clear name_out;
                name_out = master.labels{ftypes{i,2}(k,1),2};
                name_out = ['(' name_out ')']; % put units in parentheses
                if k == length(ftypes{i,2})
                    name_out = [name_out ',(n/a),(YYYYMMDD)'];
                    fprintf(fid,'%s\n',name_out);
                else
                    name_out = [name_out ','];
                    fprintf(fid,'%s',name_out);
                end
            end
            %%%%%%%%%%%%%%%% Print the data to file: %%%%%%%%%%%%%%%%%%%%%%
            for line_num = 1:1:length(ind_out)
                % First part (Site details):
                tmp_out = [dtype_label ',' site_label ',' subsite_label ','];
                fprintf(fid,'%s',tmp_out);
                clear tmp_out;
                % Second Part (Time details):
                fprintf(fid,'%4d',YYYY(ind_out(line_num),1)); fprintf(fid,'%s',',');
                fprintf(fid,'%3d',JD(ind_out(line_num),1)); fprintf(fid,'%s',',');
                fprintf(fid,'%4d',HHMM(ind_out(line_num),1)); fprintf(fid,'%s',',');
                % Third Part (Actual Data):
                for k = 1:1:length(ftypes{i,2})
                    %%% Print the value to file
                    %%% Get the proper format from the master file:
                    clear format_out;
                    format_out = master.labels{ftypes{i,2}(k,1),7};
                    %%%% Reverse sign of NEE to convert to NEP:
                    mult = 1;
                    if ~isempty(find(nee_cols==k, 1)) && data_out(ind_out(line_num),ftypes{i,2}(k,1)) ~= -999
                        mult = -1;
                    end
                    fprintf(fid,format_out,mult.*data_out(ind_out(line_num),ftypes{i,2}(k,1)));
                    fprintf(fid,'%s',',');
                    %%% If it's the last variable, go to a new line
                    if k == length(ftypes{i,2})
                        fprintf(fid,'%s\n',end_stamp);
                        %                         format_out = [format_out '\n'];
                        %                         fprintf(fid,format_out,data_out(ind_out(line_num),ftypes{i,2}(k,1)));
                        %%% If it's not, then just put a comma at the end:
                    else
                        %                         fprintf(fid,format_out,data_out(ind_out(line_num),ftypes{i,2}(k,1)));
                        
                    end
                end
            end
            fclose(fid);
        end
        clear ind_out;
    end
    %}
    %%%%%%%%%%%%%%%%%%% In Case of MCM_WX, we need to do daily and hourly
    %%%%%%%%%%%%%%%%%%% averages and output them as well
    switch site
        case 'MCM_WX'
            disp('Creating Hourly and Daily Files for MCM_WX');
    mcm_wx_averaging(j,master.labels);
    disp('Done.');
    end
    %%%%%%%%%%%%%%%%%%% Ending Stuff
    tt(j,1) = toc;
    disp(['Site: ' site ',Year: ' YYYY_label ' finished in ' num2str(tt(j,1)) ' seconds.']);
    clear YYYY JD hhmm dt;
    
end

% tt = toc;
% disp(['Time to do CCP output = ' num2str(tt) ' seconds.']);


%% Try and zip the contents of the monthly files:
% ################ BLOCK COMMETED BY JJB on 31-Jan-2016 - remove the
    % line '%{'below to re-enable
    %{
disp(['Trying to zip the monthly files for the site: ' sitename_out]);
try
    eval(['cd ' ls 'Matlab/Data/CCP/CCP_output/']);
    unix(['rm ' sitename_out '.zip']);
    disp('Old zip-file removed');
    unix(['zip -r ' sitename_out '.zip ' sitename_out]);
    disp(['Monthly files zipped for ' sitename_out '.']);
catch
    disp(['Zipping monthly files failed for the site: ' sitename_out]);
end
% eval(['cd ' ls 'Matlab/Scripts/']);
%}
%% Try and zip the contents of the annual files:
disp('Trying to zip the annual files for the site: ');
try
    eval(['cd ' ls 'Matlab/Data/CCP/CCP_output/CCP_Annual_Files/']);
    unix(['rm ' sitename_out '_annual.zip']);
    disp('Old zip-file removed');
    unix(['zip -r ' sitename_out '_annual.zip ' sitename_out]);
    disp(['Annual files zipped for ' sitename_out '.']);
    try
    %%% Upload the annual files to Google Drive
    stat = unix(['cp -avr ' ls 'Matlab/Data/CCP/CCP_output/CCP_Annual_Files/' sitename_out '_annual.zip "' gdrive_path sitename_out '_annual.zip"']);
     if stat ~=0
    disp('Could not copy files to Google Drive-synced folder. Check for problems');
     else
    disp('Uploaded Annual CCP files to Google Drive-synced folder (/home/arainlab/Google Drive/TPFS Data/CCP_Annual_Files.).');
     end
    catch
        disp('Problem copying annual files to Google Drive folder (/home/arainlab/Google Drive/TPFS Data/CCP_Annual_Files.).');
    end
catch
    disp(['Zipping annual files failed for the site: ' sitename_out]);
end
eval(['cd ' ls 'Matlab/Scripts/']);
end