%% This file was created to fill sapflow data:  Created by:  SLM June 10,
%% 2010 -  STEP #4 in the SAPFLOW RUNNING PROGRAM
% In order to fill data, two steps will be required.  1)  fixed sapflow
% data will be loaded, and the data will first be linearly interpolated (to
% a maximum of 3 points).  2)  The data will then be filled with the model
% outputs from the Neural Network (NN).

%% Step one:  Load the data (both modelled and fixed)

load 'C:\MacKay\Masters\data\hhour\model\ET1_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET1_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET2_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET2_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET3_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET3_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET4_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET4_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET5_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET5_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\ET6_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET6_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET7_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET7_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET8_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET8_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET9_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET9_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET10_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET10_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET22_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET22_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET23_fixed_hh10.dat';
%load 'C:\MacKay\Masters\data\hhour\model\ET23_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\ET11_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET11_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET12_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET12_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET13_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET13_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET14_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET14_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET15_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET15_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\ET16_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET16_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET17_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET17_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET18_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET18_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET19_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET19_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET20_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\ET20_hh10_NN.dat';

%%

ET1_fixed_hh10 = ET1_fixed_hh10(1:length(ET1_hh10_NN),:);
ET2_fixed_hh10 = ET2_fixed_hh10(1:length(ET1_hh10_NN),:);
ET3_fixed_hh10 = ET3_fixed_hh10(1:length(ET1_hh10_NN),:);
ET4_fixed_hh10 = ET4_fixed_hh10(1:length(ET1_hh10_NN),:);
ET5_fixed_hh10 = ET5_fixed_hh10(1:length(ET1_hh10_NN),:);

ET6_fixed_hh10 = ET6_fixed_hh10(1:length(ET1_hh10_NN),:);
ET7_fixed_hh10 = ET7_fixed_hh10(1:length(ET1_hh10_NN),:);
ET8_fixed_hh10 = ET8_fixed_hh10(1:length(ET1_hh10_NN),:);
ET9_fixed_hh10 = ET9_fixed_hh10(1:length(ET1_hh10_NN),:);
ET10_fixed_hh10 = ET10_fixed_hh10(1:length(ET1_hh10_NN),:);
ET22_fixed_hh10 = ET22_fixed_hh10(1:length(ET1_hh10_NN),:);

ET11_fixed_hh10 = ET11_fixed_hh10(1:length(ET1_hh10_NN),:);
ET12_fixed_hh10 = ET12_fixed_hh10(1:length(ET1_hh10_NN),:);
ET13_fixed_hh10 = ET13_fixed_hh10(1:length(ET1_hh10_NN),:);
ET14_fixed_hh10 = ET14_fixed_hh10(1:length(ET1_hh10_NN),:);
ET15_fixed_hh10 = ET15_fixed_hh10(1:length(ET1_hh10_NN),:);

ET16_fixed_hh10 = ET16_fixed_hh10(1:length(ET1_hh10_NN),:);
ET17_fixed_hh10 = ET17_fixed_hh10(1:length(ET1_hh10_NN),:);
ET18_fixed_hh10 = ET18_fixed_hh10(1:length(ET1_hh10_NN),:);
ET19_fixed_hh10 = ET19_fixed_hh10(1:length(ET1_hh10_NN),:);
ET20_fixed_hh10 = ET20_fixed_hh10(1:length(ET1_hh10_NN),:);

%% Step 2:  Linearly interpolate all the FIXED (not modelled) data

[ET1_filled1_hh10] = jjb_interp_gap(ET1_fixed_hh10);
[ET2_filled1_hh10] = jjb_interp_gap(ET2_fixed_hh10);
[ET3_filled1_hh10] = jjb_interp_gap(ET3_fixed_hh10);
[ET4_filled1_hh10] = jjb_interp_gap(ET4_fixed_hh10);
[ET5_filled1_hh10] = jjb_interp_gap(ET5_fixed_hh10);

[ET6_filled1_hh10] = jjb_interp_gap(ET6_fixed_hh10);
[ET7_filled1_hh10] = jjb_interp_gap(ET7_fixed_hh10);
[ET8_filled1_hh10] = jjb_interp_gap(ET8_fixed_hh10);
[ET9_filled1_hh10] = jjb_interp_gap(ET9_fixed_hh10);
[ET10_filled1_hh10] = jjb_interp_gap(ET10_fixed_hh10);
[ET22_filled1_hh10] = jjb_interp_gap(ET22_fixed_hh10);
[ET23_filled1_hh10] = jjb_interp_gap(ET23_fixed_hh10);

[ET11_filled1_hh10] = jjb_interp_gap(ET11_fixed_hh10);
[ET12_filled1_hh10] = jjb_interp_gap(ET12_fixed_hh10);
[ET13_filled1_hh10] = jjb_interp_gap(ET13_fixed_hh10);
[ET14_filled1_hh10] = jjb_interp_gap(ET14_fixed_hh10);
[ET15_filled1_hh10] = jjb_interp_gap(ET15_fixed_hh10);

[ET16_filled1_hh10] = jjb_interp_gap(ET16_fixed_hh10);
[ET17_filled1_hh10] = jjb_interp_gap(ET17_fixed_hh10);
[ET18_filled1_hh10] = jjb_interp_gap(ET18_fixed_hh10);
[ET19_filled1_hh10] = jjb_interp_gap(ET19_fixed_hh10);
[ET20_filled1_hh10] = jjb_interp_gap(ET20_fixed_hh10);

%% Step 3:  Fill all filled1 data now with the NN model output
%Find all the times when GEP is NOT NaN and fill the model with the real
%data whenever the real data is not NaN

ET1_filled1_hh10(isnan(ET1_filled1_hh10)) = ET1_hh10_NN(isnan(ET1_filled1_hh10)); 
ind = find(ET1_filled1_hh10<0);
ET1_filled1_hh10(ind) = NaN;
[ET1_filled_hh10] = jjb_interp_gap(ET1_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET1_filled_hh10.dat'  ET1_filled_hh10   -ASCII

clear ind;
ET2_filled1_hh10(isnan(ET2_filled1_hh10)) = ET2_hh10_NN(isnan(ET2_filled1_hh10)); 
ind = find(ET2_filled1_hh10<0);
ET2_filled1_hh10(ind) = NaN;
[ET2_filled_hh10] = jjb_interp_gap(ET2_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET2_filled_hh10.dat'  ET2_filled_hh10   -ASCII

clear ind;
ET3_filled1_hh10(isnan(ET3_filled1_hh10)) = ET3_hh10_NN(isnan(ET3_filled1_hh10)); 
ind = find(ET3_filled1_hh10<0);
ET3_filled1_hh10(ind) = NaN;
[ET3_filled_hh10] = jjb_interp_gap(ET3_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET3_filled_hh10.dat'  ET3_filled_hh10   -ASCII

clear ind;
ET4_filled1_hh10(isnan(ET4_filled1_hh10)) = ET4_hh10_NN(isnan(ET4_filled1_hh10)); 
ind = find(ET4_filled1_hh10<0);
ET4_filled1_hh10(ind) = NaN;
[ET4_filled_hh10] = jjb_interp_gap(ET4_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET4_filled_hh10.dat'  ET4_filled_hh10   -ASCII

ET5_filled1_hh10(isnan(ET5_filled1_hh10)) = ET5_hh10_NN(isnan(ET5_filled1_hh10)); 
clear ind;
ind = find(ET5_filled1_hh10<0);
ET5_filled1_hh10(ind) = NaN;
[ET5_filled_hh10] = jjb_interp_gap(ET5_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET5_filled_hh10.dat'  ET5_filled_hh10   -ASCII

ET6_filled1_hh10(isnan(ET6_filled1_hh10)) = ET6_hh10_NN(isnan(ET6_filled1_hh10)); 
clear ind;
ind = find(ET6_filled1_hh10<0);
ET6_filled1_hh10(ind) = NaN;
[ET6_filled_hh10] = jjb_interp_gap(ET6_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET6_filled_hh10.dat'  ET6_filled_hh10   -ASCII

ET7_filled1_hh10(isnan(ET7_filled1_hh10)) = ET7_hh10_NN(isnan(ET7_filled1_hh10)); 
clear ind;
ind = find(ET7_filled1_hh10<0);
ET7_filled1_hh10(ind) = NaN;
[ET7_filled_hh10] = jjb_interp_gap(ET7_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET7_filled_hh10.dat'  ET7_filled_hh10   -ASCII

ET8_filled1_hh10(isnan(ET8_filled1_hh10)) = ET8_hh10_NN(isnan(ET8_filled1_hh10)); 
clear ind;
ind = find(ET8_filled1_hh10<0);
ET8_filled1_hh10(ind) = NaN;
[ET8_filled_hh10] = jjb_interp_gap(ET8_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET8_filled_hh10.dat'  ET8_filled_hh10   -ASCII

ET9_filled1_hh10(isnan(ET9_filled1_hh10)) = ET9_hh10_NN(isnan(ET9_filled1_hh10)); 
clear ind;
ind = find(ET9_filled1_hh10<0);
ET9_filled1_hh10(ind) = NaN;
[ET9_filled_hh10] = jjb_interp_gap(ET9_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET9_filled_hh10.dat'  ET9_filled_hh10   -ASCII

ET10_filled1_hh10(isnan(ET10_filled1_hh10)) = ET10_hh10_NN(isnan(ET10_filled1_hh10));
clear ind;
ind = find(ET10_filled1_hh10<0);
ET10_filled1_hh10(ind) = NaN;
[ET10_filled_hh10] = jjb_interp_gap(ET10_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET10_filled_hh10.dat'  ET10_filled_hh10   -ASCII

ET22_filled1_hh10(isnan(ET22_filled1_hh10)) = ET22_hh10_NN(isnan(ET22_filled1_hh10)); 
clear ind;
ind = find(ET22_filled1_hh10<0);
ET22_filled1_hh10(ind) = NaN;
[ET22_filled_hh10] = jjb_interp_gap(ET22_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET22_filled_hh10.dat'  ET22_filled_hh10   -ASCII

% ET23_filled1_hh10(isnan(ET23_filled1_hh10)) = ET23_hh10_NN(isnan(ET23_filled1_hh10));
% clear ind;
% ind = find(ET23_filled1_hh10<0);
% ET23_filled1_hh10(ind) = NaN;
% [ET23_filled_hh10] = jjb_interp_gap(ET23_filled1_hh10);
% save 'C:\MacKay\Masters\data\hhour\filled\ET23_filled_hh10.dat'  ET23_filled_hh10   -ASCII

ET11_filled1_hh10(isnan(ET11_filled1_hh10)) = ET11_hh10_NN(isnan(ET11_filled1_hh10)); 
clear ind;
ind = find(ET11_filled1_hh10<0);
ET11_filled1_hh10(ind) = NaN;
[ET11_filled_hh10] = jjb_interp_gap(ET11_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET11_filled_hh10.dat'  ET11_filled_hh10   -ASCII

ET12_filled1_hh10(isnan(ET12_filled1_hh10)) = ET12_hh10_NN(isnan(ET12_filled1_hh10)); 
clear ind;
ind = find(ET12_filled1_hh10<0);
ET12_filled1_hh10(ind) = NaN;
[ET12_filled_hh10] = jjb_interp_gap(ET12_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET12_filled_hh10.dat'  ET12_filled_hh10   -ASCII

ET13_filled1_hh10(isnan(ET13_filled1_hh10)) = ET13_hh10_NN(isnan(ET13_filled1_hh10)); 
clear ind;
ind = find(ET13_filled1_hh10<0);
ET13_filled1_hh10(ind) = NaN;
[ET13_filled_hh10] = jjb_interp_gap(ET13_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET13_filled_hh10.dat'  ET13_filled_hh10   -ASCII

ET14_filled1_hh10(isnan(ET14_filled1_hh10)) = ET14_hh10_NN(isnan(ET14_filled1_hh10)); 
clear ind;
ind = find(ET14_filled1_hh10<0);
ET14_filled1_hh10(ind) = NaN;
[ET14_filled_hh10] = jjb_interp_gap(ET14_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET14_filled_hh10.dat'  ET14_filled_hh10   -ASCII

ET15_filled1_hh10(isnan(ET15_filled1_hh10)) = ET15_hh10_NN(isnan(ET15_filled1_hh10)); 
clear ind;
ind = find(ET15_filled1_hh10<0);
ET15_filled1_hh10(ind) = NaN;
[ET15_filled_hh10] = jjb_interp_gap(ET15_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET15_filled_hh10.dat'  ET15_filled_hh10   -ASCII

ET16_filled1_hh10(isnan(ET16_filled1_hh10)) = ET16_hh10_NN(isnan(ET16_filled1_hh10)); 
clear ind;
ind = find(ET16_filled1_hh10<0);
ET16_filled1_hh10(ind) = NaN;
[ET16_filled_hh10] = jjb_interp_gap(ET16_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET16_filled_hh10.dat'  ET16_filled_hh10   -ASCII

ET17_filled1_hh10(isnan(ET17_filled1_hh10)) = ET17_hh10_NN(isnan(ET17_filled1_hh10)); 
clear ind;
ind = find(ET17_filled1_hh10<0);
ET17_filled1_hh10(ind) = NaN;
[ET17_filled_hh10] = jjb_interp_gap(ET17_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET17_filled_hh10.dat'  ET17_filled_hh10   -ASCII

ET18_filled1_hh10(isnan(ET18_filled1_hh10)) = ET18_hh10_NN(isnan(ET18_filled1_hh10));
clear ind;
ind = find(ET18_filled1_hh10<0);
ET18_filled1_hh10(ind) = NaN;
[ET18_filled_hh10] = jjb_interp_gap(ET18_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET18_filled_hh10.dat'  ET18_filled_hh10   -ASCII

ET19_filled1_hh10(isnan(ET19_filled1_hh10)) = ET19_hh10_NN(isnan(ET19_filled1_hh10)); 
clear ind;
ind = find(ET19_filled1_hh10<0);
ET19_filled1_hh10(ind) = NaN;
[ET19_filled_hh10] = jjb_interp_gap(ET19_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET19_filled_hh10.dat'  ET19_filled_hh10   -ASCII

ET20_filled1_hh10(isnan(ET20_filled1_hh10)) = ET20_hh10_NN(isnan(ET20_filled1_hh10));
clear ind;
ind = find(ET20_filled1_hh10<0);
ET20_filled1_hh10(ind) = NaN;
[ET20_filled_hh10] = jjb_interp_gap(ET20_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\ET20_filled_hh10.dat'  ET20_filled_hh10   -ASCII

figure('Name','Test');clf;
hold on;
plot (ET6_filled_hh10,'b');
plot (ET6_fixed_hh10, 'r.');


WUE_Ec_2010_sf_filled_hh10(1:13,22)=NaN;
WUE_Ec_2010_ET(1,1)=(nansum(ET1_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,1)=(nansum(ET1_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,1)=(nansum(ET1_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,1)=(nansum(ET1_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,1)=(nansum(ET1_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,1)=(nansum(ET1_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,1)=(nansum(ET1_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,1)=(nansum(ET1_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,1)=(nansum(ET1_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,1)=(nansum(ET1_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,1)=(nansum(ET1_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,1)=(nansum(ET1_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,1)=(nansum(ET1_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,2)=(nansum(ET2_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,2)=(nansum(ET2_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,2)=(nansum(ET2_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,2)=(nansum(ET2_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,2)=(nansum(ET2_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,2)=(nansum(ET2_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,2)=(nansum(ET2_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,2)=(nansum(ET2_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,2)=(nansum(ET2_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,2)=(nansum(ET2_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,2)=(nansum(ET2_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,2)=(nansum(ET2_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,2)=(nansum(ET2_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,3)=(nansum(ET3_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,3)=(nansum(ET3_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,3)=(nansum(ET3_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,3)=(nansum(ET3_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,3)=(nansum(ET3_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,3)=(nansum(ET3_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,3)=(nansum(ET3_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,3)=(nansum(ET3_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,3)=(nansum(ET3_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,3)=(nansum(ET3_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,3)=(nansum(ET3_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,3)=(nansum(ET3_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,3)=(nansum(ET3_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,4)=(nansum(ET4_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,4)=(nansum(ET4_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,4)=(nansum(ET4_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,4)=(nansum(ET4_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,4)=(nansum(ET4_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,4)=(nansum(ET4_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,4)=(nansum(ET4_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,4)=(nansum(ET4_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,4)=(nansum(ET4_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,4)=(nansum(ET4_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,4)=(nansum(ET4_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,4)=(nansum(ET4_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,4)=(nansum(ET4_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,5)=(nansum(ET5_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,5)=(nansum(ET5_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,5)=(nansum(ET5_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,5)=(nansum(ET5_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,5)=(nansum(ET5_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,5)=(nansum(ET5_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,5)=(nansum(ET5_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,5)=(nansum(ET5_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,5)=(nansum(ET5_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,5)=(nansum(ET5_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,5)=(nansum(ET5_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,5)=(nansum(ET5_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,5)=(nansum(ET5_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,6)=(nansum(ET6_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,6)=(nansum(ET6_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,6)=(nansum(ET6_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,6)=(nansum(ET6_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,6)=(nansum(ET6_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,6)=(nansum(ET6_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,6)=(nansum(ET6_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,6)=(nansum(ET6_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,6)=(nansum(ET6_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,6)=(nansum(ET6_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,6)=(nansum(ET6_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,6)=(nansum(ET6_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,6)=(nansum(ET6_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,7)=(nansum(ET7_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,7)=(nansum(ET7_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,7)=(nansum(ET7_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,7)=(nansum(ET7_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,7)=(nansum(ET7_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,7)=(nansum(ET7_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,7)=(nansum(ET7_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,7)=(nansum(ET7_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,7)=(nansum(ET7_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,7)=(nansum(ET7_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,7)=(nansum(ET7_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,7)=(nansum(ET7_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,7)=(nansum(ET7_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,8)=(nansum(ET8_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,8)=(nansum(ET8_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,8)=(nansum(ET8_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,8)=(nansum(ET8_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,8)=(nansum(ET8_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,8)=(nansum(ET8_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,8)=(nansum(ET8_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,8)=(nansum(ET8_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,8)=(nansum(ET8_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,8)=(nansum(ET8_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,8)=(nansum(ET8_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,8)=(nansum(ET8_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,8)=(nansum(ET8_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,9)=(nansum(ET9_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,9)=(nansum(ET9_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,9)=(nansum(ET9_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,9)=(nansum(ET9_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,9)=(nansum(ET9_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,9)=(nansum(ET9_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,9)=(nansum(ET9_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,9)=(nansum(ET9_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,9)=(nansum(ET9_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,9)=(nansum(ET9_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,9)=(nansum(ET9_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,9)=(nansum(ET9_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,9)=(nansum(ET9_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,10)=(nansum(ET10_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,10)=(nansum(ET10_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,10)=(nansum(ET10_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,10)=(nansum(ET10_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,10)=(nansum(ET10_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,10)=(nansum(ET10_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,10)=(nansum(ET10_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,10)=(nansum(ET10_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,10)=(nansum(ET10_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,10)=(nansum(ET10_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,10)=(nansum(ET10_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,10)=(nansum(ET10_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,10)=(nansum(ET10_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,11)=(nansum(ET11_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,11)=(nansum(ET11_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,11)=(nansum(ET11_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,11)=(nansum(ET11_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,11)=(nansum(ET11_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,11)=(nansum(ET11_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,11)=(nansum(ET11_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,11)=(nansum(ET11_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,11)=(nansum(ET11_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,11)=(nansum(ET11_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,11)=(nansum(ET11_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,11)=(nansum(ET11_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,11)=(nansum(ET11_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,12)=(nansum(ET12_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,12)=(nansum(ET12_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,12)=(nansum(ET12_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,12)=(nansum(ET12_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,12)=(nansum(ET12_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,12)=(nansum(ET12_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,12)=(nansum(ET12_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,12)=(nansum(ET12_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,12)=(nansum(ET12_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,12)=(nansum(ET12_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,12)=(nansum(ET12_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,12)=(nansum(ET12_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,12)=(nansum(ET12_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,13)=(nansum(ET13_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,13)=(nansum(ET13_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,13)=(nansum(ET13_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,13)=(nansum(ET13_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,13)=(nansum(ET13_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,13)=(nansum(ET13_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,13)=(nansum(ET13_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,13)=(nansum(ET13_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,13)=(nansum(ET13_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,13)=(nansum(ET13_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,13)=(nansum(ET13_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,13)=(nansum(ET13_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,13)=(nansum(ET13_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,14)=(nansum(ET14_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,14)=(nansum(ET14_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,14)=(nansum(ET14_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,14)=(nansum(ET14_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,14)=(nansum(ET14_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,14)=(nansum(ET14_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,14)=(nansum(ET14_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,14)=(nansum(ET14_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,14)=(nansum(ET14_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,14)=(nansum(ET14_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,14)=(nansum(ET14_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,14)=(nansum(ET14_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,14)=(nansum(ET14_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,15)=(nansum(ET15_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,15)=(nansum(ET15_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,15)=(nansum(ET15_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,15)=(nansum(ET15_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,15)=(nansum(ET15_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,15)=(nansum(ET15_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,15)=(nansum(ET15_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,15)=(nansum(ET15_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,15)=(nansum(ET15_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,15)=(nansum(ET15_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,15)=(nansum(ET15_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,15)=(nansum(ET15_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,15)=(nansum(ET15_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,16)=(nansum(ET16_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,16)=(nansum(ET16_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,16)=(nansum(ET16_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,16)=(nansum(ET16_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,16)=(nansum(ET16_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,16)=(nansum(ET16_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,16)=(nansum(ET16_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,16)=(nansum(ET16_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,16)=(nansum(ET16_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,16)=(nansum(ET16_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,16)=(nansum(ET16_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,16)=(nansum(ET16_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,16)=(nansum(ET16_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,17)=(nansum(ET17_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,17)=(nansum(ET17_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,17)=(nansum(ET17_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,17)=(nansum(ET17_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,17)=(nansum(ET17_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,17)=(nansum(ET17_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,17)=(nansum(ET17_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,17)=(nansum(ET17_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,17)=(nansum(ET17_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,17)=(nansum(ET17_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,17)=(nansum(ET17_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,17)=(nansum(ET17_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,17)=(nansum(ET17_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,18)=(nansum(ET18_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,18)=(nansum(ET18_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,18)=(nansum(ET18_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,18)=(nansum(ET18_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,18)=(nansum(ET18_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,18)=(nansum(ET18_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,18)=(nansum(ET18_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,18)=(nansum(ET18_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,18)=(nansum(ET18_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,18)=(nansum(ET18_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,18)=(nansum(ET18_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,18)=(nansum(ET18_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,18)=(nansum(ET18_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,19)=(nansum(ET19_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,19)=(nansum(ET19_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,19)=(nansum(ET19_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,19)=(nansum(ET19_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,19)=(nansum(ET19_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,19)=(nansum(ET19_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,19)=(nansum(ET19_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,19)=(nansum(ET19_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,19)=(nansum(ET19_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,19)=(nansum(ET19_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,19)=(nansum(ET19_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,19)=(nansum(ET19_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,19)=(nansum(ET19_filled_hh10(1:15168)));
WUE_Ec_2010_ET(1,20)=(nansum(ET20_filled_hh10(1:5040)));
WUE_Ec_2010_ET(2,20)=(nansum(ET20_filled_hh10(1:7392)));
WUE_Ec_2010_ET(3,20)=(nansum(ET20_filled_hh10(1:7776)));
WUE_Ec_2010_ET(4,20)=(nansum(ET20_filled_hh10(1:8832)));
WUE_Ec_2010_ET(5,20)=(nansum(ET20_filled_hh10(1:9648)));
WUE_Ec_2010_ET(6,20)=(nansum(ET20_filled_hh10(1:10416)));
WUE_Ec_2010_ET(7,20)=(nansum(ET20_filled_hh10(1:10800)));
WUE_Ec_2010_ET(8,20)=(nansum(ET20_filled_hh10(1:11808)));
WUE_Ec_2010_ET(9,20)=(nansum(ET20_filled_hh10(1:12384)));
WUE_Ec_2010_ET(10,20)=(nansum(ET20_filled_hh10(1:13152)));
WUE_Ec_2010_ET(11,20)=(nansum(ET20_filled_hh10(1:13824)));
WUE_Ec_2010_ET(12,20)=(nansum(ET20_filled_hh10(1:14160)));
WUE_Ec_2010_ET(13,20)=(nansum(ET20_filled_hh10(1:15168)));

DLMWRITE('C:/MacKay/multi/WUE_Ec_2010_ET_filled.csv',WUE_Ec_2010_ET,',');
