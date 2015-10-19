function [] = mcm_SHF(year, site)
%% mcm_SHF.m
% This program calculates soil surface heat flux (G0) from soil heat plates
% at 3cm (G3) and storage (M) between 0-3 cm 
% according to formula: G0 = G3 + M
% where M is the rate of change of heat stored in the top 3 cm
% layer per unit area and M = z*Cs*delta_T/delta_t. z is the thickness
% of layer above the flux plate (0.03m), Cs is the volumetric heat capacity 
% of the soil (J m^-3 K^-1) and delta_T/delta_t is the rate of change of 
% tht average temperature of teh top 3 cm (K s^-1). C can be calculated:
% C = 2.00*theta_m + 2.50*theta_o + 4.18*theta_w
% where theta_m, theta_o, theta_w are volume fractions of mineral soil, 
% organic matter and water respectively.
%
% This function works for all data collected from all sites and years
% 2006-- Present.
%
% Inputs: year (scalar), and site (string - e.g. 'TP39');
% usage: metSHF_manual(year, site)
% 
% Created: Mar 2008 by JJB.
 
% Revision History:
%
%

loadstart = addpath_loadstart;
%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
elseif nargin == 2
    if numel(year) == 1 || ischar(year)
        if ischar(year)
            year = str2double(year);
        end
        year_start = year;
        year_end = year;
    end
end

if isempty(year)==1
    year_start = input('Enter start year: > ');
    year_end = input('Enter end year: > ');
end
%%%%%%%%%%%%%%%%%
%%% Check if site is entered as string -- if not, convert it.
if ischar(site) == false
    site = num2str(site);
end

%% Main Loop

for year_ctr = year_start:1:year_end
close all
yr_str = num2str(year_ctr);
disp(['Working on year ' yr_str '.']);

%% Output location -- always the same
SHF_load_path = ([loadstart 'Matlab/Data/Met/Cleaned3/' site '/' site '_' yr_str '.']);

% met_load_path = ([loadstart 'Matlab/Data/Met/Final_Filled/' site '/' site '_' yr_str '.']);
met_load_path = ([loadstart 'Matlab/Data/Met/Final_Filled/' site '/' site '_met_filled_' yr_str '.mat']);

met_calc_path = ([loadstart 'Matlab/Data/Met/Calculated4/' site '/' site '_' yr_str '_']);
SHF_header = jjb_hdr_read([loadstart 'Matlab/Data/Met/Raw1/Docs/' site '_OutputTemplate.csv'],',',3);

%% Load needed variables %%%%%%%%%%%%%%%%%%%%%%%%%
[junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(year_ctr,30);
z = 0.03; %% Soil Heat Flux probes at 3 cm
delta_t = 1800; %% Half hour data

% Site Specific Coefficients and Operations %%%%%%%%%%%%%%%%%%%%%%%%%%
[param]=params(yr_str, site, 'SHF');
theta_w = param(:,1); theta_m = param(:,2); theta_o = param(:,3);


%% Load variables:

if strcmp(site, 'TP39') == 1;
SHF1 = jjb_load_var(SHF_header, SHF_load_path, 'SoilHeatFlux_HFT_1',2);
SHF2 = jjb_load_var(SHF_header, SHF_load_path, 'SoilHeatFlux_HFT_2',2);
else
SHF1 = jjb_load_var(SHF_header, SHF_load_path, 'SoilHeatFlux_1',2);
SHF2 = jjb_load_var(SHF_header, SHF_load_path, 'SoilHeatFlux_2',2);
end
% Ts2 = load([met_load_path 'Ts2']);     Ts5 = load([met_load_path 'Ts5']);

filled = load(met_load_path);
Ts2 = load_from_master(filled.master,'SoilTemp_2cm');
Ts5 = load_from_master(filled.master,'SoilTemp_5cm');
clear filled;

%% Fill in Gaps for specific years:
good_shf1 = find(~isnan(SHF1)==1);
good_shf2 = find(~isnan(SHF2)==1);
%%% Average both SHF if both numbers exist
[junka junkb common] = intersect(good_shf1, good_shf2);

Gavg(1:1:length(dt),1) = NaN;
Gavg(good_shf1,1) = SHF1(good_shf1);  %% put in good numbers for SHF1
Gavg(good_shf2,1) = SHF2(good_shf2);  %% put in good numbers for SHF2
Gavg(common,1) = (SHF1(common)+ SHF2(common))./2; % put in average when both are present

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

%%% Fill small gaps
G0 = jjb_interp_gap(G0,dt,3);

% save ([met_calc_path 'Ts.dat'],'Ts','-ASCII');
save ([met_calc_path 'soil_Hstor.dat'],'M','-ASCII');
save ([met_calc_path 'g0.dat'],'G0','-ASCII');

figure (1)
clf;
h1 = plot(dt,G0,'b');
hold on;
h2 = plot(dt,Ts2,'r');
ylabel('Soil Heat Flux (Wm_2); Soil Temperature (^oC)')
xlabel('Day of Year')
legend([h1 h2], 'g0', 'Ts2')
axis ([0 365 min(G0) max(G0)]);
junk = input('Press Enter to Continue to Next Year');
end
mcm_start_mgmt;
% print('-dill',[fig_path 'SoilHeatFlux']);
% print('-dtiff',[fig_path 'SoilHeatFlux']);
