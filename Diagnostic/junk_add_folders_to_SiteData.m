%

% target_dir = '/1/fielddata/SiteData/TP39/MET-DATA/data/';
% st_year = 2002;
% end_year = 2005;
%
% % d_target = dir(target_dir);
% % Make folders for 2006 all the way to 2008
% yr_tag = []; mon_tag = []; day_tag = [];
%
% for year = st_year:1:end_year
%     year_str = num2str(year);
%     [Mon Day] = make_Mon_Day(year,1440);
% %     yr_tag_temp(1:length(Mon),1:2) = year_str(3:4);
% %     yr_tag = [yr_tag; yr_tag_temp];
%
%     for k = 1:1:length(Mon)
%        yr_tmp(k,1:2) = year_str(3:4);
%        mon_tmp = num2str(Mon(k,1));
%        day_tmp = num2str(Day(k,1));
%
%        if length(mon_tmp)==1;
%            mon_tmp = ['0' mon_tmp];
%        end
%        if length(day_tmp)==1;
%            day_tmp = ['0' day_tmp];
%        end
%
%        mon_tag = [mon_tag; mon_tmp];
%        day_tag = [day_tag; day_tmp];
%
%        clear mon_tmp day_tmp;
%     end
%        yr_tag = [yr_tag; yr_tmp];
%
% end
%
% %%% Makes folders in /SiteData/TP39 for 2006--2008 if needed:
% for j = 1:1:length(yr_tag)
%    if exist([target_dir yr_tag(j,:) mon_tag(j,:) day_tag(j,:)],'dir')==7
%    else
%    unix(['mkdir ' target_dir yr_tag(j,:) mon_tag(j,:) day_tag(j,:)])
%    disp(['Created folder ' yr_tag(j,:) mon_tag(j,:) day_tag(j,:)])
%    end
% end

% d = dir('/media/Deskie/FieldDell_backups/D_Drive_Copy_Jan_2010/met-data/data/');
%   source_path = '/1/fielddata/DUMP_Data/TP39/Data_to_sort_2002--2005/CPEC/data_20';

%% For transporting 2006--2008 data from Deskie
%   source_path = '/media/Deskie/FieldDell_backups/D_Drive_Copy_Jan_2010/met-data/data/';
% d = dir(source_path);
% for j = 3:1:length(d)
% dspot = find(d(j,1).name == '.');
%
% if strcmp(d(j,1).name(dspot+1:end),'DMCM5') == 1 || strcmp(d(j,1).name(dspot+1:end),'DMCM4') == 1
% folder_name = d(j,1).name(1:6);
% [s,w] = unix(['cp ' source_path d(j,1).name ' ' target_dir folder_name '/' d(j,1).name]);
%     if s == 0; disp(['copied file: ' d(j,1).name]);else disp(['problem with: ' d(j,1).name]); end
%
% % elseif strncmp(d(j,1).name(dspot+1:end),'CS',2) == 1 || ...
% %         strncmp(d(j,1).name(dspot+1:end),'LI',2) == 1 || strncmp(d(j,1).name(dspot+1:end),'TC',2) == 1
%
% else
%     disp(['did not copy file: ' d(j,1).name]);
% end
% end
%
%% For transporting 2002--2005 data from DUMP_Data
target_dir = '/1/fielddata/SiteData/TP39/MET-DATA/data/';
source_path = '/1/fielddata/DUMP_Data/TP39/Data_to_sort_2002--2005/CPEC/data_2005/';
d = dir(source_path);
good_file_ctr = 0;
for j = 3:1:length(d)
    dspot = find(d(j,1).name == '.');
    
    if strcmp(d(j,1).name(dspot+1:end),'DMCM5') == 1 || strcmp(d(j,1).name(dspot+1:end),'DMCM4') == 1
        folder_name = d(j,1).name(1:6);
    elseif strncmp(d(j,1).name(1:2),'CS',2) == 1 || strncmp(d(j,1).name(1:2),'LI',2) == 1 || strncmp(d(j,1).name(1:2),'TC',2) == 1
                folder_name = d(j,1).name(3:8);
    else
        folder_name = '';
    end
    
%     if strncmp(d(j,1).name(1:2),'CS',2) == 1 || strncmp(d(j,1).name(1:2),'LI',2) == 1 || strncmp(d(j,1).name(1:2),'TC',2) == 1
%                 folder_name = d(j,1).name(3:8);
%     else 
%         folder_name = '';
%     end
    
    if ~isempty(folder_name)==1;
        [s,w] = unix(['cp ' source_path d(j,1).name ' ' target_dir folder_name '/' d(j,1).name]);
         if s == 0; good_file_ctr = good_file_ctr+1;%disp(['copied file: ' d(j,1).name]);
         else disp(['problem with: ' d(j,1).name]); end

    else 
        disp(['did not copy file: ' d(j,1).name]);
    end
end
        
    disp(['succesfully copied ' num2str(good_file_ctr) ' data files.']);    
%         
%         
%     elseif strncmp(d(j,1).name(dspot+1:end),'CS',2) == 1 || strncmp(d(j,1).name(dspot+1:end),'LI',2) == 1 || strncmp(d(j,1).name(dspot+1:end),'TC',2) == 1
%         folder_name = d(j,1).name(3:8);
%         [s,w] = unix(['cp ' source_path d(j,1).name ' ' target_dir folder_name '/' d(j,1).name]);
%         if s == 0; disp(['copied file: ' d(j,1).name]);else disp(['problem with: ' d(j,1).name]); end
%         
%         
%     else
%         disp(['did not copy file: ' d(j,1).name]);
%     end
% end

%     path = [target_dir folder_name '/'];
%     if exist([

