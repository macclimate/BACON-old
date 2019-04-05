function [] = mcm_metfixer(year, site, data_type, auto_flag)
%% mcm_metfixer.m
%%% This function is designed to be run on data after being processed with
%%% mcm_metclean.  Currently, this function should be used only on data
%%% collected in 2008 or later.  This function gives the user a chance to
%%% make final, manual adjustments to the data, that may not be fixable
%%% with a simple threshold.
%%% Variables are loaded from /Cleaned3/ and saved in /Final_Cleaned/

%%% Usage: mcm_metfixer(year, site), where year is a number and site a
%%% string
% auto_flag = 0 runs in standard mode
% auto_flag = 1 runs in automated mode

% Created Mar 11, 2009 by JJB
% Revision History:
% Mar 12, 2009 - changed variables input_data and output to be the same
% size as the entire list of variables -- whether 30 min variables or not.
% This preserves the numbering of the columns of variables to be consistent

%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
elseif nargin == 2
    data_type = [];
    auto_flag = 0;
elseif nargin == 3
    auto_flag = 0;    
end
if auto_flag == 1
        skipall_flag = 1;
    else
        skipall_flag = 0;
end

[year_start year_end] = jjb_checkyear(year);

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
%%% Added Jan 24, 2011 by JJB.
%%% Want to include data_type in the program, so we can process such things
%%% are trenched, sapflow, OTT, etc data.
if isempty(data_type) == 1
    data_type = 'met';
end

%%%%%%%%%%%%%%%%%
%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%
%%% Set a flag that tells the program whether or not to do tasks associated
%%% with main met sites: '1' means that extra stuff will be processed, 0
%%% means that it won't be:

% if strcmp(data_type, 'met')==1
switch data_type
    case {'met','WX','TP_PPT'}
        switch site
            case {'TP_PPT','MCM_WX'}
                proc_flag = 0;
            otherwise
                proc_flag = 1;
        end
    otherwise
        proc_flag = 0;
        %%% For sapflow, OTT, trenched, we need to change site to include the
        %%% data_type.
        site = [site '_' data_type];
end


%%%%%%%%%%%%%%%%%%%%%




%%%%%% Declare Paths:
loadstart = addpath_loadstart;
%%% Header Path
% hdr_path = [loadstart 'Matlab/Data/Met/Raw1/Docs/'];
hdr_path = [loadstart 'Matlab/Config/Met/Organizing-Header_OutputTemplate/']; % Changed 01-May-2012
%%% Load Path
load_path = [loadstart 'Matlab/Data/Met/Cleaned3/' site '/'];%[loadstart 'Matlab/Data/Met/Cleaned3/' site '/Column/30min/' site '_' year '.'];
%%% Save Path
output_path = [loadstart 'Matlab/Data/Met/Final_Cleaned/' site '/'];
jjb_check_dirs(output_path,0);
header = jjb_hdr_read([hdr_path site '_OutputTemplate.csv'], ',', 3);
%%% Path for bad data tracker (used by jjb_remove_data):
% tracker_path = [loadstart 'Matlab/Data/Met/Final_Cleaned/Docs/bad_data_trackers/'];
tracker_path = [loadstart 'Matlab/Config/Met/Cleaning-BadDataTrackers/']; % Changed 01-May-2012

%%% Take information from columns of the header file
%%% Column vector number
col_num = str2num(char(header(:,1)));
%%% Title of variable
var_names = char(header(:,2));
%%% Minute intervals
header_min = str2num(char(header(:,3)));
%%% Use minute intervals to find 30-min variables onlya
switch site
    case 'MCM_WX'
        vars30 = find(header_min == 15);
    otherwise
        vars30 = find(header_min == 30);
end
%%% Create list of extensions needed to load all of these files
vars30_ext = create_label(col_num(vars30),3);
%%% Create list of titles that are 30-minute variables:
% names30 = var_names(vars30,:);
names30 = header(vars30,2);

names30_str = char(names30);


%% Main Loop
for year_ctr = year_start:1:year_end
    close all
    RH_max = [];
    yr_str = num2str(year_ctr);
    disp(['Working on year ' yr_str '.']);
    
    if isleapyear(year_ctr) == 1
        len_yr = 17568;
    else
        len_yr = 17520;
    end
    switch site
        case 'MCM_WX'
            len_yr = len_yr*2;
        otherwise
    end
    
    input_data = NaN.*ones(len_yr,length(vars30)); % will be filled by loaded variables
    output = input_data;                           % will be final cleaned variables
    
    % Column numbers, names and string of names for the final variables:
    output_cols = (1:1:length(vars30))';
    output_names = names30;
    output_names_str = char(output_names);
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Step 1: Cycle through all variables so the investigator can look at the
    %%% data closely
    
    j = 1;
    switch skipall_flag
        case 1
            resp3 = 'n';
        otherwise
            commandwindow;
            resp3 = input('Do you want to scroll through variables before fixing? <y/n> ', 's');
    end
    if strcmpi(resp3,'y') == 1
        scrollflag = 1;
    else
        scrollflag = 0;
    end
    
    while j <= length(vars30)
        try
            temp_var = load([load_path site '_' yr_str '.' vars30_ext(j,:)]);
        catch
            temp_var = NaN.*ones(len_yr,1);
            disp(['unable to locate variable: ' var_names(vars30(j),:)]);
        end
        
        input_data(:,j) = temp_var;
        output(:,j) = temp_var;
        
        switch scrollflag
            case 1
                figure(1)
                clf;
                plot(temp_var,'b.-');
                %     hold on;
                title([var_names(vars30(j),:) ', column no: ' num2str(j)]);
                grid on;
                
                
                %% Gives the user a chance to change the thresholds
                response = input('Press enter to move forward, enter "1" to move backward: ', 's');
                
                if isempty(response)==1
                    j = j+1;
                    
                elseif strcmp(response,'1')==1 && j > 1;
                    j = j-1;
                else
                    j = 1;
                end
            case 0
                j = j+1;
        end
        
    end
    clear j response accept
    figure(1);
    text(0,0,'Make changes in program now (if necessary) -exit script')
    
    if proc_flag == 1
        %%@@@@@@@@@@@@@@@@@@ SOIL PROBES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %%% Plot Soil Temperature and Moisture data from each pit to make sure that
        %%% all data is in the right place:
        
        % A. Soil Temperature:
        %Check to see where soil temperature data starts:
        Ts_cols_A = find(strncmpi(names30(:,1),'SoilTemp_A',10)==1);
        Ts_cols_B = find(strncmpi(names30(:,1),'SoilTemp_B',10)==1);
        TsA_labels = char(names30(Ts_cols_A,1));
        TsB_labels = char(names30(Ts_cols_B,1));
        clrs = colormap(lines(7));
        
        figure(2);clf;
        for i = 1:1:length(Ts_cols_A)
            subplot(2,1,1)
            hTsA(i) = plot(input_data(:,Ts_cols_A(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hTsA,TsA_labels(:,12:end))
        title('Pit A - Temperatures -- uncorrected')
        
        for i = 1:1:length(Ts_cols_B)
            subplot(2,1,2)
            hTsB(i) = plot(input_data(:,Ts_cols_B(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hTsB,TsB_labels(:,12:end))
        title('Pit B - Temperatures -- uncorrected')
        
        
        % B. Soil Moisture:
        SM_cols_A = find(strncmpi(names30(:,1),'SM_A',4)==1);
        SM_cols_B = find(strncmpi(names30(:,1),'SM_B',4)==1);
        SMA_labels = char(names30(SM_cols_A,1));
        SMB_labels = char(names30(SM_cols_B,1));
        
        figure(3);clf;
        
        for i = 1:1:length(SM_cols_A)
            subplot(2,1,1)
            hSMA(i) = plot(input_data(:,SM_cols_A(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hSMA,SMA_labels(:,6:end))
        title('Pit A - Moisture -- uncorrected')
        
        for i = 1:1:length(SM_cols_B)
            subplot(2,1,2)
            hSMB(i) = plot(input_data(:,SM_cols_B(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hSMB,SMB_labels(:,6:end))
        title('Pit B - Moisture -- uncorrected')
    end
    
    %% @@@@@@@@@@@@@@@@@@@@ SPECIFIC CLEANS TO DATA @@@@@@@@@@@@@@@@@@@@@@@@@@@
    %%% Step 2: Specific Cleans to the Data
    
    switch site
        case 'MCM_WX'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% MCM_WX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2008'
                case '2009'
                case '2010'
                    
                case '2011'
                case '2012'
                case '2013'
                case '2014'
                case '2015'
                    output(4922:5070,16) = NaN;
                case '2016'
                case '2017'
                case '2018'
            end
        case 'TP39_OTT'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP39_OTT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2010'
                    output([3737 3775:3776 ],2:3) = NaN;
                case '2011'
                    output([8211 8266],4) = NaN;
                case '2012'
                case '2013'
                    % Bad offset data (missing)
                    output(4742:4745,1) = NaN;
                case '2014'
                case '2015'
                case '2016'
            end
            %%% Convert The OTT reading to a WT depth:
            WT_Depth = 8.53 - output(:,output_cols(strcmp(output_names,'Water_Height')==1));
            %%% Save the Water Table Depth Data to the /Calculated4 directory:
            jjb_check_dirs([loadstart 'Matlab/Data/Met/Calculated4/' site '/'],0);
            save([loadstart 'Matlab/Data/Met/Calculated4/' site '/' site '_' yr_str '.WT_Depth'],'WT_Depth','-ASCII');
            %             save([output_path site '_' yr_str '.WT_Depth'],'WT_Depth','-ASCII');
            figure('Name','WT Depth, m below sfc');
            plot(WT_Depth);
            clear WT_Depth;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP39_trenched'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP39_trenched %%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2009'
                    % remove bad points:
                    output([5987:5988 6374:6377],[4 5]) = NaN;
                    output(5987:6377,[6 7]) = NaN;
                    output( 1:11069, [10:14]) = NaN;
                case '2010'
                    output(3981,[12:13]) = NaN;
                    output(4351,15:16) = NaN;
                case '2011'
                case '2012'
                case '2013'
                    % Inactive sensors
                    output(:,[5 7 9:14 18:22]) = NaN;
                    
                case '2014'
                    % Poorly functioning sensors
                    output(:,[18 19 20 21]) = NaN;
                    output(13869,3:4) = NaN;
                    output(16518,[8 15]) = NaN;
                    % Inactive sensors
                    output(:,[22]) = NaN;
                case '2015'
                    % Bad points SM_DR_50cm
                    output([6366:6569 14431:end],4) = NaN;
                    % Bad points SM_DR2_2_0cm
                    output([11764:12203],15) = NaN;
                case '2016'
                    % TS Tr 20cm
                    output([1677 9837],3) = NaN;
                    % SMDR 100cm
                    output([7926:7929 7950 7956:8151 8172:8249 8471:8669 8699:8706 ...
                        8789:9166 9191:9195 9222:9239 9369:9562 10132:10144 13273:13283 17333],6) = NaN;
                    % SMTR 0-30cm
                    output([8003 8473:8553 8811:9166 9480:9492 11992:11994 12032:12047 12075:12096 12129:12143 17333],8) = NaN;
                    % SMDR 2 20cm
                    output([1672 1963 5024 6504 7155:8249 8490:9765 9999:10281 10562:12520],15) = NaN;
                    % SMDR 2 50cm
                    output([1670 1816 1963 8115 8471:8669 8696:8714 8785:9562 17333],16) = NaN;
                    % SMDR 2 5cm
                    output([8242 8471:8669 8790:9165 9308:9369 9455:9564 10272],17) = NaN;
                case '2017'
                     % Ts DR5cm, TR5cm & Tr20cm
                    output([8270 10658 10693:10697 10733 10805 10970 13819 14166 14660:14726 15465:15536 15565:15582 15605 15606 16272:16275 16303:16329 16868 16878 16879 16890 16929 16966 17032 17123:17125 17143 17447],[1:3]) = NaN;
                    % SMDR 2 20cm
                    output([8105:10000 13819],15) = NaN;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP39_sapflow'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP39_sapflow %%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2008'
                case '2009'
                    % manual fixes to dt data:
                    ind_bad = [11065:11115 13835:13846 14949:14950 16472:16475 4805:4806 10559:10600 2815:3051];
                    output(ind_bad,3) = NaN; %  dt sensor 1
                    ind_bad = [11065:11115 14955:14957 4805:4807 8562:8563 9917:9919 13839:13846 10560:10595 14949:14950 16473:16474];
                    output(ind_bad,4) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16472:16474 17405:17520];
                    output(ind_bad,5) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 3084:3107 2814:2816    ];
                    output(ind_bad,6) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474];
                    output(ind_bad,7) = NaN; %  dt sensor 5
                    ind_bad = [11065:11115 14956:14957 10560:10595 4805:4807 8562:8564 13838:13846 14949:14950 16473:16474 6369:6371 17405:17520 4110:4132];
                    output(ind_bad,8) = NaN;
                    ind_bad = [11065:11115 14956:14957 10560:10595 4805:4807 8562:8564 13838:13846 14949:14950 16473:16474 6369:6373 9917:9919];
                    output(ind_bad,9) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 9917:9919 13844:13875];
                    output(ind_bad,10) = NaN;
                    ind_bad = [11065:11115 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 10556:10593];
                    output(ind_bad,11) = NaN;
                    ind_bad = [11065:11115 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 10556:10593];
                    output(ind_bad,12) = NaN;%  dt sensor 10
                    ind_bad = [11065:11115 14956:14957 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13844:13846 9917:9919];
                    output(ind_bad,13) = NaN;
                    ind_bad = [11065:11115 14956:14957 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13844:13846 9917:9919 2772:3055];
                    output(ind_bad,14) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11376 11392];
                    output(ind_bad,15) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11748:11760 13085:13110 11376];
                    output(ind_bad,16) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11745:11766 13085:13106 14912:14926 11376];
                    output(ind_bad,17) = NaN;%  dt sensor 15
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11748:11759 13088:13103 14048:14060 11376];
                    output(ind_bad,18) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11748:11766 13088:13106 14912:14924 11376];
                    output(ind_bad,19) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11748:11760 13085:13105 14915:14924 11376];
                    output(ind_bad,20) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 11367:11460 11745:11759 13100:13104 14915:14925 11376];
                    output(ind_bad,21) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13844:13846 9917:9919];
                    output(ind_bad,22) = NaN;%  dt sensor 20
                    output([11065:11115 4797],23) = NaN;
                    ind_bad = [11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 1:4115 6380:6391];
                    output(ind_bad,24) = NaN;
                    ind_bad = [11065:11115 11065:11115 10560:10595 4805:4807 8562:8564 13838:13840 14949:14950 16473:16474 13845:13846 9917:9919 1:6391];
                    output(ind_bad,25) = NaN;
                    output(11065:11115,26) = NaN;%  dt sensor 24
                    clear ind_bad;
                    
                    
                case '2010'
                    output([6004 6005 15375 16602 16607],3) = NaN;
                    output([6004 6005 8962:8981 9438:9455 15375 16607],4) = NaN;
                    output([6004 6005 15375 16602 16607],5) = NaN;
                    output([6004 6005 7423:7796 15375 16602 16607],6) = NaN;
                    output([6004 6005 15375 16602 16607],7) = NaN;
                    output([4598 6014 9438 16607],10) = NaN;
                    output([6004 6005 9438 15375 16602 16607],11) = NaN;
                    output([6004 6005 15375 16602 16607],12) = NaN;
                    output([6004 6005 15375 16602 16607],13) = NaN;
                    output([6004 6005 15375 16602 16607],14) = NaN;
                    output([6004 6005 9438:9442 15375 16602 16607],15) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16602 16607],16) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16602 16607],17) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16602 16607],18) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16607],19) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16602 16607],20) = NaN;
                    output([6004 6005 6533:6553 8312 15375 16602 16607],21) = NaN;
                    output([6004 6005 15375 16602 16607],22) = NaN;
                    output([1152:1351],84) = NaN;
                    output([2826:7256],85) = NaN;
                    output([6004 6005 15375 16602 16607],107) = NaN;
                    output([6004 6005 15375 16602 16607],108) = NaN;
                    output([4598 6004 6005 6014 15375 16602 16607],110) = NaN;
                    output([4598 6004 6005 15375 16602 16607],111) = NaN;
                    output([4598 6004 6005 15375 16602 16607],112) = NaN;
                    
                case '2011'
                    output([3911:3913 5662 7084],3) = NaN;
                    output([3911:3913 5662 7084],4) = NaN;
                    output([3911:3913 5662 7084 8265],5) = NaN;
                    output([3911:3913 4347:4358 5662 7084],6) = NaN;
                    output([3911:3913 5662 7084],7) = NaN;
                    output([3911:3913 4172 5078:5080 5198:5403 5662 5935:5951 7084 7961:9927],10) = NaN;
                    output([3911:3913 4172 5662 7084],11) = NaN;
                    output([3911:3913 4172 5662 7084],12) = NaN;
                    output([3911:3913 5662 7084],13) = NaN;
                    output([3911:3913 5662 7084 7980:8061],14) = NaN;
                    output([3911:3913 5662 7084],15) = NaN;
                    output([3911:3913 5662 7084],16) = NaN;
                    output([3911:3913 5662 7084],17) = NaN;
                    output([3911:3913 4169:4178 5662 7084],18) = NaN;
                    output([3911:3913 4169 5662 7084],19) = NaN;
                    output([3911:3913 5662 7084 8247:8289 9678:9819],20) = NaN;
                    output([3911:3913 5662 7084],21) = NaN;
                    output([3911:3913 5662 7084 8265],22) = NaN;
                    output([5240:6121],85) = NaN;
                    output([9803:9805],86) = NaN;
                    output([3911:3913 5662 6317 7084 8266],107) = NaN;
                    output([3911:3913 4172 5662 7084 8266],108) = NaN;
                    output([3911:3913 5662 6317 7084 8265:8266],110) = NaN;
                    output([3911:3913 5662 6317 7084],111) = NaN;
                    output([3911:3913 5662 6317 7084 8265:8266],112) = NaN;
                    output(4171:4172,[3:27 111:113]) = NaN;
                case '2012'
                    output(:,16) = NaN;
                case '2013'
                    % Bad points across sapflow data
                    output([1320:1325 1723 6137 8565 8570 9602:9603 12649 13610 15857:15860 17053:17054],:) = NaN;
                    % Inactive sensors (#2,#4,#6,#7,#8,#21,#22avg,#23,#24avg,#25,dr23)
                    output(:,[4 6 8 9 10 23:27 30 34 38:42 68 72 109]) = NaN;
                    % Bad sapref3avg
                    output(6134,[5 32]) = NaN;
                    % Bad sapref5avg
                    output(6134,[7 36]) = NaN;
                    % Non-functioning sensors (#11,#14,#16,#22max,#23hrmnmx,#24mm,#25m/mm,dr22avg)
                    output(:,[13 16 18 48 54 58 70 73 75 76 77 108]) = NaN;
                    % Incomplete data (#20)
                    output(:,[22 66]) = NaN;
                    % Incomplete tsdr5avg
                    output(:,87) = NaN;
                    % Inactive Ts Ref Tavg
                    output(:,90) = NaN;
                    % Bad SM DR50 avg data
                    output(3022:3025,95) = NaN;
                    % Non-functioning SM sensors (#7-12 avg)
                    output(:,101:106) = NaN;
                    
                    
                case '2014'
                    % Spikes in sensor 1
                    output([1316 1323 5651 6286 6296 13872 10451 13892 15000:17520],3) = NaN;
                    
                    % Missing past 15000 - no power
                    output([15000:17520],[3 5 6 7 11 12 14 15 16 17 18 19 20 21 22 ...
                        28 29 30 31 32 33 34 35 36 37 43 44 45 46 47 48 49:71 73:79 82 83:89 ...
                        91 95:100 107 110 111:117]) = NaN;
                    
                    % Spikes in all sensors
                    output([1323 13892],:) = NaN;
                    
                    % Bad sensors: # 11,14,20,22,24,25,Dr22-23 (+ others)
                    output(:,[4 6 8 9 10 13 16 22 23 24 25 26 27 30 34 38 39 40 ...
                        41 42 48 54 66 70 74 76 108 109]) = NaN;
                    
                    % Inactive moisture/temp sensors: #23,leaf_wet1-2, TsDr5avg,
                    % TsRefTavg, Ts10-12avg, SM7-12avg (+ others)
                    output(:,[8 9 10 13 23:26 39:42 72 80 81 87 90 92:94 101:106]) = NaN;
                    
                    
                    % Bad points in sapflow data (with dip):
                    % #12,13,15,18,19, Dr6-7 (+ others)
                    output([1316:1323 6286 11490:11492 13872 ],...
                        [5 11 12 14 15 17 20 21 28 32 44 46 50 52 56 62 64 111 112 113 115]) = NaN;
                    % Bad points in # 21 sapflow data (with dip):
                    output(1323,68) = NaN;
                    
                    % Missing data in SFref5avg
                    output(5649:12000,7) = NaN;
                    % Missing/poor data in Sap 5 max
                    output([1323 6000:17520],19) = NaN;
                    % Missing and poor data in #16 avg and max:
                    output([1:101 110 111 82:825 6000:10000],[18 58]) = NaN;
                    % Missing and poor data in # 17 avg and max
                    output([1323 6000:17520],[19 60]) = NaN;
                    % Missing and poor data in # 24 TapRoot avg
                    output([1323 6000:10000],[110]) = NaN;
                    % Spike in TsDr50 avg
                    output(14531,83) = NaN;
                    % Spike in TsRef50 avg
                    output([1367 13867 14384 14531 14066 10492 10716],[86 91]) = NaN;
                    % Spike in TsRef50 avg
                    output([14756],88:89) = NaN;
                    
                case '2015'
                    % *** Rachel found the following sensors to be working prior to April:
                    % 1,3,5,9,10,12,13,15,17,18,19
                    % After April, the following sensors are working:
                    % 1,3,9,10,12,13,15,18
                    
                    
                    % Spike in Sap1avg,
                    output([2918 7246 7249 9010 11745 14230 14487 15159],3) = NaN;
                    % Spike in Sap3avg
                    output([4973:4977 7246 7249 9010 11745 14230 14487 15159],5) = NaN;
                    % Inactive Sap sensors 4,6,8,16,17,19
                    output(1:end,[6,10,18,19,21,22]) = NaN;
                    
                    % Repeat this for min and max, refer to inventory for
                    % working and inactive sensors
                    
                    % Removed Sap19avg in April
                    output([4976:end],21) = NaN;
                    % Spike in Sap9avg
                    output([4977 7246 7249],11) = NaN;
                    % Spike in Sap10avg
                    output([7246 7249],12) = NaN;
                    % Spike in Sap13avg
                    output([4788 7246 7249 11746],15) = NaN;
                    % Spike in Sap15avg
                    output([7246 7249 13143],17) = NaN;
                    % Spike in Sap16avg, + 8500:11000 points? Rachel
                    % documented this sensor as having no data
                    output([7246 7249],18) = NaN;
                    % Spike in Sap20avg
                    output([7246 7249],20) = NaN;
                    % Spike in Sap1mAX
                    output([14230],28) = NaN;
                    % Spike in Sap3mAX
                    output([14230],32) = NaN;
                    % Spike in Sap9mAX
                    output([14230],44) = NaN;
                    % Spike in Sap1_0mAX
                    output([14230],46) = NaN;
                    % Spike in Sap1_3mAX
                    output([14230],52) = NaN;
                    % Spike in Sap1_8mAX
                    output([14230],62) = NaN;
                    
                    
                case '2016'
                    % Sap Ref 1 Avg
                    output([4210 10991 13228:13234 17332:17338],3) = NaN;
                    % Sap Ref 3, 9, 10, 13, 15, 18 Avg
                    output([4210 5644:5647 9832 10875 10880 10991 13228:13234 17332:17338],[5 11 12 15 17 20]) = NaN;
                    % Sap 1 Max
                    output([5646 17336],[28 32 44 62]) = NaN;
                    % Sap 13 Max
                    output([10991 13234 17336],52) = NaN;
                    % Sap 15 Max
                    output([11458:12214],[68 107]) = NaN;
                    % Sap 21 Max
                    output([10991 13234 17336],68) = NaN;
                    % Sap 24 Max
                    output([5827:5830 6405 6459:7261 10682 10827:10832 10875 10880 10991 11690 13227:13235 16095:16408 16529:16560 16959:17079 17336],74) = NaN;
                    % Sap Dr 50 Avg
                    output([9804:11869 12032:12489 12531:12969],95) = NaN;
                    % Sap Dr 6B Avg
                    output([5645 13228 17332:17338],111:115) = NaN;
                    
                case '2017'    
                    % HFlux A
                    output([4255:4261 5262 5732:5736 5763:5767 5795 5796],[1 2]) = NaN;
                    % Sap Ref 1 Avg
                    output([1090:1092 1235:1238 1241 1301 1543 2121 2122 2153 2154 2172 2184 2192 2414 2600 2621 2640 2914 2915 ...
                        3205:3248 9712:9715 10710:10713 11013 11044 11045],3) = NaN;
                    % Sap Ref 3, 9, 13, 18 Avg
                    output([2914 2915 3205 3247 13821 13822 14207 14208 15036 15107 15554 15555 15632 16215 16275],[5 11 15 20]) = NaN;
                    % Sap Fall 15 Avg and Max
                    output([2055:2084 2914 2915 3205 3247],[17 56]) = NaN;
                    % Sap 1 Max
                    ouput([1091 1092 1237 1241 2121 2184 2192 2414 3206:3248],28) = NaN;
                    % Sap 3, 9, 13, 24 Max
                    output([3247],[32 44 52 74]) = NaN;
                                 
                    
                    
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP74_sapflow'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP74_sapflow %%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2010'
                    
                case '2011'
                    output([6951 11850],1) = NaN;
                    output([4161:5016 6951:6983 7007 11850],2) = NaN;
                    output([6951 11850],3) = NaN;
                    output([6951:7032 11850],4) = NaN;
                    output([6951:6983 11850],5) = NaN;
                    output([4979 6952:6983 11850],6) = NaN;
                    output([4227:4256 6951:6983 11850],7) = NaN;
                    output([4007 6951:6983 11850],8) = NaN;
                    output([6951:6983 11850],9) = NaN;
                    output([6951:6983 11850],10) = NaN;
                    output([6951:6983 11850],12) = NaN;
                    output([6951:6983 11850 15915:17520],13) = NaN;
                    output([6951:6983 11850],14) = NaN;
                    output([6951:6983 11850],15) = NaN;
                    output([4978 6951:6983 11850],16) = NaN;
                    output([6951:6983 11850],15) = NaN;
                    output([11000:14470],17) = NaN;
                case '2012'
                case '2013'
                case '2014'
                    % Spikes in all sensors
                    output([14827],:) = NaN;
                    % poor sensor #3 and 13 data
                    output([6801:7355 9932:12200 15168:15172 16053 16460:16480 16503],[3 37 47 54 63 63]) = NaN;
                    output(14000:17520,[47 64]) = NaN; % Sensor 13 all wonky after fall
                    % inactive sensors: #10, 11
                    output(:,[10 11 27 28 44 45 61 62]) = NaN;
                    % Sensor #12 removed in April ***
                    output(6131:17520, [12 29 46]) = NaN;
                    % poor sensor #17 data
                    output(:,[51 68]) = NaN;
                    % v. high sensor #1,2,4,5,7,8,9,14 data
                    %output(6125:6186,52) = NaN;
                    
                    % Seonsr 17 spikes
                    output([14827:14891],34) = NaN;
                    
                    
                case '2015'
                    % Sensors 10,11,12 are inactive
                    % Sap_DT 5 has bad data after April
                    % Sap_DT_max 5 has bad data after April,
                    % Sap_vel 5 has bad data after April, 13+17 has bad data
                    % Sapflow 5 has bad data after April, 13+17 has bad data
                    
                    % Spike from changing sapflow sensors, shift afterwards
                    output([4984:4985 ],2:4 ) = NaN;
                    
                case '2016'
                    % Sensor dt Spikes
                    output([4976 5051 9775 10282],[1:9 14:16]) = NaN;
                    % Sensor dt Tree 9 Spikes
                    output([5652],[9 14]) = NaN;
                    % Sap dt Max Tree 1
                    output([4976:5002 5051:5099 9775:9802],18) = NaN;
                    % Sap dt Max Tree 4,8,14,15,16
                    output([9775:9802],[21 25 31:33]) = NaN;
                    % Sap dt Max Tree 13 & 17
                    output([4976:5156 9775:9850],[30 34]) = NaN;
                    % Sap Velocity Tree 1
                    output([9775],35) = NaN;
                    % Sensor Velocity Spikes
                    output([4976 5051 9775 10282],[36:43 48:50]) = NaN;
                    % Sensor Flow Spikes
                    output([4976 5051 9775 10282],[52:60 65:67]) = NaN;
                    
                case '2017'
                    % Sap dt Tree 3
                    output([1207:1562],3) = NaN;
                    % Sap dt Tree 4
                    output([2385 2386 3248], 4) = NaN;
                    % Sap dt Tree 7, 8, 9, 14, 15 16
                    output([3248],[7:9 14:16]) = NaN;
                    % Sensor Velocity Spikes
                    output([3248],[36:43 48:50]) = NaN;
                    % Sensor Flow Spikes
                    output([3248],[52:60 65:67]) = NaN;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP_PPT'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP_PPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            PPT_raw = output(:,output_cols(strcmp(output_names,'GN_Precip')==1));
            
            switch yr_str
                case '2008'
                    output_shift = [output(1:9000,1:end); output(9002:end,1:end); NaN.*ones(1,size(output,2))];
                    output = output_shift;
                    %             Geo_PPT_shift = [PPT_raw(1:9000); PPT_raw(9002:end); NaN];
                    %             output(:,output_cols(strcmp(output_names,'GN_Precip')==1))= Geo_PPT_shift;
                    %             PPT_out = Geo_PPT_shift;
                    %             clear Geo_PPT_shift;
                    %             PPT_tx_shift = [PPT_tx(1:9000); PPT_tx(9002:end); NaN];
                    %             PPT_tx = PPT_tx_shift;
                    %             clear PPT_tx_shift;
                    % Take out obvious bad data;
                    %             output([5496:5497 938 13707 16833],1:end) = NaN;
                case '2009'
                    % Take out bad data in wind speed:
                    output(1819:3437,4:7) = NaN;
                case '2010'
                    
                    
                    % Added Oct 09, 2010 by JJB:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% We need to insert an algorithm for removing large
                    %%% diurnal(ish) variations in bucket level during the start of
                    %%% 2010, due to the bucket being improperly balanced.  We'll
                    %%% do this by manually removing points where there seems to be
                    %%% no precipitation, and making these values equal to the last
                    %%% good point before it.  Doing this creates a much more
                    %%% acceptible result for PPT, as otherwise, these variations
                    %%% will be incorrectly counted as precipitation events.
                    %%% The list defines regions where we want to make the values
                    %%% constant (i.e. no precipitation)
                    GN_Precip = PPT_raw;
                    
                    bad_data = {522:862 891:1130 1324:1550 1610:1883 1954:2112 2170:2280 2286:2300 ...
                        2322:2525 2570:2615 2622:2686 2775:3359 3492:3731};
                    for k = 1:1:length(bad_data)
                        ind_last = find(~isnan(PPT_raw(1:bad_data{1,k}(1,1)-1)),1,'last');
                        last_good = PPT_raw(ind_last);
                        GN_Precip(bad_data{1,k}(1,:),1) = last_good;
                    end
                    %%% Copy over the bad data:
                    output(:,output_cols(strcmp(output_names,'GN_Precip')==1)) = GN_Precip;
                    clear GN_Precip;
                case '2011'
                    % Missing data in all fields
                    output(10789:10982, 1:15) = NaN;
                case '2015'
                    % Missing data in all fields
                    output([1:5409],:) = NaN; % Datalogger malfunctioned / bad data
                    output([16304:end],1) = NaN; % Bad battery voltage
                    output([16445:end],10:15) = NaN; % Bad PPT data
                    output([14286:14506 15675:16292],[4:6 8 10:15]) = NaN; % Bad data (Wind + PPT)
                    % Bad data point
                    output(5583,[12 15]) = NaN;
                case '2016'
                    % Faulty Sensor -> Tried to remove data but code did
                    % not work
                    %                     output([174:1567],15) = NaN;
                    output(14281,[11 12 13 15]) = NaN; % Bad battery voltage
                case '2017'
                    
                case '2018'
                    output(16317:16501,[10:15]) = NaN;
                case '2019' 
                    
            end
            %%% Call mcm_PPTfixer to Calculate event-based precipitation at
            %%% TP_PPT:
            GN_Precip = output(:,output_cols(strcmp(output_names,'GN_Precip')==1));
            TX_Rain = output(:,output_cols(strcmp(output_names,'TX_Rain')==1));
            
            % mcm_PPTfixer will automatically save data to /Cleaned/ and /Final_Cleaned/
            mcm_PPTfixer(year_ctr, GN_Precip,PPT_raw, TX_Rain);
            disp('mcm_PPTfixer finished.');
            disp('GEONOR and TX data saved separately to /Cleaned/ and /Final_Cleaned/.');
            clear GN_Precip TX_Rain;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP39'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP39  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2002'
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Swap some mixed up Ts sensors:
                    Ts5B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1));
                    Ts2B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1)) = [Ts5B_orig(1:5538,1) ; Ts2B_orig(5539:end)];
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1)) = [Ts2B_orig(1:5538,1) ; Ts5B_orig(5539:end)];
                    
                    % bad LW_down data:
                    output(:,18) = NaN;
                    
                    %%%%%%%%%%%%%%%%%%%% correcting too-low PAR values %%%
                    % using correlation with SW down:
                    PAR_tmp = output(:,9); SWdown_tmp = output(:,14);
                    figure(77);clf; plot(PAR_tmp,SWdown_tmp,'k.');
                    % line of best-fit
                    p = polyfit(SWdown_tmp(~isnan(PAR_tmp+SWdown_tmp)),PAR_tmp(~isnan(PAR_tmp+SWdown_tmp)),1);
                    PAR_pred = polyval(p,SWdown_tmp);
%                     PAR_diffn = (PAR_tmp - PAR_pred)./PAR_pred;
%                     figure(78);plot(PAR_diffn,'k.')
%                     figure(79);clf;plot(PAR_tmp,'b'); hold on; plot(PAR_pred,'r');
                   
                    % fix for the affected period:
                    output(12720:13240,9) = PAR_pred(12720:13240,1);
                     clear PAR_tmp SWdown_tmp PAR_pred p;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                    
                    % Noisy Snow Depth Data
                    % output([1086:3822 4635:4971 16000:17520],31) = NaN;
                    output(:,31)=NaN; % JJB 20180427 - completely removing it.
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load last 8 datapoints from 2001
                    num_to_shift = 8;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2001.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:num_to_shift,i) = temp_var(end-num_to_shift+1:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-num_to_shift,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                    
                    % Swap mislabeled HMPs - For 2002, the ground and top
                    % HMPs need to be swapped:
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_gnd_orig;
                    output(:,3)=Ta_abv_orig;
                    output(:,4)=RH_gnd_orig;
                    output(:,6)=RH_abv_orig;
                    clear *abv_org *gnd_orig;
                    
                    % Fix a data offset issue, by moving data back by 1
                    % halfhour KEEP THIS AT THE END
                    output = [output(2:9638,:);NaN.*ones(1,size(output,2));output(9639:17520,:)];
                case '2003'
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2002.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2002 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:8,i) = temp_var(end-8+1:end);
                        clear temp_var;
                    end
                    output = [fill_data(:,:); output(9:end,:)];
                    clear fill_data;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Swap some mixed up Ts sensors:
                    Ts5B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1));
                    Ts2B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1)) = Ts2B_orig(1:end,1);
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1)) = Ts5B_orig(1:end,1);
                    
                    % Remove bad PAR_down data
                    output(11405:11406,9)=NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                    % Fix bad LWdown data
                    output([9204:9218 9295:9304 9971:9978 10005:10025 10069:10072 10158:10171 10207 10693:10701 10735:10748 10776:10785 10826:10843 10873:10892 10921:10947 10973:10991 11017 11026 11036 11037 11064:11072 11115:11124 11164:11182 11259 11277 11319:11324 11368:11373 11406:11410 11449:11469 11497:11517 12332:12334 13577:13579],18) = NaN;
                    
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    
                    % Swap mislabeled HMPs - For 2003, the ground and top
                    % HMPs need to be swapped:
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_gnd_orig;
                    output(:,3)=Ta_abv_orig;
                    output(:,4)=RH_gnd_orig;
                    output(:,6)=RH_abv_orig;
                    clear *abv_org *gnd_orig;
                    % Fix a data offset issue, by moving data back by 1
                    % halfhour KEEP THIS AT THE END
                    output = [output(1:17468,:);output(17470:end,:);NaN.*ones(1,size(output,2))];
                    
                case '2004'
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    % Swap mislabeled HMPs - For 2004, the ground and top
                    % HMPs need to be swapped:
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_gnd_orig;
                    output(:,3)=Ta_abv_orig;
                    output(:,4)=RH_gnd_orig;
                    output(:,6)=RH_abv_orig;
                    clear *abv_org *gnd_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2005'
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    % Fix a data offset issue, by moving data back by 1
                    % halfhour KEEP THIS AT THE END
                    output = [output(2:17520,:);NaN.*ones(1,size(output,2))];
                    
                    % Swap mislabeled HMPs - For 2005, ground and top
                    % HMPs need to be swapped for the first 7 hhrs only:
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(1:8,1)=Ta_gnd_orig(1:8,1);
                    output(1:8,3)=Ta_abv_orig(1:8,1);
                    output(1:8,4)=RH_gnd_orig(1:8,1);
                    output(1:8,6)=RH_abv_orig(1:8,1);
                    clear *abv_org *gnd_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2006'
                    % Remove obvious bad data in PAR down abv cnpy
                    bad_data = [4341 4438 4725 4773 4821 5301 5684 5732 6500 ...
                        7075 7123 7171 7459 7507 7555 7603 7651 7699 7747 7843 ...
                        7939 7987 8035 8083 8179 8227 8371 8419 8659];%8852?
                    
                    output(bad_data,output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1))=NaN;
                    output(bad_data+1,output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1))=NaN;
                    
                    output(12290:12310,output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1))=0;
                    
                    % Remove obvious bad data in PAR down blw cnpy
                    output(12250:12600,35) = NaN;
                    %                     output(:,75:80)= NaN; output(:,82:85)= NaN; output(:,89:90)= NaN;
                    %                     output(12284:17520,69:91) = NaN;
                    %                     %%%% Move PAR bottom down to zero:
                    %                     output(output(:,33) < 10,33) = 0;
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    
                    %                     Fix a data offset issue, by moving data back by 1
                    %                     halfhour KEEP THIS AT THE END
                    output = [output(1:6490,:);output(6492:11050,:);NaN.*ones(1,size(output,2));output(11051:end,:)];
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2007'
                    
                    %                 %% Corrects for inverted Net Radiation for a period of time
                    %                 %% in the data -- due to backwards wiring of sensor into
                    %                 %% datalogger.
                    %                 %% use the mean of one day during the period to make sure
                    %                 %% the data hasn't already been flipped once (mean of the
                    %                 %% day is -24.707)
                    if mean(input_data(6015:6063,18)) < 0
                        output(459:7842,1) = -1.*output(459:7842,1);
                    end
                    % clean Ta14m&Ta2m for bad data
                    output(2758:2812,2:3) = NaN;
                    %Clean bad wind speed and direction data;
                    output(683:1070,output_cols(strcmp(output_names,'WindSpd')==1)) = NaN;
                    output(683:1070,output_cols(strcmp(output_names,'WindDir')==1)) = NaN;
                    
                    % Clean bad data in blw_cnpy PAR:
                    
                    output(694:763,output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)) = NaN;
                    % Clean bad data in canopy and blw_cnpy CO2:
                    bad_CO2_cpy = [2339:2340 3629 4306 5737 7659 14478 17372:17377]';
                    output(bad_CO2_cpy, output_cols(strcmp(output_names,'CO2_Cnpy')==1)) = NaN;
                    bad_CO2_blw = [4305 4724 5203 5258 5737 13126 16017 16922 17372:17377]';
                    output(bad_CO2_blw, output_cols(strcmp(output_names,'CO2_BlwCnpy')==1)) = NaN;
                    % Clean bad HFT data:
                    bad_HFT2 = [7647:7658]';
                    output(bad_HFT2, output_cols(strcmp(output_names,'SoilHeatFlux_HFT_2')==1)) = NaN;
                    % Clean bad soil data:
                    bad_soil_data = [694:763 7626:1:7658]';
                    bad_soil_cols = [79:100]';
                    output(bad_soil_data, bad_soil_cols) = NaN;
                    % SM 100 B probe -- before it was installed properly.
                    output(1:8200,output_cols(strcmp(output_names,'SM_B_100cm')==1)) = NaN;
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load last 8 datapoints from 2006
                    num_to_shift = 8;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2006.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2006 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:num_to_shift,i) = temp_var(end-num_to_shift+1:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-num_to_shift,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2008'
                    % Fix CO2_cpy offset during late 2008 (if hasn't already been done)
                    right_col = quick_find_col( names30, 'CO2_BlwCnpy');
                    if output(15821,right_col) - output(15822,right_col) > 20
                        output(15822:17568,right_col) = output(15822:17568,right_col)+33;
                    elseif output(15821,right_col) - output(15822,right_col) < 20
                        output(15822:17568,right_col) = output(15822:17568,right_col)-33;
                    end
                    clear right_col;
                    % Fix SnowDepth -- remove a bad point:
                    right_col = quick_find_col( names30, 'SnowDepth');
                    output(9664,right_col) = output(9663,right_col); clear right_col;
                    % Fix Problems with Atm. Pres sensor for a couple periods:
                    right_col = quick_find_col( names30, 'Pressure');
                    output(12380:13120,right_col) = NaN;
                    output(13980:14480,right_col) = NaN; clear right_col;
                    
                    % Shift data so that it's all in UTC:
                    % need to load last 8 datapoints from 2007
                    for i = 1:1:length(vars30)
                        temp_var = load([load_path site '_2007.' vars30_ext(i,:)]);
                        fill_data(1:8,i) = temp_var(end-7:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-8,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2009'
                    
                    % Bad CO2_cnpy data:
                    output(8940:12240,71) = NaN; % broken
                    output(12241:12762,71) = output(12241:12762,71) + 236; % bad offset
                    
                    % Bad Snow Depth Data:
                    output(9000:17000,31) = 0;
                    
                    % Bad SMA20cm data:
                    bad_pts = [11688 12458 12613 12650:12661 13234:13251 13662 ...
                        13725:13752 13866 13915:13982 14053 14056 14101]';
                    output(bad_pts,93) = NaN;
                    clear bad_pts;
                    
                    % We
                    
                    % Shift data so that it's all in UTC:
                    % need to load last 8 datapoints from 2008
                    
                    for i = 1:1:length(vars30)
                        temp_var = load([load_path site '_2008.' vars30_ext(i,:)]);
                        fill_data(1:8,i) = temp_var(end-7:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:704,:); output(713:end,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    
                    % We need to keep 50 datapoints that would otherwise be
                    % removed from RH because they are >100.  If we remove
                    % them, we do not have data for any site at these
                    % times, and therefore, have gaps.
                    find_big = find(output(10810:10969,4)>= 100);
                    output(10810-1+find_big,4) = 100;
                    clear find_big;
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2010'
                    %%% Bad CO2 cpy data:
                    output([1625 4598 5611 6004 6005 6014 8027 15375 16607], 71) = NaN;
                    output([1196 1197 4598 5611 6004 6005 6014 6241 7910], 72) = NaN;
                    output([6005:6013],99) = NaN;
                    output(16840,97) = NaN;
                    % Bad Snow Depth Data:
                    output([3412 3415 9675 9798],31) = NaN;
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2011'
                    % Missing data in all fields
                    output([3905:3910 5109:5116 5661 7078:7083], 1:32) = NaN;
                    % Bad data in some fields
                    output([9601 9602], [1 2 4 28:31]) = NaN;
                    % Bad Up Shortwave Radiation
                    output(3154, 15) = NaN;
                    % Bad Air Temperature at Canopy
                    output(6279, [1 3]) = NaN;
                    % Bad Wind Direction data:
                    output(6281:9595,8) = NaN;
                    % Bad Radiation data:
                    %output(3156:3157,17) = NaN;
                    output(3157:6279,[14:26])= NaN;
                    % Bad SMB100 data
                    output(:,100) = NaN;
                    % Bad SR50 (snow depth) data
                    output([290 699:704 976 1153:1155 1189:1226 1248:1281 1365 1405 1408:1420 2329:2333 2664 2801 2802 2810 3030 3079 3088 3102 3104 3121 3328 3337 3342 3346 3349 3351 3904 3912 5118 9859 9911 ...
                        9918 10111 10131 10159 10171 10417 10542 10555 10559 10595 10620 10635 10838 11144 11737 11824 12667 12669 12683 12892 12927 13012 13085 ...
                        13079 13672 13755 13993 14060 14064 14065 15093 15326 16239 16728 17419 17420 17429 17435], 31) = NaN;
                    % Bad CO2 Canopy
                    output([473 3911 13870:14345],71) = NaN;
                    % Bad soil heat flux data
                    output(15258,69) = NaN;
                    % Bad CO2BLW Canopy
                    output(15694:end,72) = NaN;
                    % Bad RMY rain data
                    output(:,11) = NaN;
                    % Snow Depth Distance Spikes
                    output([11:33 290 699:704 976 1153:1158 1185:1190 1194 1197:1209 1214 1215 1218 1221:1226 1230 ...
                        1248 1252:1281 1365 1374 1387:1389 1393:1395 1405:1420 1724:1726 1729 2035:2044 2084 2329:2333 ...
                        2464 2664 2768 2801 2802 2810 2811 3030 3079 3088 3102:3104 3121 3328 3337 3342:3354 3904:3912 ...
                        5118 9859 9907:9911 9918 9955 10108 10109 10111 10123 10127 10131 10159 10171:10175 10349 10368 ...
                        10369 10417:10419 10452:10456 10464 10512 10542 10554 10555 10559 10595 10620 10635 10838 11144 ...
                        11359 11450:11453 11737:11740 11824 11978 12186 12560:12562 12650:12652 12667:12671 12680:12683 ...
                        12843 12892 12921:12927 13012 13079:13086 13672 13713 13732 13753:13755 13988 13992 13993 14060:14067 14533 ...
                        14960 15019:15029 15093 15326 16239 16720 16728:16744 17339 17419 17420 17427:17447],[27 28]) = NaN;
                    % Set snow depth <0 to zero
                    output(output(:,31)<0,31) = 0;
                    %%% Fill in missing wind direction data with adjusted
                    %%% TP74 Wind direction data:
                    tmp_TP74 = load([loadstart 'Matlab/Data/Met/Final_Cleaned/TP74/TP74_met_cleaned_2011.mat']);
                    WD_TP74 = tmp_TP74.master.data(:,5);
                    tmp_dt = (1:1:17520)'; WD_TP39_estTP74 = NaN.*ones(17520,1);
                    WD_TP39_estTP74(1:3154,1) = WD_TP74(1:3154,1)+27.2;
                    WD_TP39_estTP74(tmp_dt>=1 & tmp_dt<=3154 & WD_TP39_estTP74 >= 360) = ...
                        WD_TP39_estTP74(tmp_dt>=1 & tmp_dt<=3154 & WD_TP39_estTP74 >= 360)-360;
                    WD_TP39_estTP74(3155:9596,1) = WD_TP74(3155:9596,1) +51.9;
                    WD_TP39_estTP74(tmp_dt>=3155 & tmp_dt<=9596 & WD_TP39_estTP74 >= 360) = ...
                        WD_TP39_estTP74(tmp_dt>=3155 & tmp_dt<=9596 & WD_TP39_estTP74 >= 360)-360;
                    WD_TP39_estTP74(9597:end,1) = WD_TP74(9597:end,1) +33.6;
                    WD_TP39_estTP74(tmp_dt>=9597 & tmp_dt<=17520 & WD_TP39_estTP74 >= 360) = ...
                        WD_TP39_estTP74(tmp_dt>=9597 & tmp_dt<=17520 & WD_TP39_estTP74 >= 360)-360;
                    
                    tmp_TP02 = load([loadstart 'Matlab/Data/Met/Final_Cleaned/TP02/TP02_met_cleaned_2011.mat']);
                    WD_TP02 = tmp_TP02.master.data(:,4); WD_TP39_estTP02 = NaN.*ones(17520,1);
                    WD_TP39_estTP02(1:3154,1) = WD_TP02(1:3154,1)+11.4;
                    WD_TP39_estTP02(tmp_dt>=1 & tmp_dt<=3154 & WD_TP39_estTP02 >= 360) = ...
                        WD_TP39_estTP02(tmp_dt>=1 & tmp_dt<=3154 & WD_TP39_estTP02 >= 360)-360;
                    WD_TP39_estTP02(3155:9596,1) = WD_TP02(3155:9596,1) +32.7;
                    WD_TP39_estTP02(tmp_dt>=3155 & tmp_dt<=9596 & WD_TP39_estTP02 >= 360) = ...
                        WD_TP39_estTP02(tmp_dt>=3155 & tmp_dt<=9596 & WD_TP39_estTP02 >= 360)-360;
                    WD_TP39_estTP02(9597:end,1) = WD_TP02(9597:end,1) +15.5;
                    WD_TP39_estTP02(tmp_dt>=9597 & tmp_dt<=17520 & WD_TP39_estTP02 >= 360) = ...
                        WD_TP39_estTP02(tmp_dt>=9597 & tmp_dt<=17520 & WD_TP39_estTP02 >= 360)-360;
                    
                    %                 tmp4 = output(:,8);
                    % Fill the Data: Fill from TP74 first, and then TP02:
                    output(isnan(output(:,8))==1,8) = WD_TP39_estTP74(isnan(output(:,8))==1,1);
                    output(isnan(output(:,8))==1,8) = WD_TP39_estTP02(isnan(output(:,8))==1,1);
                    
                    %
                    %                 figure(80);clf;
                    %                 plot(output(:,8),'r'); hold on;
                    %                 plot(tmp4); hold on;
                    %
                    % clear unneeded variables:
                    clear WD_TP39_estTP74 WD_TP39_estTP02 tmp*
                    
                    % Fill missing CNR1 data with the temporary NR-Lite
                    % data:
                    TP39_NRL = load([loadstart 'Matlab/Data/Met/Final_Cleaned/TP39_NRL/TP39_NRL_met_cleaned_2011.mat']);
                    NRL = TP39_NRL.master.data(:,4);
                    output(isnan(output(:,24)),24) = NRL(isnan(output(:,24)),1);
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = NaN;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2012'
                    % Bad SMB100 data
                    output([1:221 7806:7809 10415:12894 17317],100) = NaN;
                    % Bad SMB50 data
                    output([7805:7809 10416 14562:14575 17316 17317],99) = NaN;
                    % Bad CO2 canopy data
                    output([598:601 6855:6860 1053 10416:10417 16597 16598 17318], 71) = NaN;
                    % Bad SM 20cm A Pit
                    output([7074:7075 8276:10212],93) = NaN;
                    % Bad SM 5cm B Pit
                    output([17316:17317],96) = NaN;
                    % Bad SM 20cm B Pit
                    output([7805:7809 17316:17317],98) = NaN;
                    % Bad CO2 below canopy data
                    output([1:1568],72) = NaN;
                    % Bad RMY Rain data
                    output(:,11) = NaN;
                    % Bad snow temp data
                    output([173 4785 5500 5536 5542 7574 7810 8805 8907 10417],30) = NaN;
                    % Bad 2m NR-Lite data
                    output([766 1076:1078 1468:1471 2190:2192],12) = NaN;
                    % Removal of 2m NR-Lite (sensor stolen)
                    output(9275:end,12) = NaN;
                    % Bad group temp data
                    output([4785 8907],29) = NaN;
                    % Bad snow depth data ***SOMEONE NEEDS TO CLEAN THIS***              
                    output([620:631 768 782 799 910 955 974 996 1001 1036 1109 1220 1223 1340 1404:1408 1423 1434 1441 ...
                        1473 1501 1523 1981 1992 2016 2231 2289 2489 2502 2515 2536 2537 2588 2872 2875 5812 5813 5921 ...
                        5927 9671 10033 10106 10145 10146 10155 10228 10378 10388 10473 10519 10781 10804 10949 10973 11055 ...
                        11691 12083 12101 12255 12301 12307 12567 12753 13822:13832 14030 14072 14082 14085 14090:14092 14096 ...
                        14136 14189 14190 14220 14249 14424 14425 14538 14540 14547 14550 14583 14594 15105 15632 15847 15866 ...
                        15882:15884 16019 16210 16241 16267 16428 16429 16450 16810 16819 16857 17014 17052 17066 17074 17086 ...
                        17369:end],31) = NaN;
                    
                    %%%%%%%%%%%%%%%%%%%% correcting too-low PAR values %%%
                    % using correlation with SW down:
                    PAR_tmp = output(:,9); SWdown_tmp = output(:,14);
                    figure(77);clf; plot(PAR_tmp,SWdown_tmp,'k.');
                    % line of best-fit
                    p = polyfit(SWdown_tmp(~isnan(PAR_tmp+SWdown_tmp)),PAR_tmp(~isnan(PAR_tmp+SWdown_tmp)),1);
                    PAR_pred = polyval(p,SWdown_tmp);
%                     PAR_diffn = (PAR_tmp - PAR_pred)./PAR_pred;
%                     figure(78);plot(PAR_diffn,'k.')
%                     figure(79);clf;plot(PAR_tmp,'b'); hold on; plot(PAR_pred,'r');
                    % fix for the affected period:
                    output(11200:11530,9) = PAR_pred(11200:11530,1);
                     clear PAR_tmp SWdown_tmp PAR_pred p;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    % Offset (0.05) 12568:17568
                    output(12568:17568,[31]) = output(12568:17568,[31])+0.048;
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2013'
                    %%% Important Note: all of these data point values refer
                    %%% to those plotted during the first check of the data.
                    %%% The data is time shifted after tehse corrections are
                    %%% made, so data point numbers in the 'final check' may
                    %%% be different.
                    
                    % Bad RMY Rain data
                    output(:,11) = NaN;
                    % Bad 2m NR-Lite
                    output(:,12) = NaN;
                    % Bad ground temp
                    output([7122 8572 9610 9615 10523 13612 13428],29) = NaN;
                    output([1320 1431:1435 1723:1724 4075 5801:5802 7760 8482 8567 9602],71) = NaN;
                    % Bad snow sensor data
                    output(7759,27) = NaN;
                    % Bad snow temp data
                    output([7122 9610 9615 13428],30) = NaN;
                    % Bad snow depth data ***SOMEONE NEEDS TO CLEAN THIS***
                    output([16 19 20 25 26 28 158 362 382 411 412 418 421 425 433:435 439 470 498 828 879 887 1197 1459 ...
                        1879 1900 1903 1944 2053 2444 2447 2467 2473 2475 2530 2637 2734 2824 3262 3268:3276 3292 3305 ...
                        3337 3338 3380 3691 3717 3827 3918 3926 3977 3978 4009 4712 4759 4761 5131 6171 7123 8529:8531 ...
                        8845 9004 9473 9475 9482 9603 9605 10251 10530 10533 10763 11432 11433 11485 11748 15856 16213 ...
                        16504],31) = NaN;
                     
                    % Shift everything the offset? (0.05) 1:17568 ****
                    % Delhi data shows 20 cm December 16th, measured here
                    output(1:17520,[31]) = output(1:17520,[31])+0.05;
                    
                    % Bad tree temperature and snow temperature data (no sensors)
                    output(:,33:64) = NaN;
                    
                    % Bad Soil Heat Flux HFP1 data point
                    output(1557:1560,65) = NaN;
                    % Bad Soil Heat Flux HFP2 data (flatlines/spike)
                    output(6570:16819,66) = NaN;
                    % Bad SHFC1 data
                    output([1351:1356 14365:1437 14359:14362],69) = NaN;
                    % bad CO2 canopy data
                    output([1:5802 7760 8482 8567],71) = NaN;
                    % Bad CO2 below canopy data (no sensor)
                    output(:,72) = NaN;
                    
                    % Bad SM B 50cm data
                    output([1320:1322 1723 13611],99) = NaN;
                    % Bad SM B 100 data
                    output(13611,100) = NaN;
                    
                    %%% Fix time shifts introduced into flux data by computer
                    %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2013)
                    output = [output(1:4274,:);output(4277:9106,:);NaN.*ones(2,size(output,2));output(9107:12924,:);output(12927:13863,:);...
                        NaN.*ones(2,size(output,2)); output(13864:17520,:)];
                    %
                    % Round 2 of fixes - found issues in the internal data logger clock
                    output = [output(1:4740,:);NaN.*ones(1,size(output,2)); output(4741:5051,:); output(5053:11533,:); output(11535:12119,:);NaN.*ones(1,size(output,2));...
                        output(12120:17520,:)];
                    %                     output = [output(1:4274,:);output(4277:4741,:);NaN.*ones(1,size(output,2));output(4742:5051,:); output(5053:9106,:);NaN.*ones(2,size(output,2));...
                    %                         output(9107:11532,:); output(11534:12118);  output(9107:12924,:);output(12927:13863,:);...
                    %                         NaN.*ones(2,size(output,2)); output(13864:17520,:)];
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2014'
                    % Wind sensor not working
                    output(14525:16159,7:8) = NaN;
                    % Up Par in mid-summer not working
                    output(7132:8782,10) = NaN;
                    % Bad RMY Rain data
                    output(:,11) = NaN;
                    % Missing 2m NR-Lite
                    output(:,12) = NaN;
                    % Bad snow depth data
                    output([4109 4905 5635 6185 8782 9116 10892 11719 13387 13894 14571 15485:15487 15494 15504 15505 15507 15529 15537 15737 15781 ],[27:28 31]) = NaN;
                    % Bad ground temp data
                    output([8993 8995 9116 10892 11719],29) = NaN;
                    % Bad snow temp and depth data
                    output([8995 9116 10892 15751],30) = NaN;
                    
                    output(1323,31) = NaN; % Snow depth point
                    
                    % Bad tree temperature and snow temperature data (no sensors)
                    output(:,33:64) = NaN;
                    
                    % Spike in SHF HFP1
                    output([1542 14311 14331],65) = NaN;
                    % Spikes in SHF MV1 and MV2
                    output([1535:1536 1542],67:68) = NaN;
                    % Bad SHFC1 data - Not sure if we need to do this one
                    % (Cal)
                    %output([348 1669],69) = NaN;
                    
                    % bad CO2 canopy data
                    output([323 7091 10122 13874 15778],71) = NaN;
                    % Bad CO2 below canopy data (no sensor)
                    output(:,72) = NaN;
                    
                    % Bad pressure points
                    output(9697:9699,76) = NaN;
                    % Bad SM B 50cm data
                    output([1316:1322 7872:7876 13873:13894 15737:15751 15777:15781],99) = NaN;
                    % Bad SM B 100 data
                    output([7872:7876 11492:11494 13875:13894 15738:15751 15779:15780],100) = NaN;
                    % Soil temperature spikes
                    output(11415,79) = NaN;
                    %%% Fix time shifts introduced into flux data by computer
                    %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2014)
                    output = [output(1:4276,:);output(4279:14307,:);NaN.*ones(2,size(output,2));output(14308:17520,:)];
                    
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2015'
                    % Bad Ta points
                    output([6906 8615:8623 11508:11509 12365],1) = NaN;
                    output([8691:8787],2) = NaN;
                    output([8617:8737],3) = NaN;
                    
                    % Bad snow depth data
                    output([396 404 417 419 422 470 472 474 4670 4790 8320 8534 9016 10652 11746 11934 12922 12927 12923 12932 12983 14487 14503],27:28) = NaN;
                    output([7251 8615 8616 8623 10652 11508:12365 12926 14487],28) = NaN;
                    output([396 404 417 419 422 470 472 474 4670 8615:8623 11508:12365 12922 12927 12923 12932 12983 14503 15159],31) = NaN;
                    
                    % Bad ground and snow temp
                    output([7251 8320 8534 8615:8623 9016 10652 11507:11509 12365 11934 12922 12927 12923 12932 12983 14487],29:30) = NaN;
                    
                    %%% Fix Gain and Offset errors in RHdata (column 4) data after point 12365
                    mean_RH1 = nanmean(output(1:12365,4)); std_RH1 = nanstd(output(8000:12365,4));
                    mean_RH2 = nanmean(output(12366:17520,4));std_RH2 = nanstd(output(12366:17520,4));
                    tmp1 = output(1:12365,4); tmp2 = output(12366:17520,4);
                    tmp2 = tmp2 - (mean_RH2 - mean_RH1); % correct offset;
                    tmp2_dev = tmp2-nanmean(tmp2);
                    tmp2_adj = tmp2_dev.*(std_RH1./std_RH2) + nanmean(tmp2); % correct gain error.
                    output(:,4) = [tmp1; tmp2_adj];
                    clear tmp* mean_* std_*
                    
                    % Bad soil heat flux cal
                    output([14487:14490],69:70) = NaN;
                    
                    % Bad CO2 cnpy
                    output([4687 5309 5310 7251 7808 8623 9014:9016 12922 12923 12927 12932 12983 14487],71) = NaN;
                    % Bad Pressure data
                    output([2265:2816 2821 2917 3251 3252 3389 4356 4793 4974 4991 6129:6192 6390:6413 6688:7809 9732:10432 10913:10943 11012 11493:1150 15660:15824],76) = NaN;
                    % N2 tank pressure
                    output([3044],77) = NaN;                    
                    % Soil temp B 2 cm
                    output([15159],90) = NaN;                    
                    % Bad SM B 5cm
                    output([9012:9015],96) = NaN;
                    % Bad SM B 20cm + 50cm
                    output([7248:7250 9012:9015 ],98:99) = NaN;
                    output([11745],[98 99]) = NaN;
                    output([7248:7250 15159],98:100) = NaN;                    
                    % Bad SM B 100cm
                    output([7249 7250 9013:9015],100) = NaN;                    
                    
                    %%% Fix time shifts introduced into flux data by computer
                    %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2015)
                    output = [output(1:4178,:);output(4181:11124,:);NaN.*ones(2,size(output,2));output(11125:17520,:)];
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Wind speed (col 7) is bad from ~5650 onwards -- the bearing had broken
                    % Need to fix it by replacement with CSAT data:
                    ws = output(:,7);
                    ws(5651:16393) = NaN; % bearing started to wear out after this point. Replaced on Dec 8(~16393)
                    CPEC = load([loadstart 'Matlab/Data/Flux/CPEC/TP39/Final_Cleaned/TP39_CPEC_cleaned_2015.mat']);
                    u = CPEC.master.data(:,19);v = CPEC.master.data(:,20);
                    WS_CPEC = sqrt(u.^2 + v.^2);
                    p = polyfit(ws(~isnan(ws.*WS_CPEC)),WS_CPEC(~isnan(ws.*WS_CPEC)),1);
                    WS_CPEC_corr = WS_CPEC;
                    ws(isnan(ws),1) = WS_CPEC_corr(isnan(ws),1);
                    ws(ws<0) = 0;
                    output(:,7) = ws;
                    clear u v ws p WS*;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Swap mislabeled HMPs - For 2007--2015:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2016'
                    % Remove bad RH_cpy 
                    output(6095:8089,5) = NaN;
                    % Air Temp below canopy
                    output([177 3922 6091 6273 6376],1:6) = NaN;
                    % Wind Speed & Dir of Zero Removed
                    output([1898:1900 2933:3109 3841 6081:6088 9910 13427 13738 17330:17337],7:8) = NaN;
                    % Panel Temp dip
                    output([2767:2777],13) = NaN;
                    output([2767:2777],78) = NaN;
                    % Upward Shortwave Rad
                    output([2925:2941],15) = NaN;
                    % Upward Longwave Rad
                    output([5994 5995],17) = NaN;
                    % Bad snow depth data
                    output([99 107 126 131 253 393 415 553 1453 2777 3687 3922 4206 4211 4256 5793 6090 6273],27:28) = NaN;
                    output([106],28) = NaN;
                    output([99 106 107 126 131 253 393 415 553 2620 3919 3922 4206 4211 4256 6090 6273 14528],31) = NaN;
                    % Ground and Snow Temp
                    output([4206 4211 6273 10046 10991],29:30) = NaN;
                    % Soil Heat Flux H1
                    output(17323:17334,[65 67]) = NaN;
                    % Soil Heat Flux Cal
                    output([2118:2418 6374:6378],69) = NaN;
                    % CO2 canopy dips
                    output([1960 2620 4210 6765 13228 13459],71) = NaN;
                    % Down PAR
                    output([5466 5651 5658 5794 5947 5985 6080],75) = NaN;
                    % Pressure
                    output([852:1572 2768:3132 3461:3530 3918 5983 12222],76) = NaN;
                    % SM B 50 cm
                    output([10984:10985 13228],99) = NaN;
                    % SM B 100 cm
                    output([2374 2380 17333:17335],100) = NaN;
                    % Swap mislabeled HMPs - For 2007--2016:
                    % labeled as    | should be
                    %   abv         | gnd
                    %   gnd         | cpy
                    %   cpy         | abv
                    Ta_abv_orig = output(:,1); RH_abv_orig = output(:,4);
                    Ta_cpy_orig = output(:,2); RH_cpy_orig = output(:,5);
                    Ta_gnd_orig = output(:,3); RH_gnd_orig = output(:,6);
                    output(:,1)=Ta_cpy_orig(:,1);
                    output(:,2)=Ta_gnd_orig(:,1);
                    output(:,3)=Ta_abv_orig(:,1);
                    output(:,4)=RH_cpy_orig(:,1);
                    output(:,5)=RH_gnd_orig(:,1);
                    output(:,6)=RH_abv_orig(:,1);
                    clear *abv_org *gnd_orig *cpy_orig;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2017'
                    % Panel Temp Dips
                    output([1568 2096:2099 3104 3250:3255 15632:15635 16214:16218 16276:16279],13) = NaN;
                    % Up Longwave Below Canopy
                    output([8628],17) = NaN;
                    % Net Longwave Abv Canopy
                    output([1208 2817],[22 23]) = NaN;
                    % Bad snow depth data
                    output([491 1620 3248 3992 7108 13822 14209 15556 16276],[27 28 30 31]) = NaN;
                    % Ground Temp Outliers
                    output([3992 13822 14209],29) = NaN;
                    % Soil Heat Flux HFP
                    output([3248:3260 5764:5766 10710:10712],[65 66]) = NaN;
                    % Soil Heat Flux Cal 1
                    output([289:300 480 703:732 798 10333 10338],69) = NaN;
                    % Soil Heat Flux Cal 2
                    output([265:480 685:697 2281:2304 10333:10338 10363:10368],70) = NaN;
                    % CO2 Canopy Spikes
                    output([3205 3248 8919 10490 14209 14726 15556 16214],71) = NaN;
                    % Down PAR Below Canopy
                    output([38 278 3018 3834 3871 4694 4973 6171],75) = NaN;
                    % Panel Temperature
                    output([2096:2098 3205:3252],78) = NaN;
                    % Soil Temperature A 2cm
                    output([10711:10764],79) = NaN;
                    % Soil Temperature B 2cm
                    output([13822 15556],90) = NaN;
                    % Soil Temperature A 50 cm
                    output(9340:17520,80) = NaN;
                    % SM A 20cm
                    output([9950:17520],93) = NaN;
                    % SM B 5cm, 20cm, 50cm
                    output([13815 13816 14208 16275],[96 98 99]) = NaN;
                    % SM B 100cm
                    output([1:11699 13815 13816 14208 16275],100) = NaN;
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2018'
                    % Panel Temp Dips     
                    output([225:233 463:471 896 897 2144:2150 2889:2899 3200:3208 4493:4524 4995:5003 5029:5038 ...
                        13779 13949:13955 14881:14884 15160:15164 15923:15929 16495:16499],13) = NaN;
                    % Longwave (Down & Net)
                    output([6554 11707],[18 22]) = NaN;                                       
                    % Snow Depth Distance
                    output([4469 4493 4513 5029 5947 12675 13761 13779 14071 14091 14881],[27 28 30]) = NaN;
                    % Ground Temp
                    output([4469 4513 5029 5947 12675],29) = NaN;
                    % Soil Heat Flux Cal 1
                    output([7249:7254],69) = NaN;
                    % CO2 Canopy Spikes
                    output([2768 2889:2892 3882 4927 6186 8153 11366 14917 16497],71) = NaN;  
                    % Down PAR below canopy
                    output([6517 6565 6613 16886],75) = NaN;  
                    % Ts50A - incorrect values all year. Removing, but can change to an offset correction if a value can be found
                    output(:,80) = NaN;  
                    % Ts2A - bad data for ~20 data points. Really high spike.
                    output(10533:10559,79) = NaN;
                    % SM20A - Removing all values. Sensor appears broken
                    output(:,93) = NaN; 
                    % Set whether RH > 100 should be set to 100 or NaN:
                    RH_max = 100;
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
                case '2019'
                    % Invert sign for LW BC Up- and Down-welling
                    output(:,[16,17]) = output(:,[16,17]).*-1;
            end
            %%% Corrections applied to all years of data:
            % 1: Set any negative PAR and nighttime PAR to zero:
            PAR_cols = [];
            PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1)];
            PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1)];
            PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)];
            %Plot uncorrected:
            figure(97);clf;
            subplot(211)
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Uncorrected PAR');
            %         if year <= 2008
            [sunup_down] = annual_suntimes(site, year_ctr, 0);
            %         else
            %             [sunup_down] = annual_suntimes(site, year, 0);
            %         end
            ind_sundown = find(sunup_down< 1);
            
            switch yr_str
                case {'2002';'2003';'2004'};
            DownParBot = 15;
            UpParBot = 15;
            DownParBlwBot = 80;
                otherwise
               DownParBot = 15;
               UpParBot = 15;
            DownParBlwBot = 15;
            end
            
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            output(output(:,PAR_cols(1)) < DownParBot & sunup_down < 1,PAR_cols(1)) = 0;
            output(output(:,PAR_cols(2)) < DownParBot & sunup_down < 1,PAR_cols(2)) = 0;
            output(output(:,PAR_cols(3)) < DownParBlwBot & sunup_down < 1,PAR_cols(3)) = 0;
            output(output(:,PAR_cols(1)) < 0 , PAR_cols(1)) = 0;
            output(output(:,PAR_cols(2)) < 0 , PAR_cols(2)) = 0;
            output(output(:,PAR_cols(3)) < 0 , PAR_cols(3)) = 0;
            
            % Plot corrected data:
            figure(97);
            subplot(212);
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Corrected PAR');
            
            % 2: Set any RH > 100 to NaN -- This is questionable whether to make
            % these values NaN or 100.  I am making the decision that in some
            % cases
            RH_cols = [];
            RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_AbvCnpy')==1)];
            RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_Cnpy')==1)];
            RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_BlwCnpy')==1)];
            % Adjust columns to match output:
            %     RH_cols = RH_cols - 6;
            figure(98);clf;
            subplot(211)
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Uncorrected RH')
%             commandwindow;
            if ~isempty(RH_max)
                RH_resp = RH_max; % RH_max should be set within each year of data.
            else
                commandwindow;
                RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            end
%             RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            for j = 1:1:length(RH_cols)
                output(output(:,RH_cols(j)) > 100,RH_cols(j)) = RH_resp;
            end
            subplot(212);
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Corrected RH');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        case 'TP74'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP74  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2002'
                    [r c] = size(output);
                    % there's a 1/2 hour offset in data from first half of 2002
                    output_tmp(:,:) = [output(2:9070,1:c); NaN.*ones(1,c); output(9071:end,1:c)];
                    clear output;
                    output = output_tmp;
                    clear r c output_tmp;
                    
                    
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load last 8 datapoints from 2001
                    num_to_shift = 8;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2001.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:num_to_shift,i) = temp_var(end-num_to_shift+1:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-num_to_shift,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                    
                case '2003'
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2002.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2002 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:8,i) = temp_var(end-8+1:end);
                        clear temp_var;
                    end
                    output = [fill_data(:,:); output(9:end,:)];
                    clear fill_data;
                    % It appears there is a shift in data at the 15535 point,
                    % where data is shifted back until 17464
                    [r c] = size(output);
                    output_tmp(:,:) = [output(1:15534,1:c); NaN.*ones(1,c); output(15535:17464,1:c); output(17466:r,1:c)];
                    clear output;
                    output = output_tmp;
                    clear r c output_tmp;
                    
                case '2005'
                    
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load first 1 datapoint from 2006
                    num_to_shift = -1;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2006.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:abs(num_to_shift),i) = temp_var(1:0-num_to_shift);
                        clear temp_var;
                    end
                    output_test = [ output(1-num_to_shift:end,:); fill_data(:,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                    output(608,22) = NaN; % Bad Ts data (Pit B, 5cm)
                    
                case '2007'
                    
                case '2008'
                    
                    
                    % Remove Spike from SM data:
                    output(11077:11080,12:32) = NaN;
                    output(12570:12571,12:32) = NaN;
                    output(9732:9733,12) = NaN;
                    output(13129:13130,12) = NaN;
                    output(1:10444,24) = NaN; % 80-100cm sensor doesn't work for first part of year.
                    % Remove Spikes from SHF Data:
                    output(1:10452,11) = NaN;
                    % Remove Spikes from Ts Data (there are a lot of them):
                    %                 ctr2 = 1;
                    resp = 'y';
                    for col = 12:1:23
                        
                        try
                            tracker = load([tracker_path 'TP74_2008_tr.0' num2str(col)]);
                            disp(['loading tracker for column ' num2str(col) '. ']);
                            if strcmp(resp,'q')~=1
                                resp = input('Do you want to continue to edit the tracker? (<y> to edit, <n> to skip, q to quit): ', 's');
                                
                                if strcmp(resp,'y') == 1;
                                    output(:,col) = output(:,col).*tracker;
                                    clear tracker
                                    
                                    [tracker] = jjb_remove_data(output(:,col));
                                    
                                    save([tracker_path 'TP74_2008_tr.0' num2str(col)],'tracker','-ASCII')
                                else
                                end
                            end
                            
                        catch
                            [tracker] = jjb_remove_data(output(:,col));
                            save([tracker_path 'TP74_2008_tr.0' num2str(col)],'tracker','-ASCII')
                            
                            
                        end
                        
                        output(:,col) = output(:,col).*tracker ;
                        clear tracker
                        %                    ctr2 = ctr2+1;
                    end
                    
                    % Remove bad HMP RH Data during 2008
                    right_col = quick_find_col( names30, 'RelHum_AbvCnpy');
                    output(11363:12475,right_col) = NaN; clear right_col;
                    
                    % Remove bad HMP Ta Data during 2008
                    right_col = quick_find_col( names30, 'AirTemp_AbvCnpy');
                    output(11363:12475,right_col) = NaN; clear right_col;
                    
                    % Shift data so that it's all in UTC:
                    % need to load last 8 datapoints from 2007
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2007.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2007 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:8,i) = temp_var(end-7:end);
                        clear temp_var;
                    end
                    % only the starting 747 points were in EDT -- the rest is
                    % in UTC already:
                    output_test = [fill_data(:,:); output(1:747,:); output(756:end,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    
                    % Fix change in windspeed that results from moving wind
                    % sensor to new tower halfway through season -- we'll use the windspeed
                    % values from the CPEC system to fill in first half of
                    % season:
                    u = load([loadstart 'SiteData/TP74/MET-DATA/annual/TP74_2008.u']);
                    v = load([loadstart 'SiteData/TP74/MET-DATA/annual/TP74_2008.v']);
                    WS_CPEC = sqrt(u.^2 + v.^2);
                    
                    figure(77)
                    right_col2 = quick_find_col( names30, 'WindSpd');
                    ind = find(output(1:10454,right_col2)>0.3 & WS_CPEC(1:10454,1)>0.3) ;
                    plot(output(ind,right_col2),WS_CPEC(ind),'b.');
                    ylabel('CPEC WS'); xlabel('MET WS');
                    p = polyfit(output(ind,right_col2),WS_CPEC(ind),1);
                    output(1:10454,right_col2) = output(1:10454,right_col2).*p(1) + p(2);
                    output(isnan(output(:,right_col2)),right_col2) = WS_CPEC(isnan(output(:,right_col2)),1);
                    %                 output(1:10454,4) = NaN;
                    %                 output(isnan(output(:,4)),4) = WS_CPEC(isnan(output(:,4)),1);
                    clear u v WS_CPEC ind p right_col2;
                    
                    
                    %%% Cycle through variables
                    %                 for i = 1:1:length(vars30)
                    %                     temp_var = load([load_path site '_2008.' vars30_ext(i,:)]);
                    %                     fill_data(1:8,i) = temp_var(end-7:end);
                    %                     clear temp_var;
                    %                 end
                    
                    %                 for i = 1:1:length(vars30)
                    %                     [spike_tracker] = jjb_find_spike(output(:,i), 2);
                    %                 end
                    
                case '2009'
                    % Remove spikes in soil data:
                    output(6128:8494,1:2) = NaN;
                    output(2004,12) = NaN;
                    bad_data = [10741:10981 12759 12765];
                    output(bad_data,12:32) = NaN;
                    output([10134;10135; 10217],29) = NaN;
                    
                case '2010'
                    output(6316, [12:32]) = NaN;
                    % Bad Soil Temperature data at Pit A, 100cm:
                    bad_data = [11794 12410 12411 13215:13229 13748:13752 15362:15366 15627 16008:16011];
                    % Bad Point in all Soil Data:
                    output(bad_data, 12) = NaN;
                    output(6316,12:32) = NaN;
                case '2011'
                    % Missing Data in all fields
                    output(6476:6708, 1:51) = NaN;
                    % Remove bad spikes in soil data at Pits A and B, all depths:
                    output(15259,13:32) = NaN;
                    output(15259,48:51) = NaN;
                    % Remove bad data from CO2 Canopy
                    output([3911 9166],47) = NaN;
                    % Remove Spikes from Ts Data (there are a lot of them):
                    %                 ctr2 = 1;
                    resp = 'y';
                    for col = 12:1:23
                        
                        try
                            if exist([tracker_path 'TP74_2011_tr.0' num2str(col)],'file')==2
                                tracker = load([tracker_path 'TP74_2011_tr.0' num2str(col)]);
                                disp(['loading tracker for column ' num2str(col) '. ']);
                            else
                                tracker = ones(yr_length(2011,30),1);
                                disp(['create tracker for column ' num2str(col) '. ']);
                            end
                            
                            
                            if strcmp(resp,'q')~=1
                                resp = input('Do you want to continue to edit the tracker? (<y> to edit, <n> to skip, q to quit): ', 's');
                                
                                if strcmp(resp,'y') == 1;
                                    output(:,col) = output(:,col).*tracker;
                                    clear tracker
                                    
                                    [tracker] = jjb_remove_data(output(:,col));
                                    
                                    save([tracker_path 'TP74_2011_tr.0' num2str(col)],'tracker','-ASCII')
                                else
                                end
                            end
                            
                        catch
                            [tracker] = jjb_remove_data(output(:,col));
                            save([tracker_path 'TP74_2011_tr.0' num2str(col)],'tracker','-ASCII')
                            
                            
                        end
                        
                        output(:,col) = output(:,col).*tracker ;
                        clear tracker
                        %                    ctr2 = ctr2+1;
                    end
                    
                case '2012'
                    % Bad CO2 canopy data
                    output([601 7805 10417 16632],47) = NaN;
                    % Bad tree temp sensors
                    output(:,33:43) = NaN;
                    % Bad Ts 100cm Pit A
                    output([5345:5349 5465:5468],12) = NaN;
                    
                case '2013'
                    % Bad windspeed data (broken instrument)
                    output(10303:12087,4) = NaN;
                    % Bad wind direction data (broken instrument)
                    output(10303:12087,5) = NaN;
                    % Bad UpPAR Above Canopy data
                    output(6764:8100,6) = NaN;
                    % Missing DownPAR Above Canopy data
                    output(:,9) = NaN;
                    % Bad ST A100cm data
                    output([6806 8031 8485],12) = NaN;
                    % Bad ST A50cm data
                    output([5790 6806 8031 8101 8485],13) = NaN;
                    % Bad ST A20cm data
                    output([5790 6806 8031 8101 8485],14) = NaN;
                    % Bad ST A10cm data
                    output([5790 6806 8031 8101 8485],15) = NaN;
                    % Bad ST A5cm data
                    output([5790 6806 8031 8101 8485],16) = NaN;
                    % Bad ST A2cm data
                    output([5790 6806 8031 8101 8485],17) = NaN;
                    % Bad ST B100cm data
                    output([6806 8031 8485],18) = NaN;
                    % Bad ST B50cm data
                    output([5790 6806 8031 8101 8485],19) = NaN;
                    % Bad ST B20cm data
                    output([5790 6806 8031 8101 8485],20) = NaN;
                    % Bad ST B10cm data
                    output([5790 6806 8031 8101 8485],21) = NaN;
                    % Bad ST B5cm data
                    output([5790 6806 8031 8101 8485],22) = NaN;
                    % Bad ST B2cm data
                    output([5790 6806 8031 8101 8485],23) = NaN;
                    % Bad SM B80-100cm data
                    output([6806 8031 8485],24) = NaN;
                    % Bad SM A50cm data
                    output([5790 6806 8031 8101 8485],25) = NaN;
                    % Bad SM A20cm data
                    output([5790 6806 8031 8101 8485],26) = NaN;
                    % Bad SM A10cm data
                    output(8031,27) = NaN;
                    % Bad SM A5cm data
                    output([8031],28) = NaN;
                    % Bad SM B50cm data
                    output([6806 8031 8485],29) = NaN;
                    % Bad SM B20cm data
                    output(8031,30) = NaN;
                    % Bad SM B10cm data
                    output(8031,31) = NaN;
                    % Bad SM B5cm data
                    output(8031,32) = NaN;
                    % Bad tree temp sensors
                    output(:,33:43) = NaN;
                    % Bad CO2 canopy data
                    output([1:8444 8565 13610],47) = NaN;
                    % Bad SM DR100cm data
                    output([5790 6806 8031 8101 8485],48) = NaN;
                    % Bad SM DR50cm data
                    output([5790 6806 8031 8101 8485],49) = NaN;
                    % Bad SM DR20cm data
                    output(8031,50) = NaN;
                    % Bad SM DR5cm data
                    output([6806 8031],51) = NaN;
                    
                case '2014'
                    % Bad UpPAR Above Canopy data
                    output(3433:3452,6) = NaN;
                    % Questionable Rn
                    output([4068 4800 10707 10709],9) = NaN;
                    % Missing DownPAR Above Canopy data
                    output(:,9) = NaN;
                    % Bad ST A100cm data
                    output([10402 11715:11720 11908:11912 11095:11100 ],12) = NaN;
                    % Bad ST A20cm data
                    output(5894:5898,14) = NaN;
                    output(9815:12271,14) = NaN; % Shift upwards (>10 deg in a few hrs)
                    % Bad tree temp sensors
                    output(:,33:43) = NaN;
                    % Bad CO2 canopy data
                    output([1316:1324 11508 12363:12364 13872:13874],47) = NaN;
                    % Spikes in SM DR 100 cm
                    output([12743 12781 12791 12977],48) = NaN;
                    
                    
                case '2015'
                    % Bad Ta data
                    output(9149,1) = NaN;
                    % Bad Rn sensor
                    output([12975:16212],8) = NaN;
                    % Spike in Ts A 100cm
                    output([7211 7237 8671 10649 10653],12) = NaN;
                    % Remove spike in Ts A 20cm
                    output(3920,14) = NaN;
                    % Spike in Ts B 100 cm
                    output([1751:1752],18) = NaN;
                    % Remove spike in Ts Pit B 20cm
                    output(7248,20) = NaN;
                    % Ts A 20 cm seems to be too high most year
                    output(3654:17520,14) = NaN;
                    % Remove spike in Tank Pressure N2 Cal
                    output([614 2912 2913],45) = NaN;
                    % Bad CO2 IRGA
                    output([2915 6471 7433 7810 7899 11745:11746],47) = NaN;
                    % Try to rescale CO2 IRGA - simplest approach might be
                    % to multiply by 2:
                    output([8629:9149],47) = output([8629:9149],47).*2;
                    %                     tmp1 = output([8629:9149],47); tmp2 = output([9155:17520],47);
                    %                     std1 = nanstd(tmp1);std2 = nanstd(tmp2);
                    %     mean1 = nanmean(tmp1);mean2 = nanmean(tmp2);
                    
                case '2016'
                    % Air Temp
                    output([4979],1) = NaN;
                    % Wind Speed
                    output([9764:9777],4) = NaN;
                    % Soil Heat Flux
                    output([2450:2627],10:11) = NaN;
                    % Soil temp A 100 cm
                    output([1392 2222 2250 2624:2625 5036 ...
                        8554 9764:9766 10199 10272 10273 12190],12) = NaN;
                    % Recent Soil dips
                    output([7103 7244 7245 14412:14414],12:24) = NaN;
                    % Soil temp B 50 cm
                    output([1390 1591 3198:3202 9763],19) = NaN;
                    % Soil temp B 20 cm
                    output([737 1392 3196:3198],20) = NaN;
                    % Recent Soil dips
                    output([7103 7244 7245],29) = NaN;
                    % Recent Soil dips
                    output([7103 7244 7245],32) = NaN;
                    % CO2 Canopy
                    output([2620 2651 2777 4210 4211 17337],47) = NaN;
                    % Recent Soil dips
                    output([7103 7244 7245],48:49) = NaN;
                    
                case '2017'
                    % Relative Humidity
                    output([1954 2960 5441 7862 7956 8730 11077 13450 16400],2) = NaN;
                    % Soil Temp A 100cm
                    output([4503 5764:5797 8337 10712 10713 11777:11781 13500:13513],12) = NaN;
                    % Soil Temp B 50 cm
                    output([5765:6199],19) = NaN;   
                    % Soil Moisture A 20cm
                    output([10712],26) = NaN;
                    % Soil Moisture A 10cm
                    output([11776:11779],27) = NaN;
                    % CO2 Canopy Dips
                    output([491 3205 3249 4209 6132 8916 13822 14208 14209 14725 15555 15556 15635],47) = NaN;

                case '2018'    
                    % Random Spike in all soil data
                    output([9968 10534 11941],[12:30 48:51]) = NaN;
                    % CO2 Canopy Dips
                    output([2770 2880 2890 4513 4930 5023 5029 7134 7138 7519 7569 7571 7575 8146 ...
                        8909 11221 13761 13779 14090 14091 14249 16500],47) = NaN;
                    % Down PAR Abv Cnpy
                    output([13175:17520],7) = NaN;
                    % SM DR 100 cm
                    output([4484],[48 49]) = NaN;
                    RH_max = 100;
                  case '2019'   
                    
            end
            %% Corrections applied to all years of data:
            % 1: Set any negative PAR and nighttime PAR to zero:
            PAR_cols = [];
            try
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)];
            catch
            end
            %%% Set the bottoms of PAR (a
            if strcmp(site,'TP74')==1 && year_ctr == 2003
                DownParBot = 19;
                UpParBot = 21.5;
                DownParBlwBot = 15;
            else
                DownParBot = 10;
                UpParBot = 10;
                DownParBlwBot = 10;
            end
            %Plot uncorrected:
            figure(97);clf;
            subplot(211)
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Uncorrected PAR');
            %         if year <= 2008
            [sunup_down] = annual_suntimes(site, year_ctr, 0);
            %         else
            %             [sunup_down] = annual_suntimes(site, year, 0);
            %         end
            ind_sundown = find(sunup_down< 1);
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            try
                %             output(output(:,PAR_cols(1)) < 10 & sunup_down < 1,PAR_cols(1)) = 0;
                %             output(output(:,PAR_cols(2)) < 10 & sunup_down < 1,PAR_cols(2)) = 0;
                %             output(output(:,PAR_cols(3)) < 10 & sunup_down < 1,PAR_cols(3)) = 0;
                output(output(:,PAR_cols(1)) < DownParBot & sunup_down < 1,PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < UpParBot & sunup_down < 1,PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < DownParBlwBot & sunup_down < 1,PAR_cols(3)) = 0;
            catch
            end
            try
                output(output(:,PAR_cols(1)) < 0 , PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < 0 , PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < 0 , PAR_cols(3)) = 0;
            catch
            end
            % Plot corrected data:
            figure(97);
            subplot(212);
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Corrected PAR');
            
            % 2: Set any RH > 100 to NaN -- This is questionable whether to make
            % these values NaN or 100.  I am making the decision that in some
            % cases
            RH_cols = [];
            try
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_AbvCnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_Cnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_BlwCnpy')==1)];
            catch
            end
            % Adjust columns to match output:
            %     RH_cols = RH_cols - 6;
            figure(98);clf;
            subplot(211)
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Uncorrected RH')
            if ~isempty(RH_max)
                RH_resp = RH_max; % RH_max should be set within each year of data.
            else
                commandwindow;
                RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            end
%             RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            for j = 1:1:length(RH_cols)
                output(output(:,RH_cols(j)) > 100,RH_cols(j)) = RH_resp;
            end
            subplot(212);
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Corrected RH');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP89'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP89  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch yr_str
                case '2002'
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load last 8 datapoints from 2001
                    num_to_shift = 8;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2001.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:num_to_shift,i) = temp_var(end-num_to_shift+1:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-num_to_shift,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                case '2003'
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2002.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2002 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:8,i) = temp_var(end-8+1:end);
                        clear temp_var;
                    end
                    output = [fill_data(:,:); output(9:end,:)];
                    clear fill_data;
                case '2005'
                    
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load first 1 datapoint from 2006
                    num_to_shift = -1;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2006.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:abs(num_to_shift),i) = temp_var(1:0-num_to_shift);'/1/fielddata/Matlab/Scripts'
                        clear temp_var;
                    end
                    output_test = [ output(1-num_to_shift:end,:); fill_data(:,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                case '2007'
                case '2008'
                    % Adjust nighttime PAR to fix offset:
                    output(output(:,6) < 8,6) = 0;
                    % Adjust RH to be 100 when it is >100
                    output(output(:,2) > 100,2) = 100;
                    
                    % Shift data so that it's all in UTC:
                    % need to load last 8 datapoints from 2007
                    for i = 1:1:length(vars30)
                        temp_var = load([load_path site '_2007.' vars30_ext(i,:)]);
                        fill_data(1:8,i) = temp_var(end-7:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-8,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    
                    
            end
            %% Corrections applied to all years of data:
            % 1: Set any negative PAR and nighttime PAR to zero:
            PAR_cols = [];
            try
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)];
            catch
            end
            
            %Plot uncorrected:
            figure(97);clf;
            subplot(211)
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Uncorrected PAR');
            %         if year <= 2008
            [sunup_down] = annual_suntimes(site, year_ctr, 0);
            %         else
            %             [sunup_down] = annual_suntimes(site, year, 0);
            %         end
            ind_sundown = find(sunup_down< 1);
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            
            
            try
                output(output(:,PAR_cols(1)) < 10 & sunup_down < 1,PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < 10 & sunup_down < 1,PAR_cols(2)) = 0;
                if year >=2005 && year <=2006
                output(output(:,PAR_cols(3)) < 100 & sunup_down < 1,PAR_cols(3)) = 0;
                else
                output(output(:,PAR_cols(3)) < 10 & sunup_down < 1,PAR_cols(3)) = 0;
                end
            catch
            end
            try
                output(output(:,PAR_cols(1)) < 0 , PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < 0 , PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < 0 , PAR_cols(3)) = 0;
            catch
            end
            % Plot corrected data:
            figure(97);
            subplot(212);
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Corrected PAR');
            
            % 2: Set any RH > 100 to NaN -- This is questionable whether to make
            % these values NaN or 100.  I am making the decision that in some
            % cases
            RH_cols = [];
            try
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_AbvCnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_Cnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_BlwCnpy')==1)];
            catch
            end
            % Adjust columns to match output:
            %     RH_cols = RH_cols - 6;
            figure(98);clf;
            subplot(211)
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Uncorrected RH')
            if ~isempty(RH_max)
                RH_resp = RH_max; % RH_max should be set within each year of data.
            else
                commandwindow;
                RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            end
%             RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            for j = 1:1:length(RH_cols)
                output(output(:,RH_cols(j)) > 100,RH_cols(j)) = RH_resp;
            end
            subplot(212);
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Corrected RH');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TP02'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TP02  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% PAR Correction factors for 2002, 2013--2017 % Determined from TP02_par_correction_factor.m
            par_correction_factor = [2002, 1.23; 2013, 1.38199647061725; 2014, 1.26172364359607; 2015,1.03313933608525; 2016,0.874165785537350; 2017,0.659991285147933; 2018,0.585666951857723; 2019,1];
            par_correction_factor = par_correction_factor(par_correction_factor(:,1)==year_ctr,2);
            switch yr_str
                case '2002'
                    % Swap some mixed up SM sensors:
                    SM50B_orig = output(:,output_cols(strcmp(output_names,'SM_B_50cm')==1));
                    SM20B_orig = output(:,output_cols(strcmp(output_names,'SM_B_20cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SM_B_50cm')==1)) = SM20B_orig(1:end,1);
                    output(:,output_cols(strcmp(output_names,'SM_B_20cm')==1)) = SM50B_orig(1:end,1);
                    clear SM50B_orig SM20B_orig;
                    
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;
                    
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load last 8 datapoints from 2001
                    num_to_shift = 7;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2001.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:num_to_shift,i) = temp_var(end-num_to_shift+1:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:end-num_to_shift,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                case '2003'
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2002.' vars30_ext(i,:)]);
                        catch
                            disp(['could not load the 2002 variable: ' names30_str(i,:)]);
                            disp(['Check if column should exist -- making NaNs']);
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:8,i) = temp_var(end-8+1:end);
                        clear temp_var;
                    end
                    output = [fill_data(:,:); output(9:end,:)];
                    clear fill_data;
                    
                case '2004'
                    % Swap some mixed up SM sensors:
                    SM5B_orig = output(:,output_cols(strcmp(output_names,'SM_B_5cm')==1));
                    SM20B_orig = output(:,output_cols(strcmp(output_names,'SM_B_20cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SM_B_5cm')==1)) = SM20B_orig(1:end,1);
                    output(:,output0_cols(strcmp(output_names,'SM_B_20cm')==1)) = SM5B_orig(1:end,1);
                    
                    clear SM5B_orig SM20B_orig;
                    
                case '2005'
                    %%%%%%%%%%%%%%%%%%%%% START SHIFTING %%%%%%%%%%%%%%%%%%
                    % Shift data so that it's all in UTC: %%%%%%%%%%%%%%%%%%%%
                    % need to load first 1 datapoint from 2006
                    num_to_shift = -1;
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2006.' vars30_ext(i,:)]);
                        catch
                            %                         disp(['could not load the 2001 variable: ' names30_str(i,:)]);
                            %                         disp(['Check if column should exist -- making NaNs']);
                            
                            temp_var = NaN.*ones(len_yr,1);
                        end
                        
                        fill_data(1:abs(num_to_shift),i) = temp_var(1:0-num_to_shift);
                        clear temp_var;
                    end
                    output_test = [ output(1-num_to_shift:end,:); fill_data(:,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%% END SHIFTING %%%%%%%%%%%%%%%%%%
                    set_to_zero = [6241:6262 7492:7509 7539:7557 7588:7605 7636:7653]';
                    output(set_to_zero,output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1))=0;
                    output(set_to_zero,output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1))=0;
                    
                    clear set_to_zero
                    
                    
                case '2006'
                    % Swap some mixed up Ts sensors:
                    Ts5B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1));
                    Ts2B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1)) = Ts2B_orig(1:end,1);
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1)) = Ts5B_orig(1:end,1);
                    
                    clear Ts5B_orig Ts2B_orig;
                    
                case '2007'
                    
                case '2008'
                    
                    % step 1 - remove bad data:
                    output(3037:7181,1:2) = NaN; %broken HMP caused problems for HMP, Wind
                    output(4753:7181,3:4) = NaN; %broken HMP caused problems for HMP, Wind
                    % PAR up and down sensors backwards for short period
                    temp = output(4446:4752,5);
                    output(4446:4752,5) = output(4446:4752,6);
                    output(4446:4752,6) = temp;
                    clear temp
                    
                    % Remove spikes in soil variables:
                    %Ts
                    output([966:1:990 3357 11056 11060 11062 11063 11295],11) = NaN;
                    output([966:1:990 3357 4057 5899 7181 10782],12) = NaN;
                    output([966:1:990 3357 11274],13) = NaN;
                    output([966:1:990 3357],16) = NaN;
                    output([966:1:990 5899],17) = NaN;
                    output([966:1:990 3357 11345],18) = NaN;
                    output([966:1:990 3346 11345],20) = NaN;
                    output([966:1:990 11295 11345 12020],21) = NaN;
                    output([966:1:990 11191 11249 11297 11345],22) = NaN;
                    %SM
                    output([966:1:990 11191 11295 11329 12068],23) = NaN;
                    output([966:1:990 6015 5903 5904 11345 11191 11295 12008],25) = NaN;
                    output([966:1:990 5899 5900 5903 5904 5936:5939 6015 11191 11295 11345 11590 12008 12020 12068],26) = NaN;
                    output([966:1:990 3361 5899 5900 5903 5904 11191 11345 11590 12008 12020 12068],27) = NaN;
                    output([966:1:990 5903 5904 5935:5939 6015 11590 12008],28) = NaN;
                    output([966:1:990 11191 12018 12068],29) = NaN;
                    output([966:1:990 11590 12008],30) = NaN;
                    output([966:1:990 4286 11191 11295],31) = NaN;
                    
                    
                    % step 2 - re-arrange soil variables:
                    SM80B = output(:,31); SM50B = output(:,27); SM20B = output(:,28);
                    SM10B = output(:,29); SM5B = output(:,30);
                    output(:,27) = SM80B; output(:,28) = SM50B; output(:,29) = SM20B;
                    output(:,30) = SM10B; output(:,31) = SM5B;
                    
                    clear SM80B SM50B SM20B SM10B SM5B;
                    
                    SM5A = output(:,25); SM10A = output(:,26);
                    output(:,25) = SM10A; output(:,26) = SM5A;
                    clear SM5A SM10A;
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %   Step 3
                    % Shift data so that it's all in UTC:
                    % need to load first 8 datapoint from 2007
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2007.' vars30_ext(i,:)]);
                        catch
                            temp_var = NaN.*ones(17520,1);
                        end
                        fill_data(1:8,i) = temp_var(end-7:end);
                        clear temp_var;
                    end
                    output_test = [fill_data(:,:); output(1:6319,:); NaN.*ones(2,length(vars30)); output(6320:7178,:); output(7181:11713,:); output(11744:12068,:); NaN.*ones(22,length(vars30)); output(12069:end,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '2009'
                    % Bad Data in HMP:
                    output(4906:5650,1:2) = NaN;
                    % Bad data in other variables:
                    output(4906:5115,5:10) = NaN;
                    
                    bad_pts = [5116 10755 10984]';
                    output(bad_pts, 11:31) = NaN;
                    clear bad_pts;
                    output(14477,23:31) = NaN;
                    
                    % Clean up spikes in soil data:
                    %                 output(
                    % run [tracker] = jjb_remove_data(output(:,col)); on
                    % columns 11--22
                    % spot clean 23--31.
                    for col = 11:1:22
                        try
                            tracker = load([tracker_path 'TP02_2009_tr.0' num2str(col)]);
                            disp(['loading tracker for column ' num2str(col) '. ']);
                            
                            resp = input('Do you want to continue to edit the tracker? (<y> to edit, <n> to skip: ', 's');
                            
                            if strcmp(resp,'y') == 1;
                                output(:,col) = output(:,col).*tracker;
                                clear tracker
                                
                                [tracker] = jjb_remove_data(output(:,col));
                                
                                save([tracker_path 'TP02_2009_tr.0' num2str(col)],'tracker','-ASCII')
                            else
                            end
                            
                        catch
                            disp('cannot find tracker -- making a new one');
                            [tracker] = jjb_remove_data(output(:,col));
                            save([tracker_path 'TP02_2009_tr.0' num2str(col)],'tracker','-ASCII')
                            
                        end
                        
                        output(:,col) = output(:,col).*tracker ;
                        clear tracker
                        %                    ctr2 = ctr2+1;
                    end
                    
                    % Step 4: fill gaps in data with available data from the
                    % OPEC system:
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING
                    tmp4 = load([loadstart 'Matlab/Data/Flux/OPEC/TP02/Cleaned/TP02_30min_Master_2008.dat']);
                    %Ta_temp2 = load([loadstart 'Matlab/Data/Flux/OPEC/old/Cleaned3/TP02/Column/TP02_HHdata_2008.069']);
                    Ta_temp = tmp4(:,69);
                    Ta = [NaN.*ones(11,1); Ta_temp(1:end-11,1)];%Ta_temp(1:10778,1); NaN.*ones(5,1); Ta_temp(10779:length(Ta_temp)-8,1)];
                    Ta(5800:5805,1) = NaN;
                    %                 Ta(1:5796,1) = NaN;
                    %WS_temp2 = load([loadstart 'Matlab/Data/Flux/OPEC/old/Cleaned3/TP02/Column/TP02_HHdata_2008.046']);
                    WS_temp =  tmp4(:,46);
                    WS = [NaN.*ones(11,1); WS_temp(1:end-11,1)];
                    %                 WS = [WS_temp(1:10781,1); NaN.*ones(8,1); WS_temp(10782:length(Ta_temp)-8,1)];
                    % rWS = load([loadstart 'Matlab/Data/Flux/OPEC/Cleaned3/TP02/Column/TP02_HHdata_2008.047']);
                    %Wdir_temp2 = load([loadstart 'Matlab/Data/Flux/OPEC/old/Cleaned3/TP02/Column/TP02_HHdata_2008.044']);
                    Wdir_temp =  tmp4(:,44);
                    Wdir = [NaN.*ones(11,1); Wdir_temp(1:end-11,1)];
                    %                 Wdir = [Wdir_temp(1:10781,1); NaN.*ones(8,1); Wdir_temp(10782:length(Ta_temp)-8,1)];
                    
                    %%% Fill in blanks:
                    output(isnan(output(:,1)),1) = Ta(isnan(output(:,1)),1);
                    output(isnan(output(:,3)),3) = WS(isnan(output(:,3)),1);
                    %                 output(isnan(output(:,4)),4) = Wdir(isnan(output(:,4)),1);
                case '2010'
                case '2011'
                    %                     output(1126:1128,1) = NaN; % just a test:
                    % Missing in data for all fields
                    output(5988:6088, 1:38) = NaN;
                    % Bad Soil moisture data
                    output(10588,12) = NaN;
                    output(10584:10587,14) = NaN;
                    output([10590 10599],16) = NaN;
                    output(10586:10594,17) = NaN;
                    output(11987:end,10) = NaN;
                    
                case '2012'
                    % Bad precipitation data
                    output([1:3164 5792:5845], 10) = NaN;
                    % Bad Down PAR above canopy
                    output(16600:end,5) = NaN;
                    % Bad Net radiometer data (sensor replaced Jan. 8/13)
                    output(15113:end,7) = NaN;
                    % Bad Up PAR Above canopy
                    output(17170:17172,6) = NaN;
                    % Bad Atm pressure
                    output(807:943, 35) = NaN;
                    
                case '2013'
                    % Missing data in all sensors
                    output(7765:8060,:) = NaN;
                    % Bad Down PAR above canopy (missing)
                    output([1:1083 1284:1719],5) = NaN;
                    % Correction factor to correct for wrong multiplier used from February to June in Down PAR sensor.
                    % (Correct multipler/wrong multipler) = (282.05/170.36) = 1.65561
                    output([2675:8064],5) = output([2675:8064],5)*1.65561;
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;
                    
                    % Bad Up Par abv cnpy
                    output([9609:9633 10058:10062 10204:10205 10502:10542 11423:12069],6) = NaN;
                    % Missing SM sensors
                    output(:,32:34) = NaN;
                    % Remove bad P data
                    output([6130:12091],10) = NaN;
                    
                    output([1384:1719 ],35) = NaN;
                    
                    
                case '2014'
                    % downPar and upPar abv canopy... not sure what to do
                    % (reduced/huge increase respectively)
                    % These two variables are swapped because the sensor is
                    % wired in upside-down.
                    tmp = output(10068:11552,5);
                    output(10068:11552,5) = output(10068:11552,6);
                    output(10068:11552,6) = tmp;
                    clear tmp;
                    output([3437:3449 7093 10170:10171],6) = NaN;
                    
                    %%% Fix an magnitude issue with PAR down between points
                    %%% 10068 and 11552. Inspection showed that PAR should
                    %%% be increased by a factor of 1.1765.
                    %%%
                    output(10068:11552,5) = NaN;
                    
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;

                    
                    % Jan. 13 2015 - Removing PAR data after sensor down
                    % mid-summer (whole year or until re-started in winter?
                    output(9831:16507,6) = NaN;
                    
                    % Remove spikes in Ta
                    output(10975:10988,1) = NaN;
                    % Remove questionable points in RH
                    output([1533:1541],8:9) = NaN;
                    % Bad Rn points
                    output([465 4799 11093 12671 13774],7) = NaN;
                    % Remove questionable points in SHF
                    output([10973 11174 11181 11191:11200],2) = NaN;
                    % Bad Precip Points
                    output(11600:end,10) = NaN;
                    % Bad soil temp data points
                    output([10160:10162 10492 10187:10202 10244:10246 10348 10378:10380 10387:10396 10420:10455 10466:10493 10525:10543 10561:10591 10611:10640 10658:10687 10698:10734 10740:10828 10849:10876 10898:10973],[11:19 21:29 31]) = NaN;
                    output([10992:11018 11054:11068 11103:11110 11118 11137:11164 11200:11214 11235:11268],[11:19 21:29 31]) = NaN;
                    output([11278:11312 11339:11356 11540:11554 15705 16500],[11:19 21:29 31]) = NaN; % Pts in all sensors (abv)
                    output([12387:12413 12526 13707:13714],11)  = NaN; % Specific sensors
                    output(12526,12:13)  = NaN;
                    output(8004,14)  = NaN;
                    output([10878 12526],17)  = NaN;
                    output([10397 10878 12526],18)  = NaN;
                    output([10878 12526 14779:14812],19)  = NaN;
                    output([10397 10878],22)  = NaN;
                    %%% Ts b10 stopped working
                    output(9830:end,20) = NaN;
                    output(8004,20)  = NaN;
                    
                    % Poor SM a 50cm  and 20cm points
                    output([9830 10878 15705 16500],23) = NaN;
                    % Poor SM a 10cm and 5cm points
                    output([8736 8753 8761:8762 14698 14975:14977 14987 14991:14996 15006:15020 15025:15026 15030:15032 15037:15044 15048:15053 15066:15095 15705 16500],25:26) = NaN;
                    % SM B 0-100 points
                    output([10068:10159 ],27) = NaN;
                    % Poor SM b 10cm points
                    output([9294 10404 10444 10746 10493 10542 10590 10639 10686 10734 10745 10746],30) = NaN;
                    % Poor SM b 5cm points
                    output([8004 10068:10076],31) = NaN;
                    % Other bad SM data (all sensors)
                    output([10068:10076 10878 12526 13097 15705 16500],23:31) = NaN;
                    % Missing SM 10-12 sensors
                    output(:,32:34) = NaN;
                    
                    % Spikes in Pressure data
                    output([ 5700:5706 6053:6057 6360:6365 6745:6750 10068 10161 10201:10296 10406:10412 11552],35) = NaN;
                    
                    
                case '2015'
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;

                    % Spike in Net Rad Above Canopy
                    output([2977 4067 7587 15586],7) = NaN;
                    % Bad Soil Heat Flux points
                    output([14260:14263],8) = NaN;
                    % TBRG (col 10) data is useless -- in an enclosed gap
                    % in trees
                    output(:,10) = NaN;
                    % Bad soil temp data points
                    output([260 1251 2059],[11 12 13 15 16 17 18 19 21:22 27:31]) = NaN; %
                    % Spikes Ts A 100 cm
                    output([2965 3116 3818 4417:4448 4745:4778 5046 5195 5360 5750 5872 6235 6289:6302 7216:7218 7362 7590:7602 7623:7626 7642:7643 7907 7923:7931 ...
                        8549:8555 8563:8578 8588:8599 8949:8956 8995:9001 9103:9106 9128 9336:9340 9491:9495 10283:10299 10320:10328 10383 ...
                        10651:10652 11147 11225 11252:11261 11369 11678:11694 12019 12165:12174 12190:12195 12545:12548 12567:12571 12595:12596 ...
                        12940:12965 13249:13253 13499:13519 13753:13755 14062:14065 14146 14242:14264 14416:14418 14470 ...
                        14602:14605 14855:14856 15051:15052 15148:15151 15585:15589 15883:15885 15894:15895 16091:16096],11) = NaN;
                    
                    
                    output([3652 4067 4545 7136 8108 8739 9707 10596 12238 13346 13590 14652 14770 15308 15339:15342 15423:15424 15814:15819 16448:16453 16485:16492],12) = NaN;
                    output([3314 3869 4006 4033 4274 5072 5221 8672 8937 9319 9656 9682 10212 11173 11509 11546 12357 12454 12498 13279 13397 14387 ],13) = NaN;
                    output([2939 3600 3792 3989 4232 4247 4638 4664 4749 13684 13736 14508 14575 15376 16365 16531 16557],14) = NaN;
                    output([1251 2059  ],[14 23:31]) = NaN;
                    
                    %                     output([
                    
                case '2016'
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;
                    % Spike in Down PAR above canopy
                    output([2770 6582 12226],5) = NaN;
                    % Spike in Net Radiation Above Canopy
                    output([2242 3932 4371 4860 6852 12226 17449 17450],7) = NaN;
                    % Spike in Soil Heat Flux 1
                    output([8550 8552 9763 10200 10201 14727],8) = NaN;
                    % Remove all of SHF 2 (sensor is broken):
                    output(:,9) = NaN;
                    % Spike in Soil Temperature Pit A 100cm
                    output([1592 1593 2623 2624 4061:4063 4107 10501 11424 11425 11685 17034 17035 17072 17303:17305],11) = NaN;
                    % Spike in Soil Temperature Pit A 50cm
                    output([1261 1644 1766 2483 4105 4561 4710 5809 6300],12) = NaN;
                    % Spike in Soil Temperature Pit A 20cm
                    output([1332 2018 3403 5021 5863 6226],13) = NaN;
                    % Spike in Soil Temperature Pit A 10cm
                    output([1670 2248 3183 14052 14053],14) = NaN;
                    % Spikes in Soil Temperature Pit A 5cm
                    output([1065 1165 1235 1280 1403 1714 1740 1992 2078 2319 2561 3280 3818 4832 14052 14053],15) = NaN;
                    % Spike in Soil Temperature Pit A 2cm
                    output([1209 2155 3956 4588 4632 4857 14052],16) = NaN;
                    % Spike in Soil Temperature Pit B 100cm
                    output([1332 2631 2924 4105 4131 4995 5190 14052 14053],17) = NaN;
                    % Spike in Soil Temperature Pit B 50cm
                    output([3376 5232 5646 5950 6274 14052 14053],18) = NaN;
                    % Spike in Soil Temperature Pit B 20cm
                    output([1228 1280 1489 1992 2334 2844 3058 4517 4663 5782 5783 8261:8263 9780 17203],19) = NaN;
                    % Spike in Soil Temperature Pit B 5cm
                    output([1116 1332 2631 3142 4562 13287 13288],21) = NaN;
                    % Spike in Soil Temperature Pit B 2cm
                    output([1455 2052 5404 5837 14052],22) = NaN;
                    % Spike in Soil Moisture Pit A 50cm
                    output([2475 4762],23) = NaN;
                    
                 case '2017'
                    % Relative Humidity
                    output([181 451 2960 6326 8013 16222 16399],2) = NaN;
                    % Down PAR Above Canopy
                    output([3305 7228 7672 8197 8434 9060 9250 11893],5) = NaN;
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;

                    % Net Radiation Spikes
                    output([5138 7229 11893 14339],7) = NaN;
                    % Soil Heat Flux1
                    output([5763 5764 5795 5796 10745],8) = NaN;                                               
                    % Soil Heat Flux1
                    output(:,9) = NaN;                                               
                    % Soil Temp A 100cm Spikes
                    output([708 709 715 782:789 2025 2140 2193 2288 2475 3770 3771 3813 3818 6257 7815:7821 7910:7919 7943 7944 7979 7996 8251 8252 8289:8296 8326:8382 8672:8674 8729 8864 8904:8912 8953:8964 8978:8983 9012 9076:9079 9093:9122 9435:9453 9520:9555 9575:9605 9907:9990 10023:10040 10065:10084 10110:10129 10162:10173 10212:10226 10354:10368 10544:10563 10580:10603 10629:10750 15154 15296 15300:15400 15540:15580 15726:15730 15841:15877 16247:16282 16917:17300],11) = NaN;                                                 
                    % Soil Temp Spikes
                    output([7940:8297 8729 8864 8885:8912 8953:8985 9012:9123 9145:9207 9521:9538 9575:9640 15295:15399 15537:15583 15726:15731 15841:15846 15874:15877 16247:16282 16917:17300],[11:22]) = NaN; 
                    % SM A 10cm Spikes
                    output([11870 11929:11937 11963:11979 12020 12051:12053 12065:12067 12121:12128 12135 12164 12273 12274 12311 12344:12346 12364:12366 12385:12400 12448 12528:12557 12572 12586:12600 12649 12650 12668:12749 12798 12812:12866 12880:12894 12919:12930 13131:13233],25) = NaN;
                    % No good data in Ts 10B
                    output(:,20) = NaN;   
                    
                 case '2018' 
                    % Air Temp & RH
                    output([11649:11651 15292],[1:2]) = NaN;
                    % No good data from points 14579-14625
                    output([14579:14625],:)= NaN;
                    % Soil Heat Flux 2 (HFT_2) 
                    output([1:5420 8920:9102],9) = NaN;
                    % Data Loss in all Soil Data
                    output([5469:14676],[11:22]) = NaN;      
                    % Bad Ts and SM data
                    output([15294:15296],[11:30]) = NaN;      
                    % Negative Spike in all SM Pits
                    output([8253 8254 8481 8623 9102 9112 9968 11178 11538 14000:15296],[23:31]) = NaN;
                    % Pressure
                    output([8251 9103 15293],35) = NaN;
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;
                    
                    % LW up and LW down look to be swapped 
%                     tmp = output(:,)
                    
                    RH_max = 100;
                case '2009'
                    % Perform a scaling correction for PAR (use correction
                    % factor that was derived by inter-year comparison at
                    % the site).
                    output(:,5) = output(:,5).*par_correction_factor;
                    
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Fix data shift that occurs ~ half hour 14600 (Nov 2). At this time, the datalogger was switched back to EDT (GMT - 4 hours). 
                    % Need to shift data back by 8 data points. Also need to load first 8 points from 2019 and add to the end.
                    % need to load first 8 datapoint from 2007
                    for i = 1:1:length(vars30)
                        try
                            temp_var = load([load_path site '_2019.' vars30_ext(i,:)]);
                        catch
                            temp_var = NaN.*ones(17520,1);
                        end
                        fill_data(1:8,i) = temp_var(1:8);
                        clear temp_var;
                    end
                    output_test = [output(1:14600,:); NaN.*ones(8,length(vars30)); output(14601:end-8,:)];
                    clear fill_data;
                    clear output;
                    output = output_test;
                    clear output_test;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                 case '2019' 
                    %%% CR1000 was returned to site on Feb 11. Need to shift forward all data from this time, and load in end of 2018 data.               
            end
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Corrections applied to all years of data:
            % 1: Set any negative PAR and nighttime PAR to zero:
            PAR_cols = [];
            try
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)];
            catch
            end
            
            %%% Set the bottoms of PAR (a
            %         if strcmp(site,'TP74')==1 && year == 2003
            %             DownParBot = 19;
            %             UpParBot = 21.5;
            %             DownParBlwBot = 15;
            %         else
            switch yr_str
                case {'2008';'2009'};
            DownParBot = 100;
            UpParBot = 50;
            DownParBlwBot = 50;
                otherwise
               DownParBot = 15;
               UpParBot = 15;
            DownParBlwBot = 15;
            end
            
            %         end
            
            %Plot uncorrected:
            figure(97);clf;
            subplot(211)
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Uncorrected PAR');
            %         if year <= 2008
            [sunup_down] = annual_suntimes(site, year_ctr, 0);
            %         else
            %             [sunup_down] = annual_suntimes(site, year, 0);
            %         end
            ind_sundown = find(sunup_down< 1);
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            try
                output(output(:,PAR_cols(1)) < DownParBot & sunup_down < 1,PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < UpParBot & sunup_down < 1,PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < DownParBlwBot & sunup_down < 1,PAR_cols(3)) = 0;
            catch
            end
            try
                output(output(:,PAR_cols(1)) < 0 , PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < 0 , PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < 0 , PAR_cols(3)) = 0;
            catch
            end
            % Plot corrected data:
            figure(97);
            subplot(212);
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Corrected PAR');
            
            % 2: Set any RH > 100 to NaN -- This is questionable whether to make
            % these values NaN or 100.  I am making the decision that in some
            % cases
            RH_cols = [];
            try
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_AbvCnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_Cnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_BlwCnpy')==1)];
            catch
            end
            % Adjust columns to match output:
            %     RH_cols = RH_cols - 6;
            figure(98);clf;
            subplot(211)
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Uncorrected RH')
            if ~isempty(RH_max)
                RH_resp = RH_max; % RH_max should be set within each year of data.
            else
                commandwindow;
                RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            end
            for j = 1:1:length(RH_cols)
                output(output(:,RH_cols(j)) > 100,RH_cols(j)) = RH_resp;
            end
            subplot(212);
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Corrected RH');
            
            
        case 'TPD'
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%% TPD  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Convert wind speed to m/s for years 2012-2014
            if year < 2015
                output(:,22) = output(:,22)./3.6;
            end
            
            %%% Convert Pressure to kPa
            output(:,5) = output(:,5)./10;
            %%% Convert SHF to W/m2 ** NOTE: Change calibration values to
            %%% REAL values ***
            output(:,18) = output(:,18).*42;
            output(:,19) = output(:,19).*42;
            output(:,20) = output(:,20).*42;
            output(:,21) = output(:,21).*42;
            
            
            switch yr_str
                case '2012'
                    %%% Swap reversed SW and LW data (up & down are
                    %%% reversed)
                    tmp = output(:,10);
                    output(:,10)=output(:,11);
                    output(:,11)=tmp;
                    
                    tmp = output(:,12);
                    output(:,12)=output(:,13);
                    output(:,13)=tmp;
                    
                    %%% Bad Temperature data:
                    output([784 795 1071],3)= NaN;
                    output([9037],3)= NaN;
                    output([9496:9498],3)= NaN;
                    output([9547:9548],3)= NaN;
                    output([9563:9620],3)= NaN;
                    output([9855 9857],3)= NaN;
                    output([9859],3)= NaN;
                    output([10376:10478],3)= NaN;
                    output([11360:11368],3)= NaN;
                    output([11380],3)= NaN;
                    output([11415:11540],3)= NaN;
                    output([11552:11583],3)= NaN;
                    output([11711:12106],3)= NaN;
                    output([12270],3)= NaN;
                    output([12291:12455],3)= NaN;
                    output([12773:12815],3)= NaN;
                    output([12733:12734],3)= NaN;
                    output([12831:12832],3)= NaN;
                    output([13278:13567],3)= NaN;
                    output([14886],3)= NaN;
                    output([16756],3)= NaN;
                    output([9036 9037 9518 9532 9856 9858 9893],3)=NaN;
                    
                    
                    %%% Bad RH data:
                    output([225 591 784 795 1071 3028 12297],4)= NaN;
                    output([12310:12314],4)= NaN;
                    output([12776],4)= NaN;
                    output([12787:12788],4)= NaN;
                    output([12790:12814],4)= NaN;
                    output([13279:13567],4)= NaN;
                    output([12298],4)= NaN;
                    output([12315],4)= NaN;
                    output([12341],4)= NaN;
                    output([12777],4)= NaN;
                    output([12815],4)= NaN;
                    output([12452],4)= NaN;
                    %%% Bad Pressure data:
                    output([180:212 225:239],5)= NaN;
                    output([591 789 795 1071],5)= NaN;
                    %%% Bad Snow Depth data:
                    output([1071 5210:14349],6)= NaN;
                    
                    %%% Bad PAR data:
                    output([209 231 5838 12268],8)= NaN;
                    
                    %%% Bad WindSpeed data:
                    output([2865 4326],16)=NaN;
                    
                    %             %%% Bad SWP data:
                    %             output([241:510],26)= NaN;
                    %             output([241:510],27)= NaN;
                    %             output([241:510],28)= NaN;
                    %             output([241:510],29)= NaN;
                    %             output([241:510],30)= NaN;
                    %             %%% Bad Ohms data:
                    %             output([241:510],38)= NaN;
                    %             output([241:510],39)= NaN;
                    %             output([241:510],40)= NaN;
                    %             output([241:510],41)= NaN;
                    %             output([241:510],42)= NaN;
                    %%% Bad tipping bucket RG data:
                    output([1:4000],85)= NaN;
                    
                    %%% Remove bad CO2_cpy data:
                    output([5842:5844],86) = NaN;
                    output([6589 7434 7770 8106 8442 9131 9786 10122 10458 10794 11130 11466 11819 12155 12491 12827 13163 13547 13567],86) = NaN;
                    %%% Bad SWP Pit A
                    output([5838],25)= NaN;
                    output([5838],26)= NaN;
                    output([5838],27)= NaN;
                    output([5838],28)= NaN;
                    output([5838],29)= NaN;
                    output([5838],30)= NaN;
                    
                    %%% Bad SWP Pit B
                    output([5838],31)= NaN;
                    output([5838],32)= NaN;
                    output([5838],33)= NaN;
                    output([5838],34)= NaN;
                    output([5838],35)= NaN;
                    output([5838],36)= NaN;
                    %%% Bad KOhms Pit A
                    output([5838],37)= NaN;
                    output([5838],38)= NaN;
                    output([5838],39)= NaN;
                    output([5838],40)= NaN;
                    output([5838],41)= NaN;
                    output([5838],42)= NaN;
                    
                    %%% Bad kOhms Pit B
                    output([5838],43)= NaN;
                    output([5838],44)= NaN;
                    output([5838],45)= NaN;
                    output([5838],46)= NaN;
                    output([5838],47)= NaN;
                    output([5838],48)= NaN;
                    
                    
                    
                    %%% Fix incorrect soil sensor tensiometer wiring at start of
                    %%% year:
                    %%%% Checking plot used to fix the sensors -- not needed %%%%%%%%%%%%%
                    % %             clrs = jjb_get_plot_colors;
                    % %             figure(99);clf;
                    % %             ctr = 1;
                    % %             for i = 25:1:36
                    % %             plot(output(:,i),'Color',clrs(ctr,:),'LineWidth',2);hold on;
                    % %             ctr = ctr + 1;
                    % %             end
                    % %             legend(num2str((25:1:36)'))
                    %             clrs = jjb_get_plot_colors;
                    %             figure(99);clf;
                    %             ctr = 1;
                    %             for i = 37:1:48
                    %             plot(output(:,i),'Color',clrs(ctr,:),'LineWidth',2);hold on;
                    %             ctr = ctr + 1;
                    %             end
                    %             legend(num2str((37:1:48)'))
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Switch sensors for SWP:
                    switch_time = [241:510]';
                    tmp29 = output(switch_time,29);
                    tmp27 = output(switch_time,27);
                    output(switch_time,27) = output(switch_time,26); output(switch_time,26) = NaN;
                    output(switch_time,29) = tmp27;
                    output(switch_time,35) = output(switch_time,30); output(switch_time,30) = NaN;
                    output(switch_time,33) = tmp29;
                    output(switch_time,31) = output(switch_time,28); output(switch_time,28) = NaN;
                    %%% Switch sensors for Ohms:
                    tmp41 = output(switch_time,41);
                    tmp39 = output(switch_time,39);
                    output(switch_time,39) = output(switch_time,38); output(switch_time,38) = NaN;
                    output(switch_time,41) = tmp39;
                    output(switch_time,47) = output(switch_time,42); output(switch_time,42) = NaN;
                    output(switch_time,45) = tmp41;
                    output(switch_time,43) = output(switch_time,40); output(switch_time,40) = NaN;
                    clear tmp29 tmp27 tmp39 tmp41 switch_time
                    
                    %%% Fix shifts in met data logger throughout the first part of
                    %%% 2012:
                    % shift forward 13 points
                    output(193:225,:) = output(180:212,:); output(180:192,:) = NaN;
                    % shift backward 1 point
                    output(591:781,:) = output(592:782,:); output(782,:) = NaN;
                    % shift backward 2 points
                    output(783:791,:) = output(785:793,:); output(792:793,:) = NaN;
                    % shift backward 3 points
                    output(793:1066,:) = output(796:1069,:); output(1067:1069,:) = NaN;
                    % shift backward 4 points
                    output(1068:1577,:) = output(1072:1581,:); output(1578:1581,:) = NaN;
                    % shift backward 1 point
                    output(3028:5835,:) = output(3029:5836,:); output(5836,:) = NaN;
             
                case '2013'
                    %%% Swap reversed SW and LW data (up & down are
                    %%% reversed)
                    tmp = output(:,10);
                    output(:,10)=output(:,11);
                    output(:,11)=tmp;
                    
                    tmp = output(:,12);
                    output(:,12)=output(:,13);
                    output(:,13)=tmp;
                    % Remove bad snow depth point
                    output(16851,6) = NaN;
                    % Bad SWP Pit A
                    output(1026:1384,25:26) = NaN;
                    % Bad SWP Pit B
                    %output(817:3329,31:32) = NaN;
                    % output([3534 3659:4083 16364:16444 16483:16496],31) = NaN;
                    %output(16556:16842,32) = NaN;
                    % output(1026:1496,33) = NaN;
                    % Bad K0hms pit A
                    %output(1026:1386,37:38) = NaN;
                    % Bad K0hms pit B
                    %output([817:4084 16361:16501],43) = NaN;
                    %output([817:3153 16554:16842],44) = NaN;
                    %output(1026:1496,45) = NaN;
                    
                    
                case '2014'
                    %%% Swap reversed SW and LW data (up & down are
                    %%% reversed)
                    tmp = output(:,10);
                    output(:,10)=output(:,11);
                    output(:,11)=tmp;
                    
                    tmp = output(:,12);
                    output(:,12)=output(:,13);
                    output(:,13)=tmp;
                    
                    % Spike in LW Rad Abv Cnpy
                    output(13485,12:13) = NaN;                    
                    % SWP spikes until spring in some sensors
                    output(1:4354,[31:33 37 38 43 44 45]) = NaN;
                    % Other SWP points
                    output(14114,42) = NaN;
                    output([17485:17520 15125],43) = NaN;                    
                    
                    % Remove bad snow depth point
                    output(3390,6) = NaN;
                    % Remove SHF HFT1 point
                    output(13485,18) = NaN;
                    % Remove SHF HFT2 points
                    output([1534 7354 8344 8637 8998 9060 9293:9295 10741],19) = NaN;
                    
                    % Remove bad SHF HFT3 point
                    output([13485 13707 ],20) = NaN;
                    % Wind Spd & Dir not working
                    output(11399:end,22:24) = NaN;
                    % Remove bad CO2 cnpy points
                    output([3390 13484:14828],86) = NaN;
                    
                    % Unsure about early year kOhms
                    
                    % Unsure why LW Rn is cutoff, it is not in the TH in
                    % the same format..
                    
                    %%%%%%%%%%%
                    % Fill in gaps in Wind speed and wind direction with final cleaned CPEC data:
                    %%% wind speed
                    ws = output(:,22);
                    CPEC = load([loadstart 'Matlab/Data/Flux/CPEC/TPD/Final_Cleaned/TPD_CPEC_cleaned_2014.mat']);
                    u = CPEC.master.data(:,19);v = CPEC.master.data(:,20);
                    WS_CPEC = sqrt(u.^2 + v.^2);
                    p = polyfit(ws(~isnan(ws.*WS_CPEC)),WS_CPEC(~isnan(ws.*WS_CPEC)),1);
                    WS_CPEC_corr = (WS_CPEC-p(2))./p(1);
                    ws(isnan(ws),1) = WS_CPEC_corr(isnan(ws),1);
                    ws(ws<0) = 0;
                    output(:,22) = ws;
                    %%% wind direction
                    wdir = output(:,23);
                    WDIR_CPEC = rad2deg(atan2(u,v))+180;
                    wdir(isnan(wdir),1) = WDIR_CPEC(isnan(wdir),1);
                    output(:,23) = wdir;
                    clear u v WDIR* wdir ws p WS*;
                    
                case '2015'                    
                    % Bad snow depth
                    output([2897 4452 4453 4455 4482 4538 4542 4545 4547 4662 7323],6) = NaN;                    
                    % Long wave up, above canopy
                    output([14473 14265],12) = NaN;
                    output([9000:end],[12 13]) = NaN; % JJB removed data where drift occurred                    
                    % Soil Heat Flux HFT 2cm, 3cm, 4cm
                    output(7235:7238,[19 20 21]) = NaN;                    
                    % Bad wind speed and direction data:
                    output(1:400,[22 23]) = NaN;                    
                    % Bad CO2_cnpy data:
                    output(9300:16744,86) = NaN;
                                        
                    %%% Swap reversed SW and LW data (up & down are reversed)
                    tmp = output(:,10);
                    output(:,10)=output(:,11);
                    output(:,11)=tmp;
                    tmp = output(:,12);
                    output(:,12)=output(:,13);
                    output(:,13)=tmp;
                    
                 case '2016'
                    % Spikes in Air Temp Abv Cnpy
                    output([16888],3) = NaN;                    
                    % Spikes in Snow Depth
                    output([1329 1337 2190 16878],6) = NaN;                    
                    % Spikes in Down PAR below Cnpy
                    output([4932],9) = NaN;                    
                    % Spikes in Down Shortwave Radiation
                    output([2149 8723],11) = NaN;                    
                    % Spikes in UpLongwave Radiation Abv Cnpy
                    output([17341],12) = NaN;                    
                    % Spikes in Net Longwave above canopy
                    output([2885 17341],15) = NaN;                    
                    % Spikes in Soil Heat Flux 2
                    output([3631 5583 5584 8553 13217],19) = NaN;                    
                    % Spikes in Soil Heat Flux 3
                    output([13217],20) = NaN;                    
                    % Spikes in SWP A 10cm
                    output([5584],27) = NaN;                    
                    % Spikes in SWP A 50cm
                    output([1474 6155 7416],29) = NaN;                    
                    % Spikes in SWP Pit A 100cm
                    output([1596 3789 5584 9765],30) = NaN;                    
                    % Spikes in SWP Pit B 50cm
                    output([9039 9765],35) = NaN;                    
                    % Spikes in KOhms A 10cm
                    output([5584],39) = NaN;                    
                    % Spikes in KOhms A 50cm
                    output([1474 1923 1930 6155 7416],41) = NaN;                    
                    % Spikes in KOhms A 100cm
                    output([1596 2812 3789 4034 4211 5544 5584 9765],42) = NaN;                    
                    % Spikes in KOhms Pit B 50cm
                    output([9039 9765],47) = NaN;                    
                    % Spikes in CO2 canopy
                    output([1965 5197 6451 6474 9777 9945 9998 10045 11970 12165 12166 13431 14821],86) = NaN;
                    
                    %%%% uncomment this if nothing has been changed as of 2016
                                        %%% Swap reversed SW and LW data (up & down are
                                        %%% reversed)
                                        tmp = output(:,10);
                                        output(:,10)=output(:,11);
                                        output(:,11)=tmp;
                    
                                        tmp = output(:,12);
                                        output(:,12)=output(:,13);
                                        output(:,13)=tmp;
                 case '2017'
             %%%% recommend this CNR wiring has been changed in 2016
                                        %%% Swap reversed SW and LW data (up & down are
                                        %%% reversed)
                                        tmp = output(:,10);
                                        output(:,10)=output(:,11);
                                        output(:,11)=tmp;
                    
                                        tmp = output(:,12);
                                        output(:,12)=output(:,13);
                                        output(:,13)=tmp;
                                                      
                    % Spikes in Air Temp Abv Canopy
                    output([429:440 1691 4883 4886 6129:6136 12663 12757:12759 12803 12804 13423:13447 13571:13584 13809 13818 14941:14959 16214:16231 16276 17272:17305 17322:17327 17364 17366 17495:17516],3) = NaN;
                    % Spikes in Snowdepth
                    output([429:435 448 3731 4883:4895 5886:5892 6129:6135 12388 12389 12711 12757:12759 12803 13424:13430 13444:13446 13571:13580 13808:13817 14720 14720:14937 14938:14947 16210:16241 16536:16538 17171 17274 17275 17287 17305 17364 17369 17381 17492 17501:17507 17516],6)= NaN;
                    % Spikes in DownPAR Abv Canopy
                    output([450 5471 5485 5493 5601 9593],7) = NaN;
                    % Spikes in UpPAR Abv Canopy
                    output([471 5477 5484],8) = NaN;
                    % Spikes in DownPAR Below Canopy
                    output([33:37 448 471 4980 5124 5172 5485 5486 5601 5615 5747 5891 6179 9593],9) = NaN;
                    % Spikes in UpShortwaveRad
                    output([5463:5493 6627 9593],10) = NaN;  
                    % Spikes in DownShortwaveRad
                    output([448:466 2913 5463:5488 5563 5601:5613 6560:6627 7766:7796 9584:9613],11) = NaN;
                    % Spikes in UpLongwaveRadAbvCnpy
                    output([448:460 5484:5493 5615 9593],12) = NaN;
                    % Spikes in DownLongwaveRadAbvCnpy
                    output([7 448:451 1208 5471:5527 5615 9593],13) = NaN;
                    
                    % Spikes in Net Longwave Abv Canopy
                    output([448:466 1208 3942 4210 5493 5600:5615 6560:6630 7767:7796 9593:9611],15) = NaN;
                    % Spikes in Soil Heat Flux 2
                    output([10990 10991 11859 11999 12000 14272],19) = NaN;
                    % Spikes in Soil Heat Flux 3
                    output([5279 5764 5796 8336],20) = NaN;
                    % Missing Wind Data (Repair)
                    output([10210:12365],[22:24]) = NaN;
                    % Spikes in SWP A 50cm
                    output([1520 3303 3998],29) = NaN;
                    % Spikes in SWP A 100cm
                    output([492 493 550 849 1284 2522 2523 3148],29) = NaN;
                    % Spikes in KOhms A 50cm
                    output([1520 3303 3998],41) = NaN;
                    % Spikes in KOhms A 100cm
                    output([492 493 550 849 1284 2522 2523 3148],42) = NaN;
                    % Spikes in CO2 Canopy
                    output([256 424 425 1573:1577 2941 2956 3107 6874 7107 7145 7217 8913 14721 16063 16209 16308 16309],86) = NaN;                    
            
                case '2018'
                    
                    % Air Temp Battery Issues
                    output([9558 9563 9623 9634 9771 9780 9826 9831],3) = NaN;
                    % Spikes in Snow Depth Data
                    output([14 18 41 90 213 230 282 296 324:327 3921 4534 9533:9557 9581:9590 9628:9633 9778:9831],6) = NaN;
                    % Down PAR Abv & Blw Canopy
                    output([7312:7351 7575:9454],[7 9 10 11 12 13]) = NaN;
                    % Up PAR Abv Canopy
                    output(8337:8338,8) = NaN;
                    % Up (col 12) and Down (col 13) Longwave Abv Canopy
                    output([9832 15604:15642 13192:13196 13476:13478 13523:13525 16393:16394 13682:13693],[12,13]) = NaN;
                    
                    % Net Longwave Blw Canopy
                    output([],15) = NaN;
                    
                     %%% Swap reversed SW and LW data (up & down are reversed) %%%%%%%
                     tmp = output(:,10);
                     output(:,10)=output(:,11);
                     output(:,11)=tmp;
                     
                     tmp = output(:,12);
                     output(:,12)=output(:,13);
                     output(:,13)=tmp;
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     
                    % Soil Heat Flux Spikes
                    output([7312:7351 7575:9454],[18:21]) = NaN;
                    % All Soil Water Potential Spikes
                    output([7575:9454],[25:48]) = NaN;
                    % SWP A 10cm Spikes
                    output([5027 5028],27) = NaN;
                    % Spikes in CO2 Canopy
                    output([2773 4936 6445 9104 10313 12947 13270 13477 17310],86) = NaN;      
                    % SWP B50 
                    output(5020,35) = NaN;
                    RH_max = 100;
                case '2019'
                    % This may be needed.
%                     %%% Swap reversed SW and LW data (up & down are reversed) %%%%%%%
%                      tmp = output(:,10);
%                      output(:,10)=output(:,11);
%                      output(:,11)=tmp;
%                      
%                      tmp = output(:,12);
%                      output(:,12)=output(:,13);
%                      output(:,13)=tmp;
%                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Corrections applied to all years of data:
            % 1: Set any negative PAR and nighttime PAR to zero:
            PAR_cols = [];
            try
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'UpPAR_AbvCnpy')==1)];
                PAR_cols = [PAR_cols; output_cols(strcmp(output_names,'DownPAR_BlwCnpy')==1)];
            catch
            end
            
            %%% Set the bottoms of PAR (a
            %         if strcmp(site,'TP74')==1 && year == 2003
            %             DownParBot = 19;
            %             UpParBot = 21.5;
            %             DownParBlwBot = 15;
            %         else
            DownParBot = 10;
            UpParBot = 15;
            DownParBlwBot = 15;
            %         end
            
            %Plot uncorrected:
            figure(97);clf;
            subplot(211)
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Uncorrected PAR');
            %         if year <= 2008
            [sunup_down] = annual_suntimes(site, year_ctr, 0);
            %         else
            %             [sunup_down] = annual_suntimes(site, year, 0);
            %         end
            ind_sundown = find(sunup_down< 1);
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            try
                output(output(:,PAR_cols(1)) < DownParBot & sunup_down < 1,PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < UpParBot & sunup_down < 1,PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < DownParBlwBot & sunup_down < 1,PAR_cols(3)) = 0;
            catch
            end
            try
                output(output(:,PAR_cols(1)) < 0 , PAR_cols(1)) = 0;
                output(output(:,PAR_cols(2)) < 0 , PAR_cols(2)) = 0;
                output(output(:,PAR_cols(3)) < 0 , PAR_cols(3)) = 0;
            catch
            end
            % Plot corrected data:
            figure(97);
            subplot(212);
            plot(output(:,PAR_cols)); legend(output_names_str(PAR_cols,:))
            title('Corrected PAR');
            
            % 2: Set any RH > 100 to NaN -- This is questionable whether to make
            % these values NaN or 100.  I am making the decision that in some
            % cases
            RH_cols = [];
            try
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_AbvCnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_Cnpy')==1)];
                RH_cols = [RH_cols; output_cols(strcmp(output_names,'RelHum_BlwCnpy')==1)];
            catch
            end
            % Adjust columns to match output:
            %     RH_cols = RH_cols - 6;
            figure(98);clf;
            subplot(211)
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Uncorrected RH')
            if ~isempty(RH_max)
                RH_resp = RH_max; % RH_max should be set within each year of data.
            else
                RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            end
%             RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
            for j = 1:1:length(RH_cols)
                output(output(:,RH_cols(j)) > 100,RH_cols(j)) = RH_resp;
            end
            subplot(212);
            plot(output(:,RH_cols)); legend(output_names_str(RH_cols,:))
            title('Corrected RH');
            
            
            %% %%%%%%%%%%%%%%%%% TPD_PPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'TPD_PPT'
            switch yr_str
                case '2012'
                case '2013'
                    % Missing PrecipA,B data
                    output(10860:12472,1:2) = NaN;
                    % Missing AirTemp 2m data
                    output([5117:12472 14618:15104],3) = NaN;
                case '2014'
                    % Missing AirTemp 2m and Panel temp data
                    output([4918:5653 6722:17520],3:4) = NaN;
                case '2015'
                    % Poured hot water in to melt ice in the rain gauge
                    output(2821:2824,1:2) = NaN;
            end
    end
    
    
    
    %% @@@@@@@@@@@@@@@@@@ CHECK TIMECODE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if proc_flag == 1
        PAR_tmp = output(:,output_cols(strcmp(output_names,'DownPAR_AbvCnpy')==1));
        mcm_check_met_shifts(PAR_tmp,year_ctr, site)
        
        disp('Check to see if data is shifted relative to UTC.  If so, shift data.');
    end
    %%%%%%%%%% This part cascades all of the windows (if there is more
    %%%%%%%%%% than one figure
    % Check how many figures are open)
    hvis = get(0,'HandleVisibility');
    set(0,'HandleVisibility','on');
    nfigs = get(0,'Children');
    set(0,'HandleVisibility',hvis)                                                                                                                                      
    % Do cascade if >1 are open.
    if length(nfigs)>1
        cascade;
    else
    end
    %%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %% Plot corrected/non-corrected data to make sure it looks right:
    figure(10);
    j = 1;
    while j <= length(vars30)
        figure(10);clf;
        plot(input_data(:,j),'r.-'); hold on;
        plot(output(:,j),'b.-');
        grid on;
        %     title(var_names(vars30(j),:));
        title([var_names(vars30(j),:) ', column no: ' num2str(j)]);
        
        legend('Original','Fixed (output)');
        %% Gives the user a chance to move through variables:
        switch skipall_flag
            case 1
                response = '9';
            otherwise
        commandwindow;
        response = input('Press enter to move forward, enter "1" to move backward, 9 to skip all: ', 's');
        end
        
        if isempty(response)==1
            j = j+1;
        elseif strcmp(response,'9')==1;
            j = length(vars30)+1;
        elseif strcmp(response,'1')==1 && j > 1;
            j = j-1;
        else
            j = 1;
        end
    end
    clear j response accept
    
    if proc_flag == 1
        
        %% Plot Soil variables for final inspection:
        figure(5);clf;
        for i = 1:1:length(Ts_cols_A)
            subplot(2,1,1)
            hTsA(i) = plot(output(:,Ts_cols_A(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hTsA,TsA_labels(:,12:end))
        title('Pit A - Temperatures -- Corrected')
        
        for i = 1:1:length(Ts_cols_B)
            subplot(2,1,2)
            hTsB(i) = plot(output(:,Ts_cols_B(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hTsB,TsB_labels(:,12:end))
        title('Pit B - Temperatures -- Corrected')
        
        
        % B. Soil Moisture:
        figure(6);clf;
        
        for i = 1:1:length(SM_cols_A)
            subplot(2,1,1)
            hSMA(i) = plot(output(:,SM_cols_A(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hSMA,SMA_labels(:,6:end))
        title('Pit A - Moisture -- Corrected')
        
        for i = 1:1:length(SM_cols_B)
            subplot(2,1,2)
            hSMB(i) = plot(output(:,SM_cols_B(i)),'Color',clrs(i,:)); hold on;
        end
        legend(hSMB,SMB_labels(:,6:end))
        title('Pit B - Moisture -- Corrected')
    end
    %% Output
    % Here is the problem with outputting the data:  Right now, all data in
    % /Final_Cleaned/ is saved with the extensions corresponding to the
    % CCP_output program.  Alternatively, I think I am going to leave the output
    % extensions the same as they are in /Organized2 and /Cleaned3, and then
    % re-write the CCP_output script to work on 2008-> data in a different
    % manner.
    master(1).data = output;
    master(1).labels = names30_str;
    save([output_path site '_met_cleaned_' yr_str '.mat'], 'master');
    clear master;
    
    if auto_flag == 1
            resp2 = 'y';
    else
        commandwindow;
    resp2 = input('Are you ready to print this data to /Final_Cleaned? <y/n> ','s');
    end
    
    if strcmpi(resp2,'n')==1
        disp('Variables not saved to /Final_Cleaned/.');
    else
        for i = 1:1:length(vars30)
            temp_var = output(:,i);
            save([output_path site '_' yr_str '.' vars30_ext(i,:)], 'temp_var','-ASCII');
            
        end
        disp('Variables saved to /Final_Cleaned/.');
        
    end
    switch auto_flag
        case 0
            commandwindow;
            junk = input('Press Enter to Continue to Next Year');
        otherwise
    end
end
mcm_start_mgmt;
end

%subfunction
% Returns the appropriate column for a specified variable name
function [right_col] = quick_find_col(names30_in, var_name_in)

right_col = find(strncmpi(names30_in,var_name_in,length(var_name_in))==1);
end

