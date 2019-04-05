function [VPD] = VPD_calc(RH, Ta,unit_flag)
%%% Calculates VPD (in kPa or hPa) when RH(%) and Tair(in C) are inputted
% usage VPD = VPD_calc(RH, Ta);
% Created Feb 19, 2009 by JJB.
% Edited 20180314 by JJB to include unit_flag
% unit_flag = 1 is kPa; 2 is hPa

if nargin==2
    unit_flag = 1;
else 
    if isempty(unit_flag)==1
        unit_flag=1;
    end
end

% Calculate VPD in kPa
esat = 0.6108.*exp((17.27.*Ta)./(237.3+Ta));
e = (RH.*esat)./100;
VPD = esat-e;

%Convert to hPa if unit_flag = 2;
if unit_flag==2
    VPD = VPD.*10;
end