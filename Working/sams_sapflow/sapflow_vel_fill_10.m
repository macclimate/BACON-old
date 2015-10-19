%This file was created to fill sapflow data:  Created by:  SLM June 10,
%2010
% In order to fill data, two steps will be required.  1)  fixed sapflow
% data will be loaded, and the data will first be linearly interpolated (to
% a maximum of 3 points).  2)  The data will then be filled with the model
% outputs from the Neural Nsfvel_work (NN).

%% Step one:  Load the data (both modelled and fixed)

load 'C:\MacKay\Masters\data\hhour\model\sfvel_1_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_1_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_2_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_2_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_3_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_3_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_4_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_4_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_5_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_5_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sfvel_6_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_6_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_7_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_7_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_8_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_8_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_9_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_9_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_10_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_10_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_22_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_22_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_23_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_23_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sfvel_11_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_11_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_12_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_12_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_13_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_13_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_14_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_14_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_15_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_15_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sfvel_16_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_16_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_17_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_17_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_18_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_18_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_19_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_19_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_20_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sfvel_20_hh10_NN.dat';

%% Step 2:  Linearly interpolate all the FIXED (not modelled) data

[sfvel_1_filled1_hh10] = jjb_interp_gap(sfvel_1_fixed_hh10);
[sfvel_2_filled1_hh10] = jjb_interp_gap(sfvel_2_fixed_hh10);
[sfvel_3_filled1_hh10] = jjb_interp_gap(sfvel_3_fixed_hh10);
[sfvel_4_filled1_hh10] = jjb_interp_gap(sfvel_4_fixed_hh10);
[sfvel_5_filled1_hh10] = jjb_interp_gap(sfvel_5_fixed_hh10);

[sfvel_6_filled1_hh10] = jjb_interp_gap(sfvel_6_fixed_hh10);
[sfvel_7_filled1_hh10] = jjb_interp_gap(sfvel_7_fixed_hh10);
[sfvel_8_filled1_hh10] = jjb_interp_gap(sfvel_8_fixed_hh10);
[sfvel_9_filled1_hh10] = jjb_interp_gap(sfvel_9_fixed_hh10);
[sfvel_10_filled1_hh10] = jjb_interp_gap(sfvel_10_fixed_hh10);
[sfvel_22_filled1_hh10] = jjb_interp_gap(sfvel_22_fixed_hh10);
[sfvel_23_filled1_hh10] = jjb_interp_gap(sfvel_23_fixed_hh10);

[sfvel_11_filled1_hh10] = jjb_interp_gap(sfvel_11_fixed_hh10);
[sfvel_12_filled1_hh10] = jjb_interp_gap(sfvel_12_fixed_hh10);
[sfvel_13_filled1_hh10] = jjb_interp_gap(sfvel_13_fixed_hh10);
[sfvel_14_filled1_hh10] = jjb_interp_gap(sfvel_14_fixed_hh10);
[sfvel_15_filled1_hh10] = jjb_interp_gap(sfvel_15_fixed_hh10);

[sfvel_16_filled1_hh10] = jjb_interp_gap(sfvel_16_fixed_hh10);
[sfvel_17_filled1_hh10] = jjb_interp_gap(sfvel_17_fixed_hh10);
[sfvel_18_filled1_hh10] = jjb_interp_gap(sfvel_18_fixed_hh10);
[sfvel_19_filled1_hh10] = jjb_interp_gap(sfvel_19_fixed_hh10);
[sfvel_20_filled1_hh10] = jjb_interp_gap(sfvel_20_fixed_hh10);


%% Step 3:  Make the NN output files the same length as the actual datassfvel_s
% (17520).  

% sfvel_1_filled1_hh10 = sfvel_1_filled1_hh10(length(sfvel_1_hh10_NN));
% sfvel_2_filled1_hh10 = sfvel_2_filled1_hh10(length(sfvel_2_hh10_NN));
% sfvel_3_filled1_hh10 = sfvel_3_filled1_hh10(length(sfvel_3_hh10_NN));
% sfvel_4_filled2_hh10 = sfvel_4_filled1_hh10(length(sfvel_4_hh10_NN));
% sfvel_5_filled2_hh10 = sfvel_5_filled1_hh10(length(sfvel_5_hh10_NN));


%% Step 4:  Fill all filled1 data now with the NN model output
%Find all the times when GEP is NOT NaN and fill the model with the real
%data whenever the real data is not NaN

sfvel_1_filled1_hh10(isnan(sfvel_1_filled1_hh10)) = sfvel_1_hh10_NN(isnan(sfvel_1_filled1_hh10)); 
ind = find(sfvel_1_filled1_hh10<0);
sfvel_1_filled1_hh10(ind) = NaN;
[sfvel_1_filled_hh10] = jjb_interp_gap15(sfvel_1_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_1_filled_hh10.dat'  sfvel_1_filled_hh10   -ASCII

clear ind;
sfvel_2_filled1_hh10(isnan(sfvel_2_filled1_hh10)) = sfvel_2_hh10_NN(isnan(sfvel_2_filled1_hh10)); 
ind = find(sfvel_2_filled1_hh10<0);
sfvel_2_filled1_hh10(ind) = NaN;
[sfvel_2_filled_hh10] = jjb_interp_gap15(sfvel_2_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_2_filled_hh10.dat'  sfvel_2_filled_hh10   -ASCII

clear ind;
sfvel_3_filled1_hh10(isnan(sfvel_3_filled1_hh10)) = sfvel_3_hh10_NN(isnan(sfvel_3_filled1_hh10)); 
ind = find(sfvel_3_filled1_hh10<0);
sfvel_3_filled1_hh10(ind) = NaN;
[sfvel_3_filled_hh10] = jjb_interp_gap15(sfvel_3_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_3_filled_hh10.dat'  sfvel_3_filled_hh10   -ASCII

clear ind;
sfvel_4_filled1_hh10(isnan(sfvel_4_filled1_hh10)) = sfvel_4_hh10_NN(isnan(sfvel_4_filled1_hh10)); 
ind = find(sfvel_4_filled1_hh10<0);
sfvel_4_filled1_hh10(ind) = NaN;
[sfvel_4_filled_hh10] = jjb_interp_gap15(sfvel_4_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_4_filled_hh10.dat'  sfvel_4_filled_hh10   -ASCII

sfvel_5_filled1_hh10(isnan(sfvel_5_filled1_hh10)) = sfvel_5_hh10_NN(isnan(sfvel_5_filled1_hh10)); 
clear ind;
ind = find(sfvel_5_filled1_hh10<0);
sfvel_5_filled1_hh10(ind) = NaN;
[sfvel_5_filled_hh10] = jjb_interp_gap15(sfvel_5_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_5_filled_hh10.dat'  sfvel_5_filled_hh10   -ASCII

sfvel_6_filled1_hh10(isnan(sfvel_6_filled1_hh10)) = sfvel_6_hh10_NN(isnan(sfvel_6_filled1_hh10)); 
clear ind;
ind = find(sfvel_6_filled1_hh10<0);
sfvel_6_filled1_hh10(ind) = NaN;
[sfvel_6_filled_hh10] = jjb_interp_gap15(sfvel_6_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_6_filled_hh10.dat'  sfvel_6_filled_hh10   -ASCII

sfvel_7_filled1_hh10(isnan(sfvel_7_filled1_hh10)) = sfvel_7_hh10_NN(isnan(sfvel_7_filled1_hh10)); 
clear ind;
ind = find(sfvel_7_filled1_hh10<0);
sfvel_7_filled1_hh10(ind) = NaN;
[sfvel_7_filled_hh10] = jjb_interp_gap15(sfvel_7_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_7_filled_hh10.dat'  sfvel_7_filled_hh10   -ASCII

sfvel_8_filled1_hh10(isnan(sfvel_8_filled1_hh10)) = sfvel_8_hh10_NN(isnan(sfvel_8_filled1_hh10)); 
clear ind;
ind = find(sfvel_8_filled1_hh10<0);
sfvel_8_filled1_hh10(ind) = NaN;
[sfvel_8_filled_hh10] = jjb_interp_gap15(sfvel_8_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_8_filled_hh10.dat'  sfvel_8_filled_hh10   -ASCII

sfvel_9_filled1_hh10(isnan(sfvel_9_filled1_hh10)) = sfvel_9_hh10_NN(isnan(sfvel_9_filled1_hh10)); 
clear ind;
ind = find(sfvel_9_filled1_hh10<0);
sfvel_9_filled1_hh10(ind) = NaN;
[sfvel_9_filled_hh10] = jjb_interp_gap15(sfvel_9_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_9_filled_hh10.dat'  sfvel_9_filled_hh10   -ASCII

sfvel_10_filled1_hh10(isnan(sfvel_10_filled1_hh10)) = sfvel_10_hh10_NN(isnan(sfvel_10_filled1_hh10));
clear ind;
ind = find(sfvel_10_filled1_hh10<0);
sfvel_10_filled1_hh10(ind) = NaN;
[sfvel_10_filled_hh10] = jjb_interp_gap15(sfvel_10_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_10_filled_hh10.dat'  sfvel_10_filled_hh10   -ASCII

sfvel_22_filled1_hh10(isnan(sfvel_22_filled1_hh10)) = sfvel_22_hh10_NN(isnan(sfvel_22_filled1_hh10)); 
clear ind;
ind = find(sfvel_22_filled1_hh10<0);
sfvel_22_filled1_hh10(ind) = NaN;
[sfvel_22_filled_hh10] = jjb_interp_gap15(sfvel_22_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_22_filled_hh10.dat'  sfvel_22_filled_hh10   -ASCII

sfvel_23_filled1_hh10(isnan(sfvel_23_filled1_hh10)) = sfvel_23_hh10_NN(isnan(sfvel_23_filled1_hh10));
clear ind;
ind = find(sfvel_23_filled1_hh10<0);
sfvel_23_filled1_hh10(ind) = NaN;
[sfvel_23_filled_hh10] = jjb_interp_gap15(sfvel_23_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_23_filled_hh10.dat'  sfvel_23_filled_hh10   -ASCII

sfvel_11_filled1_hh10(isnan(sfvel_11_filled1_hh10)) = sfvel_11_hh10_NN(isnan(sfvel_11_filled1_hh10)); 
clear ind;
ind = find(sfvel_11_filled1_hh10<0);
sfvel_11_filled1_hh10(ind) = NaN;
[sfvel_11_filled_hh10] = jjb_interp_gap15(sfvel_11_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_11_filled_hh10.dat'  sfvel_11_filled_hh10   -ASCII

sfvel_12_filled1_hh10(isnan(sfvel_12_filled1_hh10)) = sfvel_12_hh10_NN(isnan(sfvel_12_filled1_hh10)); 
clear ind;
ind = find(sfvel_12_filled1_hh10<0);
sfvel_12_filled1_hh10(ind) = NaN;
[sfvel_12_filled_hh10] = jjb_interp_gap15(sfvel_12_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_12_filled_hh10.dat'  sfvel_12_filled_hh10   -ASCII

sfvel_13_filled1_hh10(isnan(sfvel_13_filled1_hh10)) = sfvel_13_hh10_NN(isnan(sfvel_13_filled1_hh10)); 
clear ind;
ind = find(sfvel_13_filled1_hh10<0);
sfvel_13_filled1_hh10(ind) = NaN;
[sfvel_13_filled_hh10] = jjb_interp_gap15(sfvel_13_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_13_filled_hh10.dat'  sfvel_13_filled_hh10   -ASCII

sfvel_14_filled1_hh10(isnan(sfvel_14_filled1_hh10)) = sfvel_14_hh10_NN(isnan(sfvel_14_filled1_hh10)); 
clear ind;
ind = find(sfvel_14_filled1_hh10<0);
sfvel_14_filled1_hh10(ind) = NaN;
[sfvel_14_filled_hh10] = jjb_interp_gap15(sfvel_14_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_14_filled_hh10.dat'  sfvel_14_filled_hh10   -ASCII

sfvel_15_filled1_hh10(isnan(sfvel_15_filled1_hh10)) = sfvel_15_hh10_NN(isnan(sfvel_15_filled1_hh10)); 
clear ind;
ind = find(sfvel_15_filled1_hh10<0);
sfvel_15_filled1_hh10(ind) = NaN;
[sfvel_15_filled_hh10] = jjb_interp_gap15(sfvel_15_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_15_filled_hh10.dat'  sfvel_15_filled_hh10   -ASCII

sfvel_16_filled1_hh10(isnan(sfvel_16_filled1_hh10)) = sfvel_16_hh10_NN(isnan(sfvel_16_filled1_hh10)); 
clear ind;
ind = find(sfvel_16_filled1_hh10<0);
sfvel_16_filled1_hh10(ind) = NaN;
[sfvel_16_filled_hh10] = jjb_interp_gap15(sfvel_16_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_16_filled_hh10.dat'  sfvel_16_filled_hh10   -ASCII

sfvel_17_filled1_hh10(isnan(sfvel_17_filled1_hh10)) = sfvel_17_hh10_NN(isnan(sfvel_17_filled1_hh10)); 
clear ind;
ind = find(sfvel_17_filled1_hh10<0);
sfvel_17_filled1_hh10(ind) = NaN;
[sfvel_17_filled_hh10] = jjb_interp_gap15(sfvel_17_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_17_filled_hh10.dat'  sfvel_17_filled_hh10   -ASCII

sfvel_18_filled1_hh10(isnan(sfvel_18_filled1_hh10)) = sfvel_18_hh10_NN(isnan(sfvel_18_filled1_hh10));
clear ind;
ind = find(sfvel_18_filled1_hh10<0);
sfvel_18_filled1_hh10(ind) = NaN;
[sfvel_18_filled_hh10] = jjb_interp_gap15(sfvel_18_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_18_filled_hh10.dat'  sfvel_18_filled_hh10   -ASCII

sfvel_19_filled1_hh10(isnan(sfvel_19_filled1_hh10)) = sfvel_19_hh10_NN(isnan(sfvel_19_filled1_hh10)); 
clear ind;
ind = find(sfvel_19_filled1_hh10<0);
sfvel_19_filled1_hh10(ind) = NaN;
[sfvel_19_filled_hh10] = jjb_interp_gap15(sfvel_19_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_19_filled_hh10.dat'  sfvel_19_filled_hh10   -ASCII

sfvel_20_filled1_hh10(isnan(sfvel_20_filled1_hh10)) = sfvel_20_hh10_NN(isnan(sfvel_20_filled1_hh10));
clear ind;
ind = find(sfvel_20_filled1_hh10<0);
sfvel_20_filled1_hh10(ind) = NaN;
[sfvel_20_filled_hh10] = jjb_interp_gap15(sfvel_20_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sfvel_20_filled_hh10.dat'  sfvel_20_filled_hh10   -ASCII

figure('Name','Test');clf;
hold on;
plot (sfvel_6_filled_hh10,'b');
plot (sfvel_6_fixed_hh10, 'r.');
