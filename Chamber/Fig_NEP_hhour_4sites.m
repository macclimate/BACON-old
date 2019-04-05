% Monthly time series of GEP, RE, NEP for all four sites
% Altaf Arain, 20 October 2008


close all; clear all; clc

days = 1;

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2003.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2004.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2005.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2006.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2007.dat

dt03 = TP39_final_2003(:,6);
dt04 = TP39_final_2004(:,6);
dt05 = TP39_final_2005(:,6);
dt06 = TP39_final_2006(:,6);
dt07 = TP39_final_2007(:,6);

NEP39_03um = TP39_final_2003(:,7);
NEP39_04um = TP39_final_2004(:,7);
NEP39_05um = TP39_final_2005(:,7);
NEP39_06um = TP39_final_2006(:,7);
NEP39_07um = TP39_final_2007(:,7);

NEP39_03 = TP39_final_2003(:,7).*0.0216;
NEP39_04 = TP39_final_2004(:,7).*0.0216;
NEP39_05 = TP39_final_2005(:,7).*0.0216;
NEP39_06 = TP39_final_2006(:,7).*0.0216;
NEP39_07 = TP39_final_2007(:,7).*0.0216;

% [NEP39_03sum,NEP39_03mean,TimeX03] = integzBC1(dt03(~isnan(NEP39_03)),  NEP39_03(~isnan(NEP39_03)),1:365,days);  NEP39_03Sum  = NEP39_03sum'; 
% [NEP39_04sum,NEP39_04mean,TimeX04] = integzBC1(dt04(~isnan(NEP39_04)),  NEP39_04(~isnan(NEP39_04)),1:366,days);  NEP39_04Sum  = NEP39_04sum'; 
% [NEP39_05sum,NEP39_05mean,TimeX05] = integzBC1(dt05(~isnan(NEP39_05)),  NEP39_05(~isnan(NEP39_05)),1:365,days);  NEP39_05Sum  = NEP39_05sum'; 
% [NEP39_06sum,NEP39_06mean,TimeX06] = integzBC1(dt06(~isnan(NEP39_06)),  NEP39_06(~isnan(NEP39_06)),1:365,days);  NEP39_06Sum  = NEP39_06sum'; 
% [NEP39_07sum,NEP39_07mean,TimeX07] = integzBC1(dt07(~isnan(NEP39_07)),  NEP39_07(~isnan(NEP39_07)),1:365,days);  NEP39_07Sum  = NEP39_07sum'; 

NEP39um = [NEP39_03um; NEP39_04um; NEP39_05um; NEP39_06um; NEP39_07um];
% NEP39 = [NEP39_03Sum; NEP39_04Sum; NEP39_05Sum; NEP39_06Sum; NEP39_07Sum];

%%%
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP74_final_2003.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP74_final_2004.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP74_final_2005.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP74_final_2006.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP74_final_2007.dat

dt03 = TP74_final_2003(:,6);
dt04 = TP74_final_2004(:,6);
dt05 = TP74_final_2005(:,6);
dt06 = TP74_final_2006(:,6);
dt07 = TP74_final_2007(:,6);

NEP74_03um = TP74_final_2003(:,7);
NEP74_04um = TP74_final_2004(:,7);
NEP74_05um = TP74_final_2005(:,7);
NEP74_06um = TP74_final_2006(:,7);
NEP74_07um = TP74_final_2007(:,7);

NEP74_03 = TP74_final_2003(:,7).*0.0216;
NEP74_04 = TP74_final_2004(:,7).*0.0216;
NEP74_05 = TP74_final_2005(:,7).*0.0216;
NEP74_06 = TP74_final_2006(:,7).*0.0216;
NEP74_07 = TP74_final_2007(:,7).*0.0216;

% [NEP74_03sum,NEP74_03mean,TimeX03] = integzBC1(dt03(~isnan(NEP74_03)),  NEP74_03(~isnan(NEP74_03)),1:365,days);  NEP74_03Sum  = NEP74_03sum'; 
% [NEP74_04sum,NEP74_04mean,TimeX04] = integzBC1(dt04(~isnan(NEP74_04)),  NEP74_04(~isnan(NEP74_04)),1:366,days);  NEP74_04Sum  = NEP74_04sum'; 
% [NEP74_05sum,NEP74_05mean,TimeX05] = integzBC1(dt05(~isnan(NEP74_05)),  NEP74_05(~isnan(NEP74_05)),1:365,days);  NEP74_05Sum  = NEP74_05sum'; 
% [NEP74_06sum,NEP74_06mean,TimeX06] = integzBC1(dt06(~isnan(NEP74_06)),  NEP74_06(~isnan(NEP74_06)),1:365,days);  NEP74_06Sum  = NEP74_06sum'; 
% [NEP74_07sum,NEP74_07mean,TimeX07] = integzBC1(dt07(~isnan(NEP74_07)),  NEP74_07(~isnan(NEP74_07)),1:365,days);  NEP74_07Sum  = NEP74_07sum'; 


NEP74um = [NEP74_03um; NEP74_04um; NEP74_05um; NEP74_06um; NEP74_07um];
% NEP74 = [NEP74_03Sum; NEP74_04Sum; NEP74_05Sum; NEP74_06Sum; NEP74_07Sum];

%%%
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP89_final_2003.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP89_final_2004.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP89_final_2005.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP89_final_2006.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP89_final_2007.dat

dt03 = TP89_final_2003(:,6);
dt04 = TP89_final_2004(:,6);
dt05 = TP89_final_2005(:,6);
dt06 = TP89_final_2006(:,6);
dt07 = TP89_final_2007(:,6);

NEP89_03um = TP89_final_2003(:,7);
NEP89_04um = TP89_final_2004(:,7);
NEP89_05um = TP89_final_2005(:,7);
NEP89_06um = TP89_final_2006(:,7);
NEP89_07um = TP89_final_2007(:,7);

NEP89_03 = TP89_final_2003(:,7).*0.0216;
NEP89_04 = TP89_final_2004(:,7).*0.0216;
NEP89_05 = TP89_final_2005(:,7).*0.0216;
NEP89_06 = TP89_final_2006(:,7).*0.0216;
NEP89_07 = TP89_final_2007(:,7).*0.0216;

% [NEP89_03sum,NEP89_03mean,TimeX03] = integzBC1(dt03(~isnan(NEP89_03)),  NEP89_03(~isnan(NEP89_03)),1:365,days);  NEP89_03Sum  = NEP89_03sum'; 
% [NEP89_04sum,NEP89_04mean,TimeX04] = integzBC1(dt04(~isnan(NEP89_04)),  NEP89_04(~isnan(NEP89_04)),1:366,days);  NEP89_04Sum  = NEP89_04sum'; 
% [NEP89_05sum,NEP89_05mean,TimeX05] = integzBC1(dt05(~isnan(NEP89_05)),  NEP89_05(~isnan(NEP89_05)),1:365,days);  NEP89_05Sum  = NEP89_05sum'; 
% [NEP89_06sum,NEP89_06mean,TimeX06] = integzBC1(dt06(~isnan(NEP89_06)),  NEP89_06(~isnan(NEP89_06)),1:365,days);  NEP89_06Sum  = NEP89_06sum'; 
% [NEP89_07sum,NEP89_07mean,TimeX07] = integzBC1(dt07(~isnan(NEP89_07)),  NEP89_07(~isnan(NEP89_07)),1:365,days);  NEP89_07Sum  = NEP89_07sum'; 


NEP89um = [NEP89_03um; NEP89_04um; NEP89_05um; NEP89_06um; NEP89_07um];
% NEP89 = [NEP89_03Sum; NEP89_04Sum; NEP89_05Sum; NEP89_06Sum; NEP89_07Sum];

%%%%
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP02_final_2003.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP02_final_2004.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP02_final_2005.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP02_final_2006.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP02_final_2007.dat

dt03 = TP02_final_2003(:,6);
dt04 = TP02_final_2004(:,6);
dt05 = TP02_final_2005(:,6);
dt06 = TP02_final_2006(:,6);
dt07 = TP02_final_2007(:,6);

NEP02_03um = TP02_final_2003(:,7);
NEP02_04um = TP02_final_2004(:,7);
NEP02_05um = TP02_final_2005(:,7);
NEP02_06um = TP02_final_2006(:,7);
NEP02_07um = TP02_final_2007(:,7);

NEP02_03 = TP02_final_2003(:,7).*0.0216;
NEP02_04 = TP02_final_2004(:,7).*0.0216;
NEP02_05 = TP02_final_2005(:,7).*0.0216;
NEP02_06 = TP02_final_2006(:,7).*0.0216;
NEP02_07 = TP02_final_2007(:,7).*0.0216;

% [NEP02_03sum,NEP02_03mean,TimeX03] = integzBC1(dt03(~isnan(NEP02_03)),  NEP02_03(~isnan(NEP02_03)),1:365,days);  NEP02_03Sum  = NEP02_03sum'; 
% [NEP02_04sum,NEP02_04mean,TimeX04] = integzBC1(dt04(~isnan(NEP02_04)),  NEP02_04(~isnan(NEP02_04)),1:366,days);  NEP02_04Sum  = NEP02_04sum'; 
% [NEP02_05sum,NEP02_05mean,TimeX05] = integzBC1(dt05(~isnan(NEP02_05)),  NEP02_05(~isnan(NEP02_05)),1:365,days);  NEP02_05Sum  = NEP02_05sum'; 
% [NEP02_06sum,NEP02_06mean,TimeX06] = integzBC1(dt06(~isnan(NEP02_06)),  NEP02_06(~isnan(NEP02_06)),1:365,days);  NEP02_06Sum  = NEP02_06sum'; 
% [NEP02_07sum,NEP02_07mean,TimeX07] = integzBC1(dt07(~isnan(NEP02_07)),  NEP02_07(~isnan(NEP02_07)),1:365,days);  NEP02_07Sum  = NEP02_07sum'; 

NEP02um = [NEP02_03um; NEP02_04um; NEP02_05um; NEP02_06um; NEP02_07um];
% NEP02 = [NEP02_03Sum; NEP02_04Sum; NEP02_05Sum; NEP02_06Sum; NEP02_07Sum];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2003_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2004_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2005_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2006_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2007_model4_1daysum.dat
% GEP39d_03 = TP39_GEP_2003_model4_1daysum; 
% GEP39d_04 = TP39_GEP_2004_model4_1daysum; 
% GEP39d_05 = TP39_GEP_2005_model4_1daysum; 
% GEP39d_06 = TP39_GEP_2006_model4_1daysum; 
% GEP39d_07 = TP39_GEP_2007_model4_1daysum; 
% GEP39d = [GEP39d_03; GEP39d_04; GEP39d_05; GEP39d_06; GEP39d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2007_model3_1daysum.dat
% GEP74d_03 = TP74_GEP_2003_model3_1daysum; 
% GEP74d_04 = TP74_GEP_2004_model3_1daysum; 
% GEP74d_05 = TP74_GEP_2005_model3_1daysum; 
% GEP74d_06 = TP74_GEP_2006_model3_1daysum; 
% GEP74d_07 = TP74_GEP_2007_model3_1daysum; 
% GEP74d = [GEP74d_03; GEP74d_04; GEP74d_05; GEP74d_06; GEP74d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2007_model3_1daysum.dat
% GEP89d_03 = TP89_GEP_2003_model3_1daysum; 
% GEP89d_04 = TP89_GEP_2004_model3_1daysum; 
% GEP89d_05 = TP89_GEP_2005_model3_1daysum; 
% GEP89d_06 = TP89_GEP_2006_model3_1daysum; 
% GEP89d_07 = TP89_GEP_2007_model3_1daysum; 
% GEP89d = [GEP89d_03; GEP89d_04; GEP89d_05; GEP89d_06; GEP89d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2007_model3_1daysum.dat
% GEP02d_03 = TP02_GEP_2003_model3_1daysum; 
% GEP02d_04 = TP02_GEP_2004_model3_1daysum; 
% GEP02d_05 = TP02_GEP_2005_model3_1daysum; 
% GEP02d_06 = TP02_GEP_2006_model3_1daysum; 
% GEP02d_07 = TP02_GEP_2007_model3_1daysum; 
% GEP02d = [GEP02d_03; GEP02d_04; GEP02d_05; GEP02d_06; GEP02d_07];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2003_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2004_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2005_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2006_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2007_model4_1daysum.dat
% RE39d_03 = TP39_R_2003_model4_1daysum; 
% RE39d_04 = TP39_R_2004_model4_1daysum; 
% RE39d_05 = TP39_R_2005_model4_1daysum; 
% RE39d_06 = TP39_R_2006_model4_1daysum; 
% RE39d_07 = TP39_R_2007_model4_1daysum; 
% RE39d = [RE39d_03; RE39d_04; RE39d_05; RE39d_06; RE39d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2007_model3_1daysum.dat
% RE74d_03 = TP74_R_2003_model3_1daysum; 
% RE74d_04 = TP74_R_2004_model3_1daysum; 
% RE74d_05 = TP74_R_2005_model3_1daysum; 
% RE74d_06 = TP74_R_2006_model3_1daysum; 
% RE74d_07 = TP74_R_2007_model3_1daysum; 
% RE74d = [RE74d_03; RE74d_04; RE74d_05; RE74d_06; RE74d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2007_model3_1daysum.dat
% RE89d_03 = TP89_R_2003_model3_1daysum; 
% RE89d_04 = TP89_R_2004_model3_1daysum; 
% RE89d_05 = TP89_R_2005_model3_1daysum; 
% RE89d_06 = TP89_R_2006_model3_1daysum; 
% RE89d_07 = TP89_R_2007_model3_1daysum; 
% RE89d = [RE89d_03; RE89d_04; RE89d_05; RE89d_06; RE89d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2007_model3_1daysum.dat
% RE02d_03 = TP02_R_2003_model3_1daysum; 
% RE02d_04 = TP02_R_2004_model3_1daysum; 
% RE02d_05 = TP02_R_2005_model3_1daysum; 
% RE02d_06 = TP02_R_2006_model3_1daysum; 
% RE02d_07 = TP02_R_2007_model3_1daysum; 
% RE02d = [RE02d_03; RE02d_04; RE02d_05; RE02d_06; RE02d_07];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2003_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2004_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2005_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2006_model4_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2007_model4_1daysum.dat
% NEP39d_03 = TP39_NEP_2003_model4_1daysum; 
% NEP39d_04 = TP39_NEP_2004_model4_1daysum; 
% NEP39d_05 = TP39_NEP_2005_model4_1daysum; 
% NEP39d_06 = TP39_NEP_2006_model4_1daysum; 
% NEP39d_07 = TP39_NEP_2007_model4_1daysum; 
% NEP39d = [NEP39d_03; NEP39d_04; NEP39d_05; NEP39d_06; NEP39d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2007_model3_1daysum.dat
% NEP74d_03 = TP74_NEP_2003_model3_1daysum; 
% NEP74d_04 = TP74_NEP_2004_model3_1daysum; 
% NEP74d_05 = TP74_NEP_2005_model3_1daysum; 
% NEP74d_06 = TP74_NEP_2006_model3_1daysum; 
% NEP74d_07 = TP74_NEP_2007_model3_1daysum; 
% NEP74d = [NEP74d_03; NEP74d_04; NEP74d_05; NEP74d_06; NEP74d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2007_model3_1daysum.dat
% NEP89d_03 = TP89_NEP_2003_model3_1daysum; 
% NEP89d_04 = TP89_NEP_2004_model3_1daysum; 
% NEP89d_05 = TP89_NEP_2005_model3_1daysum; 
% NEP89d_06 = TP89_NEP_2006_model3_1daysum; 
% NEP89d_07 = TP89_NEP_2007_model3_1daysum; 
% NEP89d = [NEP89d_03; NEP89d_04; NEP89d_05; NEP89d_06; NEP89d_07];
% 
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2003_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2004_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2005_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2006_model3_1daysum.dat
% load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2007_model3_1daysum.dat
% NEP02d_03 = TP02_NEP_2003_model3_1daysum; 
% NEP02d_04 = TP02_NEP_2004_model3_1daysum; 
% NEP02d_05 = TP02_NEP_2005_model3_1daysum; 
% NEP02d_06 = TP02_NEP_2006_model3_1daysum; 
% NEP02d_07 = TP02_NEP_2007_model3_1daysum; 
% NEP02d = [NEP02d_03; NEP02d_04; NEP02d_05; NEP02d_06; NEP02d_07];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(gcf)
figure('unit','inches','PaperOrientation','Landscape','PaperPosition',[.1 0.1 9. 7.0],...
'position',[0.1    0.1    9.0    7.0]);

axes('Position',[.15 .58 .75 .35])
hold on
            
plot(NEP39um,'ko',...
                'MarkerEdgeColor',[0.3 0.3 0.3],...
                'MarkerFaceColor','w',...
                'MarkerSize',3); 
            
set(gca,'box','on','ylim',[-20 30],'FontSize',12);
%set(gca,'YTick',[0;200;400;600;800;1000;1200;1400;1600;1800]);
%set(gca,'YTickLabel',['0| |400| |800| |1200| |1600| ']);
%xlabel('Year','FontSize',13)
ylabel('NEP (\mum C m^{-2} s^{-1})','FontSize',13)

set(gca,'box','on','xlim',[0 87648],'FontSize',12);
set(gca,'XTick',[0;8760;17520;26304;35088;43848;52608;61368;70128;78888; 87648]);
set(gca,'XTickLabel',['|2003||2004||2005||2006||2007|']);
set(gca,'XTickLabel',[  ]);

text(900,26,'(a)','FontSize',12);
% aa=legend('TP39','TP74','TP89','TP02',2);
% set(aa,'box','off','FontSize',10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.15 .2 .75 .35])
hold on

plot(NEP74um,'k^',...
                'MarkerEdgeColor',[0.4 0.4 0.4],...
                'MarkerFaceColor','w',...
                'MarkerSize',3);  

plot(NEP89um,'ks',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','w',...
                'MarkerSize',3);  
            
plot(NEP02um,'kd',...
                'MarkerEdgeColor',[0.7 0.7 0.7],...
                'MarkerFaceColor','w',...
                'MarkerSize',3);  
            
set(gca,'box','on','ylim',[-30 50],'FontSize',12);
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
%set(gca,'YTickLabel',['0.4|0.6|0.8|1.0|1.2|1.4']);
ylabel('NEP (\mum C m^{-2} s^{-1})','FontSize',13)

set(gca,'box','on','xlim',[0 87648],'FontSize',12);
set(gca,'XTick',[0;8760;17520;26304;35088;43848;52608;61368;70128;78888; 87648]);
set(gca,'XTickLabel',['|2003||2004||2005||2006||2007|']);

aa = legend('TP74','TP89','TP02','Location','Best');
set(aa,'box','off','FontSize',10);

text(900,45,'(b)','FontSize',12);

print -dmeta   NEP_hhour_4sites; 
print -dtiff -r300  NEP_hhour_4sites; 
