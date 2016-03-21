load('/1/fielddata/Matlab/Data/Master_Files/TP02/TP02_data_master.mat');

year= master.data(:,1);
TP02_2014 = master.data(year==2014,40);
TP02_2013 = master.data(year==2013,40);
TP02_2011 = master.data(year==2011,40);


figure(1);clf;
plot(TP02_2011,'k'); hold on;
plot(TP02_2013,'r')
plot(TP02_2014,'b')

a = sort(TP02_2013(10000:11500),'descend');
b = sort(TP02_2014(10000:11500),'descend');

tmp_2014 = TP02_2014;
tmp_2014(10000:11500)=tmp_2014(10000:11500)./0.85;
num = 200;
amean=nanmean(a(1:num))
bmean=nanmean(b(634+1:634+num))
rat = bmean/amean
figure(1);
plot(tmp_2014,'g');

%% TPD, 2014
load('/1/fielddata/Matlab/Data/Master_Files/TPD/TPD_data_master.mat');
year= master.data(:,1);

wdir = master.data(year==2014,51);
ws = master.data(year==2014,50);
% Load fixed CPEC data:
CPEC = load('/1/fielddata/Matlab/Data/Flux/CPEC/TPD/Final_Cleaned/TPD_CPEC_cleaned_2014.mat');
year2 = CPEC.master.data(:,1);
u = CPEC.master.data(:,19);v = CPEC.master.data(:,20);
WS_CPEC = sqrt(u.^2 + v.^2);
figure(1);clf;
plot(ws,'b'); hold on; plot(WS_CPEC,'r');
p = polyfit(ws(~isnan(ws.*WS_CPEC)),WS_CPEC(~isnan(ws.*WS_CPEC)),1);
WDIR_CPEC = rad2deg(atan2(u,v))+180;
figure(1);clf;
plot(wdir,'b'); hold on; plot(WDIR_CPEC,'r');

