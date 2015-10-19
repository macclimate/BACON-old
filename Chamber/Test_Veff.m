Stats_all=[];
load d:\met-data\hhour\080218.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080219.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080220.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080221.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080222.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080223.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];

load d:\met-data\hhour\080310.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080311.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080312.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];

load d:\met-data\hhour\080318.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080319.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080320.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080321.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080322.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080323.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080324.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080325.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080326.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080327.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080328.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080329.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080330.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];
load d:\met-data\hhour\080331.acs_flux_CR16.mat;Stats_all=[Stats_all HHour];


dcdt=[];
for s=1:10;
    dcdt(:,s)=get_stats_field(Stats_all,sprintf('Chamber(1).Sample(%d).dcdt',s));
end;
rmse=[];
for s=1:10;
    rmse(:,s)=get_stats_field(Stats_all,sprintf('Chamber(1).Sample(%d).rmse',s));
end;
tv=get_stats_field(Stats_all,'TimeVector');
dcdt=dcdt';dcdt=dcdt(:);
rmse=rmse';rmse=rmse(:);
Vc=(0.145+0.01)*(0.528/2)^2*pi*1000+32
Ve = (1-41.1/43.6)*Vc
V=0.23*(0.153/2)^2*pi*1000
V/Ve
figure(1)
plot([dcdt rmse ])
zoom on
legend('dcdt','rmse')