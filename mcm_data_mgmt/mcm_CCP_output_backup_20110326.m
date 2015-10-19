function [] = mcm_CCP_output(year,site,CCP_out_path, master)
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

    ls = addpath_loadstart;
    master_out_path =           [ls 'Matlab/Data/Master_Files/'];
    
if isempty(CCP_out_path)==1 || isempty(master)==1
    % Declare Paths:

    CCP_out_path =              [ls 'Matlab/Data/CCP/CCP_output/' site '/'];
    jjb_check_dirs(CCP_out_path);
end
%%% Load the data:
if exist([master_out_path  site '/' site '_data_master.mat'], 'file')== 2;
    disp('Loading master file.');
    load([master_out_path  site '/' site '_data_master.mat']);
else
    disp('Can not locate the master file.  Check path in mcm_CCP_output.m')
    return
end

%%% Establish start and end years
% year_start = min(year);
% year_end = max(year);

%%%% Labels for naming files and columns:

% Change TP to WPP:
site_tmp = ['WPP' site(3:end)];
site_label = ['ON-' site_tmp];

if strcmp(site,'TP_PPT')==1
    subsite_label = 'PPT_Stn';
else
    subsite_label = 'FlxTwr';
end

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
    disp(['Now Working on Year ' YYYY_label '.'])
    
    
    [YYYY JD HHMM dt] = jjb_makedate(j,30);
    % Shrink output data file to only the specified year:
    clear data_out;
    data_out = master.data(master.data(:,1)==j,:);
    %%% Replace Nans with -999:
    data_out(isnan(data_out)) = -999;
    
%             ind_out = find(data_out(:,2)==m);

    %% Write annual Files:
    for i = 1:1:length(ftypes)
            
            clear dtype_label;
            dtype_label = ftypes{i,1};
            
            clear filename;
            filename = [site_label '_' subsite_label '_' dtype_label '_' YYYY_label '.csv'];
            fid = fopen([CCP_out_path filename],'w');
            %%%%%%%%%%%%%% Make the headers: %%%%%%%%%%%%%%%%%%%%%%
            %%% Print first part of column names:
            tmp_out = 'DataType,Site,SubSite,Year,Day,End_Time,';
            fprintf(fid,'%s',tmp_out);
            clear tmp_out;
            %%% Prints the rest of the Column Names
            for k = 1:1:length(ftypes{i,2})
                clear name_out;
                name_out = master.labels{ftypes{i,2}(k,1),1};
                if k == length(ftypes{i,2})
                    name_out = [name_out ',CertificationCode,RevisionDate'];
                    fprintf(fid,'%s\n',name_out);
                else
                    name_out = [name_out ','];
                    fprintf(fid,'%s',name_out);
                end
            end
            %%%  Print first part of units (line 2):
            tmp_out = '(n/a),(n/a),(n/a),(UTC),(UTC),(HrMn_UTC),';
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
                    fprintf(fid,format_out,data_out(line_num,ftypes{i,2}(k,1)));
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
    for m = 1:1:12
        clear MM_label;
        MM_label = create_label(m,2);
        % index of the data to use:
        %         ind_out = find(master.data(:,1)==j & master.data(:,2)==m);
        ind_out = find(data_out(:,2)==m);
        
        for i = 1:1:length(ftypes)
            
            clear dtype_label;
            dtype_label = ftypes{i,1};
            
            clear filename;
            filename = [site_label '_' subsite_label '_' dtype_label '_' YYYY_label '-' MM_label '-00.csv'];
            fid = fopen([CCP_out_path filename],'w');
            %%%%%%%%%%%%%% Make the headers: %%%%%%%%%%%%%%%%%%%%%%
            %%% Print first part of column names:
            tmp_out = 'DataType,Site,SubSite,Year,Day,End_Time,';
            fprintf(fid,'%s',tmp_out);
            clear tmp_out;
            %%% Prints the rest of the Column Names
            for k = 1:1:length(ftypes{i,2})
                clear name_out;
                name_out = master.labels{ftypes{i,2}(k,1),1};
                if k == length(ftypes{i,2})
                    name_out = [name_out ',CertificationCode,RevisionDate'];
                    fprintf(fid,'%s\n',name_out);
                else
                    name_out = [name_out ','];
                    fprintf(fid,'%s',name_out);
                end
            end
            %%%  Print first part of units (line 2):
            tmp_out = '(n/a),(n/a),(n/a),(UTC),(UTC),(HrMn_UTC),';
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
                    fprintf(fid,format_out,data_out(ind_out(line_num),ftypes{i,2}(k,1)));
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
    
    
    
    tt(j,1) = toc;
    disp(['Year ' YYYY_label ' finished in ' num2str(tt(j,1)) ' seconds.']);
    
    clear YYYY JD hhmm dt;
end

% tt = toc;
% disp(['Time to do CCP output = ' num2str(tt) ' seconds.']);
end