clear all
close all
clc;
%
%% Load files - This part i've always loaded in the organized csv data file
%% that I've created.  This part needs to be updated to whatever form of
%% data file is now available.

%load 'c:\MacKay\matlab_masters\tv_sf.dat'
load 'C:\MacKay\Masters\Organized Data\sapflow_09.csv';
%path = 'c:\MacKay\matlab_masters\sapflow_2006.dat'; % TV purposes only
%(Josh - OLD)
sapflow_matrix(1:17520,1:128) = NaN;
sapflow_matrix(1:length(sapflow_09),1:128) = sapflow_09;
sapflow = sapflow_matrix;
load decdoy_00.txt;
%% Time Variables - created

tv = decdoy_00(1:length(sapflow(:,1)));
time = tv;
julian = sapflow(:,2);%Create vector of julian days
hourmin = sapflow(:,3);

%% From Josh's script... not 100% sure what it does... I know, i know... bad
%% bad bad...
jul_vec = [1:((length(sapflow_matrix))/48)];
jul_vec = jul_vec';
dy = sapflow(:,2);
[dytime, dyavg, dysum, dymax, dymin, dystd, dyn] = dailystats_new(tv, dy, 500, 0);

%% The first basic step of cleaning - get rid of the crap - also create
%% zero'd data

% Zero'd data
sapflow_zero = sapflow;
ind = find(sapflow_zero(:,1:117) == -6999);%take out error values from all data and set to NaN
sapflow_zero(ind) = [NaN];

%Actual Data
ind = find(sapflow(:,1:117) == -6999);%take out error values from all data and set to NaN
sapflow(ind) = [NaN];

% Some constants needed for later.
days = 1;

dw = 1000; % Density of water (kg/m^3)

BA = 0.0037; % Basal area (m^2/m^2) or 37.0 (m^2/ha)

[YYYY, JD, HHMM, dt] = jjb_makedate(2009, 30);


%%  This is where stuff get's tricky...  These values have to be entered in
%%  about each tree for each year.  Not sure how to make this matlab
%%  compatible.
% Tree	D(cm)	r(cm)	wa(cm^2)	sw(cm^2)	wa(m^2)	    sw(m^2)
% 1	    36.4	18.2	1040.620272	242.7910246	0.104062027	0.024279102
% 2	    26.2	13.1	539.1282599	116.8006615	0.053912826	0.011680066
% 3	    37	    18.5	1075.209178	251.7872448	0.107520918	0.025178724
% 4	    47.3	23.65	1757.161973	434.9041895	0.175716197	0.043490419
% 5	    41.45	20.73	1350.044581	324.1878309	0.135004458	0.032418783

% 6	    43.4	21.7	1479.343315	359.1097965	0.147934332	0.03591098
% 7	    37.5	18.75	1104.465234	259.4219933	0.110446523	0.025942199
% 8	    33.5	16.75	881.4123444	201.8330682	0.088141234	0.020183307
% 9	    30.9	15.45	749.905387	168.6208246	0.074990539	0.016862082
% 10	40	    20	    1256.636	299.4897156	0.1256636	0.029948972

% 11	31.5	15.75	779.3106694	175.9940215	0.077931067	0.017599402
% 12	37.7	18.75	1104.465234	262.5110865	0.110446523	0.026251109
% 13	54.4	27.2	2324.273946	593.6895438	0.232427395	0.059368954
% 14	44.7	22.35	1569.294891	383.4881696	0.156929489	0.038348817
% 15	36.25	18.13	1032.630894	240.5701041	0.103263089	0.02405701

% 16	43.7	21.85	1499.865752	364.6573727	0.149986575	0.036465737
% 17	45.8	22.54	1596.089826	404.8066548	0.159608983	0.040480665
% 18	35.5	17.75	989.7971994	229.6337857	0.09897972	0.022963379
% 19	38.7	19.35	1176.281982	278.2592372	0.117628198	0.027825924
% 20	37.1	18.55	1081.028973	253.3041512	0.108102897	0.025330415

% 22	28	    14	    615.75164	135.4138518	0.061575164	0.013541385
% 23	40.4	20.2	1281.894384	306.1954259	0.128189438	0.030619543

%% (Manual) sapwood area of tree at 1.3m above ground (m^2): As = 0.0815*DBH^2.2254
sw1 = 0.024279102;
sw2 = 0.011680066;
sw3 = 0.025178724;
sw4 = 0.043490419;
sw5 = 0.032418783;

sw6 = 0.03591098;
sw7 = 0.025942199;
sw8 = 0.020183307;
sw9 = 0.016862082;
sw10 = 0.029948972;
sw22 = 0.013541385;
sw23 = 0.030619543;

sw11 = 0.017599402;
sw12 = 0.026251109;
sw13 = 0.059368954;
sw14 = 0.038348817;
sw15 = 0.02405701;

sw16 = 0.036465737;
sw17 = 0.040480665;
sw18 = 0.022963379;
sw19 = 0.027825924;
sw20 = 0.025330415;

%% (Manual) Total wood area of tree at 1.3m above ground (m^2) 
w1 = 0.104062027;
w2 = 0.053912826;
w3 = 0.107520918;
w4 = 0.175716197;
w5 = 0.135004458;

w6 = 0.147934332;
w7 = 0.110446523;
w8 = 0.088141234;
w9 = 0.074990539;
w10 = 0.1256636;
w22 = 0.061575164;
w23 = 0.128189438;

w11 = 0.077931067;
w12 = 0.110446523;
w13 = 0.232427395;
w14 = 0.156929489;
w15 = 0.103263089;

w16 = 0.149986575;
w17 = 0.159608983;
w18 = 0.09897972;
w19 = 0.117628198;
w20 = 0.108102897;



%%  Now we're getting into the data again (yea, not the most organized
%%  script in the world...).  Okay, this part here is the dT data.  Just
%%  calling it at this point.

dt1(1:17520) = sapflow(:,6);
dt2(1:17520) = sapflow(:,7);
dt3(1:17520) = sapflow(:,8);
dt4(1:17520) = sapflow(:,9);
dt5(1:17520) = sapflow(:,10); 

dt6(1:17520) = sapflow(:,11);
dt7(1:17520) = sapflow(:,12);
dt8(1:17520) = sapflow(:,13);
dt8_uncorrected = dt8;
dt9(1:17520) = sapflow(:,14);
dt10(1:17520) = sapflow(:,15);
dt22(1:17520) = sapflow(:,27); 
dt23(1:17520) = sapflow(:,28);

dt11(1:17520) = sapflow(:,16);
dt12(1:17520) = sapflow(:,17);
dt13(1:17520) = sapflow(:,18);
dt14(1:17520) = sapflow(:,19);
dt15(1:17520) = sapflow(:,20); 

dt16(1:17520) = sapflow(:,21);
dt17(1:17520) = sapflow(:,22);
dt18(1:17520) = sapflow(:,23);
dt19(1:17520) = sapflow(:,24);
dt20(1:17520) = sapflow(:,25);

dt21(1:17520) = sapflow(:,26);
dt24(1:17520) = sapflow(:,29);

%% Basic clean of the dt data - thresholds
dt1(find(dt1<0.3 | dt1>0.8)) = NaN;
dt2(find(dt2<0.2 | dt2>0.9)) = NaN;
dt3(find(dt3<0.3 | dt3>0.8)) = NaN;
dt4(find(dt4<0.3 | dt4>0.8)) = NaN;
dt5(find(dt5<0.33 | dt5>0.8)) = NaN;

dt6(find(dt6<0.2 | dt6>0.8)) = NaN;
dt7(find(dt7<0.17 | dt7>0.7)) = NaN;
dt8(find(dt8<0.2 | dt8>0.9)) = NaN;
dt9(find(dt9<0.3 | dt9>0.8)) = NaN;
dt10(find(dt10<0.3 | dt10>0.8)) = NaN;

dt11(find(dt11<0.2 | dt11>0.8)) = NaN;
dt12(find(dt12<0.2 | dt12>0.69)) = NaN;
dt13(find(dt13<0.3 | dt13>0.8)) = NaN;
dt14(find(dt14<0.2 | dt14>0.8)) = NaN;
dt15(find(dt15<0.2 | dt15>0.8)) = NaN;

dt16(find(dt16<0.2 | dt16>0.8)) = NaN;
dt17(find(dt17<0.2 | dt17>0.8)) = NaN;
dt18(find(dt18<0.2 | dt18>0.8)) = NaN;
dt19(find(dt19<0.2 | dt19>0.8)) = NaN;
dt20(find(dt20<0.2 | dt20>0.8)) = NaN;

dt21(find(dt21<0.2 | dt21>0.8)) = NaN;
dt22(find(dt22<0.2 | dt22>0.8)) = NaN;
dt23(find(dt23<0.2 | dt23>0.8)) = NaN;
dt23(1:6380) = NaN;
dt24(find(dt24<0.2 | dt24>0.8)) = NaN;


%% ????
dt1_uncorrected = dt1.*25;

%%  Self-cleaning - days that were no good and I knew it (data logger
%%  kicked the bucket, or the volt regulator went kaput)
dt1(11065:11115) = NaN;
dt1(13835:13846) = NaN;
dt1(14949:14950) = NaN;
dt1(16472:16475) = NaN;
dt1(4805:4806) = NaN;
dt1(10559:10600) = NaN;
dt1(2815:3051)=NaN;

dt2(11065:11115) = NaN;
dt2(14955:14957) = NaN;
dt2(4805:4807)=NaN;
dt2(8562:8563) = NaN;
dt2(9917:9919) = NaN;
dt2(13839:13846)=NaN;
dt2(10560:10595)=NaN;
dt2(14949:14950)=NaN;
dt2(16473:16474)=NaN;


dt3(11065:11115) = NaN;
dt3(10560:10595)=NaN;
dt3(4805:4807)=NaN;
dt3(8562:8564)=NaN;
dt3(13838:13840)=NaN;
dt3(14949:14950)=NaN;
dt3(16472:16474)=NaN;
dt3(17405:17520)=NaN;

dt4(11065:11115) = NaN;
dt4(10560:10595)=NaN;
dt4(4805:4807)=NaN;
dt4(8562:8564)=NaN;
dt4(13838:13840)=NaN;
dt4(14949:14950)=NaN;
dt4(16473:16474)=NaN;
dt4(3084:3107)=NaN;
dt4(2814:2816)=NaN;


dt5(11065:11115) = NaN;
dt5(10560:10595)=NaN;
dt5(4805:4807)=NaN;
dt5(8562:8564)=NaN;
dt5(13838:13840)=NaN;
dt5(14949:14950)=NaN;
dt5(16473:16474)=NaN;

dt6(11065:11115) = NaN;
dt6(14956:14957) = NaN;
dt6(10560:10595)=NaN;
dt6(4805:4807)=NaN;
dt6(8562:8564)=NaN;
dt6(13838:13846)=NaN;
dt6(14949:14950)=NaN;
dt6(16473:16474)=NaN;
dt6(6369:6371) = NaN;
dt6(17405:17520) = NaN;
dt6(4110:4132) = NaN;


dt7(11065:11115) = NaN;
dt7(14956:14957) = NaN;
dt7(10560:10595)=NaN;
dt7(4805:4807)=NaN;
dt7(8562:8564)=NaN;
dt7(13838:13846)=NaN;
dt7(14949:14950)=NaN;
dt7(16473:16474)=NaN;
%dt7(1:4146) = NaN;
dt7(6369:6373)=NaN;
dt7(9917:9919)=NaN;


dt8(11065:11115) = NaN;
dt8(10560:10595)=NaN;
dt8(4805:4807)=NaN;
dt8(8562:8564)=NaN;
dt8(13838:13840)=NaN;
dt8(14949:14950)=NaN;
dt8(16473:16474)=NaN;
dt8(9917:9919)=NaN;
dt8(13844:13875)=NaN;

dt9(11065:11115) = NaN;
dt9(4805:4807)=NaN;
dt9(8562:8564)=NaN;
dt9(13838:13840)=NaN;
dt9(14949:14950)=NaN;
dt9(16473:16474)=NaN;
dt9(10556:10593)=NaN;

dt10(11065:11115) = NaN;
dt10(4805:4807)=NaN;
dt10(8562:8564)=NaN;
dt10(13838:13840)=NaN;
dt10(14949:14950)=NaN;
dt10(16473:16474)=NaN;
dt10(10556:10593)=NaN;

dt11(11065:11115) = NaN;
dt11(14956:14957) = NaN;
dt11(10560:10595)=NaN;
dt11(4805:4807)=NaN;
dt11(8562:8564)=NaN;
dt11(13838:13840)=NaN;
dt11(14949:14950)=NaN;
dt11(16473:16474)=NaN;
dt11(13845:13846)=NaN;
dt11(9917:9919)=NaN;


dt12(11065:11115) = NaN;
dt12(14956:14957) = NaN;
dt12(10560:10595)=NaN;
dt12(4805:4807)=NaN;
dt12(8562:8564)=NaN;
dt12(13838:13840)=NaN;
dt12(14949:14950)=NaN;
dt12(16473:16474)=NaN;
dt12(13845:13846)=NaN;
dt12(9917:9919)=NaN;
dt12(2772:3055)=NaN;

dt13(11065:11115) = NaN;
dt13(10560:10595)=NaN;
dt13(4805:4807)=NaN;
dt13(8562:8564)=NaN;
dt13(13838:13840)=NaN;
dt13(14949:14950)=NaN;
dt13(16473:16474)=NaN;
dt13(13845:13846)=NaN;
dt13(9917:9919)=NaN;
dt13(11376)=NaN;
dt13(11392)=NaN;


dt14(11065:11115) = NaN;
dt14(10560:10595)=NaN;
dt14(4805:4807)=NaN;
dt14(8562:8564)=NaN;
dt14(13838:13840)=NaN;
dt14(14949:14950)=NaN;
dt14(16473:16474)=NaN;
dt14(13845:13846)=NaN;
dt14(9917:9919)=NaN;
dt14(11748:11760)=NaN;
dt14(13085:13110)=NaN;
dt14(11376)=NaN;


dt15(11065:11115) = NaN;
dt15(10560:10595)=NaN;
dt15(4805:4807)=NaN;
dt15(8562:8564)=NaN;
dt15(13838:13840)=NaN;
dt15(14949:14950)=NaN;
dt15(16473:16474)=NaN;
dt15(13845:13846)=NaN;
dt15(9917:9919)=NaN;
dt15(11745:11766)=NaN;
dt15(13085:13106)=NaN;
dt15(14912:14926)=NaN;
dt15(11376)=NaN;

dt16(11065:11115) = NaN;
dt16(10560:10595)=NaN;
dt16(4805:4807)=NaN;
dt16(8562:8564)=NaN;
dt16(13838:13840)=NaN;
dt16(14949:14950)=NaN;
dt16(16473:16474)=NaN;
dt16(13845:13846)=NaN;
dt16(9917:9919)=NaN;
dt16(11748:11759)=NaN;
dt16(13088:13103)=NaN;
dt16(14048:14060)=NaN;
dt16(11376)=NaN;

dt17(11065:11115) = NaN;
dt17(10560:10595)=NaN;
dt17(4805:4807)=NaN;
dt17(8562:8564)=NaN;
dt17(13838:13840)=NaN;
dt17(14949:14950)=NaN;
dt17(16473:16474)=NaN;
dt17(13845:13846)=NaN;
dt17(9917:9919)=NaN;
dt17(11748:11766)=NaN;
dt17(13088:13106)=NaN;
dt17(14912:14924)=NaN;
dt17(11376)=NaN;

dt18(11065:11115) = NaN;
dt18(10560:10595)=NaN;
dt18(4805:4807)=NaN;
dt18(8562:8564)=NaN;
dt18(13838:13840)=NaN;
dt18(14949:14950)=NaN;
dt18(16473:16474)=NaN;
dt18(13845:13846)=NaN;
dt18(9917:9919)=NaN;
dt18(11748:11760)=NaN;
dt18(13085:13105)=NaN;
dt18(14915:14924)=NaN;
dt18(11376)=NaN;

dt19(11065:11115) = NaN;
dt19(10560:10595)=NaN;
dt19(4805:4807)=NaN;
dt19(8562:8564)=NaN;
dt19(13838:13840)=NaN;
dt19(14949:14950)=NaN;
dt19(16473:16474)=NaN;
dt19(13845:13846)=NaN;
dt19(9917:9919)=NaN;
dt19(11367:11460)=NaN;
dt19(11745:11759)=NaN;
dt19(13100:13104)=NaN;
dt19(14915:14925)=NaN;
dt19(11376)=NaN;

dt20(11065:11115) = NaN;
dt20(10560:10595)=NaN;
dt20(4805:4807)=NaN;
dt20(8562:8564)=NaN;
dt20(13838:13840)=NaN;
dt20(14949:14950)=NaN;
dt20(16473:16474)=NaN;
dt20(13845:13846)=NaN;
dt20(9917:9919)=NaN;

dt21(11065:11115) = NaN;

dt22(11065:11115) = NaN;
dt22(10560:10595)=NaN;
dt22(4805:4807)=NaN;
dt22(8562:8564)=NaN;
dt22(13838:13840)=NaN;
dt22(14949:14950)=NaN;
dt22(16473:16474)=NaN;
dt22(13845:13846)=NaN;
dt22(9917:9919)=NaN;
dt22(1:4115)=NaN;
dt22(6380:6391)=NaN;

dt23(11065:11115) = NaN;
dt23(11065:11115) = NaN;
dt23(10560:10595)=NaN;
dt23(4805:4807)=NaN;
dt23(8562:8564)=NaN;
dt23(13838:13840)=NaN;
dt23(14949:14950)=NaN;
dt23(16473:16474)=NaN;
dt23(13845:13846)=NaN;
dt23(9917:9919)=NaN;
dt23(1:6391)=NaN;


dt24(11065:11115) = NaN;

%% GROWING SEASON DATA REMOVAL!  HIGHLIGHT THIS IF YOU DONT WANT THIS!
%%  This was a step we did in the trial-and-error process.  Still on the
%%  fence about whether or not winter data is actually saying anything, but
%%  that is not really my focus anymore...

% dt1(1:4032)=NaN;
% dt2(1:4032)=NaN;
% dt3(1:4032)=NaN;
% dt4(1:4032)=NaN;
% dt5(1:4032)=NaN;
% 
% dt6(1:4032)=NaN;
% dt7(1:4032)=NaN;
% dt8(1:4032)=NaN;
% dt9(1:4032)=NaN;
% dt10(1:4032)=NaN;
% 
% dt11(1:4032)=NaN;
% dt12(1:4032)=NaN;
% dt13(1:4032)=NaN;
% dt14(1:4032)=NaN;
% dt15(1:4032)=NaN;
% 
% dt16(1:4032)=NaN;
% dt17(1:4032)=NaN;
% dt18(1:4032)=NaN;
% dt19(1:4032)=NaN;
% dt20(1:4032)=NaN;
% 
% dt22(1:4032)=NaN;
% dt23(1:4032)=NaN;
% 
% dt1(16320:17520)=NaN;
% dt2(16320:17520)=NaN;
% dt3(16320:17520)=NaN;
% dt4(16320:17520)=NaN;
% dt5(16320:17520)=NaN;
% 
% dt6(16320:17520)=NaN;
% dt7(16320:17520)=NaN;
% dt8(16320:17520)=NaN;
% dt9(16320:17520)=NaN;
% dt10(16320:17520)=NaN;
% 
% dt11(16320:17520)=NaN;
% dt12(16320:17520)=NaN;
% dt13(16320:17520)=NaN;
% dt14(16320:17520)=NaN;
% dt15(16320:17520)=NaN;
% 
% dt16(16320:17520)=NaN;
% dt17(16320:17520)=NaN;
% dt18(16320:17520)=NaN;
% dt19(16320:17520)=NaN;
% dt20(16320:17520)=NaN;
% 
% dt22(16320:17520)=NaN;
% dt23(16320:17520)=NaN;


%%  First round of figures for checking and cleaning.

figure('Name','dT check for cleaning');
subplot(2,2,1);
hold on;
plot(dt1,'r');
plot(dt2,'b');
plot(dt3,'g');
plot(dt4,'m');
plot(dt5,'y');
legend('1','2','3','4','5');

subplot(2,2,2);
hold on;
plot(dt6,'r');
plot(dt7,'b');
plot(dt8,'g');
plot(dt9,'m');
plot(dt10,'y');
plot(dt22,'c');
plot(dt23,'k');
legend('6','7','8','9','10','22','23');

subplot(2,2,3);
hold on;
plot(dt11,'r');
plot(dt12,'b');
plot(dt13,'g');
plot(dt14,'m');
plot(dt15,'y');
legend('11','12','13','14','15');

subplot(2,2,4);
hold on;
plot(dt16,'r');
plot(dt17,'b');
plot(dt18,'g');
plot(dt19,'m');
plot(dt20,'y');
legend('16','17','18','19','20');


%% Calculate maximum dt (aka:  dT_Max) value for each day:  This is for the
%% entire day, and NOT the correct way of determining dT max.

[dt1time, dt1avg, dt1sum, dt1x, dt1min, dt1std, dt1n] = Dailystats_new(tv, dt1, 6999, -6999);
[dt2time, dt2avg, dt2sum, dt2x, dt2min, dt2std, dt2n] = Dailystats_new(tv, dt2, 6999, -6999);
[dt3time, dt3avg, dt3sum, dt3x, dt3min, dt3std, dt3n] = Dailystats_new(tv, dt3, 6999, -6999);
[dt4time, dt4avg, dt4sum, dt4x, dt4min, dt4std, dt4n] = Dailystats_new(tv, dt4, 6999, -6999);
[dt5time, dt5avg, dt5sum, dt5x, dt5min, dt5std, dt5n] = Dailystats_new(tv, dt5, 6999, -6999);
[dt6time, dt6avg, dt6sum, dt6x, dt6min, dt6std, dt6n] = Dailystats_new(tv, dt6, 6999, -6999);
[dt7time, dt7avg, dt7sum, dt7x, dt7min, dt7std, dt7n] = Dailystats_new(tv, dt7, 6999, -6999);
[dt8time, dt8avg, dt8sum, dt8x, dt8min, dt8std, dt8n] = Dailystats_new(tv, dt8, 6999, -6999);
[dt9time, dt9avg, dt9sum, dt9x, dt9min, dt9std, dt9n] = Dailystats_new(tv, dt9, 6999, -6999);
[dt10time, dt10avg, dt10sum, dt10x, dt10min, dt10std, dt10n] = Dailystats_new(tv, dt10, 6999, -6999);
[dt11time, dt11avg, dt11sum, dt11x, dt11min, dt11std, dt11n] = Dailystats_new(tv, dt11, 6999, -6999);
[dt12time, dt12avg, dt12sum, dt12x, dt12min, dt12std, dt12n] = Dailystats_new(tv, dt12, 6999, -6999);
[dt13time, dt13avg, dt13sum, dt13x, dt13min, dt13std, dt13n] = Dailystats_new(tv, dt13, 6999, -6999);
[dt14time, dt14avg, dt14sum, dt14x, dt14min, dt14std, dt14n] = Dailystats_new(tv, dt14, 6999, -6999);
[dt15time, dt15avg, dt15sum, dt15x, dt15min, dt15std, dt15n] = Dailystats_new(tv, dt15, 6999, -6999);
[dt16time, dt16avg, dt16sum, dt16x, dt16min, dt16std, dt16n] = Dailystats_new(tv, dt16, 6999, -6999);
[dt17time, dt17avg, dt17sum, dt17x, dt17min, dt17std, dt17n] = Dailystats_new(tv, dt17, 6999, -6999);
[dt18time, dt18avg, dt18sum, dt18x, dt18min, dt18std, dt18n] = Dailystats_new(tv, dt18, 6999, -6999);
[dt19time, dt19avg, dt19sum, dt19x, dt19min, dt19std, dt19n] = Dailystats_new(tv, dt19, 6999, -6999);
[dt20time, dt20avg, dt20sum, dt20x, dt20min, dt20std, dt20n] = Dailystats_new(tv, dt20, 6999, -6999);
[dt21time, dt21avg, dt21sum, dt21x, dt21min, dt21std, dt21n] = Dailystats_new(tv, dt21, 6999, -6999);
[dt22time, dt22avg, dt22sum, dt22x, dt22min, dt22std, dt22n] = Dailystats_new(tv, dt22, 6999, -6999);
[dt23time, dt23avg, dt23sum, dt23x, dt23min, dt23std, dt23n] = Dailystats_new(tv, dt23, 6999, -6999);


for i = JD(1):JD(end);   %create max daily temp diff vectors
    x = find(sapflow_2006(:,3) == i);
    y = find(jul_vec == i');
    echo off;
    dt1max_old(x) = dt1x(y)';
    dt2max_old(x) = dt2x(y)';
    dt3max_old(x) = dt3x(y)';
    dt4max_old(x) = dt4x(y)';
    dt5max_old(x) = dt5x(y)';
    dt6max_old(x) = dt6x(y)';
    dt7max_old(x) = dt7x(y)';
    dt8max_old(x) = dt8x(y)';
    dt9max_old(x) = dt9x(y)';
    dt10max_old(x) = dt10x(y)';
    dt11max_old(x) = dt11x(y)';
    dt12max_old(x) = dt12x(y)';
    dt13max_old(x) = dt13x(y)';
    dt14max_old(x) = dt14x(y)';
    dt15max_old(x) = dt15x(y)';
    dt16max_old(x) = dt16x(y)';
    dt17max_old(x) = dt17x(y)';
    dt18max_old(x) = dt18x(y)';
    dt19max_old(x) = dt19x(y)';
    dt20max_old(x) = dt20x(y)';
    dt21max_old(x) = dt21x(y)';
    dt22max_old(x) = dt22x(y)';
    dt23max_old(x) = dt23x(y)';
    %dt24max(x) = dt24x(y)';
end;

dt1max_old = dt1max_old.*25;


%%  This is calculating the max for the peak part of the day - this was
%%  part of the correction done with Myroslava.  This is the more correct,
%%  but still needs work, way...

dt1_rs = reshape(dt1,48, []);
[r c] = size(dt1_rs);

for j=1:1:c;
    dt1maxx (1,j) = nanmax(dt1_rs(18:21,j));
end;
dt1maxx = dt1maxx';

dt2_rs = reshape(dt2,48, []);
[r c] = size(dt2_rs);

for j=1:1:c;
    dt2maxx (1,j) = nanmax(dt2_rs(18:21,j));
end;

dt3_rs = reshape(dt3,48, []);
[r c] = size(dt3_rs);

for j=1:1:c;
    dt3maxx (1,j) = nanmax(dt3_rs(18:21,j));
end;

dt4_rs = reshape(dt4,48, []);
[r c] = size(dt4_rs);

for j=1:1:c;
    dt4maxx (1,j) = nanmax(dt4_rs(18:21,j));
end;

dt5_rs = reshape(dt5,48, []);
[r c] = size(dt5_rs);

for j=1:1:c;
    dt5maxx (1,j) = nanmax(dt5_rs(18:21,j));
end;

dt6_rs = reshape(dt6,48, []);
[r c] = size(dt6_rs);

for j=1:1:c;
    dt6maxx (1,j) = nanmax(dt6_rs(18:21,j));
end;


dt7_rs = reshape(dt7,48, []);
[r c] = size(dt7_rs);

for j=1:1:c;
    dt7maxx (1,j) = nanmax(dt7_rs(18:21,j));
end;

dt8_rs = reshape(dt8,48, []);
[r c] = size(dt8_rs);

for j=1:1:c;
    dt8maxx (1,j) = nanmax(dt8_rs(18:21,j));
end;

dt9_rs = reshape(dt9,48, []);
[r c] = size(dt9_rs);

for j=1:1:c;
    dt9maxx (1,j) = nanmax(dt9_rs(18:21,j));
end;

dt10_rs = reshape(dt10,48, []);
[r c] = size(dt10_rs);

for j=1:1:c;
    dt10maxx (1,j) = nanmax(dt10_rs(18:21,j));
end;

dt11_rs = reshape(dt11,48, []);
[r c] = size(dt11_rs);

for j=1:1:c;
    dt11maxx (1,j) = nanmax(dt11_rs(18:21,j));
end;


dt12_rs = reshape(dt12,48, []);
[r c] = size(dt12_rs);

for j=1:1:c;
    dt12maxx (1,j) = nanmax(dt12_rs(18:21,j));
end;

dt13_rs = reshape(dt13,48, []);
[r c] = size(dt13_rs);

for j=1:1:c;
    dt13maxx (1,j) = nanmax(dt13_rs(18:21,j));
end;

dt14_rs = reshape(dt14,48, []);
[r c] = size(dt14_rs);

for j=1:1:c;
    dt14maxx (1,j) = nanmax(dt14_rs(18:21,j));
end;

dt15_rs = reshape(dt15,48, []);
[r c] = size(dt15_rs);

for j=1:1:c;
    dt15maxx (1,j) = nanmax(dt15_rs(18:21,j));
end;

dt16_rs = reshape(dt16,48, []);
[r c] = size(dt16_rs);

for j=1:1:c;
    dt16maxx (1,j) = nanmax(dt16_rs(18:21,j));
end;

dt17_rs = reshape(dt17,48, []);
[r c] = size(dt17_rs);

for j=1:1:c;
    dt17maxx (1,j) = nanmax(dt17_rs(18:21,j));
end;

dt18_rs = reshape(dt18,48, []);
[r c] = size(dt18_rs);

for j=1:1:c;
    dt18maxx (1,j) = nanmax(dt18_rs(18:21,j));
end;

dt19_rs = reshape(dt19,48, []);
[r c] = size(dt19_rs);

for j=1:1:c;
    dt19maxx (1,j) = nanmax(dt19_rs(18:21,j));
end;

dt20_rs = reshape(dt20,48, []);
[r c] = size(dt20_rs);

for j=1:1:c;
    dt20maxx (1,j) = nanmax(dt20_rs(18:21,j));
end;

dt21_rs = reshape(dt21,48, []);
[r c] = size(dt21_rs);

for j=1:1:c;
    dt21maxx (1,j) = nanmax(dt21_rs(18:21,j));
end;

dt22_rs = reshape(dt22,48, []);
[r c] = size(dt22_rs);

for j=1:1:c;
    dt22maxx (1,j) = nanmax(dt22_rs(18:21,j));
end;

dt23_rs = reshape(dt23,48, []);
[r c] = size(dt23_rs);

for j=1:1:c;
    dt23maxx (1,j) = nanmax(dt23_rs(18:21,j));
end;

dt24_rs = reshape(dt24,48, []);
[r c] = size(dt24_rs);

for j=1:1:c;
    dt24maxx (1,j) = nanmax(dt24_rs(18:21,j));
end;

dt2maxx = dt2maxx';
dt3maxx = dt3maxx';
dt4maxx = dt4maxx';
dt5maxx = dt5maxx';
dt6maxx = dt6maxx';
dt7maxx = dt7maxx';
dt8maxx = dt8maxx';
dt9maxx = dt9maxx';
dt10maxx = dt10maxx';
dt11maxx = dt11maxx';
dt12maxx = dt12maxx';
dt13maxx = dt13maxx';
dt14maxx = dt14maxx';
dt15maxx = dt15maxx';
dt16maxx = dt16maxx';
dt17maxx = dt17maxx';
dt18maxx = dt18maxx';
dt19maxx = dt19maxx';
dt20maxx = dt20maxx';
dt21maxx = dt21maxx';
dt22maxx = dt22maxx';
dt23maxx = dt23maxx';
dt124maxx = dt24maxx';


for i = JD(1):JD(end);   %create max daily temp diff vectors
    x = find(sapflow_2006(:,3) == i);
    y = find(jul_vec == i');
    echo off;
    dt1max_new(x) = dt1maxx(y)';
    dt2max_new(x) = dt2maxx(y)';
    dt3max_new(x) = dt3maxx(y)';
    dt4max_new(x) = dt4maxx(y)';
    dt5max_new(x) = dt5maxx(y)';
    dt6max_new(x) = dt6maxx(y)';
    dt7max_new(x) = dt7maxx(y)';
    dt8max_new(x) = dt8maxx(y)';
    dt9max_new(x) = dt9maxx(y)';
    dt10max_new(x) = dt10maxx(y)';
    dt11max_new(x) = dt11maxx(y)';
    dt12max_new(x) = dt12maxx(y)';
    dt13max_new(x) = dt13maxx(y)';
    dt14max_new(x) = dt14maxx(y)';
    dt15max_new(x) = dt15maxx(y)';
    dt16max_new(x) = dt16maxx(y)';
    dt17max_new(x) = dt17maxx(y)';
    dt18max_new(x) = dt18maxx(y)';
    dt19max_new(x) = dt19maxx(y)';
    dt20max_new(x) = dt20maxx(y)';
    dt21max_new(x) = dt21maxx(y)';
    dt22max_new(x) = dt22maxx(y)';
    dt23max_new(x) = dt23maxx(y)';
    %dt24max(x) = dt24x(y)';
end;


%%  CLEAR-WATER CORRECTION!!!!!   This is basically the formula and the
%%  point where it needs to be done.

dt1 = (dt1 - (0.3 * dt1max_new))/0.7; 
dt2 = (dt2 - (0.3 * dt2max_new))/0.7;
dt3 = (dt3 - (0.3 * dt3max_new))/0.7;
dt4 = (dt4 - (0.3 * dt4max_new))/0.7;
dt5 = (dt5 - (0.3 * dt5max_new))/0.7;
dt6 = (dt6 - (0.3 * dt6max_new))/0.7;
dt7 = (dt7 - (0.3 * dt7max_new))/0.7; 
dt8 = (dt8 - (0.3 * dt8max_new))/0.7;
dt9 = (dt9 - (0.3 * dt9max_new))/0.7;
dt10 = (dt10 - (0.3 * dt10max_new))/0.7;
dt11 = (dt11 - (0.3 * dt11max_new))/0.7;
dt12 = (dt12 - (0.3 * dt12max_new))/0.7;
dt13 = (dt13 - (0.3 * dt13max_new))/0.7; 
dt14 = (dt14 - (0.3 * dt14max_new))/0.7;
dt15 = (dt15 - (0.3 * dt15max_new))/0.7;
dt16 = (dt16 - (0.3 * dt16max_new))/0.7;
dt17 = (dt17 - (0.3 * dt17max_new))/0.7;
dt18 = (dt18 - (0.3 * dt18max_new))/0.7;
dt19 = (dt19 - (0.3 * dt19max_new))/0.7; 
dt20 = (dt20 - (0.3 * dt20max_new))/0.7;
%dt21 = (dt21 - (0.3 * dt21max'))/0.7;
dt22 = (dt22 - (0.3 * dt22max_new))/0.7;
dt23 = (dt23 - (0.3 * dt23max_new))/0.7;

%%  Add these into a matrix using a loop

dt1max_x(1:17520,1) = NaN;
dt1max_rs = reshape(dt1max_x,48,[]);
dt1max_rs(18,:) = dt1maxx;
dt1max = reshape(dt1max_rs,[],1);

dt2max_x(1:17520,1) = NaN;
dt2max_rs = reshape(dt2max_x,48,[]);
dt2max_rs(18,:) = dt2maxx;
dt2max = reshape(dt2max_rs,[],1);

dt3max_x(1:17520,1) = NaN;
dt3max_rs = reshape(dt3max_x,48,[]);
dt3max_rs(18,:) = dt3maxx;
dt3max = reshape(dt3max_rs,[],1);

dt4max_x(1:17520,1) = NaN;
dt4max_rs = reshape(dt4max_x,48,[]);
dt4max_rs(18,:) = dt4maxx;
dt4max = reshape(dt4max_rs,[],1);

dt5max_x(1:17520,1) = NaN;
dt5max_rs = reshape(dt5max_x,48,[]);
dt5max_rs(18,:) = dt5maxx;
dt5max = reshape(dt5max_rs,[],1);

dt6max_x(1:17520,1) = NaN;
dt6max_rs = reshape(dt6max_x,48,[]);
dt6max_rs(18,:) = dt6maxx;
dt6max = reshape(dt6max_rs,[],1);

dt7max_x(1:17520,1) = NaN;
dt7max_rs = reshape(dt7max_x,48,[]);
dt7max_rs(18,:) = dt7maxx;
dt7max = reshape(dt7max_rs,[],1);

dt8max_x(1:17520,1) = NaN;
dt8max_rs = reshape(dt8max_x,48,[]);
dt8max_rs(18,:) = dt8maxx;
dt8max = reshape(dt8max_rs,[],1);

dt9max_x(1:17520,1) = NaN;
dt9max_rs = reshape(dt9max_x,48,[]);
dt9max_rs(18,:) = dt9maxx;
dt9max = reshape(dt9max_rs,[],1);

dt10max_x(1:17520,1) = NaN;
dt10max_rs = reshape(dt10max_x,48,[]);
dt10max_rs(18,:) = dt10maxx;
dt10max = reshape(dt10max_rs,[],1);

dt11max_x(1:17520,1) = NaN;
dt11max_rs = reshape(dt11max_x,48,[]);
dt11max_rs(18,:) = dt11maxx;
dt11max = reshape(dt11max_rs,[],1);

dt12max_x(1:17520,1) = NaN;
dt12max_rs = reshape(dt12max_x,48,[]);
dt12max_rs(18,:) = dt12maxx;
dt12max = reshape(dt12max_rs,[],1);

dt13max_x(1:17520,1) = NaN;
dt13max_rs = reshape(dt13max_x,48,[]);
dt13max_rs(18,:) = dt13maxx;
dt13max = reshape(dt13max_rs,[],1);

dt14max_x(1:17520,1) = NaN;
dt14max_rs = reshape(dt14max_x,48,[]);
dt14max_rs(18,:) = dt14maxx;
dt14max = reshape(dt14max_rs,[],1);

dt15max_x(1:17520,1) = NaN;
dt15max_rs = reshape(dt15max_x,48,[]);
dt15max_rs(18,:) = dt15maxx;
dt15max = reshape(dt15max_rs,[],1);

dt16max_x(1:17520,1) = NaN;
dt16max_rs = reshape(dt16max_x,48,[]);
dt16max_rs(18,:) = dt16maxx;
dt16max = reshape(dt16max_rs,[],1);

dt17max_x(1:17520,1) = NaN;
dt17max_rs = reshape(dt17max_x,48,[]);
dt17max_rs(18,:) = dt17maxx;
dt17max = reshape(dt17max_rs,[],1);

dt18max_x(1:17520,1) = NaN;
dt18max_rs = reshape(dt18max_x,48,[]);
dt18max_rs(18,:) = dt18maxx;
dt18max = reshape(dt18max_rs,[],1);

dt19max_x(1:17520,1) = NaN;
dt19max_rs = reshape(dt19max_x,48,[]);
dt19max_rs(18,:) = dt19maxx;
dt19max = reshape(dt19max_rs,[],1);

dt20max_x(1:17520,1) = NaN;
dt20max_rs = reshape(dt20max_x,48,[]);
dt20max_rs(18,:) = dt20maxx;
dt20max = reshape(dt20max_rs,[],1);

dt21max_x(1:17520,1) = NaN;
dt21max_rs = reshape(dt21max_x,48,[]);
dt21max_rs(18,:) = dt21maxx;
dt21max = reshape(dt21max_rs,[],1);

dt22max_x(1:17520,1) = NaN;
dt22max_rs = reshape(dt22max_x,48,[]);
dt22max_rs(18,:) = dt22maxx;
dt22max = reshape(dt22max_rs,[],1);

dt23max_x(1:17520,1) = NaN;
dt23max_rs = reshape(dt23max_x,48,[]);
dt23max_rs(18,:) = dt23maxx;
dt23max = reshape(dt23max_rs,[],1);

dt24max_x(1:17520,1) = NaN;
dt24max_rs = reshape(dt24max_x,48,[]);
dt24max_rs(18,:) = dt24maxx;
dt24max = reshape(dt24max_rs,[],1);


% Transpose vectors
dt1max = dt1max';
dt2max = dt2max';
dt3max = dt3max';
dt4max = dt4max';
dt5max = dt5max';
dt6max = dt6max';
dt7max = dt7max';
dt8max = dt8max';
dt9max = dt9max';
dt10max = dt10max';
dt11max = dt11max';
dt12max = dt12max';
dt13max = dt13max';
dt14max = dt14max';
dt15max = dt15max';
dt16max = dt16max';
dt17max = dt17max';
dt18max = dt18max';
dt19max = dt19max';
dt20max = dt20max';
dt21max = dt21max';
dt22max = dt22max';
dt23max = dt23max';
%dt24max = dt24max';  <-- you'll notice a lot of sensors are blocked out in
%the 24-25 range;  These sensors just weren't working or were never
%programmed (i.e. SF_25)

% Check dTmax
figure('Name','dt_max test');clf;
hold on;

subplot(2,2,1);
hold on;
plot(dt1max,'b');
plot(dt2max,'g');
plot(dt3max,'r');
plot(dt4max,'c');
plot(dt5max,'m');
set(gca,'box','on');
title 'Reference';

subplot(2,2,2);
hold on;
plot(dt6max,'b');
plot(dt7max,'g');
plot(dt8max,'r');
plot(dt9max,'c');
plot(dt10max,'m');
set(gca,'box','on');
title 'Drought';

subplot(2,2,3);
hold on;
plot(dt11max,'b');
plot(dt12max,'g');
plot(dt13max,'r');
plot(dt14max,'c');
plot(dt15max,'m');
set(gca,'box','on');
title 'Fall';

subplot(2,2,4);
hold on;
plot(dt16max,'b');
plot(dt17max,'g');
plot(dt18max,'r');
plot(dt19max,'c');
plot(dt20max,'m');
set(gca,'box','on');
title 'Fall';


%%  This was a manual adjustment.  After the new volt. regulator came in,
%%  we had to readjust the values to account for some drift.

volt_reg_adjust_before1 = nanmean(dt1max(10080:10560));
volt_reg_adjust_after1 = nanmean(dt1max(11090:11470));

ratio_volt_reg_1 = volt_reg_adjust_before1./volt_reg_adjust_after1;

volt_reg_adjust_before2 = nanmean(dt2max(10080:10560));
volt_reg_adjust_after2 = nanmean(dt2max(11090:11470));

ratio_volt_reg_2 = volt_reg_adjust_before2./volt_reg_adjust_after2;

volt_reg_adjust_before3 = nanmean(dt3max(10080:10560));
volt_reg_adjust_after3 = nanmean(dt3max(11090:11470));

ratio_volt_reg_3 = volt_reg_adjust_before3./volt_reg_adjust_after3;

volt_reg_adjust_before4 = nanmean(dt4max(10080:10560));
volt_reg_adjust_after4 = nanmean(dt4max(11090:11470));

ratio_volt_reg_4 = volt_reg_adjust_before4./volt_reg_adjust_after4;

volt_reg_adjust_before5 = nanmean(dt5max(10080:10560));
volt_reg_adjust_after5 = nanmean(dt5max(11090:11470));

ratio_volt_reg_5 = volt_reg_adjust_before5./volt_reg_adjust_after5;



volt_reg_adjust_before6 = nanmean(dt6max(10080:10560));
volt_reg_adjust_after6 = nanmean(dt6max(11090:11470));

ratio_volt_reg_6 = volt_reg_adjust_before6./volt_reg_adjust_after6;

volt_reg_adjust_before7 = nanmean(dt7max(10080:10560));
volt_reg_adjust_after7 = nanmean(dt7max(11090:11470));

ratio_volt_reg_7 = volt_reg_adjust_before7./volt_reg_adjust_after7;

volt_reg_adjust_before8 = nanmean(dt8max(10080:10560));
volt_reg_adjust_after8 = nanmean(dt8max(11090:11470));

ratio_volt_reg_8 = volt_reg_adjust_before8./volt_reg_adjust_after8;

volt_reg_adjust_before9 = nanmean(dt9max(10080:10560));
volt_reg_adjust_after9 = nanmean(dt9max(11090:11470));

ratio_volt_reg_9 = volt_reg_adjust_before9./volt_reg_adjust_after9;

volt_reg_adjust_before10 = nanmean(dt10max(10080:10560));
volt_reg_adjust_after10 = nanmean(dt10max(11090:11470));

ratio_volt_reg_10 = volt_reg_adjust_before10./volt_reg_adjust_after10;

volt_reg_adjust_before11 = nanmean(dt11max(10080:10560));
volt_reg_adjust_after11 = nanmean(dt11max(11090:11470));

ratio_volt_reg_11 = volt_reg_adjust_before11./volt_reg_adjust_after11;

volt_reg_adjust_before12 = nanmean(dt12max(10080:10560));
volt_reg_adjust_after12 = nanmean(dt12max(11090:11470));

ratio_volt_reg_12 = volt_reg_adjust_before12./volt_reg_adjust_after12;

volt_reg_adjust_before13 = nanmean(dt13max(10080:10560));
volt_reg_adjust_after13 = nanmean(dt13max(11090:11470));
volt_reg_adjust_after13b = nanmean(dt13max(11151:11366));

ratio_volt_reg_13 = volt_reg_adjust_before13./volt_reg_adjust_after13;
ratio_volt_reg_13b = volt_reg_adjust_before13./volt_reg_adjust_after13b;

volt_reg_adjust_before14 = nanmean(dt14max(10080:10560));
volt_reg_adjust_after14 = nanmean(dt14max(11376:11856));
volt_reg_adjust_after14b = nanmean(dt14max(11151:11366));

ratio_volt_reg_14 = volt_reg_adjust_before14./volt_reg_adjust_after14;
ratio_volt_reg_14b = volt_reg_adjust_before14./volt_reg_adjust_after14b;

volt_reg_adjust_before15 = nanmean(dt15max(10080:10560));
volt_reg_adjust_after15 = nanmean(dt15max(11376:11856));
volt_reg_adjust_after15b = nanmean(dt15max(11151:11366));

ratio_volt_reg_15 = volt_reg_adjust_before15./volt_reg_adjust_after15;
ratio_volt_reg_15b = volt_reg_adjust_before15./volt_reg_adjust_after15b;

volt_reg_adjust_before16 = nanmean(dt16max(10080:10560));
volt_reg_adjust_after16 = nanmean(dt16max(11376:11856));
volt_reg_adjust_after16b = nanmean(dt16max(11151:11366));

ratio_volt_reg_16 = volt_reg_adjust_before16./volt_reg_adjust_after16;
ratio_volt_reg_16b = volt_reg_adjust_before16./volt_reg_adjust_after16b;

volt_reg_adjust_before17 = nanmean(dt17max(10080:10560));
volt_reg_adjust_after17 = nanmean(dt17max(11376:11856));
volt_reg_adjust_after17b = nanmean(dt17max(11151:11366));

ratio_volt_reg_17 = volt_reg_adjust_before17./volt_reg_adjust_after17;
ratio_volt_reg_17b = volt_reg_adjust_before17./volt_reg_adjust_after17b;

volt_reg_adjust_before18 = nanmean(dt18max(10080:10560));
volt_reg_adjust_after18 = nanmean(dt18max(11376:11856));
volt_reg_adjust_after18b = nanmean(dt18max(11151:11366));

ratio_volt_reg_18 = volt_reg_adjust_before18./volt_reg_adjust_after18;
ratio_volt_reg_18b = volt_reg_adjust_before18./volt_reg_adjust_after18b;

volt_reg_adjust_before19 = nanmean(dt19max(10080:10560));
volt_reg_adjust_after19 = nanmean(dt19max(11376:11856));
volt_reg_adjust_after19b = nanmean(dt19max(11151:11366));

ratio_volt_reg_19 = volt_reg_adjust_before19./volt_reg_adjust_after19;
ratio_volt_reg_19b = volt_reg_adjust_before19./volt_reg_adjust_after19b;

volt_reg_adjust_before20 = nanmean(dt20max(10080:10560));
volt_reg_adjust_after20 = nanmean(dt20max(11090:11470));

ratio_volt_reg_20 = volt_reg_adjust_before20./volt_reg_adjust_after20;

volt_reg_adjust_before22 = nanmean(dt22max(10080:10560));
volt_reg_adjust_after22 = nanmean(dt22max(11090:11470));

ratio_volt_reg_22 = volt_reg_adjust_before22./volt_reg_adjust_after22;

volt_reg_adjust_before23 = nanmean(dt23max(10080:10560));
volt_reg_adjust_after23 = nanmean(dt23max(11090:11470));

ratio_volt_reg_23 = volt_reg_adjust_before23./volt_reg_adjust_after23;



%%  Adjust all the dt and Tmax values for the voltage regulator impact
%%  (same dealeo)


dt1max(10560:end) = dt1max(10560:end).*ratio_volt_reg_1;
dt2max(10560:end) = dt2max(10560:end).*ratio_volt_reg_2;
dt3max(10560:end) = dt3max(10560:end).*ratio_volt_reg_3;
dt4max(10560:end) = dt4max(10560:end).*ratio_volt_reg_4;
dt5max(10560:end) = dt5max(10560:end).*ratio_volt_reg_5;

dt6max(10560:end) = dt6max(10560:end).*ratio_volt_reg_6;
dt7max(10560:end) = dt7max(10560:end).*ratio_volt_reg_7;
dt8max(10560:end) = dt8max(10560:end).*ratio_volt_reg_8;
dt9max(10560:end) = dt9max(10560:end).*ratio_volt_reg_9;
dt10max(10560:end) = dt10max(10560:end).*ratio_volt_reg_10;

dt11max(10560:end) = dt11max(10560:end).*ratio_volt_reg_11;
dt12max(10560:end) = dt12max(10560:end).*ratio_volt_reg_12;
dt13max(11367:end) = dt13max(11367:end).*ratio_volt_reg_13;
dt13max(11115:11366) = dt13max(11115:11366).*ratio_volt_reg_13b;
dt14max(11367:end) = dt14max(11367:end).*ratio_volt_reg_14;
dt14max(11115:11366) = dt14max(11115:11366).*ratio_volt_reg_14b;
dt15max(11367:end) = dt15max(11367:end).*ratio_volt_reg_15;
dt15max(11115:11366) = dt15max(11115:11366).*ratio_volt_reg_15b;

dt16max(11367:end) = dt16max(11367:end).*ratio_volt_reg_16;
dt16max(11115:11366) = dt16max(11115:11366).*ratio_volt_reg_16b;
dt17max(11367:end) = dt17max(11367:end).*ratio_volt_reg_17;
dt17max(11115:11366) = dt17max(11115:11366).*ratio_volt_reg_17b;
dt18max(11367:end) = dt18max(11367:end).*ratio_volt_reg_18;
dt18max(11115:11366) = dt18max(11115:11366).*ratio_volt_reg_18b;
dt19max(11367:end) = dt19max(11367:end).*ratio_volt_reg_19;
dt19max(11115:11366) = dt19max(11115:11366).*ratio_volt_reg_19b;
dt20max(10560:end) = dt20max(10560:end).*ratio_volt_reg_20;

dt22max(10560:end) = dt22max(10560:end).*ratio_volt_reg_22;
dt23max(10560:end) = dt23max(10560:end).*ratio_volt_reg_23;


dt1(10560:end) = dt1(10560:end).*ratio_volt_reg_1;
dt2(10560:end) = dt2(10560:end).*ratio_volt_reg_2;
dt3(10560:end) = dt3(10560:end).*ratio_volt_reg_3;
dt4(10560:end) = dt4(10560:end).*ratio_volt_reg_4;
dt5(10560:end) = dt5(10560:end).*ratio_volt_reg_5;

dt6(10560:end) = dt6(10560:end).*ratio_volt_reg_6;
dt7(10560:end) = dt7(10560:end).*ratio_volt_reg_7;
dt8(10560:end) = dt8(10560:end).*ratio_volt_reg_8;
dt9(10560:end) = dt9(10560:end).*ratio_volt_reg_9;
dt10(10560:end) = dt10(10560:end).*ratio_volt_reg_10;

dt11(10560:end) = dt11(10560:end).*ratio_volt_reg_11;
dt12(10560:end) = dt12(10560:end).*ratio_volt_reg_12;
dt13(11367:end) = dt13(11367:end).*ratio_volt_reg_13;
dt13(11115:11366) = dt13(11115:11366).*ratio_volt_reg_13b;
dt14(11367:end) = dt14(11367:end).*ratio_volt_reg_14;
dt14(11115:11366) = dt14(11115:11366).*ratio_volt_reg_14b;
dt15(11367:end) = dt15(11367:end).*ratio_volt_reg_15;
dt15(11115:11366) = dt15(11115:11366).*ratio_volt_reg_15b;

dt16(11367:end) = dt16(11367:end).*ratio_volt_reg_16;
dt16(11115:11366) = dt16(11115:11366).*ratio_volt_reg_16b;
dt17(11367:end) = dt17(11367:end).*ratio_volt_reg_17;
dt17(11115:11366) = dt17(11115:11366).*ratio_volt_reg_17b;
dt18(11367:end) = dt18(11367:end).*ratio_volt_reg_18;
dt18(11115:11366) = dt18(11115:11366).*ratio_volt_reg_18b;
dt19(11367:end) = dt19(11367:end).*ratio_volt_reg_19;
dt19(11115:11366) = dt19(11115:11366).*ratio_volt_reg_19b;
dt20(10560:end) = dt20(10560:end).*ratio_volt_reg_20;

dt22(10560:end) = dt22(10560:end).*ratio_volt_reg_22;
dt23(10560:end) = dt23(10560:end).*ratio_volt_reg_23;

%%  A figure to see the adjustment - the values are at the same level now.
%%  (Myro/Henrik adjustment)

figure('Name','dt_max after adjustment');clf;
hold on;

subplot(2,2,1);
hold on;
plot(dt1max,'b');
plot(dt2max,'g');
plot(dt3max,'r');
plot(dt4max,'c');
plot(dt5max,'m');
set(gca,'box','on');
title 'Reference';

subplot(2,2,2);
hold on;
plot(dt6max,'b');
plot(dt7max,'g');
plot(dt8max,'r');
plot(dt9max,'c');
plot(dt10max,'m');
set(gca,'box','on');
title 'Drought';

subplot(2,2,3);
hold on;
plot(dt11max,'b');
plot(dt12max,'g');
plot(dt13max,'r');
plot(dt14max,'c');
plot(dt15max,'m');
set(gca,'box','on');
title 'Fall';

subplot(2,2,4);
hold on;
plot(dt16max,'b');
plot(dt17max,'g');
plot(dt18max,'r');
plot(dt19max,'c');
plot(dt20max,'m');
set(gca,'box','on');
title 'Thinned';

figure('Name','dt_ after adjustment');clf;
hold on;

subplot(2,2,1);
hold on;
plot(dt1,'b');
plot(dt2,'g');
plot(dt3,'r');
plot(dt4,'c');
plot(dt5,'m');
set(gca,'box','on');
title 'Reference';

subplot(2,2,2);
hold on;
plot(dt6,'b');
plot(dt7,'g');
plot(dt8,'r');
plot(dt9,'c');
plot(dt10,'m');
set(gca,'box','on');
title 'Drought';

subplot(2,2,3);
hold on;
plot(dt11,'b');
plot(dt12,'g');
plot(dt13,'r');
plot(dt14,'c');
plot(dt15,'m');
set(gca,'box','on');
title 'Fall';

subplot(2,2,4);
hold on;
plot(dt16,'b');
plot(dt17,'g');
plot(dt18,'r');
plot(dt19,'c');
plot(dt20,'m');
set(gca,'box','on');
title 'Thinned';


%%  PUT EVERYTHING IN TEMP (finally...)

dt1 = dt1.*25;
dt2 = dt2.*25;
dt3 = dt3.*25;
dt4 = dt4.*25;
dt5 = dt5.*25;

dt6 = dt6.*25;
dt7 = dt7.*25;
dt8 = dt8.*25;
dt9 = dt9.*25;
dt10 = dt10.*25;

dt11 = dt11.*25;
dt12 = dt12.*25;
dt13 = dt13.*25;
dt14 = dt14.*25;
dt15 = dt15.*25;

dt16 = dt16.*25;
dt17 = dt17.*25;
dt18 = dt18.*25;
dt19 = dt19.*25;
dt20 = dt20.*25;

dt21 = dt21.*25;
dt22 = dt22.*25;
dt23 = dt23.*25;
dt24 = dt24.*25;

dt1max = dt1max.*25;
dt2max = dt2max.*25;
dt3max = dt3max.*25;
dt4max = dt4max.*25;
dt5max = dt5max.*25;

dt6max = dt6max.*25;
dt7max = dt7max.*25;
dt8max = dt8max.*25;
dt9max = dt9max.*25;
dt10max = dt10max.*25;

dt11max = dt11max.*25;
dt12max = dt12max.*25;
dt13max = dt13max.*25;
dt14max = dt14max.*25;
dt15max = dt15max.*25;

dt16max = dt16max.*25;
dt17max = dt17max.*25;
dt18max = dt18max.*25;
dt19max = dt19max.*25;
dt20max = dt20max.*25;

dt21max = dt21max.*25;
dt22max = dt22max.*25;
dt23max = dt23max.*25;
dt24max = dt24max.*25;

%%  Try interpolating the data...  This is where things start to get
%%  complicated I guess...  This is creating the "Golden" data file... i.e.
%%  the data we can actually do something with.  Figures for checks also
%%  involved.

% SENSOR #1
x_val = 1:1:17520;
a = dt1max;

dt1max_interp = interp_nan(x_val,a);

figure('Name','naninterp dt1');
hold on;
plot(dt1,'g');
plot(dt1max_interp,'b');
plot(dt1max,'ro');

golden_dt1 = (dt1 - dt1max_interp);
dtmax(1,1:17520) = 0;
dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt1,'r','LineWidth',2);
plot(golden_dt1,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT1 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #2

dt2max_interp = interp_nan(x_val,dt2max);

figure('Name','naninterp dt2');
hold on;
plot(dt2,'g');
plot(dt2max_interp,'b');
plot(dt2max,'ro');

golden_dt2 = (dt2 - dt2max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt2,'r','LineWidth',2);
plot(golden_dt2,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT2 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #3

dt3max_interp = interp_nan(x_val,dt3max);

figure('Name','naninterp dt3');
hold on;
plot(dt3,'g');
plot(dt3max_interp,'b');
plot(dt3max,'ro');

golden_dt3 = (dt3 - dt3max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt3,'r','LineWidth',2);
plot(golden_dt3,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT3 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #4

dt4max_interp = interp_nan(x_val,dt4max);

figure('Name','naninterp dt4');
hold on;
plot(dt4,'g');
plot(dt4max_interp,'b');
plot(dt4max,'ro');

golden_dt4 = (dt4 - dt4max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt4,'r','LineWidth',2);
plot(golden_dt4,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT4 FINALLY!','FontSize',16);
legend('raw','Golden');


% SENSOR #5

dt5max_interp = interp_nan(x_val,dt5max);

figure('Name','naninterp dt5');
hold on;
plot(dt5,'g');
plot(dt5max_interp,'b');
plot(dt5max,'ro');

golden_dt5 = (dt5 - dt5max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt5,'r','LineWidth',2);
plot(golden_dt5,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT5 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #6

dt6max_interp = interp_nan(x_val,dt6max);

figure('Name','naninterp dt6');
hold on;
plot(dt6,'g');
plot(dt6max_interp,'b');
plot(dt6max,'ro');

golden_dt6 = (dt6 - dt6max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt6,'r','LineWidth',2);
plot(golden_dt6,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT6 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #7

dt7max_interp = interp_nan(x_val,dt7max);

figure('Name','naninterp dt7');
hold on;
plot(dt7,'g');
plot(dt7max_interp,'b');
plot(dt7max,'ro');

golden_dt7 = (dt7 - dt7max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt7,'r','LineWidth',2);
plot(golden_dt7,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT7 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #8

dt8max_interp = interp_nan(x_val,dt8max);

figure('Name','naninterp dt8');
hold on;
plot(dt8,'g');
plot(dt8max_interp,'b');
plot(dt8max,'ro');

golden_dt8 = (dt8 - dt8max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt8,'r','LineWidth',2);
plot(golden_dt8,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT8 FINALLY!','FontSize',16);
legend('raw','Golden');


% SENSOR #9

dt9max_interp = interp_nan(x_val,dt9max);

figure('Name','naninterp dt9');
hold on;
plot(dt9,'g');
plot(dt9max_interp,'b');
plot(dt9max,'ro');

golden_dt9 = (dt9 - dt9max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt9,'r','LineWidth',2);
plot(golden_dt9,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT9 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #10

dt10max_interp = interp_nan(x_val,dt10max);

figure('Name','naninterp dt10');
hold on;
plot(dt10,'g');
plot(dt10max_interp,'b');
plot(dt10max,'ro');

golden_dt10 = (dt10 - dt10max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt10,'r','LineWidth',2);
plot(golden_dt10,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT10 FINALLY!','FontSize',16);
legend('raw','Golden');


% SENSOR #11

dt11max_interp = interp_nan(x_val,dt11max);

figure('Name','naninterp dt11');
hold on;
plot(dt11,'g');
plot(dt11max_interp,'b');
plot(dt11max,'ro');

golden_dt11 = (dt11 - dt11max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt11,'r','LineWidth',2);
plot(golden_dt11,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT11 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #12

dt12max_interp = interp_nan(x_val,dt12max);

figure('Name','naninterp dt12');
hold on;
plot(dt12,'g');
plot(dt12max_interp,'b');
plot(dt12max,'ro');

golden_dt12 = (dt12 - dt12max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt12,'r','LineWidth',2);
plot(golden_dt12,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT12 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #13

dt13max_interp = interp_nan(x_val,dt13max);

figure('Name','naninterp dt13');
hold on;
plot(dt13,'g');
plot(dt13max_interp,'b');
plot(dt13max,'ro');

golden_dt13 = (dt13 - dt13max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt13,'r','LineWidth',2);
plot(golden_dt13,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT13 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #14

dt14max_interp = interp_nan(x_val,dt14max);

figure('Name','naninterp dt14');
hold on;
plot(dt14,'g');
plot(dt14max_interp,'b');
plot(dt14max,'ro');

golden_dt14 = (dt14 - dt14max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt14,'r','LineWidth',2);
plot(golden_dt14,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT14 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #15

dt15max_interp = interp_nan(x_val,dt15max);

figure('Name','naninterp dt14');
hold on;
plot(dt15,'g');
plot(dt15max_interp,'b');
plot(dt15max,'ro');

golden_dt15 = (dt15 - dt15max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt15,'r','LineWidth',2);
plot(golden_dt15,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT15 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #16

dt16max_interp = interp_nan(x_val,dt16max);

figure('Name','naninterp dt16');
hold on;
plot(dt16,'g');
plot(dt16max_interp,'b');
plot(dt16max,'ro');

golden_dt16 = (dt16 - dt16max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt16,'r','LineWidth',2);
plot(golden_dt16,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT16 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #17

dt17max_interp = interp_nan(x_val,dt17max);

figure('Name','naninterp dt17');
hold on;
plot(dt17,'g');
plot(dt17max_interp,'b');
plot(dt17max,'ro');

golden_dt17 = (dt17 - dt17max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt17,'r','LineWidth',2);
plot(golden_dt17,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT17 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #18

dt18max_interp = interp_nan(x_val,dt18max);

figure('Name','naninterp dt18');
hold on;
plot(dt18,'g');
plot(dt18max_interp,'b');
plot(dt18max,'ro');

golden_dt18 = (dt18 - dt18max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt18,'r','LineWidth',2);
plot(golden_dt18,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT18 FINALLY!','FontSize',16);
legend('raw','Golden');


% SENSOR #19

dt19max_interp = interp_nan(x_val,dt19max);

figure('Name','naninterp dt19');
hold on;
plot(dt19,'g');
plot(dt19max_interp,'b');
plot(dt19max,'ro');

golden_dt19 = (dt19 - dt19max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt19,'r','LineWidth',2);
plot(golden_dt19,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT19 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #20

dt20max_interp = interp_nan(x_val,dt20max);

figure('Name','naninterp dt20');
hold on;
plot(dt20,'g');
plot(dt20max_interp,'b');
plot(dt20max,'ro');

golden_dt20 = (dt20 - dt20max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt20,'r','LineWidth',2);
plot(golden_dt20,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT20 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #22

dt22max_interp = interp_nan(x_val,dt22max);

figure('Name','naninterp dt22');
hold on;
plot(dt22,'g');
plot(dt22max_interp,'b');
plot(dt22max,'ro');

golden_dt22 = (dt22 - dt22max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt22,'r','LineWidth',2);
plot(golden_dt22,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT22 FINALLY!','FontSize',16);
legend('raw','Golden');

% SENSOR #23

dt23max_interp = interp_nan(x_val,dt23max);

figure('Name','naninterp dt23');
hold on;
plot(dt23,'g');
plot(dt23max_interp,'b');
plot(dt23max,'ro');

golden_dt23 = (dt23 - dt23max_interp);
%dtmax(1,1:17520) = 0;
%dtmax = dtmax';

figure('Name','Golden');
hold on;
plot(dt23,'r','LineWidth',2);
plot(golden_dt23,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT23 FINALLY!','FontSize',16);
legend('raw','Golden');


%%  Final matrix of usable dT (corrected) data

matrix_golden_2009(1:17520,44)=NaN;
matrix_golden_2009(:,1)=golden_dt1;
matrix_golden_2009(:,2)=golden_dt2;
matrix_golden_2009(:,3)=golden_dt3;
matrix_golden_2009(:,4)=golden_dt4;
matrix_golden_2009(:,5)=golden_dt5;
matrix_golden_2009(:,6)=golden_dt6;
matrix_golden_2009(:,7)=golden_dt7;
matrix_golden_2009(:,8)=golden_dt8;
matrix_golden_2009(:,9)=golden_dt9;
matrix_golden_2009(:,10)=golden_dt10;
matrix_golden_2009(:,11)=golden_dt11;
matrix_golden_2009(:,12)=golden_dt12;
matrix_golden_2009(:,13)=golden_dt13;
matrix_golden_2009(:,14)=golden_dt14;
matrix_golden_2009(:,15)=golden_dt15;
matrix_golden_2009(:,16)=golden_dt16;
matrix_golden_2009(:,17)=golden_dt17;
matrix_golden_2009(:,18)=golden_dt18;
matrix_golden_2009(:,19)=golden_dt19;
matrix_golden_2009(:,20)=golden_dt20;
matrix_golden_2009(:,21)=golden_dt22;
matrix_golden_2009(:,22)=golden_dt23;
matrix_golden_2009(:,23)=dt1;
matrix_golden_2009(:,24)=dt2;
matrix_golden_2009(:,25)=dt3;
matrix_golden_2009(:,26)=dt4;
matrix_golden_2009(:,27)=dt5;
matrix_golden_2009(:,28)=dt6;
matrix_golden_2009(:,29)=dt7;
matrix_golden_2009(:,30)=dt8;
matrix_golden_2009(:,31)=dt9;
matrix_golden_2009(:,32)=dt10;
matrix_golden_2009(:,33)=dt11;
matrix_golden_2009(:,34)=dt12;
matrix_golden_2009(:,35)=dt13;
matrix_golden_2009(:,36)=dt14;
matrix_golden_2009(:,37)=dt15;
matrix_golden_2009(:,38)=dt16;
matrix_golden_2009(:,39)=dt17;
matrix_golden_2009(:,40)=dt18;
matrix_golden_2009(:,41)=dt19;
matrix_golden_2009(:,42)=dt20;
matrix_golden_2009(:,43)=dt22;
matrix_golden_2009(:,44)=dt23;

DLMWRITE('C:/MacKay/multi/matrix_golden_2009_final.csv', matrix_golden_2009,',');

close all;


figure('Name','show');
subplot(2,1,1);
hold on;
plot(dt1,'g');
plot(dt1max_interp,'b');
plot(dt1max,'ro');
legend ('Raw','Interpolated','Max');
set(gca,'box','on');
title 'Finding the Golden Data';

subplot(2,1,2);
hold on;
plot(dt1,'r','LineWidth',2);
plot(golden_dt1,'k','LineWidth',2);
set(gca,'box','on');
title ('Golden Data for dT1 FINALLY!','FontSize',16);
legend('raw','Golden');

%%  Calculate values using this new data

%%  K is a dimensionless parameter

K1 = ((-1.*(golden_dt1))./dt1); ind = find(K1 < 0); K1(ind) = 0;
K2 = ((-1.*(golden_dt2))./dt2); ind = find(K2 < 0); K2(ind) = 0;
K3 = ((-1.*(golden_dt3))./dt3); ind = find(K3 < 0); K3(ind) = 0;
K4 = ((-1.*(golden_dt4))./dt4); ind = find(K4 < 0); K4(ind) = 0;
K5 = ((-1.*(golden_dt5))./dt5); ind = find(K5 < 0); K5(ind) = 0;

K6 = ((-1.*(golden_dt6))./dt6); ind = find(K6 < 0); K6(ind) = 0;
K7 = ((-1.*(golden_dt7))./dt7); ind = find(K7 < 0); K7(ind) = 0;
K8 = ((-1.*(golden_dt8))./dt8); ind = find(K8 < 0); K8(ind) = 0;
K9 = ((-1.*(golden_dt9))./dt9); ind = find(K9 < 0); K9(ind) = 0;
K10 = ((-1.*(golden_dt10))./dt10); ind = find(K10 < 0); K10(ind) = 0;

K11 = ((-1.*(golden_dt11))./dt11); ind = find(K11 < 0); K11(ind) = 0;
K12 = ((-1.*(golden_dt12))./dt12); ind = find(K12 < 0); K12(ind) = 0;
K13 = ((-1.*(golden_dt13))./dt13); ind = find(K13 < 0); K13(ind) = 0;
K14 = ((-1.*(golden_dt14))./dt14); ind = find(K14 < 0); K14(ind) = 0;
K15 = ((-1.*(golden_dt15))./dt15); ind = find(K15 < 0); K15(ind) = 0;

K16 = ((-1.*(golden_dt16))./dt16); ind = find(K16 < 0); K16(ind) = 0;
K17 = ((-1.*(golden_dt17))./dt17); ind = find(K17 < 0); K17(ind) = 0;
K18 = ((-1.*(golden_dt18))./dt18); ind = find(K18 < 0); K18(ind) = 0;
K19 = ((-1.*(golden_dt19))./dt19); ind = find(K19 < 0); K19(ind) = 0;
K20 = ((-1.*(golden_dt20))./dt20); ind = find(K20 < 0); K20(ind) = 0;

K22 = ((-1.*(golden_dt22))./dt22); ind = find(K22 < 0); K22(ind) = 0;
K23 = ((-1.*(golden_dt23))./dt23); ind = find(K23 < 0); K23(ind) = 0;



%% Sap Flow Velocity (Js)

V1 = 0.119e-3 .*(K1 .^1.231);
V1(find(V1>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V1_hh09.dat'  V1   -ASCII
V2 = 0.119e-3 .*(K2 .^1.231);
V2(find(V2>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V2_hh09.dat'  V2   -ASCII
V3 = 0.119e-3 .*(K3 .^1.231);
V3(find(V3>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V3_hh09.dat'  V3   -ASCII
V4 = 0.119e-3 .*(K4 .^1.231);
V4(find(V4>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V4_hh09.dat'  V4   -ASCII
V5 = 0.119e-3 .*(K5 .^1.231);
V5(find(V5>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V5_hh09.dat'  V5   -ASCII
V6 = 0.119e-3 .*(K6 .^1.231);
V6(find(V6>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V6_hh09.dat'  V6   -ASCII
V7 = 0.119e-3 .*(K7 .^1.231);
V7(find(V7>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V7_hh09.dat'  V7   -ASCII
V8 = 0.119e-3 .*(K8 .^1.231);
V8(find(V8>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V8_hh09.dat'  V8   -ASCII
V9 = 0.119e-3 .*(K9 .^1.231);
V9(find(V9>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V9_hh09.dat'  V9   -ASCII
V10 = 0.119e-3 .*(K10 .^1.231);
V10(find(V10>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V10_hh09.dat'  V10   -ASCII
V11 = 0.119e-3 .*(K11 .^1.231);
V11(find(V11>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V11_hh09.dat'  V11   -ASCII
V12 = 0.119e-3 .*(K12 .^1.231);
V12(find(V12>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V12_hh09.dat'  V12   -ASCII
V13 = 0.119e-3 .*(K13 .^1.231);
V13(find(V13>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V13_hh09.dat'  V13   -ASCII
V14 = 0.119e-3 .*(K14 .^1.231);
V14(find(V14>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V14_hh09.dat'  V14   -ASCII
V15 = 0.119e-3 .*(K15 .^1.231);
V15(find(V15>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V15_hh09.dat'  V15   -ASCII
V16 = 0.119e-3 .*(K16 .^1.231);
V16(find(V16>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V16_hh09.dat'  V16   -ASCII
V17 = 0.119e-3 .*(K17 .^1.231);
V17(find(V17>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V17_hh09.dat'  V17   -ASCII
V18 = 0.119e-3 .*(K18 .^1.231);
V18(find(V18>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V18_hh09.dat'  V18   -ASCII
V19 = 0.119e-3 .*(K19 .^1.231);
V19(find(V19>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V19_hh09.dat'  V19   -ASCII
V20 = 0.119e-3 .*(K20 .^1.231);
V20(find(V20>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V20_hh09.dat'  V20   -ASCII
% V21 = 0.119e-3 .*(K21 .^1.231);
% V21(find(V21>0.0002)) = NaN;
% save 'C:\MacKay\Masters\data\hhour\V21_hh09.dat'  V21   -ASCII
V22 = 0.119e-3 .*(K22 .^1.231);
V22(find(V22>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V22_hh09.dat'  V22   -ASCII
V23 = 0.119e-3 .*(K23 .^1.231);
V23(find(V23>0.0002)) = NaN;
save 'C:\MacKay\Masters\data\hhour\V23_hh09.dat'  V23   -ASCII

save 'C:/MacKay/multi/dt1_cleaned_raw.dat' dt1 -ASCII
save 'C:/MacKay/multi/golden_dt1.dat' golden_dt1 -ASCII
save 'C:/MacKay/multi/K1.dat'  K1 -ASCII
save 'C:/MacKay/multi/V1.dat'  V1 -ASCII

[V1_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V1', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V1_fixed_hh09.dat'  V1_fixed_hh09   -ASCII
[V2_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V2', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V2_fixed_hh09.dat'  V2_fixed_hh09   -ASCII
[V3_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V3', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V3_fixed_hh09.dat'  V3_fixed_hh09   -ASCII
[V4_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V4', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V4_fixed_hh09.dat'  V4_fixed_hh09   -ASCII
[V5_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V5', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V5_fixed_hh09.dat'  V5_fixed_hh09   -ASCII
[V6_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V6', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V6_fixed_hh09.dat'  V6_fixed_hh09   -ASCII
[V7_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V7', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V7_fixed_hh09.dat'  V7_fixed_hh09   -ASCII
[V8_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V8', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V8_fixed_hh09.dat'  V8_fixed_hh09   -ASCII
[V9_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V9', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V9_fixed_hh09.dat'  V9_fixed_hh09   -ASCII
[V10_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V10', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V10_fixed_hh09.dat'  V10_fixed_hh09   -ASCII
[V11_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V11', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V11_fixed_hh09.dat'  V11_fixed_hh09   -ASCII
[V12_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V12', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V12_fixed_hh09.dat'  V12_fixed_hh09   -ASCII
[V13_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V13', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V13_fixed_hh09.dat'  V13_fixed_hh09   -ASCII
[V14_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V14', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V14_fixed_hh09.dat'  V14_fixed_hh09   -ASCII
[V15_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V15', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V15_fixed_hh09.dat'  V15_fixed_hh09   -ASCII
[V16_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V16', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V16_fixed_hh09.dat'  V16_fixed_hh09   -ASCII
[V17_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V17', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V17_fixed_hh09.dat'  V17_fixed_hh09   -ASCII
[V18_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V18', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V18_fixed_hh09.dat'  V18_fixed_hh09   -ASCII
[V19_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V19', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V19_fixed_hh09.dat'  V19_fixed_hh09   -ASCII
[V20_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V20', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V20_fixed_hh09.dat'  V20_fixed_hh09
[V22_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V22', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V22_fixed_hh09.dat'  V22_fixed_hh09
[V23_fixed_hh09] = mcm_CPEC_outlier_removal('TP39', V23', 30, 'ET');
save 'C:\MacKay\Masters\data\hhour\model\V23_fixed_hh09.dat'  V23_fixed_hh09
close all;

figure('Name','V');
hold on;
plot(V1_fixed_hh09,'b');
set(gca,'box','on');
title 'Sap FLow Velocity (m/hh)';

%% Sap Flow Calculation (F)

F1 = ((sw1).*(V1_fixed_hh09).*1800)'; 
save 'C:\MacKay\Masters\data\hhour\sf1_hh09.dat'  F1   -ASCII
F2 = ((sw2).*(V2_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf2_hh09.dat'  F2   -ASCII
F3 = ((sw3).*(V3_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf3_hh09.dat'  F3   -ASCII
F4 = ((sw4).*(V4_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf4_hh09.dat'  F4   -ASCII
F5 = ((sw5).*(V5_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf5_hh09.dat'  F5   -ASCII
F6 = ((sw6).*(V6_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf6_hh09.dat'  F6   -ASCII
F7 = ((sw7).*(V7_fixed_hh09).*1800)'; 
save 'C:\MacKay\Masters\data\hhour\sf7_hh09.dat'  F7   -ASCII
F8 = ((sw8).*(V8_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf8_hh09.dat'  F8   -ASCII
F9 = ((sw9).*(V9_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf9_hh09.dat'  F9   -ASCII
F10 = ((sw10).*(V10_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf10_hh09.dat'  F10   -ASCII
F11 = ((sw11).*(V11_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf11_hh09.dat'  F11   -ASCII
F12 = ((sw12).*(V12_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf12_hh09.dat'  F12   -ASCII
F13 = ((sw13).*(V13_fixed_hh09).*1800)'; 
save 'C:\MacKay\Masters\data\hhour\sf13_hh09.dat'  F13   -ASCII
F14 = ((sw14).*(V14_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf14_hh09.dat'  F14   -ASCII
F15 = ((sw15).*(V15_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf15_hh09.dat'  F15   -ASCII
F16 = ((sw16).*(V16_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf16_hh09.dat'  F16   -ASCII
F17 = ((sw17).*(V17_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf17_hh09.dat'  F17   -ASCII
F18 = ((sw18).*(V18_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf18_hh09.dat'  F18   -ASCII
F19 = ((sw19).*(V19_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf19_hh09.dat'  F19   -ASCII
F20 = ((sw20).*(V20_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf20_hh09.dat'  F20   -ASCII
%F21 = ((sw21).*(V21).*1800);
%save 'C:\MacKay\Masters\data\hhour\sf21_hh09.dat'  F21   -ASCII
F22_all = ((sw22).*(V22_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf22_all_hh09.dat'  F22_all   -ASCII
F23_all = ((sw23).*(V23_fixed_hh09).*1800)';
save 'C:\MacKay\Masters\data\hhour\sf23_all_hh09.dat'  F23_all   -ASCII


%%  Daily Sum of Sap Flow
% Daily total sapflow from each tree (kg/day)
dt = (decdoy_00(1:length(F1)));
[F1sum,F1mean,TimeX99] = integzBC1(dt(~isnan(F1)),F1(~isnan(F1)),1:length(dt1n),days); F1Sum	=	F1sum'; 
save 'C:\MacKay\Masters\data\daily\sf1_SF_DSum09.dat'  F1sum   -ASCII
[F2sum,F2mean,TimeX99] = integzBC1(dt(~isnan(F2)),F2(~isnan(F2)),1:length(dt2n),days); F2Sum	=	F2sum'; 
save 'C:\MacKay\Masters\data\daily\sf2_SF_DSum09.dat'  F2sum   -ASCII
[F3sum,F3mean,TimeX99] = integzBC1(dt(~isnan(F3)),F3(~isnan(F3)),1:length(dt3n),days); F3Sum	=	F3sum'; 
save 'C:\MacKay\Masters\data\daily\sf3_SF_DSum09.dat'  F3sum   -ASCII
[F4sum,F4mean,TimeX99] = integzBC1(dt(~isnan(F4)),F4(~isnan(F4)),1:length(dt4n),days); F4Sum	=	F4sum';
save 'C:\MacKay\Masters\data\daily\sf4_SF_DSum09.dat'  F4sum   -ASCII
[F5sum,F5mean,TimeX99] = integzBC1(dt(~isnan(F5)),F5(~isnan(F5)),1:length(dt5n),days); F5Sum	=	F5sum';
save 'C:\MacKay\Masters\data\daily\sf5_SF_DSum09.dat'  F5sum   -ASCII
[F6sum,F6mean,TimeX99] = integzBC1(dt(~isnan(F6)),F6(~isnan(F6)),1:length(dt6n),days); F6Sum	=	F6sum'; 
save 'C:\MacKay\Masters\data\daily\sf6_SF_DSum09.dat'  F6sum   -ASCII
[F7sum,F7mean,TimeX99] = integzBC1(dt(~isnan(F7)),F7(~isnan(F7)),1:length(dt7n),days); F7Sum	=	F7sum';
save 'C:\MacKay\Masters\data\daily\sf7_SF_DSum09.dat'  F7sum   -ASCII
[F8sum,F8mean,TimeX99] = integzBC1(dt(~isnan(F8)),F8(~isnan(F8)),1:length(dt8n),days); F8Sum	=	F8sum';
save 'C:\MacKay\Masters\data\daily\sf8_SF_DSum09.dat'  F8sum   -ASCII
[F9sum,F9mean,TimeX99] = integzBC1(dt(~isnan(F9)),F9(~isnan(F9)),1:length(dt9n),days); F9Sum	=	F9sum';
save 'C:\MacKay\Masters\data\daily\sf9_SF_DSum09.dat'  F9sum   -ASCII
[F10sum,F10mean,TimeX99] = integzBC1(dt(~isnan(F10)),F10(~isnan(F10)),1:length(dt10n),days); F10Sum	=	F10sum'; 
save 'C:\MacKay\Masters\data\daily\sf10_SF_DSum09.dat'  F10sum   -ASCII
[F11sum,F11mean,TimeX99] = integzBC1(dt(~isnan(F11)),F11(~isnan(F11)),1:length(dt11n),days); F11Sum	=	F11sum';
save 'C:\MacKay\Masters\data\daily\sf11_SF_DSum09.dat'  F11sum   -ASCII
[F12sum,F12mean,TimeX99] = integzBC1(dt(~isnan(F12)),F12(~isnan(F12)),1:length(dt12n),days); F12Sum	=	F12sum';
save 'C:\MacKay\Masters\data\daily\sf12_SF_DSum09.dat'  F12sum   -ASCII
[F13sum,F13mean,TimeX99] = integzBC1(dt(~isnan(F13)),F13(~isnan(F13)),1:length(dt13n),days); F13Sum	=	F13sum';
save 'C:\MacKay\Masters\data\daily\sf13_SF_DSum09.dat'  F13sum   -ASCII
[F14sum,F14mean,TimeX99] = integzBC1(dt(~isnan(F14)),F14(~isnan(F14)),1:length(dt14n),days); F14Sum	=	F14sum';
save 'C:\MacKay\Masters\data\daily\sf14_SF_DSum09.dat'  F14sum   -ASCII
[F15sum,F15mean,TimeX99] = integzBC1(dt(~isnan(F15)),F15(~isnan(F15)),1:length(dt15n),days); F15Sum	=	F15sum';
save 'C:\MacKay\Masters\data\daily\sf15_SF_DSum09.dat'  F15sum   -ASCII
[F16sum,F16mean,TimeX99] = integzBC1(dt(~isnan(F16)),F16(~isnan(F16)),1:length(dt16n),days); F16Sum	=	F16sum';
save 'C:\MacKay\Masters\data\daily\sf16_SF_DSum09.dat'  F16sum   -ASCII
[F17sum,F17mean,TimeX99] = integzBC1(dt(~isnan(F17)),F17(~isnan(F17)),1:length(dt17n),days); F17Sum	=	F17sum';
save 'C:\MacKay\Masters\data\daily\sf17_SF_DSum09.dat'  F17sum   -ASCII
[F18sum,F18mean,TimeX99] = integzBC1(dt(~isnan(F18)),F18(~isnan(F18)),1:length(dt18n),days); F18Sum	=	F18sum';
save 'C:\MacKay\Masters\data\daily\sf18_SF_DSum09.dat'  F18sum   -ASCII
[F19sum,F19mean,TimeX99] = integzBC1(dt(~isnan(F19)),F19(~isnan(F19)),1:length(dt19n),days); F19Sum	=	F19sum';
save 'C:\MacKay\Masters\data\daily\sf19_SF_DSum09.dat'  F19sum   -ASCII
[F20sum,F20mean,TimeX99] = integzBC1(dt(~isnan(F20)),F20(~isnan(F20)),1:length(dt20n),days); F20Sum	=	F20sum';
save 'C:\MacKay\Masters\data\daily\sf20_SF_DSum09.dat'  F20sum   -ASCII
%[F21sum,F21mean,TimeX99] = integzBC1(dt(~isnan(F21)),F21(~isnan(F21)),1:length(dt21n),days); F21Sum	=	F21sum';
%save 'C:\MacKay\Masters\data\daily\sf21_SF_DSum09.dat'  F21sum   -ASCII
[F22sum,F22mean,TimeX99] = integzBC1(dt(~isnan(F22_all)),F22_all(~isnan(F22_all)),1:length(dt22n),days); F22Sum	=	F22sum';
save 'C:\MacKay\Masters\data\daily\sf22_SF_DSum09.dat'  F22sum   -ASCII
[F23sum,F23mean,TimeX99] = integzBC1(dt(~isnan(F23_all)),F23_all(~isnan(F23_all)),1:length(dt23n),days); F23Sum	=	F23sum';
save 'C:\MacKay\Masters\data\daily\sf23_SF_DSum09.dat'  F23sum   -ASCII
% [F24sum,F24mean,TimeX99] = integzBC1(dt(~isnan(F24)),F24(~isnan(F24)),1:length(dt24n),days); F24Sum	=	F24sum';
% save 'C:\MacKay\Masters\data\daily\sf24_SF_DSum09.dat'  F24sum   -ASCII

%% Quick Check
figure('Name','F_plot test');
hold on;
plot(F1sum,'r');
plot(F2sum,'b');
plot(F10sum,'g');
set(gca,'box','on');
legend('F1','F2','F10');

%%  ************  JAY:  THIS IS AS FAR AS WE SHOULD GO.  TO CALCULATE
%%  TRANSPIRATION, YOU NEED TO USE THE NUMBER OF TREES WITHIN A KNOWN AREA,
%%  AND THAT MIGHT CHANGE, BASED ON THE QUESTION BEING ASKED (FOR INSTANCE,
%%  SOMEONE MIGHT USE ALL 22 TREES AND CALL THE AREA SOMETHING BIGGER THAN
%%  WHAT I'VE DONE PLOT BY PLOT.  FROM THIS POINT ON, THE DATA IS MORE
%%  QUESTION SPECIFIC, BUT I'VE INCLUDED IT TO SHOW THE CALCULATION OF
%%  AREA SAPFLOW.  PLEASE SEE BELOW THIS SECTION TO GET MORE RELEVANT INFORMATION THAT SHOULD BE INCLUDED**************************












%% *****  UNNECESSARY - START *********
%%  Calculate Plot-scale Sapflow as an AVERAGE between all trees in the
%%  plot:  this is to give an AVERAGE water loss.

for i = 1:365;
    echo off;
    x = [F1sum(i),F2sum(i),F3sum(i),F4sum(i),F5sum(i)];
    y = [F6sum(i),F7sum(i),F8sum(i),F9sum(i),F10sum(i)];
    a = [F22sum(i),F23sum(i)];
    z = [F11sum(i),F12sum(i),F13sum(i),F14sum(i),F15sum(i)];
    v = [F16sum(i),F17sum(i),F18sum(i),F19sum(i),F20sum(i)];
    TTsf_ref(i) = nanmean(x);
    TTsf_dro(i) = nanmean(y);
    TTsf_dro2(i) = nanmean(a);
    TTsf_fal(i) = nanmean(z);
    TTsf_thi(i) = nanmean(v);
end;

save 'C:\MacKay\Masters\data\daily\TTsf_ref_DSum09.dat'  TTsf_ref   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_dro_DSum09.dat'  TTsf_dro   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_dro2_DSum09.dat'  TTsf_dro2   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_fal_DSum09.dat'  TTsf_fal   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_thi_DSum09.dat'  TTsf_thi   -ASCII

%% Run an overall average (Drought v.s. Ref.)  --  NOT plot scaled.
for i = 1:365;
    x = [F1sum(i),F2sum(i),F3sum(i),F4sum(i),F5sum(i),F11sum(i),F12sum(i),F13sum(i),F14sum(i),F15sum(i),F16sum(i),F17sum(i),F18sum(i),F19sum(i),F20sum(i)];
    y = [F6sum(i),F7sum(i),F8sum(i),F9sum(i),F10sum(i),F22sum(i),F23sum(i)];
    TTsf_reference(i) = nanmean(x);
    TTsf_drought(i) = nanmean(y);
 end;
 
save 'C:\MacKay\Masters\data\daily\TTsf_reference_DSum09.dat'  TTsf_reference   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_drought_DSum09.dat'   TTsf_drought   -ASCII
 
 for i = 1:365;
    y = [F6sum(i),F7sum(i),F8sum(i),F9sum(i),F10sum(i),F22sum(i),F23sum(i)];
    TTsf_drought_v3(i) = nanmean(y);
 end;

 save 'C:\MacKay\Masters\data\daily\TTsf_drought_v3_DSum09.dat'   TTsf_drought_v3   -ASCII
 
%% some cleaning:  There could still be spikes at this stage - this removes
%% some of the difficult ones.
 
ind = find(TTsf_drought_v3 >= 0.2); TTsf_drought_v3(ind)=[NaN];
ind = find(TTsf_ref >= 0.2); TTsf_ref(ind)=[NaN];
ind = find(TTsf_fal >= 0.2); TTsf_fal(ind)=[NaN];
ind = find(TTsf_thi >= 0.2); TTsf_thi(ind)=[NaN];

save 'C:\MacKay\Masters\data\daily\TTsf_reference_cleaned_DSum09.dat'  TTsf_reference   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_drought_cleaned_DSum09.dat'   TTsf_drought   -ASCII
save 'C:\MacKay\Masters\data\daily\TTsf_drought_v3_cleaned_DSum09.dat'   TTsf_drought_v3   -ASCII


%%  Plot stuff out to check it. 

figure('Name','TTsf_all');clf;
hold on;
plot(TTsf_ref, 'r.-');
plot(TTsf_dro, 'b.-');
plot(TTsf_dro2, 'y.-');
plot(TTsf_fal,'g.-');
plot(TTsf_thi,'m.-');
legend ('Reference', 'Drought', 'Drought_new', 'Fall', 'Thinned');
title 'check 2009 daily ave';

figure('Name', 'TTsf_all2');clf;
hold on;
plot(TTsf_ref, 'r.-');
plot(TTsf_drought_v3, 'b.-');
plot(TTsf_fal,'g.-');
plot(TTsf_thi,'m.-');
legend ('Reference', 'Drought', 'Fall', 'Thinned');
title 'daily average of summed values';


figure('Name','TTsf dro and ref');clf;
hold on;
plot(TTsf_reference, 'r.-');
plot(TTsf_drought, 'b.-');
legend ('Reference', 'Drought', 'Drought_new');
title 'check 2009 daily ave';

figure('Name', 'F (sf) at each dbh');clf;
subplot (2,2,1)
hold on;
plot(F1sum, 'r.-');
plot(F2sum, 'b.-');
plot(F3sum, 'g.-');
plot(F4sum, 'm.-');
plot(F5sum, 'c.-');
title 'Reference';
axis ([0 365 0 0.5]);
legend ('36.4cm (SF1)', '26.2cm (SF2)', '37cm (SF3)', '47.3cm (SF4)', '41.45cm (SF5)');

subplot (2,2,2)
hold on;
plot(F6sum, 'r.-');
plot(F7sum, 'b.-');
plot(F8sum, 'g.-');
plot(F9sum, 'm.-');
plot(F10sum, 'c.-');
plot(F22sum, 'k.-');
plot(F23sum, 'y.-');
title 'Drought';
axis ([0 365 0 0.5]);
legend ('43.4cm (SF6)', '37.5cm (SF7)', '33.5cm (SF8)', '30.9cm (SF9)', '40cm (SF10)', '28cm (SF23)', '40.4cm (SF24)');

subplot (2,2,3)
hold on;
plot(F11sum, 'r.-');
plot(F12sum, 'b.-');
plot(F13sum, 'g.-');
plot(F14sum, 'm.-');
plot(F15sum, 'c.-');
title 'Fall Drought';
axis ([0 365 0 0.5]);
legend ('31.5cm (SF11)', '37.7cm (SF12)', '54.4cm (SF13)', '44.7cm (SF14)', '36.3cm (SF15)');

subplot (2,2,4)
hold on;
plot(F16sum, 'r.-');
plot(F17sum, 'b.-');
plot(F18sum, 'g.-');
plot(F19sum, 'm.-');
plot(F20sum, 'c.-');
title 'thinned';
legend ('43.7cm (SF16)', '45.8cm (SF17)', '35.5cm (SF18)', '38.7cm (SF19)', '37.1cm (SF20)');
axis ([0 365 0 0.5]);

%% ********************UNNECESSARY END****************************





%%  Transpiration calculation -  we are now back onto somewhat relevant
%%  information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transpiration following Wilson et al., 2001

%% (Manual) Ratio of sapwood area (m2) to tree wood area (m2) - unitless
%% (Yes, i know we are jumping around a bit...)

sw_w1 = sw1/w1; 
sw_w2 = sw2/w2;
sw_w3 = sw3/w3;
sw_w4 = sw4/w4;
sw_w5 = sw5/w5;
sw_w6 = sw6/w6;
sw_w7 = sw7/w7; 
sw_w8 = sw8/w8;
sw_w9 = sw9/w9;
sw_w10 = sw10/w10;
sw_w11 = sw11/w11;
sw_w12 = sw12/w12;
sw_w13 = sw13/w13; 
sw_w14 = sw14/w14;
sw_w15 = sw15/w15;
sw_w16 = sw16/w16;
sw_w17 = sw17/w17;
sw_w18 = sw18/w18;
sw_w19 = sw19/w19; 
sw_w20 = sw20/w20;
sw_w22 = sw22/w22;
sw_w23 = sw23/w23;


% Sapwood area : ground area  - As:Ag
SV1 = BA * sw_w1;
SV2 = BA * sw_w2;
SV3 = BA * sw_w3;
SV4 = BA * sw_w4;
SV5 = BA * sw_w5;
SV6 = BA * sw_w6;
SV7 = BA * sw_w7;
SV8 = BA * sw_w8;
SV9 = BA * sw_w9;
SV10 = BA * sw_w10;
SV11 = BA * sw_w11;
SV12 = BA * sw_w12;
SV13 = BA * sw_w13;
SV14 = BA * sw_w14;
SV15 = BA * sw_w15;
SV16 = BA * sw_w16;
SV17 = BA * sw_w17;
SV18 = BA * sw_w18;
SV19 = BA * sw_w19;
SV20 = BA * sw_w20;
SV23 = BA * sw_w23;
SV22 = BA * sw_w22;


%% Transpiration per unit groud area (kg/m2/s)  PER TREE

T1 = (dw .* V1) .* (SV1);
T2 = (dw .* V2) .* (SV2);
T3 = (dw .* V3) .* (SV3);
T4 = (dw .* V4) .* (SV4);
T5 = (dw .* V5) .* (SV5);
T6 = (dw .* V6) .* (SV6);
T7 = (dw .* V7) .* (SV7);
T8 = (dw .* V8) .* (SV8);
T9 = (dw .* V9) .* (SV9);
T10 = (dw .* V10) .* (SV10);
T11 = (dw .* V11) .* (SV11);
T12 = (dw .* V12) .* (SV12);
T13 = (dw .* V13) .* (SV13);
T14 = (dw .* V14) .* (SV14);
T15 = (dw .* V15) .* (SV15);
T16 = (dw .* V16) .* (SV16);
T17 = (dw .* V17) .* (SV17);
T18 = (dw .* V18) .* (SV18);
T19 = (dw .* V19) .* (SV19);
T20 = (dw .* V20) .* (SV20);
T22 = (dw .* V22) .* (SV22);
T23 = (dw .* V23) .* (SV23);


%% Transpiration per unit groud area (mm/h-hour)  ** PER TREE
Thh1 = (T1 .* 1800); %Thh1(14034:15049) = Thh1(14034:15049) - 0.051251;
Thh2 = T2 .* 1800;
Thh3 = T3 .* 1800;
Thh4 = T4 .* 1800;
Thh5 = T5 .* 1800; %Thh5(14034:15049) = Thh5(14034:15049) - 0.01266;
Thh6 = (T6 .* 1800); %Thh6(6574:9120) = Thh6(6574:9120) - 0.021508; Thh6(9120:9478) = Thh6(9120:9478) - 0.008303; Thh6(9544:11322) = Thh6(9544:11322) - 0.02291; Thh6(11323:12264) = Thh6(11323:12264) - 0.021508; Thh6(12370:13978) = Thh6(12370:13978) - 0.03944;
Thh7 = T7 .* 1800; 
Thh8 = T8 .* 1800;
Thh9 = T9 .* 1800;
Thh10 = T10 .* 1800;
Thh11 = T11 .* 1800; 
Thh12 = (T12 .* 1800);
Thh13 = T13 .* 1800; 
Thh14 = T14 .* 1800;
Thh15 = T15 .* 1800;
Thh16 = T16 .* 1800;
Thh17 = T17 .* 1800; 
Thh18 = (T18 .* 1800); 
Thh19 = T19 .* 1800; 
Thh20 = T20 .* 1800;
Thh22 = T22 .* 1800;
Thh23 = T23 .* 1800;

%%  Some cleaning for some spikes - somewhat easier to detect at this stage
%%  because the values are more relateable.
 
ind = find(Thh1 >= 0.15); Thh1(ind)=[NaN];
ind = find(Thh2 >= 0.15); Thh2(ind)=[NaN];
ind = find(Thh3 >= 0.15); Thh3(ind)=[NaN];
ind = find(Thh4 >= 0.15); Thh4(ind)=[NaN];
ind = find(Thh5 >= 0.15); Thh5(ind)=[NaN];
ind = find(Thh6 >= 0.25); Thh6(ind)=[NaN];
ind = find(Thh7 >= 0.25); Thh7(ind)=[NaN];
ind = find(Thh8 >= 0.25); Thh8(ind)=[NaN];
ind = find(Thh9 >= 0.15); Thh9(ind)=[NaN];
ind = find(Thh10 >= 0.15); Thh10(ind)=[NaN];
ind = find(Thh11 >= 0.15); Thh11(ind)=[NaN];
ind = find(Thh12 >= 0.15); Thh12(ind)=[NaN];
ind = find(Thh13 >= 0.15); Thh13(ind)=[NaN];
ind = find(Thh14 >= 0.15); Thh14(ind)=[NaN];
ind = find(Thh15 >= 0.15); Thh15(ind)=[NaN];
ind = find(Thh16 >= 0.15); Thh16(ind)=[NaN];
ind = find(Thh17 >= 0.15); Thh17(ind)=[NaN];
ind = find(Thh18 >= 0.15); Thh18(ind)=[NaN];
ind = find(Thh19 >= 0.15); Thh19(ind)=[NaN];
ind = find(Thh20 >= 0.15); Thh20(ind)=[NaN];
ind = find(Thh22 >= 0.15); Thh22(ind)=[NaN];
ind = find(Thh23 >= 0.15); Thh23(ind)=[NaN];


ind = find(Thh1 < 0); Thh1(ind)=[0];
ind = find(Thh2 < 0); Thh2(ind)=[0];
ind = find(Thh3 < 0); Thh3(ind)=[0];
ind = find(Thh4 < 0); Thh4(ind)=[0];
ind = find(Thh5 < 0); Thh5(ind)=[0];
ind = find(Thh6 < 0); Thh6(ind)=[0];
ind = find(Thh7 < 0); Thh7(ind)=[0];
ind = find(Thh8 < 0); Thh8(ind)=[0];
ind = find(Thh9 < 0); Thh9(ind)=[0];
ind = find(Thh10 < 0); Thh10(ind)=[0];
ind = find(Thh11 < 0); Thh11(ind)=[0];
ind = find(Thh12 < 0); Thh12(ind)=[0];
ind = find(Thh13 < 0); Thh13(ind)=[0];
ind = find(Thh14 < 0); Thh14(ind)=[0];
ind = find(Thh15 < 0); Thh15(ind)=[0];
ind = find(Thh16 < 0); Thh16(ind)=[0];
ind = find(Thh17 < 0); Thh17(ind)=[0];
ind = find(Thh18 < 0); Thh18(ind)=[0];
ind = find(Thh19 < 0); Thh19(ind)=[0];
ind = find(Thh20 < 0); Thh20(ind)=[0];
ind = find(Thh22 < 0); Thh22(ind)=[0];
ind = find(Thh23 < 0); Thh23(ind)=[0];


ind = find(Thh1(1:4068) >= 0.05); Thh1(ind)=[NaN];
ind = find(Thh2(1:4068) >= 0.05); Thh2(ind)=[NaN];
ind = find(Thh3(1:4068) >= 0.05); Thh3(ind)=[NaN];
ind = find(Thh4(1:4068) >= 0.05); Thh4(ind)=[NaN];
ind = find(Thh5(1:4068) >= 0.05); Thh5(ind)=[NaN];
ind = find(Thh6(1:4068) >= 0.05); Thh6(ind)=[NaN];
ind = find(Thh7(1:4068) >= 0.05); Thh7(ind)=[NaN];
ind = find(Thh8(1:4068) >= 0.05); Thh8(ind)=[NaN];
ind = find(Thh9(1:4068) >= 0.05); Thh9(ind)=[NaN];
ind = find(Thh10(1:4068) >= 0.05); Thh10(ind)=[NaN];
ind = find(Thh11(1:4068) >= 0.05); Thh11(ind)=[NaN];
ind = find(Thh12(1:4068) >= 0.05); Thh12(ind)=[NaN];
ind = find(Thh13(1:4068) >= 0.05); Thh13(ind)=[NaN];
ind = find(Thh14(1:4068) >= 0.05); Thh14(ind)=[NaN];
ind = find(Thh15(1:4068) >= 0.05); Thh15(ind)=[NaN];
ind = find(Thh16(1:4068) >= 0.05); Thh16(ind)=[NaN];
ind = find(Thh17(1:4068) >= 0.05); Thh17(ind)=[NaN];
ind = find(Thh18(1:4068) >= 0.05); Thh18(ind)=[NaN];
ind = find(Thh19(1:4068) >= 0.05); Thh19(ind)=[NaN];
ind = find(Thh20(1:4068) >= 0.05); Thh20(ind)=[NaN];
ind = find(Thh22(1:4068) >= 0.05); Thh21(ind)=[NaN];
ind = find(Thh23(1:4068) >= 0.05); Thh22(ind)=[NaN];

%%  Remember, ET is the E(subscript)T and it's transpiration - Evaporation
%%  component that is accounted for via Transpiration  (this data is in mm
%%  hh^-1 at this stage)

 save 'C:\MacKay\Masters\data\hhour\ET1_cleaned_hh09.dat'   Thh1   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET2_cleaned_hh09.dat'   Thh2   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET3_cleaned_hh09.dat'   Thh3   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET4_cleaned_hh09.dat'   Thh4   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET5_cleaned_hh09.dat'   Thh5   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET6_cleaned_hh09.dat'   Thh6   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET7_cleaned_hh09.dat'   Thh7   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET8_cleaned_hh09.dat'   Thh8   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET9_cleaned_hh09.dat'   Thh9   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET10_cleaned_hh09.dat'   Thh10   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET11_cleaned_hh09.dat'   Thh11   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET12_cleaned_hh09.dat'   Thh12   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET13_cleaned_hh09.dat'   Thh13   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET14_cleaned_hh09.dat'   Thh14   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET15_cleaned_hh09.dat'   Thh15   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET16_cleaned_hh09.dat'   Thh16   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET17_cleaned_hh09.dat'   Thh17   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET18_cleaned_hh09.dat'   Thh18   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET19_cleaned_hh09.dat'   Thh19   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET20_cleaned_hh09.dat'   Thh20   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET21_cleaned_hh09.dat'   Thh21   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET22_cleaned_hh09.dat'   Thh22   -ASCII
 save 'C:\MacKay\Masters\data\hhour\ET23_cleaned_hh09.dat'   Thh23   -ASCII


%%  *****************  START OF UNNECESSARY *******************************
 
for i = 1:17520;
    echo off;
    x = [Thh1(i),Thh2(i),Thh3(i),Thh4(i),Thh5(i)];%Thh5(i),;
    y = [Thh6(i),Thh7(i),Thh8(i),Thh9(i),Thh10(i)];
    a = [Thh22(i),Thh23(i)];
    b = [Thh7(i),Thh8(i),Thh9(i),Thh10(i),Thh22(i),Thh23(i)]; %Thh6(i)
    z = [Thh11(i),Thh12(i),Thh13(i),Thh14(i),Thh15(i)];
    v = [Thh16(i),Thh17(i),Thh18(i),Thh19(i),Thh20(i)];
    Thhavg_ref(i) = nanmean(x);
    Thhavg_dro(i) = nanmean(y);
    Thhavg_dro2(i) = nanmean(a);
    Thhavg_dro3(i) = nanmean(b);
    Thhavg_fal(i) = nanmean(z);
    Thhavg_thi(i) = nanmean(v);
end;

for i = 1:17520;
    echo off;
    x = [Thh1(i),Thh3(i),Thh4(i),Thh5(i)];%Thh5(i),;
    y = [Thh6(i),Thh9(i),Thh10(i),Thh22(i),Thh23(i)];
    z = [Thh11(i),Thh12(i),Thh13(i),Thh14(i),Thh15(i)];
    v = [Thh16(i),Thh17(i),Thh18(i),Thh19(i),Thh20(i)];
    Thhavg_ref_v2(i) = nanmean(x);
    Thhavg_dro_v2(i) = nanmean(y);
    Thhavg_fal_v2(i) = nanmean(z);
    Thhavg_thi_v2(i) = nanmean(v);
end;


%%  Repeat of whats up top.

ET_mm_hh_Thh1 = Thh1;
ET_mm_hh_Thh2 = Thh2;
ET_mm_hh_Thh3 = Thh3;
ET_mm_hh_Thh4 = Thh4;
ET_mm_hh_Thh5 = Thh5;
ET_mm_hh_Thh6 = Thh6;
ET_mm_hh_Thh7 = Thh7;
ET_mm_hh_Thh8 = Thh8;
ET_mm_hh_Thh9 = Thh9;
ET_mm_hh_Thh10 = Thh10;
ET_mm_hh_Thh11 = Thh11;
ET_mm_hh_Thh12 = Thh12;
ET_mm_hh_Thh13 = Thh13;
ET_mm_hh_Thh14 = Thh14;
ET_mm_hh_Thh15 = Thh15;
ET_mm_hh_Thh16 = Thh16;
ET_mm_hh_Thh17 = Thh17;
ET_mm_hh_Thh18 = Thh18;
ET_mm_hh_Thh19 = Thh19;
ET_mm_hh_Thh20 = Thh20;
ET_mm_hh_Thh22 = Thh22;
ET_mm_hh_Thh23 = Thh23;

Thh1 = Thh1';
Thh2 = Thh2';
Thh3 = Thh3';
Thh4 = Thh4';
Thh5 = Thh5';
Thh6 = Thh6';
Thh7 = Thh7';
Thh8 = Thh8';
Thh9 = Thh9';
Thh10 = Thh10';
Thh11 = Thh11';
Thh12 = Thh12';
Thh13 = Thh13';
Thh14 = Thh14';
Thh15 = Thh15';
Thh16 = Thh16';
Thh17 = Thh17';
Thh18 = Thh18';
Thh19 = Thh19';
Thh20 = Thh20';
Thh22 = Thh22';
Thh23 = Thh23';





ET_mm_hh_ref = Thhavg_ref';
ET_mm_hh_dro = Thhavg_dro';
ET_mm_hh_dro2 = Thhavg_dro2';
ET_mm_hh_dro3 = Thhavg_dro3';
ET_mm_hh_fal = Thhavg_fal';
ET_mm_hh_thi = Thhavg_thi';

ET_mm_hh_ref_v2 = Thhavg_ref_v2';
ET_mm_hh_dro_v2 = Thhavg_dro_v2';
ET_mm_hh_fal_v2 = Thhavg_fal_v2';
ET_mm_hh_thi_v2 = Thhavg_thi_v2';


save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_ref_09.dat' ET_mm_hh_ref -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_dro_09.dat' ET_mm_hh_dro -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_dro2_09.dat' ET_mm_hh_dro2 -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_dro3_09.dat' ET_mm_hh_dro3 -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_fal_09.dat' ET_mm_hh_fal -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_thi_09.dat' ET_mm_hh_thi -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_ref_v2_09.dat' ET_mm_hh_ref_v2 -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_dro_v2_09.dat' ET_mm_hh_dro_v2 -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_fal_v2_09.dat' ET_mm_hh_fal_v2 -ASCII
save 'C:\MacKay\Masters\data\hhour\ET_mm_hh_thi_v2_09.dat' ET_mm_hh_thi_v2 -ASCII

figure(2);
hold on;
plot(ET_mm_hh_ref,'b');
plot(ET_mm_hh_dro,'r');
plot(ET_mm_hh_dro2,'y');
plot(ET_mm_hh_fal,'c');
plot(ET_mm_hh_thi,'m');
legend ('ref', 'dro', 'dro2', 'fal', 'thi');
title 'check 2009 half hours';

figure(12);
hold on;
plot(ET_mm_hh_ref_v2,'b');
plot(ET_mm_hh_dro_v2,'r');
plot(ET_mm_hh_fal_v2,'c');
plot(ET_mm_hh_thi_v2,'m');
legend ('ref', 'dro', 'fal', 'thi');
title 'check 2009 half hours v2';



%%  Calculating the daily sum of Transpiration

[t_ref_1, avg_ref_1, ET_mm_ref_1, max_ref_1, min_ref_1, std_ref_1, n_ref_1] = Dailystats_new(tv, ET_mm_hh_Thh1, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref1_DSum09.dat' ET_mm_ref_1 -ASCII
[t_ref_2, avg_ref_2, ET_mm_ref_2, max_ref_2, min_ref_2, std_ref_2, n_ref_2] = Dailystats_new(tv, ET_mm_hh_Thh2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref2_DSum09.dat' ET_mm_ref_2 -ASCII
[t_ref_3, avg_ref_3, ET_mm_ref_3, max_ref_3, min_ref_3, std_ref_3, n_ref_3] = Dailystats_new(tv, ET_mm_hh_Thh3, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref3_DSum09.dat' ET_mm_ref_3 -ASCII
[t_ref_4, avg_ref_4, ET_mm_ref_4, max_ref_4, min_ref_4, std_ref_4, n_ref_4] = Dailystats_new(tv, ET_mm_hh_Thh4, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref4_DSum09.dat' ET_mm_ref_4 -ASCII
[t_ref_5, avg_ref_5, ET_mm_ref_5, max_ref_5, min_ref_5, std_ref_5, n_ref_5] = Dailystats_new(tv, ET_mm_hh_Thh5, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref5_DSum09.dat' ET_mm_ref_5 -ASCII

[t_ref_6, avg_ref_6, ET_mm_ref_6, max_ref_6, min_ref_6, std_ref_6, n_ref_6] = Dailystats_new(tv, ET_mm_hh_Thh6, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref6_DSum09.dat' ET_mm_ref_6 -ASCII
[t_ref_7, avg_ref_7, ET_mm_ref_7, max_ref_7, min_ref_7, std_ref_7, n_ref_7] = Dailystats_new(tv, ET_mm_hh_Thh7, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref7_DSum09.dat' ET_mm_ref_7 -ASCII
[t_ref_8, avg_ref_8, ET_mm_ref_8, max_ref_8, min_ref_8, std_ref_8, n_ref_8] = Dailystats_new(tv, ET_mm_hh_Thh8, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref8_DSum09.dat' ET_mm_ref_8 -ASCII
[t_ref_9, avg_ref_9, ET_mm_ref_9, max_ref_9, min_ref_9, std_ref_9, n_ref_9] = Dailystats_new(tv, ET_mm_hh_Thh9, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref9_DSum09.dat' ET_mm_ref_9 -ASCII
[t_ref_10, avg_ref_10, ET_mm_ref_10, max_ref_10, min_ref_10, std_ref_10, n_ref_10] = Dailystats_new(tv, ET_mm_hh_Thh10, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref10_DSum09.dat' ET_mm_ref_10 -ASCII

[t_ref_11, avg_ref_11, ET_mm_ref_11, max_ref_11, min_ref_11, std_ref_11, n_ref_11] = Dailystats_new(tv, ET_mm_hh_Thh11, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref11_DSum09.dat' ET_mm_ref_11 -ASCII
[t_ref_12, avg_ref_12, ET_mm_ref_12, max_ref_12, min_ref_12, std_ref_12, n_ref_12] = Dailystats_new(tv, ET_mm_hh_Thh12, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref12_DSum09.dat' ET_mm_ref_12 -ASCII
[t_ref_13, avg_ref_13, ET_mm_ref_13, max_ref_13, min_ref_13, std_ref_13, n_ref_13] = Dailystats_new(tv, ET_mm_hh_Thh13, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref13_DSum09.dat' ET_mm_ref_13 -ASCII
[t_ref_14, avg_ref_14, ET_mm_ref_14, max_ref_14, min_ref_14, std_ref_14, n_ref_14] = Dailystats_new(tv, ET_mm_hh_Thh14, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref14_DSum09.dat' ET_mm_ref_14 -ASCII
[t_ref_15, avg_ref_15, ET_mm_ref_15, max_ref_15, min_ref_15, std_ref_15, n_ref_15] = Dailystats_new(tv, ET_mm_hh_Thh15, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref15_DSum09.dat' ET_mm_ref_15 -ASCII

[t_ref_16, avg_ref_16, ET_mm_ref_16, max_ref_16, min_ref_16, std_ref_16, n_ref_16] = Dailystats_new(tv, ET_mm_hh_Thh16, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref16_DSum09.dat' ET_mm_ref_16 -ASCII
[t_ref_17, avg_ref_17, ET_mm_ref_17, max_ref_17, min_ref_17, std_ref_17, n_ref_17] = Dailystats_new(tv, ET_mm_hh_Thh17, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref17_DSum09.dat' ET_mm_ref_17 -ASCII
[t_ref_18, avg_ref_18, ET_mm_ref_18, max_ref_18, min_ref_18, std_ref_18, n_ref_18] = Dailystats_new(tv, ET_mm_hh_Thh18, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref18_DSum09.dat' ET_mm_ref_18 -ASCII
[t_ref_19, avg_ref_19, ET_mm_ref_19, max_ref_19, min_ref_19, std_ref_19, n_ref_19] = Dailystats_new(tv, ET_mm_hh_Thh19, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref19_DSum09.dat' ET_mm_ref_19 -ASCII
[t_ref_20, avg_ref_20, ET_mm_ref_20, max_ref_20, min_ref_20, std_ref_20, n_ref_20] = Dailystats_new(tv, ET_mm_hh_Thh20, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref20_DSum09.dat' ET_mm_ref_20 -ASCII

[t_ref_22, avg_ref_22, ET_mm_ref_22, max_ref_22, min_ref_22, std_ref_22, n_ref_22] = Dailystats_new(tv, ET_mm_hh_Thh22, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref22_DSum09.dat' ET_mm_ref_22 -ASCII
[t_ref_23, avg_ref_23, ET_mm_ref_23, max_ref_23, min_ref_23, std_ref_23, n_ref_23] = Dailystats_new(tv, ET_mm_hh_Thh23, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref23_DSum09.dat' ET_mm_ref_23 -ASCII


%%  Plot Specific Daily Sum

[t_ref, avg_ref, ET_mm_ref, max_ref, min_ref, std_ref, n_ref] = Dailystats_new(tv, ET_mm_hh_ref, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref_DSum09.dat' ET_mm_ref -ASCII
[t_dro, avg_dro, ET_mm_dro, max_dro, min_dro, std_dro, n_dro] = Dailystats_new(tv, ET_mm_hh_dro, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_dro_DSum09.dat' ET_mm_dro -ASCII
[t_dro2, avg_dro2, ET_mm_dro2, max_dro2, min_dro2, std_dro2, n_dro2] = Dailystats_new(tv, ET_mm_hh_dro2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_dro2_DSum09.dat' ET_mm_dro2 -ASCII
[t_dro3, avg_dro3, ET_mm_dro3, max_dro3, min_dro3, std_dro3, n_dro3] = Dailystats_new(tv, ET_mm_hh_dro3, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_dro3_DSum09.dat' ET_mm_dro3 -ASCII
[t_fal, avg_fal, ET_mm_fal, max_fal, min_fal, std_fal, n_fal] = Dailystats_new(tv, ET_mm_hh_fal, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_fal_DSum09.dat' ET_mm_fal -ASCII
[t_thi, avg_thi, ET_mm_thi, max_thi, min_thi, std_thi, n_thi] = Dailystats_new(tv, ET_mm_hh_thi, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_thi_DSum09.dat' ET_mm_thi -ASCII

[t_ref_v2, avg_ref_v2, ET_mm_ref_v2, max_ref_v2, min_ref_v2, std_ref_v2, n_ref_v2] = Dailystats_new(tv, ET_mm_hh_ref_v2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_ref_v2_DSum09.dat' ET_mm_ref_v2 -ASCII
[t_dro_v2, avg_dro_v2, ET_mm_dro_v2, max_dro_v2, min_dro_v2, std_dro_v2, n_dro_v2] = Dailystats_new(tv, ET_mm_hh_dro_v2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_dro_v2_DSum09.dat' ET_mm_dro_v2 -ASCII
[t_fal, avg_fal_v2, ET_mm_fal_v2, max_fal_v2, min_fal_v2, std_fal_v2, n_fal_v2] = Dailystats_new(tv, ET_mm_hh_fal_v2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_fal_v2_DSum09.dat' ET_mm_fal_v2 -ASCII
[t_thi, avg_thi_v2, ET_mm_thi_v2, max_thi_v2, min_thi_v2, std_thi_v2, n_thi_v2] = Dailystats_new(tv, ET_mm_hh_thi_v2, 999, -999);
save 'C:\MacKay\Masters\data\daily\ET_mm_thi_v2_DSum09.dat' ET_mm_thi_v2 -ASCII
%save 'ET_06.dat' ET_mm -ASCII;


%%  *********************** END OF UNNECCESSARY ***************************
