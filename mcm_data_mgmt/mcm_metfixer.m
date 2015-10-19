
function [] = mcm_metfixer(year, site, data_type)
%% mcm_metfixer.m
%%% This function is designed to be run on data after being processed with
%%% mcm_metclean.  Currently, this function should be used only on data
%%% collected in 2008 or later.  This function gives the user a chance to
%%% make final, manual adjustments to the data, that may not be fixable
%%% with a simple threshold.
%%% Variables are loaded from /Cleaned3/ and saved in /Final_Cleaned/
%%% Usage: mcm_metfixer(year, site), where year is a number and site a
%%% string

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
if isempty(data_type) == 1;
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
%%% Use minute intervals to find 30-min variables only
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
    commandwindow;
    resp3 = input('do you want to scroll through variables before fixing? <y/n> ', 's');
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
        %% @@@@@@@@@@@@@@@@@@ SOIL PROBES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
             case '2008'
                case '2009'
                case '2010'
                    
                case '2011'
                case '2012'
                case '2013'
                case '2014'
                case '2015'
                case '2016'
            
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
                    % Bad points (possibly)
                    output([6366:6569],4) = NaN;
                case '2016'
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
                    output([1367 13867 14384 14531 14066 19492 10716],[86 91]) = NaN;
                    % Spike in TsRef50 avg
                    output([14756],88:89) = NaN;
                    
                case '2015'
                    % Spike in Sap1avg,
                    output([2918 7246 7249 9010],3) = NaN;
                    % Spike in Sap3avg
                    output([4973:4977 7246 7249 9010],5) = NaN;
                    % Spike in Sap9avg
                    output([4977 7246 7249],11) = NaN;
                    % Spike in Sap10avg
                    output([7246 7249],12) = NaN;
                    % Spike in Sap13avg
                    output([4788 7246 7249],15) = NaN;
                    % Spike in Sap15avg
                    output([7246 7249],17) = NaN;
                    % Spike in Sap16avg, + 8500:11000 points
                    output([7246 7249],18) = NaN;
                    % Spike in Sap20avg
                    output([7246 7249],20) = NaN;

%                     
%              
                    
                    
                    
                case '2016'
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
                    % Sensor #12 removed in April
                    output(6131:17520, [12 29 46]) = NaN;
                    % poor sensor #17 data
                    output(:,[51 68]) = NaN;
                    % v. high sensor #1,2,4,5,7,8,9,14 data
                    %output(6125:6186,52) = NaN;
                    
                    % Seonsr 17 spikes
                    output([14827:14891],34) = NaN;
                    
                    
                case '2015'
                case '2016'
                    
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
                    
                    % Bad data point
                    output(5583,[12 15]) = NaN;
       
                    
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
                    % Swap some mixed up Ts sensors:
                    Ts5B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1));
                    Ts2B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1)) = [Ts5B_orig(1:5538,1) ; Ts2B_orig(5539:end)];
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1)) = [Ts2B_orig(1:5538,1) ; Ts5B_orig(5539:end)];
                    
                    % bad LW_down data:
                    output(:,18) = NaN;
                    
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
                    
                    % Swap some mixed up Ts sensors:
                    Ts5B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1));
                    Ts2B_orig = output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_5cm')==1)) = Ts2B_orig(1:end,1);
                    output(:,output_cols(strcmp(output_names,'SoilTemp_B_2cm')==1)) = Ts5B_orig(1:end,1);
                    
                    % Fix bad LWdown data
                    output([9204:9218 9295:9304 9971:9978 10005:10025 10069:10072 10158:10171 10207 10693:10701 10735:10748 10776:10785 10826:10843 10873:10892 10921:10947 10973:10991 11017 11026 11036 11037 11064:11072 11115:11124 11164:11182 11259 11277 11319:11324 11368:11373 11406:11410 11449:11469 11497:11517 12332:12334 13577:13579],18) = NaN;
                    
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                    
                                 case '2004'
                    % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt;
                      case '2005'
                     % Add PPT data from the /Final_Cleaned/TP39_PPT_2003-2007 directory
                    load([output_path(1:end-1) '_PPT_2003-2007/TP39_PPT_met_cleaned_' yr_str '.mat']);
                    output(:,output_cols(strcmp(output_names,'CS_Rain')==1)) = ppt;
                    clear ppt; 
                case '2006'
                    % Remove obvious bad data in PAR down abv cnpy
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
                    
                case '2010'
                    %%% Bad CO2 cpy data:
                    output([1625 4598 5611 6004 6005 6014 8027 15375 16607], 71) = NaN;
                    output([1196 1197 4598 5611 6004 6005 6014 6241 7910], 72) = NaN;
                    output([6005:6013],99) = NaN;
                    output(16840,97) = NaN;
                    % Bad Snow Depth Data:
                    output([3412 3415 9675 9798],31) = NaN;
                    
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
                    % Bad SR50 data
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
                    
                case '2012'
                    % Bad SMB100 data
                    output([1:221 7806:7809  10415:12894 17317], 100) = NaN;
                    % Bad SMB50 data
                    output([7805:7809 10416 14562:14575 17316 17317], 99) = NaN;
                    % Bad CO2 canopy data
                    output([598:601 6855:6860 1053 10416:10417 16597 16598 17318], 71) = NaN;
                    % Bad SM 20cm A Pit
                    output([7074:7075 8276:10212 ],93) = NaN;
                    % Bad SM 5cm B Pit
                    output([17316:17317], 96) = NaN;
                    % Bad SM 20cm B Pit
                    output([7805:7809 17316:17317],98) = NaN;
                    % Bad CO2 below canopy data
                    output([1:1568], 72) = NaN;
                    % Bad RMY Rain data
                    output(:,11) = NaN;
                    % Bad snow temp data
                    output([173 4785 5500 5536 5542 7574 7810 8805 8907 10417],30) = NaN;
                    % Bad 2m NR-Lite data
                    output([766 1076:1078 1468:1471 2190:2192],12) = NaN;
                    % Removal of 2m NR-Lite (sensor stolen)
                    output(9275:end,12) = NaN;
                    % Bad group temp data
                    output([4785 8907 ],29) = NaN;
               
                case '2013'
                   
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
                    output(413611,100) = NaN;
                  
                    
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
                    
                    
                case '2015'
                    %%% Data is forward-shifted between 7251 and 11129
                    %%% (needs to be shifted back by 2 half hours)
                    %output([7251:11129],:
                    % Bad Ta points
                    output([8615:8623 11508:11509],1) = NaN;
                    output([8691:8787],2) = NaN;
                    output([8617:8737],3) = NaN;
                                                       
             
                    % Bad snow depth data
                    output([396 404 417 419 422 470 472 474 4670 4790 8320 8534 9016 10652],27:28) = NaN;
                    output([7251 8615 8616 8623 10652],28) = NaN; 
                    % Bad ground and snow temp
                    output([7251 8320 8534 8615:8623 9016 11507:11509],29:30) = NaN;
                    
                    
                    output([396 404 417 419 422 470 472 474 4670 8615:8623],31) = NaN;
                    % Bad CO2 cnpy 
                    output([4687 5309 5310 7251 7808 8623 9014:9016],71) = NaN; 
                    
                    % Bad SM B 5cm
                    output([9012:9015],96) = NaN;
                    % Bad SM B 20cm + 10cm
                    output([7248:7250, 9012:9015],98:99) = NaN;
                    % Bad SM B 100cm
                    output([7249 7250 9015],100) = NaN;
                    
                    % N2 tank pressure
                    output([3044],77) = NaN;
                    
                    
                case '2016'
                    
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
            figure(55);clf;
            plot(output(:,PAR_cols(1)))
            hold on;
            plot(ind_sundown,output(ind_sundown,PAR_cols(1)),'.','Color',[1 0 0])
            title('Check to make sure timing is right')
            output(output(:,PAR_cols(1)) < 10 & sunup_down < 1,PAR_cols(1)) = 0;
            output(output(:,PAR_cols(2)) < 5 & sunup_down < 1,PAR_cols(2)) = 0;
            output(output(:,PAR_cols(3)) < 10 & sunup_down < 1,PAR_cols(3)) = 0;
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
            commandwindow;
            RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
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
                    % Remove spike in Ts Pit B 20cm
                    output(7248,20) = NaN;
                    % Remove spike in Tank Pressure N2 Cal
                    output([614 2912 2913],45) = NaN;
                    % Bad CO2 IRGA
                    output([6471 7433 7810 7899],47) = NaN;
                        % Multiply by 2
%                         output([8629:9149],47) = 
                    
                case '2016'
                                     
                   

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
            RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
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
                output(output(:,PAR_cols(3)) < 10 & sunup_down < 1,PAR_cols(3)) = 0;
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
            RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
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
            switch yr_str
                case '2002'
                    % Swap some mixed up SM sensors:
                    SM50B_orig = output(:,output_cols(strcmp(output_names,'SM_B_50cm')==1));
                    SM20B_orig = output(:,output_cols(strcmp(output_names,'SM_B_20cm')==1));
                    
                    output(:,output_cols(strcmp(output_names,'SM_B_50cm')==1)) = SM20B_orig(1:end,1);
                    output(:,output_cols(strcmp(output_names,'SM_B_20cm')==1)) = SM50B_orig(1:end,1);
                    clear SM50B_orig SM20B_orig;
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
                    % Bad soil temp data points
                    output([260 1251 2059],[11 12 13 15 16 17 18 19 21:22 27:31]) = NaN; %
                    output([1251 2059],[14 23:26]) = NaN;

                    
                    
                case '2016'
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
            RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
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
            %%% Convert wind speed to m/s
            output(:,22) = output(:,22)./3.6;
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
                    
                    
                    
                    
                case '2015'

                    % Bad snow depth 
                    output([2897 4452 4453 4455 4482 4538 4542 4545 4547 4662 7323],[6 ]) = NaN;   
                    
%%%%% uncomment this if nothing has been changed as of 2015
%                     %%% Swap reversed SW and LW data (up & down are
%                     %%% reversed)
%                     tmp = output(:,10);
%                     output(:,10)=output(:,11);
%                     output(:,11)=tmp;
%                     
%                     tmp = output(:,12);
%                     output(:,12)=output(:,13);
%                     output(:,13)=tmp;


                case '2016'
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
            RH_resp = input('Enter value to set RH > 100 to? (100 or NaN): ');
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
    commandwindow;
    response = input('Press enter to move forward, enter "1" to move backward, 9 to skip all: ', 's');
        
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
    
    
    resp2 = input('Are you ready to print this data to /Final_Cleaned? <y/n> ','s');
    if strcmpi(resp2,'n')==1
        disp('Variables not saved to /Final_Cleaned/.');
    else
        for i = 1:1:length(vars30)
            temp_var = output(:,i);
            save([output_path site '_' yr_str '.' vars30_ext(i,:)], 'temp_var','-ASCII');
            
        end
        disp('Variables saved to /Final_Cleaned/.');
        
    end
    junk = input('Press Enter to Continue to Next Year');
end
mcm_start_mgmt;
end



%subfunction
% Returns the appropriate column for a specified variable name
function [right_col] = quick_find_col(names30_in, var_name_in)

right_col = find(strncmpi(names30_in,var_name_in,length(var_name_in))==1);
end
