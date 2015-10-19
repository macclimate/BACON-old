% Monthly time series of PAR, Ta, PPT
% Altaf Arain, 20 October 2008


%close all; clear all; clc

%% Load PPT and Ta data

%TP39
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2003_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2003_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2003_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2003_model4_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2004_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2004_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2004_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2004_model4_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2005_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2005_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2005_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2005_model4_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2006_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2006_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2006_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2006_model4_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2007_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2007_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2007_model4_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2007_model4_monmean.dat

M1_PAR = [M1_PAR_2003_model4_monmean M1_PAR_2004_model4_monmean M1_PAR_2005_model4_monmean M1_PAR_2006_model4_monmean M1_PAR_2007_model4_monmean];
M1_Ta = [M1_Ta_2003_model4_monmean M1_Ta_2004_model4_monmean M1_Ta_2005_model4_monmean M1_Ta_2006_model4_monmean M1_Ta_2007_model4_monmean];
M1_Ts = [M1_Ts_2003_model4_monmean M1_Ts_2004_model4_monmean M1_Ts_2005_model4_monmean M1_Ts_2006_model4_monmean M1_Ts_2007_model4_monmean];
M1_SM = [M1_SM_2003_model4_monmean M1_SM_2004_model4_monmean M1_SM_2005_model4_monmean M1_SM_2006_model4_monmean M1_SM_2007_model4_monmean];


M1_PAR_monts = reshape(M1_PAR,1,60);
M1_Ta_monts  = reshape(M1_Ta,1,60);
M1_Ts_monts  = reshape(M1_Ts,1,60);
M1_SM_monts  = reshape(M1_SM,1,60);


M1_PAR_ann = [mean(M1_PAR_2003_model4_monmean(1:12,:)) mean(M1_PAR_2004_model4_monmean(1:12,:)) mean(M1_PAR_2005_model4_monmean(1:12,:)) mean(M1_PAR_2006_model4_monmean(1:12,:)) mean(M1_PAR_2007_model4_monmean(1:12,:))];
M1_Ta_ann = [mean(M1_Ta_2003_model4_monmean(1:12,:)) mean(M1_Ta_2004_model4_monmean(1:12,:)) mean(M1_Ta_2005_model4_monmean(1:12,:)) mean(M1_Ta_2006_model4_monmean(1:12,:)) mean(M1_Ta_2007_model4_monmean(1:12,:))];
M1_Ts_ann = [mean(M1_Ts_2003_model4_monmean(1:12,:)) mean(M1_Ts_2004_model4_monmean(1:12,:)) mean(M1_Ts_2005_model4_monmean(1:12,:)) mean(M1_Ts_2006_model4_monmean(1:12,:)) mean(M1_Ts_2007_model4_monmean(1:12,:))];
M1_SM_ann = [mean(M1_SM_2003_model4_monmean(1:12,:)) mean(M1_SM_2004_model4_monmean(1:12,:)) mean(M1_SM_2005_model4_monmean(1:12,:)) mean(M1_SM_2006_model4_monmean(1:12,:)) mean(M1_SM_2007_model4_monmean(1:12,:))];



%TP74
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2003_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2004_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2005_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2006_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2007_model3_monmean.dat

M2_PAR = [M2_PAR_2003_model3_monmean M2_PAR_2004_model3_monmean M2_PAR_2005_model3_monmean M2_PAR_2006_model3_monmean M2_PAR_2007_model3_monmean];
M2_Ta = [M2_Ta_2003_model3_monmean M2_Ta_2004_model3_monmean M2_Ta_2005_model3_monmean M2_Ta_2006_model3_monmean M2_Ta_2007_model3_monmean];
M2_Ts = [M2_Ts_2003_model3_monmean M2_Ts_2004_model3_monmean M2_Ts_2005_model3_monmean M2_Ts_2006_model3_monmean M2_Ts_2007_model3_monmean];
M2_SM = [M2_SM_2003_model3_monmean M2_SM_2004_model3_monmean M2_SM_2005_model3_monmean M2_SM_2006_model3_monmean M2_SM_2007_model3_monmean];

M2_PAR_monts = reshape(M2_PAR,1,60);
M2_Ta_monts  = reshape(M2_Ta,1,60);
M2_Ts_monts  = reshape(M2_Ts,1,60);
M2_SM_monts  = reshape(M2_SM,1,60);

M2_PAR_ann= [mean(M2_PAR_2003_model3_monmean(1:12,:)) mean(M2_PAR_2004_model3_monmean(1:12,:)) mean(M2_PAR_2005_model3_monmean(1:12,:)) mean(M2_PAR_2006_model3_monmean(1:12,:)) mean(M2_PAR_2007_model3_monmean(1:12,:))];
M2_Ta_ann = [mean(M2_Ta_2003_model3_monmean(1:12,:))  mean(M2_Ta_2004_model3_monmean(1:12,:))  mean(M2_Ta_2005_model3_monmean(1:12,:))  mean(M2_Ta_2006_model3_monmean(1:12,:))  mean(M2_Ta_2007_model3_monmean(1:12,:))];
M2_Ts_ann = [mean(M2_Ts_2003_model3_monmean(1:12,:))  mean(M2_Ts_2004_model3_monmean(1:12,:))  mean(M2_Ts_2005_model3_monmean(1:12,:))  mean(M2_Ts_2006_model3_monmean(1:12,:))  mean(M2_Ts_2007_model3_monmean(1:12,:))];
M2_SM_ann = [mean(M2_SM_2003_model3_monmean(1:12,:))  mean(M2_SM_2004_model3_monmean(1:12,:))  mean(M2_SM_2005_model3_monmean(1:12,:))  mean(M2_SM_2006_model3_monmean(1:12,:))  mean(M2_SM_2007_model3_monmean(1:12,:))];


%TP89
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2003_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2004_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2005_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2006_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2007_model3_monmean.dat

M3_PAR = [M3_PAR_2003_model3_monmean M3_PAR_2004_model3_monmean M3_PAR_2005_model3_monmean M3_PAR_2006_model3_monmean M3_PAR_2007_model3_monmean];
M3_Ta = [M3_Ta_2003_model3_monmean M3_Ta_2004_model3_monmean M3_Ta_2005_model3_monmean M3_Ta_2006_model3_monmean M3_Ta_2007_model3_monmean];
M3_Ts = [M3_Ts_2003_model3_monmean M3_Ts_2004_model3_monmean M3_Ts_2005_model3_monmean M3_Ts_2006_model3_monmean M3_Ts_2007_model3_monmean];
M3_SM = [M3_SM_2003_model3_monmean M3_SM_2004_model3_monmean M3_SM_2005_model3_monmean M3_SM_2006_model3_monmean M3_SM_2007_model3_monmean];

M3_PAR_monts = reshape(M3_PAR,1,60);
M3_Ta_monts  = reshape(M3_Ta,1,60);
M3_Ts_monts  = reshape(M3_Ts,1,60);
M3_SM_monts  = reshape(M3_SM,1,60);

M3_PAR_ann= [mean(M3_PAR_2003_model3_monmean(1:12,:)) mean(M3_PAR_2004_model3_monmean(1:12,:)) mean(M3_PAR_2005_model3_monmean(1:12,:)) mean(M3_PAR_2006_model3_monmean(1:12,:)) mean(M3_PAR_2007_model3_monmean(1:12,:))];
M3_Ta_ann = [mean(M3_Ta_2003_model3_monmean(1:12,:))  mean(M3_Ta_2004_model3_monmean(1:12,:))  mean(M3_Ta_2005_model3_monmean(1:12,:))  mean(M3_Ta_2006_model3_monmean(1:12,:))  mean(M3_Ta_2007_model3_monmean(1:12,:))];
M3_Ts_ann = [mean(M3_Ts_2003_model3_monmean(1:12,:))  mean(M3_Ts_2004_model3_monmean(1:12,:))  mean(M3_Ts_2005_model3_monmean(1:12,:))  mean(M3_Ts_2006_model3_monmean(1:12,:))  mean(M3_Ts_2007_model3_monmean(1:12,:))];
M3_SM_ann = [mean(M3_SM_2003_model3_monmean(1:12,:))  mean(M3_SM_2004_model3_monmean(1:12,:))  mean(M3_SM_2005_model3_monmean(1:12,:))  mean(M3_SM_2006_model3_monmean(1:12,:))  mean(M3_SM_2007_model3_monmean(1:12,:))];


%TP02
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2003_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2003_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2004_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2004_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2005_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2005_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2006_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2006_model3_monmean.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2007_model3_monmean.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2007_model3_monmean.dat

M4_PAR = [M4_PAR_2003_model3_monmean M4_PAR_2004_model3_monmean M4_PAR_2005_model3_monmean M4_PAR_2006_model3_monmean M4_PAR_2007_model3_monmean];
M4_Ta = [M4_Ta_2003_model3_monmean M4_Ta_2004_model3_monmean M4_Ta_2005_model3_monmean M4_Ta_2006_model3_monmean M4_Ta_2007_model3_monmean];
M4_Ts = [M4_Ts_2003_model3_monmean M4_Ts_2004_model3_monmean M4_Ts_2005_model3_monmean M4_Ts_2006_model3_monmean M4_Ts_2007_model3_monmean];
M4_SM = [M4_SM_2003_model3_monmean M4_SM_2004_model3_monmean M4_SM_2005_model3_monmean M4_SM_2006_model3_monmean M4_SM_2007_model3_monmean];

M4_PAR_monts = reshape(M4_PAR,1,60);
M4_Ta_monts  = reshape(M4_Ta,1,60);
M4_Ts_monts  = reshape(M4_Ts,1,60);
M4_SM_monts  = reshape(M4_SM,1,60);

M4_PAR_ann= [mean(M4_PAR_2003_model3_monmean(1:12,:)) mean(M4_PAR_2004_model3_monmean(1:12,:)) mean(M4_PAR_2005_model3_monmean(1:12,:)) mean(M4_PAR_2006_model3_monmean(1:12,:)) mean(M4_PAR_2007_model3_monmean(1:12,:))];
M4_Ta_ann = [mean(M4_Ta_2003_model3_monmean(1:12,:))  mean(M4_Ta_2004_model3_monmean(1:12,:))  mean(M4_Ta_2005_model3_monmean(1:12,:))  mean(M4_Ta_2006_model3_monmean(1:12,:))  mean(M4_Ta_2007_model3_monmean(1:12,:))];
M4_Ts_ann = [mean(M4_Ts_2003_model3_monmean(1:12,:))  mean(M4_Ts_2004_model3_monmean(1:12,:))  mean(M4_Ts_2005_model3_monmean(1:12,:))  mean(M4_Ts_2006_model3_monmean(1:12,:))  mean(M4_Ts_2007_model3_monmean(1:12,:))];
M4_SM_ann = [mean(M4_SM_2003_model3_monmean(1:12,:))  mean(M4_SM_2004_model3_monmean(1:12,:))  mean(M4_SM_2005_model3_monmean(1:12,:))  mean(M4_SM_2006_model3_monmean(1:12,:))  mean(M4_SM_2007_model3_monmean(1:12,:))];


PAR_ann = [M1_PAR_ann' M2_PAR_ann' M3_PAR_ann' M4_PAR_ann' ];
Ta_ann = [M1_Ta_ann' M2_Ta_ann' M3_Ta_ann' M4_Ta_ann' ];
Ts_ann = [M1_Ts_ann' M2_Ts_ann' M3_Ts_ann' M4_Ts_ann' ];
SM_ann = [M1_SM_ann' M2_SM_ann' M3_SM_ann' M4_SM_ann' ];



%%%%%%%%%%%%%%%%%%%%%%%%%
% Monthly Total vlaues
%TP39

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2003_model4_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2004_model4_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2005_model4_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2006_model4_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_PAR_2007_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ta_2007_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_Ts_2007_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M1_SM_2007_model4_monsum.dat

M1_PAR_sum = [M1_PAR_2003_model4_monsum M1_PAR_2004_model4_monsum M1_PAR_2005_model4_monsum M1_PAR_2006_model4_monsum M1_PAR_2007_model4_monsum];
M1_Ta_sum = [M1_Ta_2003_model4_monsum M1_Ta_2004_model4_monsum M1_Ta_2005_model4_monsum M1_Ta_2006_model4_monsum M1_Ta_2007_model4_monsum];
M1_Ts_sum = [M1_Ts_2003_model4_monsum M1_Ts_2004_model4_monsum M1_Ts_2005_model4_monsum M1_Ts_2006_model4_monsum M1_Ts_2007_model4_monsum];
M1_SM_sum = [M1_SM_2003_model4_monsum M1_SM_2004_model4_monsum M1_SM_2005_model4_monsum M1_SM_2006_model4_monsum M1_SM_2007_model4_monsum];

M1_PAR_monsum = reshape(M1_PAR_sum,1,60);

M1_PAR_sum_ann = [sum(M1_PAR_2003_model4_monsum(1:12,:)) sum(M1_PAR_2004_model4_monsum(1:12,:)) sum(M1_PAR_2005_model4_monsum(1:12,:)) sum(M1_PAR_2006_model4_monsum(1:12,:)) sum(M1_PAR_2007_model4_monsum(1:12,:))];
M1_Ta_sum_ann  = [sum(M1_Ta_2003_model4_monsum(1:12,:))  sum(M1_Ta_2004_model4_monsum(1:12,:))  sum(M1_Ta_2005_model4_monsum(1:12,:))  sum(M1_Ta_2006_model4_monsum(1:12,:))  sum(M1_Ta_2007_model4_monsum(1:12,:))];
M1_Ts_sum_ann  = [sum(M1_Ts_2003_model4_monsum(1:12,:))  sum(M1_Ts_2004_model4_monsum(1:12,:))  sum(M1_Ts_2005_model4_monsum(1:12,:))  sum(M1_Ts_2006_model4_monsum(1:12,:))  sum(M1_Ts_2007_model4_monsum(1:12,:))];
M1_SM_sum_ann  = [sum(M1_SM_2003_model4_monsum(1:12,:))  sum(M1_SM_2004_model4_monsum(1:12,:))  sum(M1_SM_2005_model4_monsum(1:12,:))  sum(M1_SM_2006_model4_monsum(1:12,:))  sum(M1_SM_2007_model4_monsum(1:12,:))];


%TP74

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2003_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2004_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2005_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2006_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_PAR_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ta_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_Ts_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M2_SM_2007_model3_monsum.dat

M2_PAR_sum = [M2_PAR_2003_model3_monsum M2_PAR_2004_model3_monsum M2_PAR_2005_model3_monsum M2_PAR_2006_model3_monsum M2_PAR_2007_model3_monsum];
M2_Ta_sum = [M2_Ta_2003_model3_monsum M2_Ta_2004_model3_monsum M2_Ta_2005_model3_monsum M2_Ta_2006_model3_monsum M2_Ta_2007_model3_monsum];
M2_Ts_sum = [M2_Ts_2003_model3_monsum M2_Ts_2004_model3_monsum M2_Ts_2005_model3_monsum M2_Ts_2006_model3_monsum M2_Ts_2007_model3_monsum];
M2_SM_sum = [M2_SM_2003_model3_monsum M2_SM_2004_model3_monsum M2_SM_2005_model3_monsum M2_SM_2006_model3_monsum M2_SM_2007_model3_monsum];

M2_PAR_monsum = reshape(M2_PAR_sum,1,60);

M2_PAR_sum_ann = [sum(M2_PAR_2003_model3_monsum(1:12,:)) sum(M2_PAR_2004_model3_monsum(1:12,:)) sum(M2_PAR_2005_model3_monsum(1:12,:)) sum(M2_PAR_2006_model3_monsum(1:12,:)) sum(M2_PAR_2007_model3_monsum(1:12,:))];
M2_Ta_sum_ann  = [sum(M2_Ta_2003_model3_monsum(1:12,:))  sum(M2_Ta_2004_model3_monsum(1:12,:))  sum(M2_Ta_2005_model3_monsum(1:12,:))  sum(M2_Ta_2006_model3_monsum(1:12,:))  sum(M2_Ta_2007_model3_monsum(1:12,:))];
M2_Ts_sum_ann  = [sum(M2_Ts_2003_model3_monsum(1:12,:))  sum(M2_Ts_2004_model3_monsum(1:12,:))  sum(M2_Ts_2005_model3_monsum(1:12,:))  sum(M2_Ts_2006_model3_monsum(1:12,:))  sum(M2_Ts_2007_model3_monsum(1:12,:))];
M2_SM_sum_ann  = [sum(M2_SM_2003_model3_monsum(1:12,:))  sum(M2_SM_2004_model3_monsum(1:12,:))  sum(M2_SM_2005_model3_monsum(1:12,:))  sum(M2_SM_2006_model3_monsum(1:12,:))  sum(M2_SM_2007_model3_monsum(1:12,:))];



%TP89

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2003_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2004_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2005_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2006_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_PAR_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ta_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_Ts_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M3_SM_2007_model3_monsum.dat

M3_PAR_sum = [M3_PAR_2003_model3_monsum M3_PAR_2004_model3_monsum M3_PAR_2005_model3_monsum M3_PAR_2006_model3_monsum M3_PAR_2007_model3_monsum];
M3_Ta_sum = [M3_Ta_2003_model3_monsum M3_Ta_2004_model3_monsum M3_Ta_2005_model3_monsum M3_Ta_2006_model3_monsum M3_Ta_2007_model3_monsum];
M3_Ts_sum = [M3_Ts_2003_model3_monsum M3_Ts_2004_model3_monsum M3_Ts_2005_model3_monsum M3_Ts_2006_model3_monsum M3_Ts_2007_model3_monsum];
M3_SM_sum = [M3_SM_2003_model3_monsum M3_SM_2004_model3_monsum M3_SM_2005_model3_monsum M3_SM_2006_model3_monsum M3_SM_2007_model3_monsum];

M3_PAR_monsum = reshape(M3_PAR_sum,1,60);

M3_PAR_sum_ann = [sum(M3_PAR_2003_model3_monsum(1:12,:)) sum(M3_PAR_2004_model3_monsum(1:12,:)) sum(M3_PAR_2005_model3_monsum(1:12,:)) sum(M3_PAR_2006_model3_monsum(1:12,:)) sum(M3_PAR_2007_model3_monsum(1:12,:))];
M3_Ta_sum_ann = [sum(M3_Ta_2003_model3_monsum(1:12,:))  sum(M3_Ta_2004_model3_monsum(1:12,:))  sum(M3_Ta_2005_model3_monsum(1:12,:))  sum(M3_Ta_2006_model3_monsum(1:12,:))  sum(M3_Ta_2007_model3_monsum(1:12,:))];
M3_Ts_sum_ann  = [sum(M3_Ts_2003_model3_monsum(1:12,:))  sum(M3_Ts_2004_model3_monsum(1:12,:))  sum(M3_Ts_2005_model3_monsum(1:12,:))  sum(M3_Ts_2006_model3_monsum(1:12,:))  sum(M3_Ts_2007_model3_monsum(1:12,:))];
M3_SM_sum_ann  = [sum(M3_SM_2003_model3_monsum(1:12,:))  sum(M3_SM_2004_model3_monsum(1:12,:))  sum(M3_SM_2005_model3_monsum(1:12,:))  sum(M3_SM_2006_model3_monsum(1:12,:))  sum(M3_SM_2007_model3_monsum(1:12,:))];


%TP02

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2003_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2004_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2005_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2006_model3_monsum.dat

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_PAR_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ta_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_Ts_2007_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\M4_SM_2007_model3_monsum.dat

M4_PAR_sum = [M4_PAR_2003_model3_monsum M4_PAR_2004_model3_monsum M4_PAR_2005_model3_monsum M4_PAR_2006_model3_monsum M4_PAR_2007_model3_monsum];
M4_Ta_sum = [M4_Ta_2003_model3_monsum M4_Ta_2004_model3_monsum M4_Ta_2005_model3_monsum M4_Ta_2006_model3_monsum M4_Ta_2007_model3_monsum];
M4_Ts_sum = [M4_Ts_2003_model3_monsum M4_Ts_2004_model3_monsum M4_Ts_2005_model3_monsum M4_Ts_2006_model3_monsum M4_Ts_2007_model3_monsum];
M4_SM_sum = [M4_SM_2003_model3_monsum M4_SM_2004_model3_monsum M4_SM_2005_model3_monsum M4_SM_2006_model3_monsum M4_SM_2007_model3_monsum];

M4_PAR_monsum = reshape(M4_PAR_sum,1,60);

M4_PAR_sum_ann = [sum(M4_PAR_2003_model3_monsum(1:12,:)) sum(M4_PAR_2004_model3_monsum(1:12,:)) sum(M4_PAR_2005_model3_monsum(1:12,:)) sum(M4_PAR_2006_model3_monsum(1:12,:)) sum(M4_PAR_2007_model3_monsum(1:12,:))];
M4_Ta_sum_ann  = [sum(M4_Ta_2003_model3_monsum(1:12,:))  sum(M4_Ta_2004_model3_monsum(1:12,:))  sum(M4_Ta_2005_model3_monsum(1:12,:))  sum(M4_Ta_2006_model3_monsum(1:12,:))  sum(M4_Ta_2007_model3_monsum(1:12,:))];
M4_Ts_sum_ann  = [sum(M4_Ts_2003_model3_monsum(1:12,:))  sum(M4_Ts_2004_model3_monsum(1:12,:))  sum(M4_Ts_2005_model3_monsum(1:12,:))  sum(M4_Ts_2006_model3_monsum(1:12,:))  sum(M4_Ts_2007_model3_monsum(1:12,:))];
M4_SM_sum_ann  = [sum(M4_SM_2003_model3_monsum(1:12,:))  sum(M4_SM_2004_model3_monsum(1:12,:))  sum(M4_SM_2005_model3_monsum(1:12,:))  sum(M4_SM_2006_model3_monsum(1:12,:))  sum(M4_SM_2007_model3_monsum(1:12,:))];


PAR_sum_ann = [M1_PAR_sum_ann' M2_PAR_sum_ann' M3_PAR_sum_ann' M4_PAR_sum_ann' ];
Ta_sum_ann = [M1_Ta_sum_ann' M2_Ta_sum_ann' M3_Ta_sum_ann' M4_Ta_sum_ann' ];
Ts_sum_ann = [M1_Ts_sum_ann' M2_Ts_sum_ann' M3_Ts_sum_ann' M4_Ts_sum_ann' ];
SM_sum_ann = [M1_SM_sum_ann' M2_SM_sum_ann' M3_SM_sum_ann' M4_SM_sum_ann' ];


%% PPT data
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\PPT_months_M1_allyears.txt
M1_PPT_sum = PPT_months_M1_allyears;
M1_PPT_sum_ann = [sum(M1_PPT_sum(1:12,1)) sum(M1_PPT_sum(1:12,2)) sum(M1_PPT_sum(1:12,3)) sum(M1_PPT_sum(1:12,4)) sum(M1_PPT_sum(1:12,5))];
M1_PPT_sum_Spr = [sum(M1_PPT_sum(5:6,1)) sum(M1_PPT_sum(5:6,2)) sum(M1_PPT_sum(5:6,3)) sum(M1_PPT_sum(5:6,4)) sum(M1_PPT_sum(5:6,5))];


load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\PPT_months_M4_allyears.txt
M4_PPT_sum = PPT_months_M4_allyears;
M4_PPT_sum_ann = [sum(M4_PPT_sum(1:12,1)) sum(M4_PPT_sum(1:12,2)) sum(M4_PPT_sum(1:12,3)) sum(M4_PPT_sum(1:12,4)) sum(M4_PPT_sum(1:12,5))];
M4_PPT_sum_Spr = [sum(M4_PPT_sum(5:6,1)) sum(M4_PPT_sum(5:6,2)) sum(M4_PPT_sum(5:6,3)) sum(M4_PPT_sum(5:6,4)) sum(M4_PPT_sum(5:6,5))];

PPT_sum_ann = [M1_PPT_sum_ann' M1_PPT_sum_ann' M1_PPT_sum_ann' M4_PPT_sum_ann'];
PPT_sum_Spr = [M1_PPT_sum_Spr' M1_PPT_sum_Spr' M1_PPT_sum_Spr' M4_PPT_sum_Spr'];

M1_PPT_monts = reshape(M1_PPT_sum ,1,60);
M4_PPT_monts = reshape(M4_PPT_sum ,1,60);

PPT_monts = [M1_PPT_monts' M4_PPT_monts'];
errors(60,2) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(gcf)
figure('unit','inches','PaperOrientation','Landscape','PaperPosition',[.1 0.1 9. 7.0],...
'position',[0.1    0.1    9.0    7.0]);

axes('Position',[.1 .7 .45 .25])
hold on

plot(M1_PAR_monsum,'ko-',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',4);   
plot(M2_PAR_monsum,'k-','LineWidth',1)  
plot(M3_PAR_monsum,'Color',[.6 .6 .6],'LineWidth',1.0)  
plot(M4_PAR_monsum,'k-.','LineWidth',1)   
            
            
set(gca,'box','on','xlim',[0 61],'FontSize',12);
set(gca,'XTick',[0;6;12;18;24;30;36;42;48;54;60]);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[0 1800],'FontSize',12);
set(gca,'YTick',[0;200;400;600;800;1000;1200;1400;1600;1800]);
set(gca,'YTickLabel',['0| |400| |800| |1200| |1600| ']);
%xlabel('Year','FontSize',13)
ylabel('PAR (mol m^{-2} month^{-1})','FontSize',13)

text(57,1650,'(a)','FontSize',12);
aa=legend('TP39','TP74','TP89','TP02',2);
set(aa,'box','off','FontSize',8);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.57 .7 .30 .25])
hold on

% plot(M1_PAR_sum(:,1),'k-d',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_PAR_sum(:,2),'k-v',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_PAR_sum(:,3),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);  
% plot(M1_PAR_sum(:,4),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);   
% plot(M1_PAR_sum(:,5),'k-^',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);    

plot(M1_PAR_sum(:,1),'k-','LineWidth',1.0)              
plot(M1_PAR_sum(:,2),'Color',[.6 .6 .6],'LineWidth',1.0)              
plot(M1_PAR_sum(:,3),'k-','LineWidth',2)                
plot(M1_PAR_sum(:,4),'k--','LineWidth',2.0)                
plot(M1_PAR_sum(:,5),'Color',[.6 .6 .6],'LineWidth',2)                
   
            
set(gca,'box','on','xlim',[0 13],'FontSize',12);
set(gca,'XTick',[0;1;2;3;4;5;6;7;8;9;10;11;12;13]);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[0 1800],'FontSize',12);
set(gca,'YTick',[0;200;400;600;800;1000;1200;1400;1600;1800]);
set(gca,'YTickLabel',[ ]);
%xlabel('Year','FontSize',13)
%ylabel('PAR (umol m^{-2} month^{-1})','FontSize',13)

text(0.5,1650,'(d)','FontSize',12);
aa=legend('2003','2004','2005','2006','2007',1);
set(aa,'box','off','FontSize',8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.1 .4 .45 .25])
hold on

plot(M1_Ta_monts,'ko-',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',4);   
plot(M2_Ta_monts,'k-','LineWidth',1)  
plot(M3_Ta_monts,'Color',[.6 .6 .6],'LineWidth',1.0)  
plot(M4_Ta_monts,'k-.','LineWidth',1)   


set(gca,'box','on','xlim',[0 61],'FontSize',12);
set(gca,'XTick',[0;6;12;18;24;30;36;42;48;54;60]);
%set(gca,'XTickLabel',['2003|2004|2005|2006|2007']);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[-10 25],'FontSize',12);
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
%set(gca,'YTickLabel',['0.4|0.6|0.8|1.0|1.2|1.4']);
 
%xlabel('Year','FontSize',13)
ylabel('Ta (^oC)','FontSize',13)
text(57,21,'(b)','FontSize',12);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.57 .4 .30 .25])
hold on

% plot(M1_Ta(:,1),'k-d',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_Ta(:,2),'k-v',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_Ta(:,3),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);  
% plot(M1_Ta(:,4),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);   
% plot(M1_Ta(:,5),'k-^',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);    

plot(M1_Ta(:,1),'k-','LineWidth',1.0)              
plot(M1_Ta(:,2),'Color',[.6 .6 .6],'LineWidth',1.0)              
plot(M1_Ta(:,3),'k-','LineWidth',2)                
plot(M1_Ta(:,4),'k--','LineWidth',2.0)                
plot(M1_Ta(:,5),'Color',[.6 .6 .6],'LineWidth',2) 

set(gca,'box','on','xlim',[0 13],'FontSize',12);
set(gca,'XTick',[0;1;2;3;4;5;6;7;8;9;10;11;12;13]);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[-10 25],'FontSize',12);
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
set(gca,'YTickLabel',[ ]);
%xlabel('Year','FontSize',13)
%ylabel('PAR (umol m^{-2} month^{-1})','FontSize',13)

text(0.5,21,'(e)','FontSize',12);
%aa=legend('2003','2004','2005','2006','2007',1);
%set(aa,'box','off','FontSize',8);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.1 .10 .45 .25])
hold on

plot(M1_Ts_monts,'ko-',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',4);   
plot(M2_Ts_monts,'k-','LineWidth',1)  
plot(M3_Ts_monts,'Color',[.6 .6 .6],'LineWidth',1.0)  
plot(M4_Ts_monts,'k-.','LineWidth',1)  
            
set(gca,'box','on','xlim',[0 61],'FontSize',12);
set(gca,'XTick',[0;6;12;18;24;30;36;42;48;54;60]);
set(gca,'XTickLabel',['|2003| |2004| |2005| |2006| |2007| ']);

set(gca,'box','on','ylim',[-5 30],'FontSize',12);
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
%set(gca,'YTickLabel',['0.4|0.6|0.8|1.0|1.2|1.4']);
%xlabel('Year','FontSize',13)
ylabel('Ts (^oC)','FontSize',13)

text(57,27,'(c)','FontSize',12);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.57 .10 .30 .25])
hold on

% plot(M1_Ts(:,1),'k-d',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_Ts(:,2),'k-v',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);  
% plot(M1_Ts(:,3),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);  
% plot(M1_Ts(:,4),'k-o',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','w',...
%                 'MarkerSize',5);   
% plot(M1_Ts(:,5),'k-^',...               
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',5);    

plot(M1_Ts(:,1),'k-','LineWidth',1.0)              
plot(M1_Ts(:,2),'Color',[.6 .6 .6],'LineWidth',1.0)              
plot(M1_Ts(:,3),'k-','LineWidth',2)                
plot(M1_Ts(:,4),'k--','LineWidth',2.0)                
plot(M1_Ts(:,5),'Color',[.6 .6 .6],'LineWidth',2) 


set(gca,'box','on','xlim',[0 13],'FontSize',12);
set(gca,'XTick',[0;1;2;3;4;5;6;7;8;9;10;11;12;13]);
set(gca,'XTickLabel',['|J|F|M|A|M|J|J|A|S|O|N|D|'  ]);

set(gca,'box','on','ylim',[-5 30],'FontSize',12);
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
set(gca,'YTickLabel',[ ]);
%xlabel('Year','FontSize',13)
%ylabel('PAR (umol m^{-2} month^{-1})','FontSize',13)

text(0.5,27,'(f)','FontSize',12);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print -dmeta PAR_Ta_Ts_monthly_ts; 
print -dtiff -r300  PAR_Ta_Ts_monthly_ts; 

