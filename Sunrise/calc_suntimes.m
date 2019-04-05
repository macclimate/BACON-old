% calc_suntimes.m 
% calculations for sunrise/sunset/solar noon for TP39 in EST:
clear all
% doy = (1:1:365)';
lat = dms2dec(42,39,39.27);
long = dms2dec(80,33,34.27);
timezone = -5;
for doy = 1:1:365
[srhr(doy,1) srmin(doy,1) sshr(doy,1) ssmin(doy,1) snhr(doy,1) snmin(doy,1)] = suntimes(lat, long, doy, timezone);
end




