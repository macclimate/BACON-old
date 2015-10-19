function [] = mcm_wx_averaging(year_in,labels)

ls = addpath_loadstart;
data_path = [ls 'Matlab/Data/CCP/CCP_output/CCP_Annual_Files/MCM_WX/'];

% data = importdata([data_path 'MCM_WX_Met_Stn_Met2_' num2str(year_in) '.csv'],',');
[data, result]= readtext([data_path 'MCM_WX_Met_Stn_Met2_' num2str(year_in) '.csv'],',');

% Extract the data from the file:
insides = cell2mat(data(3:end,9:end-2));
insides(insides==-999) = NaN;

%%% Sort out which rows are sample, min, max, avg, sum
cols_to_export = find(strcmp(labels(:,4),'met')==1 & strcmp(labels(:,6),'Met2')==1);

% Just a check to make sure we're synced up:
if size(insides,2) ~= size(cols_to_export,1)
    disp('possible error in mcm_wx_averaging -- check that size(insides,2)= size(cols_to_export,1)');
end

export_command = labels(cols_to_export,8);
% ind_avg = 8 + find(strcmp(export_command(:,1),'avg')==1);
% ind_min = 8 + find(strcmp(export_command(:,1),'min')==1);
% ind_max = 8 + find(strcmp(export_command(:,1),'max')==1);
% ind_sum = 8 + find(strcmp(export_command(:,1),'sum')==1);

numrows_hr = (size(data,1)-2)/4;
numrows_day = (size(data,1)-2)/(4*24);

%% Hourly file
% Write the first two rows and Sample the first 8 columns:

data_hr(1:2,:) = data(1:2,:);
data_hr(3:2+numrows_hr,1:3) = data(4:4:end,1:3);
data_hr(3:end,4:8) = data(6:4:end,4:8);
data_hr(3:end,end-1:end) = data(6:4:end,end-1:end);


hr_avg = NaN.*ones(size(insides,1)/4,size(insides,2));
hr_min = NaN.*ones(size(insides,1)/4,size(insides,2));
hr_max = NaN.*ones(size(insides,1)/4,size(insides,2));
hr_sum = NaN.*ones(size(insides,1)/4,size(insides,2));

ctr = 1;
for i = 1:4:size(insides,1)
    hr_avg(ctr,:) = mean(insides(i:i+3,:));
    hr_max(ctr,:) = nanmax(insides(i:i+3,:));
    hr_min(ctr,:) = nanmin(insides(i:i+3,:));
    hr_sum(ctr,:) = sum(insides(i:i+3,:));
    %     data_hr(2+i,9:end-2) = num2cell(mean(insides(i:i+3,:)));
    ctr = ctr + 1;
end

for i = 1:1:length(export_command)
    switch export_command{i}
        case 'avg'
            data_hr(3:end,i+8) = num2cell(hr_avg(:,i));
        case 'min'
            data_hr(3:end,i+8) = num2cell(hr_min(:,i));
        case 'max'
            data_hr(3:end,i+8) = num2cell(hr_max(:,i));
        case 'sum'
            data_hr(3:end,i+8) = num2cell(hr_sum(:,i));
    end
    
end

%% Daily file

data_day(1:2,:) = data(1:2,:);
data_day(3:2+numrows_day,1:3) = data(98:(4*24):end,1:3);
data_day(3:end,4:8) = data(98:(4*24):end,4:8);


day_avg = NaN.*ones(size(insides,1)/(4*24),size(insides,2));
day_min = NaN.*ones(size(insides,1)/(4*24),size(insides,2));
day_max = NaN.*ones(size(insides,1)/(4*24),size(insides,2));
day_sum = NaN.*ones(size(insides,1)/(4*24),size(insides,2));

ctr = 1;
for i = 1:96:size(insides,1)
    day_avg(ctr,:) = mean(insides(i:i+95,:));
    day_max(ctr,:) = nanmax(insides(i:i+95,:));
    day_min(ctr,:) = nanmin(insides(i:i+95,:));
    day_sum(ctr,:) = sum(insides(i:i+95,:));
    ctr = ctr + 1;
end


for i = 1:1:length(export_command)
    switch export_command{i}
        case 'avg'
            data_day(3:end,i+8) = num2cell(day_avg(:,i));
        case 'min'
            data_day(3:end,i+8) = num2cell(day_min(:,i));
        case 'max'
            data_day(3:end,i+8) = num2cell(day_max(:,i));
        case 'sum'
            data_day(3:end,i+8) = num2cell(day_sum(:,i));
    end
    
end

%% Now, Output these to the /CCP folder:
dlmcell([data_path 'MCM_WX_Met_Stn_Met2_' num2str(year_in) '_Hourly.csv'],data_hr,',');
dlmcell([data_path 'MCM_WX_Met_Stn_Met2_' num2str(year_in) '_Daily.csv'],data_day,',');

