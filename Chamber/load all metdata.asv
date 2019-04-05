%load all met data

%load 2008 data
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

PAR_DOWN_08= load('C:/DATA/metdata 2008/TP39_2008.015');
PAR_UP_08= load('C:/DATA/metdata 2008/TP39_2008.016');

%load 2009 data
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

PAR_DOWN_09= load('C:/DATA/metdata 2009/TP39_2009.015');
PAR_UP_09= load('C:/DATA/metdata 2009/TP39_2009.016');

%Combine 2008 and 2009 data

Ts2_A_all    = [Ts2_A_08; Ts2_A_09];
Ts2_B_all    = [Ts2_B_08; Ts2_B_09];
Ts5_A_all    = [Ts5_A_08; Ts5_A_09];
Ts5_B_all    = [Ts5_B_08; Ts5_B_09];
Ts20_A_all   = [Ts20_A_08; Ts20_A_09];
Ts20_B_all   = [Ts20_B_08; Ts20_B_09];
Ts50_A_all   = [Ts50_A_08; Ts50_A_09];
Ts50_B_all   = [Ts50_B_08; Ts50_B_09];

SM5_A_all    = [SM5_A_08; SM5_A_09];
SM5_B_all    = [SM5_B_08; SM5_B_09];
SM10_A_all   = [SM10_A_08; SM10_A_09];
SM10_B_all   = [SM10_B_08; SM10_B_09];
SM20_A_all   = [SM20_A_08; SM20_A_09];
SM20_B_all   = [SM20_B_08; SM20_B_09];
SM50_A_all   = [SM50_A_08; SM50_A_09];
SM50_B_all   = [SM50_B_08; SM50_B_09];

PAR_DOWN_all = [PAR_DOWN_08; PAR_DOWN_09];
PAR_UP_all   = [PAR_UP_08; PAR_UP_09];

%chamber
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
chamber_data = dlmread('C:\DATA\condensed\hhour_all_current.csv'); %change file name

d_data = datenum(chamber_data(:,1),chamber_data(:,2),chamber_data(:,3),chamber_data(:,4),chamber_data(:,5),0);

[c i_output i_data] = intersect(d_2008, d_data);
output_2008(i_output,7:46) = chamber_data(i_data,6:45);


clear c i_output i_data
[c i_output i_data] = intersect(d_2009, d_data);
output_2009(i_output,7:46) = chamber_data(i_data,6:45);

save('C:\DATA\chamber_data\output_2008.dat','output_2008','-ASCII');
save('C:\DATA\chamber_data\output_2009.dat','output_2009','-ASCII');


%%%CLEANED DATA%%%

%load chamber data
chamber_data = dlmread('C:\DATA\condensed\hhour_all_current.csv');  %%change here%%

%Clean for 2008
cleaned_Ch1_08 = output_2008(:,16);
cleaned_Ch1_08(cleaned_Ch1_08 < 0.000001,1) = NaN;

cleaned_Ch2_08 = output_2008(:,26);
cleaned_Ch2_08(cleaned_Ch2_08 < 0.000001,1) = NaN;

cleaned_Ch3_08 = output_2008(:,36);
cleaned_Ch3_08(cleaned_Ch3_08 < 0.000001,1) = NaN;

cleaned_Ch4_08 = output_2008(:,46);
cleaned_Ch4_08(cleaned_Ch4_08 < 0.000001,1) = NaN;

%Clean for 2009
cleaned_Ch1_09 = output_2009(:,16);
cleaned_Ch1_09(cleaned_Ch1_09 < 0.000001,1) = NaN;

cleaned_Ch2_09 = output_2009(:,26);
cleaned_Ch2_09(cleaned_Ch2_09 < 0.000001,1) = NaN;

cleaned_Ch3_09 = output_2009(:,36);
cleaned_Ch3_09(cleaned_Ch3_09 < 0.000001,1) = NaN;

cleaned_Ch4_09 = output_2009(:,46);
cleaned_Ch4_09(cleaned_Ch4_09 < 0.000001,1) = NaN;

%Put 2008 and 2009 cleaned data together

cleaned_all_Ch1 = [cleaned_Ch1_08; cleaned_Ch1_09];
cleaned_all_Ch2 = [cleaned_Ch2_08; cleaned_Ch2_09];
cleaned_all_Ch3 = [cleaned_Ch3_08; cleaned_Ch3_09];
cleaned_all_Ch4 = [cleaned_Ch4_08; cleaned_Ch4_09];


%plot chamber data and metdata
figure(26);
hold on;
subplot (6,1,1);
hold on;
plot (cleaned_all_Ch1, 'r')
title ('Ch1 August 08 to May 09')
xlabel('HHOUR')
%ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 24000 -0.5 8]);
legend('Ch1',1)

subplot (6,1,2);
hold on;
plot (cleaned_all_Ch2, 'b')
title ('Ch2 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Soil CO2 Efflux (umol CO2 m-2 s-1)');
axis([10000 24000 -0.5 8]);
legend('Ch2',1)

subplot (6,1,3);
hold on;
plot (cleaned_all_Ch3, 'g')
title ('Ch3 August 08 to May 09')
xlabel('HHOUR')
%ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 24000 -0.5 8]);
legend('Ch3',1)

subplot (6,1,4);
hold on;
plot (cleaned_all_Ch4, 'c')
title ('Ch4 August 08 to May 09')
xlabel('HHOUR')
%ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 24000 -0.5 8]);
legend('Ch4',1)

subplot (6,1,5);
hold on;
plot (Ts5_A_all, 'm')
title ('Soil Temperature August 08 to May 09')
xlabel('HHOUR')
ylabel ('Soil Temperature (oC)');
axis([10000 24000 -5 25]);
legend('Ts5',1)

subplot (6,1,6);
hold on;
plot (SM20_A_all, 'k')
title ('Soil Moisture August 08 to May 09')
xlabel('HHOUR')
ylabel ('Soil Moisture(m3 m-3)');
axis([10000 24000 0 0.5]);
legend('SM20',1)


