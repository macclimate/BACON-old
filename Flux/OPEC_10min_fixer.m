function [output_data] = OPEC_10min_fixer(site,qtflag)
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPEC_10min_fixer.m
%%% usage: [output_data] = OPEC_10min_fixer(site,qtflag), where site is a
%%% string label and qtflag set to 1 skips spike detection elements
%%% (speeding up processing) for quick checking of different elements.
%%% Perhaps the most important function for processing 10-min data.
%%% This function:
%%% 1. Loads 10-min cleaned data and does site-spec. manual fixes on data
%%% 2. Does rotation corrections and converts Fc and CO2 to umol units
%%% 3. Calculates storage and performs Papale spike removal function
%%% 4. Averages data to 30 minutes
%%% 5. Compares with Met Data to ensure no data shifts exist
%%% 6. Saves resulting 10 and 30-minute fixed and calculated data (eg. NEE)
% usage: OPEC_10min_fixer(site), where site is a string (e.g. 'TP74')
%%% Created July 12, 2010 by JJB
%%% Revision History:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0 || isempty(site)==1 || (~isempty(site) && ~ischar(site))
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
end
if nargin < 2
    qtflag = 0;
end
ls = addpath_loadstart('off');
%%% Declare Paths:
load_path = [ls 'Matlab/Data/Flux/OPEC/' site '/Cleaned/'];
save_path_cleaned = [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Cleaned/']; % For the cleaned-up data...
save_path_calc    = [ls 'Matlab/Data/Flux/OPEC/' site '/Final_Calculated/']; % For new data created (rotated, storage)
jjb_check_dirs(save_path_cleaned,0);
jjb_check_dirs(save_path_calc,0);
met_path = [ls 'Matlab/Data/Met/Final_Cleaned/' site '/']; % Data where the final_cleaned met data is stored...
TP39met_path =  [ls 'Matlab/Data/Met/Final_Cleaned/TP39/']; % Data where the final_cleaned TP39 met data is stored...
%%% Load the Master File:
load([load_path site '_OPEC_10min_cleaned.mat']);
% calc.data = struct;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot data before fixes (if desired)
if qtflag == 2
else
    resp = input('do you want to scroll through variables before fixing? <y/n> ', 's');
    if strcmpi(resp,'y') == 1;   scrollflag = 1; else scrollflag = 0; end
    
    j = 7;
    while j <= length(master.labels)
        temp_var = master.data(:,j);
        switch scrollflag
            case 1
                figure(1); clf;  plot(temp_var);
                title([char(master.labels(j)) ', column no: ' num2str(j)]);
                grid on;
                %%% Gives the user a chance to go through variables:
                response = input('Press enter to move forward, enter "1" to move backward, 9 to accept all: ', 's');
                if isempty(response)==1;                    j = j+1;
                elseif strcmp(response,'1')==1 && j > 1;    j = j-1;
                elseif strcmp(response,'9')==1;             j = length(master.labels)+1;
                else
                end
            case 0
                j = j+1;
        end
    end
    clear j response
    figure(1);clf
    text(0,0,'Make changes in program now (if necessary) -exit script','FontSize',18)
end
old_master = master.data;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Clean #1
%%% Enter manual site-specific fixes to 10-minute data:
switch site
    case 'TP74'
    case 'TP02'
        % Fix bad CO2_cpy data:
        right_col = find_right_col(master.labels,'co2stor_Avg');
        master.data([80454:81622 236410:240980 332870:356070],right_col) = NaN;
        clear right_col
    case 'TP89'
end
if qtflag==2
else
    %%% Plot the resulting data with changes.  Compare to previous data:
    j = 7;
    while j <= length(master.labels)
        
        figure(1); clf;  plot(old_master(:,j),'r'); hold on; plot(master.data(:,j),'b');
        title([char(master.labels(j)) ', column no: ' num2str(j)]);
        legend('Original', 'Fixed (output)');
        grid on;
        %%% Gives the user a chance to go through
        response = input('Press enter to move forward, enter "1" to move backward, 9 to accept all: ', 's');
        if isempty(response)==1;                    j = j+1;
        elseif strcmp(response,'1')==1 && j > 1;    j = j-1;
        elseif strcmp(response,'9')==1;             j = length(master.labels)+1;
        else
        end
        
    end
    clear j response
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Rotation Corrections and WPL:
% input arrangement:
% col 1 - x  % col 2 - y  % col 3 - z  % col 4 - xx  % col 5 - yy  % col 6 - zz
% col 7 - xy % col 8 - xz % col 9 - yz % col 10 - xc % col 11 - yc % col 12 - zc
% output arrangement:
% col 1 - u  % col 2 - v  % col 3 - w  % col 4 - uu  % col 5 - vv  % col 6 - ww
% col 7 - uv % col 8 - uw % col 9 - vw % col 10 - uc % col 11 - vc % col 12 - wc

%%%% Edited April 19, 2011 by JJB:
%%%%% Instead of doing an around-about method of applying the rotation
%%%%% corrections, we're instead going to do the rotation corrections on
%%%%% the raw covariances, and from there we will apply the WPL correction
%%%%% ourselves.  The Burba correction will have to be done after we align
%%%%% the data with 
% Constants:
ZeroK = 273.15;                         % zero deg. C in deg K.
R     = 8.31451;                        % J/mol/K universal gas constant
Rv    = 461.5;                          % J/kg/K gas constant for water vapour Stull(1995)
Rd    = 287.05;                         % J/kg/K gas constant for dry air Stull(1995)
Cp    = 1004.67;                        % J/kg/K specific heat for dry air at constant pressure Stull(1995)
Cpv   = 1875;                          % J/kg/K specific heat for water vapour at constant pressure Stull(1995)
Mc    = 44.01;                          % g/mol molecular weight co2 Stull(1995)
Ma    = 28.96;                          % g/mol molecular weight for mean condition of air, Stull(1995)
Mw    = 18.02;                          % g/mol molecular weight for water, Stull(1995)
mu    = 1.6077;                         % ratio of Ma:Mw
% Get necessary vars:
rho_v = master.data(:,find_right_col(master.labels,'h2o_Avg(1)'))./1000;         % in kg/m3
rho_c = master.data(:,find_right_col(master.labels,'co2_Avg(1)'))./1e6;   % in kg/m3
rho_a = master.data(:,find_right_col(master.labels,'rho_a_Avg'));          % in kg/m3
rho_d = rho_a - rho_v - rho_c;         % in kg/m3
APR  = master.data(:,find_right_col(master.labels,'press_Avg(1)')); % in kPa
Ts  = master.data(:,find_right_col(master.labels,'Ts_Avg(1)')); % in C
Ta = master.data(:,find_right_col(master.labels,'t_hmp_Avg(1)')); % in C
w_mean = master.data(:,find_right_col(master.labels,'Uz_Avg(1)'));
w_std  = sqrt(master.data(:,find_right_col(master.labels,'cov_Uz_Uz(1)')));
H2O_top  = master.data(:,find_right_col(master.labels,'h2o_Avg(1)'));
Wind_Speed  = master.data(:,find_right_col(master.labels,'wnd_spd(1)'));
u_std  = sqrt(master.data(:,find_right_col(master.labels,'cov_Ux_Ux(1)')));
u_star  = master.data(:,find_right_col(master.labels,'u_star'));
% Convert Ts into Ta - Put rho_a into a molar density (mmol/m^3)
[Ta_conv rho_a_conv] = Ts2Ta_using_density(Ts, APR, (rho_v.*1e6)./Mw);
Ta(isnan(Ta),1) = Ta_conv(isnan(Ta),1);
% rho_a(isnan(rho_a),1) = rho_a_conv(isnan(rho_a),1);
Ta_K = Ta + ZeroK;


%%%%%%%%%%%%%%% ROTATIONS: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Calculate for Fc:
rot_input_Fc = [find_right_col(master.labels,'Ux_Avg(1)') find_right_col(master.labels,'Uy_Avg(1)') ...
    find_right_col(master.labels,'Uz_Avg(1)') find_right_col(master.labels,'cov_Ux_Ux(1)') ...
    find_right_col(master.labels,'cov_Uy_Uy(1)') find_right_col(master.labels,'cov_Uz_Uz(1)') ...
    find_right_col(master.labels,'cov_Ux_Uy(1)') find_right_col(master.labels,'cov_Uz_Ux(1)') ...
    find_right_col(master.labels,'cov_Uz_Uy(1)') find_right_col(master.labels,'cov_Ux_co2(1)') ...
    find_right_col(master.labels,'cov_Uy_co2(1)') find_right_col(master.labels,'cov_Uz_co2(1)') ];
% [rot_output_Fc] = OPEC_Rotations(master.data(:,rot_input_Fc));
[rot_output_Fc] = OPEC_Rotations(master.data(:,rot_input_Fc));
wc_rot = rot_output_Fc(:,12); % in mg/m2/s

%%%% Calculate for LE:
rot_input_LE = [find_right_col(master.labels,'Ux_Avg(1)') find_right_col(master.labels,'Uy_Avg(1)') ...
    find_right_col(master.labels,'Uz_Avg(1)') find_right_col(master.labels,'cov_Ux_Ux(1)') ...
    find_right_col(master.labels,'cov_Uy_Uy(1)') find_right_col(master.labels,'cov_Uz_Uz(1)') ...
    find_right_col(master.labels,'cov_Ux_Uy(1)') find_right_col(master.labels,'cov_Uz_Ux(1)') ...
    find_right_col(master.labels,'cov_Uz_Uy(1)') find_right_col(master.labels,'cov_Ux_h2o(1)') ...
    find_right_col(master.labels,'cov_Uy_h2o(1)') find_right_col(master.labels,'cov_Uz_h2o(1)') ];
[rot_output_LE] = OPEC_Rotations(master.data(:,rot_input_LE));
wh2o_rot = rot_output_LE(:,12); % in g/m2/s

%%%% Calculate for Hs:
rot_input_Hs = [find_right_col(master.labels,'Ux_Avg(1)') find_right_col(master.labels,'Uy_Avg(1)') ...
    find_right_col(master.labels,'Uz_Avg(1)') find_right_col(master.labels,'cov_Ux_Ux(1)') ...
    find_right_col(master.labels,'cov_Uy_Uy(1)') find_right_col(master.labels,'cov_Uz_Uz(1)') ...
    find_right_col(master.labels,'cov_Ux_Uy(1)') find_right_col(master.labels,'cov_Uz_Ux(1)') ...
    find_right_col(master.labels,'cov_Uz_Uy(1)') find_right_col(master.labels,'cov_Ux_Ts(1)') ...
    find_right_col(master.labels,'cov_Uy_Ts(1)') find_right_col(master.labels,'cov_Uz_Ts(1)') ];
[rot_output_Hs] = OPEC_Rotations(master.data(:,rot_input_Hs));
corr_factor_Hs = rot_output_Hs(:,12)./master.data(:,find_right_col(master.labels,'cov_Uz_Ts(1)'));
Hs_rot = master.data(:,find_right_col(master.labels,'Hs')).*corr_factor_Hs;

%%%% Calculate for Htc:
rot_input_Htc = [find_right_col(master.labels,'Ux_Avg(1)') find_right_col(master.labels,'Uy_Avg(1)') ...
    find_right_col(master.labels,'Uz_Avg(1)') find_right_col(master.labels,'cov_Ux_Ux(1)') ...
    find_right_col(master.labels,'cov_Uy_Uy(1)') find_right_col(master.labels,'cov_Uz_Uz(1)') ...
    find_right_col(master.labels,'cov_Ux_Uy(1)') find_right_col(master.labels,'cov_Uz_Ux(1)') ...
    find_right_col(master.labels,'cov_Uz_Uy(1)') find_right_col(master.labels,'cov_Ux_fw(1)') ...
    find_right_col(master.labels,'cov_Uy_fw(1)') find_right_col(master.labels,'cov_Uz_fw(1)') ];
[rot_output_Htc] = OPEC_Rotations(master.data(:,rot_input_Htc));
corr_factor_Htc = rot_output_Htc(:,12)./master.data(:,find_right_col(master.labels,'cov_Uz_fw(1)'));
Htc_rot = master.data(:,find_right_col(master.labels,'H')).*corr_factor_Htc;
clear rot_input*

%%%%%%%%%%%%%%% WPL Corretions: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% WPL correction for h2o flux (output in kg/m2/s):
% w_h2o = master.data(:,find_right_col(master.labels,'cov_Uz_h2o(1)'))./1000; % in kg/m2/s
% Hs = master.data(:,find_right_col(master.labels,'Hs')); % in W/m2
wh2o_wpl = (1 + ((mu.*rho_v)./rho_d)) .* ((wh2o_rot./1000) + ((Hs_rot.*rho_c)./(rho_a.*Cp.*Ta_K)));
%%% WPL correction for co2 flux (output in kg/m2/s): 
wc_wpl = (wc_rot./1e6) + ((mu.*wh2o_wpl)./rho_d).*(rho_c./(1+mu.*(rho_v./rho_d))) + ( (Hs_rot.*rho_c)./(rho_a.*Cp.*Ta_K) );

%%%%% Convert Fc, CO2_top into umolm-2s-1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert both raw and rotated Fc, and CO2 at the top:
Fc_raw = CO2_convert(master.data(:,find_right_col(master.labels,'cov_Uz_co2(1)')), Ta, APR, 2);
Fc_rot = CO2_convert(wc_rot, Ta, APR, 2);
Fc_rot_wpl = CO2_convert(wc_wpl.*1e6, Ta, APR, 2);

CO2_top = CO2_convert(master.data(:,find_right_col(master.labels,'co2_Avg(1)')), Ta, APR, 4); % from mg/m3 to umol/mol
CO2_cpy = master.data(:,find_right_col(master.labels,'co2stor_Avg')); % already in umol/mol (ppm)

% Convert H2O from g/m3 to mmol/mol if necessary:
H2O_top = H2O_convert(H2O_top, rho_a.*1000, 1, 1);
figure('Name','H2O---Converted to mmol/mol');hold on;
plot(H2O_top);

% % %%%% Plot original, rotation-corrected and rot-corrected+wpl Fc:
% % figure('Tag','Rotation','Name','Rotation, WPL Results');
% % figure(findobj('Tag','Rotation'));clf;
% % subplot(211)
% % plot(Fc_raw,'r'); hold on; plot(Fc_rot,'b'); plot(Fc_rot_wpl,'g')
% % legend('Fc_{raw}', 'Fc_{rot}', 'Fc_{rot+WPL}');
% % subplot(212)
% % plot(CO2_top,'r'); hold on; plot(CO2_cpy,'b');
% % legend('CO2_{top}', 'CO2_{cpy}');


%% First clean, Storage calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Clean data by using flags to signal bad 10-min averages:
% options for cleaning are:
% col 67 (# CSAT warnings), col 68 (# irga warnings) *****
% cols 69-76: flags - doesn't work so well
% col 77: agc value - doesn't work so well
% col 24: cov_Ux_Ux(1) - doesn't work so well
ind = find( master.data(:,67) > 10 | master.data(:,68) > 10 );
% NEE_raw(ind,1) = NaN;
Fc_rot_wpl(ind,1) = NaN;
% LE_rot(ind,1) = NaN;
Hs_rot(ind,1) = NaN;
Htc_rot(ind,1) = NaN;
CO2_top(master.data(:,68) > 10) = NaN;

%%%% Plot original, rotation-corrected and rot-corrected+wpl Fc:
figure('Tag','Rotation','Name','Rotation, WPL Results');
figure(findobj('Tag','Rotation'));clf;
subplot(211)
plot(Fc_raw,'r'); hold on; plot(Fc_rot,'b'); plot(Fc_rot_wpl,'g')
legend('Fc_{raw}', 'Fc_{rot}', 'Fc_{rot+WPL}');
subplot(212)
plot(CO2_top,'r'); hold on; plot(CO2_cpy,'b');
legend('CO2_{top}', 'CO2_{cpy}');

%%% Storage Calculations:
[NEE_raw dcdt Jtfill dcdt_1h dcdt_2h] = OPEC_storage(site, master.data(:,2), Fc_rot_wpl, CO2_top, CO2_cpy, Ta);


%% Initial Spike Cleaning of 10-min Data:
%%% We do this to get rid of any spikes that might exist in the 10-minute
%%% data, so that they are not carried over to 30-minute averages:

%%% Before we do this, we'll have to convert the wh20_wpl over to LE, so we
%%% can run it through the cleaning:
LE_wpl = wh2o_wpl.*lambda(Ta);


if qtflag ==1
%     Fc_wpl_cleaned = NaN.*ones(size(Fc_rot_wpl));
    NEE_wpl_cleaned = NaN.*ones(size(NEE_raw));
    LE_wpl_cleaned = NaN.*ones(size(NEE_raw));
    Hs_cleaned = NaN.*ones(size(NEE_raw));
    Htc_cleaned = NaN.*ones(size(NEE_raw));
    disp('Spike removal skipped.  WIll not save final data.');
else
    %%% Papale Spike Removal:
    % 1. For Fc, NEE:
%     [Fc_wpl_cleaned] = mcm_CPEC_outlier_removal(site, Fc_rot_wpl, 10, 'Fc');
    [NEE_wpl_cleaned] = mcm_CPEC_outlier_removal(site, NEE_raw, 10, 'Fc');
    % 2. For LE:
    [LE_wpl_cleaned] = mcm_CPEC_outlier_removal(site, LE_wpl, 10, 'LE');
    % 3. For Hs, Htc:
    [Hs_cleaned] = mcm_CPEC_outlier_removal(site, Hs_rot, 10, 'H');
    [Htc_cleaned] = mcm_CPEC_outlier_removal(site, Htc_rot, 10, 'H');
end

% %%% Clean rotated values -- we'll need them later for Burba Correction:
% % wh2o_wpl(isnan(LE_cleaned),1) = NaN;
% wh2o_rot(isnan(LE_wpl_cleaned),1) = NaN;
% % wc_wpl(isnan(Fc_wpl_cleaned),1) = NaN;
% wc_rot(isnan(Fc_wpl_cleaned),1) = NaN;


%% MAKING CALC FILE:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Put all of the calculated data into its own matrix:

calc_master.data = [master.data(:,1:6)  w_mean w_std H2O_top APR... % cols 1-10
    Ts Ta Wind_Speed u_std u_star Jtfill CO2_top CO2_cpy dcdt dcdt_1h dcdt_2h Fc_rot_wpl... % cols 11-20
    NEE_wpl_cleaned LE_wpl_cleaned Hs_cleaned Htc_cleaned]; % cols 21-28
calc_master.labels = {'TimeVec'; 'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'w_mean'; 'w_std'; 'H2O_top'; 'Pressure';...
    'Ts'; 'Ta'; 'Wind_Speed'; 'u_std'; 'u_star';'Jtfill'; 'CO2_top'; 'CO2_cpy'; 'dcdt'; 'dcdt_1h'; 'dcdt_2h';'Fc_noBurba'; ...
    'NEE_noBurba'; 'LE_noBurba'; 'Hs_cleaned'; 'Htc_cleaned'};

%%%% Internal variables:
int_master.data = [master.data(:,1:6) rho_a rho_v rho_d rho_c wc_rot wh2o_rot Hs_rot Htc_rot];
int_master.labels = {'TimeVec'; 'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'rho_a'; 'rho_v'; 'rho_d';...
    'rho_c'; 'wc_rot'; 'wh2o_rot'; 'Hs_rot'; 'Htc_rot'};



% calc_master.data = [master.data(:,1:6) ...
%     Fc_rot LE_rot Hs_rot Htc_rot Jtfill CO2_top CO2_cpy dcdt NEE_noBurba LE_noBurba Hs_cleaned Htc_cleaned];
%
%
% calc_master.labels = {'TimeVec'; 'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'Fc_rot'; 'LE_rot'; 'Hs_rot'; ...
%     'Htc_rot'; 'Jtfill'; 'CO2_top'; 'CO2_cpy'; 'dcdt'; 'NEE_noBurba'; 'LE_noBurba'; 'Hs_cleaned'; 'Htc_cleaned'};

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Average Data to 30 minutes -- Use OPEC_HH_mean
%%%%% First, do cleaned data:
cleaned_30min = NaN.*ones(length(master.data(:,1))./3, length(master.labels));
date_ind = (3:3:length(master.data(:,1)))';
cleaned_30min(:,1:6) = master.data(date_ind,1:6);

for i = 7:1:length(master.labels)
    cleaned_30min(:,i) = OPEC_HH_mean(master.data(:,i));
end

%%%%% Second, do calculated data:
calc_30min = NaN.*ones(length(calc_master.data(:,1))./3, length(calc_master.labels));
calc_30min(:,1:6) = calc_master.data(date_ind,1:6);

for i = 7:1:length(calc_master.labels)
    calc_30min(:,i) = OPEC_HH_mean(calc_master.data(:,i));
end

%%%%% Next, do internal data:
int_30min = NaN.*ones(length(int_master.data(:,1))./3, length(int_master.labels));
int_30min(:,1:6) = int_master.data(date_ind,1:6);

for i = 7:1:length(int_master.labels)
    int_30min(:,i) = OPEC_HH_mean(int_master.data(:,i));
end

disp('Data averaged to 30 minutes successfully');

%%% This would be a good time to get rid of the 10-minute data, so we don't
%%% run out of memory on the machine.  This can be modified later, where
%%% the 10-min file can be kept and used later, or perhaps saved to the
%%% appropriate folders, but right now, we're just going to use the 30-min
%%% data.
cleaned_labels_tmp = master.labels;
calc_labels_tmp = calc_master.labels;
int_labels_tmp = int_master.labels;
clear master calc_master int_master Fc_rot LE_rot Hs_rot Htc_rot Jtfill CO2_top
clear CO2_cpy dcdt NEE_wpl_cleaned LE_wpl_cleaned Hs_cleaned Htc_cleaned date_ind

%%% Bring back 'master' and calc_master and int_master, but now as 30-min files:
master.data = cleaned_30min;
master.labels = cleaned_labels_tmp;
calc_master.data = calc_30min;
calc_master.labels = calc_labels_tmp;
int_master.data = int_30min;
int_master.labels = int_labels_tmp;

clear *_tmp cleaned_30min calc_30min int_30min;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Clean #2
%%% Enter manual site-specific fixes to 30-minute data:
%%% This may be desirable to 10-min fixes in some cases where you're trying
%%% to fix a problem that's cropped up in the 30-minute data:
shift_override = [];
switch site
    case 'TP74'
        % Put data at (or close) to UTC -- all pre-2009 data is in EDT/EST
        % Remove a few problems with CSAT data
        master.data([17476:17479 32208:32233 32256:32263 55657:55665 ],find_right_col(master.labels,'wnd_spd(1)')) = NaN;
        master.data([34622:34681],find_right_col(master.labels,'wnd_spd(1)')) = NaN;
        calc_master.data([17476:17479 32208:32233 32256:32263 55657:55665 ],find_right_col(calc_master.labels,'Wind_Speed')) = NaN;
        calc_master.data([34622:34681],find_right_col(calc_master.labels,'Wind_Speed')) = NaN;
        
        % Shift data back 1 data point
        master.data([32034:33042], 7:end) = master.data([32035:33043], 7:end); master.data(32043,7:end) = NaN;
        calc_master.data([32034:33042], 7:end) = calc_master.data([32035:33043], 7:end); calc_master.data(32043,7:end) = NaN;
        int_master.data([32034:33042], 7:end) = int_master.data([32035:33043], 7:end); int_master.data(32043,7:end) = NaN;
        
        % Create a variable (shift_override) that allows us to specify the
        % proper shift for cases where there is a clear problem with the
        % loops (below) that are used to estimate the shift based on
        % comparisons of wind speeds:
        % Each row of data specifies the start and end data points for the
        % sections, and the desired amount of shift.  The start and end
        % data points should match up with what is output in columns 1 and
        % 2 of start_times.
        %        shift_override = [55657 55665 10;];
    case 'TP02'
        master.data([15260:15263 15478:15537 19151:19171],find_right_col(master.labels,'wnd_spd(1)')) = NaN;
        calc_master.data([15260:15263 15478:15537 19151:19171],find_right_col(calc_master.labels,'Wind_Speed')) = NaN;
        
        %%% Here's an unexplained large shift in the data:  What we're
        %%% going to do is move everything backwards 8 data points more
        %%% than we should, preserving the nominal offset between the MET
        %%% (UTC) data and the OPEC (EST/EDT) data.
        master.data((40157-48):(40868-48),7:end) = master.data(40157:40868,7:end);
        master.data(40868-47:40868,7:end) = NaN;
        calc_master.data((40157-48):(40868-48),7:end) = calc_master.data(40157:40868,7:end);
        calc_master.data(40868-47:40868,7:end) = NaN;
        int_master.data((40157-48):(40868-48),7:end) = int_master.data(40157:40868,7:end);
        int_master.data(40868-47:40868,7:end) = NaN;
        %%% Small gap in data that leads to a shift:
        master.data([61121:61220], 7:end) = master.data([61122:61221], 7:end); master.data(61221,7:end) = NaN;
        calc_master.data([61121:61220], 7:end) = calc_master.data([61122:61221], 7:end); calc_master.data(61221,7:end) = NaN;
        int_master.data([61121:61220], 7:end) = int_master.data([61122:61221], 7:end); int_master.data(61221,7:end) = NaN;
        
        
        %         master.data((22589-48):(23300-48),7:end) = master.data(22589:23300,7:end);
        %         master.data(23300-47:23300,7:end) = NaN;
        %         calc_master.data((22589-48):(23300-48),7:end) = calc_master.data(22589:23300,7:end);
        %         calc_master.data(23300-47:23300,7:end) = NaN;
        
    case 'TP89'
        master.data([26240 26384 54818:54841 55432:55473],find_right_col(master.labels,'wnd_spd(1)')) = NaN;
        calc_master.data([26240 26384 54818:54841 55432:55473],find_right_col(calc_master.labels,'Wind_Speed')) = NaN;

end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fix timeshifts in the Flux Data - Do this fix by aligning flux data
%%% with met data (which was aligned to UTC using PAR and modeled suntimes)

%%% Load successive years of met data, we want to keep the following data:
%%% Ta, RH?, WS, WDir and PAR (for figuring out UTC or EST),
min_yr = min(master.data(:,2));
max_yr = max(master.data(:,2));
met.data = [master.data(:,2) NaN.*ones(length(master.data),6)]; % extra column in case something else is desired

for yr = min_yr:1:max_yr
    
    try
        met_tmp = load([met_path site '_met_cleaned_' num2str(yr) '.mat']);
        try met.data(met.data(:,1)== yr,2) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'AirTemp_AbvCnpy'));
        catch; met.data(met.data(:,1)==yr,2) = NaN; disp(['Could not load Ta for year: ' num2str(yr)]); end
        try met.data(met.data(:,1)== yr,3) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'RelHum_AbvCnpy'));
        catch; met.data(met.data(:,1)==yr,3) = NaN; disp(['Could not load RH for year: ' num2str(yr)]); end
        try met.data(met.data(:,1)== yr,4) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'WindSpd'));
        catch; met.data(met.data(:,1)==yr,4) = NaN; disp(['Could not load WS for year: ' num2str(yr)]); end
        try  met.data(met.data(:,1)== yr,5) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'WindDir'));
        catch; met.data(met.data(:,1)==yr,5) = NaN; disp(['Could not load WDir for year: ' num2str(yr)]); end
        try  met.data(met.data(:,1)== yr,6) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'DownPAR_AbvCnpy'));
        catch; met.data(met.data(:,1)==yr,6) = NaN; disp(['Could not load PAR for year: ' num2str(yr)]); end
    catch
        disp(['Could not find data for year: ' num2str(yr) '.']);
        met.data(met.data(:,1)== yr,2:6) = NaN;
    end
end

%%% Use OPEC_find_intervals to establish the starting and ending points for
%%% each measurement period (most likely when times would have been changed):
%%%%%%%%%%%%%%%%%%% Wind Speed:
OPEC_DAT = master.data(:,find_right_col(master.labels,'wnd_spd(1)'));
MET_DAT = met.data(:,4);
%%%%%%%%%%%%%%%%%%% Wind Direction:
% OPEC_DAT = master.data(:,find_right_col(master.labels,'wnd_dir_compass(1)'));
% MET_DAT = met.data(:,5);
%%%%%%%%%%%%%%%%%%% Air Temp:
% OPEC_DAT = master.data(:,find_right_col(master.labels,'t_hmp_Avg(1)'));
% MET_DAT = met.data(:,2);



[start_times] = OPEC_find_intervals(OPEC_DAT, 30, 300);


%%% Compare the OPEC and met-derived windspeed data
num_lags = 16; % The maximum number of shifts to check correlation for is 15 half-hours (8 hours).
% Plot the data before shifting
% close(findobj('Tag','Pre-Shift'));
% figure('Name','Data_Alignment: Pre-Shift','Tag','Pre-Shift');
% figure(findobj('Tag','Pre-Shift'));clf;
% subplot(211);
% plot(MET_DAT,'b');hold on;
% plot(OPEC_DAT,'r');
% legend('Met WSpd', 'OPEC WSpd');
% grid on;

% Prepare blank files to put the shifted data into (will replace the
% existing data files with this data when finished).
[r_master c_master] = size(master.data);
[r_calc c_calc] = size(calc_master.data);
[r_int c_int] = size(int_master.data);

shifted_master = NaN.*ones(r_master, c_master);
shifted_master(:,1:6) = master.data(:,1:6);
shifted_calc   = NaN.*ones(r_calc, c_calc);
shifted_calc(:,1:6) = calc_master.data(:,1:6);
shifted_int   = NaN.*ones(r_int, c_int);
shifted_int(:,1:6) = int_master.data(:,1:6);


%%% Run through each of the measurement periods and try and find the shift
ccorr = []; lags = [];
for j = 1:1:length(start_times)
    clear *_tmp;
    
    MET_DAT_tmp  = MET_DAT(start_times(j,1):start_times(j,2),1);
    OPEC_DAT_tmp = OPEC_DAT(start_times(j,1):start_times(j,2),1);
    
    %       %%% Continuous segment xcorr
    try
        [output(j).seg] = segment_xcorr(MET_DAT_tmp, OPEC_DAT_tmp, num_lags);
        pts_to_shift_seg(j,1) = output(j).seg(output(j).seg(:,3) == max(output(j).seg(:,3)),4);
    catch
        pts_to_shift_seg(j,1) = NaN;
    end
    %%% Moving window x-correlation:
    try
        [output(j).mw] = mov_window_xcorr(MET_DAT_tmp, OPEC_DAT_tmp, num_lags);
        pts_to_shift_mw(j,1) = mode(output(j).mw(:,2));
    catch
        pts_to_shift_mw(j,1) = NaN;
    end
    
    try
        %%% Traditional x-correlation for entire period
        MET_DAT_tmp(isnan(MET_DAT_tmp),1) = 0;
        OPEC_DAT_tmp(isnan(OPEC_DAT_tmp),1) = 0;
        
        
        ind_tmp = find(~isnan(MET_DAT_tmp.*OPEC_DAT_tmp));
        [ccorr_tmp lags_tmp] = xcorr(MET_DAT_tmp(ind_tmp), OPEC_DAT_tmp(ind_tmp), num_lags);
        lags = [lags lags_tmp'];
        ccorr = [ccorr ccorr_tmp];
        ccorr(:,j) = ccorr(:,j)./(max(ccorr(:,j)));
        pts_to_shift(j,1) = lags(ccorr(:,j) == 1,j);
        % % % % %     ccorr(1:num_lags*2+1,j) = ccorr_tmp(1:num_lags*2+1,1);
        % % % % %         lags(1:num_lags*2+1,j) = lags_tmp(1:num_lags*2+1);
    catch
        disp(['Error on loop ' num2str(j) ', data starting at ' num2str(start_times(j,1)) ]);
        pts_to_shift(j,1) = NaN;
        lags = [lags(:,1:j-1) NaN.*ones(num_lags.*2+1,1)];
        ccorr = [ccorr(:,1:j-1) NaN.*ones(num_lags.*2+1,1)];
    end
end


%%% Override shifts if set in Clean #2:
if ~isempty(shift_override)
    for k = 1:1:size(shift_override,1)
        try
            indfirst = find(shift_override(k,1)==start_times(:,1));
            indlast = find(shift_override(k,2)==start_times(:,2));
            if indfirst > 0 && indlast > 0 && indfirst==indlast
                pts_to_shift(indfirst,1) = shift_override(k,3);
                disp(['Overridden shift value for : start time group ' num2str(indfirst)]);
                
            else
                disp(['indexes for first and last shift overrides do not match. Override not completed for override: ' num2str(k)]);
            end
        catch
            disp(['Problem with override. Override not completed for override: ' num2str(k)]);
        end
        clear indfirst indlast
    end
end


%%% Apply shifts and ask the user if they are happy with the results:
add_to_plot = [];
for j = 1:1:length(start_times)
    tmp_add = (start_times(j,1):20:start_times(j,2))';
    add_to_plot = [add_to_plot ; tmp_add j.*ones(length(tmp_add),1)];
    clear tmp_add;
    if isnan(pts_to_shift(j,1)) == 1;
        try
            switch j
                case 1
                    pts_to_shift(1,1) = pts_to_shift(2,1);
                case length(j)
                    pts_to_shift(length(j),1) = pts_to_shift(length(j)-1,1);
                otherwise
                    pts_to_shift(j,1) = ceil(nanmean([pts_to_shift(j-1,1); pts_to_shift(j+1,1)]));
            end
            disp(['Shift for data section ' num2str(j) ' is estimated at ' num2str(pts_to_shift(j,1)) '.']);
        catch
            disp(['Could not estimate a lag time for start_time ' num2str(j) '. Set to zero.']);
        end
    end
    
    % Shift the OPEC data ahead by specified number of points if shift is +
    if pts_to_shift(j,1) > 0
        clear ind_shifted
        ind_shifted = (start_times(j,1)+pts_to_shift(j,1):1:start_times(j,2)+pts_to_shift(j,1));
        shifted_master(ind_shifted,7:c_master) = master.data(start_times(j,1):start_times(j,2),7:c_master);
        shifted_calc(ind_shifted,7:c_calc) = calc_master.data(start_times(j,1):start_times(j,2),7:c_calc);
        shifted_int(ind_shifted,7:c_int) = int_master.data(start_times(j,1):start_times(j,2),7:c_int);
       
        % Shift OPEC data backwards if it is a -'ve shift
    elseif pts_to_shift(j,1) < 0
        clear ind_shifted
        ind_shifted = (start_times(j,1)+pts_to_shift(j,1):1:start_times(j,2)+pts_to_shift(j,1));
        if ~isempty(find(ind_shifted<1, 1)) % fix case where we are shifting beyond the start date:
            ind_shifted = (1:1:start_times(j,2)+pts_to_shift(j,1));
            start_times(j,1) = length(find(ind_shifted<1)) + 1;
        end
        shifted_master(ind_shifted,7:c_master) = master.data(start_times(j,1):start_times(j,2),7:c_master);
        shifted_calc(ind_shifted,7:c_calc) = calc_master.data(start_times(j,1):start_times(j,2),7:c_calc);
        shifted_int(ind_shifted,7:c_int) = int_master.data(start_times(j,1):start_times(j,2),7:c_int);
        
        % If shift = 0, don't touch it.
    elseif pts_to_shift(j,1) == 0
        ind_shifted = (start_times(j,1):1:start_times(j,2));
        shifted_master(ind_shifted,7:c_master) = master.data(start_times(j,1):start_times(j,2),7:c_master);
        shifted_calc(ind_shifted,7:c_calc) = calc_master.data(start_times(j,1):start_times(j,2),7:c_calc);
        shifted_int(ind_shifted,7:c_int) = int_master.data(start_times(j,1):start_times(j,2),7:c_int);
    
    end
    
end

%%% Plot the unshifted and shifted timeseries, along with Met and
%%% OPEC_10min data:
close(findobj('Tag','Pre-Shift'));
figure('Name','Data_Alignment: Pre-Shift','Tag','Pre-Shift');
figure(findobj('Tag','Pre-Shift'));clf;
plot(met.data(:,4),'b');hold on;
plot(master.data(:,find_right_col(master.labels,'wnd_spd(1)')),'Color',[0.8 0.8 0.8]);
plot(shifted_master(:,find_right_col(master.labels,'wnd_spd(1)')),'g');
legend('Met WSpd', 'Orig 10min WSpd',  'Corr 10min WSpd');
grid on;
set(gca, 'XMinorGrid','on');
for ii = 1:1:length(add_to_plot)
    text(add_to_plot(ii,1),6,num2str(add_to_plot(ii,2)),'Color','k')
end
%
% figure(findobj('Tag','Pre-Shift'));
% subplot(212);
% plot(met.data(:,4),'b');hold on;
% plot(master.data(:,find_right_col(master.labels,'wnd_spd(1)')),'r');
% plot(shifted_master(:,find_right_col(master.labels,'wnd_spd(1)')),'g');
% legend('Met WSpd', 'OPEC WSpd', 'Corrected OPEC WSpd');
% grid on;
% for ii = 1:1:length(add_to_plot)
%     text(add_to_plot(ii,1),6,num2str(add_to_plot(ii,2)),'Color','k')
% end

%%% Create output information for the user:
output_data = [(1:1:length(start_times))' start_times pts_to_shift];
disp(output_data);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Overwrite the data in master and calc_master with the shifted data:
master.data = shifted_master;
calc_master.data = shifted_calc;
int_master.data = shifted_int;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Add more data to the calc file - all data that we want to be carried
%%% over to the next step, where this data is combined with data from EdiRe
%%% data:
% w_mean = shifted_master(:,find_right_col(master.labels,'Uz_Avg(1)'));
% w_std  = sqrt(shifted_master(:,find_right_col(master.labels,'cov_Uz_Uz(1)')));
% H2O_top  = shifted_master(:,find_right_col(master.labels,'h2o_Avg(1)'));
% APR  = shifted_master(:,find_right_col(master.labels,'press_Avg(1)'));
% Ts  = shifted_master(:,find_right_col(master.labels,'Ts_Avg(1)'));
% Wind_Speed  = shifted_master(:,find_right_col(master.labels,'wnd_spd(1)'));
% u_std  = sqrt(shifted_master(:,find_right_col(master.labels,'cov_Ux_Ux(1)')));
% u_star  = shifted_master(:,find_right_col(master.labels,'u_star'));
% rho_air = shifted_master(:,find_right_col(master.labels,'rho_a_Avg'));
% % Convert H2O from g/m3 to mmol/mol if necessary:
% H2O_top = H2O_convert(H2O_top, rho_air.*1000, 1, 1);
% figure('Name','H2O---Converted to mmol/mol');hold on;
% plot(H2O_top);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Added April 18, 2011 by JJB: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Calculate the Burba Li-7500 self-heating correction, create new LE and
%%%% Fc variables.
%%%% This is probably a bad place to put this correction, but because of
%%%% the problems with variable alignment, it has to go after alignment is
%%%% done, since we need met data for these corrections:
NEE_noBurba = calc_master.data(:,find_right_col(calc_master.labels,'NEE_noBurba')); 
% tmp_dcdt = calc_master.data(:,find_right_col(calc_master.labels,'dcdt')); 
% Fc_cleaned = tmp_NEE_cleaned - tmp_dcdt;
LE_noBurba = calc_master.data(:,find_right_col(calc_master.labels,'LE_noBurba')); 
% Hs_cleaned = calc_master.data(:,find_right_col(calc_master.labels,'Hs_cleaned')); 
% %%%% Internal variables:
% int_master.data = [master.data(:,1:6) rho_a rho_v rho_d rho_c wc_rot wh2o_rot Hs_rot Htc_rot];
% int_master.labels = {'TimeVec'; 'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'rho_a'; 'rho_v'; 'rho_d';...
%     'rho_c'; 'wc_rot'; 'wh2o_rot'; 'Hs_rot'; 'Htc_rot'};
% internal data:
rho_c = int_master.data(:,find_right_col(int_master.labels,'rho_c')); % all in kg/m3
rho_a = int_master.data(:,find_right_col(int_master.labels,'rho_a')); 
rho_d = int_master.data(:,find_right_col(int_master.labels,'rho_d')); 
rho_v = int_master.data(:,find_right_col(int_master.labels,'rho_v')); 
wc_rot = int_master.data(:,find_right_col(int_master.labels,'wc_rot')); 
wh2o_rot = int_master.data(:,find_right_col(int_master.labels,'wh2o_rot')); 
Hs_rot = int_master.data(:,find_right_col(int_master.labels,'Hs_rot')); 
% data from calculated master:
Ta = calc_master.data(:,find_right_col(calc_master.labels,'Ta')); % in C
Wind_Speed = calc_master.data(:,find_right_col(calc_master.labels,'Wind_Speed'));
APR = calc_master.data(:,find_right_col(calc_master.labels,'Pressure'));
dcdt = calc_master.data(:,find_right_col(calc_master.labels,'dcdt'));
% Load the TP39 met data:
TP39data = [master.data(:,2) NaN.*ones(length(master.data),6)]; % extra column in case something else is desired
for yr = min_yr:1:max_yr
    try
        met_tmp = load([TP39met_path 'TP39_met_cleaned_' num2str(yr) '.mat']);
        try TP39data(TP39data(:,1)== yr,2) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'DownLongwaveRad_AbvCnpy'));
        catch; TP39data(TP39data(:,1)==yr,2) = NaN; disp(['Could not load Ldown for year: ' num2str(yr)]); end
        try TP39data(TP39data(:,1)== yr,3) = met_tmp.master.data(:,find_right_col(met_tmp.master.labels,'DownShortwaveRad'));
        catch; TP39data(TP39data(:,1)==yr,3) = NaN; disp(['Could not load Qdown for year: ' num2str(yr)]); end
    catch
        disp(['Could not find TP39 met data for year: ' num2str(yr) '.']);
        TP39data(TP39data(:,1)== yr,2:6) = NaN;
    end
end

% u = Wind_Speed; u(isnan(u),1) = met.data(isnan(u),4);
% Ta = Ts; Ta(isnan(Ta),1) = met.data(isnan(Ta),2);
u = met.data(:,4); u(isnan(u),1) = Wind_Speed(isnan(u),1);
Ta_K = met.data(:,2)+ZeroK; Ta_K(isnan(Ta_K),1) = Ta(isnan(Ta_K),1)+ZeroK;

L = TP39data(:,2);
Q = TP39data(:,3); Q(Q<0) = 0;

[Hs_corr] = OPEC_Burba_correction(Hs_rot, Ta_K-ZeroK, u, Q, L);

%%% Re-apply the WPL corrections, using the new Hs value:
%%% WPL correction for h2o flux (output in kg/m2/s):
wh2o_wpl_B = (1 + ((mu.*rho_v)./rho_d)) .* ((wh2o_rot./1000) + ((Hs_corr.*rho_c)./(rho_a.*Cp.*Ta_K)));
%%% WPL correction for co2 flux (output in kg/m2/s): 
wc_wpl_B = (wc_rot./1e6) + ((mu.*wh2o_wpl_B)./rho_d).*(rho_c./(1+mu.*(rho_v./rho_d))) + ( (Hs_corr.*rho_c)./(rho_a.*Cp.*Ta_K) );

%%%%% Convert Fc, into umolm-2s-1, LE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fc_rot_wpl_B = CO2_convert(wc_wpl_B.*1e6, Ta, APR, 2); % from kg/m2/s to umol/m2/s
% Add storage to get NEE:
NEE_rot_wpl_B = Fc_rot_wpl_B + dcdt;
% Convert LE:
LE_rot_wpl_B = wh2o_wpl_B.*lambda(Ta);

%%%%%%%%%%% SPIKE REMOVAL FOR NEW VARIABLES:
if qtflag ==1
    NEE_wpl_B_cleaned = NaN.*ones(size(NEE_raw));
    LE_wpl_B_cleaned = NaN.*ones(size(NEE_raw));
    disp('Spike removal skipped.  WIll not save final data.');
else
    %%% Papale Spike Removal:
    % 1. For NEE:
    [NEE_wpl_B_cleaned] = mcm_CPEC_outlier_removal(site, NEE_rot_wpl_B, 30, 'Fc');
    % 2. For LE:
    [LE_wpl_B_cleaned] = mcm_CPEC_outlier_removal(site, LE_rot_wpl_B, 30, 'LE');
end

%% Last Bit: We may have gaps in the Burba-corrected data due to missing LW
%%% or SW data.  We can adjust the rest by a regression with original NEE:
%%% Tests at TP74 shows a slope of ~0.94 with R2 = 0.97, so it's pretty
%%% valid.
figure(99)
ind = find(~isnan(NEE_noBurba.*NEE_wpl_B_cleaned));
plot(NEE_noBurba(ind),NEE_wpl_B_cleaned(ind),'k.')
p = polyfit(NEE_noBurba(ind),NEE_wpl_B_cleaned(ind),1);
B_pred = polyval(p,NEE_noBurba);
rsq = rsquared(NEE_wpl_B_cleaned(ind),B_pred(ind));
hold on; plot(NEE_noBurba(ind),B_pred(ind),'r-','LineWidth',2)
ylabel('Burba-cleaned');
xlabel('Non-Burba-Cleaned');
text(-10,-25,['y = ' num2str(p(1)) 'x + ' num2str(p(2)) ' - R2 = ' num2str(rsq)])
NEE_wpl_B_cleaned(isnan(NEE_wpl_B_cleaned),1) = B_pred(isnan(NEE_wpl_B_cleaned),1);
title('NEE');

%%% No sense to even correct for LE - we can just use cleaned value:

LE_wpl_B_cleaned(isnan(LE_wpl_B_cleaned),1) = LE_noBurba(isnan(LE_wpl_B_cleaned),1);

%%% Plot the differences:
figure('Tag','Burba','Name','Rot+WPL+Burba Results');
figure(findobj('Tag','Burba'));clf;
subplot(211)
plot(NEE_noBurba,'r'); hold on; plot(NEE_wpl_B_cleaned,'b');
legend('NEE_{no Burba}', 'NEE_{Burba}');
subplot(212)
plot(LE_noBurba,'r'); hold on; plot(LE_wpl_B_cleaned,'b');
legend('LE_{no Burba}', 'LE_{Burba}');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update Master calc file with newly calculated Burba-corrected fluxes:
%%% We're just adding them onto the end:

calc_master.data = [calc_master.data(:,1:end) Fc_rot_wpl_B NEE_wpl_B_cleaned LE_wpl_B_cleaned]; 
add_to_labels = {'Fc';'NEE_cleaned';'LE_cleaned'};
for j = 1:1:length(add_to_labels)
   calc_master.labels{length(calc_master.labels)+1,1} = add_to_labels{j,1}; 
end
%     calc_master.labels = {'TimeVec'; 'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'w_mean'; 'w_std'; 'H2O_top'; 'Pressure';...
%     'Ts'; 'Ta'; 'Wind_Speed'; 'u_std'; 'u_star';'Jtfill'; 'CO2_top'; 'CO2_cpy'; 'dcdt'; 'Fc'; ...
%     'NEE_noBurba'; 'LE_noBurba'; 'Hs_cleaned'; 'Htc_cleaned'};


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Save the data to the appropriate folder:

if qtflag==1 || qtflag ==9
else
    save([save_path_cleaned  site '_OPEC_30min_cleaned.mat'], 'master');
    clear master
    master = calc_master;
    save([save_path_calc site '_OPEC_30min_calc.mat'], 'master');
    disp('Master and Calculated Data saved.');
end

end % ##################### END OF FUNCTION ##########################


function [right_col] = find_right_col(label_list,label_in)

%%% Convert character array to cell array if label_list is in that form:
if ischar(label_list)==1
    [r1 c1] = size(label_list);
    for j = 1:1:r1
        tmp = label_list(j,:);
        tmp(tmp == ' ') = '';
        label_list_new{j,1} = tmp;
        clear tmp;
    end
    clear label_list;
    label_list = label_list_new;
    clear label_list_new;
end

%%%% Find the Right Row:
[r c] = size(label_list);
right_col = [];
col_ctr = 1;

while isempty(right_col)==1 && col_ctr <= c
    %     for col_ctr = 3:1:c
    %     try
    right_col = find(strcmp(label_in,label_list(:,col_ctr))==1);
    %     catch
    %     right_col = find(strncmp(label_in,label_list(:,1),length(label_in))==1);
    %     end
    col_ctr = col_ctr+1;
end
end

