

TP74_sapflow_path = '/1/fielddata/Matlab/Data/Met/Calculated4/TP74_sapflow/';
TP39_sapflow_path = '/1/fielddata/Matlab/Data/Met/Calculated4/TP39_sapflow/';
TP74_met_path = '/1/fielddata/Matlab/Data/Master_Files/TP74/';
TP39_met_path = '/1/fielddata/Matlab/Data/Master_Files/TP39/';

% Load sapflow data:
TP74_2011sf = load([TP74_sapflow_path 'TP74_sapflow_calculated_2011.mat']);
TP39_2009sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2009.mat']);
TP39_2010sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2010.mat']);
TP39_2011sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2011.mat']);

% Load met data: 
TP74_2011met = load([TP74_met_path 'TP74_data_master_2011.mat']);
TP39_2009met = load([TP39_met_path 'TP39_data_master_2009.mat']);
TP39_2010met = load([TP39_met_path 'TP39_data_master_2010.mat']);
TP39_2011met = load([TP39_met_path 'TP39_data_master_2011.mat']);

% Plot some Js values from TP74 for 2011:
figure(2);clf;
plot(TP74_2011sf.master.data(:,33:38)); hold on;
plot(TP74_2011met.master.data(:,107)./1000,'k--');

% Same for TP39:
figure(3);clf;
plot(TP39_2011sf.master.data(:,47:52)); hold on;
plot(TP39_2011met.master.data(:,131)./1000,'k--');