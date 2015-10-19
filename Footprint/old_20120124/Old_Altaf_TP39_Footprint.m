% Footprint Analysis (Schuepp etal., 1990)
% Sitename: Turkey Point 70-year-old White Pine (TP39, planted in 1939), Southern Ontario, Canada. 			
% Location: 42.7122 N, 80.3572 W, levation (masl): 184m			
% Ecosystem type: Conifer (white pine)			
% Leaf Area Index = 8.0
% Tree height = 21.8 m
% Stem density = 425 stems/ha
% DBH = 35.5 cm
% Altaf Arain
% 30 April, 2010		

close all; clear all;

% Site parameters
hcan = 21.8;      % vegetation height (m)
zanm = 28;        % anemometer height (m)
%z   = 16.2       % flux instrument height at existing tower (m)
z    = 28;        % flux instrument height at proposed 20m tower (m)

d    = hcan*2/3;  % displacemeny height (m)
z0   = hcan*0.1;  % roughness heigh (m)
k    = 0.41;      % von Karmn constant
cp   = 1012;      % Cp in Jkg/degK
g    = 9.81;      % m/s2
xf   = 0.7;       % fraction of flux (80%) 

ustrTH = 0.35     % Usatr threshhold

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load data 
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\decdoy_00.txt

dt03 = decdoy_00(1:17520);
dt04 = decdoy_00(1:17568)+365;
dt05 = decdoy_00(1:17520)+365+366;
dt06 = decdoy_00(1:17520)+365+366+365;
dt07 = decdoy_00(1:17520)+365+366+365+365;
dt08 = decdoy_00(1:17568)+365+366+365+365+366;
dt09 = decdoy_00(1:17520)+365+366+365+365+366+365;

t = [dt03; dt04; dt05; dt06; dt07; dt08; dt09]; % time vector

% Meteorology data
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2003.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2004.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2005.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2006.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2007.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2008.dat
load C:\Data\turkey\TP_2003_09_Drought_Final\hhour\TP39_2009.dat

TP39met = [TP39_2003; TP39_2004; TP39_2005; TP39_2006; TP39_2007; TP39_2008; TP39_2009];

% ta     = 20.0;            % fixed air temperature (oC)
ta       = TP39met(:,44);   % air temperature (oC)
hs       = TP39met(:,12);   % sensibel heat flux (W/m2)
uanm     = TP39met(:,47);   % windspeed (m/s)
windd    = TP39met(:,19);   % Wind direction (deg)
ustr_obs = TP39met(:,15);   % friction velocity, u* (m/s)

ustr     = ustr_obs; 
ustr_cal = (k*uanm)/(log((zanm-d)/z0));   % Compute friction velocity, if missing
ustr     = ustr_obs;

% plot data for checking
figure(1); plot(ta,'-');
figure(2); plot(uanm,'-');
figure(3); plot(hs,'-');
figure(4); plot(ustr_obs,'b-'); hold on;  plot(ustr_cal,'r-'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Atmospheric Stability by The Obukhov Length. 
% AMS reference: http://amsglossary.allenpress.com/glossary/search?id=obukhov-length1

% The Obukhov length, L = -(Tv*ustar^3)/(K*g*Qv)
% where k is von Kármán's constant, u* is the friction velocity (a measure
% of turbulent surface stress), g is gravitational acceleration (m/s2), 
% Tv is virtual temperature in deg K 
% Qv is a kinematic virtual temperature flux at the surface in K.m/s.
% Qv = H/(roh*Cp) where H is sensible heat flux in W/m2 or J/s.m2
% Tv = (1 + 0.61 rv)*Ta in deg K
% rv = (0.622*e)/(P-e) is mixing ratio

% Following Garrett, 1992 (Page 38) 
% L = - (roh*Cp*Ta*ustar^3)/(K*g*H)
% where H is in J/s.m2 (W/m2)
% Ta is degree K

% At a given height z above a surface, 
% (z-d)/L = 0 for statically neutral stability, 
% (z-d)/L is positive for stable atmosphere in a typical range of 1 to 5 
% (z-d)/L is negative for unstable atmosphere in a typical range of -5 to -1 stratification.
% (z-d)/L i stypically -1 to -2 over tall forests 

roh = 1.293;  % Kg/m3 at a temperature of 273 K and a pressure of 101.325 kPa.
Cp  = 1012;   % J/(Kg.K)
k   = 0.40;   % constant
g   = 9.81;   % m/s2

rh  = TP39met(:,45);   % relative humidity
p   = TP39met(:,20);   % atmospheric pressure (kPa)

% vappress.m Program to convert RH to vapour pressure (kPa)
% e - vapour pressure from HMP (kPa)
% ea - saturation vapour pressure using HMP thermistor (kPa)
[e,ea] = vappress(ta, rh); 
rv     = (0.622.*e)./(p-e);         % mixing ratio
tv     = (1+0.61.*rv).*(ta+273.15); % deg K

L  = -(roh*Cp.*tv.*ustr.^3)./(k*g.*hs); % in meters 
zL = (z-d)./L; 


% Plot Z/L
figure(5); hold on
plot(zL,'bo')
plot(ustr,'rx')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[-20 20],'FontSize',12);
xlabel('Hour)','FontSize',12)
ylabel('Obukhov length Stability, z/L','FontSize',12)
%aa = legend('Heat-corrected','un-corrected',1);
%set(aa,'Vis','on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Velocity at proposed flux instrumentation height
u = abs(ustr/k)*log((z-d)/z0);

% Calculate average wind velocity used in the model
uavg = ustr*(log((z-d)/z0)-1+(z0/(z-d)))/(k*(1-(z0/(z-d))));

% Correction factors
gama = 0.0646 + ta*(6.1)^5;
kt   = ta + 237.3;
slop = ((2503*2.718).^((17.269.*ta)./kt))./(kt).^2;
br   = gama./slop;
roh  = 1.292 - 0.00428.*ta;

monl = -(((ustr).^3).*roh.*cp.*(ta+273.16))./(k.*g.*hs.*(1 + (0.07./br)));
fim  = (1-(16*(z-d)./monl)).^-0.25;
fihs = (1-(16*(z-d)./monl)).^-0.5;

% Calculate Xmax, distance where maximum flux originates
xmax    = (uavg./ustr)*((z-d)/(2*k));
xcorrm  = fim .* xmax;
xcorrhs = fihs .* xmax;

% Distance at which the cumulative flux density is equal to a fraction (80%) of total
xfrac   = (-1/log(xf)).*(uavg./ustr).*((z-d)/k);
xfracm  = fim  .* xfrac;   % flux footprint
xfrachs = fihs .* xfrac;   % flux footprint with heat correction

%fp = [t uanm windd ustr u uavg xmax xcorrm xcorrhs xfrac xfracm xfrachs];
fp = [t uanm windd ustr zL real(xcorrhs) real(xfrachs)];
fp = fp';

%save 'TP39_Footprint.dat' fp -ascii
save 'TP39_Footprint_Xfrac70.dat' fp -ascii

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot flux footprint
figure(10)
%plot(t,xcorrm,'ro', t,xcorrhs,'b^')
plot(real(xcorrhs),'b^')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 1000],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance where maximum flux originated (m)','FontSize',12)
aa = legend('Heat-corrected','un-corrected',1);
set(aa,'Vis','on');

%print -dmeta  TP39_Xmax; 

% Plot flux footprint
figure(11)
%plot(t,xfracm,'r^',t,xfrachs,'bo')
plot(real(xfrachs),'ro')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 2000],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance from which 80% flux originates (m)','FontSize',12)
aa = legend('Heat-corrected','un-corrected',1);
set(aa,'Vis','on');

%print -dmeta  TP39_Xfrac80; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ustar applied to eliminate bas fluxes
ind = find(ustr > ustrTH);

xcorrhsX = NaN*(1:(length(t)));
xcorrhsX(ind) = xcorrhs(ind);

xfrachsX = NaN*(1:(length(t)));
xfrachsX(ind) = xfrachs(ind);

% Plot flux footprint
figure(12)
%plot(t,xcorrm,'ro', t,xcorrhs,'b^')
plot(real(xcorrhsX),'b^')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 1000],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance where maximum flux originated (m)','FontSize',12)
aa = legend('Heat-corrected','un-corrected',1);
set(aa,'Vis','on');

%print -dmeta  TP39_Xmax_ustar; 

% Plot flux footprint
figure(13)
%plot(t,xfracm,'r^',t,xfrachs,'bo')
plot(real(xfrachsX),'ro')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 2000],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance from which 80% flux originates (m)','FontSize',12)
aa = legend('Heat-corrected','un-corrected',1);
set(aa,'Vis','on');

%print -dmeta  TP39_Xfrac80_ustar; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot footprint for unstable and neutral conditions only

ind = find(zL <= 0);
xcorrhsXX = NaN*(1:(length(t)));
xcorrhsXX(ind) = xcorrhs(ind);
xcorrhsXX = xcorrhsXX';

xfrachsXX = NaN*(1:(length(t)));
xfrachsXX(ind) = xfrachs(ind);
xfrachsXX = xfrachsXX';

% Plot flux footprint
figure(14)
%plot(t,xcorrm,'ro', t,xcorrhs,'b^')
plot(real(xcorrhsXX),'b^')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 140],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance where maximum flux originated (m)','FontSize',12)
aa = legend('Unstable',1);
set(aa,'Vis','on');

%print -dmeta  TP02_Xmax_zL; 

% Plot flux footprint
figure(15)
%plot(t,xfracm,'r^',t,xfrachs,'bo')
plot(real(xfrachsXX),'ro')
%set(gca,'box','on','xlim',[0 365],'FontSize',12);
set(gca,'box','on','ylim',[0 700],'FontSize',12);
xlabel('Day of Year)','FontSize',12)
ylabel('Distance from which 80% flux originates (m)','FontSize',12)
aa = legend('Unstable',1);
set(aa,'Vis','on');

%print -dmeta  TP02_Xfrac80_zL; 