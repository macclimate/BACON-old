%load data
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load Soil Temperature Ts at 5 cm depth%

Ts2= load('C:/DATA/metdata 2008/TP39_2008.098');
Ts5= load('C:/DATA/metdata 2008/TP39_2008.097');
Ts10= load('C:/DATA/metdata 2008/TP39_2008.096');
Ts20= load('C:/DATA/metdata 2008/TP39_2008.095');
SM5= load('C:/DATA/metdata 2008/TP39_2008.104');
SM10= load('C:/DATA/metdata 2008/TP39_2008.105');
SM20= load('C:/DATA/metdata 2008/TP39_2008.106');
P= load('C:/DATA/metdata 2008/TP39_2008.084');
PPT= load('C:/DATA/metdata 2008/TP39_2008.038');
JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');


%Scatter Plot Soil T vs. Efflux ch1-ch4
C_1 = output_2008(:,16);
C_2 = output_2008(:,26);
C_3 = output_2008(:,36);
C_4 = output_2008(:,46);

C_1(14250:14650,1) = NaN;
C_2(14250:14650,1) = NaN;
C_3(14250:14650,1) = NaN;
C_4(14250:14650,1) = NaN;

ind_regress1 = find(C_1 < 0.000001);
ind_regress2 = find(C_2 < 0.000001);
ind_regress3 = find(C_3 < 0.000001);
ind_regress4 = find(C_4 < 0.000001);
C_1(ind_regress1) = NaN;
C_2(ind_regress2) = NaN;
C_3(ind_regress3) = NaN;
C_4(ind_regress4) = NaN;

figure(3); clf;
hold on;
subplot (2,2,1);
title('Soil Temperature at 5 cm Depth and Efflux')
hold on;
plot(Ts5, C_1, 'r.') 
subplot (2,2,3);
plot(Ts5, C_2, 'b.')
subplot (2,2,2);
plot (Ts5, C_3, 'c.')
subplot (2,2,4);
plot (Ts5, C_4, 'g.')
%xlabel('Soil Temperature (oC)')
%ylabel('Efflux (umol C m-2 s-1)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Soil Ts5 vs. Efflux ch1-ch4

figure(1); clf;
plot(Ts5(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(Ts5(10225:16290,1), chamber_data(:,25), 'b.')
plot(Ts5(10225:16290,1), chamber_data(:,35), 'c.')
plot(Ts5(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Soil Temperature (oC)')
title('Soil Temperature at 5 cm Depth and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Soil Moisture at 5cm vs. Efflux ch1-ch4

figure(2); clf;
plot(SM5(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(SM5(10225:16290,1), chamber_data(:,25), 'b.')
plot(SM5(10225:16290,1), chamber_data(:,35), 'c.')
plot(SM5(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 5 cm Depth and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Soil Moisture at 10cm vs. Efflux ch1-ch4

figure(4); clf;
plot(SM10(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(SM10(10225:16290,1), chamber_data(:,25), 'b.')
plot(SM10(10225:16290,1), chamber_data(:,35), 'c.')
plot(SM10(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Soil Moisture (m3 m-3)')
title('Soil Moisture at 10 cm Depth and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Pressure vs. Efflux ch1-ch4

figure(4); clf;
plot(P(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(P(10225:16290,1), chamber_data(:,25), 'b.')
plot(P(10225:16290,1), chamber_data(:,35), 'c.')
plot(P(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Atmospheric Pressure (kPa)')
title('Atmospheric Pressure and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Soil Ts2 vs. Efflux ch1-ch4

figure(5); clf;
plot(Ts2(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(Ts2(10225:16290,1), chamber_data(:,25), 'b.')
plot(Ts2(10225:16290,1), chamber_data(:,35), 'c.')
plot(Ts2(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Soil Temperature (oC)')
title('Soil Temperature at 2 cm Depth and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%Scatter Plot Soil Ts10 vs. Efflux ch1-ch4

figure(6); clf;
plot(Ts10(10225:16290,1), chamber_data(:,15), 'r.') 
hold on;
plot(Ts10(10225:16290,1), chamber_data(:,25), 'b.')
plot(Ts10(10225:16290,1), chamber_data(:,35), 'c.')
plot(Ts10(10225:16290,1), chamber_data(:,45), 'g.')
xlabel('Soil Temperature (oC)')
title('Soil Temperature at 10 cm Depth and Efflux')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)







