%% OPEC_CPEC_compare1
%%% A simple script to compare Closed and Open-Path eddy covariance systems
%%% at Met 2.

%% Load Data -- Entire 2008 file for OPEC and stub from CPEC for Fc, Wdir
%  and WS
  OP_data = load('C:\HOME\MATLAB\Data\Flux\OPEC\Cleaned3\Met2\Master\Met2_30min_Master_2008.dat'); % col 62 is Fc
  CP_FC = load('C:\HOME\MATLAB\Data\Flux_comp\CP_FC.dat');  CP_FC1 = reshape(CP_FC,[],1);%jan 10, 11, 13, 14, 16
  CP_WD = load('C:\HOME\MATLAB\Data\Flux_comp\CP_WD.dat');  CP_WD1 = reshape(CP_WD,[],1);%jan 10, 11, 13, 14, 16
  CP_WS = load('C:\HOME\MATLAB\Data\Flux_comp\CP_WS.dat');  CP_WS1 = reshape(CP_WS,[],1);%jan 10, 11, 13, 14, 16
    CP_LE = load('C:\HOME\MATLAB\Data\Flux_comp\CP_LE.dat');  CP_LE1 = reshape(CP_LE,[],1);%jan 10, 11, 13, 14, 16
      CP_HS = load('C:\HOME\MATLAB\Data\Flux_comp\CP_HS.dat');  CP_HS1 = reshape(CP_HS,[],1);%jan 10, 11, 13, 14, 16
  
      CP_data = [CP_FC1 CP_WD1 CP_WS1 CP_LE1 CP_HS1];
  %% Include time vector
  [junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(str2double('2008'),30);
  
%   CP_FC1 = reshape(CP_FC,[],1);
%   
% %% Select necessary columns from OPEC file 
% %%%(as listed in C:\HOME\MATLAB\Data\Flux\OPEC\Organized2\Docs\OPEC_header.csv)
  OP_J16(:,1) = OP_data(:,6);  % Fc
  OP_J16(:,2) = OP_data(:,44);  %Wdir
  OP_J16(:,3) = OP_data(:,46);  %WS
  OP_J16(:,4) = OP_data(:,7);  % LE
  OP_J16(:,5) = OP_data(:,8);  % Hs
  
%% Load HMP data
T_HMP = load('C:\HOME\MATLAB\Data\Met\Cleaned3\Met2\Met2_2008.007');
  
% %% Shift data from CPEC file, since data covers only Jan 10,11,13,14 & 16
%   % Fc
%   CP_J16(1:768,1) = NaN; CP_J16(433:480,1) = CP_data(:,1); 
%   CP_J16(481:528,1) = CP_data(:,2); CP_J16(577:624,1) = CP_data(:,3);
%   CP_J16(625:672,1) = CP_data(:,4); CP_J16(721:768,1) = CP_data(:,5); 
%   %Wdir
%   CP_J16(1:768,2) = NaN; CP_J16(433:480,2) = CP_WDir(:,1); 
%   CP_J16(481:528,2) = CP_WDir(:,2); CP_J16(577:624,2) = CP_WDir(:,3);
%   CP_J16(625:672,2) = CP_WDir(:,4); CP_J16(721:768,2) = CP_WDir(:,5); 
%   %WS
%   CP_J16(1:768,3) = NaN; CP_J16(433:480,3) = CP_WS(:,1); 
%   CP_J16(481:528,3) = CP_WS(:,2); CP_J16(577:624,3) = CP_WS(:,3);
%   CP_J16(625:672,3) = CP_WS(:,4); CP_J16(721:768,3) = CP_WS(:,5);
%     %LE
%   CP_J16(1:768,4) = NaN; CP_J16(433:480,4) = CP_LE(:,1); 
%   CP_J16(481:528,4) = CP_LE(:,2); CP_J16(577:624,2) = CP_LE(:,3);
%   CP_J16(625:672,4) = CP_LE(:,4); CP_J16(721:768,2) = CP_LE(:,5); 
%   %Hs
%   CP_J16(1:768,5) = NaN; CP_J16(433:480,5) = CP_Hs(:,1); 
%   CP_J16(481:528,5) = CP_Hs(:,2); CP_J16(577:624,5) = CP_Hs(:,3);
%   CP_J16(625:672,5) = CP_Hs(:,4); CP_J16(721:768,5) = CP_Hs(:,5);
  
  
  
  
  
%% Shift data the necessary amounts (OPEC data uses different time than CPEC system
  CP_data_s(1:17557,:) = CP_data(12:17568,:);
CP_data_s(17558:17568,:) = NaN;
clear CP_data; CP_data = CP_data_s; clear CP_data_s;
% CP_J16(1:757,1:5) = CP_J16(12:768,1:5);
%   CP_J16(758:768,1:5) = NaN;
  
  
  
%% Plot variables
% Wind Speed (for matching times)
  figure(3)
  clf
  plot(dt,CP_data(:,3),'b.-')
  hold on
  plot(dt, OP_J16(:,3),'r.-')
  axis([1 367 0 6])
  
  % Wind Direction (for matching times)

  figure(2)
   clf
  plot(dt,CP_data(:,2),'b.-')
  hold on
  plot(dt, OP_J16(:,2),'r.-')
  axis([1 367 0 360])
  

  % Measured Fc 
  figure(1)
   clf
  plot(dt,CP_data(:,1),'b.-')
  hold on
  plot(dt, OP_J16(:,1),'r.-')
  axis([1 367 -30 30])
 
%   % Measured LE 
%   figure(4)
%   clf
%   plot(dt_J16, OP_J16(:,4),'b.-')
%   hold on
%   plot(dt_J16,CP_J16(:,4),'r.-')
%  axis([8 16 -100 100])
%  
%   % Measured Hs
%   figure(5)
%   clf
%   plot(dt_J16, OP_J16(:,5),'b.-')
%   hold on
%   plot(dt_J16,CP_J16(:,5),'r.-')
%  axis([8 16 -200 200])
%  
%  
%  
%   