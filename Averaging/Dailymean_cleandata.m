% This program calculates daily mean value of corrected flux data
% It also saves h-hourly values for year 2002-03

% Turkey Point, Altaf SArain, August 3, 2003

% --- get time ---
days = 1;

% --- get time series ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX99 = dt(1:17520);

% Read Meteorlogy data
% 1	      2	      3	  4	    5	   6	    7	   8	  9	       10	      11	   12         13	  14	  15	    16	         17	      18	  19	   20	   21	   22	   23	   24	   25	  26	   27     28       29     30      31     32      33      34       35     36		37		38	  39	40	  41	42	  43	44	  45	46		47																								
%year	month	day	 JD	  hour	 minute	  airTC	  RH	ws_ms	wind_dir   PAR up	PAR down	NR Wm2	Hflux1	Hflux2	  PARcanopy	  M2Ts1A	M2Ts50A M2Ts20A	M2Ts10A	M2Ts5A	M2Ts2A	M2Ts11B	M2Ts50B	M2Ts20B	M2Ts10B  M2Ts5B M2Ts2B	M2Sm50A	M2Sm20A	M2Sm20A	M2Sm5A	M2Sm50B	M2Sm20B	M2Sm20B	M2Sm5B	tree1 tree2 tree3 tree4 tree5 tree6 tree7 tree8 tree9 tree10 tree11
load Meteo2005_m2.txt;
m2met = Meteo2005_m2;
clear Meteo2005_m2


% Read daily avg obseved data
load nee2005m2W_ec_dn.dat
nep =  - nee2005m2W_ec_dn;

[nepgmsum,nepmean,TimeX99] = integzBC1(dt(~isnan(nep)),nep(~isnan(nep)),1:365,days); 
nepMean	=	nepmean'; 
save 'nep_DM.dat'      nepMean   -ASCII


load GEP2005m2W_ec.dat
gep = GEP2005m2W_ec; % umol m-2 d-1 
[gepgmsum,gepmean,TimeX99] = integzBC1(dt(~isnan(gep)),gep(~isnan(gep)),1:365,days); 
gepMean	=	gepmean'; 
save 'gep_DM.dat'      gepMean   -ASCII


load R2005m2W_ec.dat
r =  R2005m2W_ec;
[rgmsum,rmean,TimeX99] = integzBC1(dt(~isnan(r)),r(~isnan(r)),1:365,days); 
rMean	=	rmean'; 
save 'r_DM.dat'      rMean   -ASCII

%%*********************************
% --- get H flux (W m-2) ---
load SHF2005m2W_ec.dat
SHF2005 = SHF2005m2W_ec;
clear SHF2005m2W_ec 
[SHFsum2005,SHFmean2005,TimeX99] = integzBC1(dt(~isnan(SHF2005)),SHF2005(~isnan(SHF2005)),1:365,days); 
SHFMean2005	=	SHFmean2005'; 
save 'H_DM.dat'      SHFMean2005   -ASCII

%%*********************************
% --- get LE flux (W m-2) ---

load LE2005m2W_ec.dat
LE2005 = LE2005m2W_ec;
clear LE2005m2W_ec 
[LEsum2005,LEmean2005,TimeX99] = integzBC1(dt(~isnan(LE2005)),LE2005(~isnan(LE2005)),1:365,days); 
LEMean2005	=	LEmean2005'; 
save 'LE_DM.dat'      LEMean2005   -ASCII


load E2005m2W_ec_mmhhour.dat
LE05 = E2005m2W_ec_mmhhour;
clear E2005m2W_ec_mmhhour
[LEsum05,LEmean05,TimeX99] = integzBC1(dt(~isnan(LE05)),LE05(~isnan(LE05)),1:365,days); 
LEMean05	=	LEmean05'; 
save 'LE05_mm_DM.dat'      LEMean05   -ASCII



% --- get Rn flux (W m-2) ---

Rn = m2met(:,13);
Rn0203 = Rn;
clear Rn0203m2W_ec 
[Rnsum0203,Rnmean0203,TimeX99] = integzBC1(dt(~isnan(Rn0203)),Rn0203(~isnan(Rn0203)),1:365,days); 
RnMean0203	=	Rnmean0203'; 
save 'Rn_DM.dat'      RnMean0203   -ASCII



% --- get Ta flux (W m-2) ---

Ta = m2met(:,7); 
Ta0203 = Ta;
clear Ta0203m2W_ec 
[Tasum0203,Tamean0203,TimeX99] = integzBC1(dt(~isnan(Ta0203)),Ta0203(~isnan(Ta0203)),1:365,days); 
TaMean0203	=	Tamean0203'; 
save 'Ta_DM.dat'      TaMean0203   -ASCII


% --- get G flux (W m-2) ---

load G0.txt
G0203 = G0;
clear G0203m2W_ec 
[Gsum0203,Gmean0203,TimeX99] = integzBC1(dt(~isnan(G0203)),G0203(~isnan(G0203)),1:365,days); 
GMean0203	=	Gmean0203'; 
save 'G0_DM.dat'      GMean0203   -ASCII


% --- get G flux (W m-2) ---
load Jt.txt
Jt03 = Jt;
clear Jt 
[Jtsum0203,Jtmean0203,TimeX99] = integzBC1(dt(~isnan(Jt03)),Jt03(~isnan(Jt03)),1:365,days); 
JtMean0203	=	Jtmean0203'; 
save 'Jt_DM.dat'      JtMean0203   -ASCII


%%%%%%%%%%%%%%% Ts %%%%%%%%%%%%%%%%%%%%%%%%
% Soil temp of both N and S sensors 
TsA2  = m2met(:,22); ind = find(TsA2  < -8); TsA2(ind)  = NaN; TsA2  = interp_nan(dt,TsA2); 
TsA5  = m2met(:,21); ind = find(TsA5  < -8); TsA5(ind)  = NaN; TsA5  = interp_nan(dt,TsA5); 
TsA10 = m2met(:,20); ind = find(TsA10 < -8); TsA10(ind) = NaN; TsA10 = interp_nan(dt,TsA10); 
TsA20 = m2met(:,19); ind = find(TsA20 < -8); TsA20(ind) = NaN; TsA20 = interp_nan(dt,TsA20); 
TsA50 = m2met(:,18); ind = find(TsA50 < -8); TsA50(ind) = NaN; TsA50 = interp_nan(dt,TsA50); 
TsA100= m2met(:,17); ind = find(TsA100< -8); TsA100(ind)= NaN; TsA100= interp_nan(dt,TsA100); 

TsB2  = m2met(:,28); ind = find(TsB2  < -8); TsB2(ind)  = NaN; TsB2  = interp_nan(dt,TsB2); 
TsB5  = m2met(:,27); ind = find(TsB5  < -8); TsB5(ind)  = NaN; TsB5  = interp_nan(dt,TsB5); 
TsB10 = m2met(:,26); ind = find(TsB10 < -8); TsB10(ind) = NaN; TsB10 = interp_nan(dt,TsB10); 
TsB20 = m2met(:,25); ind = find(TsB20 < -8); TsB20(ind) = NaN; TsB20 = interp_nan(dt,TsB20); 
TsB50 = m2met(:,24); ind = find(TsB50 < -8); TsB50(ind) = NaN; TsB50 = interp_nan(dt,TsB50); 
TsB100= m2met(:,23); ind = find(TsB100< -8); TsB100(ind)= NaN; TsB100= interp_nan(dt,TsB100); 


Ts2 = (TsA2 + TsB2)/2; % AVREGARE soil temperature of 10cm layer in two pits
Ts5 = (TsA5 + TsB5)/2; % AVREGARE soil temperature of 10cm layer in two pits
Ts10 = (TsA10 + TsB10)/2; % AVREGARE soil temperature of 10cm layer in two pits
Ts20 = (TsA20 + TsB20)/2; % AVREGARE soil temperature of 10cm layer in two pits
Ts50 = (TsA50 + TsB50)/2; % AVREGARE soil temperature of 10cm layer in two pits


[Ts2sum,Ts2mean,TimeX99] = integzBC1(dt(~isnan(Ts2)),Ts2(~isnan(Ts2)),1:365,days); 
Ts2Mean	=	Ts2mean'; 
save 'Ts2_DM.dat'      Ts2Mean   -ASCII

[Ts5sum,Ts5mean,TimeX99] = integzBC1(dt(~isnan(Ts5)),Ts5(~isnan(Ts5)),1:365,days); 
Ts5Mean	=	Ts5mean'; 
save 'Ts5_DM.dat'      Ts5Mean   -ASCII

[Ts10sum,Ts10mean,TimeX99] = integzBC1(dt(~isnan(Ts10)),Ts10(~isnan(Ts10)),1:365,days); 
Ts10Mean	=	Ts10mean'; 
save 'Ts10_DM.dat'      Ts10Mean   -ASCII


[Ts20sum,Ts20mean,TimeX99] = integzBC1(dt(~isnan(Ts20)),Ts20(~isnan(Ts20)),1:365,days); 
Ts20Mean	=	Ts20mean'; 
save 'Ts20_DM.dat'      Ts20Mean   -ASCII


[Ts50sum,Ts50mean,TimeX99] = integzBC1(dt(~isnan(Ts50)),Ts50(~isnan(Ts50)),1:365,days); 
Ts50Mean	=	Ts50mean'; 
save 'Ts50_DM.dat'      Ts50Mean   -ASCII

% get soil moisture
Sm5a  = m2met(:,32); %ind = find(TsA5  < -8); TsA5(ind)  = NaN; TsA5  = interp_nan(dt,TsA5); 
Sm10a = m2met(:,31); %ind = find(TsA10 < -8); TsA10(ind) = NaN; TsA10 = interp_nan(dt,TsA10); 

Sm20a = m2met(:,30); %ind = find(TsA20 < -8); TsA20(ind) = NaN; TsA20 = interp_nan(dt,TsA20); 
Sm50a = m2met(:,29); %ind = find(TsA50 < -8); TsA50(ind) = NaN; TsA50 = interp_nan(dt,TsA50); 

Sm5b  = m2met(:,36); %ind = find(TsA5  < -8); TsA5(ind)  = NaN; TsA5  = interp_nan(dt,TsA5); 
Sm10b = m2met(:,35); %ind = find(TsA10 < -8); TsA10(ind) = NaN; TsA10 = interp_nan(dt,TsA10); 
Sm20b = m2met(:,34); %ind = find(TsA20 < -8); TsA20(ind) = NaN; TsA20 = interp_nan(dt,TsA20); 
Sm50b = m2met(:,33); %ind = find(TsA50 < -8); TsA50(ind) = NaN; TsA50 = interp_nan(dt,TsA50); 


Sm50 = (Sm50a + Sm50b)/2;
Sm20 = (Sm20a + Sm20b)/2;
Sm10 = (Sm10a + Sm10b)/2;
Sm5 = (Sm5a + Sm5b)/2;


[Sm5sum,Sm5mean,TimeX99] = integzBC1(dt(~isnan(Sm5)),Sm5(~isnan(Sm5)),1:365,days); 
Sm5Mean	=	Sm5mean'; 
save 'Sm5_DM.dat'      Sm5Mean   -ASCII

[Sm10sum,Sm10mean,TimeX99] = integzBC1(dt(~isnan(Sm10)),Sm10(~isnan(Sm10)),1:365,days); 
Sm10Mean	=	Sm10mean'; 
save 'Sm10_DM.dat'     Sm10Mean   -ASCII


[Sm20sum,Sm20mean,TimeX99] = integzBC1(dt(~isnan(Sm20)),Sm20(~isnan(Sm20)),1:365,days); 
Sm20Mean	=	Sm20mean'; 
save 'Sm20_DM.dat'      Sm20Mean   -ASCII


[Sm50sum,Sm50mean,TimeX99] = integzBC1(dt(~isnan(Sm50)),Sm50(~isnan(Sm50)),1:365,days); 
Sm50Mean	=	Sm50mean'; 
save 'Sm50_DM.dat'      Sm50Mean   -ASCII


