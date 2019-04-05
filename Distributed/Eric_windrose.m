load('\\130.113.210.243\fielddata\Matlab\Data\Master_Files\TPD\TPD_data_master.mat');
ind = find(master.data(:,1)>=2012 & master.data(:,1)<=2016);

W_Dir = master.data(ind,51);
[W_Dir_deg] = CSWind2Polar(W_Dir,'deg');
u = master.data(ind,98);
hwr = jjb_wind_rose(W_Dir_deg(~isnan(W_Dir_deg.*u)), u(~isnan(W_Dir_deg.*u)),'percbg', 'None');
set(hwr(1),'FaceColor','None');
% title(['Wind Roses, ' site ', ' num2str(year)])
print('-dpdf', ['D:\Local\TPD_windrose-2012-2016'])
print('-dpng','-r600', ['D:\Local\TPD_windrose-2012-2016'])
