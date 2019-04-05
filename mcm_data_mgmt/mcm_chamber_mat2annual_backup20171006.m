function [] = mcm_chamber_mat2annual(year, site,quickflag)

if nargin == 1
    site = year;
    year = [];
end
if nargin == 2
    quickflag = 0;
end
[year_start year_end] = jjb_checkyear(year);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Paths and Tags -- add more to these as move to more sites:
% switch site
%     case 'TP39_chamber';
%         tag = 'ACS_Flux_16.mat';
%         maxNch = 8; % maximum number of chambers
%         num_samples = 3; % number of samples per chamber per hhour
% end

tag = mcm_get_fluxsystem_info(site,'hhour_extensions');
tmp = mcm_get_fluxsystem_info(site,'chamber_settings');
maxNch = tmp.maxNch;
num_samples = tmp.num_samples;
clear tmp;

loadstart = addpath_loadstart;
% log_path = [loadstart '/SiteData/logs/'];
log_path = [loadstart '/Documentation/Logs/mcm_mat2annual/']; % Changed 01-May-2012
load_path = [loadstart 'SiteData/' site '/MET-DATA/'];
save_path = [loadstart 'SiteData/' site '/MET-DATA/annual/'];
jjb_check_dirs(save_path,abs(quickflag));

%% Enter information about the variables (paths and names)
% vars = struct;
% vars = mcm_get_varnames(site);
vars = mcm_get_fluxsystem_info(site, 'varnames');

if quickflag == 0
    %%% Ask if user would like to fill gaps from field data
    commandwindow;
    resp = input('Fill gaps in recalc data using field data? <y/n>','s');
    %%% Ask if user would like to plot the data:
    plot_resp = input('Would you like to quickly plot the data? <y/n>','s');
elseif quickflag == 1
    resp = 'y';
    plot_resp = 'n';
elseif quickflag == -1
    resp = 'n';
    plot_resp = 'n';
end
fignum_ctr = 1;
for year_ctr = year_start:1:year_end
    
    yr_str = num2str(year_ctr);
    YY = yr_str(3:4);
    disp(['Working on year ' yr_str '.']);
    
    [Mon Day] = make_Mon_Day(year_ctr, 1440);
    if isleapyear(year_ctr) == 1; num_days = 366; else num_days = 365; end
    hhour = struct;
    hhour_field = struct;
    % hhour_output = NaN.*ones(48.*num_days,length(vars));
    % hhour_field_output = NaN.*ones(48.*num_days,length(vars));
    
    %% Load data file tracker if it exists... If not, make a new one:
    if exist([log_path site '_hhour_tracker_' yr_str '.dat'],'file') == 2;
        hhour_tracker = load([log_path site '_hhour_tracker_' yr_str '.dat']);
        old_hhour_tracker = hhour_tracker;
    else
        hhour_tracker = NaN.*ones(num_days,4);
        old_hhour_tracker = zeros(num_days,4);
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
    %     %%% Save the tracker file:
    %     save([log_path site '_hhour_tracker_' yr_str '.dat'],'hhour_tracker','-ASCII');
    %%% Compare the old and new hhour_trackers to see what's new:
    % -- do this later if the new computer is still really slow at processing
    % hhour files...
    hhour_tracker_to_save = hhour_tracker;
    [r_diff c_diff] = find(old_hhour_tracker ~= hhour_tracker);
    % diffs = old_hhour_tracker - hhour_tracker;
    
    if ~isempty(r_diff)
        if quickflag == -1
            resp_recalc = 1  ;
        elseif quickflag == 1;
            resp_recalc = [];
        else
            commandwindow;
            resp_recalc = input('Enter <1> to re-compile all data or hit <enter> to add new data only (faster)');
        end
    else
        if quickflag == -1
            resp_recalc = 1;
        elseif quickflag == 1;
            resp_recalc = [];
        else
            % resp_recalc = [];
            resp_recalc = input('No new data found: Enter <1> to re-compile all, or hit <enter> to skip through');
        end
    end
    
    if isempty(resp_recalc) == 1
        %%% Load the master files:
        load([save_path site '_' yr_str '_recalc.mat']);
        load([save_path site '_' yr_str '_field.mat']);
        
        hhour_tracker(:,2:4) = zeros(num_days,3);
        for j = 1:1:length(r_diff)
            hhour_tracker(r_diff(j), c_diff(j)) = 1;
        end
    else
        for i = 1:1:maxNch
            hhour(i).results(1:num_days*48,1:15) = NaN;
            hhour_field(i).results(1:num_days*48,1:15) = NaN;
        end
    end
    
    
    
    
    %% Main Loop - Load files from /hhour (processed) and place in master:
    for j = 1:1:num_days
        disp(datastr(j,:));
        if hhour_tracker(j,2) == 1; % make sure the hhour file is there
            try
                tmp_hhour = load([load_path 'hhour/' datastr(j,:) '.' tag]);
                for hh_ctr = 1:1:48 %cycle through half-hours
                    for ch_ctr = 1:1:maxNch % cycle through chambers
                        for smpl_ctr = 1:1:num_samples % cycle through samples
                            for var_ctr = 1:1:length(vars)
                                %%% If the first condition in the try loop
                                %%% works, then we know we're processing
                                %%% chamber data.  Otherwise, it's CPEC
                                %%% data.
                                try
                                    tmp(smpl_ctr,var_ctr) = eval(['tmp_hhour.HHour(hh_ctr).Chamber(ch_ctr).Sample(smpl_ctr).' vars(var_ctr).path]);
                                catch
                                    tmp(smpl_ctr,var_ctr) = NaN;
                                end
                            end
                        end
                        tmp_avg = nanmean(tmp); % take the nanmean of the 3 samples
                        hhour(ch_ctr).results(j.*48 + hh_ctr - 48,1:var_ctr) = tmp_avg;
                        clear tmp_avg tmp;
                    end
                end
            catch
                disp(['Problem loading ' load_path 'hhour/' datastr(j,:) '.' tag]);
                disp('Check if file exists, but is 0 bytes.  If so, delete it');
            end
            
        end
        
        
        %% Main Loop2 - Load files from /hhour_field (processed) and place in master:
        if hhour_tracker(j,3) == 1; % make sure the hhour file is there
            try
                tmp_hhour_field = load([load_path 'hhour_field/' datastr(j,:) '.' tag]);
                for hh_ctr = 1:1:48 %cycle through half-hours
                    for ch_ctr = 1:1:maxNch % cycle through chambers
                        for smpl_ctr = 1:1:num_samples % cycle through samples
                            for var_ctr = 1:1:length(vars)
                                try
                                    tmp(smpl_ctr,var_ctr) = eval(['tmp_hhour_field.HHour(hh_ctr).Chamber(ch_ctr).Sample(smpl_ctr).' vars(var_ctr).path]);
                                catch
                                    tmp(smpl_ctr,var_ctr) = NaN;
                                end
                            end
                        end
                        tmp_avg = nanmean(tmp); % take the nanmean of the 3 samples
                        hhour_field(ch_ctr).results(j.*48 + hh_ctr - 48,1:var_ctr) = tmp_avg;
                        clear tmp_avg tmp;
                    end
                end
            catch
                disp(['Problem loading ' load_path 'hhour_field/' datastr(j,:) '.' tag]);
                disp('Check if file exists, but is 0 bytes.  If so, delete it');
            end
        end
        %%%% Display an update on progress every 100 days:
        if rem(j,100) == 0;   
            disp(['Working on Day: ' num2str(j)]);   
        end
    end
    %% Give option to fill in NaN data in recalc data with data calculated in
    %%% the field -- This is useful if /data files are missing for some reason,
    %%% or, data files are corrupt, etc.
    % resp = input('Fill gaps in recalc data using field data? <y/n>','s');
    if strcmp(resp,'y')==1
        for k = 1:1:maxNch
            [r_ind c_ind] = find(isnan(hhour(k).results)==1);
            hhour(k).results(r_ind,c_ind) = hhour_field(k).results(r_ind,c_ind);
            clear r_ind c_ind;
        end
        disp('data copied from field data successfully');
    else
        disp('data not copied from field data');
    end
    
    %% Export columns from each chamber to file:
    
    for ch_ctr = 1:1:maxNch
        for var_ctr = 1:1:length(vars)
            tmp_out = hhour(ch_ctr).results(:,var_ctr);
            tmp_tag = vars(var_ctr).name;
            save([save_path site '_' yr_str '.C' num2str(ch_ctr) '_' tmp_tag],'tmp_out','-ASCII')
            clear tmp_out tmp_tag;
        end
    end
    
    %% Also export all similar variables to same matrix files:
    for var_ctr = 1:1:length(vars)
        for ch_ctr = 1:1:maxNch
            tmp_out2(:,ch_ctr) = hhour(ch_ctr).results(:,var_ctr);
            tmp_tag2 = vars(var_ctr).name;
            save([save_path site '_' yr_str '.' tmp_tag2 '_all'],'tmp_out2','-ASCII')
        end
        clear tmp_out2 tmp_tag2;
    end
    
    %% Save the .mat files:
    save([save_path site '_' yr_str '_recalc.mat'],'hhour');
    save([save_path site '_' yr_str '_field.mat'],'hhour_field');
    
    %% Save the tracker file:
    save([log_path site '_hhour_tracker_' yr_str '.dat'],'hhour_tracker_to_save','-ASCII');
    
    %% Finally, give the user the opportunity to plot the data quickly:
    % plot_resp = input('Would you like to quickly plot the data? <y/n>','s');
    close all;
    
    if strcmp(plot_resp,'y') == 1;
        sbplot_ctr = 1;
        for var_ctr = 1:1:length(vars)
            for ch_ctr = 1:1:maxNch
                tmp_out2(:,ch_ctr) = hhour(ch_ctr).results(:,var_ctr);
                tmp_tag2 = vars(var_ctr).name;
                
            end
            figure(fignum_ctr);
            subplot(4,2,sbplot_ctr)
            
            plot(tmp_out2);hold on;
            title([tmp_tag2 ', ' yr_str]);
            if maxNch < 10
                legend(num2str((1:1:ch_ctr)'));
            end
            clear tmp_out2 tmp_tag2;
            if sbplot_ctr == 8
                fignum_ctr = fignum_ctr+1;
                sbplot_ctr = 1;
            else
                sbplot_ctr = sbplot_ctr+1;
            end
            
        end
        
    end
    
end
if quickflag == 0
mcm_start_mgmt;
end
