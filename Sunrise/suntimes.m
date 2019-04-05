function [srhr srmin sshr ssmin snhr snmin] = suntimes(lat, long, doy, timezone)
%% suntimes.m
% This function outputs the sunrise, sunset and solar noon times for a
% given day with inputted latitude, longitude and timezone
%
% Usage: [srhr srmin sshr ssmin snhr snmin] = suntimes(lat, long, doy, timezone)
%
%%% Outputs:
% srhr - sunrise hour, srmin - sunrise minute
% sshr - sunset hour, ssmin - sunset minute
% snhr - solar noon hour, snmin - solar noon minute
%
%Inputs:
% lat, long - latitude & long in decimals of angle (use dms2dec(deg,min,sec)) to convert
% e.g. 
%  lat = dms2dec(42,39,39.27);
%  long = dms2dec(80,33,34.27);
% timezone: offset to UTC (e.g. timezone = -5; % For Eastern Standard Time)
% doy: day of year for calculation:
%
% Created Mar 13, 2009 by JJB

% Revision History:
%
%

%%% fractional year (gamma)
gamma = ((2.*pi()) ./ 365) .* (doy - 1 + (((-1.*timezone)-12)./24));

%%% equation of time (in minutes)
eqtime = 229.18.*(0.000075+ 0.001868.*cos(gamma) - 0.032077.*sin(gamma) - 0.014615.*cos(2.*gamma) - 0.040849.*sin(2.*gamma));

%%% Solar declination angle (in radians)
decl = 0.006918 - 0.399912.*cos(gamma) + 0.070257*sin(gamma) - 0.006758.*cos(2*gamma) + 0.000907*sin(2*gamma) ...
    -0.002697.*cos(3*gamma) + 0.00148*sin(3*gamma);

%%% hour angle for the day (in degrees)
ha_rise_set = acosd( ((cosd(90.833))./ (cosd(lat).*cos(decl)))  - tand(lat).*tan(decl)) ;

% sunrise/sunset (in minutes from 0000 UTC)
sunrise_minsUTC = 720 + 4.*(long-ha_rise_set) - eqtime;
sunset_minsUTC =  720 + 4.*(long-(-1.*ha_rise_set)) - eqtime;
snoon_minsUTC = 720 + 4.*(long) - eqtime;

% Convert to all to hr and min in UTC:
[srhr_UTC srmin junk] = min2hms(sunrise_minsUTC);
[sshr_UTC ssmin junk] = min2hms(sunset_minsUTC);
[snhr_UTC snmin junk] = min2hms(snoon_minsUTC);


% now, convert to local (standard) time:

srhr = srhr_UTC+timezone;
sshr = sshr_UTC+timezone;
snhr = snhr_UTC+timezone;