%Load Soil Temperature Ts at 5 cm depth%

Ts2_A_08=  load('C:/DATA/metdata 2008/TP39_2008.087');
Ts2_B_08=  load('C:/DATA/metdata 2008/TP39_2008.098');
Ts5_A_08=  load('C:/DATA/metdata 2008/TP39_2008.091');
Ts5_B_08=  load ('C:/DATA/metdata 2008/TP39_2008.097');
Ts20_A_08=  load('C:/DATA/metdata 2008/TP39_2008.090');
Ts20_B_08=  load('C:/DATA/metdata 2008/TP39_2008.095');
Ts50_A_08=  load('C:/DATA/metdata 2008/TP39_2008.088');
Ts50_B_08=  load('C:/DATA/metdata 2008/TP39_2008.094');


SM5_A_08= load('C:/DATA/metdata 2008/TP39_2008.099');
SM5_B_08= load('C:/DATA/metdata 2008/TP39_2008.104');
SM10_A_08= load('C:/DATA/metdata 2008/TP39_2008.100');
SM10_B_08= load('C:/DATA/metdata 2008/TP39_2008.105');
SM20_A_08= load('C:/DATA/metdata 2008/TP39_2008.101');
SM20_B_08= load('C:/DATA/metdata 2008/TP39_2008.106');
SM50_A_08= load('C:/DATA/metdata 2008/TP39_2008.102');
SM50_B_08= load('C:/DATA/metdata 2008/TP39_2008.107');

RAIN_08= load('C:/DATA/metdata 2008/TP39_2008.017');

PAR_DOWN_08= load('C:/DATA/metdata 2008/TP39_2008.015');
PAR_UP_08= load('C:/DATA/metdata 2008/TP39_2008.016');

%Plot Soil Temperature Ts at 5 cm depth against time%

figure(1); clf;
plot(Ts5,'b-');
ylabel('Soil Moisture')
title('Soil Moisture at 5 cm Depth')
xlabel('date')
% datetick('x')


% Pick out Ts, Sm5, pressure and Ppt for julian days 244-273 (September);

Ts5_sept(:,1) = Ts5(JD >= 244 & JD <= 273,1);
SM5_sept(:,1) = SM5(JD >= 244 & JD <= 273,1);
P_sept(:,1) = P(JD >= 244 & JD <= 273,1);
PPT_sept(:,1) = PPT(JD >= 245 & JD <= 274,1);

% Pick out Ts, Sm5, pressure and Ppt for julian days 274-304 (October);

Ts5_oct(:,1) = Ts5(JD >= 274 & JD <= 304,1);
SM5_oct(:,1) = SM5(JD >= 274 & JD <= 304,1);
P_oct(:,1) = P(JD >= 274 & JD <= 304,1);
PPT_oct(:,1) = PPT(JD >= 274 & JD <= 304,1);

% Pick out Ts, Sm5, pressure and Ppt for julian days 305-334 (November);

Ts5_nov(:,1) = Ts5(JD >= 305 & JD <= 334,1);
SM5_nov(:,1) = SM5(JD >= 305 & JD <= 334,1);
P_nov(:,1) = P(JD >= 305 & JD <= 344,1);
PPT_nov(:,1) = PPT(JD >= 305 & JD <= 344,1);

% Pick out Ts, Sm5, pressure and Ppt for julian days 213-143 (August);

Ts5_aug(:,1) = Ts5(JD >= 213 & JD <= 243,1);
SM5_aug(:,1) = SM5(JD >= 213 & JD <= 243,1);
P_aug(:,1) = P(JD >= 213 & JD <= 243,1);
PPT_aug(:,1) = PPT(JD >= 213 & JD <= 243,1);

% Pick out Ts, Sm5, pressure and Ppt for julian days 213-365 (August-December);

Ts5_08(:,1) = Ts5(JD >= 213 & JD <= 365,1);
SM5_08(:,1) = SM5(JD >= 213 & JD <= 365,1);
P_08(:,1) = P(JD >= 213 & JD <= 365,1);
PPT_08(:,1) = PPT(JD >= 213 & JD <= 365,1);


%Plot Ts for September
figure(3); clf;
plot(Ts5_sept,'b-');
ylabel('Soil Temperature (oC')
title('Soil Temperature at 5 cm Depth')
xlabel('date')

%Plot Efflux for chamber 1-4, Ts5, SM5, ppt for Sept

figure(1); clf
subplot(4,1,1)
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux (umol C m-2 s-1)')
xlabel('date')
datetick('x')
title('Soil CO2 Efflux')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure(2);clf
subplot(3,1,1)
plot(JD,Ts5,'b-');
hold on;
ylabel('Soil Temperature (oC)')
title('Soil Temperature at 5 cm Depth')
xlabel('date')

subplot(3,1,2)
plot(JD,SM5,'r-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth')
xlabel('date')

subplot(3,1,3)
plot(JD,PPT),'g-');
hold on;
ylabel('Precipitation (mm)')
title('CS Rain, Precipitation')
xlabel('date')

%Plot Efflux for chamber 1-4, Ts5, SM5, ppt for Oct

figure(1); clf
subplot(4,1,1)
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux (umol C m-2 s-1)')
xlabel('date')
datetick('x')
title('Soil CO2 Efflux')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

subplot(4,1,2)
plot(Ts5_oct(:,1),'b-');
hold on;
ylabel('Soil Temperature (oC)')
title('Soil Temperature at 5 cm Depth')
xlabel('date')

subplot(4,1,3)
plot(SM5_oct(:,1),'r-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth')
xlabel('date')

subplot(4,1,4)
plot(PPT_oct(:,1),'g-');
hold on;
ylabel('Precipitation (mm)')
title('CS Rain, Precipitation')
xlabel('date')

%Plot Efflux for chamber 1-4, Ts5, SM5, ppt for November

figure(1); clf
subplot(4,1,1)
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux (umol C m-2 s-1)')
xlabel('date')
datetick('x')
title('Soil CO2 Efflux')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

subplot(4,1,2)
plot(Ts5_nov(:,1),'b-');
hold on;
ylabel('Soil Temperature (oC)')
title('Soil Temperature at 5 cm Depth')
xlabel('date')

subplot(4,1,3)
plot(SM5_nov(:,1),'r-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth')
xlabel('date')

subplot(4,1,4)
plot(PPT_nov(:,1),'g-');
hold on;
ylabel('Precipitation (mm)')
title('CS Rain, Precipitation')
xlabel('date')

%Plot Efflux for chamber 1-4, Ts5, SM5, ppt for Aug

figure(1); clf
subplot(4,1,1)
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux (umol C m-2 s-1)')
xlabel('date')
datetick('x')
title('Soil CO2 Efflux')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

subplot(4,1,2)
plot(Ts5_aug(:,1),'b-');
hold on;
ylabel('Soil Temperature (oC)')
title('Soil Temperature at 5 cm Depth')
xlabel('date')

subplot(4,1,3)
plot(SM5_aug(:,1),'r-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth')
xlabel('date')

subplot(4,1,4)
plot(PPT_aug(:,1),'g-');
hold on;
ylabel('Precipitation (mm)')
title('CS Rain, Precipitation')
xlabel('date')


% Pick out Sm5, SM10, and SM20 for julian days 213-243 (August);

SM5_aug(:,1) = SM5(JD >= 213 & JD <= 243,1);
SM10_aug(:,1) = SM10(JD >= 213 & JD <= 243,1);
SM20_aug(:,1) = SM20(JD >= 213 & JD <= 243,1);

% Pick out Sm5, SM10, and SM20 for julian days 244-273 (September);

SM5_sept(:,1) = SM5(JD >= 244 & JD <= 273,1);
SM10_sept(:,1) = SM10(JD >= 244 & JD <= 273,1);
SM20_sept(:,1) = SM20(JD >= 244 & JD <= 273,1);

% Pick out Sm5, SM10, and SM20 for julian days 274-304 (October);

SM5_oct(:,1) = SM5(JD >= 274 & JD <= 304,1);
SM10_oct(:,1) = SM10(JD >= 274 & JD <= 304,1);
SM20_oct(:,1) = SM20(JD >= 274 & JD <= 304,1);

% Pick out Sm5, SM10, and SM20 for julian days 305-334 (November);

SM5_nov(:,1) = SM5(JD >= 305 & JD <= 334,1);
SM10_nov(:,1) = SM10(JD >= 305 & JD <= 334,1);
SM20_nov(:,1) = SM20(JD >= 305 & JD <= 334,1);

%Plot Efflux for chamber 1-4, SM5, SM10, and SM20 for Aug

figure(1); clf
subplot(4,1,1)
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux (umol C m-2 s-1)')
xlabel('date')
datetick('x')
title('Soil CO2 Efflux')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

subplot(4,1,2)
plot(SM5_aug(:,1),'b-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth')
xlabel('date')

subplot(4,1,3)
plot(SM10_aug(:,1),'r-');
hold on;
ylabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 10 cm Depth')
xlabel('date')

subplot(4,1,4)
plot(SM20_aug(:,1),'g-');
hold on;
ylabel('Soil Moisture (m3 m-3')
title('Soil Moisture at 20 cm depth')
xlabel('date')



%% Scatterplot between SM5 and Ch efflux

figure(3); clf;
plot(SM5,output_2008,'pb');
title('Efflux vs. Soil Moisture')
ylabel('efflux (umol C m-2 s-1)')
xlabel('soi moisture (m3 m-3)')

