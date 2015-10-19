function [q] = RH_to_SpecHum(Ta, RH, APR)
%%% This function converts RH to Specific humidity, (in kg/kg).
%%% Written Jan-15-2010 by JJB
%%% usage:  [q] = RH_to_SpecHum(Ta, RH, APR)


%% Calculate VP using RH:

esat = 0.6108.*exp((17.27.*Ta)./(237.3+Ta));
e = (RH.*esat)./100;

%% Calculate specific humidity from RH and P

rho_a = (APR*1000)./(287.0028.*(Ta+273));
rho_v = (e*1000)./(461.5.*(Ta+273))*1000;
q = rho_v./rho_a; % in g/kg
q = q/1000; % puts it into kg/kg