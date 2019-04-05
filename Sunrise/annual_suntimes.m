 function [sunup_down] = annual_suntimes(site, year, timezone,time_int)
% This function uses suntimes.m to create an annual 1/2 hourly dataset of
% sunrise and sunset times for the specified timezone.
% usage: [output] = annual_suntimes(site, year, timezone)
% Where site is a string denoting the site (e.g. 'TP39')
% year is a scalar number for the year of interest
% timezone is the timezone if interest --from UTC -- (e.g. EST = -5)
% Created 19 May 2009 by JJB
% 
% Revision History:

% For Testing Only %%%%%%%%%%%%
% clear all
% close all
% site = 'TP39';
% year = 2007;
% timezone = -5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <4
    time_int = 30;
end
%%% Get SunTimes 
[lat_long] = params(year, site, 'Sun'); 
[YYYY, JD, HHMM, dt] = jjb_makedate(year, time_int);
sunup_down = zeros(length(YYYY),1);

    if isleapyear(year) == 1
        num_days = 366;
    else
        num_days = 365;
    end

for day = 1:1:num_days
[srhr(day,1) srmin(day,1) sshr(day,1) ssmin(day,1) snhr(day,1) snmin(day,1)] = ...
    suntimes(lat_long(1,1), lat_long(1,2), day, timezone);
end

sr_time = srhr.*100 + srmin;
ss_time = sshr.*100 + ssmin;
sn_time = snhr.*100 + snmin;

ctr = 1;
for j = 1:1440/time_int:length(YYYY) % Cycles through all hhours in a day.
    ind_up = find(HHMM(j:j+(1440/time_int)-1,1) > sr_time(ctr,1)  & HHMM(j:j+(1440/time_int)-1,1) < ss_time(ctr,1));
    ind_noon = find(HHMM(j:j+(1440/time_int)-1,1) > sn_time(ctr,1),1,'first');
%     daylength(ctr,1) = length(ind_up);
    sunup_down(ind_up+j-1,1) = 1;
    sunup_down(ind_noon+j-1,1) = 10;
    
    ctr = ctr +1;
    clear ind_up;
end
%%%%%%%%%%%%% Original script that worked with 30-minute data only --
%%%%%%%%%%%%% revert if necessary:
% %%% Get SunTimes 
% [lat_long] = params(year, site, 'Sun'); 
% [YYYY, JD, HHMM, dt] = jjb_makedate(year, 30);
% sunup_down = zeros(length(YYYY),1);
% 
%     if isleapyear(year) == 1
%         num_days = 366;
%     else
%         num_days = 365;
%     end
% 
% for day = 1:1:num_days
% [srhr(day,1) srmin(day,1) sshr(day,1) ssmin(day,1) snhr(day,1) snmin(day,1)] = ...
%     suntimes(lat_long(1,1), lat_long(1,2), day, timezone);
% end
% 
% sr_time = srhr.*100 + srmin;
% ss_time = sshr.*100 + ssmin;
% sn_time = snhr.*100 + snmin;
% 
% ctr = 1;
% for j = 1:48:length(YYYY) % Cycles through all hhours in a day.
%     ind_up = find(HHMM(j:j+47,1) > sr_time(ctr,1)  & HHMM(j:j+47,1) < ss_time(ctr,1));
%     ind_noon = find(HHMM(j:j+47,1) > sn_time(ctr,1),1,'first');
% %     daylength(ctr,1) = length(ind_up);
%     sunup_down(ind_up+j-1,1) = 1;
%     sunup_down(ind_noon+j-1,1) = 10;
%     
%     ctr = ctr +1;
%     clear ind_up;
% end
    
% figure(1);clf;
% plot(sunup_down,'.');
% 
 