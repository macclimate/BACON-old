 function [] = mcm_CPEC_storage(year, site, T_flag, quickflag)
%%% mcm_CPEC_storage.m
%%%
%%% This function calculates both heat and CO2 storage in the canopy below
%%% CPEC systems.  Fc, CO2 concentrations, and resultant NEE are cleaned
%%% for spikes and outputted
%
%%% This script also corrects fluxes (Fc, Hs, Htc, LE) for temperature and
%%% pressure differences between that used by CPEC (often given a default
%%% value) and actual data, as measured by met stations..
% usage: mcm_CPEC_storage(year, site, T_flag)
% T_flag: 1 for Celsius (most or all cases), 2 for Kelvin


if nargin ==2
    T_flag = [];
    quickflag = 0;
elseif nargin == 3
    quickflag = 0;
end

% if quickflag ==1
% %     T_flag = 1;
% %    disp('Quickflag is on for mcm_CPEC_storage. Assuming T is in Celsius'); 
% end
%%%%%%%%%%%%%%%%%
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
%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%%

Ma = 28.97; % approx molar mass of dry air:
rho_a = 1200;  % approx density of dry air (g/m3)

%%% Declare Paths:
ls = addpath_loadstart;
% if yr >= 2008 || (yr >= 2007 && strcmp(site,'TP39')==1)
output_path =   [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
jjb_check_dirs(output_path,0);
cleaned_path =  [ls 'Matlab/Data/Met/Final_Cleaned/' site '/'];
filled_path =   [ls 'Matlab/Data/Met/Final_Filled/' site '/'];
flux_path =     [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/'];
% else
% output_path =   [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
% cleaned_path =  [ls 'Matlab/Data/Met/Final_Cleaned/CCP/' site '/'];
% filled_path =   [ls 'Matlab/Data/Met/Final_Filled/' site '/'];
% flux_path =     [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Cleaned/'];
% end


%% Main Loop

for year_ctr = year_start:1:year_end
    clear Ta APR CO2_* Fc* *_col Hs* Htc* LE* CPEC_Ta CPEC_APR dt
    clear storage_params z* toph cpyh dT* Jt* T1* T2* dc* c1* c2*
    clear mean_ds NEE* master dcdt*
    close all;
    yr_str = num2str(year_ctr);
    disp(['Working on year ' yr_str '.']);
    len_yr = yr_length(year_ctr);
    
    %%% Load necessary data:
    try
        cleaned = load([cleaned_path site '_met_cleaned_' yr_str '.mat']);
    catch
        disp('could not load the cleaned master file.  Probably because you''re running pre-2008 data');
    end
    filled = load([filled_path site '_met_filled_' yr_str '.mat']);
    flux = load([flux_path site '_CPEC_cleaned_' yr_str '.mat']);
    
    % if exist([output_path site '_CPEC_calc_' year '.mat'],'file')==2
    %     calc = load([output_path site '_CPEC_calc_' year '.mat']);
    % else
    %     calc.master = struct;
    % end
    
    Ta = load_from_master(filled.master,'AirTemp_AbvCnpy');
%     RH = load_from_master(filled.master,'RelHum_AbvCnpy'); % Added 20180314 by JJB to enable VPD calculation.
    
    APR = load_from_master(filled.master,'Pressure');
    [CO2_top CO2_top_col] = load_from_master(flux.master,'CO2_irga');
    [Fc Fc_col]= load_from_master(flux.master,'Fc');
    [Hs Hs_col] = load_from_master(flux.master,'Hs');
    [Htc Htc_col] = load_from_master(flux.master,'Htc');
    [LE LE_col]= load_from_master(flux.master,'LE_L');
    [CPEC_Ta CPEC_Ta_col] = load_from_master(flux.master,'Tair');
    [CPEC_APR CPEC_APR_col] = load_from_master(flux.master,'BarometricP');
    
    %%% Added 20160130 by JJB - auto-determine Ta in C or K:
    if nanmean(Ta) > 100 && (nanmean(CPEC_Ta) > 100 || sum(~isnan(CPEC_Ta))==0)
        T_flag = 1; % Kelvin - Changed from 2 to 1 by JJB -- now performing conversion below
        disp('It appears that T is in Kelvin. Converting to C');
        Ta = Ta - 273.15;
    elseif nanmean(Ta) < 100 && (nanmean(CPEC_Ta) < 100 || sum(~isnan(CPEC_Ta))==0)
        T_flag = 1; % Celsius
        disp('It appears that T is in Celsius');
    else
        T_flag = [];
        disp('It''s unclear what unit T is in -- investigate this.');
    end
    
    %%% Load CO2 canopy data:
    try
        CO2_cpy = load_from_master(cleaned.master,'CO2_Cnpy');
    catch
        disp('Could not find canopy CO_{2}.  Either it doesn''t exist or problem with mcm_CPEC_storage.');
        CO2_cpy = NaN.*ones(len_yr,1);
    end
    %%%%%%%%%%%%%%%%%%%%% CORRECT FLUXES FOR T and APR Differences %%%%%%%%%%%
    
    
    [Fc_new corr_factor] = CPEC_T_APR_Correction(Fc, CPEC_Ta, CPEC_APR, Ta, APR, T_flag);
    Hs_new = Hs.*corr_factor;
    Htc_new = Htc.*corr_factor;
    LE_new = LE.*corr_factor;
    
    clear Fc Hs Htc LE;
    Fc = Fc_new;
    Hs = Hs_new;
    Htc = Htc_new;
    LE = LE_new;
    %
    % %%% Load CO2 canopy data:
    % % if yr >= 2008 || (yr == 2007 && strcmp(site,'TP39')==1)
    % try
    %     CO2_cpy = load_from_master(cleaned.master,'CO2_Cnpy');
    % catch
    %     disp('Could not find canopy CO_{2}.  Either it doesn''t exist or problem with mcm_CPEC_storage.');
    %     CO2_cpy = NaN.*ones(len_yr,1);
    % end
    % % else
    %     try
    %        disp( 'It is not recommended to use this functions for data this old -- there may be problems with data alignment');
    %        % Try loading from Master File (It should be there):
    %        load([ls 'Matlab/Data/Master_Files/' site '/' site '_data_master_' year '.mat']);
    % %            right_col = find(strncmp(master.labels(:,3),'CO2_Cnpy',8) == 1);
    %            CO2_cpy = master.data(:,strncmp(master.labels(:,3),'CO2_Cnpy',8) == 1);
    %            clear master
    %     catch
    %         disp('Error near line 105 -- Was not able to load from master file:');
    %     end
    % end
    [junk, junk, junk, dt] = jjb_makedate(year_ctr, 30);
    clear junk*
    
    %%% Load parameters pertaining to height of system
    [storage_params] = params(year_ctr, site, 'CO2_storage');
    z_top = storage_params(:,2); z_cpy = storage_params(:,3);
    col_flag = storage_params(:,4); % tells program to use 1-height or 2-height
    
    toph(1:len_yr,1) = z_top; % distance from cpy sensor to top sensor
    cpyh(1:len_yr,1) = z_cpy; % distance from ground to top sensor
    z = toph+cpyh;          % total height of column:
    clear storage_params z_top z_cpy;
    
    %%% DO HEAT STORAGE FIRST: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Shift Temperature data by one point and take difference to get dT/dt
    %%% Also cuts off the extra data point that is created by adding NaN
    T1top = [NaN; Ta(1:length(Ta)-1)];
    T2top = [Ta(1:length(Ta)-1) ; NaN];
    
    %%% Heat Storage
    dTdt = T1top-T2top;
    Jt(:,1) = 22.25.*0.6.*dTdt +1.66;    %% Blanken et al. (1997)
    Jt(1,1) = Jt(2,1); Jt(length(dt),1) = Jt(length(dt)-1,1);
    %%% Fill small gaps with linear interp:
    [Jtfill] = jjb_interp_gap(Jt,[], 3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% CLEAN LE, H %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [LE_cleaned] = mcm_CPEC_outlier_removal(site, LE, 30, 'LE');
    [Hs_cleaned] = mcm_CPEC_outlier_removal(site, Hs, 30, 'H');
    
    if ~isempty(find(~isnan(Htc)))
        [Htc_cleaned] = mcm_CPEC_outlier_removal(site, Htc, 30, 'H');
    else
        Htc_cleaned = Htc;
    end
    
    % clear LE Hs Htc;
    % Hs = Hs_clean;
    % Htc = Htc_clean;
    % LE = LE_clean;
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The following has been removed -- it's taken care of in mcm_fluxfixer.m

% %     %%% CO2 STORAGE: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     %%%% Auto-calibration screws up CO2 concentration at same time every night
% %     %%%% if it is turned on at the site.  We'll try to remove this by checking
% %     %%%% this every night to see if the down-spike occurred.
% %     
% %     if strcmp(site,'TP74') == 1 || strcmp(site,'TP02') == 1
% %         ind_cal = (11:48:length(dt))';
% %         [junk2 junk] = Papale_spike_removal(CO2_top, 10);
% %         CO2_top_fix = CO2_top;
% %         
% %         a = find(isnan(junk(ind_cal)));
% %         CO2_top_fix(ind_cal(a),1) = NaN;
% %         
% %         figure('Name', 'Fixing CO2_top for calibration spikes');clf;
% %         plot(CO2_top); hold on;
% %         plot(CO2_top_fix,'g.');
% %         title('CO2_top with calibration spikes removed..')
% %         
% %         
% %         CO2_top = CO2_top_fix;
% %         clear junk* CO2_top_fix;
% %     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    %%% Shift CO2_top data by one point and take difference to get dc/dt
    %%% Also cuts off the extra data point that is created by adding NaN
    c1top = [NaN; CO2_top(1:length(CO2_top)-1)];
    c2top = [CO2_top(1:length(CO2_top)-1) ; NaN];
    c1cpy = [NaN; CO2_cpy(1:length(CO2_cpy)-1)];
    c2cpy = [CO2_cpy(1:length(CO2_cpy)-1) ; NaN];
    %%%%%%%%%%%%%%%%%%%%% 1-height %%%%%%%%%%%%%%%%%%%%
    %%% Calculate CO2 storage in column below system: One-Height approach
    %%%*** Note the output of this is in umol/mol NOT IN mg/m^3 ***********
    % dcdt_1h(:,1) = (c2top-c1top).*(z/1800);
    dcdt_1h(:,1) = (c2top-c1top).*(rho_a./Ma).*(z./1800);
    
    %%%%%%%%%%%%%%%%% 2-height %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if col_flag(1,1) == 2 % Calculate for the top and bottom halves
        %%% top
        dcdt_top = (c2top-c1top).*(rho_a./Ma).*(toph./1800);
        %%% bottom
        dcdt_cpy = (c2cpy-c1cpy).*(rho_a./Ma).*(cpyh./1800);
        
    elseif col_flag(1,1) == 1;
        dcdt_top(1:length(dt),1) = NaN;
        dcdt_cpy(1:length(dt),1) = NaN;
    end
    %%% Add top and bottom storages
    dcdt_2h(:,1) = dcdt_top + dcdt_cpy;  %% 2-height storage in umol/mol m^-2s^-1
    
    %% Remove outliers
    
    %%% Do the first-through removal of large outliers:
    dcdt_1h(abs(dcdt_1h) > 20) = NaN;
    dcdt_2h(abs(dcdt_2h) > 20) = NaN;
    %%% We somehow need to quality control these CO2 storage estimates, since
    %%% we'll have to make a single estimate out of these--
    %%% We'll use the 2-height first, and then if it's not there, use
    %%% 1-height
    mean_ds(1:length(dcdt_1h),1) = NaN;
    mean_ds(isnan(mean_ds),1) = dcdt_2h(isnan(mean_ds),1);
    mean_ds(isnan(mean_ds),1) = dcdt_1h(isnan(mean_ds),1);
    
    
    figure('Name', 'CPEC_storage: dcdt');clf;
    plot(mean_ds,'r','LineWidth',2);hold on;
    plot(dcdt_1h,'b'); 
    plot(dcdt_2h,'g');
    % plot this on the figure
    
    legend('final','1-height', '2-height')
    
    NEE_uncleaned = Fc + mean_ds;
    
    %% Spike detection to clean up NEE data:
    [NEE_cleaned] = mcm_CPEC_outlier_removal(site, NEE_uncleaned, 30, 'Fc');
    
    %% Calculate VPD (added 20180314 by JJB):
%     VPD = VPD_calc(RH,Ta,2); % VPD in hPa
    
    %% Save data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% This entire section has been commented out as of Aug 27, 2010 by JJB.
    %%% Overwriting the variables below to the Final_Cleaned/ directory is a
    %%% very bad idea.  If fluxfixer is not run directly before
    %%% mcm_CPEC_storage, there is no way to know if we are double or even
    %%% triple correcting this data, and then saving it back into the same
    %%% directory to be later loaded and corrected again.
    %%% Instead, we will save these extra variables to the /Final_Calculated
    %%% Column, and have the compiler load the variables out of there.
    
    % % % 1. Save the fluxes that had been corrected for T & APR:
    % %
    save([flux_path site '_' yr_str '.Fc_corr'],'Fc','-ASCII');
    save([flux_path site '_' yr_str '.LE_corr'],'LE','-ASCII');
    save([flux_path site '_' yr_str '.Hs_corr'],'Hs','-ASCII');
    save([flux_path site '_' yr_str '.Htc_corr'],'Htc','-ASCII');
    save([flux_path site '_' yr_str '.CO2_irga_corr'],'CO2_top','-ASCII');
    % %
    % %
    % % % 2. Overwrite fluxes, Ta, and APR into master files:
    % %
    % % flux.master.data(:,Fc_col) = Fc;
    % % flux.master.data(:,Hs_col) = Hs;
    % % flux.master.data(:,Htc_col) = Htc;
    % % flux.master.data(:,LE_col) = LE;
    % % % flux.master.data(:,CPEC_Ta_col) = Ta;
    % % % flux.master.data(:,CPEC_APR_col) = APR;
    % % flux.master.data(:,CO2_top_col) = CO2_top;
    % %
    % % % Save master cleaned flux file:
    % % master = flux.master;
    % % save([flux_path site '_CPEC_cleaned_' year '.mat'],'master')
    % % clear master;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3. Save calculated data (NEEraw, Jt, dcdt) to /Final_Calculated/:
    %%% Do I want to save this to a master file, or just individuals and let
    %%% data compiler take care of them?
    
    master.data = [NEE_cleaned LE_cleaned Hs_cleaned Htc_cleaned Jtfill mean_ds CO2_top Fc dcdt_1h dcdt_2h];
    master.labels = {'NEE_cleaned';'LE_cleaned'; 'Hs_cleaned'; 'Htc_cleaned'; 'Jtfill'; 'dcdt'; 'CO2_top'; 'Fc';'dcdt_1h'; 'dcdt_2h'};
    % save([output_path site '_' year '.NEE_raw'],'NEE_raw','-ASCII');
    % save([output_path site '_' year '.Jt'],'Jtfill','-ASCII');
    % save([output_path site '_' year '.dcdt'],'mean_ds','-ASCII');
    % Changed July, 2010 -- save the data as a master structure file:
    save([output_path site '_CPEC_calculated_' yr_str '.mat'],'master');
    disp(['Master file saved to ' output_path site '_CPEC_calculated_' yr_str '.mat']);
    commandwindow;
    
    if quickflag == 1
    else
        junk = input('Press Enter to Continue to Next Year');
    end

end

%%% Ask user if they want to run the compiler before continuing:
if quickflag == 1
    resp3 = 'n';
else
    commandwindow;
    disp('It is recommended that you run mcm_data_compiler at this point.');
    resp3 = input('Do you want to run mcm_data_compiler now? (y/n) > ','s');
end

if strcmp(resp3,'n')==1
else
    mcm_data_compiler([],site,'',1);
end

if quickflag == 1
else
    mcm_start_mgmt;
end

