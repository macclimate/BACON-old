function s_times_UTC = make_suntimes_year(year, site)
%% Uses suntimes.m to create a yearly hhourly vector with 0 for no expected
%%% PAR and 1000 for expected PAR (between sunrise and sunset):
% usage: suntimes_UTC = make_suntimes_year(year, site), where inputs are:
% year - must be in number format -- but if it's in string we can convert
% it inside of the function
% site - label (string) for site of interest (e.g. 'TP39')

% created April 4, 2009 by JJB
% Revision History:
%
%
% 
%%%%%%%%%%%% For testing:
% clear all
% 
% year = 2007;
% site = 'TP39';
%%%%%%%%%%%%%%%%%%%%%%%%%

if isstr(year) == 1;
    year = str2num(year);
end

[yr, JD, HHMM, dt] = jjb_makedate(year, 30);
[latlong] = params(year, site, 'Sun');
lat = latlong(1);
long = latlong(2);

%%% We're going to do this in EST to start, because doing it in UTC causes
%%% problems because sunset is often after 2400 UTC
for j = 1:1:366
[srhr(j,1) srmin(j,1) sshr(j,1) ssmin(j,1) snhr(j,1) snmin(j,1)] = suntimes(lat, long, j, -5);
end



sr = srhr*100 + srmin;
ss = sshr*100 + ssmin;

s_times = zeros(length(HHMM),1);

ctr = 1;
for j = 1:48:length(HHMM)-47
    sect(:,1) = (j:j+47);
    sunup = find(HHMM(sect,1) > sr(ctr) & HHMM(sect,1) < ss(ctr));
    sunup = [sunup; sunup(end)+1];
    s_times(sect(sunup),1) = 1000;
clear sect
clear sunup
ctr = ctr+1;
end

%%% Now, convert stuff back to UTC:
%%% This means we have to cut the final 5 hours (10 datapoints) and put it
%%% onto the front of it

s_times_UTC = [s_times(length(s_times)-9:end,1); s_times(1:length(s_times)-10,1) ];

