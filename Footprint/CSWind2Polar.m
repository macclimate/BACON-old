function [wind_out] = CSWind2Polar(wind_in,angle_type)
%%% This function converts wind directions recorded by Campbell Sci Wind
%%% Sensors (compass direction, degrees) into polar directions
%%% (mathematical direction, radians)
%%% CSWind data starts with 0 at North, and rotates clockwise positively,
%%% while polar plotting starts with 0 at East, and rotates
%%% counter-clockwise positively.
%%% angle_type - set to 'deg' for output in degrees or 'rad' for radian
%%% output (default)
% Written May 6, 2010 by JJB:

if nargin ==1
    angle_type = 'rad';
end
% wind_in = [0:45:360]'
% This rotates everything by 90 degrees to make it start at 0 when due East
wind_in = wind_in - 90;
wind_in(wind_in < 0) = wind_in(wind_in < 0) + 360;
% Flips the direction so positive is counter-clockwise:
wind_in = 360-wind_in;
wind_in(wind_in == 360) = 0;

if strcmp(angle_type,'rad')==1;
% Convert to radians:
wind_out = wind_in.*pi()./180;
else
    wind_out = wind_in;
end