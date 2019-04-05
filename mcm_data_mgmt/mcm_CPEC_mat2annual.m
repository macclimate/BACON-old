function [] = mcm_CPEC_mat2annual(year, site,quickflag)
%%% mcm_CPEC_mat2annual.m
%%% This function extacts data in the separate /hhour data files, and places them in an 
%%% annual data file. 

if nargin == 1
    site = year;
    year = [];
    quickflag = 0;
end
if nargin ==2 
    quickflag = 0;
end
[year_start year_end] = jjb_checkyear(year);
% 
% elseif nargin == 2
%     if numel(year) == 1 || ischar(year)==1
%         if ischar(year)
%             year = str2double(year);
%         end
%         year_start = year;
%         year_end = year;
%     end
% end
% 
% if isempty(year)==1
%     year_start = input('Enter start year: > ');
%     year_end = input('Enter end year: > ');
% end


%%%% TO BE REMOVED AFTER OPERATIONAL:
%  year = 2008;
% % site = 'TP74';
% site = 'TP02';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Paths and Tags:
% switch site
%     case 'TP39';        tag = 'hMCM1.mat';
%     case 'TP74';        tag = 'hMCM2.mat';
%     case 'TP02';        tag = 'hMCM3.mat';
% end
tag = mcm_get_fluxsystem_info(site, 'hhour_extensions');

loadstart = addpath_loadstart;
% log_path = [loadstart '/SiteData/logs/'];
log_path = [loadstart '/Documentation/Logs/mcm_mat2annual/']; % Changed 01-May-2012
load_path = [loadstart 'SiteData/' site '/MET-DATA/'];
save_path = [loadstart 'SiteData/' site '/MET-DATA/annual/'];
jjb_check_dirs(save_path, abs(quickflag));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part makes sure that the files in /TP39/hhour and
% /hhour_field have the right extension (not the old one -.hHJP02.mat)
switch site
    case 'TP39'
        eval(['cd ' load_path 'hhour_field/']); 
        unix('pwd');
        [status,result] = unix('rename -v ''s/\.hHJP02.mat/\.hMCM1.mat/'' *.hHJP02.mat','-echo');
        if strncmp(result,'Can''t rename',12) ~=1;
           disp('Some files may have been renamed at /TP39/hhour_field/ (.hHJP02.mat --> .hMCM1.mat)');
        end
        
        eval(['cd ' load_path 'hhour/']); 
        unix('pwd');
        [status2,result2] = unix('rename -v ''s/\.hHJP02.mat/\.hMCM1.mat/'' *.hHJP02.mat','-echo');
        if ~isempty(result2);
           disp('Some files may have been renamed at /TP39/hhour/ (.hHJP02.mat --> .hMCM1.mat)');
        end

        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%
%% Get information about the variables (paths and names)
% vars = struct;
% vars_backup = struct;
% vars = mcm_get_varnames(site);
vars = mcm_get_fluxsystem_info(site, 'varnames');

%%%%%%%%%%%%%%%%%%%%%%%%%

fignum_ctr = 1;
for year_ctr = year_start:1:year_end
    close all;
tic;

yr_str = num2str(year_ctr);
YY = yr_str(3:4);
disp(['Working on year ' yr_str '.']);

%%% Make NaNs in all data places:

[Mon Day] = make_Mon_Day(year_ctr, 1440);
if isleapyear(year_ctr) == 1; num_days = 366; else num_days = 365; end
hhour_output = NaN.*ones(48.*num_days,length(vars));
hhour_field_output = NaN.*ones(48.*num_days,length(vars));
%% Load data file tracker if it exists... If not, make a new one:
if exist([log_path site '_hhour_tracker_' yr_str '.dat'],'file') == 2;
    hhour_tracker = load([log_path site '_hhour_tracker_' yr_str '.dat']);
else
    hhour_tracker = NaN.*ones(num_days,4);
end

%%% Make the tracker list for both /hhour and /hhour_field:
for k = 1:1:num_days
    MM = create_label(Mon(k,1),2); DD = create_label(Day(k,1),2);
    datastr(k,:) = [YY MM DD];
    hhour_tracker(k,1) = str2double(datastr(k,:));
    hhour_tracker(k,2) = ceil(exist([load_path 'hhour/' datastr(k,:) '.' tag])./10);
    hhour_tracker(k,3) = ceil(exist([load_path 'hhour_field/' datastr(k,:) '.' tag])./10);
    hhour_tracker(k,4) = ceil((hhour_tracker(k,2)+hhour_tracker(k,3))./10);
    clear MM DD;
end

disp('Working.... Please wait...(This may take ~5 minutes)')

%%% start loading in files and placing them in the master:
for j = 1:1:num_days
% disp(datastr(j,:));
         if j  == 144;
         disp('stop. hammer time');
         end
    %%%%%%% Loop for Processed hhour files
    if hhour_tracker(j,2) == 1;
        try
%             disp('top')
            tmp_hhour = load([load_path 'hhour/' datastr(j,:) '.' tag]);
            for hh_ctr = 1:1:48
                for i = 1:1:length(vars)
                    try
                        hhour_output(j.*48 + hh_ctr - 48,i) = eval(['tmp_hhour.Stats(1,hh_ctr).' vars(i).path]);
                    catch
                        hhour_output(j.*48 + hh_ctr - 48,i) = NaN;
                    end
                end
            end

        catch
            hhour_output(j*48-47 : j*48 ,:) = NaN;
            disp(['For some reason, ' load_path 'hhour/' datastr(j,:) '.' tag ' did not load - may be corrupt']);
        end
    else
        hhour_output(j*48-47 : j*48 ,:) = NaN;
    end
    clear tmp_hhour
    %%%%%%%%%%% Loop for field hhour files:
    if hhour_tracker(j,3) == 1;
        try
%                   disp('bottom')
            tmp_hhour_field = load([load_path 'hhour_field/' datastr(j,:) '.' tag]);
            for hh_ctr = 1:1:48
                for i = 1:1:length(vars)
                    try
                        hhour_field_output(j.*48 + hh_ctr - 48,i) = eval(['tmp_hhour_field.Stats(1,hh_ctr).' vars(i).path]);
                    catch
                        hhour_field_output(j.*48 + hh_ctr - 48,i) = NaN;
                    end
                end
            end
        catch
            hhour_field_output(j*48-47 : j*48 ,:) = NaN;
            disp(['For some reason, ' load_path 'hhour_field/' datastr(j,:) '.' tag ' did not load - may be corrupt']);
        end

    else
        hhour_field_output(j*48-47 : j*48 ,:) = NaN;
    end
    clear tmp_hhour_field;

    %%%% Display an update on progress every 100 days:
    if rem(j,100) == 0;   disp(['Working on Day: ' num2str(j)]);   end

end

ctr = 1;
for k = 1:48:length(hhour_output);
    x_tick(ctr,1) = k;
x_tick_label(ctr,:) = datastr(ctr,:);
ctr = ctr+1;
end

if quickflag == 1
    fill_resp = 1;
elseif quickflag == -1
    fill_resp = [];
else
figure(99);clf;
plot(hhour_field_output(:,1),'r'); hold on;
plot(hhour_output(:,1)); hold on;
legend ('hhour-field','hhour-lab');
disp('Please look at figure 99')
disp('Fill in gaps in ''hhour-lab'' data with ''hhour-field'' data?');
commandwindow;
fill_resp = input('<1> to fill, <enter> to skip: > '); 
end

sbplot_ctr = 1;
for j = 1:1:length(vars)
    tmp_hhour_data = hhour_output(:,j);
    tmp_hhour_field_data = hhour_field_output(:,j);

    %%% Fill in the gaps in the 'lab' data with data in the 'field' data:
if fill_resp == 1
    tmp_hhour_data(isnan(tmp_hhour_data),1) = tmp_hhour_field_data(isnan(tmp_hhour_data),1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% This is a very special case, where for some reason, the hhour data
    %%%% from the field for the first part of 2008 is much better than the
    %%%% lab-calculated data.  So, we'll replace all of this data:
    switch site
        case 'TP74'
            if year_ctr == 2008 && j == 1
                tmp_hhour_data(1:3457,1) = tmp_hhour_field_data(1:3457,1);
            end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
    %%% Print data to file:
    save([save_path site '_' yr_str '.' vars(j).name],'tmp_hhour_data','-ASCII');

%%% Plot figures:
if quickflag == 0
    figure(fignum_ctr);
    subplot(4,2,sbplot_ctr)
    plot(tmp_hhour_field_data,'r.-');
    hold on;
    plot(tmp_hhour_data,'b.-');
    legend('hhour-field','hhour-lab');
title([vars(j).name ', ' yr_str]);
set(gca,'XTick',x_tick);
set(gca,'XTickLabel',x_tick_label);
end
    clear tmp_hhour_data tmp_hhour_field_data;
%%% advance the figure number if we've just plotted 8th subplot on figure:
if sbplot_ctr == 8
fignum_ctr = fignum_ctr+1;
sbplot_ctr = 1;
else
    sbplot_ctr = sbplot_ctr+1;
end

end
t = toc;

disp(['One Year done in ' num2str(t/60) ' minutes.']);
end
if quickflag == 0
mcm_start_mgmt;
end
