% function [] = mcm_Schuepp_footprint(data, year_start, year_end, Ustar_th, xf_use)

%% mcm_Schuepp_footprint.m 
%%% Footprint data filtering program:
%%% This program uses the Scheupp analytical footprint model to estimate
%%% the radial distance from which a specified percentage of the measured
%%% flux is coming from (e.g. ground distance (m) in which 70% of the
%%% measured flux comes from).  
% Inputs:
% data - input data structure
% year_start - start year for calculation
% year_end - end year for calculation
% Ustar_th - u* threshold
% xf_use - fraction of flux within footprint considered acceptable


%%%%%%%%%%%%%%%%%% Details of Obukhov Length Calculation %%%%%%%%%%%%%%%%%%
% Atmospheric Stability by The Obukhov Length. 
% AMS reference:
% http://amsglossary.allenpress.com/glossary/search?id=obukhov-length1
% The Obukhov length, L = -(Tv*ustar^3)/(K*g*Qv)
% where k is von K�rm�n's constant, u* is the friction velocity (a measure
% of turbulent surface stress), g is gravitational acceleration (m/s2), 
% Tv is virtual temperature in deg K 
% Qv is a kinematic virtual temperature flux at the surface in K.m/s.
% Qv = H/(roh*Cp) where H is sensible heat flux in W/m2 or J/s.m2
% Tv = (1 + 0.61 rv)*Ta in deg K
% rv = (0.622*e)/(P-e) is mixing ratio
%%% Following Garrett, 1992 (Page 38) 
% L = - (roh*Cp*Ta*ustar^3)/(K*g*H)
% where H is in J/s.m2 (W/m2)
% Ta is degree K
%%% At a given height z above a surface, 
% (z-d)/L = 0 for statically neutral stability, 
% (z-d)/L is positive for stable atmosphere in a typical range of 1 to 5 
% (z-d)/L is negative for unstable atmosphere in a typical range of -5 to 
% -1 stratification.
% (z-d)/L is typically -1 to -2 over tall forests 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if isfield(data,'site');
%  site = data.site;   
% else  
%     site = input('Please input site name (e.g. ''TP39''): ','s');
% end


%%% Test of wind roses -- remove
% ctr = 1;
% for yr_ctr = year_start:1:year_end
% figure(ctr);clf;
% % subplot(3,3,ctr);
% ind(ctr).out = find(data.Year == yr_ctr & ~isnan(data.W_Dir.*data.WS));
% % h1 = figure('Name', 'Wind Rose'); clf
% wind_rose(data.W_Dir(ind(ctr).out), data.WS(ind(ctr).out));
% title(num2str(yr_ctr));
%     
% ctr = ctr + 1;
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for yr_ctr = year_start:1:year_end
function [xcorrm, xcorrhs, xf_m, xf_h, L2, zL] = mcm_Schuepp_footprint(u, ustar, H, Ta, RH, APR, z, h, zanm, XCrit)
%%% Get height information from parameter file:
% [Heights] = params(yr_ctr, site, 'Heights');
%%%% Vegetation heights
% hcan = Heights(1,2);    % vegetation height (m)
d    = h*2/3;        % displacemeny height (m)
z0   = h*0.1;        % roughness heigh (m)
% zm = z - d;
%%% Measurement heights:
if nargin == 8
    disp('Assuming that anemometer (zanm) and EC equipment (z) at same height');
 zanm = z;    % anemometer and EC equipment at the same height (m)
 XCrit = (0.5:0.05:0.9)';
elseif nargin == 9
    if z_anm<1
        XCrit = z_anm;
        zanm = z; 
    else
        XCrit = [];
    end
else
end

% if zanm == z || isempty(zanm)
if isequal(zanm,z)==1 || isempty(zanm)
    u_extrap_flag = 0;
else
u_extrap_flag = 1;    
end

if isempty(XCrit)
 XCrit = (0.5:0.05:0.9)';    
end
% z    = Heights(1,1);    % flux instrument height at proposed 20m tower (m)
%%% Constants:
roh = 1.293;  % Kg/m3 at a temperature of 273 K and a pressure of 101.325 kPa.
k    = 0.41;      % von Karmn constant
Cp   = 1012;      % Cp in Jkg/degK
g    = 9.81;      % m/s2
%%% Get Sector Information:
% [fetch] = params(yr_ctr, site, 'Fetch');
%%% Get meteorological information:
% ta       = data.Ta(data.Year == yr_ctr);   % air temperature (oC)
% hs       = data.H(data.Year == yr_ctr);   % sensibel heat flux (W/m2)
% uavg     = data.WS(data.Year == yr_ctr);   % windspeed (m/s)
% windd    = data.W_Dir(data.Year == yr_ctr);   % Wind direction (deg)
% ustar = data.Ustar(data.Year == yr_ctr);   % friction velocity, u* (m/s)
% RH  = data.RH(data.Year == yr_ctr);   % relative humidity
% APR   = data.APR(data.Year == yr_ctr);   % atmospheric pressure (kPa)
% par = data.PAR(data.Year == yr_ctr);    % incoming solar radiation (umolm-2s-1)
%%% Calculate any information if necessary:
% [windd_math_rad] = CSWind2Polar(windd,'rad'); % Converts wind dir into mathematical notation + radians
% [windd_math_deg] = CSWind2Polar(windd,'deg'); % Converts wind dir into mathematical notation + degrees
% ustr     = ustr_obs;                        % Use observed ustar values if available
ustar_cal = (k.*u)./(log((zanm-d)./z0));     % Compute friction velocity, to fill missing
ustar(isnan(ustar)) = ustar_cal(isnan(ustar));  % Fill in gaps in measured with modeled
[e,ea] = vappress(Ta, RH);                  % Convert HMP RH to vap. pressures 
                                            % [e - vapour pressure (kPa); ea - saturation vapour pressure (kPa)]
rv     = (0.622.*e)./(APR-e);                 % water vapour mixing ratio
tv     = (1+0.61.*rv).*(Ta+273.15);         % converts Ta to virtual temperature (in deg K)
L  = -1.*(roh*Cp.*tv.*ustar.^3)./(k*g.*H);     % Obukhov Length (in meters) 
zL = (z-d)./L;                              % (z/L stability parameter)

% Velocity at proposed flux instrumentation height 
% u_extrap = abs(ustar/k)*log((z-d)/z0);
% Calculate average wind velocity used in the model
uavg_mod = ustar.*(log((z-d)./z0)-1+(z0./(z-d)))./(k.*(1-(z0./(z-d))));

if u_extrap_flag == 1
uavg = uavg_mod;
else
uavg = u;
uavg(isnan(uavg)) = uavg_mod((isnan(uavg)));   
end
 

% Correction factors
gama = 0.0646 + Ta.*(6.1).^5;
kt   = Ta + 237.3;
slop = ((2503*2.718).^((17.269.*Ta)./kt))./(kt).^2;
br   = gama./slop;
roh  = 1.292 - 0.00428.*Ta;
%%% A second calculation of the Obukhov length:
L2 = -(((ustar).^3).*roh.*Cp.*(Ta+273.15))./(k.*g.*H.*(1 + (0.07./br)));
fim  = abs((1-(16.*(z-d)./L2)).^-0.25);
fihs = abs((1-(16.*(z-d)./L2)).^-0.5);

% Calculate Xmax, distance where maximum flux originates
xmax    = (uavg./ustar).*((z-d)./(2.*k));
xcorrm  = fim .* xmax;
xcorrhs = fihs .* xmax;
%%% Convert values to real numbers:
% xcorrhs_real = real(xcorrhs);
% xcorrm_real = real(xcorrm);


% Calculate the upwind distance from which 40-90% of the measured flux
% comes from
xfrac = NaN.*ones(length(u),numel(XCrit));
xf_m = NaN.*ones(length(u),numel(XCrit));
xf_h = NaN.*ones(length(u),numel(XCrit));

ctr_xf = 1;
% This section was edited by JJB on 21-Apr-2013
for i_xf = 1:1:size(XCrit,1)  
    xf_pct = XCrit(i_xf,1);
% Distance at which the cumulative flux density is equal to a fraction (e.g. 80%) of total
xfrac(:,ctr_xf)   = (-1./log(xf_pct)).*(uavg./ustar).*((z-d)./k);
xf_m(:,ctr_xf)  = fim  .* xfrac(:,ctr_xf);   % flux footprint
xf_h(:,ctr_xf) = fihs .* xfrac(:,ctr_xf);   % flux footprint with heat correction
ctr_xf = ctr_xf+1;
end

% for xf_pct = min(XCrit):0.05:max(XCrit)
% % Distance at which the cumulative flux density is equal to a fraction (e.g. 80%) of total
% xfrac(:,ctr_xf)   = (-1/log(xf_pct)).*(uavg./ustar).*((z-d)/k);
% xf_m(:,ctr_xf)  = fim  .* xfrac(:,ctr_xf);   % flux footprint
% xf_h(:,ctr_xf) = fihs .* xfrac(:,ctr_xf);   % flux footprint with heat correction
% ctr_xf = ctr_xf+1;
% end

