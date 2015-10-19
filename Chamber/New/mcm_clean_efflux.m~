%This script is designed to clean all the soil CO2 efflux data
%It then separtes the data into yearly variables as chamber 1 through 8
year = 2010;
num_ch = 8;
'cd C:\DATA'; %find directory
 
load_path = '/1/fielddata/SiteData/TP39_chamber/MET-DATA/annual/';

f1 = figure();clf;
% Load Chamber Data and plot it:
for i = 1:1:num_ch
   efflux(:,i) = load([ load_path 'TP39_chamber_' num2str(year) '.C' num2str(i) '_efflux']);
   rmse(:,i) = load([ load_path 'TP39_chamber_' num2str(year) '.C' num2str(i) '_rmse']);
subplot(4,2,i);
plot(efflux(:,i));
axis([1 17568 -10 20]);
title (['Chamber ' num2str(i)])
end


% Clean 1: Remove data for the 17th data point in every day, corresponding
% to system restart time (08:05 UTC -- 3:05am EST)
efflux(17:48:end,:) = NaN;



%Clean efflux data for all vaules between -0.5 and 10 for all
%2008,2009,2010
C1_efflux_all(C1_efflux_all(:,1) <= 0 | C1_efflux_all(:,1) >= 12,1) = NaN;
C2_efflux_all(C2_efflux_all(:,1) <= 0 | C2_efflux_all(:,1) >= 12,1) = NaN;
C3_efflux_all(C3_efflux_all(:,1) <= 0 | C3_efflux_all(:,1) >= 12,1) = NaN;
C4_efflux_all(C4_efflux_all(:,1) <= 0 | C4_efflux_all(:,1) >= 12,1) = NaN;
C5_efflux_all(C5_efflux_all(:,1) <= 0 | C5_efflux_all(:,1) >= 12,1) = NaN;
C6_efflux_all(C6_efflux_all(:,1) <= 0 | C6_efflux_all(:,1) >= 12,1) = NaN;
C7_efflux_all(C7_efflux_all(:,1) <= 0 | C7_efflux_all(:,1) >= 12,1) = NaN;
C8_efflux_all(C8_efflux_all(:,1) <= 0 | C8_efflux_all(:,1) >= 12,1) = NaN;

%Clean out efflux less than -0.5 and greater that 2 for Winter 2008/09
C1_efflux_all(C1_efflux_all(16080:21888,1) <= 0 | C1_efflux_all(16080:21888,1) >= 2,1) = NaN;
C2_efflux_all(C2_efflux_all(16080:21888,1) <= 0 | C2_efflux_all(16080:21888,1) >= 2,1) = NaN;
C3_efflux_all(C3_efflux_all(16080:21888,1) <= 0 | C3_efflux_all(16080:21888,1) >= 2,1) = NaN;
C4_efflux_all(C4_efflux_all(16080:21888,1) <= 0 | C4_efflux_all(16080:21888,1) >= 2,1) = NaN;
C5_efflux_all(C5_efflux_all(16080:21888,1) <= 0 | C5_efflux_all(16080:21888,1) >= 2,1) = NaN;
C6_efflux_all(C6_efflux_all(16080:21888,1) <= 0 | C6_efflux_all(16080:21888,1) >= 2,1) = NaN;

%Clean out efflux less than -0.5 and greater that 2 for Spring 2009
C1_efflux_all(C1_efflux_all(16080:21888,1) <= 0 | C1_efflux_all(16080:21888,1) >= 2,1) = NaN;
C2_efflux_all(C2_efflux_all(16080:21888,1) <= 0 | C2_efflux_all(16080:21888,1) >= 2,1) = NaN;
C3_efflux_all(C3_efflux_all(16080:21888,1) <= 0 | C3_efflux_all(16080:21888,1) >= 2,1) = NaN;
C4_efflux_all(C4_efflux_all(16080:21888,1) <= 0 | C4_efflux_all(16080:21888,1) >= 2,1) = NaN;
C5_efflux_all(C5_efflux_all(16080:21888,1) <= 0 | C5_efflux_all(16080:21888,1) >= 2,1) = NaN;
C6_efflux_all(C6_efflux_all(16080:21888,1) <= 0 | C6_efflux_all(16080:21888,1) >= 2,1) = NaN;

%Clean data for bad data when chambers were broken---this may be added to
%as you keep cleaning the data
%

C1_efflux_all(6800:8915,1)= NaN;
C2_efflux_all(6800:8915,1)= NaN;
C3_efflux_all(6800:8915,1)= NaN;
C4_efflux_all(6800:8915,1)= NaN;

C1_efflux_all(9345:9395,1)= NaN;
C2_efflux_all(9345:9395,1)= NaN;
C3_efflux_all(9345:9395,1)= NaN;
C4_efflux_all(9345:9395,1)= NaN;

C1_efflux_all(9454:9547,1)= NaN;
C2_efflux_all(9454:9547,1)= NaN;
C3_efflux_all(9454:9547,1)= NaN;
C4_efflux_all(9454:9547,1)= NaN;

C1_efflux_all(9870:9882,1)= NaN;
C2_efflux_all(9870:9882,1)= NaN;
C3_efflux_all(9870:9882,1)= NaN;
C4_efflux_all(9870:9882,1)= NaN;

C1_efflux_all(14269:14619,1)= NaN;
C2_efflux_all(14269:14619,1)= NaN;
C3_efflux_all(14269:14619,1)= NaN;
C4_efflux_all(14269:14619,1)= NaN;

C1_efflux_all(15816:15858,1)= NaN;
C2_efflux_all(15816:15858,1)= NaN;
C3_efflux_all(15816:15858,1)= NaN;
C4_efflux_all(15816:15858,1)= NaN;

C1_efflux_all(16972:17420,1)= NaN;
C2_efflux_all(16972:17420,1)= NaN;
C3_efflux_all(16972:17420,1)= NaN;
C4_efflux_all(16972:17420,1)= NaN;

C1_efflux_all(17910:17939,1)= NaN;
C2_efflux_all(17910:17939,1)= NaN;
C3_efflux_all(17910:17939,1)= NaN;
C4_efflux_all(17910:17939,1)= NaN;

C1_efflux_all(18050:18250,1)= NaN;
C2_efflux_all(18050:18250,1)= NaN;

C1_efflux_all(10444:10452,1)= NaN;
C3_efflux_all(10444:10452,1)= NaN;
C4_efflux_all(10444:10452,1)= NaN;

C1_efflux_all(16972:17517,1)= NaN;
C2_efflux_all(16972:17517,1)= NaN;
C3_efflux_all(16972:17517,1)= NaN;

C1_efflux_all(13812:13812,1)= NaN;
C2_efflux_all(13812:13812,1)= NaN;
C4_efflux_all(13812:13812,1)= NaN;
C1_efflux_all(12314:12314,1)= NaN;
C2_efflux_all(12314:12314,1)= NaN;
C4_efflux_all(12267:12267,1)= NaN;
C3_efflux_all(13956:13956,1)= NaN;

C1_efflux_all(10504:10504,1)= NaN;
C2_efflux_all(10504:10504,1)= NaN;
C4_efflux_all(10504:10504,1)= NaN;

C1_efflux_all(9642:9645,1)= NaN;
C1_efflux_all(10549:10570,1)= NaN;
C1_efflux_all(11538:11539,1)= NaN;

C1_efflux_all(24180:24315,1)= NaN;
C2_efflux_all(24180:24315,1)= NaN;
C3_efflux_all(24180:24315,1)= NaN;
C4_efflux_all(24180:24315,1)= NaN;
C5_efflux_all(24180:24315,1)= NaN;
C6_efflux_all(24180:24315,1)= NaN;

C1_efflux_all(24870:24950,1)= NaN;
C2_efflux_all(24870:24950,1)= NaN;
C3_efflux_all(24870:24950,1)= NaN;
C4_efflux_all(24870:24950,1)= NaN;
C5_efflux_all(24870:24950,1)= NaN;
C6_efflux_all(24860:24950,1)= NaN;

C1_efflux_all(25850:25904,1)= NaN;
C2_efflux_all(25850:25904,1)= NaN;
C3_efflux_all(25850:25904,1)= NaN;
C4_efflux_all(25850:25904,1)= NaN;
C5_efflux_all(25850:25904,1)= NaN;
C6_efflux_all(25844:25906,1)= NaN;

C1_efflux_all(24875:24950,1)= NaN;
C2_efflux_all(24875:24950,1)= NaN;
C3_efflux_all(24875:24950,1)= NaN;
C4_efflux_all(24875:24950,1)= NaN;
C5_efflux_all(24875:24950,1)= NaN;
C6_efflux_all(24875:24950,1)= NaN;

C3_efflux_all(10500:13954,1)= NaN;
C5_efflux_all(24312:24945,1)= NaN;
C6_efflux_all(25978:26302,1)= NaN;
C3_efflux_all(19259:19260,1)= NaN;
C3_efflux_all(20517:20525,1)= NaN;
C4_efflux_all(20520:20523,1)= NaN;
C3_efflux_all(27097:27125,1)= NaN;
C5_efflux_all(26954:27204,1)= NaN;

%Removal of spikes
C6_efflux_all(24772:24772,1)= NaN;
C5_efflux_all(25208:25208,1)= NaN;
C5_efflux_all(25210:25210,1)= NaN;
C5_efflux_all(25023:25023,1)= NaN;
C1_efflux_all(23720:23720,1)= NaN;
C1_efflux_all(24400:24400,1)= NaN;
C1_efflux_all(25208:25208,1)= NaN;
C2_efflux_all(25334:25334,1)= NaN;
C4_efflux_all(26019:26019,1)= NaN;
C5_efflux_all(26302:26302,1)= NaN;
C2_efflux_all(15485:15485,1)= NaN;
C3_efflux_all(15488:15488,1)= NaN;
C1_efflux_all(20314:20314,1)= NaN;
C2_efflux_all(19091:19091,1)= NaN;
C4_efflux_all(20513:20513,1)= NaN;
C3_efflux_all(23498:23498,1)= NaN;
C6_efflux_all(24315:24387,1)= NaN;
C6_efflux_all(24515:24534,1)= NaN;
C6_efflux_all(24951:25210,1)= NaN;
C6_efflux_all(25360:25440,1)= NaN;
%Updated Nov 13 2009
C1_efflux_all(31413:31413,1)= NaN;
C2_efflux_all(31413:31413,1)= NaN;
C3_efflux_all(31413:31413,1)= NaN;
C4_efflux_all(31413:31413,1)= NaN;
C5_efflux_all(31413:31413,1)= NaN;
C6_efflux_all(31413:31413,1)= NaN;
C5_efflux_all(31465:31465,1)= NaN;
C3_efflux_all(31466:31472,1)= NaN;
C2_efflux_all(32320:33399,1)= NaN;
C5_efflux_all(32525:32525,1)= NaN;
%Updated on Dec 10 2009
C1_efflux_all(33386:33399,1)= NaN;
C2_efflux_all(33386:33399,1)= NaN;
C3_efflux_all(33386:33399,1)= NaN;
C4_efflux_all(33386:33399,1)= NaN;
C5_efflux_all(33386:33399,1)= NaN;
C6_efflux_all(33386:33399,1)= NaN;
%Updated on Jan 5th 2010
C1_efflux_all(33601:34352,1)= NaN;
C6_efflux_all(34071:34072,1)= NaN;
C6_efflux_all(34123:34124,1)= NaN;
C6_efflux_all(34140:34141,1)= NaN;
C5_efflux_all(34330:34330,1)= NaN;
C6_efflux_all(34400:34400,1)= NaN;
C1_efflux_all(34583:34625,1)= NaN;
C2_efflux_all(34583:34625,1)= NaN;
C3_efflux_all(34583:34625,1)= NaN;
C4_efflux_all(34583:34625,1)= NaN;
C5_efflux_all(34583:34625,1)= NaN;
C6_efflux_all(34583:34625,1)= NaN;
C1_efflux_all(34625:35088,1)= NaN;
C3_efflux_all(34625:35088,1)= NaN;
C6_efflux_all(34073:34101,1)= NaN;
%Updated on Jan 6th 2010
C2_efflux_all(20245:21006,1)= NaN;
%Updated on Jan13th 2010
C3_efflux_all(17902:17902,1)= NaN;
C1_efflux_all(8916:8916,1)= NaN;
C1_efflux_all(9344:9344,1)= NaN;
C3_efflux_all(9343:9345,1)= NaN;
C3_efflux_all(14780:14780,1)= NaN;
C4_efflux_all(9343:9343,1)= NaN;
C4_efflux_all(11367:11367,1)= NaN;
C1_efflux_all(10547:10572,1)= NaN;
C2_efflux_all(10547:10572,1)= NaN;
C1_efflux_all(11020:11020,1)= NaN;
C2_efflux_all(11020:11020,1)= NaN;
C4_efflux_all(11020:11020,1)= NaN;
C2_efflux_all(12313:12313,1)= NaN;
C2_efflux_all(15480:15490,1)= NaN;
C1_efflux_all(14268:14268,1)= NaN;
C2_efflux_all(14268:14268,1)= NaN;
C3_efflux_all(14268:14268,1)= NaN;
C4_efflux_all(14268:14268,1)= NaN;
%Updated January 18th 2010
C1_efflux_all(18400:19090,1)= NaN;
C2_efflux_all(18400:19090,1)= NaN;
C1_efflux_all(18389:18390,1)= NaN;
C2_efflux_all(18389:18390,1)= NaN;
C1_efflux_all(24722:24726,1)= NaN;
C1_efflux_all(26379:26379,1)= NaN;
C2_efflux_all(26379:26379,1)= NaN;
C6_efflux_all(26379:26379,1)= NaN;
C2_efflux_all(16493:16520,1)= NaN;
C3_efflux_all(16493:16520,1)= NaN;
C3_efflux_all(18050:19400,1)= NaN;
C3_efflux_all(19428:19428,1)= NaN;
C4_efflux_all(27454:27454,1)= NaN;
C4_efflux_all(27968:27968,1)= NaN;
C6_efflux_all(25021:25025,1)= NaN;
C6_efflux_all(24620:24628,1)= NaN;
C6_efflux_all(26388:26388,1)= NaN;
C5_efflux_all(25021:25025,1)= NaN;
C5_efflux_all(26387:26387,1)= NaN;
%Updated January 19th 2010
C1_efflux_all(25209:25211,1)= NaN;
C6_efflux_all(24414:24482,1)= NaN;
C6_efflux_all(25357:25359,1)= NaN;
C1_efflux_all(27640:27640,1)= NaN;
C2_efflux_all(27640:27640,1)= NaN;
C3_efflux_all(27640:27640,1)= NaN;
C4_efflux_all(27640:27640,1)= NaN;
C5_efflux_all(27640:27640,1)= NaN;
C6_efflux_all(27640:27640,1)= NaN;
C1_efflux_all(28131:28131,1)= NaN;
C2_efflux_all(28131:28131,1)= NaN;
C3_efflux_all(28131:28131,1)= NaN;
C4_efflux_all(28131:28131,1)= NaN;
C5_efflux_all(28131:28131,1)= NaN;
C6_efflux_all(28131:28131,1)= NaN;
C1_efflux_all(28243:28243,1)= NaN;
C2_efflux_all(28243:28243,1)= NaN;
C3_efflux_all(28243:28243,1)= NaN;
C4_efflux_all(28243:28243,1)= NaN;
C5_efflux_all(28243:28243,1)= NaN;
C6_efflux_all(28243:28243,1)= NaN;
C1_efflux_all(28777:28777,1)= NaN;
C2_efflux_all(28777:28777,1)= NaN;
C3_efflux_all(28777:28777,1)= NaN;
C4_efflux_all(28777:28777,1)= NaN;
C5_efflux_all(28777:28777,1)= NaN;
C6_efflux_all(28777:28777,1)= NaN;
C2_efflux_all(29355:29356,1)= NaN;
C5_efflux_all(29355:29356,1)= NaN;
C5_efflux_all(29364:29364,1)= NaN;
C5_efflux_all(26782:26791,1)= NaN;
C5_efflux_all(26494:26495,1)= NaN;
C6_efflux_all(29365:29365,1)= NaN;
C2_efflux_all(32319:32319,1)= NaN;
C1_efflux_all(19080:19420,1)= NaN;
C2_efflux_all(19080:19420,1)= NaN;
C4_efflux_all(19080:19420,1)= NaN;

%Updated March 4th, 2010
C3_efflux_all(35088:35107,1)= NaN;
C3_efflux_all(35517:35517,1)= NaN;
C3_efflux_all(35530:35550,1)= NaN;

%Updated March 29th, 2010

C3_efflux_all(36490:36500,1) = NaN;
C3_efflux_all(37090:37420,1) = NaN;
C3_efflux_all(37620:37623,1) = NaN;
C3_efflux_all(39018:39018,1) = NaN;
C3_efflux_all(36500:36511,1) = NaN;
C1_efflux_all(37225:37226,1) = NaN;
C1_efflux_all(37900:37920,1) = NaN;
C2_efflux_all(37420:37422,1) = NaN;
C1_efflux_all(38710:38815,1) = NaN;
C2_efflux_all(38710:38815,1) = NaN;
C3_efflux_all(38710:38815,1) = NaN;
C4_efflux_all(38710:38815,1) = NaN;
C5_efflux_all(38710:38815,1) = NaN;
C6_efflux_all(38710:38815,1) = NaN;

%Updated April 23rd, 210
C1_efflux_all(33388:34583,1) = NaN;

%Updated May 7th,2010
C1_efflux_all(4780:4800,1) = NaN;
C3_efflux_all(4750:4800,1) = NaN;

%Updated May 12th, 2010
C1_efflux_all(39800:39920,1) = NaN;
C2_efflux_all(39800:39920,1) = NaN;
C3_efflux_all(39800:39920,1) = NaN;
C4_efflux_all(39800:39920,1) = NaN;
C5_efflux_all(39800:39920,1) = NaN;
C6_efflux_all(39800:39920,1) = NaN;

C1_efflux_all(39965:39980,1) = NaN;
C2_efflux_all(39965:39980,1) = NaN;
C3_efflux_all(39965:39980,1) = NaN;
C4_efflux_all(39965:39980,1) = NaN;
C5_efflux_all(39965:39980,1) = NaN;
C6_efflux_all(39965:39980,1) = NaN;

C1_efflux_all(40200:40450,1) = NaN;
C2_efflux_all(40200:40450,1) = NaN;
C3_efflux_all(40200:40450,1) = NaN;
C4_efflux_all(40200:40450,1) = NaN;
C5_efflux_all(40200:40450,1) = NaN;
C6_efflux_all(40200:40450,1) = NaN;

C1_efflux_all(40643:40697,1) = NaN;
C2_efflux_all(40643:40697,1) = NaN;
C3_efflux_all(40643:40697,1) = NaN;
C4_efflux_all(40643:40697,1) = NaN;
C5_efflux_all(40643:40697,1) = NaN;
C6_efflux_all(40643:40697,1) = NaN;

C1_efflux_all(37700:38315,1) = NaN;
C2_efflux_all(37700:38315,1) = NaN;
C3_efflux_all(37700:38315,1) = NaN;
C4_efflux_all(37700:38315,1) = NaN;
C5_efflux_all(37700:38315,1) = NaN;
C6_efflux_all(37700:38315,1) = NaN;

C2_efflux_all(39700:39956,1) = NaN;

%updated July7th, 2010
% C3_efflux_all(40830:43005,1) = NaN;
% C8_efflux_all(41310:43005,1) = NaN;
C7_efflux_all(40830:41650,1) = NaN;

%updated August 6th,2010
C2_efflux_all(42656:42658,1) = NaN;
C5_efflux_all(42656:42658,1) = NaN;
C6_efflux_all(42656:42658,1) = NaN;
C7_efflux_all(42656:42658,1) = NaN;

C2_efflux_all(44260:44380,1) = NaN;
C4_efflux_all(44260:44380,1) = NaN;

C4_efflux_all(44380:44510,1) = NaN;

C2_efflux_all(44813:44815,1) = NaN;
C4_efflux_all(44813:44815,1) = NaN;
C5_efflux_all(44813:44815,1) = NaN;
C6_efflux_all(44813:44815,1) = NaN;
C7_efflux_all(44813:44815,1) = NaN;

%updated August 11th, 2010
C7_efflux_all(44340:44340,1) = NaN;
C6_efflux_all(40196:40198,1) = NaN;
C1_efflux_all(44339:44343,1) = NaN;

%updated September 7th, 2010 
C3_efflux_all(40700:45789,1) =  NaN; %removed due to sample tubes switched for ch3 and ch8
C8_efflux_all(41320:45789,1) = NaN;
C3_eflux_all(41102:41102,1) = NaN;
C1_efflux_all(41188:41188,1) = NaN;
C1_efflux_all(41644:41644,1) = NaN;

%updated September 9th, 2010
C6_efflux_all(46320:46660,1) = NaN;
C3_efflux_all(45750:46075,1) = NaN;
C8_efflux_all(45750:46075,1) = NaN;

%updated November 12th, 2010
C6_efflux_all(46661:48175,1) = NaN;
C5_efflux_all(47097:47097,1) = NaN;
C2_efflux_all(47151:47151,1) = NaN;
C7_efflux_all(47378:47378,1) = NaN;
C7_efflux_all(47380:47380,1) = NaN;
C7_efflux_all(47388:47388,1) = NaN;
C4_efflux_all(47393:47393,1) = NaN;
C1_efflux_all(47665:47693,1) = NaN;
C2_efflux_all(47665:47693,1) = NaN;
C3_efflux_all(47665:47693,1) = NaN;
C4_efflux_all(47665:47693,1) = NaN;
C5_efflux_all(47665:47693,1) = NaN;
C6_efflux_all(47665:47693,1) = NaN;
C7_efflux_all(47665:47693,1) = NaN;
C8_efflux_all(47665:47693,1) = NaN;
C7_efflux_all(48245:48245,1) = NaN;
C8_efflux_all(47639:48507,1) = NaN;
C1_efflux_all(48432:48432,1) = NaN;
C3_efflux_all(48507:48507,1) = NaN;
C8_efflux_all(47550:47650,1) = NaN;

clc;

% Ignore NaN's when plotting and determining stats- added Aug 24/09
%%% option 1 -- use find to make index
%%This was done to calculate stats--needed to be done becuase will not
%%accept NaN's
indC1 = find(~isnan(C1_efflux_all)); 
stats_C1_efflux = C1_efflux_all(indC1); %use this variable to calculate stats
indC2 = find(~isnan(C2_efflux_all)); 
stats_C2_efflux = C2_efflux_all(indC2);
indC3 = find(~isnan(C3_efflux_all)); 
stats_C3_efflux = C3_efflux_all(indC3);
indC4 = find(~isnan(C4_efflux_all)); 
stats_C4_efflux = C4_efflux_all(indC4);
indC5 = find(~isnan(C5_efflux_all)); 
stats_C5_efflux = C5_efflux_all(indC5);
indC6 = find(~isnan(C6_efflux_all)); 
stats_C6_efflux = C6_efflux_all(indC6);
indC7 = find(~isnan(C7_efflux_all)); 
stats_C7_efflux = C7_efflux_all(indC7);
indC8 = find(~isnan(C8_efflux_all)); 
stats_C8_efflux = C8_efflux_all(indC8);

%Plot time series for chambers- soil CO2 efflux after 1st step cleaning
figure('Name','Time Series Soil CO2 Efflux','NumberTitle','off'); 
hold on;
subplot (8,1,1);
hold on;
plot(C1_efflux_all,'-','Color',[0.69 0.11 0]);hold on;
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch1')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux');
legend('No Litter',1)

hold on;
subplot (8,1,2);
hold on;
plot(C2_efflux_all,'-','Color',[0.06 0.03 0.67]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch2')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Control 1',1)

hold on;
subplot (8,1,3);
hold on;
plot(C3_efflux_all,'-','Color',[0.22 0.47 0.24]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch3')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Trenched',1)

hold on;
subplot (8,1,4);
hold on;
plot(C4_efflux_all,'-','Color',[0.21 0.56 0.82]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch4')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Drought 1',1)

hold on;
subplot (8,1,5);
hold on;
plot(C5_efflux_all,'-','Color',[0.91 0.49 0.12]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch5')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Control 2',1)

hold on;
subplot (8,1,6);
hold on;
plot(C6_efflux_all, '-','Color',[0.25 0 0.50]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch6')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Drought 2',1)

hold on;
subplot (8,1,7);
hold on;
plot(C7_efflux_all, '-','Color',[0.83 0.2 0.56]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch7')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO2 m^-^2 s^-^1)');
legend('Reference',1)

hold on;
subplot (8,1,8);
hold on;
plot(C8_efflux_all, '-','Color',[0 0.5 0.5]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux Ch8')
xlabel('HHOUR')
ylabel ('Soil CO_2 Efflux (umol CO_2 m^-^2 s^-^1)');
legend('Hetero/Dro',1)

%Plot all data from chambers- soil CO2 efflux after 1st step of cleaning

figure('Name','Heterotrophic and Litterless Chambers','NumberTitle','off');clf
hold on;
plot(C1_efflux_all,'-','Color',[0.69 0.11 0]);hold on;
hold on;
plot(C3_efflux_all,'-','Color',[0.22 0.47 0.24]);
plot(C8_efflux_all, '-','Color',[0.06 0.03 0.67]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux')
ylabel('Soil CO_2 Efflux (umol m^-^2 s^-^1)')
xlabel('Time (hhour)')
legend('C1/ref no litter','C3 ref/trenched','C8 trenched',1)

figure('Name','Drought and Reference Chambers','NumberTitle','off');clf
hold on;
plot(C2_efflux_all,'-','Color',[0.06 0.03 0.67]);
plot(C4_efflux_all,'-','Color',[0.21 0.56 0.82]);
plot(C5_efflux_all,'-','Color',[0.91 0.49 0.12]);
plot(C6_efflux_all, '-','Color',[0.25 0 0.50]);
plot(C7_efflux_all, '-','Color',[0.83 0.2 0.56]);
axis([7296 49728 -1 13]);
title('Soil CO_2 Efflux')
ylabel('Soil CO_2 Efflux (umol m^-^2 s^-^1)')
xlabel('Time (hhour)')
legend('C2 ref','C4 ref/drought','C5 ref','C6 drought','C7 ref',1)

% Create variables for each year of the cleaned data (1st step)

%2008 cleaned data
C1_efflux_2008_clean = C1_efflux_all (1:17568); %creating variable for clean data
save 'C:\DATA\condensed\clean\C1_efflux_2008_clean.dat'  C1_efflux_2008_clean   -ASCII %saving data--make sure you have created the folder 
C2_efflux_2008_clean = C2_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C2_efflux_2008_clean.dat'  C2_efflux_2008_clean   -ASCII 
C3_efflux_2008_clean = C3_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C3_efflux_2008_clean.dat'  C3_efflux_2008_clean   -ASCII 
C4_efflux_2008_clean = C4_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C4_efflux_2008_clean.dat'  C4_efflux_2008_clean   -ASCII 
C5_efflux_2008_clean = C5_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C5_efflux_2008_clean.dat'  C5_efflux_2008_clean   -ASCII 
C6_efflux_2008_clean = C6_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C6_efflux_2008_clean.dat'  C6_efflux_2008_clean   -ASCII 
C7_efflux_2008_clean = C7_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C7_efflux_2008_clean.dat'  C7_efflux_2008_clean   -ASCII 
C8_efflux_2008_clean = C8_efflux_all (1:17568);
save 'C:\DATA\condensed\clean\C8_efflux_2008_clean.dat'  C8_efflux_2008_clean   -ASCII 

%2009 cleaned data
C1_efflux_2009_clean = C1_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C1_efflux_2009_clean.dat'  C1_efflux_2009_clean   -ASCII 
C2_efflux_2009_clean = C2_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C2_efflux_2009_clean.dat'  C2_efflux_2009_clean   -ASCII 
C3_efflux_2009_clean = C3_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C3_efflux_2009_clean.dat'  C3_efflux_2009_clean   -ASCII 
C4_efflux_2009_clean = C4_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C4_efflux_2009_clean.dat'  C4_efflux_2009_clean   -ASCII 
C5_efflux_2009_clean = C5_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C5_efflux_2009_clean.dat'  C5_efflux_2009_clean   -ASCII 
C6_efflux_2009_clean = C6_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C6_efflux_2009_clean.dat'  C6_efflux_2009_clean   -ASCII 
C7_efflux_2009_clean = C7_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C7_efflux_2009_clean.dat'  C7_efflux_2009_clean   -ASCII 
C8_efflux_2009_clean = C8_efflux_all (17569:35088);
save 'C:\DATA\condensed\clean\C8_efflux_2009_clean.dat'  C8_efflux_2009_clean   -ASCII 

%2010 cleaned data
C1_efflux_2010_clean = C1_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C1_efflux_2010_clean.dat'  C1_efflux_2010_clean   -ASCII 
C2_efflux_2010_clean = C2_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C2_efflux_2010_clean.dat'  C2_efflux_2010_clean   -ASCII 
C3_efflux_2010_clean = C3_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C3_efflux_2010_clean.dat'  C3_efflux_2010_clean   -ASCII 
C4_efflux_2010_clean = C4_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C4_efflux_2010_clean.dat'  C4_efflux_2010_clean   -ASCII 
C5_efflux_2010_clean = C5_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C5_efflux_2010_clean.dat'  C5_efflux_2010_clean   -ASCII 
C6_efflux_2010_clean = C6_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C6_efflux_2010_clean.dat'  C6_efflux_2010_clean   -ASCII 
C7_efflux_2010_clean = C7_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C7_efflux_2010_clean.dat'  C7_efflux_2010_clean   -ASCII 
C8_efflux_2010_clean = C8_efflux_all (35089:52608);
save 'C:\DATA\condensed\clean\C8_efflux_2010_clean.dat'  C8_efflux_2010_clean   -ASCII 
clc;

%%Separate Data for drought work
%showing different time periods

C2_efflux_before= C2_efflux_all(20448:21888,1); %before drought JD 60-90 (Mar 1-Mar 31)
C5_efflux_before= C5_efflux_all(20448:21888,1); %before drought JD 60-90 (Mar 1-Mar 31)
C4_efflux_before= C4_efflux_all(20448:21888,1); %before drought JD 60-90 (Mar 1-Mar 31)
C6_efflux_before= C6_efflux_all(20448:21888,1); %before drought JD 60-90 (Mar 1-Mar 31)

C2_efflux_during_91_120= C2_efflux_all(21889:23328,1); %during drought JD 91-120 (April 1-April 30)
C5_efflux_during_91_120= C5_efflux_all(21889:23328,1); %during drought JD 91-120 (April 1-April 30)
C4_efflux_during_91_120= C4_efflux_all(21889:23328,1); %during drought JD 91-120 (April 1-April 30)
C6_efflux_during_91_120= C6_efflux_all(21889:23328,1); %duirng drought JD 91-120 (April 1-April 30)

C2_efflux_during_121_151= C2_efflux_all(23389:24816,1); %during drought JD 121-151 (May 1- May 31)
C5_efflux_during_121_151= C5_efflux_all(23389:24816,1); %during drought JD 121-151 (May 1- May 31)
C4_efflux_during_121_151= C4_efflux_all(23389:24816,1); %during drought JD 121-151 (May 1- May 31)
C6_efflux_during_121_151= C6_efflux_all(23389:24816,1); %duirng drought JD 121-151 (May 1- May 31)

C2_efflux_during_152_184= C2_efflux_all(24817:26400,1); %during drought JD 152-184 (June 1- July 3)
C5_efflux_during_152_184= C5_efflux_all(24817:26400,1); %during drought JD 152-184 (June 1- July 3)
C4_efflux_during_152_184= C4_efflux_all(24817:26400,1); %during drought JD 152-184 (June 1- July 3)
C6_efflux_during_152_184= C6_efflux_all(24817:26400,1); %duirng drought JD 152-184 (June 1- July 3)

C2_efflux_after_185_212= C2_efflux_all(26401:27744,1); %after drought JD 185-212 (July 3- July 31)
C5_efflux_after_185_212= C5_efflux_all(26401:27744,1); %after drought JD 185-212 (July 3- July 31)
C4_efflux_after_185_212= C4_efflux_all(26401:27744,1); %after drought JD 185-212 (July 3- July 31)
C6_efflux_after_185_212= C6_efflux_all(26401:27744,1); %after drought JD 185-212 (July 3- July 31)

C2_efflux_after_213_243= C2_efflux_all(27745:29232,1); %after drought JD 213-243 (Aug 1-Aug 31)
C5_efflux_after_213_243= C5_efflux_all(27745:29232,1); %after drought JD 213-243 (Aug 1-Aug 31)
C4_efflux_after_213_243= C4_efflux_all(27745:29232,1); %after drought JD 213-243 (Aug 1-Aug 31)
C6_efflux_after_213_243= C6_efflux_all(27745:29232,1); %after drought JD 213-243 (Aug 1-Aug 31)

C2_efflux_after_244_273= C2_efflux_all(29233:30672,1); %after drought JD 244-273 (Sept 1- Sept 30)
C5_efflux_after_244_273= C5_efflux_all(29233:30672,1); %after drought JD 244-273 (Sept 1- Sept 30)
C4_efflux_after_244_273= C4_efflux_all(29233:30672,1); %after drought JD 244-273 (Sept 1- Sept 30)
C6_efflux_after_244_273= C6_efflux_all(29233:30672,1); %after drought JD 244-273 (Sept 1- Sept 30)

C2_efflux_after_274_365= C2_efflux_all(30673:35088,1); %after drought JD 274-365 (Oct 1- Dec 31)
C5_efflux_after_274_365= C5_efflux_all(30673:35088,1); %after drought JD 274-365 (Oct 1- Dec 31)
C4_efflux_after_274_365= C4_efflux_all(30673:35088,1); %after drought JD 274-365 (Oct 1- Dec 31)
C6_efflux_after_274_365= C6_efflux_all(30673:35088,1); %after drought JD 274-365 (Oct 1- Dec 31)




