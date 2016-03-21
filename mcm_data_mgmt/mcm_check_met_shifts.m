function [] = mcm_check_met_shifts(PAR,year, site)
%%% This function is designed to help the user ensure that met data is
%%% properly aligned to the UTC timecode.
%%% usage: mcm_check_met_shifts(PAR, year, site), where PAR is an annual timeseries
%%% of PAR down.
%%% Created June, 2010 by JJB

%%% Revision History:
% July 23, 2010 by JJB
% - Modified to use a moving window over the data -- with the hope of
% finding changes that may occur throughout the year.
ls = addpath_loadstart;
try
    tmp = load([ls 'Matlab/Data/Met/Final_Cleaned/PAR_limits_for_shifts.dat']);
PAR_crit(1:length(PAR),1) = tmp(1:length(PAR),1); 
catch
    PAR_crit(1:length(PAR),1) = 0;
end

%%% Move the critical values for PAR down for TP02 for selected years
if strcmp(site, 'TP02') == 1 && year == 2002
PAR_crit = PAR_crit*0.9;
end

% suntimes in UTC:
[sunup_down] = annual_suntimes(site, year, 0);
figure('Name','PAR, Est Suntimes');clf;
h1(1)=plot(PAR);
hold on;
h1(2)=plot(sunup_down.*225,'g')
nans = find(isnan(PAR));
%%% Draw indicators where data is missing
for i = 1:1:length(nans)
    h1(3) = plot([nans(i) nans(i)],[0 2500],'r-');
    %  plot(pred_snoon(i)+b(i),
end
legend(h1,{'PAR - in', 'Estimated suntimes (UTC)','Missing Data'});

%%% Go through the data day by day to try and find the suntimes.
%%% Find the suntimes estimated by the model:
ctr = 1;
for day_ctr = 1:48:length(PAR)
    % extract suntimes suggested by measured PAR data:
    try srise(ctr,1) = find(PAR(day_ctr:day_ctr+24,1)>15,1,'first'); catch; srise(ctr,1) = NaN;end
    try sset(ctr,1) = find(PAR(day_ctr+25:day_ctr+47,1)<15,1,'first')+25;catch; sset(ctr,1) = NaN;end
    try snoon(ctr,1) = find(PAR(day_ctr+0:day_ctr+47,1)==max(PAR(day_ctr+0:day_ctr+47,1)),1,'first')+0;catch; snoon(ctr,1) = NaN;end
    % if the value of PAR at noon is less than a specified threshold, then
    % we ignore it, as it will for sure not be a sunny day, and will only
    % lead to more problems.
%     test_PAR(ctr,1) = PAR(snoon(ctr,1),1);
%     max_PAR(ctr,1) = max(PAR(day_ctr+0:day_ctr+47,1));
    if ~isnan(snoon(ctr)) && PAR(snoon(ctr)+day_ctr,1) < PAR_crit(day_ctr,1); snoon(ctr,1) = NaN; else end
    % model-predicted suntimes:
    pred_srise(ctr,1) = find(sunup_down(day_ctr:day_ctr+32,1)==1,1,'first');
    pred_sset(ctr,1) = find(sunup_down(day_ctr+40:day_ctr+(min(52,length(PAR)-day_ctr)),1)==1,1,'first')+40;
    pred_snoon(ctr,1) = find(sunup_down(day_ctr+0:day_ctr+47,1)==10,1,'first')+0;
    ctr = ctr + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%% FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot time series of daily suntimes (model & observed)
figure('Name', 'HHour of suntimes (obs vs. pred)');clf;
plot(pred_snoon,'b'); hold on;
plot(snoon,'r','LineWidth',2)
plot(srise,'m');
plot(pred_srise,'c')
legend('obs noon','pred noon','obs srise','pred srise');
%%%%%%%%%%%%%%%%%%%%%%%% FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot the apparent difference between model & observed:
figure('Name','Estimated Time Difference');clf;
plot(pred_srise-srise,'b');hold on;
plot(pred_sset-sset,'r');
plot(pred_snoon-snoon,'k');
legend('Est by srise','Est by sset','Est by snoon');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% an index marking the start of the day (to be used for plotting)
b = (0:48:length(PAR)-1)';
%%%%%%%%%%%%%%%%%%%%%%%% FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the Observed solar noons (before fixing)
figure('Name', 'SNoon Vis. Inspection','Tag','Inspection');clf;
figure(findobj('Tag','Inspection'));clf
subplot(211)
plot(PAR,'Color',[0.9 0.9 0.9]); hold on;
ind = find(~isnan(snoon));
h1(1) = plot(b(ind)+snoon(ind),PAR(b(ind)+snoon(ind)),'bo');
%%% Draw the modeled (expected) solar noon times with vertical green lines:
for i = 1:1:length(pred_snoon)
    h1(2) = plot([pred_snoon(i)+b(i) pred_snoon(i)+b(i)],[0 2500],'g--');
    %  plot(pred_snoon(i)+b(i),
    h1(3) = plot([pred_srise(i)+b(i) pred_srise(i)+b(i)],[0 150],'k--');
    plot([pred_sset(i)+b(i) pred_sset(i)+b(i)],[0 150],'k--');
    
end
nans = find(isnan(PAR));
%%% Draw indicators where data is missing
for i = 1:1:length(nans)
    h1(4) = plot([nans(i) nans(i)],[0 2500],'r-');
    %  plot(pred_snoon(i)+b(i),
end

legend(h1,{'Obs Solar Noon';'Pred Solar Noon';'Pred SRrise, SSet';'Missing Data'});
title('uncorrected');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% mode_noon is the mode differences between predicted and
mode_noon = mode(pred_snoon-snoon);
disp(['Comparison of solar noons suggest a shift of ' num2str(mode_noon) ' data points.']);
figure('Name', 'Historgram of estimated shifts:');clf;
n = hist(pred_snoon-snoon,[-20:1:20]);
bar([-20:1:20],n);
axis tight
clear n;

mode_srise = mode(pred_srise-srise);
disp(['Comparison of sunrises suggest a shift of ' num2str(mode_srise) ' data points.']);
%%% Shift the data by what is predicted by mode_noon:
if mode_noon >= 0
    PAR_shift = [NaN.*ones(mode_noon,1) ; PAR(1:end-mode_noon)];
elseif mode_noon < 0
    PAR_shift = [PAR(1+abs(mode_noon):end); NaN.*ones(abs(mode_noon),1)];
end

%%% Plot the corrected (shifted) observed data for inspection:
figure(findobj('Tag','Inspection'));
subplot(212)
plot(PAR_shift,'Color',[0.9 0.9 0.9]); hold on;
h1(1) = plot(b(ind)+snoon(ind)+mode_noon,PAR_shift(b(ind)+snoon(ind)+mode_noon),'ro');

for i = 1:1:length(pred_snoon)
    h1(2) = plot([pred_snoon(i)+b(i) pred_snoon(i)+b(i)],[0 2500],'g--');
     h1(3) = plot([pred_srise(i)+b(i) pred_srise(i)+b(i)],[0 150],'k--');
    plot([pred_sset(i)+b(i) pred_sset(i)+b(i)],[0 150],'k--');
    
end
%%% Draw indicators where data is missing
for i = 1:1:length(nans)
    h1(4) = plot([nans(i) nans(i)],[0 2500],'r-');
    %  plot(pred_snoon(i)+b(i),
end

legend(h1,{'Obs Solar Noon';'Pred Solar Noon';'Pred SRrise, SSet';'Missing Data'});
title('corrected');

%%% Split the data into 2-week segments and see what the estimates are for
%%% shifts within the 2-week periods:
ctr = 1;
for j = 1:14:length(snoon)-14
    seg_mode_noon(ctr,1) = mode(pred_snoon(j:j+13,1)-snoon(j:j+13,1));
    ctr = ctr+1;
end
disp(seg_mode_noon);