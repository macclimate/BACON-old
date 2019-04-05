function [] = met1plot(year)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This program plots time-averaged met variables collected from the Met2
%%%% Station, to allow for easy and quick inspection of sensor operation.
%%%% # of days in year is necessary to scale the x (time) axis properly.
%%%% Created May 24, 2007 by JJB
%%%% Modified May 28, 2007 by JJB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;

if mod(year,400)==0
    days_in_year = 366;
    
elseif mod(year,4) ==0
    days_in_year = 366;
    
else 
    days_in_year = 365;
end

%%%% Declare paths for each time averaged variable %%%%
path5 = (['C:\Home\Matlab\Data\Met\Organized2\Met1\Column\5min\Met1_' num2str(year) '.']);


path30 = (['C:\Home\Matlab\Data\Met\Organized2\Met1\Column\30min\Met1_' num2str(year) '.']);


pathday = (['C:\Home\Matlab\Data\Met\Organized2\Met1\Column\1440min\Met1_' num2str(year) '.']);

x_raw = [1:1:17520];
%%%% Load Timevectors for 5 min, 30 min and 1 day column vectors & convert into fractions of a year %%%%
tv_5 = load([path5 'tv']);
tv_5int = days_in_year./length(tv_5); %%% determines increments of year for each TV entry
tv_5(1:length(tv_5),1) = (tv_5int:tv_5int:days_in_year)';
tv_5(1:length(tv_5),1) = tv_5+1;

tv_30 = load([path30 'tv']);
tv_30int = days_in_year./length(tv_30); %%% determines increments of year for each TV entry
tv_30(1:length(tv_30),1) = (tv_30int:tv_30int:days_in_year)';
tv_30(1:length(tv_30),1) = tv_30+1;

tv_day = load([pathday 'tv']);
tv_dayint = days_in_year./length(tv_day); %%% determines increments of year for each TV entry
tv_day(1:length(tv_day),1) = (tv_dayint:tv_dayint:days_in_year)';
tv_day(1:length(tv_day),1) = tv_day+1;

%%%% FIGURE 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Soil Temperatures from pits A and B
Ts100a = load([path30 '092']);
Ts50a = load([path30 '088']);
Ts20a = load([path30 '090']);
Ts10a = load([path30 '089']);
Ts5a = load([path30 '091']);
Ts2a = load([path30 '087']);

Ts100b = load([path30 '093']);
Ts50b = load([path30 '094']);
Ts20b = load([path30 '095']);
Ts10b = load([path30 '096']);
Ts5b = load([path30 '097']);
Ts2b = load([path30 '098']);

figure (5)
clf;


% Subplot 1 - Pit A
subplot(2,1,1);
h_100a = plot(tv_30, Ts100a, 'Color', [0 0 0], 'LineStyle','-');
hold on;
h_50a = plot(tv_30, Ts50a, 'Color', [1 0 1], 'LineStyle','-');
h_20a = plot(tv_30, Ts20a, 'Color', [0 1 1], 'LineStyle','-');
h_10a = plot(tv_30, Ts10a, 'Color', [1 0 0], 'LineStyle','-');
h_5a = plot(tv_30, Ts5a, 'Color', [0 1 0], 'LineStyle','-');
h_2a = plot(tv_30, Ts2a, 'Color', [0 0 1], 'LineStyle','-');
Ha = [h_100a h_50a h_20a h_10a h_5a h_2a];
legend(Ha, 'Ts 100cm','50','20','10','5','2');
axis([tv_30(1) tv_30(length(tv_30)) -5 30])
ylabel('Pit A Soil Temperatures, C');
title('Soil Temperature Profiles')

% Subplot 2 - Pit B
subplot(2,1,2);

h_100b = plot(tv_30, Ts100b, 'Color', [0 0 0], 'LineStyle','-');
hold on;
h_50b = plot(tv_30, Ts50b, 'Color', [1 0 1], 'LineStyle','-');
h_20b = plot(tv_30, Ts20b, 'Color', [0 1 1], 'LineStyle','-');
h_10b = plot(tv_30, Ts10b, 'Color', [1 0 0], 'LineStyle','-');
h_5b = plot(tv_30, Ts5b, 'Color', [0 1 0], 'LineStyle','-');
h_2b = plot(tv_30, Ts2b, 'Color', [0 0 1], 'LineStyle','-');

Hb = [h_100b h_50b h_20b h_10b h_5b h_2b];
legend(Hb, 'Ts 100cm','50','20','10','5','2');
axis([tv_30(1) tv_30(length(tv_30)) -5 30])
ylabel('Pit B Soil Temperatures, C');

clear Ts100a Ts50a Ts20a Ts10a Ts5a Ts2a; 
clear Ts100b Ts50b Ts20b Ts10b Ts5b Ts2b;





%%%% FIGURE 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot Soil Moisture from Pits A and B
M100a = load([path30 '103']);
M50a = load([path30 '102']);
M20a = load([path30 '101']);
M10a = load([path30 '100']);
M5a = load([path30 '099']);

M100b = load([path30 '108']);
M50b = load([path30 '107']);
M20b = load([path30 '106']);
M10b = load([path30 '105']);
M5b = load([path30 '104']);


figure (6)
clf;


% Subplot 1 - Pit A
subplot(2,1,1);
h_M100a = plot(tv_30, M100a, 'Color', [1 0.5 0.5], 'LineStyle','-');
hold on;
h_M50a = plot(tv_30, M50a, 'Color', [1 0 1], 'LineStyle','-');
h_M20a = plot(tv_30, M20a, 'Color', [0 1 1], 'LineStyle','-');
h_M10a = plot(tv_30, M10a, 'Color', [1 0 0], 'LineStyle','-');
h_M5a = plot(tv_30, M5a, 'Color', [0 1 0], 'LineStyle','-');
HMa = [ h_M100a h_M50a h_M20a h_M10a h_M5a];
legend(HMa, 'M 100cm', '50','20','10','5');
axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
ylabel('Pit A Soil Moisture, %');
title('Soil Moisture Profiles');

% Subplot 2 - Pit B
% subplot(2,1,2);
% h_M100b = plot(tv_30, M100b, 'Color', [0.7 0 0.5], 'LineStyle','-');
% 
% hold on;
% h_M50b = plot(tv_30, M50b, 'Color', [1 0 1], 'LineStyle','-');
% h_M20b = plot(tv_30, M20b, 'Color', [0 1 1], 'LineStyle','-');
% h_M10b = plot(tv_30, M10b, 'Color', [1 0 0], 'LineStyle','-');
% h_M5b = plot(tv_30, M5b, 'Color', [0 1 0], 'LineStyle','-');
% HMb = [ h_M100b, h_M50b h_M20b h_M10b h_M5b];
% legend(HMb, 'M 100cm','50','20','10','5');
% axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
% ylabel('Pit B Soil Moisture, %');


%%%%%%%%%%%%% FIGURE 7 - same as 6, but with different x-axis
figure (7)
clf;


% Subplot 1 - Pit A
subplot(2,1,1);
h_M100a = plot(tv_30, M100a, 'Color', [1 0.5 0.5], 'LineStyle','-');
hold on;
h_M50a = plot(tv_30, M50a, 'Color', [1 0 1], 'LineStyle','-');
h_M20a = plot(tv_30, M20a, 'Color', [0 1 1], 'LineStyle','-');
h_M10a = plot(tv_30, M10a, 'Color', [1 0 0], 'LineStyle','-');
h_M5a = plot(tv_30, M5a, 'Color', [0 1 0], 'LineStyle','-');
HMa = [ h_M100a h_M50a h_M20a h_M10a h_M5a];
legend(HMa, 'M 100cm', '50','20','10','5');
axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
ylabel('Pit A Soil Moisture, %');
title('Soil Moisture Profiles');

% Subplot 2 - Pit B
subplot(2,1,2);
h_M100b = plot(tv_30, M100b, 'Color', [0.7 0 0.5], 'LineStyle','-');
hold on;
h_M50b = plot(tv_30, M50b, 'Color', [1 0 1], 'LineStyle','-');
h_M20b = plot(tv_30, M20b, 'Color', [0 1 1], 'LineStyle','-');
h_M10b = plot(tv_30, M10b, 'Color', [1 0 0], 'LineStyle','-');
h_M5b = plot(tv_30, M5b, 'Color', [0 1 0], 'LineStyle','-');
HMb = [ h_M100b, h_M50b h_M20b h_M10b h_M5b];
legend(HMb, 'M 100cm','50','20','10','5');
axis([tv_30(1) tv_30(length(tv_30)) 0 0.3])
ylabel('Pit B Soil Moisture, %');


clear M100a M50a M20a M10a M5a; 
clear M100b M50b M20b M10b M5b;

% %%%%%%%%%%%%%%%%%%%%%%% FIGURE 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%% Rain guage comparison (CS vs. RMYOUNG)
% 
% RainRMY = load([path30 '017']);
% RainCS = load([path30 '038']);
% H_flux1 = load([path30 '081']);
% 
% figure (8)
% clf;
% subplot(2,1,1)
% plot (x_raw,RainRMY, 'rx-');
% hold on
% plot(x_raw,RainCS, 'bx-');
% subplot(2,1,2)
% plot(x_raw,H_flux1,'rx-');

%%%%%%%%% FIGURE 9 T_HMP @ 14 & 28m

T_HMP14 = load([path30 '009']);
T_HMP28 = load([path30 '008']);

figure (9)
clf
plot(T_HMP14,'r')
hold on;
plot(T_HMP28,'b')

