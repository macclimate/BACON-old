%%% Load TP02 Master file: 

ls = addpath_loadstart; 

load([ls '/Matlab/Data/Master_Files/TP02/TP02_data_master.mat']);

% Load PAR Down
Year = master.data(:,1);
PARDn = master.data(:,39);

PARDn_2017_sort = sort(PARDn(Year==2017),'descend');
PARDn_2017_sort = PARDn_2017_sort(~isnan(PARDn_2017_sort ));
PARDn_2018_sort = sort(PARDn(Year==2018),'descend');
PARDn_2018_sort = PARDn_2018_sort(~isnan(PARDn_2018_sort ));

% PARDn_2019 = PARDn(Year==2019);


% linear relationship between 2017 and 2018 data: 
figure(1);
plot(PARDn_2017_sort(1:10000),PARDn_2018_sort(1:10000),'.');
p_2018 = polyfit(PARDn_2017_sort(1:10000),PARDn_2018_sort(1:10000),1);

pcf_2018 = 1/p_2018(1); % = 0.585666951857723
% 2018 correction factors
par_correction_factor = [2002, 1.23; 2013, 1.38199647061725; 2014, 1.26172364359607; 2015,1.03313933608525; 2016,0.874165785537350; 2017,0.659991285147933];
