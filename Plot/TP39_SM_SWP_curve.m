load('/1/fielddata/Matlab/Data/Met/Organized2/TP39_trenched/HH_Files/TP39_trenched_HH_2009.mat');
met = load('/1/fielddata/Matlab/Data/Met/Organized2/TP39/HH_Files/TP39_HH_2009.mat');

SM_10a = met.master_30min.data(:,100);
SM_10b = met.master_30min.data(:,105);

SM_Tr = master.data(:,12);
SWP_10_a = master.data(:,16);
SWP_10_b = master.data(:,18);


figure(1);clf
plot(SM_Tr.*100); hold on;
plot(SWP_10_a,'r')

figure(2);clf
plot(SWP_10_a.*100,SM_Tr,'k.')

figure(3);clf
plot(SM_10a,SWP_10_a.*100,'k.')

figure(4);clf
plot(SM_Tr,SWP_10_a.*100,'k.')