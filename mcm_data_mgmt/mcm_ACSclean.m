function [] = mcm_ACSclean(year, site, auto_flag)

ls = addpath_loadstart;
num_ch = 8; % number of chambers.
%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
    auto_flag = 0; % flag that determines if we're in automated mode or not
elseif nargin == 2
    auto_flag = 0; % flag that determines if we're in automated mode or not
end
[year_start year_end] = jjb_checkyear(year);

% if isempty(year)==1
%     year = input('Enter year(s) to process; single or sequence (e.g. [2007:2010]): >');
% elseif ischar(year)==1
%     year = str2double(year);
% end
% 
% if numel(year)>1
%     year_start = min(year);
%     year_end = max(year);
% else
%     year_start = year;
%     year_end = year;
% end
%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%%

%%% Declare Paths:
load_path = [ls 'SiteData/' site '/MET-DATA/annual/'];
output_path = [ls 'Matlab/Data/Flux/ACS/' site '/Cleaned/'];
jjb_check_dirs(output_path, auto_flag);
% header_path = [ls 'Matlab/Data/Flux/CPEC/Docs/'];
thresh_path = [ls 'Matlab/Config/Flux/ACS/Cleaning-Thresholds/']; % Changed 01-May-2012
jjb_check_dirs(thresh_path,auto_flag);
% Load Header:
% header_old = jjb_hdr_read([thresh_path 'mcm_CPEC_Header_Master.csv'], ',', 3);
% header_tmp = mcm_get_varnames(site);
header_tmp = mcm_get_fluxsystem_info(site, 'varnames');

t = struct2cell(header_tmp);
t2 = t(2,1,:); t2 = t2(:);
% Column vector number
col_num = (1:1:length(t2))';
header = mat2cell(col_num,ones(length(t2),1),1);
header(:,2) = t2;
%%%% Take information from columns of the header file
% col_num = str2num(num2str(header(:,1)));
% col_num = str2num(char(header(:,1)));

% Title of variable
var_names = char(header(:,2));


%% Main Loop

for year_ctr = year_start:1:year_end
    close all
    if auto_flag == 1
    skipall_flag = 1;
    else
    skipall_flag = 0;
    end
    yr_str = num2str(year_ctr);
    disp(['Working on year ' yr_str '.']);
    
    
    %%% Create a blank output matrix:
    if isleapyear(year_ctr) == 1;
        len_yr = 17568;
    else
        len_yr = 17520;
    end
    
    num_vars = max(col_num);
%     save_output = NaN.*ones(len_yr,num_vars);
    
    %% Run through the variables first, so that we can see what may need to be
    %%% changed:
   
    for k = 1:1:num_vars
        try
            save_output{k} = load([load_path site '_' yr_str '.' char(header{k,2}) '_all']);
%             save_output(:,k) = load([load_path site '_' yr_str '.' char(header{k,2}) '_all']);
        catch
            save_output{k} = NaN.*ones(len_yr,8);
            disp(['Variable "' char(header{k,2}) '" was not processed.']);
            
        end
    end
    
    %%%%%%%%% We need while loops for each variable - cycle through all 8
    %%%%%%%%% chambers: 
    
    quitflag = 0;
    while quitflag == 0;
        k = 1;
        while k <=num_vars
        j = 1;
        while j <= num_ch
            temp_var = save_output{k}(:,j);
            figure(1)
            clf;
            plot(temp_var);
            hold on;
            title([var_names(k,:) ', Chamber ' num2str(j)]);
            grid on;
            
            %% Gives the user a chance to change the thresholds
            if auto_flag == 1
                response = 'q';
            else
                response = input('Press enter to move forward, enter "1" to move backward, q to go straight to cleaning: ', 's');
            end
                     
            if isempty(response)==1
                j = j+1;
                
            elseif strcmp(response,'1')==1 && j > 1;
                j = j-1;
            elseif strcmp(response,'q')==1
                j = num_ch+1;
                k = num_vars+1;
            else
                j = 1;
            end
        end
        
        clear j response accept
        k=k+1;
        end
        
        %% Load Threshold file -- If it does not exist, start creating one
        if exist([thresh_path site '_thresh_' yr_str '.csv'])
            thresh = csvread([thresh_path site '_thresh_' yr_str '.csv']);
            threshflag = 1;
            thresh_out_flag = 0;
            disp('Threshold file exists: Uploading');
            
        else
            commandwindow;
            disp('Threshold file does not exist.');
            if auto_flag == 1
                thresh_resp = 1;
            else
            thresh_resp = input('Enter <1> to use previous year''s, or <0> to use blank thresholds');
            end
            if thresh_resp == 1;
                try
                    unix(['cp ' thresh_path site '_thresh_' num2str(year_ctr-1) '.csv ' thresh_path site '_thresh_' yr_str '.csv'])
                    disp('Using Previous Year''s Thresholds');
                    thresh = load([thresh_path site '_thresh_' yr_str '.csv']);
                    threshflag = 1;
                    thresh_out_flag = 0;
                catch
                    thresh(1:num_vars*num_ch,1:4) = NaN;
                    tmp = (repmat(col_num,1,num_ch))';
                    thresh(:,1) = tmp(:);
                    thresh(:,2) = repmat((1:1:num_ch)',num_vars,1);
                    thresh_out_flag = 1;
                    threshflag = 0;
                    disp('Blank Threshold File Created');
                end
            else
                thresh(1:num_vars*num_ch,1:4) = NaN;
                tmp = (repmat(col_num,1,num_ch))';
                thresh(:,1) = tmp(:);
                thresh(:,2) = repmat((1:1:num_ch)',num_vars,1);
                threshflag = 0;
                thresh_out_flag = 1;
                disp('Blank Threshold File Created');
            end
        end
        
        %%% Check if the threshold file is the right length.  If it's too
        %%% short, we'll add some lines to it:
%         if size(thresh,1) < size(col_num,1)
%            rows_to_add(:,1) =  col_num(size(thresh,1)+1:end);
%            thresh = [thresh; [col_num(rows_to_add) zeros(length(rows_to_add),1) ones(length(rows_to_add),1)]];            
%            thresh_out_flag = 1;
%         end
        
        %% A quick fix that needs to be done before cleaning (most fixing should be
        %%% done following cleaning with mcm_fluxfixer.m
        switch site
%             case 'TP39'
%               switch yr_str
% 
%                 case '2002'
%                 % T_irga and P_irga are switched until April 2004:
%                 T_tmp = save_output(:,27); P_tmp = save_output(:,28);
%                 save_output(:,27) = P_tmp;
%                 save_output(:,28) = T_tmp;
%                 clear P_tmp T_tmp;
%             case '2003'
%                 % T_irga and P_irga are switched until April 2004:
%                 T_tmp = save_output(:,27); P_tmp = save_output(:,28);
%                 save_output(1:4945,27) = P_tmp(1:4945,1);
%                 save_output(1:4945,28) = T_tmp(1:4945,1);
%                 clear P_tmp T_tmp;
%               end
%             case 'TP74'
%                 switch yr_str
%                     case '2009'
%                         save_output(5985:6800,[1 7]) = save_output(5985:6800,[1 7]).*-1;
%                 end
%             case 'TP89'
%             case 'TP02'
        end
        %% Load file, plot it, and give cleaning options
        for i = 1:1:num_vars
            for j = 1:1:num_ch
            accept = 1;
            %         temp_var = load([load_path site '_' year '.' vars30_ext(i,:)]);
            figure(1)
            clf;
            plot(save_output{i}(:,j));
            hold on;
            title([var_names(i,:) ', Chamber ' num2str(j)]);
            grid on;
            switch threshflag
                case 1
                    %%% Load lower and upper limits
                    thresh_row = find(thresh(:,1) == i & thresh(:,2) == j);  %% Select correct row in thresh
                    low_lim = thresh(thresh_row,3);
                    up_lim = thresh(thresh_row,4);
                    
                case 0
                    low_lim_str = input('Enter Lower Limit: ', 's');
                    low_lim = str2double(low_lim_str);
                    
                    up_lim_str = input('Enter Upper Limit: ', 's');
                    up_lim = str2double(up_lim_str);
                    
                    %%% Write new values to thresh matrix
                    thresh_row = find(thresh(:,1) == i & thresh(:,2) == j);  %% Select correct row in thresh
                    thresh(thresh_row,3) = low_lim;
                    thresh(thresh_row,4) = up_lim;
                    
            end
            
            %%% Plot lower limit
            line([1 length(save_output{i}(:,j))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
            %%% Plot upper limit
            line([1 length(save_output{i}(:,j))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')
            
            axis([1   length(save_output{i}(:,j))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
            title([var_names(i,:) ', Chamber ' num2str(j)]);
            
            if skipall_flag == 0
                %%% Gives the user a chance to change the thresholds
                response = input('Press <enter> to accept, <1> to enter new thresholds, <s> to accept all: > ', 's');
            else
                response = '';
            end
            
            
            if isempty(response)==1
                accept = 1;
            elseif strcmp(response, 's')==1
                skipall_flag = 1;
                accept = 1;
            elseif isequal(str2double(response),1)==1;
                accept = 0;
                thresh_out_flag = 1;
            end
            
            while accept == 0;
                %%% New lower limit
                low_lim_new = input('enter new lower limit: ','s');
                if isempty(low_lim_new)
                else
                    low_lim = str2double(low_lim_new);
                end
                
                thresh(thresh_row,3) = low_lim;
                
                %%% New upper limit
                up_lim_new = input('enter new upper limit: ','s');
                if isempty(up_lim_new)
                else
                    up_lim = str2double(up_lim_new);
                end
                
                thresh(thresh_row,4) = up_lim;
                %%% plot again
                figure (1)
                clf;
                plot(save_output{i}(:,j))
                hold on
                %%% Plot lower limit
                line([1 length(save_output{i}(:,j))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
                %%% Plot lower limit
                line([1 length(save_output{i}(:,j))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')
                
                axis([1   length(save_output{i}(:,j))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
                title(var_names(i,:));
                grid on
                
                
                accept_resp = input('hit enter to accept, 1 to change again: ','s');
                if isempty(accept_resp)
                    accept = 1;
                else
                    accept = 0;
                end
            end
            
            save_output{i}(save_output{i}(:,j) > up_lim | save_output{i}(:,j) < low_lim,j) = NaN;
            
            clear temp_var up_lim low_lim accept_resp accept response thresh_row;
        end
        end
        %% Save variable to /Cleaned3 directory
        
        resp_flag = 0;
        
        while resp_flag == 0;
            commandwindow;
            if auto_flag == 1
                resp2 = 'y';
            else
                resp2 = input('Are you ready to print this data to /Cleaned? <y/n> ','s');
            end
            if strcmpi(resp2,'y')==1
                resp_flag = 1;
                for i = 1:1:num_vars
                    for j = 1:1:num_ch
                    temp_var = save_output{i}(:,j);
                    
                    save([output_path site '_' yr_str '.C' num2str(j) '_' char(header{i,2})], 'temp_var','-ASCII');
                    %         save([fill_path site '_' year '.' vars30_ext(i,:)], 'temp_var','-ASCII');
                    end
                end
                % Save the entire matrix to a .mat file
                master(1).data = save_output;
                master(1).labels = var_names;
                save([output_path site '_ACS_clean_' yr_str '.mat' ], 'master');
                clear master;
                
                
                
                %% Save threshold file
                if isequal(thresh_out_flag,1) == 1;
                    csvwrite([thresh_path site '_thresh_' yr_str '.csv'],thresh);
                end
                quitflag = 1;
            elseif strcmpi(resp2,'n')==1
                resp_flag = 1;
                quitflag = 0;
            else
                resp_flag = 0;
            end
        end
    end
        if auto_flag == 1
    else
    commandwindow;
    junk = input('Press Enter to Continue to Next Year');
        end
end
mcm_start_mgmt;
