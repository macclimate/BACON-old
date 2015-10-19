%This file was created to fill sapflow data:  Created by:  SLM June 10,
%2010
% In order to fill data, two steps will be required.  1)  fixed sapflow
% data will be loaded, and the data will first be linearly interpolated (to
% a maximum of 3 points).  2)  The data will then be filled with the model
% outputs from the Neural Nsfwork (NN).

%% Step one:  Load the data (both modelled and fixed)

load 'C:\MacKay\Masters\data\hhour\model\sf1_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf1_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf2_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf2_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf3_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf3_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf4_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf4_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf5_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf5_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sf6_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf6_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf7_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf7_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf8_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf8_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf9_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf9_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf10_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf10_hh10_NN.dat';
% load 'C:\MacKay\Masters\data\hhour\model\sf22_fixed_hh10.dat';
% load 'C:\MacKay\Masters\data\hhour\model\sf22_hh10_NN.dat';
% load 'C:\MacKay\Masters\data\hhour\model\sf23_fixed_hh10.dat';
% load 'C:\MacKay\Masters\data\hhour\model\sf23_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sf11_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf11_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf12_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf12_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf13_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf13_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf14_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf14_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf15_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf15_hh10_NN.dat';

load 'C:\MacKay\Masters\data\hhour\model\sf16_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf16_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf17_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf17_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf18_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf18_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf19_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf19_hh10_NN.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf20_fixed_hh10.dat';
load 'C:\MacKay\Masters\data\hhour\model\sf20_hh10_NN.dat';

%% Step 2:  Linearly interpolate all the FIXED (not modelled) data

[sf1_filled1_hh10] = jjb_interp_gap(sf1_fixed_hh10);
[sf2_filled1_hh10] = jjb_interp_gap(sf2_fixed_hh10);
[sf3_filled1_hh10] = jjb_interp_gap(sf3_fixed_hh10);
[sf4_filled1_hh10] = jjb_interp_gap(sf4_fixed_hh10);
[sf5_filled1_hh10] = jjb_interp_gap(sf5_fixed_hh10);

[sf6_filled1_hh10] = jjb_interp_gap(sf6_fixed_hh10);
[sf7_filled1_hh10] = jjb_interp_gap(sf7_fixed_hh10);
[sf8_filled1_hh10] = jjb_interp_gap(sf8_fixed_hh10);
[sf9_filled1_hh10] = jjb_interp_gap(sf9_fixed_hh10);
[sf10_filled1_hh10] = jjb_interp_gap(sf10_fixed_hh10);
% [sf22_filled1_hh10] = jjb_interp_gap(sf22_fixed_hh10);
% [sf23_filled1_hh10] = jjb_interp_gap(sf23_fixed_hh10);

[sf11_filled1_hh10] = jjb_interp_gap(sf11_fixed_hh10);
[sf12_filled1_hh10] = jjb_interp_gap(sf12_fixed_hh10);
[sf13_filled1_hh10] = jjb_interp_gap(sf13_fixed_hh10);
[sf14_filled1_hh10] = jjb_interp_gap(sf14_fixed_hh10);
[sf15_filled1_hh10] = jjb_interp_gap(sf15_fixed_hh10);

[sf16_filled1_hh10] = jjb_interp_gap(sf16_fixed_hh10);
[sf17_filled1_hh10] = jjb_interp_gap(sf17_fixed_hh10);
[sf18_filled1_hh10] = jjb_interp_gap(sf18_fixed_hh10);
[sf19_filled1_hh10] = jjb_interp_gap(sf19_fixed_hh10);
[sf20_filled1_hh10] = jjb_interp_gap(sf20_fixed_hh10);


%% Step 3:  Make the NN output files the same length as the actual datassfs
% (17520).  

% sf1_filled1_hh10 = sf1_filled1_hh10(length(sf1_hh10_NN));
% sf2_filled1_hh10 = sf2_filled1_hh10(length(sf2_hh10_NN));
% sf3_filled1_hh10 = sf3_filled1_hh10(length(sf3_hh10_NN));
% sf4_filled2_hh10 = sf4_filled1_hh10(length(sf4_hh10_NN));
% sf5_filled2_hh10 = sf5_filled1_hh10(length(sf5_hh10_NN));


%% Step 4:  Fill all filled1 data now with the NN model output
%Find all the times when GEP is NOT NaN and fill the model with the real
%data whenever the real data is not NaN

sf1_filled1_hh10(isnan(sf1_filled1_hh10)) = sf1_hh10_NN(isnan(sf1_filled1_hh10)); 
ind = find(sf1_filled1_hh10<0);
sf1_filled1_hh10(ind) = NaN;
[sf1_filled_hh10] = jjb_interp_gap15(sf1_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf1_filled_hh10.dat'  sf1_filled_hh10   -ASCII

clear ind;
sf2_filled1_hh10(isnan(sf2_filled1_hh10)) = sf2_hh10_NN(isnan(sf2_filled1_hh10)); 
ind = find(sf2_filled1_hh10<0);
sf2_filled1_hh10(ind) = NaN;
[sf2_filled_hh10] = jjb_interp_gap15(sf2_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf2_filled_hh10.dat'  sf2_filled_hh10   -ASCII

clear ind;
sf3_filled1_hh10(isnan(sf3_filled1_hh10)) = sf3_hh10_NN(isnan(sf3_filled1_hh10)); 
ind = find(sf3_filled1_hh10<0);
sf3_filled1_hh10(ind) = NaN;
[sf3_filled_hh10] = jjb_interp_gap15(sf3_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf3_filled_hh10.dat'  sf3_filled_hh10   -ASCII

clear ind;
sf4_filled1_hh10(isnan(sf4_filled1_hh10)) = sf4_hh10_NN(isnan(sf4_filled1_hh10)); 
ind = find(sf4_filled1_hh10<0);
sf4_filled1_hh10(ind) = NaN;
[sf4_filled_hh10] = jjb_interp_gap15(sf4_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf4_filled_hh10.dat'  sf4_filled_hh10   -ASCII

sf5_filled1_hh10(isnan(sf5_filled1_hh10)) = sf5_hh10_NN(isnan(sf5_filled1_hh10)); 
clear ind;
ind = find(sf5_filled1_hh10<0);
sf5_filled1_hh10(ind) = NaN;
[sf5_filled_hh10] = jjb_interp_gap15(sf5_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf5_filled_hh10.dat'  sf5_filled_hh10   -ASCII

sf6_filled1_hh10(isnan(sf6_filled1_hh10)) = sf6_hh10_NN(isnan(sf6_filled1_hh10)); 
clear ind;
ind = find(sf6_filled1_hh10<0);
sf6_filled1_hh10(ind) = NaN;
[sf6_filled_hh10] = jjb_interp_gap15(sf6_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf6_filled_hh10.dat'  sf6_filled_hh10   -ASCII

sf7_filled1_hh10(isnan(sf7_filled1_hh10)) = sf7_hh10_NN(isnan(sf7_filled1_hh10)); 
clear ind;
ind = find(sf7_filled1_hh10<0);
sf7_filled1_hh10(ind) = NaN;
[sf7_filled_hh10] = jjb_interp_gap15(sf7_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf7_filled_hh10.dat'  sf7_filled_hh10   -ASCII

sf8_filled1_hh10(isnan(sf8_filled1_hh10)) = sf8_hh10_NN(isnan(sf8_filled1_hh10)); 
clear ind;
ind = find(sf8_filled1_hh10<0);
sf8_filled1_hh10(ind) = NaN;
[sf8_filled_hh10] = jjb_interp_gap15(sf8_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf8_filled_hh10.dat'  sf8_filled_hh10   -ASCII

sf9_filled1_hh10(isnan(sf9_filled1_hh10)) = sf9_hh10_NN(isnan(sf9_filled1_hh10)); 
clear ind;
ind = find(sf9_filled1_hh10<0);
sf9_filled1_hh10(ind) = NaN;
[sf9_filled_hh10] = jjb_interp_gap15(sf9_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf9_filled_hh10.dat'  sf9_filled_hh10   -ASCII

sf10_filled1_hh10(isnan(sf10_filled1_hh10)) = sf10_hh10_NN(isnan(sf10_filled1_hh10));
clear ind;
ind = find(sf10_filled1_hh10<0);
sf10_filled1_hh10(ind) = NaN;
[sf10_filled_hh10] = jjb_interp_gap15(sf10_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf10_filled_hh10.dat'  sf10_filled_hh10   -ASCII

% sf22_filled1_hh10(isnan(sf22_filled1_hh10)) = sf22_hh10_NN(isnan(sf22_filled1_hh10)); 
% clear ind;
% ind = find(sf22_filled1_hh10<0);
% sf22_filled1_hh10(ind) = NaN;
% [sf22_filled_hh10] = jjb_interp_gap15(sf22_filled1_hh10);
% save 'C:\MacKay\Masters\data\hhour\filled\sf22_filled_hh10.dat'  sf22_filled_hh10   -ASCII
% 
% sf23_filled1_hh10(isnan(sf23_filled1_hh10)) = sf23_hh10_NN(isnan(sf23_filled1_hh10));
% clear ind;
% ind = find(sf23_filled1_hh10<0);
% sf23_filled1_hh10(ind) = NaN;
% [sf23_filled_hh10] = jjb_interp_gap15(sf23_filled1_hh10);
% save 'C:\MacKay\Masters\data\hhour\filled\sf23_filled_hh10.dat'  sf23_filled_hh10   -ASCII

sf11_filled1_hh10(isnan(sf11_filled1_hh10)) = sf11_hh10_NN(isnan(sf11_filled1_hh10)); 
clear ind;
ind = find(sf11_filled1_hh10<0);
sf11_filled1_hh10(ind) = NaN;
[sf11_filled_hh10] = jjb_interp_gap15(sf11_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf11_filled_hh10.dat'  sf11_filled_hh10   -ASCII

sf12_filled1_hh10(isnan(sf12_filled1_hh10)) = sf12_hh10_NN(isnan(sf12_filled1_hh10)); 
clear ind;
ind = find(sf12_filled1_hh10<0);
sf12_filled1_hh10(ind) = NaN;
[sf12_filled_hh10] = jjb_interp_gap15(sf12_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf12_filled_hh10.dat'  sf12_filled_hh10   -ASCII

sf13_filled1_hh10(isnan(sf13_filled1_hh10)) = sf13_hh10_NN(isnan(sf13_filled1_hh10)); 
clear ind;
ind = find(sf13_filled1_hh10<0);
sf13_filled1_hh10(ind) = NaN;
[sf13_filled_hh10] = jjb_interp_gap15(sf13_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf13_filled_hh10.dat'  sf13_filled_hh10   -ASCII

sf14_filled1_hh10(isnan(sf14_filled1_hh10)) = sf14_hh10_NN(isnan(sf14_filled1_hh10)); 
clear ind;
ind = find(sf14_filled1_hh10<0);
sf14_filled1_hh10(ind) = NaN;
[sf14_filled_hh10] = jjb_interp_gap15(sf14_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf14_filled_hh10.dat'  sf14_filled_hh10   -ASCII

sf15_filled1_hh10(isnan(sf15_filled1_hh10)) = sf15_hh10_NN(isnan(sf15_filled1_hh10)); 
clear ind;
ind = find(sf15_filled1_hh10<0);
sf15_filled1_hh10(ind) = NaN;
[sf15_filled_hh10] = jjb_interp_gap15(sf15_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf15_filled_hh10.dat'  sf15_filled_hh10   -ASCII

sf16_filled1_hh10(isnan(sf16_filled1_hh10)) = sf16_hh10_NN(isnan(sf16_filled1_hh10)); 
clear ind;
ind = find(sf16_filled1_hh10<0);
sf16_filled1_hh10(ind) = NaN;
[sf16_filled_hh10] = jjb_interp_gap15(sf16_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf16_filled_hh10.dat'  sf16_filled_hh10   -ASCII

sf17_filled1_hh10(isnan(sf17_filled1_hh10)) = sf17_hh10_NN(isnan(sf17_filled1_hh10)); 
clear ind;
ind = find(sf17_filled1_hh10<0);
sf17_filled1_hh10(ind) = NaN;
[sf17_filled_hh10] = jjb_interp_gap15(sf17_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf17_filled_hh10.dat'  sf17_filled_hh10   -ASCII

sf18_filled1_hh10(isnan(sf18_filled1_hh10)) = sf18_hh10_NN(isnan(sf18_filled1_hh10));
clear ind;
ind = find(sf18_filled1_hh10<0);
sf18_filled1_hh10(ind) = NaN;
[sf18_filled_hh10] = jjb_interp_gap15(sf18_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf18_filled_hh10.dat'  sf18_filled_hh10   -ASCII

sf19_filled1_hh10(isnan(sf19_filled1_hh10)) = sf19_hh10_NN(isnan(sf19_filled1_hh10)); 
clear ind;
ind = find(sf19_filled1_hh10<0);
sf19_filled1_hh10(ind) = NaN;
[sf19_filled_hh10] = jjb_interp_gap15(sf19_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf19_filled_hh10.dat'  sf19_filled_hh10   -ASCII

sf20_filled1_hh10(isnan(sf20_filled1_hh10)) = sf20_hh10_NN(isnan(sf20_filled1_hh10));
clear ind;
ind = find(sf20_filled1_hh10<0);
sf20_filled1_hh10(ind) = NaN;
[sf20_filled_hh10] = jjb_interp_gap15(sf20_filled1_hh10);
save 'C:\MacKay\Masters\data\hhour\filled\sf20_filled_hh10.dat'  sf20_filled_hh10   -ASCII

figure('Name','Test');clf;
hold on;
plot (sf6_filled_hh10,'b');
plot (sf6_fixed_hh10, 'r.');

WUE_Ec_2010_sf_filled_hh10(1:13,22)=NaN;
WUE_Ec_2010_sf(1,1)=(nansum(sf1_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,1)=(nansum(sf1_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,1)=(nansum(sf1_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,1)=(nansum(sf1_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,1)=(nansum(sf1_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,1)=(nansum(sf1_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,1)=(nansum(sf1_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,1)=(nansum(sf1_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,1)=(nansum(sf1_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,1)=(nansum(sf1_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,1)=(nansum(sf1_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,1)=(nansum(sf1_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,1)=(nansum(sf1_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,2)=(nansum(sf2_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,2)=(nansum(sf2_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,2)=(nansum(sf2_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,2)=(nansum(sf2_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,2)=(nansum(sf2_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,2)=(nansum(sf2_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,2)=(nansum(sf2_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,2)=(nansum(sf2_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,2)=(nansum(sf2_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,2)=(nansum(sf2_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,2)=(nansum(sf2_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,2)=(nansum(sf2_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,2)=(nansum(sf2_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,3)=(nansum(sf3_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,3)=(nansum(sf3_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,3)=(nansum(sf3_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,3)=(nansum(sf3_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,3)=(nansum(sf3_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,3)=(nansum(sf3_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,3)=(nansum(sf3_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,3)=(nansum(sf3_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,3)=(nansum(sf3_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,3)=(nansum(sf3_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,3)=(nansum(sf3_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,3)=(nansum(sf3_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,3)=(nansum(sf3_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,4)=(nansum(sf4_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,4)=(nansum(sf4_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,4)=(nansum(sf4_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,4)=(nansum(sf4_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,4)=(nansum(sf4_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,4)=(nansum(sf4_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,4)=(nansum(sf4_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,4)=(nansum(sf4_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,4)=(nansum(sf4_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,4)=(nansum(sf4_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,4)=(nansum(sf4_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,4)=(nansum(sf4_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,4)=(nansum(sf4_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,5)=(nansum(sf5_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,5)=(nansum(sf5_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,5)=(nansum(sf5_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,5)=(nansum(sf5_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,5)=(nansum(sf5_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,5)=(nansum(sf5_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,5)=(nansum(sf5_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,5)=(nansum(sf5_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,5)=(nansum(sf5_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,5)=(nansum(sf5_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,5)=(nansum(sf5_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,5)=(nansum(sf5_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,5)=(nansum(sf5_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,6)=(nansum(sf6_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,6)=(nansum(sf6_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,6)=(nansum(sf6_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,6)=(nansum(sf6_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,6)=(nansum(sf6_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,6)=(nansum(sf6_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,6)=(nansum(sf6_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,6)=(nansum(sf6_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,6)=(nansum(sf6_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,6)=(nansum(sf6_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,6)=(nansum(sf6_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,6)=(nansum(sf6_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,6)=(nansum(sf6_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,7)=(nansum(sf7_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,7)=(nansum(sf7_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,7)=(nansum(sf7_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,7)=(nansum(sf7_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,7)=(nansum(sf7_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,7)=(nansum(sf7_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,7)=(nansum(sf7_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,7)=(nansum(sf7_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,7)=(nansum(sf7_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,7)=(nansum(sf7_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,7)=(nansum(sf7_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,7)=(nansum(sf7_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,7)=(nansum(sf7_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,8)=(nansum(sf8_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,8)=(nansum(sf8_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,8)=(nansum(sf8_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,8)=(nansum(sf8_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,8)=(nansum(sf8_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,8)=(nansum(sf8_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,8)=(nansum(sf8_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,8)=(nansum(sf8_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,8)=(nansum(sf8_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,8)=(nansum(sf8_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,8)=(nansum(sf8_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,8)=(nansum(sf8_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,8)=(nansum(sf8_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,9)=(nansum(sf9_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,9)=(nansum(sf9_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,9)=(nansum(sf9_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,9)=(nansum(sf9_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,9)=(nansum(sf9_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,9)=(nansum(sf9_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,9)=(nansum(sf9_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,9)=(nansum(sf9_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,9)=(nansum(sf9_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,9)=(nansum(sf9_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,9)=(nansum(sf9_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,9)=(nansum(sf9_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,9)=(nansum(sf9_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,10)=(nansum(sf10_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,10)=(nansum(sf10_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,10)=(nansum(sf10_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,10)=(nansum(sf10_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,10)=(nansum(sf10_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,10)=(nansum(sf10_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,10)=(nansum(sf10_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,10)=(nansum(sf10_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,10)=(nansum(sf10_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,10)=(nansum(sf10_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,10)=(nansum(sf10_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,10)=(nansum(sf10_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,10)=(nansum(sf10_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,11)=(nansum(sf11_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,11)=(nansum(sf11_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,11)=(nansum(sf11_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,11)=(nansum(sf11_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,11)=(nansum(sf11_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,11)=(nansum(sf11_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,11)=(nansum(sf11_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,11)=(nansum(sf11_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,11)=(nansum(sf11_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,11)=(nansum(sf11_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,11)=(nansum(sf11_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,11)=(nansum(sf11_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,11)=(nansum(sf11_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,12)=(nansum(sf12_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,12)=(nansum(sf12_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,12)=(nansum(sf12_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,12)=(nansum(sf12_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,12)=(nansum(sf12_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,12)=(nansum(sf12_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,12)=(nansum(sf12_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,12)=(nansum(sf12_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,12)=(nansum(sf12_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,12)=(nansum(sf12_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,12)=(nansum(sf12_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,12)=(nansum(sf12_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,12)=(nansum(sf12_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,13)=(nansum(sf13_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,13)=(nansum(sf13_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,13)=(nansum(sf13_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,13)=(nansum(sf13_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,13)=(nansum(sf13_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,13)=(nansum(sf13_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,13)=(nansum(sf13_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,13)=(nansum(sf13_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,13)=(nansum(sf13_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,13)=(nansum(sf13_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,13)=(nansum(sf13_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,13)=(nansum(sf13_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,13)=(nansum(sf13_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,14)=(nansum(sf14_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,14)=(nansum(sf14_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,14)=(nansum(sf14_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,14)=(nansum(sf14_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,14)=(nansum(sf14_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,14)=(nansum(sf14_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,14)=(nansum(sf14_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,14)=(nansum(sf14_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,14)=(nansum(sf14_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,14)=(nansum(sf14_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,14)=(nansum(sf14_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,14)=(nansum(sf14_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,14)=(nansum(sf14_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,15)=(nansum(sf15_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,15)=(nansum(sf15_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,15)=(nansum(sf15_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,15)=(nansum(sf15_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,15)=(nansum(sf15_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,15)=(nansum(sf15_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,15)=(nansum(sf15_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,15)=(nansum(sf15_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,15)=(nansum(sf15_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,15)=(nansum(sf15_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,15)=(nansum(sf15_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,15)=(nansum(sf15_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,15)=(nansum(sf15_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,16)=(nansum(sf16_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,16)=(nansum(sf16_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,16)=(nansum(sf16_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,16)=(nansum(sf16_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,16)=(nansum(sf16_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,16)=(nansum(sf16_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,16)=(nansum(sf16_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,16)=(nansum(sf16_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,16)=(nansum(sf16_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,16)=(nansum(sf16_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,16)=(nansum(sf16_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,16)=(nansum(sf16_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,16)=(nansum(sf16_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,17)=(nansum(sf17_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,17)=(nansum(sf17_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,17)=(nansum(sf17_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,17)=(nansum(sf17_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,17)=(nansum(sf17_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,17)=(nansum(sf17_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,17)=(nansum(sf17_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,17)=(nansum(sf17_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,17)=(nansum(sf17_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,17)=(nansum(sf17_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,17)=(nansum(sf17_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,17)=(nansum(sf17_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,17)=(nansum(sf17_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,18)=(nansum(sf18_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,18)=(nansum(sf18_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,18)=(nansum(sf18_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,18)=(nansum(sf18_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,18)=(nansum(sf18_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,18)=(nansum(sf18_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,18)=(nansum(sf18_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,18)=(nansum(sf18_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,18)=(nansum(sf18_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,18)=(nansum(sf18_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,18)=(nansum(sf18_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,18)=(nansum(sf18_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,18)=(nansum(sf18_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,19)=(nansum(sf19_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,19)=(nansum(sf19_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,19)=(nansum(sf19_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,19)=(nansum(sf19_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,19)=(nansum(sf19_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,19)=(nansum(sf19_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,19)=(nansum(sf19_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,19)=(nansum(sf19_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,19)=(nansum(sf19_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,19)=(nansum(sf19_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,19)=(nansum(sf19_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,19)=(nansum(sf19_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,19)=(nansum(sf19_filled_hh10(1:15168)));
WUE_Ec_2010_sf(1,20)=(nansum(sf20_filled_hh10(1:5040)));
WUE_Ec_2010_sf(2,20)=(nansum(sf20_filled_hh10(1:7392)));
WUE_Ec_2010_sf(3,20)=(nansum(sf20_filled_hh10(1:7776)));
WUE_Ec_2010_sf(4,20)=(nansum(sf20_filled_hh10(1:8832)));
WUE_Ec_2010_sf(5,20)=(nansum(sf20_filled_hh10(1:9648)));
WUE_Ec_2010_sf(6,20)=(nansum(sf20_filled_hh10(1:10416)));
WUE_Ec_2010_sf(7,20)=(nansum(sf20_filled_hh10(1:10800)));
WUE_Ec_2010_sf(8,20)=(nansum(sf20_filled_hh10(1:11808)));
WUE_Ec_2010_sf(9,20)=(nansum(sf20_filled_hh10(1:12384)));
WUE_Ec_2010_sf(10,20)=(nansum(sf20_filled_hh10(1:13152)));
WUE_Ec_2010_sf(11,20)=(nansum(sf20_filled_hh10(1:13824)));
WUE_Ec_2010_sf(12,20)=(nansum(sf20_filled_hh10(1:14160)));
WUE_Ec_2010_sf(13,20)=(nansum(sf20_filled_hh10(1:15168)));

DLMWRITE('C:/MacKay/multi/WUE_Ec_2010_F_filled.csv',WUE_Ec_2010_sf,',');
