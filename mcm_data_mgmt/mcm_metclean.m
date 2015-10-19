function [] = mcm_metclean(year, site, data_type, auto_flag)
%% mcm_metclean.m
%%% This function is used to visually inspect and rough-clean
%%% meteorological data that has been organized from raw files.
%%% usage: metclean(year,site, data_type, auto_flag)
% auto_flag = 0 runs in standard mode
% auto_flag = 1 runs in automated mode
%%% Created by JJB

%%%%%%% Revision History:
% Dec 9, 2011, JJB:
%%% I modified the threshold accept/change loop so that the user also has
%%% the option to accept all thresholds as-is.  This will make it possible
%%% to run this automatically and send the output to people via email
% Nov 17, 2014, JJB:
%%% Added auto_flag to the main threshold accept/modify process -- cleaning
%%% should now be fully automated (if required).



loadstart = addpath_loadstart;
%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
    data_type = [];
    auto_flag = 0; % flag that determines if we're in automated mode or not
elseif nargin == 2
    data_type = [];
    auto_flag = 0; % flag that determines if we're in automated mode or not
elseif nargin == 3
    auto_flag = 0; % flag that determines if we're in automated mode or not
end
[year_start year_end] = jjb_checkyear(year);

%
% if isempty(year)==1
%     year = input('Enter year(s) to process; single or sequence (e.g. [2007:2010]): >');
% elseif ischar(year)==1
%     year = str2double(year);
% end
%
% if numel(year)>1
%         year_start = min(year);
%         year_end = max(year);
% else
%     year_start = year;
%     year_end = year;
% end

%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%%
if isempty(data_type) == 1;
    data_type = 'met';
end

switch data_type
    case {'met','WX','TP_PPT'}
    otherwise
        site = [site '_' data_type];
end

%%% Convert yr into a string
% if ischar(year) == false
%     year = num2str(year);
% end

%% Declare Paths

%%% Header path
% hdr_path = [loadstart 'Matlab/Data/Met/Raw1/Docs/'];
hdr_path = [loadstart 'Matlab/Config/Met/Organizing-Header_OutputTemplate/']; % Changed 01-May-2012

%%% Folder to load organize data from
switch site
    case 'MCM_WX'
        load_path = [loadstart 'Matlab/Data/Met/Organized2/' site '/Column/15min/'];
    otherwise
        load_path = [loadstart 'Matlab/Data/Met/Organized2/' site '/Column/30min/'];
end
%%% Folder to output loaded data
output_path = [loadstart 'Matlab/Data/Met/Cleaned3/' site '/'];
jjb_check_dirs(output_path,auto_flag);

%%% Folder for storing threshold files
% thresh_path = [loadstart 'Matlab/Data/Met/Cleaned3/Docs/'];
thresh_path = [loadstart 'Matlab/Config/Met/Cleaning-Thresholds/']; % Changed 01-May-2012

%%% Folder for filled files
% fill_path = [loadstart 'Matlab/Data/Met/Filled3a/' site '/'];
%% Load Header File

header = jjb_hdr_read([hdr_path site '_OutputTemplate.csv'], ',', 3);


%% Take information from columns of the header file
%%% Column vector number
col_num = str2num(char(header(:,1)));

%%% Title of variable
var_names = char(header(:,2));

%%% Minute intervals
header_min = str2num(char(header(:,3)));

%%% Use minute intervals to find 30-min variables only
switch site
    case 'MCM_WX'
        vars30 = find(header_min == 15);
    otherwise
        vars30 = find(header_min == 30);
end
%%% Create list of extensions needed to load all of these files
vars30_ext = create_label(col_num(vars30),3);

vars30_names = var_names(vars30,:); % added by JJB, Feb 2, 2010.



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
    
    
    if isleapyear(year_ctr) == 1;
        len_yr = 17568;
    else
        len_yr = 17520;
    end
    switch site
        case 'MCM_WX'
            len_yr = len_yr*2
        otherwise
    end
    save_output = NaN.*ones(len_yr,length(vars30));
    %% Run through the variables first, so that we can see what may need to be
    %%% changed:
    for k = 1:1:length(vars30)
        try
            save_output(:,k) = load([load_path site '_' yr_str '.' vars30_ext(k,:)]);
        catch
            disp(['Unable to load the following variable: ' vars30_names(k,:)])
            save_output(:,k) = NaN.*ones(len_yr,1);
            
        end
    end
    
    quitflag = 0;
    while quitflag == 0;
        
        j = 1;
        while j <= length(vars30)
            temp_var = save_output(:,j);
            figure(1)
            clf;
            plot(temp_var);
            hold on;
            title([var_names(vars30(j),:) ', col: ' strrep(num2str(vars30(j)),'_','-')]);
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
                j = length(vars30)+1;
            else
                j = 1;
            end
        end
        clear j response accept
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % Run Metfix file to fix any problems that need an NAN:
        % % Otherwise, it needs to be done here:
        % %     metfixer(year, site);
        %     switch site
        %         case 'TP39'
        %             switch year
        %                 case '2008'
        %
        % % fix RH_blwcnpy
        %         save_output(3167:3837,vars30 ==  find(strcmp(header(:,2),'RelHum_BlwCnpy')==1)) = NaN;
        % % fix CO2 blwcnpy
        %         save_output(15822:17568,vars30 == find(strcmp(header(:,2),'CO2_BlwCnpy')==1)) = save_output(15822:17568,vars30 == find(strcmp(header(:,2),'CO2_BlwCnpy')==1))+33;
        % % fix Ts2a:
        %         save_output(10457:10595,vars30 == find(strcmp(header(:,2),'SoilTemp_A_2cm')==1)) = NaN;
        %
        %             end
        %     end
        
        %%
        %         thresh_ext = '.dat';
        %% Load Threshold file -- If it does not exist, start creating one
        if exist([thresh_path site '_thresh_' yr_str '.dat'],'file')==2
            thresh = load([thresh_path site '_thresh_' yr_str '.dat']);
            threshflag = 1;
            thresh_out_flag = 0;
            disp('Threshold file exists: Uploading');
            % [r2 c2] = size(save_output);
            % if length(thresh
            
        elseif exist([thresh_path site '_thresh_' yr_str '.csv'],'file')==2
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
                thresh_resp = input('Enter <1> to use previous year''s, or <0> to use blank thresholds: > ');
            end
            if thresh_resp == 1;
                try
                    unix(['cp ' thresh_path site '_thresh_' num2str(year_ctr-1) '.dat ' thresh_path site '_thresh_' yr_str '.dat'])
                    disp('Using Previous Year''s Thresholds');
                    thresh = load([thresh_path site '_thresh_' yr_str '.dat']);
                    threshflag = 1;
                    thresh_out_flag = 0;
                    
                catch
                    thresh(1:length(vars30),1:3) = NaN;
                    thresh(:,1) = vars30;
                    threshflag = 0;
                    thresh_out_flag = 1;
                    disp('Blank Threshold File Created');
                end
            else
                thresh(1:length(vars30),1:3) = NaN;
                thresh(:,1) = vars30;
                threshflag = 0;
                thresh_out_flag = 1;
                disp('Blank Threshold File Created');
            end
        end
        %%% Adjust length of threshold file if it's not long enough:
        size_diff =  length(vars30) - length(thresh);
        
        if size_diff > 0
            for k = 1:1:size_diff
                thresh(length(thresh)+1,1:3) = [vars30(length(thresh)+1,1) -100 100];
            end
            disp('You had more variables than threshold entries - fixing that now');
            thresh_out_flag = 1;
        end
        
        
        %% Load file, plot it, and give cleaning options
        for i = 1:1:length(vars30)
            accept = 1;
            %         temp_var = load([load_path site '_' year '.' vars30_ext(i,:)]);
            figure(1)
            clf;
            plot(save_output(:,i));
            hold on;
            %         title(var_names(vars30(i),:));
            title([var_names(vars30(i),:) ', col: ' strrep(num2str(vars30(i)),'_','-')]);
            
            grid on;
            switch threshflag
                case 1
                    %%% Load lower and upper limits
                    thresh_row = find(thresh(:,1) == vars30(i));  %% Select correct row in thresh
                    low_lim = thresh(thresh_row,2);
                    up_lim = thresh(thresh_row,3);
                    
                case 0
                    low_lim_str = input('Enter Lower Limit: ', 's');
                    low_lim = str2double(low_lim_str);
                    
                    up_lim_str = input('Enter Upper Limit: ', 's');
                    up_lim = str2double(up_lim_str);
                    
                    %%% Write new values to thresh matrix
                    thresh_row = find(thresh(:,1) == vars30(i));  %% Select correct row in thresh
                    thresh(thresh_row,2) = low_lim;
                    thresh(thresh_row,3) = up_lim;
                    
            end
            
            lim_range = up_lim - low_lim;
            %%% Plot lower limit
            line([1 length(save_output(:,i))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
            %%% Plot upper limit
            line([1 length(save_output(:,i))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')
            
            % Scale axes:
            %             axis([1   length(save_output(:,i))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
            axis([1   length(save_output(:,i))    low_lim-0.5*lim_range     up_lim+0.5*lim_range]);
            
            text(length(save_output(:,i))+10,up_lim,num2str(up_lim));
            text(length(save_output(:,i))+10,low_lim,num2str(low_lim));
            %         title(var_names(vars30(i),:));
            title([var_names(vars30(i),:) ', col: ' strrep(num2str(vars30(i)),'_','-') ]);
            
            %%%% Do a survey of # points above/below the threshold:
            ind_above = find(save_output(:,i)> up_lim);
            ind_below = find(save_output(:,i)< low_lim);
            
            plot(ind_above,save_output(ind_above,i),'go','MarkerSize',8);
            plot(ind_above,save_output(ind_above,i),'kx','MarkerSize',6);
            
            plot(ind_below,save_output(ind_below,i),'go','MarkerSize',8);
            plot(ind_below,save_output(ind_below,i),'kx','MarkerSize',6);
            
            %%% Display a message indicating whether or not the thresholds are
            %%% exceeded:
            if isempty(ind_above)==1 && isempty(ind_below)==1
                plot(0.1.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'go','MarkerFaceColor','g','MarkerSize',30);
                t1 = text(0.2.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'All Clear!');
            else
                plot(0.1.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'ro','MarkerFaceColor','r','MarkerSize',30);
                t1 = text(0.2.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'Thresholds Exceeded.');
            end
            set(t1,'FontSize',20,'VerticalAlignment','middle');
            
            %% Gives the user a chance to change the thresholds
            if skipall_flag == 0
                response = input('Press enter to accept, "1" to enter new thresholds: ', 's');
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
                
                
                thresh(thresh_row,2) = low_lim;
                
                %%% New upper limit
                up_lim_new = input('enter new upper limit: ','s');
                if isempty(up_lim_new)
                else
                    up_lim = str2double(up_lim_new);
                end
                
                
                
                thresh(thresh_row,3) = up_lim;
                %%% plot again
                figure (1)
                clf;
                plot(save_output(:,i))
                hold on
                %%% Plot lower limit
                line([1 length(save_output(:,i))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
                %%% Plot lower limit
                line([1 length(save_output(:,i))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')
                
                %                 axis([1   length(save_output(:,i))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
                axis([1   length(save_output(:,i))    low_lim-0.5*lim_range     up_lim+0.5*lim_range]);
                
                text(length(save_output(:,i))+10,up_lim,num2str(up_lim));
                text(length(save_output(:,i))+10,low_lim,num2str(low_lim));
                %             title(var_names(vars30(i),:));
                title([var_names(vars30(i),:) ', col: ' strrep(num2str(vars30(i)),'_','-')]);
                
                grid on
                
                %%%% Do a survey of # points above/below the threshold:
                ind_above = find(save_output(:,i)> up_lim);
                ind_below = find(save_output(:,i)< low_lim);
                
                plot(ind_above,save_output(ind_above,i),'go','MarkerSize',8);
                plot(ind_above,save_output(ind_above,i),'kx','MarkerSize',6);
                
                plot(ind_below,save_output(ind_below,i),'go','MarkerSize',8);
                plot(ind_below,save_output(ind_below,i),'kx','MarkerSize',6);
                
                
                %%% Display a message indicating whether or not the thresholds are
                %%% exceeded:
                if isempty(ind_above)==1 && isempty(ind_below)==1
                    plot(0.1.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'go','MarkerFaceColor','g','MarkerSize',30);
                    t1 = text(0.2.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'All Clear!');
                else
                    plot(0.1.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'ro','MarkerFaceColor','r','MarkerSize',30);
                    t1 = text(0.2.*length(save_output(:,i)),0.85.*(up_lim+0.5*lim_range),'Thresholds Exceeded.');
                end
                set(t1,'FontSize',20,'VerticalAlignment','middle');
                
                if auto_flag ==1
                    accept_resp = '';
                else
                    accept_resp = input('hit enter to accept, 1 to change again: ','s');
                end
                
                if isempty(accept_resp)
                    accept = 1;
                else
                    accept = 0;
                end
            end
            
            save_output(save_output(:,i) > up_lim | save_output(:,i) < low_lim,i) = NaN;
            if strcmp(site,'3') && strcmp(year_str,'2007');
                save_output(10000:10600,i) = NaN;
            end
            
            clear temp_var up_lim low_lim accept_resp accept response thresh_row;
        end
        
        %% Save variable to /Cleaned3 directory
        
        
        
        
        resp_flag = 0;
        
        while resp_flag == 0;
            commandwindow;
            if auto_flag == 1
                resp2 = 'y';
            else
                resp2 = input('Are you ready to print this data to /Cleaned3? <y/n> ','s');
            end
            if strcmpi(resp2,'y')==1
                resp_flag = 1;
                for i = 1:1:length(vars30)
                    temp_var = save_output(:,i);
                    
                    save([output_path site '_' yr_str '.' vars30_ext(i,:)], 'temp_var','-ASCII');
                    %         save([fill_path site '_' year '.' vars30_ext(i,:)], 'temp_var','-ASCII');
                    
                end
                master(1).data = save_output;
                master(1).labels = vars30_names;
                save([output_path site '_master_' yr_str '.mat'], 'master');
                clear master;
                
                %% Save threshold file
                if isequal(thresh_out_flag,1) == 1;
                    save([thresh_path site '_thresh_' yr_str '.dat'],'thresh','-ASCII');
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

