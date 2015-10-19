function [ET_mm] = LE_to_ET(LE_filled,Ta)
%% LE_to_ET.m
%%% usage: [ET] = LE_to_ET(LE_filled,Ta)
%%% Convert LE in W/m^2 to mm/hhour 
%%% by using either (LE/lambda(T_air).*1800) or LE/343 (when Ta is NaN)    

LHV = (2501-2.38.*Ta).*1000; % Latent Heat of Vaporization

ET_mm = (LE_filled./LHV).*1800;
ET_mm(isnan(ET_mm),1) = LE_filled(isnan(ET_mm))./1372;
