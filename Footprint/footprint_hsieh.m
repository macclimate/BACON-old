%footprint_hsieh.m: Estimates the footprint (or source weight function)
%                   along the upwind distance (x=0 is measuring point)               
%
%Authors:           Gaby Katul and Cheng-I Hsieh
%
%Reference:         Hsieh, C.I., G.G. Katul, and T.W. Chi, 2000,  
%                   "An approximate analytical model for footprint estimation of scalar fluxes 
%                   in thermally stratified atmospheric flows", 
%                   Advances in Water Resources, 23, 765-772.
%
%Usage: [Fc, Fp, L,xp,x]=footprint_hsieh(ustar,H,Ta,zm,zo)
%
%Fc = Cumulative source contribution with distance (fraction)
%fp = Source-weight function (with distance)
%L  = Obukhov length (m)
%xp = Peak distance from measuring point to the maximum contributing source area (m)
%x  = Distance vector used in the computation of Fc, fp (m)
%F2H=Fetch to Height ratio (for 90% of flux recovery, i.e. 100:1 or 20:1)
%
%ustar = friction velocity (m/s)
%H     = Sensible heat (W/m2)
%Ta    = Mean air temperature (oC)
%zm    = Instrument height (m)
%zo    = Momentum roughness height (m)
%---------------------------------------------------------------------------------------------------------
function [Fc, Fp, x,L,xp,F2H]=footprint_hsieh(ustar,H,Ta,zm,zo)
k=0.4;                              %Von karman constant
Cp=1005;                            %Specific heat capacity of dry air at constant pressure (J/kg K)
g=9.81;                             % Gravitational constant
Ta_K=Ta+273.15;                     % Convert oC to K
rho=1.3079-0.0045*Ta;               % Density of air (kg/m3)
L=-rho*(ustar+eps)^3/(k*g*((H+eps)/(Cp*Ta_K))); % Obukhov Length (m)

% Equations (15)-(17) from Hsieh et al. (2000)
zu=zm*(log(zm/zo)-1+zo/zm);       
P=[0.59 1 1.33];                  
D=[0.28 0.97 2.44];
Mu=[100 500 2000];
stab=zu/L;
thresh=0.04;

if stab<-thresh
    ii=1;
elseif abs(stab)<thresh
    ii=2;
elseif stab>thresh
    ii=3;
end
D1=D(ii);
P1=P(ii);
Mu1=Mu(ii);

min_x=(Mu1/100)*zo;
max_x=Mu1*zm;
x_bin=(max_x-min_x)/1000;
x=[min_x:x_bin:max_x];


c1=(-1/k/k)*(D1*zu^P1*abs(L)^(1-P1))./x;
Fc=exp(c1);
Fp=-(c1./x).*Fc;
xp=(1/2/k/k)*(D1*zu^P1*abs(L)^(1-P1));
F2H=(D1/0.105/k/k)*(zm^(-1)*abs(L)^(1-P1)*zu^(P1));