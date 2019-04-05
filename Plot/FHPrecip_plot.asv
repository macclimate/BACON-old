%% This file loads Precipitation data from the TP Fish Hatchery site and
%% plots them for inspection:
% 1	TimeVector
% 2	Year
% 3	JD
% 4	HHMM
% 5	BatteryVoltage
% 6	ProgSig
% 7	PanelTemp
% 8	WindSpd_AVG
% 9	WindSpd_MAX
% 10	WindSpd_MIN
% 11	WindSpd_SD
% 12	WindDir
% 13	TX_Rain
% 14	Pre_AVG
% 15	Post_AVG
% 16	Post_MAX
% 17	Post_MIN
% 18	Post_SD
% 19	GN_Precip
% 20	BatteryVoltage_1440
% 21	PanelTemp_1440
% 22	ProgramSig_1440

%% 2007 data

[junk(:,1) junk(:,2) junk(:,3) dt_2007]  = jjb_makedate(str2double('2007'),30);
clear junk
% Load data:
FH2007 = load('C:\HOME\MATLAB\Data\Met\Organized2\FHPrecip\Master\metFHmaster2007.dat');

%%% Look at Rain:
figure(1)
plot(dt_2007,FH2007(:,13),'r.-')
hold on; 
plot(dt_2007,FH2007(:,19),'b.-')
legend('Tx','Geonor',4)






%% 2008 data

[junk(:,1) junk(:,2) junk(:,3) dt_2008]  = jjb_makedate(str2double('2008'),30);
clear junk
% Load data:
FH2008 = load('C:\HOME\MATLAB\Data\Met\Organized2\FHPrecip\Master\metFHmaster2008.dat');
figure(2)
plot(dt_2008,FH2008(:,13),'r.-')
hold on; 
plot(dt_2008,FH2008(:,19),'b.-')
legend('Tx','Geonor',4)

figure(3)
plot(dt_2008,FH2008(:,5),'r.-')

figure(4)
plot(dt_2008,FH2008(:,16),'r.-')
hold on
plot(dt_2008,FH2008(:,17),'b.-')
plot(dt_2008,FH2008(:,15),'g.-')

TXcum = FH2008(dt_2008>=7.9 & dt_2008 <= 8.3,13);
TXcumsum = sum(TXcum)