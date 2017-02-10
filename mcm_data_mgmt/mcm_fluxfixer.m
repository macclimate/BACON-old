function [pts_to_shift] = mcm_fluxfixer(year, site,auto_flag)
% usage: mcm_fluxclean(year, site, auto_flag)
% auto_flag = 0 runs in standard mode
% auto_flag = 1 runs in automated mode

ls = addpath_loadstart;
%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
    auto_flag = 0; % flag that determines if we're in automated mode or not
elseif nargin == 2
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
%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%%

%%% Declare Paths:
% load_path = [ls 'SiteData/' site '/MET-DATA/annual/'];
load_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Cleaned/'];
output_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/'];
jjb_check_dirs(output_path,0);
% header_path = [ls 'Matlab/Data/Flux/CPEC/Docs/'];
header_path = [ls 'Matlab/Config/Flux/CPEC/']; % Changed 01-May-2012
met_path = [ls 'Matlab/Data/Met/Final_Cleaned/' site '/'];
% Load Header:
% header_old = jjb_hdr_read([header_path 'mcm_CPEC_Header_Master.csv'], ',', 3);
% header_tmp = mcm_get_varnames(site);
header_tmp = mcm_get_fluxsystem_info(site, 'varnames');

t = struct2cell(header_tmp);
t2 = t(2,1,:); t2 = t2(:);
% Column vector number
col_num = (1:1:length(t2))';
header = mat2cell(col_num,ones(length(t2),1),1);
header(:,2) = t2;er_old = jjb_hdr_read([header_path 'mcm_CPEC_Header_Master.csv'], ',', 3);

% Title of variable
var_names = char(header(:,2));
num_vars = max(col_num);

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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 1: Cycle through all variables so the investigator can look at the
%%% data closely

% Load data:
load([load_path site '_CPEC_clean_' yr_str '.mat' ]);
input_data = master.data; clear master;
output = input_data;

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

while j <= num_vars
    %     temp_var = load([load_path site '_' year '.' char(header{k,2})]);
    %     input_data(:,j) = temp_var;
    %     output(:,j) = temp_var;
    temp_var = input_data(:,j);
    switch scrollflag
        case 1
            figure(1)
            clf;
            plot(temp_var);
            %     hold on;
            title([strrep(var_names(j,:),'_','-') ', column no: ' num2str(j)]);
            grid on;
            
            
            %% Gives the user a chance to change the thresholds
            commandwindow;
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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 2: Specific Cleans to the Data

switch site
    case 'TP39'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% % Added 19-Oct-2010 by JJB
            %%%% Clean CSAT and flux data using value of std for Ts or w
            bad_CSAT = isnan(output(:,26))==1 | output(:,26) > 2.5;
            output(bad_CSAT, [16 22]) = NaN; 
            bad_CSAT2 = isnan(output(:,25))==1 | output(:,25) > 2.5;
            output(bad_CSAT2, [1:5 19 20 21]) = NaN;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch yr_str
            case '2002'
                output([7042:7043 10244:10269 14183:14210],17) = NaN;
                %%% Shift flux data into UTC:
                output = [NaN.*ones(9,size(output,2)); output(1:9063,1:end); ...
                    output(9065:14376,1:end); NaN.*ones(2,size(output,2)); output(14377:end-10,1:end)];
            % Fix a data offset issue, by moving data back by 1
                    % halfhour KEEP THIS AT THE END
                    output = [output(2:9638,:);NaN.*ones(1,size(output,2));output(9639:17520,:)];
                
            case '2003'
                output([2329:2337 7752:7754 9878:9924],17) = NaN;
                %%% Shift flux data into UTC:
            try load([load_path site '_CPEC_clean_2002.mat' ]);TP39_2002 = master.data; clear master; 
            catch
               disp('could not load 2002 cleaned flux data');   TP39_2002 = NaN.*ones(size(output));
            end                
                output = [TP39_2002(end-10+1:end,1:end); output(1:6129,1:end); ...
                    output(6132:14512,1:end); output(14514:end-7,1:end)];
            
            case '2004'
                % CRazy looking Fc data in start of 2004:
                output([2754:2959],1) = NaN;
                output([613 2721:2774],17) = NaN;
                % bad looking LE data:
                output([6116:6238 6770:7142 8337:8859 9810:10423],5) = NaN;
                %%% Shift flux data into UTC:
            try load([load_path site '_CPEC_clean_2003.mat' ]);TP39_2003 = master.data; clear master; 
            catch
               disp('could not load 2003 cleaned flux data');   TP39_2003 = NaN.*ones(size(output));
            end                
                output = [TP39_2003(end-8+1:end,1:end); output(1:end-8,1:end)];
            
            case '2005'
                output(11029:11030,[16 22]) = NaN;
                 output([2186 8409:8425],17) = NaN;
                output(11174,18) = NaN;
                %%% Shift flux data into UTC:
            try load([load_path site '_CPEC_clean_2004.mat' ]);TP39_2004 = master.data; clear master; 
            catch
               disp('could not load 2004 cleaned flux data');   TP39_2004 = NaN.*ones(size(output));
            end                
%                 output = [TP39_2004(end-9+1:end,1:end); output(1:end-9,1:end)];
                output = [TP39_2004(end-8+1:end,1:end); output(1:end-8,1:end)]; % Modified by JJB to fix a time shift offset issue

                
            case '2006'
            bad_CO2 = [(3094:3103)';(8061:8077)'; (12602:12609)'];
            bad_H2O = [(8061:8095)'];
                output(bad_CO2, 17) = NaN;
                output(bad_H2O, 18) = NaN;
                clear bad_*
            %%% Shift flux data into UTC (right now in EDT)
            try            load([load_path site '_CPEC_clean_2005.mat' ]);  TP39_2005 = master.data; clear master; 
            catch
               disp('could not load 2005 cleaned flux data');   TP39_2005 = NaN.*ones(size(output));
            end
            output = [TP39_2005(end-8+1:end,1:end); output(1:9652,1:end); ...
                NaN.*ones(1,size(output,2)); output(9653:11832,1:end); output(11834:13027,1:end);...
                NaN.*ones(1,size(output,2)); output(13028:end-9,1:end)];                
            % fix a data offset issue, by moving data back by 1 halfhour KEEP THIS AT THE END
            output = [output(1:6490,:);output(6492:11050,:);NaN.*ones(1,size(output,2));output(11051:end,:)];
            
            
            case '2007'
             output(650:950,:) = NaN; % Obviously bad data (in all variables)
             output([8138:8177 12261],17) = NaN;
            % Fix CO2 offset problems:
            output(464:468,17) = NaN;
            output(469:944,17) = output(469:944,17) + 100;
            
            %%% Shift flux data into UTC (right now in EDT)
            try load([load_path site '_CPEC_clean_2006.mat' ]);  TP39_2006 = master.data; clear master; 
            catch
               disp('could not load 2006 cleaned flux data');   TP39_2006 = NaN.*ones(size(output));
            end
            output = [TP39_2006(end-7:end,:); output(1:end-8,:)];
            
            case '2008'                     

            output(5594:5599,17) = NaN; % 

            clear bad_IRGA;
            %%% Shift flux data into UTC (right now in EDT)
            try load([load_path site '_CPEC_clean_2007.mat' ]);  TP39_2007 = master.data; clear master; 
            catch
               disp('could not load 2007 cleaned flux data');   TP39_2007 = NaN.*ones(size(output));
            end
            output = [TP39_2007(end-7:end,:); output(1:end-8,:)];
  
            case '2009'
                output([13580:13589],17) = NaN;
                output([13580:13711],18) = NaN;

                output(1:700,:) = NaN; % before installed.
                output(output(:,17) == 455.6962,17) = NaN;
                output(output(:,18) == 30.927267,18) = NaN;
                output(output(:,22) == 5.0000019,22) = NaN;
                
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 13, until the
                %%% end of the year:
                output((13:48:17520)',[17,18,1,5]) = NaN;
            case '2010'
               output([3730 7907],17) = NaN;
                
               output(output(:,17) == 455.6962,17) = NaN;
               output(output(:,17) == 450,17) = NaN;
               
               output(output(:,18) == 30.927267,18) = NaN;
               output(output(:,22) == 5.0000019,22) = NaN; 
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                % Remove LE data when H2O is maxed out:
               output((output(:,18)> 29.999 & output(:,18)< 29.9995) |...
                   (output(:,18)> 49.990 & output(:,18)< 50) | ...
                   (output(:,18)> 32.4999 & output(:,18) < 32.5001),[5 18]) = NaN;
               
               %%% Correct H2O and LE data for overestimation due to
               %%% impropoper calibration:
               output(3740:14296,18) = (output(3740:14296,18)-(-1.867)) ./ 1.7807;
               output(3740:14296,5) = output(3740:14296,5).*0.57122;               
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 13, until the
                %%% end of the year:
                output((13:48:17520)',[17,18,1,5]) = NaN;
            case '2011'
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 13, until the
                %%% end of the year:
                output((13:48:17520)',[17,18,1,5]) = NaN;  
                % Remove bad CO2 IRGA data
                output([3911 5117:5118 5241:5243 10550:10605 14005 14062:14103 15483:15582],17) = NaN; 
                output([3911 5117:5118 5240:5243 9973:9974 10550:10605 14006 14103 15480:15520 16408:16430],18) = NaN; 
                output(output(:,17) == 455.6962,17) = NaN;
                output(output(:,17) == 450,17) = NaN;
               
                output(output(:,18) == 30.927267,18) = NaN;
                output(output(:,22) == 5.0000019,22) = NaN; 
                
            case '2012'
                % Remove bad Fc data
                output(176,1) = NaN;
                % Remove bad CO2 IRGA data
                output([174:175 1566:1568 4786:4836 5537 5849 7527:7531 7806:7807 10215 12569 14563 17317:17321 17323 17325 17327 17329 17331 17333 17335 17337 17339],17) = NaN;
                % Remove bad H20 IRGA data (calibration)
                output([599 600 602 1333:1335 1337 1339 1341 1343 1345 1347 1349 1351 1353:1355 4786:4788 4790 4792 4794 4796 4798 4800 4802 4804 4806 4808 4810 4812 5537:5539 5541 5543:5545 5547 5549 7806 7807 14563 7527:7531 17317:17321 17323 17325 17327 17329 17331 17333 17335 17337 17339],18) = NaN;
                % Remove bad Penergy data
                output(176,7) = NaN;
                % Remove bad Le data
                output(12568:12569,5) = NaN;
                
            case '2013'
                % Remove bad Fc data
                output([6810 7364:7800 10523],1) = NaN;
                % Remove bad LE data
                output([5131 7364:7800 9610],5) = NaN;
                % Remove bad pEnergy data
                output(7364:7800,7) = NaN;
                % Remove bad CO2 IRGA data
                output([1246 1580:3452],17) = NaN;
                % Remove bad H2O IRGA data
                output([1246 1580:3452 7763: 8568:8569 15848 16541:16542],18) = NaN;
                % Remove bad Ts data
                output([7725:7794 8533:8569 10139:10170 11476:11496],22) = NaN;
                % Remove bad IRGA Ta
                output([1246 1323 1580:3452 5792:5806 6132 6804:6805 8568:8569 8570 9731 10748:10750 15857 16541:16542],27) = NaN;
                % Remove bad IRGA pressure
                output([1246 1580:3452],28) = NaN;
                
                %%% Fix time shifts introduced into flux data by computer
                %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2013)
                    output = [output(1:4274,:);output(4277:9106,:);NaN.*ones(2,size(output,2));output(9107:12924,:);output(12927:13863,:);...
                        NaN.*ones(2,size(output,2)); output(13864:17520,:)];
                        % Round 2 of fixes - found issues in the internal data logger clock
                output = [output(1:4740,:);NaN.*ones(1,size(output,2)); output(4741:5051,:); output(5053:11533,:); output(11535:12119,:);NaN.*ones(1,size(output,2));...
                    output(12120:17520,:)];
        case '2014'
                % Remove bad Fc data
                output([2010 2097 3381 3356 15737 15830 15831],1) = NaN;
                 % Remove bad u* data
                output([5701 5703 10405],2) = NaN;
                % Missing HTc , HRcoeff, Bk sensors/data
                output(:,[4 9 11]) = NaN;
                % Remove bad LE data
                output([2010 14004 15830],5) = NaN;
                % Remove bad pEnergy data
                output([2010 2097 3356 3381 5635 13387 15830 15831] ,7) = NaN;
                % Remove bad CO2 IRGA data
                output([ 1317 3381:3689 8777  15740 15779 15827:15833],17) = NaN;  %12046:12082
                % Remove bad H2O IRGA data
                output([ 1317  13875:13876],18) = NaN; % 12046:12082
                % Remove bad Ts data
                % output([ ],22) = NaN;
                % Remove bad IRGA Ta
                output([7877 7873 11493 13875 13894],27) = NaN;
                % Remove bad IRGA pressure
                output([1317 7873 8600:8778 11493 13875 15310 15740:15833],28) = NaN;
                 %%% Fix time shifts introduced into flux data by computer
                %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2014)
                    output = [output(1:4276,:);output(4279:14307,:);NaN.*ones(2,size(output,2));output(14308:17520,:)];

         case '2015'
                % Spikes in Fc 
                output([2918 4792 6503 9600 11336 13771 15089],1) = NaN;
                % Spikes in UStar
                output([4026 14613],2) = NaN;
                % Big spikes in Penergy
                output([207 601],7) = NaN;
                % Bad periods in CO2-irga
                output([2628:2918 6368:6473 14530:14532],17) = NaN;
                % Spikes in H2O-irga
                output([14532 15154],18) = NaN;
                % Bad spikes in T-s
                output([8553:8578 9106:9108 9362:9370 9530:9531 9601:9602 9605 9607:9609 10375 10653 10665 10667:10680 11119:11121 ...
                    12219 12989:12993 13029 13040:13055 13496:13505 15155:15156 16647:16667 17291:17299 17394:17408],22) = NaN;
                % Bad spikes in T-irga
                output([7249:7252 8003 9013 10159 10159:10167 11070:11087 11508],27) = NaN;
                % Spikes in H2O-irga
%                 output([7249:7250 10159:10167 11070:11087], ) = NaN;
                % Remove bad values for IRGA-related variables:
                output([224:610],[17:18 1 5]) = NaN;

                %%% Fix time shifts introduced into flux data by computer
                %%% timing issues (KEEP THESE LINES AT THE END OF FIXES FOR 2015)
                    output = [output(1:4178,:);output(4181:11124,:);NaN.*ones(2,size(output,2));output(11125:17520,:)];
 
         case '2016'
                % Spikes in Fc 
                output([514 736 1571:1573 1575 1957:1960 2290 4206 5168 6740 6754 7205 7590 8265 8320 10665 10964 11168 12357 13497 14780 17452],1) = NaN;
                % Spikes in UStar
                output([736 12540 12954 14144:14146],2) = NaN;
                % Big spikes in Hs
                output([412:416 2850 3779 3982 4352 5218 7137 8549:8553 9125 9374 9763 10271 11385 12513:12542 12955 12988 13132],3) = NaN;
                % Spike in Le-L
                output([2769 2777 2842 4211 5415 5793 7291 8265 8681 8727 9589 10046 11022],5) = NaN;
                % Negative Spikes P-energy
                output([514 736 1573 1575 1957:1960 2770:2778 4206 4935 5167 5168 6740 6754:6757 7205 7590 8265 8320 10387 10783 10964 12357 14780 16691 17452],7) = NaN;
                % Tair Irregularities
                output([736 747 1874 14423 14758],16) = NaN;
                % CO2 irga
                output([512 1571:1574 1957:1960 2769:2772 5933:5982 6090:6093 7088 7907 10077 10984:10986 11369 12598 12599 13229:13231 17334],17) = NaN;
                % H20 - irga
                output([6094 10984 11906],18) = NaN;
                % T-s
                output([10985 10986],22) = NaN;
                % T - irga
                output([512 5933:5994 6090:6095 7088 7907 10077 10985:10994 13229:13236 17334],27) = NaN;
                % P - irga
                output([512:515 5932:5982 6090:6095 6272:6275 7907 10077 10323:10409 13229:13231],28) = NaN;
         
            case '2017'
                % Spikes in Fc 
                output([161],1) = NaN;
                % Spikes in UStar      
                output([161],2) = NaN;
                % Big spikes in Hs
                output([124 130 157:161],3) = NaN;
                 % Negative Spikes P-energy
                output([161],7) = NaN;
                
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TP74
    case 'TP74'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% % Added 19-Oct-2010 by JJB
            %%%% Clean CSAT and flux data using value of std for Ts or w
            bad_CSAT = isnan(output(:,26))==1 | output(:,26) > 2.5;
            output(bad_CSAT, [16 22]) = NaN; 
            bad_CSAT2 = isnan(output(:,25))==1 | output(:,25) > 2.5;
            output(bad_CSAT2, [1:5 19 20 21]) = NaN;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch yr_str
            
            %             case '2007'
            
            case '2008'
                bad_CO2 = [616 758 2075:2200 2680:2682 3201];
                output(bad_CO2,18) = NaN;
                clear bad_CO2;
                output(9867,18) = NaN; % bad data point;
                output(15366,2) = NaN; % bad data point;
                output(1:400,:) = NaN; % before it was installed
                bad_irga = [7804:7855 9025:9060 11367:11454]';
                irga_cols = [1;5;6;7;8;17;18];
                output(bad_irga,irga_cols) = NaN; %bad data
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                clear irga_cols bad_irga;
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 11, until the
                %%% end of the year:
                output([11:48:17568]',[17,18,1,5]) = NaN;      
                
                %%% There is a lot of really noisy Fc data in the early
                %%% part 
            case '2009'
                bad_irga1 = [ 8451:8492 14957:15147]';
                bad_irga3 = [(6751:6795)'; bad_irga1];
                bad_irga2 = [(5985:6408)' ; bad_irga3];
                
                output(bad_irga1,[1;7]) = NaN; % Fix Fc, Penergy, CO2, H2O
                output(bad_irga3,[17;18]) = NaN; % Fix Fc, Penergy, CO2, H2O
                output(bad_irga2,[5;6;8]) = NaN; % Fix LE, WUE
%                 output(5985:6408,7) = output(5985:6408,7).*-1; % Flip Penergy
                output(8811,17) = NaN;
                
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                clear bad_irga*;
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 11, until the
                %%% end of the year:
                output([11:48:17520]',[17,18,1,5]) = NaN;
                %%% Remove flux data when computer undergoes auto-restart:
                output([12:48:17520]',[1,5]) = NaN;
                
            case '2010'
                % bad Fc Data: 
                output(6014:6098,[1 3 5 7]) = NaN;
                % bad CO2 data:
                output([1182 3054 3733 3738 15014], 17) = NaN;
                
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end                
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 3083, until the
                %%% end of the year:
                output([3083:48:17520]',[17,18,1,5]) = NaN;
                
                %%% Remove all data associated with IRGA for period of
                %%% 12-Dec to 29-Dec, as IRGA was off...
                output([16605:17421],[1 5 7 8 10 17 18]) = NaN;
                %%% Remove flux data when computer undergoes auto-restart:
                output([12:48:17520]',[1,5]) = NaN;       
            case '2011'
                % bad Fc data
                output([1798:1824 3961:4220 5118:5214 6952:7281 7779:8335 9327:9334 12116],1) = NaN;
                % bad LE data
                output([1798:1824 3961:4220 5118:5214 6952:7281 7608:8335 9327:9334 12116],5) = NaN;
                % bad CO2 data
                output([1811:1812 6952:7080 8916:8919],17) = NaN;
                % bad H2O data
                output([1797:1818 6951:7080 7531 7581 15671:15675 16982:16987],18) = NaN;
                
            case '2012'
                % Bad CO2 - where CO2 is flatlined around 450
                bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                output(bad_co2,[1 17]); % remove for Fc and CO2 concentration

                % Bad Fc data
                output([7524 10158:10164 ],1) = NaN;
                % Bad Penergy data
                output([7524 10155:10165],7) = NaN;
                % bad CO2 IRGA data
                output([12240:12250],17) = NaN;
                
            case '2013'
                % Bad CO2 - where CO2 is flatlined around 450
                bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                output(bad_co2,[1 17]) = NaN; % remove for Fc and CO2 concentration
                
                % Bad Fc data
                output([1067 3035 16523],1) = NaN;
                % Bad Penergy data
                output([1067 3035 5387],7) = NaN;
                % Bad CO2 IRGA data (flatline)
                output([10109:10169],17) = NaN;
                
           case '2014'   
                % Bad CO2 - where CO2 is flatlined around 450
                bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                output(bad_co2,[1 17]) = NaN; % remove for Fc and CO2 concentration
               
                % Bad Fc data
                % output([2060 2095],1) = NaN;
                % Spikes in T irga data
                output([1326 7877 11493 13892 14139:14170 14709:14746 15751 ],27:28) = NaN;
                
           case '2015'
               % Bad CO2 - where CO2 is flatlined around 450
                bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                output(bad_co2,[1 17]) = NaN; % remove for Fc and CO2 concentration
               % Spike in Fc
               output([16811],1) = NaN;
               %Spike in Ustar
               output([2986 7647 17387],2) = NaN;
               % Spike in H2O irga
               output([2632:2645 5851:5866 6370:6394 6671:6682],18) = NaN;
               
               % Bad T-s data
               output([133:161 4710 4740 4750 4754 5651:5743 6251 6299 7644:7646 7653 7658 7922:7936 8095:8102 ...
                   8523:8524 8555 8558:8569 8572:8575 8590 9150 9315 9346:9347 10654:10655 11085 11088 12225:12226 14439 ...
                   15582 17033:17035 17395:17408],22) = NaN;
               
               % Spike in T-irga & P-irga
               output([2632:2645 5851:5866 6370:6394 6671:6682],[27 28]) = NaN;
               output([7249:7256 11067:11087 15160:15161 16734],27) = NaN;
               output([11067:11086],28) = NaN;
               
            case '2016'
               % Bad CO2 - where CO2 is flatlined around 450
                bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                output(bad_co2,[1 17]) = NaN; % remove for Fc and CO2 concentration
                % Fc Spikes
                output([4121 6370 6393 6417 6633 7044 7098 7099 7505 7590 7931 8621:8624 8937 9556 9606 9611 9800 9994 10042 10781 10860 11437 11442 12204 12665 13217 13218 13255 14278 14568 16715 17435],1) = NaN;
                % Ustar Spikes
                output([404 3010:3055 9910 10666 13738 16622:16626 17332],2) = NaN;
                % Hs Spikes
                output([407 2624 2657 6660 6710 7954 8433 8624 9369 11385 11602 13134 16902],3) = NaN;
                % Le-L Spikes
                output([2843 4435 6137 7044 7099 7284 8265 8266 8681 9351 9586 9972 11601 11700 11900 11901 12175 12325 14772 17337],5) = NaN;
                % P energy spike
                output([1604:1605 4121 6393 7098 7099 7165 7505 7590 7931 9556 9800 9994 10042 10666 10781 10964 11437 11442 12204 13217 13218 14568 16715 17435 17483],7) = NaN;
                % C02 irga spikes
                output([3961:3672 4211:4220 6826 7163 7164 8996 9775 12597:12602 13217],17) = NaN;
                % H20 irga spikes
                output([2142:2169 2183:2185 2211 6937:6952 7099 7356:7370 7539:7546 8625:8650 8864:8890 17330:17337],18) = NaN;
                % Constant zero U,V, and W-values
                output([2659 2660 2662:2678 2929:3049],[19:21]) = NaN;
                % Bad T-s data
                output([2164:2173 2179:2186 2190 2195 2198 2200 2202 2307:2308 2926:3055 10782 13229:13232 16627:16631 16890:16960 17334:17336],22) = NaN;
                % T & P-irga
                output([2142:2169 2184 2211 4211 6890:6924 6937:7100 7356:7370 7537:7546 8625:8650 8864:8890 9775 9776 9832:9834 10991:10993 11359:11367 13229:13235 17334:17338],27:28) = NaN;
        end        
        
           
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TP89
        %     case 'TP89'
        %         switch year
        %             case '2008'
        %             % Adjust nighttime PAR to fix offset:
        %              output(output(:,6) < 8,6) = 0;
        %              % Adjust RH to be 100 when it is >100
        %              output(output(:,2) > 100,2) = 100;
        %         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TP02
    case 'TP02'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% % Added 19-Oct-2010 by JJB
            %%%% Clean CSAT and flux data using value of std for Ts or w
            bad_CSAT = isnan(output(:,26))==1 | output(:,26) > 2.5;
            output(bad_CSAT, [16 22]) = NaN; 
            bad_CSAT2 = isnan(output(:,25))==1 | output(:,25) > 2.5;
            output(bad_CSAT2, [1:5 19 20 21]) = NaN;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch yr_str
            %             case '2007'
            case '2008'
                output(1:8750,:) = NaN; %%%% Removing in-lab (test period)
                output(14534:15836,:) = NaN; %%%% Removing bad period - PDQ problems??
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 11, until the
                %%% end of the year:
                output([11:48:17568]',[17,18,1,5]) = NaN;
                %%% Remove flux data when computer undergoes auto-restart:
                output([12:48:17568]',[1,5]) = NaN;    
            case '2009'
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                output([5953 9676:9695 14118:14167],17) = NaN;
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 11, until the
                %%% end of the year:
                output([11:48:17520]',[17,18,1,5]) = NaN;
                
            case '2010'  
                for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
                    output(output(:,jj)==-1.5646218e-6,jj) = NaN;
                    if jj >= 23
                        output(output(:,jj)== 0,jj) = NaN;
                    end
                end
                %%% Remove LE data when H2O is maxed out:
                output(output(:,18)> 39.999,5) = NaN;
                %%% Remove bad CO2 data:
                output([3068 3069 3724 3725 3781],17) = NaN;
                
                %%% Remove concentration data during daily calibration:
                %%% Cals were turned back on at data point 3083, until the
                %%% end of the year:
                output([3083:48:17520]',[17,18,1,5]) = NaN;
                %%% Remove flux data when computer undergoes auto-restart:
                output([12:48:17520]',[1,5]) = NaN;    
                
               %%% Correct H2O and LE data for overestimation due to
               %%% impropoper calibration:
               output(3750:14295,18) = (output(3750:14295,18)-(-4.2219)) ./ 1.4544;
               output(3750:14295,5) = output(3750:14295,5).*0.68951;  
               
            case '2011'
                % Bad Fc data
                output([203 5016:5029 7259:7277 9341:9346],1) = NaN;
                % Bad CO2 IRGA data
                output(6282:6330,17) = NaN;
                
            case '2012'
                % Bad Fc data (for 3 days CO2 dropped to
                % ~250, not entirely sure of cause but likely gas-related
                output([11569:11710 14589:14895 15114:15313],1) = NaN;
                % Bad CO2 IRGA data (same problem as above)
                output([3878:3885 3926:3931 6711:6720 6753:6768 6806:6815  11569:11710 14589:14895 15114:15313],17) = NaN;
                % Bad Penergy data (same problem as above)
                output([11569:11710 14589:14895 15114:15313],7) = NaN;
                % Bad H2O IRGA data
                output([11709 14247 15127:15175],18) = NaN;
                
            case '2013'
                % Bad Fc data
                output(17132,1) = NaN;
                % Bad CO2 IRGA data
                output([3695:3856 6130 6457:6463 17133],17) = NaN;
                % Bad H2O IRGA data
                output(3695:3856,18) = NaN;
                % Bad Ts data
                output(9114:9447,22) = NaN;
                % Bad Tirga, Pirga data
                output([3694:3857 10119:10177 14330 14618],27:28) = NaN;
           case '2014'
               % missing Fc, u*, Hs, LE, Penergy, Bl, Eta, theta, beta, P& Tair,
               % CO2irga, H2O irga, u,w,Ts  data,
               % output(10525:12525,[1:3 5:6 7 10 12:22]) = NaN;
               % Not sure - a couple hours in the midde, shuold we get rid
               % of these?
               %%% REMOVE IRGA DATA FOR MALFUNCTIONING PERIOD FOR ALL VARIABLES
               output(4501:12500,[17,18,1,5,7,8,27,28,29,30])=NaN;
               output(11550:11551,:) = NaN; % Bad points
               bad_co2 = find(output(:,17) > 449.9999 & output(:,17) < 450.0001);
                  bad_h2o = find(output(:,18) > 18.9999 & output(:,18) < 19.0001);
                  bad_CSAT = find(output(:,19)==-1.5646218e-6);
                  output(bad_CSAT,19:26)= NaN;
                
              % Bad CO2 irga (flatlines @ 400)
             output(bad_co2,17) = NaN;
             % Bad H2O irga (flatlines)
             output(bad_h2o,18) = NaN; 
             % T Irga spikes
             output([5825 6935 9890 15354 15780],27) = NaN;
          
           case '2015'
             % Fc spikes,  
             output([390 400 1958:1959 2147 6120 6446 7117:7118 13820 14811:14812 15771:15773],1) = NaN;
             % Ustar spike
             output([4065],2) = NaN;
             % Penergy spikes
             output([390 400 1958:1959 7117:7118 14811:14812 15771:15773],7) = NaN;
             % Fc spikes, Penergy, IRGA
             output([2146:2147 11913 13820 16744],[1 7 17 18]) = NaN;
             % CO2-irga
             output([376 399:400 2148 2248 6350:6393 8863:8896],17) = NaN;
            
             % H2O IRGA spikes
             output([376 2148 2248 8892:8911 9077:9100 9733 13821],18) = NaN;
             % Bad T-s points
             output([10622 11054 11055 13406:13407],22) = NaN; 
             % Tirga only
              output([175:177 4957:4958 13820:13821 14783:14784 16744:16745],27) = NaN;
        
            case '2016'
              %Fc Spikes
              output([3149 5223 5413 6083 6837 7020 7376 7528 7614 7905 8237 8624 8679 8758 8813 9047 9368 9762 9850 10218 10898 10962 10964 11306 12110 12169 13034 13216 13904],1) = NaN;
              %Ustar
              output([4435 9368 9764 11890 11617],2) = NaN;
              %LE-L Spikes
              output([2622 2624 2625 2628 2629 3637 4197 5223 5413 7004 7528 7561 7676 9910 10615 10788 11123 13286 14421 17329],5) = NaN;
              %Penergy Spikes
              output([3149 3481 6083 6837 7020 8758 8813 9047 9368 9606 9850 10898 10964 11306 12169 13216],7) = NaN;
              %CO2-IRGA spikes
              output([182 7383 8852 10006 12640 14673],17) = NaN;
              %H2O IRGA spikes
              output([182 9778 10983:10986 15023 17332],18) = NaN;
              %T-s spikes
              output([1873:1880 2930:2952 9768],22) = NaN;
              %u-std spikes
              output([16907:16911],23) = NaN;
              %v-std spikes
              output([16907:16911],24) = NaN;
              %w-std spikes
              output([16907:16911],25) = NaN;
              %Ts-std spikes
              output([16907:16911],26) = NaN;
              %T IRGA spikes
              output([325 326 10986 11376 12132],27) = NaN;
              %P IRGA spikes
              output([182 7172 7173 7174 7175 7383 10983:10985],28) = NaN;
              
          
             
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
         case 'TPD'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% % Added 19-Oct-2010 by JJB
            %%%% Clean CSAT and flux data using value of std for Ts or w
%             bad_CSAT = isnan(output(:,26))==1 | output(:,26) > 2.5;
%             output(bad_CSAT, [16 22]) = NaN; 
%             bad_CSAT2 = isnan(output(:,25))==1 | output(:,25) > 2.5;
%             output(bad_CSAT2, [1:5 19 20 21]) = NaN;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch yr_str
            %             case '2007'
            case '2012'     
                output([809:822],1) = NaN;
                output([808, 1524:1539 2484],17) = NaN;
                 badh2o = find(output(:,18)> 49.995 & output(:,18) < 50.005);
                 output(badh2o,18) = NaN;
%                  badh2o = find(output(:,18)> 22.495 & output(:,18) < 25.005);
%                  output(badh2o,18) = NaN;
                 
                 % remove bad IRGA data:
                 bad_P = [5291:5362, 5366];
                 output(bad_P,[17:18 27:30]) = NaN;
                 
                  %remove bad LE_L data
                 output([808 816],5) = NaN;
                 
                 % remove bad H20 IRGA data
                 output([14916:15632 15755:15924 11147:11259],18) = NaN;
                 
                 %remove bad u data
                output([14916:14932 14962:14995 15009:15200 15207:15210 15228:15336 15391:15632],19) = NaN;
                
                 %remove bad v data
                 output([14916:14932 14962:14995 15009:15200 15207:15210 15228:15336 15391:15632],20) = NaN;
                 
                 %remove bad w data 
                 output([14916:14932 14962:14995 15009:15200 15207:15210 15228:15336 15391:15632],21) = NaN;
                 
                 %remove bad Ts data 
                 output([14916:14932 14962:14995 15009:15200 15207:15210 15228:15336 15391:15632],22) = NaN;
                 
                 %remove bad T irga data
                 output([8251:8266 8300:8314 8783:8790 8974:8990 9015:9043 9056:9086 9116:9123 9179:9204 9310:9320 9357:9371 9541:9575 9839:9855 9882:9892 10361:10376 10407:10424 11147:11259 11421:11427 12059:12069 14916:14932 14962:14995 15009:15200 15207:15210 15228:15336 15391:15632 15755:15924],27) = NaN;
%                 
%                 % Remove bad CSAT data:
%                 bad_CSAT = find(output(:,19)==-1.5646218e-6);
%                 output(bad_CSAT,19:26)= NaN;
%                 bad_CSAT2 = find(output(:,23)< 0.005);
%                 output(bad_CSAT2,19:26)= NaN;
%                 for jj = 19:1:26 % Remove zeros from CSAT data (bad data)
%                     output(output(:,jj)==-1.5646218e-6,jj) = NaN;
%                     if jj >= 23
%                         output(output(:,jj)== 0,jj) = NaN;
%                     end
%                 end
       
         case '2013'  
                  bad_co2 = find(output(:,17) > 399.9999 & output(:,17) < 400);
                  bad_h2o = find(output(:,18) > 22.4999 & output(:,18) < 22.5001);
                  bad_CSAT = find(output(:,19)==-1.5646218e-6);
                  output(bad_CSAT,19:26)= NaN;
             % Bad Fc data   
              output([1420 1862 2740:2840],1) = NaN;
             % Bad P energy
              output([1420 1862],7) = NaN;
             % Bad CO2 irga (flatlines @ 400)
             output(bad_co2,17) = NaN;
             output([1595:1714 1856:1861 2727:2848 3131:4887 8897:9061 12299:12468],17) = NaN;
             % Bad H2O irga (flatlines)
             output(bad_h2o,18) = NaN;
             output([1595:1714 1856:1861 2755:2841 3131:4887 8897:9061 12299:12468],18) = NaN;
             % Bad Tirga (flatlines)
             output([1595:1714 1856:1861],27) = NaN;
             output(bad_h2o,27) = NaN;
             % Bad Pirga (flatlines)
             output([1595:1714 1856:1861],28) = NaN;
             output(bad_h2o,28) = NaN;
          
          case '2014'
              % Spike in all
              output(15492,:) = NaN;
              % Fc - Penergy had some similar spikes, I'm not sure if these
              % are issues or normal
              output([2272 6936 1787 13077 15492],1) = NaN;
              % H2O irga (flatlines)
              output([2843:2943 5661 12630:12688 14826],18) = NaN;
             
            case '2015'
             % Hs
              output([2036 17028],3) = NaN;
             % Fc + Penergy spikes
              output([703 1163 1247 17148 16475 17384:17385],[1 7]) = NaN;
             % CO2 irga spikes
              output([184 683 657 2972:2975 17384],17) = NaN;
              % H20 irga spikes
              output([10715:10718 10915:10916 11514:11515 12155:12158 16218:16219 17384],18) = NaN;
            %  Bad T-s data
              output([133:143 5107 6005 7661 7924:7925 8099 8539 8565:8570 10653:10659 10672:10676 11702 12216:12228 ...
                  16077:16079 16083:16113],22) = NaN;
              % Bad T-irga
              output([10715:10718 11514:11792 12154:12158],27) = NaN;
              
            case '2016'
             % Fc Spikes
             output([831 2002 2849 3145 3835 4197 4207 4451 4684 5211 5596 5648 6896 7857 8048 11643 12166 12559 14053],1) = NaN;
             %Ustar
             output([397 2658 2846 3543 3566 4030 4680 4681 9124 9368 14113 14427  17028],2) = NaN;
             %Hs Spikes
             output([3542 4030 14116 14417 16913 16921:16924 16928:16929 17329],3) = NaN;
             % LE-L Spikes
             output([1669 1670 3397 3835 4678 6953 7809 7857 7918 8097 8962 9252 9971 10074 10746 12130 12325 12609],5) = NaN;
             % Penergy
             output([2849 5211 10665 10964 11643 11685 12166 12559 12600],7) = NaN;
             % Tair Spikes
             output([393 2657 14125],16) = NaN;
             % CO2-irga Spikes
             output([1499:1501 1964 1965 7378 10722 12590 12600 13835:13949 15431 16571:16695],17) = NaN;
             % H2O-irga Spikes
             output([1964 1965 12590 13835:13950 16571:16695],18) = NaN;
             % u Spikes
             output([2658:2674 2929:2979 3542 3543 4850:4859 5831:5841 5876 5877 14113:14116 14125 14417 14428 14432:14443 15532 16085 16914 16919 17452 17453],19) = NaN;
             % T-s Spikes
             output([393 2657:2674 2929:2979 2989 3335:3359 3523:3532 6409:6411 13228:13231 14125 14434:14443 17205 17451],22) = NaN;
             % T-irga Spikes
             output([11127 11129 13835:13949],27) = NaN;
        end
        
end
          
            
%% Plot corrected/non-corrected data to make sure it looks right:

figure(4);
j = 1;
while j <= num_vars
    figure(4);clf;
    plot(input_data(:,j),'r'); hold on;
    plot(output(:,j),'b');
    grid on;
     title([strrep(var_names(j,:),'_','-') ', column no: ' num2str(j)]);
    legend('Data Removed', 'Data Kept');
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
        j = num_vars+1;
    elseif strcmp(response,'1')==1 && j > 1;
        j = j-1;
    else
        j = 1;
    end
end
clear j response accept

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compare with met data to shift data appropriately to UTC if necessary:

% %%% Set overrides for shifts here, or remove data points, or make shifts:
switch site
    case 'TP74'
        shift_override = [];
    case 'TP89'
        shift_override = [];
    case 'TP02'
        shift_override = [];
end

%%% Load the met wind speed data (to be used for comparison):
met = load([met_path site '_met_cleaned_' yr_str '.mat']);
MET_DAT = met.master.data(:,mcm_find_right_col(met.master.labels,'WindSpd'));
u = output(:,mcm_find_right_col(var_names,'u')); v = output(:,mcm_find_right_col(var_names,'v'));
CPEC_DAT = sqrt(u.^2 + v.^2); clear u v;
u_orig = input_data(:,mcm_find_right_col(var_names,'u')); v_orig = input_data(:,mcm_find_right_col(var_names,'v'));
CPEC_ORIG = sqrt(u_orig.^2 + v_orig.^2); clear u_orig v_orig;

num_lags = 16; 
win_size = 500; % one-sided window size 
increment = 100;

[pts_to_shift] = mov_window_xcorr(MET_DAT, CPEC_DAT, num_lags,win_size,increment);

%%% Plot the unshifted timeseries, along with Met data
close(findobj('Tag','Pre-Shift'));
figure('Name','Data_Alignment: Pre-Shift','Tag','Pre-Shift');
figure(findobj('Tag','Pre-Shift'));clf;
plot(MET_DAT,'b');hold on;
plot(CPEC_ORIG,'Color',[0.8 0.8 0.8]);
plot(CPEC_DAT,'Color',[1 0 0]);
% plot(shifted_master(:,find_right_col(master.labels,'u_mean_ms-1')),'g');
legend('Met WSpd', 'Orig CPEC WSpd', 'Corrected CPEC WSpd');%, 'Orig EdiRe WSpd',  'Corrected EdiRe WSpd');
grid on;
set(gca, 'XMinorGrid','on');

disp('Investigate Data Alignment through attached figure ');
disp(' and by looking at output of this function.  Fix if needed.');


%% Output
% Here is the problem with outputting the data:  Right now, all data in
% /Final_Cleaned/ is saved with the extensions corresponding to the
% CCP_output program.  Alternatively, I think I am going to leave the output
% extensions the same as they are in /Organized2 and /Cleaned3, and then
% re-write the CCP_output script to work on 2008-> data in a different
% manner.


continue_flag = 0;
while continue_flag == 0;
    commandwindow;
    resp2 = input('Are you ready to print this data to /Final_Cleaned? <y/n> ','s');
    if strcmpi(resp2,'n')==1
        continue_flag = 1;
        
    elseif strcmpi(resp2,'y')==1
        continue_flag = 1;
        for i = 1:1:num_vars
            temp_var = output(:,i);
            save([output_path site '_' yr_str '.' char(header{i,2})], 'temp_var','-ASCII');
        end
        master(1).data = output;
        master(1).labels = var_names;
        save([output_path site '_CPEC_cleaned_' yr_str '.mat' ], 'master');
        
    else
        continue_flag = 0;
        
    end
end
switch skipall_flag
    case 0;
commandwindow;
junk = input('Press Enter to Continue to Next Year');
    otherwise;
end
end
mcm_start_mgmt;
end
%subfunction
% Returns the appropriate column for a specified variable name
function [right_col] = quick_find_col(names30_in, var_name_in)

right_col = find(strncmpi(names30_in,var_name_in,length(var_name_in))==1);
end