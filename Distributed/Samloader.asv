%% This script is to prepare data for calculating gap-filled NEP
%%% Requirements:  
clear all
close all

%% The goal is to load all variables and get each variable into one column
% vector, containing all years data:
start_year = 2003;
end_year = 2005;
n_yrs = end_year - start_year + 1;
%% Create open variables
% data = struct('dt',NaN.*ones(17568,n_yrs), 'year',NaN.*ones(17568,n_yrs), 'Ts2a',NaN.*ones(17568,n_yrs), 'Ts2b',NaN.*ones(17568,n_yrs), 'Ts5a',NaN.*ones(17568,n_yrs), ...
%  'Ts5b',NaN.*ones(17568,n_yrs), 'T_air',NaN.*ones(17568,n_yrs), 'PAR',NaN.*ones(17568,n_yrs),   'SM5a',NaN.*ones(17568,n_yrs), ...
%  'SM5b',NaN.*ones(17568,n_yrs), 'SM10a',NaN.*ones(17568,n_yrs), 'SM10b',NaN.*ones(17568,n_yrs), 'SM20a',NaN.*ones(17568,n_yrs), ...
%  'SM20b',NaN.*ones(17568,n_yrs),'ustar',NaN.*ones(17568,n_yrs), 'WS',NaN.*ones(17568,n_yrs), ...
%  'Wdir',NaN.*ones(17568,n_yrs), 'RH'   ,NaN.*ones(17568,n_yrs));

o_dt(1:17568,1:n_yrs) = NaN; o_NEE(1:17568,1:n_yrs) = NaN; o_Ts2a(1:17568,1:n_yrs) = NaN; o_Ts2b(1:17568,1:n_yrs) = NaN; o_Ts2c(1:17568,1:n_yrs) = NaN;
o_Ts5a(1:17568,1:n_yrs) = NaN; o_Ts5b(1:17568,1:n_yrs) = NaN; o_T_air(1:17568,1:n_yrs) = NaN; 
o_PAR(1:17568,1:n_yrs) = NaN; o_SM10(1:17568,1:n_yrs) = NaN; o_SM40(1:17568,1:n_yrs) = NaN; o_ustar(1:17568,1:n_yrs) = NaN; 
o_year(1:17568,1:n_yrs) = NaN; o_WS(1:17568,1:n_yrs) = NaN; o_Wdir(1:17568,1:n_yrs) = NaN; o_RH(1:17568,1:n_yrs) = NaN;
o_Ts2(1:17568,1:n_yrs) = NaN; o_Ts5(1:17568,1:n_yrs) = NaN; o_SM(1:17568,1:n_yrs) = NaN;
%% Load variables for years 2003-2005

%%% For loading CR data -- easiest thing to do is to load all 3 large
%%% datafiles at once:
CR_path = 'C:\HOME\MATLAB\Data\SAM_CR\';
CR_03 = dlmread([CR_path 'CR031.csv'],',');
CR_04 = dlmread([CR_path 'CR041.csv'],',');
CR_05 = dlmread([CR_path 'CR051.csv'],',');

%% fill dt and year columns
 ctr_j = 1;
 for j = start_year:1:end_year
  
[temp_yr junk1(:,1) junk1(:,2) temp_dt] = jjb_makedate(j,30);
o_year(1:length(temp_yr),ctr_j) = temp_yr;
o_dt(1:length(temp_dt),ctr_j) = temp_dt;

 clear junk1 temp_yr temp_dt
 ctr_j = ctr_j+1;
 end

%% Fill rest of the variables:
%%% Soil Temp:
%%%%%%%%% 2003  %%%%%%%%%%%%%%%%   %%%%%%%%%   2004   %%%%%%%%%%%%     %%%%%%%%% 2005 %%%%%%%%%%%%% 
o_Ts2a(1:17520,1) = CR_03(:,17);   o_Ts2a(1:17568,2) = CR_04(:,17);   o_Ts2a(1:17520,3) = CR_05(:,33); 
o_Ts2b(1:17520,1) = CR_03(:,18);   o_Ts2b(1:17568,2) = CR_04(:,18);   o_Ts2b(1:17520,3) = NaN;  
o_Ts2c(1:17520,1) = CR_03(:,19);   o_Ts2c(1:17568,2) = CR_04(:,19);   o_Ts2c(1:17520,3) = NaN;  

o_Ts5a(1:17520,1) = CR_03(:,20);   o_Ts5a(1:17568,2) = CR_04(:,20);   o_Ts5a(1:17520,3) = CR_05(:,34); 
o_Ts5b(1:17520,1) = CR_03(:,58);   o_Ts5b(1:17568,2) = CR_04(:,58);   o_Ts5b(1:17520,3) = NaN;  

%%% Soil Moisture:

o_SM10(1:17520,1) = CR_03(:,12);   o_SM10(1:17568,2) = CR_04(:,12);           o_SM10(1:17520,3) = CR_05(:,5); 
% o_SM40(1:17520,1) = CR_03(:,6);   o_SM40(1:17568,2) = CR_04(:,58);      o_SM40(1:17520,3) = CR_05(:,14); 

o_T_air(1:17520,1) = CR_03(:,43);    o_T_air(1:17568,2) = CR_04(:,43);     o_T_air(1:17520,3) = CR_05(:,19);
o_PAR(1:17520,1) = CR_03(:,55);       o_PAR(1:17568,2) = CR_04(:,55);        o_PAR(1:17520,3) = CR_05(:,31); 
o_NEE(1:17520,1) = -1.*CR_03(:,5);   o_NEE(1:17568,2) = -1.*CR_04(:,5);   o_NEE(1:17520,3) = -1.*CR_05(:,36); 
o_ustar(1:17520,1) = CR_03(:,33);   o_ustar(1:17568,2) = CR_04(:,33);    o_ustar(1:17520,3) = CR_05(:,9);
o_WS(1:17520,1) = CR_03(:,47);      o_WS(1:17568,2) = CR_04(:,47);           o_WS(1:17520,3) = CR_05(:,23); 
o_Wdir(1:17520,1) = CR_03(:,46);   o_Wdir(1:17568,2) = CR_04(:,46);      o_Wdir(1:17520,3) = CR_05(:,22); 
o_RH(1:17520,1) = CR_03(:,44);      o_RH(1:17568,2) = CR_04(:,44);          o_RH(1:17520,3) = CR_05(:,20); 


%% Average Soil Temperatures:
%%% 2cm
o_Ts2_03 = [o_Ts2a(:,1)'; o_Ts2b(:,1)'; o_Ts2c(:,1)'];
for k = 1:1:length(o_Ts2a(:,1))
    o_Ts2(k,1) = nanmean(o_Ts2_03(:,k));
end
o_Ts2_04 = [o_Ts2a(:,2)'; o_Ts2b(:,2)'; o_Ts2c(:,2)'];
for k = 1:1:length(o_Ts2a(:,2))
    o_Ts2(k,2) = nanmean(o_Ts2_04(:,k));
end
o_Ts2_05 = [o_Ts2a(:,3)'; o_Ts2b(:,3)'; o_Ts2c(:,3)'];
for k = 1:1:length(o_Ts2a(:,3))
    o_Ts2(k,3) = nanmean(o_Ts2_05(:,k));
end

%%% 5cm
o_Ts5 = (o_Ts5a+o_Ts5b)./2;
o_Ts5(isnan(o_Ts5)) = o_Ts5b(isnan(o_Ts5));
o_Ts5(isnan(o_Ts5)) = o_Ts5a(isnan(o_Ts5));

%% Average Soil Moistures:
o_SM = o_SM10;

%% Reshape all data into single columns
T_air1 = reshape(o_T_air,[],1);
PAR1 = reshape(o_PAR,[],1);
Ts1 = reshape(o_Ts2,[],1);
Ts51 = reshape(o_Ts5,[],1);
SM1 = reshape(o_SM,[],1);
NEE1 = reshape(o_NEE,[],1); NEE1(NEE1 > 100) = NaN;
ustar1 = reshape(o_ustar,[],1);
dt1 = reshape(o_dt,[],1);
year1 = reshape(o_year,[],1);
WS1 = reshape(o_WS,[],1);
Wdir1 = reshape(o_Wdir,[],1);
RH1 = reshape(o_RH,[],1);
% RHc1 = reshape(o_RHc,[],1);

clear o_*

%% Calculate NEE 
% NEE1 = Fc1 + CO2_storl;
% NEE1(isnan(NEE1)) = Fc1(isnan(NEE1));

%% Convert RH into VPD:
esat = 0.6108.*exp((17.27.*T_air1)./(237.3+T_air1));
e = (RH1.*esat)./100;
VPD1 = esat-e;

clear RH1 esat e;

%% Clean variables for obvious outliers:
SM1(SM1<0) = NaN;
Wdir1(Wdir1<0) = NaN;
VPD1(VPD1<-0.5) = NaN;
ustar1(ustar1<-0.1) = NaN;






%% Save variables

all_data = [T_air1 PAR1 Ts1 Ts51 SM1 NEE1 ustar1 dt1 year1 WS1 Wdir1 VPD1];
save([CR_path 'CR_Fluxdata.dat'],'all_data','-ASCII')


%%

