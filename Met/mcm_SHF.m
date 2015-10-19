function [] = mcm_SHF(year, site)
% Loads SHF from /Cleaned3 directory.
% Loads met from /Final_filled directory

%%% Kick the user back out if they're trying to run TP_PPT
if strcmp(site,'TP_PPT') == 1
    disp('SHF calculation currently not enabled for this site.');
disp('If data does exist for this site, remove statement at top of mcm_SHF.m.');
return;
end

loadstart = addpath_loadstart;
if ischar(year) == false
    year = num2str(year);
end

%% Output location -- always the same
cleaned_path = ([loadstart 'Matlab/Data/Met/Final_Cleaned/']);

filled_path = ([loadstart 'Matlab/Data/Met/Final_Filled/']);
calc_path = ([loadstart 'Matlab/Data/Met/Calculated4/']);
% SHF_header = jjb_hdr_read([loadstart 'Matlab/Data/Met/Raw1/Docs/' site '_OutputTemplate.csv'],',',3);

%% Load needed variables %%%%%%%%%%%%%%%%%%%%%%%%%
[junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(str2double(year),30);
z = 0.03; %% Soil Heat Flux probes at 3 cm
delta_t = 1800; %% Half hour data

% Site Specific Coefficients and Operations %%%%%%%%%%%%%%%%%%%%%%%%%%
[param]=params(year, site, 'SHF');
theta_w = param(:,1); theta_m = param(:,2); theta_o = param(:,3);


%% Load variables:
cleaned = load([cleaned_path site '/' site '_met_cleaned_' year '.mat']);

if strcmp(site, 'TP39') == 1;
SHF1 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_1');
SHF2 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_2');
SHF3 = NaN.*ones(length(SHF2),1);
SHF4 = NaN.*ones(length(SHF2),1);
elseif strcmp(site, 'TPD') == 1;
  SHF1 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_1');
SHF2 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_2');
SHF3 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_3');
SHF4 = load_from_master(cleaned.master,'SoilHeatFlux_HFT_4');

else
SHF1 = load_from_master(cleaned.master,'SoilHeatFlux_1');
SHF2 = load_from_master(cleaned.master,'SoilHeatFlux_2');    
SHF3 = NaN.*ones(length(SHF2),1);
SHF4 = NaN.*ones(length(SHF2),1);
end

filled = load([filled_path site '/' site '_met_filled_' year '.mat']);

Ts2 = load_from_master(filled.master,'SoilTemp_2cm');     
Ts5 = load_from_master(filled.master,'SoilTemp_5cm');

%% Fill in Gaps for specific years:
% Modified JJB 28-Mar-2012 - Added new Gavg statement, comment rest:
% good_shf1 = find(~isnan(SHF1)==1);
% good_shf2 = find(~isnan(SHF2)==1);
% % try good_shf3 = find(~isnan(SHF3)==1); catch
Gavg = nanmean([SHF1 SHF2 SHF3 SHF4],2); 

% mean_shf = row_nanmean([SHF1 SHF2]);
% %%% Average both SHF if both numbers exist
% [junka junkb common] = intersect(good_shf1, good_shf2);
% clear junk*
% 
% Gavg(1:1:length(dt),1) = NaN;
% Gavg(common,1) = (SHF1(common)+ SHF2(common))./2; % put in average when both are present
% Gavg(isnan(Gavg),1) = SHF1(isnan(Gavg),1);
% Gavg(isnan(Gavg),1) = SHF2(isnan(Gavg),1);


% % Gavg(good_shf1,1) = SHF1(good_shf1);  %% put in good numbers for SHF1
% % Gavg(good_shf2,1) = SHF2(good_shf2);  %% put in good numbers for SHF2


%% Shift soil temperature to calculate dT/dt..
ind_dt(:,1) = 2:length(Ts2);
dTs = Ts2(ind_dt,1) - Ts2(ind_dt-1,1);

%% Calculations
M(1:1:length(dTs)) = NaN;
Cs = 2.*theta_m + 2.5.*theta_o + 4.18.*theta_w;

M = (z.*Cs.*(dTs./delta_t))*1.0e6;        %%%in W^m-2
M = [M(1) ;M(1:end)];

G0 = Gavg + M;

%%%% Simple cleaning:
G0(G0 <-50 | G0 > 200) = NaN;
G0_m1 = G0(2:length(G0));
G0_diff = G0(1:length(G0)-1) - G0_m1;
G0(abs(G0_diff)>75,1) = NaN;

G0(dt<45) = Gavg(dt<45); % Put this in here to avoid noise early on in year.

%%% Fill small gaps
G0 = jjb_interp_gap(G0,dt,3);

% save ([met_calc_path 'Ts.dat'],'Ts','-ASCII');
% save ([calc_path site '/' site '_' year '_soil_Hstor.dat'],'M','-ASCII');
% save ([calc_path site '/' site '_' year '_SHF.dat'],'G0','-ASCII');
% Extensions changed Feb 11, 2010.
master.data = [M G0];
master.labels = {'soil_Hstor'; 'SoilHeatFlux'};
jjb_check_dirs([calc_path site '/'],0);
save   ([calc_path site '/' site '_SHF_master_' year '.mat'],'master');
% save ([calc_path site '/' site '_' year '.soil_Hstor'],'M','-ASCII');
% save ([calc_path site '/' site '_' year '.SHF'],'G0','-ASCII');

figure();clf
h1 = plot(dt,G0,'b');
hold on;
h2 = plot(dt,Gavg,'g--');
h3 = plot(dt,Ts2,'r');
ylabel('Soil Heat Flux (Wm_2); Soil Temperature (^oC)')
xlabel('Day of Year')
legend([h1 h2 h3], 'Corrected SHF', 'original (SHF plate)','Ts2')
axis ([0 365 min(G0) max(G0)]);
disp('mcm_SHF done!');
% print('-dill',[fig_path 'SoilHeatFlux']);
% print('-dtiff',[fig_path 'SoilHeatFlux']);
