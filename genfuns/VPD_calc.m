function [VPD] = VPD_calc(RH, Ta)
%%% Calculates VPD (in kPa) when RH(%) and Tair(in C) are inputted
% usage VPD = VPD_calc(RH, Ta);
% Created Feb 19, 2009 by JJB.
%
%
%
%

esat = 0.6108.*exp((17.27.*Ta)./(237.3+Ta));
e = (RH.*esat)./100;
VPD = esat-e;