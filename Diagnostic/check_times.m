%% Check for timing between CPEC system, OPEC system, and met data:

%% TEST BETWEEN CPEC AND MET FOR 2007 AT MET 1:
year = '2007';


load_path_cpec = 'C:\HOME\MATLAB\Data\Flux\CPEC\Met1\HH_fluxes\';
met_path = (['C:\HOME\MATLAB\Data\Met\Cleaned3\Met1\Met1_' year '.']);



T_Csat = load([load_path_cpec 'T_Csat07.dat']);
T_HMP = load([met_path '007']);

figure(1)
clf;
plot(T_Csat,'b.-');
hold on;
plot(T_HMP,'r.-');

%% TEST BETWEEN OPEC AND MET FOR 2006:
clear year;
year = '2006';
site = '2';
%%% Master Flux and Met
load_path_master = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Met' site '\Column\Met' site '_' year '.']);
hdr_path_master = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Docs\Met' site '_FluxColumns.csv']);
%%% Processed Met
load_path_metproc = (['C:\Home\Matlab\Data\Met\Organized2\Met' site '\Column\30min\Met' site '_' year '.']);
hdr_path_metproc = (['C:\Home\Matlab\Data\Met\Raw1\Docs\Met' site '_OutputTemplate.csv']);


%%% Tracker for Master Flux and Master Met Files
[hdr_cell_flux]  = jjb_hdr_read(hdr_path_master,',',2);
%%% Tracker for Processed Met Files
[hdr_cell_metproc] = jjb_hdr_read(hdr_path_metproc,',',3);

Tair_OPEC = jjb_load_var(hdr_cell_flux, load_path_master, 'AirTemp_AbvCnpy');
T_HMP = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'AirTemp_AbvCnpy');

figure(2)
clf;
plot(Tair_OPEC,'b.-')
hold on;
plot(T_HMP,'r.-')

%% Compare Processed OPEC data with Processed Met data (both processed from) raw %% 
clear year;
year = '2005';

load_path_metproc = (['C:\Home\Matlab\Data\Met\Organized2\Met' site '\Column\30min\Met' site '_' year '.']);
hdr_path_metproc = (['C:\Home\Matlab\Data\Met\Raw1\Docs\Met' site '_OutputTemplate.csv']);

hdr_path_opec = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Docs\OPEC_header.csv']);
load_path_opec = (['C:\HOME\MATLAB\Data\Flux\OPEC\Cleaned3\Met' site '\Column\Met' site '_HHdata_' year '.']);

%%% Tracker for Processed OPEC files
[hdr_cell_opec]  = jjb_hdr_read(hdr_path_opec,',',2);

% OPEC outputs
T_HMP_OPEC = jjb_load_var(hdr_cell_opec, load_path_opec, 't_hmp_Avg');
T_CSAT = jjb_load_var(hdr_cell_opec, load_path_opec, 'Ts_Avg');
T_fw = jjb_load_var(hdr_cell_opec, load_path_opec, 'fw_Avg');

% Met Outputs

T_HMP = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'AirTemp_AbvCnpy');
PAR = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownPAR_AbvCnpy');

figure(3)
clf;
plot(T_HMP_OPEC,'b.-')
hold on
plot(T_CSAT,'r.-')
plot(T_fw,'g.-')
plot(T_HMP,'k.-')
plot(PAR/100,'m')
