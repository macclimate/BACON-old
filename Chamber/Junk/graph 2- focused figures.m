%% This script is designed to show the focused figures of temperature, soil
%% moisture and CO2 efflux. Shows hhour data only. For monthly comparison%%

%load chamber data
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all3updated.csv');

clear all;
[Year, JD, HHMM, dt] = jjb_makedate(2008, 30);
[no_days] = jjb_days_in_month(2008);

 ctr = 1;
for m = 1:1:12
    
    for d = 1:1:no_days(m)
        for h = 1:1:48
        Month(ctr,1) = m;
        Day(ctr,1) = d;
        ctr = ctr+1;
        end
    end
end

% output_2008 = [Year Month Day HH]
HHMMs = num2str(HHMM);

HH = NaN.*ones(length(Year),1);
MM = NaN.*ones(length(Year),1);

for c = 1:1:length(HH)
    try
HH(c,1) = str2num(HHMMs(c,1:2));
    catch
 HH(c,1) = 0;
    end
    MM(c,1) = str2num(HHMMs(c,3:4));
end

HH(HH == 24,1) = 0;
output_2008(1:length(Year),1:46) = NaN;
output_2008 = [Year Month JD Day HH MM];

clear Year JD HHMM HH MM dt no_days d m HHMMs Month Day
%% For 2009:
[Year, JD, HHMM, dt] = jjb_makedate(2009, 30);
[no_days] = jjb_days_in_month(2009);

 ctr = 1;
for m = 1:1:12
    
    for d = 1:1:no_days(m)
        for h = 1:1:48
        Month(ctr,1) = m;
        Day(ctr,1) = d;
        ctr = ctr+1;
        end
    end
end

HHMMs = num2str(HHMM);

HH = NaN.*ones(length(Year),1);
MM = NaN.*ones(length(Year),1);

for c = 1:1:length(HH)
    try
HH(c,1) = str2num(HHMMs(c,1:2));
    catch
 HH(c,1) = 0;
    end
    MM(c,1) = str2num(HHMMs(c,3:4));
end

HH(HH == 24,1) = 0;

output_2009(1:length(Year),1:46) = NaN;
output_2009 = [Year Month JD Day HH MM];

%% 
%%% turn 
d_2008 = datenum(output_2008(:,1), output_2008(:,2), output_2008(:,4), output_2008(:,5), output_2008(:,6),0);
d_2009 = datenum(output_2009(:,1), output_2009(:,2), output_2009(:,4), output_2009(:,5), output_2009(:,6),0);
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all3updated.csv');

d_data = datenum(chamber_data(:,1),chamber_data(:,2),chamber_data(:,3),chamber_data(:,4),chamber_data(:,5),0);

[c i_output i_data] = intersect(d_2008, d_data);
output_2008(i_output,7:46) = chamber_data(i_data,6:45);


clear c i_output i_data
[c i_output i_data] = intersect(d_2009, d_data);
output_2009(i_output,7:46) = chamber_data(i_data,6:45);

save('C:\DATA\condensed\output_2008.dat','output_2008','-ASCII');
save('C:\DATA\condensed\output_2009.dat','output_2009','-ASCII');

%load all the met data

JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');

Ta=load('C:/DATA/metdata 2008/TP39_2008.009');
Ts5_A=load ('C:/DATA/metdata 2008/TP39_2008.091');
Ts5_B= load ('C:/DATA/metdata 2008/TP39_2008.097');
SM20_A= load('C:/DATA/metdata 2008/TP39_2008.101');
SM20_B= load('C:/DATA/metdata 2008/TP39_2008.106');

%%August 2008 Comparison Plots%% Julian Days 214- 244

%Load Julian Dday 214-243%
Ta_aug(:,1) = Ta(JD >= 214 & JD <= 244,1);
Ts5_A_aug(:,1) = Ts5_A(JD >= 214 & JD <= 244,1);
Ts5_B_aug(:,1) = Ts5_B(JD >= 214 & JD <= 244,1);
SM20_A_aug(:,1) = SM20_A(JD >= 214 & JD <= 244,1);
SM20_B_aug(:,1) = SM20_B(JD >= 214 & JD <= 244,1);

%Plot for August 2008

figure (2);
hold on;
subplot(2,1,1)
plot(Ta_aug, 'r')
hold on;
plot(Ts5_A_aug, 'g')
plot(Ts5_B_aug, 'b')
xlabel('HHOUR')
title('Air and Soil Temperature at 5 cm Depth for August 2008')
ylabel('Temperature (oC)')
legend('Ta', 'Ts_A', 'Ts_B')

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux August 2008')
axis ([10272 11760 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure (3);
hold on;
subplot(2,1,1)
plot(SM20_A_aug, 'r')
hold on;
plot(SM20_B_aug, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for August 2008')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux August 2008')
axis ([10272 11760 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


%%September 2008 Comparison Plots%% Julian Days 245- 274

%Load Julian Dday 245-274%
Ta_sept(:,1) = Ta(JD >= 245 & JD <= 274,1);
Ts5_A_sept(:,1) = Ts5_A(JD >= 245 & JD <= 274,1);
Ts5_B_sept(:,1) = Ts5_B(JD >= 245 & JD <= 274,1);
SM20_A_sept(:,1) = SM20_A(JD >= 245 & JD <= 274,1);
SM20_B_sept(:,1) = SM20_B(JD >= 245 & JD <= 274,1);

%Plot for September 2008

figure (4);
hold on;
subplot(2,1,1)
plot(Ta_sept, 'r')
hold on;
plot(Ts5_A_sept, 'g')
plot(Ts5_B_sept, 'b')
xlabel('HHOUR')
title('Air and Soil Temperature at 5 cm Depth for September 2008')
ylabel('Temperature (oC)')
legend('Ta', 'Ts_A', 'Ts_B')

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux September 2008')
axis ([11760 13152 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure (5);
hold on;
subplot(2,1,1)
plot(SM20_A_sept, 'r')
hold on;
plot(SM20_B_sept, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for September 2008')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux September 2008')
axis ([11760 13152 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%%October 2008 Comparison Plots%% Julian Days 275- 305

%Load Julian Dday 275-305%
Ta_oct(:,1) = Ta(JD >= 275 & JD <= 305,1);
Ts5_A_oct(:,1) = Ts5_A(JD >= 275 & JD <= 305,1);
Ts5_B_oct(:,1) = Ts5_B(JD >= 275 & JD <= 305,1);
SM20_A_oct(:,1) = SM20_A(JD >= 275 & JD <= 305,1);
SM20_B_oct(:,1) = SM20_B(JD >= 275 & JD <= 305,1);

%Plot for October 2008

figure (6);
hold on;
subplot(2,1,1)
plot(Ta_oct, 'r')
hold on;
plot(Ts5_A_oct, 'g')
plot(Ts5_B_oct, 'b')
xlabel('HHOUR')
title('Air and Soil Temperature at 5 cm Depth for October 2008')
ylabel('Temperature (oC)')
legend('Ta', 'Ts_A', 'Ts_B')

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux October 2008')
axis ([13200 14640 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure (7);
hold on;
subplot(2,1,1)
plot(SM20_A_oct, 'r')
hold on;
plot(SM20_B_oct, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for October 2008')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux October 2008')
axis ([13200 14640 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%%November 2008 Comparison Plots%% Julian Days 306-335

%Load Julian Dday 275-305%
Ta_nov(:,1) = Ta(JD >= 306 & JD <= 335,1);
Ts5_A_nov(:,1) = Ts5_A(JD >= 306 & JD <= 335,1);
Ts5_B_nov(:,1) = Ts5_B(JD >= 306 & JD <= 335,1);
SM20_A_nov(:,1) = SM20_A(JD >= 306 & JD <= 335,1);
SM20_B_nov(:,1) = SM20_B(JD >= 306 & JD <= 335,1);

%Plot for November 2008

figure (8);
hold on;
subplot(2,1,1)
plot(Ta_nov, 'r')
hold on;
plot(Ts5_A_nov, 'g')
plot(Ts5_B_nov, 'b')
xlabel('HHOUR')
title('Air and Soil Temperature at 5 cm Depth for November 2008')
ylabel('Temperature (oC)')
legend('Ta', 'Ts_A', 'Ts_B')

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux November 2008')
axis ([14688 16080 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure (9);
hold on;
subplot(2,1,1)
plot(SM20_A_nov, 'r')
hold on;
plot(SM20_B_nov, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for November 2008')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux November 2008')
axis ([14688 16080 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%%December 2008 Comparison Plots%% Julian Days 336-366

%Load Julian Day 275-305%
Ta_dec(:,1) = Ta(JD >= 336 & JD <= 335,1);
Ts5_A_dec(:,1) = Ts5_A(JD >= 336 & JD <= 366,1);
Ts5_B_dec(:,1) = Ts5_B(JD >= 336 & JD <= 366,1);
SM20_A_dec(:,1) = SM20_A(JD >= 336 & JD <= 366,1);
SM20_B_dec(:,1) = SM20_B(JD >= 336 & JD <= 366,1);

%Plot for December 2008

figure (10);
hold on;
subplot(2,1,1)
plot(Ta_dec, 'r')
hold on;
plot(Ts5_A_dec, 'g')
plot(Ts5_B_dec, 'b')
xlabel('HHOUR')
title('Air and Soil Temperature at 5 cm Depth for December 2008')
ylabel('Temperature (oC)')
legend('Ta', 'Ts_A', 'Ts_B')

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux December 2008')
axis ([16128 17568 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


figure (11);
hold on;
subplot(2,1,1)
plot(SM20_A_dec, 'r')
hold on;
plot(SM20_B_dec, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for December 2008')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux December 2008')
axis ([16128 17568 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%%%%%%A particular rain event%%%%%%%
%%%%%%HAVING 25.12 MM OF RAIN%%%%%%%

%Load Julian Day %
Ta_rain(:,1) = Ta(JD >= 250 & JD <= 260,1);
Ts5_A_rain(:,1) = Ts5_A(JD >= 250 & JD <= 260,1);
Ts5_B_rain(:,1) = Ts5_B(JD >= 250 & JD <= 260,1);
SM20_A_rain(:,1) = SM20_A(JD >= 250& JD <= 260,1);
SM20_B_rain(:,1) = SM20_B(JD >= 250 & JD <= 260,1);


figure (16);
hold on;
subplot(2,1,1)
plot(SM20_A_rain, 'r')
hold on;
plot(SM20_B_rain, 'b')
xlabel('HHOUR')
title('Soil Moisture at 20 cm Depth for a Rain Event')
ylabel('Soil Moisture (m3 m-3)')
legend('SM20_A', 'SM20_B',1)

subplot(2,1,2)
hold on;
plot (output_2008(:,16), 'r')
plot (output_2008(:,26), 'b')
%plot (output_2008(:,36), 'g')
plot (output_2008(:,46), 'c')
title('Soil CO2 Efflux for a Rain Event')
axis ([12000 12480 -5 12]);
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

