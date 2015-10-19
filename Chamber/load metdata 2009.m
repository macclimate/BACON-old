%Load Met data 2009

Ts2_A_09=  load('C:/DATA/metdata 2009/TP39_2009.087');
Ts2_B_09=  load('C:/DATA/metdata 2009/TP39_2009.098');
Ts5_A_09=  load('C:/DATA/metdata 2009/TP39_2009.091');
Ts5_B_09=  load ('C:/DATA/metdata 2009/TP39_2009.097');
Ts20_A_09=  load('C:/DATA/metdata 2009/TP39_2009.090');
Ts20_B_09=  load('C:/DATA/metdata 2009/TP39_2009.095');
Ts50_A_09=  load('C:/DATA/metdata 2009/TP39_2009.088');
Ts50_B_09=  load('C:/DATA/metdata 2009/TP39_2009.094');


SM5_A_09= load('C:/DATA/metdata 2009/TP39_2009.099');
SM5_B_09= load('C:/DATA/metdata 2009/TP39_2009.104');
SM10_A_09= load('C:/DATA/metdata 2009/TP39_2009.100');
SM10_B_09= load('C:/DATA/metdata 2009/TP39_2009.105');
SM20_A_09= load('C:/DATA/metdata 2009/TP39_2009.101');
SM20_B_09= load('C:/DATA/metdata 2009/TP39_2009.106');
SM50_A_09= load('C:/DATA/metdata 2009/TP39_2009.102');
SM50_B_09= load('C:/DATA/metdata 2009/TP39_2009.107');

RAIN_09= load('C:/DATA/metdata 2009/TP39_2009.017');

PAR_DOWN_09= load('C:/DATA/metdata 2009/TP39_2009.015');
PAR_UP_09= load('C:/DATA/metdata 2009/TP39_2009.016');

%Plot the met data
figure(21); 
hold on;
subplot (2,1,1);
hold on;
plot(Ts2_A , 'r')
plot(Ts2_A , 'c')
plot(Ts5_A,'b')
plot(Ts5_B,'g')
%axis([0 18000 -20 35]);
title('Soil Temperature')
xlabel('HHOUR')
ylabel ('Temperature (oC)');
legend('Ts2_A','Ts2_B' 'Ts5_A', 'Ts5_B',1)

subplot (2,1,2);
hold on;
plot (SM5_A, 'r')
plot(SM5_B, 'c')
plot (SM20_A, 'b')
plot(SM20_B, 'g')
%axis([0 18000 0 0.50]);
title('Soil Moisture ')
xlabel('HHOUR')
ylabel('Soil Moisture (m3 m-3)')
legend ('SM5_A', 'SM5_B', 'SM20_A', 'SM20_B',1)






