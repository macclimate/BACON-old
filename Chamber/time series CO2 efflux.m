%%%%%%%%%%TIME SERIES FOR SOIL CO2 EFFLUX%%%%%%%%%%%%%%%

%load data
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all_cuurent.csv');

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
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all_cuurent.csv');

d_data = datenum(chamber_data(:,1),chamber_data(:,2),chamber_data(:,3),chamber_data(:,4),chamber_data(:,5),0);

[c i_output i_data] = intersect(d_2008, d_data);
output_2008(i_output,7:46) = chamber_data(i_data,6:45);


clear c i_output i_data
[c i_output i_data] = intersect(d_2009, d_data);
output_2009(i_output,7:46) = chamber_data(i_data,6:45);

save('C:\DATA\condensed\output_2008.dat','output_2008','-ASCII');
save('C:\DATA\condensed\output_2009.dat','output_2009','-ASCII');


%Clean
cleaned_Ch1 = output_2009(:,16);
cleaned_Ch1(cleaned_Ch1==0,1) = NaN;

cleaned_Ch2 = output_2009(:,26);
cleaned_Ch2(cleaned_Ch2==0,1) = NaN;

cleaned_Ch3 = output_2009(:,36);
cleaned_Ch3(cleaned_Ch3==0,1) = NaN;

cleaned_Ch4 = output_2009(:,46);
cleaned_Ch4(cleaned_Ch4==0,1) = NaN;


% %%%PLOT TIME SERIES%%%
% figure(99); 
% hold on;
% subplot (4,1,1);
% hold on;
% plot(output_2008(:,16), 'r') 
% subplot (4,1,2);
% plot(output_2008(:,26), 'b')
% subplot (4,1,3);
% plot (output_2008(:,36), 'g')
% subplot (4,1,4);
% plot (output_2008(:,46), 'c')

%%%PLOT CLEAN TIME SERIES%%%
figure(100); 
hold on;
subplot (4,1,1);
hold on;
plot(cleaned_Ch1, 'r')
legend('Ch SE',1)
title('Time Series of Soil CO2 Efflux Data for 2008')
subplot (4,1,2);
plot(cleaned_Ch2, 'b')
legend('Ch SW',1)
subplot (4,1,3);
plot (cleaned_Ch3, 'g')
ylabel ('Soil CO2 Efflux (umol C m-2 s-1)')
legend('Ch NE',1)
subplot (4,1,4);
plot (cleaned_Ch4, 'c')
xlabel ('HHOUR')
legend('Ch NW',1)

