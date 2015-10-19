%%%%%%%%%%This script was made for graph 1 for undergraduate thesis, PAR,
%%%%%%%%%%Ta, Ts, SM, CO2 hhour


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

%This script is designed to take the daily averages of
%%%%Created on March 09, 2009%%%%


% --- get time ---
days = 1;

%%%%%%%%%%%%% 2003 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- get time vector ---
load decdoy_00.txt;
dt = decdoy_00;
TimeX = dt;

%To load data%

JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');

% PAR_UP=load('C:/DATA/metdata 2008/TP39_2008.015');
% PAR_DOWN=load('C:/DATA/metdata 2008/TP39_2008.016');
Ta=load('C:/DATA/metdata 2008/TP39_2008.009');
Ts5_A=load ('C:/DATA/metdata 2008/TP39_2008.091');
Ts5_B= load ('C:/DATA/metdata 2008/TP39_2008.097');
SM20_A= load('C:/DATA/metdata 2008/TP39_2008.101');
SM20_B= load('C:/DATA/metdata 2008/TP39_2008.106');


% % --- PAR_UP ---
% PAR_UP =  PAR_UP; 
% [PAR_UPsum,PAR_UPmean,TimeX] = integzBC1(dt(~isnan(PAR_UP)),PAR_UP(~isnan(PAR_UP)),1:365,days); 
% PAR_UPmean	=PAR_UPmean'; 
% save 'C:\DATA\condensed\daily\PAR_UP_DM.dat' PAR_UPmean  -ASCII
% 
% % --- PAR_DOWN ---
% PAR_DOWN =  PAR_DOWN  
% [PAR_DOWNsum,PAR_DOWNmean,TimeX] = integzBC1(dt(~isnan(PAR_DOWN)),PAR_DOWN(~isnan(PAR_DOWN)),1:365,days); 
% PAR_DOWNMean	=	PAR_DOWNmean'; 
% save 'C:\DATA\condensed\daily\PAR_DOWN_DM.dat' PAR_DOWNMean   -ASCII

% --- Ta, oC ---
Ta =  Ta; % oC 
[Tasum,Tamean,TimeX] = integzBC1(dt(~isnan(Ta)),Ta(~isnan(Ta)),1:365,days); 
TaMean	=	Tamean'; 
save 'C:\DATA\condensed\daily\Ta_DM.dat' TaMean   -ASCII

%--- Ts5_A, oC ---
Ts5_A =  Ts5_A; % oC 
[Ts5_Asum,Ts5_Amean,TimeX] = integzBC1(dt(~isnan(Ts5_A)),Ts5_A(~isnan(Ts5_A)),1:365,days); 
Ts5_AMean	=	Ts5_Amean'; 
save 'C:\DATA\condensed\daily\Ts5_A_DM.dat'  Ts5_AMean   -ASCII

%--- Ts5_B, oC ---
Ts5_B=  Ts5_B; % oC 
[Ts5_Bsum,Ts5_Bmean,TimeX] = integzBC1(dt(~isnan(Ts5_B)),Ts5_B(~isnan(Ts5_B)),1:365,days); 
Ts5_BMean	=	Ts5_Bmean'; 
save 'C:\DATA\condensed\daily\Ts5_B_DM.dat'  Ts5_BMean   -ASCII

%--- SM20_A, oC ---
SM20_A =  SM20_A; % oC 
[SM20_Asum,SM20_Amean,TimeX] = integzBC1(dt(~isnan(SM20_A)),SM20_A(~isnan(SM20_A)),1:365,days); 
SM20_AMean	=	SM20_Amean'; 
save 'C:\DATA\condensed\daily\SM20_A_DM.dat'  SM20_AMean   -ASCII

%--- SM20_B, oC ---
SM20_B =  SM20_B; % oC 
[SM20_Bsum,SM20_Bmean,TimeX] = integzBC1(dt(~isnan(SM20_B)),SM20_B(~isnan(SM20_B)),1:365,days); 
SM20_BMean	=	SM20_Bmean'; 
save 'C:\DATA\condensed\daily\SM20_B_DM.dat'  SM20_BMean   -ASCII

%Clean

cleaned_Ch1 = output_2008(:,16);
cleaned_Ch1(cleaned_Ch1==0,1) = NaN;

cleaned_Ch2 = output_2008(:,26);
cleaned_Ch2(cleaned_Ch2==0,1) = NaN;

cleaned_Ch3 = output_2008(:,36);
cleaned_Ch3(cleaned_Ch3==0,1) = NaN;

cleaned_Ch4 = output_2008(:,46);
cleaned_Ch4(cleaned_Ch4==0,1) = NaN;

[mon_sums] = mcm_monsum(cleaned_Ch1, 2008)
[mon_sums] = mcm_monsum(cleaned_Ch2, 2008)
[mon_sums] = mcm_monsum(cleaned_Ch3, 2008)
[mon_sums] = mcm_monsum(cleaned_Ch4, 2008)


%%Plotting master figure here. Includes; PAR, Ta, Ts, SM and efflux%%%

figure(1); 
% hold on;
% subplot (4,1,1);
% title('Daily Values of PAR')
% xlabel('HHOUR')
% ylabel ('PAR (umol cm-2 s-1)');
% hold on;
% plot(PAR_UP, 'r')

subplot (3,1,1);
hold on;
plot(Ta , 'r')
plot(Ts5_A,'b')
plot(Ts5_B,'g')
axis([0 18000 -20 35]);
title('Daily Values of Air and Soil Temperature at 5 cm Depth')
xlabel('HHOUR')
ylabel ('Temperature (oC)');
legend('Ta', 'Ts5_A', 'Ts5_B',1)

subplot (3,1,2);
hold on;
plot (SM20_A, 'r')
plot(SM20_B, 'b')
axis([0 18000 0 0.50]);
title('Daily Averages of Soil Moisture at 20 cm Depth')
xlabel('HHOUR')
ylabel('Soil Moisture (m3 m-3)')
legend ('SM20_A', 'SM20_B',1)

% subplot (4,1,3);
% hold on;
% plot (output_2008(:,16), 'r')
% plot (output_2008(:,26), 'b')
% %plot (output_2008(:,36), 'g')
% plot (output_2008(:,46), 'c')
% title('Half Hourly Measurements of Soil CO2 Efflux')
% xlabel('HHOUR')
% ylabel('Efflux (mol C m-2 s-1)')
% legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

subplot (3,1,3);
hold on;
plot (cleaned_Ch1, 'r')
plot (cleaned_Ch2, 'b')
%plot (cleaned_Ch3, 'g')
plot (cleaned_Ch4, 'c')
title('Half Hourly Measurements of Soil CO2 Efflux')
xlabel('HHOUR')
ylabel('Efflux (umol C m-2 s-1)')
legend('Ch SE','Ch SW', 'Ch NW',1)



