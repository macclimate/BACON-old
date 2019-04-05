function [VPD] = vpdcalc(Ta, RH)
% This function calculates VPD from inputs of air temperature (Ta) - in C--
% and Relative Humidity (RH).
%
% Created Dec 9, 2008 by JJB.

esat = 0.6108.*exp((17.27.*Ta)./(237.3+Ta));
e = (RH.*esat)./100;
VPD = esat-e;