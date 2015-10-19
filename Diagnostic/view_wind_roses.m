                    
TP02 = load('/1/fielddata/Matlab/Data/Master_Files/TP02/TP02_data_master.mat');

WDir_2009 = TP02.master.data(TP02.master.data(:,1)==2009, 49);
u = TP02.master.data(TP02.master.data(:,1)==2009, 79);
%%% Convert wind data to polar direction coordinates
[WDir_rad] = CSWind2Polar(WDir_2009,'rad');
[WDir_deg] = CSWind2Polar(WDir_2009,'deg');

figure('Name','TP02, 2009');clf;
hwr = jjb_wind_rose(WDir_deg(~isnan(WDir_deg.*u)), u(~isnan(WDir_deg.*u)),'percbg', 'None');
set(hwr(1),'FaceColor','None');

TP39 = load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master.mat');
WDir_2009 = TP39.master.data(TP39.master.data(:,1)==2009, 61);
u = TP39.master.data(TP39.master.data(:,1)==2009, 113);
%%% Convert wind data to polar direction coordinates
[WDir_rad] = CSWind2Polar(WDir_2009,'rad');
[WDir_deg] = CSWind2Polar(WDir_2009,'deg');

figure('Name','TP39, 2009');clf;
hwr = jjb_wind_rose(WDir_deg(~isnan(WDir_deg.*u)), u(~isnan(WDir_deg.*u)),'percbg', 'None');
set(hwr(1),'FaceColor','None');
