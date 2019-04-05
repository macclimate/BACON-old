
load(['D:\Matlab\Data\Met\Organized2\TP39_trenched\HH_Files\TP39_trenched_HH_2009.mat' ])
SWPall = master_30min(1).data(:,16);
SWC = master_30min(1).data(11069:11504,12);
SWP = master_30min(1).data(11069:11504,16).*100;

figure(4);clf;
plot(SWC);
figure(5);clf
plot(SWPall);

figure(6);clf;
plot(SWP,SWC,'.');
xlabel('SWP - kPa');
ylabel('VWC - %');
