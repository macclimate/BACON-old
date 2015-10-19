%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This script plots up the Li 7000 box temperature, along with outside
%%% air temp (@ 28m) and wind speed, in order to allow analysis of causes
%%% for de-regulation in box temp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Tbox_06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\T_li700006.dat');
T28_06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\T28.csv');
WS_06 = load('C:\Home\Matlab\Data\Organized\Met1\Column\30min\WS2006.csv');

figure (1)
clf;
plot(Tbox_06,'b.-');
hold on;
grid on;
plot(T28_06,'r.-');
plot(WS_06,'k-');