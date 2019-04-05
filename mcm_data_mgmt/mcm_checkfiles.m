function [log_names] = mcm_checkfiles(site, year, data_type,display_flag)
% mcm_checkfiles.m
% This function searches through /data and /hhour folders of CPEC data,
% assessing gaps in data.
% usage: mcm_checkfiles(site, year)
% Created 8-Feb, 2009 by JJB

%%%%%%%%%%%% Revision History:
%%% Jan 12, 2011, JJB.
% Changed the hhour folder that we're checking from hhour_field/ to hhour/
% Instead of getting a list of what hhour files we have from the field
% (which are pretty well useless anyway), we'll now get a list of
% calculated hhour files, which will let us know what has and hasn't been
% calculated.



%%% If year is empty, it means we're going to run multiple years together
% if isempty(year)
%     year_start = input('Enter Start Year: > ');
%     year_end = input('Enter End Year: > ');
% %%% If year has a single element, we are running one year:
% elseif numel(year) == 1 || ischar(year);
% if ischar(year)
%     year = str2num(year);
% end
% year_start = year; year_end = year;
%
% end
if nargin ==2
    data_type = '';
    display_flag = 1;
elseif nargin == 3
    display_flag = 1;
end

if isempty(display_flag)==1
    display_flag = 1;
end

if strcmp('chamber',data_type) == 1
    site = [site '_chamber'];
end

if isempty(year)==1
    commandwindow;
    year = input('Enter year(s) to process; single or sequence (e.g. [2007:2010]): >');
elseif ischar(year)==1
    year = str2double(year);
end

if numel(year)>1
    year_start = min(year);
    year_end = max(year);
else
    year_start = year;
    year_end = year;
end

ctr = 1;
for yr_ctr = year_start:1:year_end
    
    yr_str = num2str(yr_ctr);
    
    %%% Navigate to the proper directory:
    
    % if ispc == 1;
    %     if exist('G:/DUMP_Data')==7;
    %         start_path = 'G:/';
    %         disp('loading from portable hard drive.')
    %     else
    %         start_path = 'D:/';
    %         disp('loading from fixed hard disk.');
    %     end
    % else
    
    %     if exist('/media/Deskie/') == 7;
    %         start_path = '/media/Deskie/';
    %     elseif exist('/media/Storage/') == 7;
    %         start_path = '/media/Storage/';
    %     else
    %         start_path = addpath_loadstart;
    %     end
    %
    % end
    
    ls = addpath_loadstart;
    % disp(['running mcm_checkfiles -- start_path = ' ls]);
    
    data_path = [ls 'SiteData/' site '/MET-DATA/data/'];
    hhour_path = [ls 'SiteData/' site '/MET-DATA/hhour/'];
    % hhour_field_path = [ls 'SiteData/' site '/MET-DATA/hhour_field/'];
%     log_path = [ls 'SiteData/logs/'];
    log_path = [ls 'Documentation/Logs/mcm_checkfiles/']; % Changed 01-May-2012
    
    %%% Make a cell array that contains information about what extensions
    %%% should be present on data collected from each site.
    % site_info(1,1) = cellstr('TP39'); site_info(1,2) = cellstr('.DMCM4');   site_info(1,3) = cellstr('.DMCM5');     site_info(1,4) = cellstr('.DMCM6');        site_info(1,5) =  cellstr('.hHJP02.mat');
    % site_info(2,1) = cellstr('TP74'); site_info(2,2) = cellstr('.DMCM21');  site_info(2,3) = cellstr('.DMCM22');    site_info(2,4) = cellstr('.DMCM23');       site_info(2,5) =  cellstr('.hMCM2.mat');
    % site_info(3,1) = cellstr('TP02'); site_info(3,2) = cellstr('.DMCM31');  site_info(3,3) = cellstr('.DMCM32');    site_info(3,4) = cellstr('.DMCM33');       site_info(3,5) =  cellstr('.hMCM3.mat');
    % site_info(4,1) = cellstr('TP39_chamber'); site_info(4,2) = cellstr('.DACS16');
    
    %TP39 tags:
    % site_info(1).name(1,1) = cellstr('TP39'); site_info(1).hhour_tag(1,1) =  cellstr('.hHJP02.mat'); site_info(1).hhour_tag(2,1) =  cellstr('s.hHJP02.mat'); %site_info(1).hhour_size =
    site_info(1).name(1,1) = cellstr('TP39'); site_info(1).hhour_tag(1,1) =  cellstr('.hMCM1.mat'); site_info(1).hhour_tag(2,1) =  cellstr('s.hMCM1.mat'); %site_info(1).hhour_size =
    site_info(1).data_tag(1,1) = cellstr('.DMCM4'); site_info(1).data_tag(2,1) = cellstr('.DMCM5');  site_info(1).data_tag(3,1) = cellstr('.bin'); %site_info(1).data_tag(3,1) = cellstr('.DMCM6');
    site_info(1).datafilesize(1,1) = 420000; site_info(1).datafilesize(1,2) = 300000;  site_info(1).datafilesize(1,3) = 500000;
    
    %TP74 tags:
    site_info(2).name(1,1) = cellstr('TP74'); site_info(2).hhour_tag(1,1) =  cellstr('.hMCM2.mat'); site_info(2).hhour_tag(2,1) =  cellstr('s.hMCM2.mat');
    site_info(2).data_tag(1,1) = cellstr('.DMCM21'); site_info(2).data_tag(2,1) = cellstr('.DMCM22');  site_info(2).data_tag(3,1) = cellstr('.DMCM23');
    site_info(2).datafilesize(1,1) = 480000; site_info(2).datafilesize(1,2) = 300000; site_info(2).datafilesize(1,3) = 500000;
    
    %TP02 tags:
    site_info(3).name(1,1) = cellstr('TP02'); site_info(3).hhour_tag(1,1) =  cellstr('.hMCM3.mat'); site_info(3).hhour_tag(2,1) =  cellstr('s.hMCM3.mat');
    site_info(3).data_tag(1,1) = cellstr('.DMCM31'); site_info(3).data_tag(2,1) = cellstr('.DMCM32');  site_info(3).data_tag(3,1) = cellstr('.DMCM33');
    site_info(3).datafilesize(1,1) = 140000; site_info(3).datafilesize(1,2) = 350000; site_info(3).datafilesize(1,3) = 500000;
    

    
    %TP39_chamber tags:
    site_info(4).name(1,1) = cellstr('TP39_chamber'); site_info(4).hhour_tag(1,1) =  cellstr('.ACS_Flux_16.mat');
    site_info(4).data_tag(1,1) = cellstr('.DACS16'); site_info(4).data_tag(2,1) = cellstr('.'); site_info(4).data_tag(3,1) = cellstr('.');
    site_info(4).datafilesize(1,1) = 70000; site_info(4).datafilesize(1,2) = 70000; site_info(4).datafilesize(1,3) = 70000;
    
    
        %TPD tags:
    site_info(5).name(1,1) = cellstr('TPD'); site_info(5).hhour_tag(1,1) =  cellstr('.hMCM4.mat'); site_info(5).hhour_tag(2,1) =  cellstr('s.hMCM4.mat');
    site_info(5).data_tag(1,1) = cellstr('.DMCM41'); site_info(5).data_tag(2,1) = cellstr('.DMCM42');  site_info(5).data_tag(3,1) = cellstr('.DMCM43');
    site_info(5).datafilesize(1,1) = 140000; site_info(5).datafilesize(1,2) = 350000; site_info(5).datafilesize(1,3) = 500000;
        
    % % add TP74_chamber tags here (if needed):
    % site_info(5).name(1,1) = cellstr('TP74_chamber'); site_info(5).hhour_tag(1,1) =  cellstr('***enter extension***');
    % site_info(5).data_tag(1,1) = cellstr('***enter extension***');
    for k = 1:1:length(site_info)
        site_names(k,1) = site_info(k).name;
        site_names(k,2) = cellstr(num2str(k));
    end
    
    
    %%% Figure out which extensions it should be looking for:
    tmp = find(strcmp(site_names, site)==1);
    proper_site = str2num(char(site_names(tmp,2))); clear tmp;
    
    for k = 1:1:length(site_info(proper_site).data_tag)
        data_tag_list(k,:) = cellstr(char(site_info(proper_site).data_tag(k,1)));
    end
    
    for k = 1:1:length(site_info(proper_site).hhour_tag)
        hhour_tag_list(k,:) = cellstr(char(site_info(proper_site).hhour_tag(k,1)));
    end
    
    % we will use 'proper_site' as the number in site()info
    
    %%
    %%% Get YYMMDD list:
    [file_list] = make_YYMMDDlist(yr_ctr);
    %%% Make hhlist:
    hhour_list = num2str((2:2:96)');
    for i = 1:1:length(hhour_list)
        t = find(hhour_list(i,:) == ' ');
        hhour_list(i,t) = '0';
        clear t
    end
    
    check = struct;
    %%
    d2 = dir(hhour_path);
    if length(d2) < 3
        hhour_data = NaN.*ones(3,1);
    else
    end
    for j = 3:1:length(d2);
        %         ind_dot = find(d2(j).name == '.',1,'first');
        temp_tag = d2(j).name(7:end);   % extract tag
        temp_name = cellstr(d2(j).name(1:6));
        temp_bytes = d2(j).bytes;
        right_tagspot = find(strcmp(temp_tag, hhour_tag_list)==1);
        if isempty(right_tagspot) == 1
            disp(['Found data in /hhour folder with improper extension: ' temp_tag]);
        else
            hhour_data(j-2,1)= str2double(temp_name);
            hhour_data(j-2,2) = right_tagspot;
            hhour_data(j-2,3) = temp_bytes;
        end
        
        clear temp* right_tagspot;
    end
    
    %% Go through and check data files for completeness
    for i = 1:1:length(file_list)
        
        if rem(i,50) == 0
            disp(['Working on day ' num2str(i)]);
        end
        
        %%%%%% go through hhour files first
        check(1).hhourstatus(i,1) = str2double(file_list(i,:));
        ind_data = find(hhour_data(:,1) == check(1).hhourstatus(i,1));
        if ~isempty(ind_data)
            for k = 1:1:length(ind_data)
                right_col = hhour_data(ind_data(k),2);
                check(1).hhourstatus(i,right_col.*2) = 1;
                check(1).hhourstatus(i,right_col.*2 + 1) = hhour_data(ind_data(k),3);
            end
            
        else
            check(1).hhourstatus(i,[2 4]) = 0;
            check(1).hhourstatus(i,[3 5]) = NaN;
            
        end
        
        %%%%%%
        
        % Step 1: Check to see if the folder even exists:
        if exist([data_path file_list(i,:)],'dir') == 0 % If the folder does not exist
            check(i).folderstatus = 0;
            check(i).numfiles = 0;
            check(i).filesize = [NaN NaN NaN];
            
        else
            check(i).folderstatus = 1;
            
            %% Go into the folder and look at what is there:
            d = dir([data_path file_list(i,:)]);
            check(i).numfiles = length(d)-2;
            
            check(i).filesize = [NaN NaN NaN];
            try
                for d_ctr = 3:1:length(d)
                    ind_dot = find(d(d_ctr).name == '.',1,'first');
                    temp_tag = d(d_ctr).name(ind_dot:end);   % extract tag
                    right_tagspot = find(strcmp(temp_tag, data_tag_list)==1);
                    check(i).filesize(d_ctr-2,3) = d(d_ctr).bytes;
                    check(i).filesize(d_ctr-2,2) = right_tagspot;
                    check(i).filesize(d_ctr-2,1) = str2num(d(d_ctr).name(7:ind_dot-1));
                    clear ind_dot temp_tag right_tagspot;
                end
            catch
                disp(['There may be a problem with a bad/unwanted file: ' data_path file_list(i,:) '/' d(d_ctr).name]);
                %     disp(['Delete File: ])
            end
            clear d;
        end
    end
    
    % Condense stats for HF data files:
    for i = 1:1:length(check)
        check(1).datastatus(i,1) = str2double(file_list(i,:));
        check(1).datastatus(i,2) = yr_ctr;                            %year
        check(1).datastatus(i,3) = str2double(file_list(i,3:4));    %month
        check(1).datastatus(i,4) = str2double(file_list(i,5:6));    %day
        check(1).datastatus(i,5) = check(i).numfiles;               % # files
        
        ind_tag1 = find(check(i).filesize(:,2) == 1);       check(1).datastatus(i,6) = length(ind_tag1);
        ind_tag2 = find(check(i).filesize(:,2) == 2);       check(1).datastatus(i,7) = length(ind_tag2);
        ind_tag3 = find(check(i).filesize(:,2) == 3);       check(1).datastatus(i,8) = length(ind_tag3);
        
        check(1).datastatus(i,9) = length(find(check(i).filesize(:,3)==0)); % # of empty files
        
        
        marginal_tag1 = length(find(check(i).filesize(ind_tag1,3) > 0 & check(i).filesize(ind_tag1,3) < site_info(proper_site).datafilesize(1,1)));
        marginal_tag2= length(find(check(i).filesize(ind_tag2,3) > 0 & check(i).filesize(ind_tag2,3) < site_info(proper_site).datafilesize(1,2)));
        marginal_tag3= length(find(check(i).filesize(ind_tag3,3) > 0 & check(i).filesize(ind_tag3,3) < site_info(proper_site).datafilesize(1,3)));
        
        
        check(1).datastatus(i,9) = length(find(check(i).filesize(:,3)==0)); % # of empty files
        check(1).datastatus(i,10) = sum([marginal_tag1; marginal_tag2; marginal_tag3]); % # of empty files
        
        
        clear marginal_tag* ind_tag*
        %     check(1).datastatus(i,2) = length(find(check(1,i).filesize
    end
    final_data = check(1).datastatus;
    %%% Jan 12, 2011: Changed from 'hhourstatus(:,2:5) to hhourstatus(:,2:end)'
    final_hhour = [check(1).hhourstatus(:,1) check(1).datastatus(:,2:4) check(1).hhourstatus(:,2:end)];
    % Step 3: Look to see if (both) hhour files exist for given day
    
    %% Write data to log files
    % 1. HF data file summary
    A(1,1)  = cellstr('YYMMDD'); A(2,1)  = cellstr('Year'); A(3,1)  = cellstr('Month');
    A(4,1)  = cellstr('Day'); A(5,1)  = cellstr('# files'); A(6,1)  = cellstr(['# ' char(site_info(proper_site).data_tag(1,1))]);
    A(7,1)  = cellstr(['# ' char(site_info(proper_site).data_tag(2,1))]) ; A(8,1)  = cellstr(['# ' char(site_info(proper_site).data_tag(3,1))]);
    A(9,1)  = cellstr('# empty');  A(10,1)  = cellstr('# marginal');
    AA = char(A);
    format_code = '\n %6.0f\t %4.0f\t %2.0f\t %2.0f\t %3.0f\t %2.0f\t %2.0f\t %2.0f\t %3.0f\t %3.0f\t';
    
    Preamble(1,1) =cellstr(['Completeness log file for HF data for site: ' site ', year ' num2str(yr_ctr)]);
    Pre_char = char(Preamble);
    % Preamble(2,1) =cellstr('All variables are listed in EST timecode (GMT-5)');
    % Preamble(3,1) =cellstr('Variable Explanation: ');
    tmp = datestr(now); timestamp = tmp(1:11); clear tmp;
    
    fid = fopen([log_path site '_HFdata_complete_check_' num2str(yr_ctr) '_' timestamp '.dat'],'w');
    log_names{ctr,1} =[log_path site '_HFdata_complete_check_' num2str(yr_ctr) '_' timestamp '.dat'];
    for i = 1:1:length(Preamble)
        h3 = fprintf(fid,['%' num2str(length(Pre_char)) 's\n'],Pre_char(i,:));
    end
    
    
    for j = 1:1:length(A)
        h = fprintf(fid, '%10s\t' , AA(j,:) );
    end
    
    
    for j = 1:1:length(file_list)
        h2 = fprintf(fid,format_code,final_data(j,:));
    end
    
    fclose(fid)
    
    %% 2. hhour file summary
    A(1,1)  = cellstr('YYMMDD'); A(2,1)  = cellstr('Year'); A(3,1)  = cellstr('Month');
    A(4,1)  = cellstr('Day'); A(5,1)  = cellstr('long-file-ind'); A(6,1)  = cellstr('long-file-size');
    A(7,1)  = cellstr('short-file-ind'); A(8,1)  = cellstr('short-file-size');
    clear AA;
    AA = char(A);
    
    format_code = '\n %6.0f\t %4.0f\t %2.0f\t %2.0f\t %1.0f\t %7.0f\t %1.0f\t %7.0f\t';
    
    Preamble(1,1) =cellstr(['Completeness log file for hhour data for site: ' site ', year ' num2str(yr_ctr)]);
    Pre_char = char(Preamble);
    % Preamble(2,1) =cellstr('All variables are listed in EST timecode (GMT-5)');
    % Preamble(3,1) =cellstr('Variable Explanation: ');
    tmp = datestr(now); timestamp = tmp(1:11); clear tmp;
    
    fid = fopen([log_path site '_hhour_complete_check_' num2str(yr_ctr) '_' timestamp '.dat'],'w');
    log_names{ctr,2} = [log_path site '_hhour_complete_check_' num2str(yr_ctr) '_' timestamp '.dat'];
    for i = 1:1:length(Preamble)
        h3 = fprintf(fid,['%' num2str(length(Pre_char)) 's\n'],Pre_char(i,:));
    end
    
    
    for j = 1:1:length(A)
        h = fprintf(fid, '%18s\t' , AA(j,:) );
    end
    
    
    for j = 1:1:length(file_list)
        h2 = fprintf(fid,format_code,final_hhour(j,:));
    end
    
    fclose(fid);
    
    disp(['Finished for year ' yr_str]);
    ctr = ctr+1;
end

%         tmp_name =
% [pathstr, name, ext, versn] = fileparts(d2(j).name);
% % [pathstr, name, ext, versn] = fileparts(filename)
%  = cellstr(name);

disp(['Done!  You can find the log file at: ' log_path]);
jjb_play_sounds('done');
if display_flag == 1
    try
        unix(['gnumeric ' log_path site '_hhour_complete_check_' num2str(yr_ctr) '_' timestamp '.dat' ])
        unix(['gnumeric ' log_path site '_HFdata_complete_check_' num2str(yr_ctr) '_' timestamp '.dat' ])
        
    catch
    end
end
