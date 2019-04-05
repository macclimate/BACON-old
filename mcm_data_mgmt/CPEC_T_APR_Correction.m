function [flux_out corr_factor] = CPEC_T_APR_Correction(flux_in, CPEC_Ta, CPEC_APR, actual_Ta, actual_APR, T_flag)
%% CPEC_T_APR_Correction.m
%%% This script performs a correction of fluxes (Fc, Hs, LE) for
%%% incorrect/missing values of Ta and APR used by the CPEC in deriving
%%% flux values.  Actual values are typically taken from the accompanying
%%% met station.
%%% Usage: CPEC_T_APR_Correction(flux_in, CPEC_Ta, CPEC_APR, actual_Ta, actual_APR)
%%% NOTE: If proper Ta and APR data are used in online fashion right on the
%%% CPEC (i.e. no need for correction), running this correction will not
%%% cause any change to the data.
%%% Created 05-Feb-2010 by JJB

%%% Revision History:

% Check to see if temperature is in C or K
if nargin == 4
    T_flag = [];
end

if T_flag == 1
    resp = 1;
elseif T_flag ==2
    resp = 2;
else
    commandwindow;
    resp = input('enter <1> if Ta is in C, <2> if in K: ');
end

if resp == 1
    add_to_temp = 273;
elseif resp == 2
    add_to_temp = 0;
end

% corr_factor = (actual_APR./CPEC_APR) .* (CPEC_Ta./actual_Ta);
corr_factor = (actual_APR./CPEC_APR) .* ((CPEC_Ta + add_to_temp)./(actual_Ta + add_to_temp));
corr_factor(isnan(corr_factor),1) = 1;

flux_out = corr_factor.*flux_in;



%% Information from Zoran -- where to find data:
% BarometricP = Stats(i).MiscVariables.BarometricP
% Tair = Stats(i).MiscVariables.Tair
% Pb = correct pressure measured by the MET station
% Ta = correct temperature measured by the MET station
%
% C = (Pb / BarometricP) * (Tair / Ta);
%
