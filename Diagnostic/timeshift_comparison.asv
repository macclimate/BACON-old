%%%%This program has been written in order to find where shifts between
%%%%meteorological and flux dataloggers has taken place.  It plots data
%%%%from the Met dataloggers in red, while flux data in blue, for
%%%%comparison.


clear all 
close all

Wdir = load('C:\Home\Matlab\Data\Flux\WindDir06.dat');
Ux = load('C:\Home\Matlab\Data\Flux\Ux06.dat');
Uy = load('C:\Home\Matlab\Data\Flux\Uy06.dat');

U = sqrt(Ux.^2 + Uy.^2);

% Wdir_met = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2006.014');
Wdir_met = load('C:\Home\Matlab\Data\met_data\Met1\Other\Wdir_2006.txt');
WS_met = load('C:\Home\Matlab\Data\met_data\Met1\Other\WS_2006.txt');

Wdir_met06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2006.014');
WS_met06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2006.013');

T_met06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2006.008');
T_Csat06 = load('C:\Home\Matlab\Data\Flux\T_Csat06.dat');
T_master = load('C:\Home\Matlab\Data\met_data\Met1\Other\T28m_2006.txt');

figure (1)
clf;

subplot(3,1,1)
plot(Wdir,'bx-')
hold on
plot(Wdir_met,'rx-')
plot(Wdir_met06,'gx-')
title ('2006 Met 1 Wind Direction - Flux data vs. Met Data');
legend ('Flux Wdir','Met Wdir', 'DL Met Wdir');
grid on;

subplot(3,1,2)
title('2006 Met 1 Wind Speed - Flux data vs. Met Data');
plot(U,'bx-')
hold on
plot(WS_met,'rx-')
plot(WS_met06,'gx-')
legend ('Flux WS','Met WS', 'DL Met WS');
grid on;

subplot(3,1,3)
title('2006 Met 1 Air Temp - Flux data vs. Met Data');
plot(T_Csat06,'bx-')
hold on
plot(T_master,'rx-')
plot(T_met06,'gx-')
legend ('TCSAT', 'T28 Master File','DL Met Tair');
grid on;

%%%%% 2007 data

Wdir07 = load('C:\Home\Matlab\Data\Flux\WindDir07.dat');
Ux07 = load('C:\Home\Matlab\Data\Flux\Ux07.dat');
Uy07 = load('C:\Home\Matlab\Data\Flux\Uy07.dat');

U07 = sqrt(Ux07.^2 + Uy07.^2);

Wdir_met07 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2007.014');
WS_met07 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2007.013');

figure (2)
clf;

subplot(2,1,1)
plot(Wdir07,'bx-')
hold on;
plot(Wdir_met07,'rx-')
grid on;
title ('2007 Met 1 Wind Direction - Flux data vs. Met Data');
legend ('Flux Wdir','Met Wdir');

subplot(2,1,2)
plot(U07,'bx-')
hold on
plot(WS_met07,'rx-')
grid on;
title('2007 Met 1 Wind Speed - Flux data vs. Met Data');
legend ('Flux WS','Met WS');

%%% 2005 Data
Wdir05 = load('C:\Home\Matlab\Data\Flux\WindDir05.dat');
Ux05 = load('C:\Home\Matlab\Data\Flux\Ux05.dat');
Uy05 = load('C:\Home\Matlab\Data\Flux\Uy05.dat');

U05 = sqrt(Ux05.^2 + Uy05.^2);

Wdir_met05 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2005.014');
WS_met05 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\Met1_2005.013');

figure (3)
clf;

subplot(2,1,1)
plot(Wdir05,'bx-')
hold on;
plot(Wdir_met05,'rx-')
grid on;
title ('2005 Met 1 Wind Direction - Flux data vs. Met Data');
legend ('Flux Wdir','Met Wdir');

subplot(2,1,2)
plot(U05,'bx-')
hold on
plot(WS_met05,'rx-')
grid on;
title('2005 Met 1 Wind Speed - Flux data vs. Met Data');
legend ('Flux WS','Met WS');



%%% Part 2 - Compare 2006 and 2007 radiation data from sites to see if
%%% there is any difference (i.e. time shift)

%%% Met 2
M2_2005up = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2005.011');
M2_2005d = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2005.012');


M2_2006up = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2006.011');
M2_2006d = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2006.012');


M2_2007up = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2007.011');
M2_2007d = load('C:\Home\Matlab\Data\Organized\Met2\Column\30min\Met2_2007.012');

figure (4)
clf;
subplot(2,1,1)
plot(M2_2005up,'gx-');
hold on;
plot(M2_2006up,'bx-');
plot(M2_2007up,'rx-');

grid on;
title ('Met2 reflected radiation: 2005, 2006 vs 2007');
legend ('2005','2006','2007');

subplot(2,1,2)
plot(M2_2005d,'gx-');
hold on;
plot(M2_2006d,'bx-');
plot(M2_2007d,'rx-');
grid on;
title ('Met2 sky radiation: 2005, 2006 vs 2007');
legend ('2005','2006','2007');

%%% Met 3

M3_2005up = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2005.011');
M3_2005d = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2005.012');


M3_2006up = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2006.011');
M3_2006d = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2006.012');


M3_2007up = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2007.011');
M3_2007d = load('C:\Home\Matlab\Data\Organized\Met3\Column\30min\Met3_2007.012');

figure (5)
clf;
subplot(2,1,1)

plot(M3_2005up,'gx-');
hold on;
plot(M3_2006up,'bx-');
plot(M3_2007up,'rx-');
grid on;
title ('Met3 reflected radiation: 2005, 2006 vs 2007');
legend ('2005','2006','2007');

subplot(2,1,2)
plot(M3_2005d,'gx-');
hold on;
plot(M3_2006d,'bx-');
plot(M3_2007d,'rx-');
grid on;
title ('Met3 sky radiation: 2005, 2006 vs 2007');
legend ('2005','2006','2007');

%%% Met 4
M4_2005up = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2005.010');
M4_2005d = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2005.009');


M4_2006up = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2006.010');
M4_2006d = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2006.009');

M4_2007up = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2007.009');
M4_2007d = load('C:\Home\Matlab\Data\Organized\Met4\Column\30min\Met4_2007.010');

figure (6)
clf;
subplot(2,1,1)
plot(M4_2005up,'gx-');
hold on;
plot(M4_2006up,'bx-');
plot(M4_2007up,'rx-');
grid on;
title ('Met4 reflected radiation: 2005, 2006 vs 2007');
legend ('2005','2006','2007');

subplot(2,1,2)
plot(M4_2005d,'gx-');
hold on;
plot(M4_2006d,'bx-');
plot(M4_2007d,'rx-');
grid on;
title ('Met4 sky radiation: 2005, 2006 vs 2007');
legend ('2005', '2006','2007');

