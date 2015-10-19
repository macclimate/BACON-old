% % % to recalculate for more than one day with no plotting
% % % choose dates to process from data
%%FROM SCRIPT 'basic efflux calc'
 'cd C:\DATA';
ACS_calc_and_save(datenum(2009,05,08):datenum(2009,05,12),16,'C:\DATA',1,0);

%ACS_DC_primer_UA.m file to process flux data
'cd C:\DATA';
inputPath = 'C:\DATA\hhour\HHourAll\';  %Change inputpath to desired file
siteID = '*.ACS_Flux_16.mat'
dirInfo = dir([inputPath siteID]);
HHourAll = [];
N = 0;
for i=1:length(dirInfo)
    if dirInfo(i).isdir == 0
        disp(sprintf('Loading file #%d %s%s',i,inputPath,dirInfo(i).name))        
        load(fullfile(inputPath,dirInfo(i).name))
        % extract only periods that had measurements (every 2 hours)
        for j=1:length(HHour)
            if ~isempty(HHour(j).HhourFileName)
                N = N+1;
                try
                    if N == 1 
                        HHourAll = HHour(j);
                    else
                        HHourAll(N) = HHour(j);            
                    end
                catch
                    N = N - 1;
                end
            end
        end
    end
end
% now extract the time vector
tv = zeros(length(HHourAll),1);
for i=1:length(HHourAll)
    % here we are re-creating time vector from the file name.  The new
    % version of acs_calc_and_save does have a proper field TimeVector but
    % the older version didn't and it also output the wrong end time.
    % Solution below works for both the old and the new version
    fileName = HHourAll(i).HhourFileName;
    tv(i) = datenum(2000+str2num(fileName(1:2)),str2num(fileName(3:4)),str2num(fileName(5:6)), 0,str2num(fileName(7:8))*15,0);
end

%%%%%%%%%   STOP   %%%%%%%%%%%
%%%%%%%%%%%% PUT HHOUR DATA INTO 'HHourAll' FOLDER

%%FROM SCRIPT 'save hhour data'
'cd C:\DATA';
inputPath = 'C:\DATA\hhour\HHourAll\';
siteID = '*.ACS_Flux_16.mat'
dirInfo = dir([inputPath siteID]);
HHourAll = [];
N = 0;
ctr = 0;
for i=1:length(dirInfo)
    if dirInfo(i).isdir == 0
        disp(sprintf('Loading file #%d %s%s',i,inputPath,dirInfo(i).name))
        load(fullfile(inputPath,dirInfo(i).name))
        % extract only periods that had measurements (every 2 hours)
        for j=1:length(HHour)
            if ~isempty(HHour(j).HhourFileName)
                N = N+1;
                ctr = ctr + 1;
                try
                    if N == 1
                        HHourAll = HHour(j);
                    else
                        HHourAll(ctr) = HHour(j);
                    end
%                     data2(N,1) = HHour(j).TimeVector;
                    col = 2;
                    for chamber_ctr = 1:1:4
                        for sample_ctr = 1:1:3
                            tmp1(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.avg;
                            tmp2(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.min;
                            tmp3(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.max;
                            tmp4(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.std;
                            tmp5(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).airTemperature;
                            tmp6(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).airPressure;
                            tmp7(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).dcdt;
                            tmp8(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).rsquare;
                            tmp9(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).rmse;
                            tmp10(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).efflux;           
                        end
                        data2(N,1) = HHour(j).TimeVector;
                        data2(N,(((chamber_ctr-1).*10)+2)) = nanmean(tmp1);
                        data2(N,(((chamber_ctr-1).*10)+3)) = nanmean(tmp2);
                        data2(N,(((chamber_ctr-1).*10)+4)) = nanmean(tmp3);
                        data2(N,(((chamber_ctr-1).*10)+5)) = nanmean(tmp4);
                        data2(N,(((chamber_ctr-1).*10)+6)) = nanmean(tmp5);
                        data2(N,(((chamber_ctr-1).*10)+7)) = nanmean(tmp6);
                        data2(N,(((chamber_ctr-1).*10)+8)) = nanmean(tmp7);
                        data2(N,(((chamber_ctr-1).*10)+9)) = nanmean(tmp8);
                        data2(N,(((chamber_ctr-1).*10)+10)) = nanmean(tmp9);
                        data2(N,(((chamber_ctr-1).*10)+11)) = nanmean(tmp10);
                        clear tmp*
                    end
%                     tv(N) = HHour(j).TimeVector;
%                     Data_ch1(N,1:x) = [HHour(j).Chamber(1)]
% 
%                     Data(N).TimeVector = HHour(j).TimeVector;
%                     Data(N).Chamber = HHour(j).Chamber;
                catch
                    N = N - 1;
                end
            end
        end
        clear HHourAll ;
        ctr = 0;
    end
end
% now extract the time vector
% tv = zeros(length(HHourAll),1);
% for i=1:length(HHourAll)
%     % here we are re-creating time vector from the file name.  The new
%     % version of acs_calc_and_save does have a proper field TimeVector but
%     % the older version didn't and it also output the wrong end time.
%     % Solution below works for both the old and the new version
%     fileName = HHourAll(i).HhourFileName;
%     tv(i) = datenum(2000+str2num(fileName(1:2)),str2num(fileName(3:4)),str2num(fileName(5:6)), 0,str2num(fileName(7:8))*15,0);
% end

%% This section changes the timevector to dates, which will be columns 1-5
%% in final data file:
tvs = datevec(data2(:,1));

[rows cols] = size(data2);
data_final(1:rows, 1:cols+4) = NaN;
data_final(:,:) = [tvs(:,1:5) data2(:,2:cols)];
clear data2;

%% Saves the final data file:
filename = input('give file a name, please: ','s');
save_path = ['C:\DATA\condensed\' filename '.csv']
dlmwrite(save_path, data_final, ',')

%%%%%%%%%%%%%%%%%%%%%%%%%  STOP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%condense chamber data and save output
%%FROM SCRIPT 'For-Emily'
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

CO2avg_Ch1_08 = output_2008(:,07);
CO2avg_Ch2_08 = output_2008(:,17);
CO2avg_Ch3_08 = output_2008(:,27);
CO2avg_Ch4_08 = output_2008(:,37);

CO2avg_Ch1_09 = output_2009(:,07);
CO2avg_Ch2_09 = output_2009(:,17);
CO2avg_Ch3_09 = output_2009(:,27);
CO2avg_Ch4_09 = output_2009(:,37);

figure(21); 
hold on;
plot(CO2avg_Ch1_08 , 'r')
plot(CO2avg_Ch2_08 , 'b')
plot(CO2avg_Ch3_08 , 'g')
plot(CO2avg_Ch4_08 , 'c')
plot(CO2avg_Ch1_09 , 'r')
plot(CO2avg_Ch2_09 , 'b')
plot(CO2avg_Ch3_09 , 'g')
plot(CO2avg_Ch4_09 , 'c')
%axis([6144 6336 -1 5]);
title('Soil CO2 Average Concentration')
xlabel('HHOUR')
ylabel ('Soil CO2(umol CO2 m-2 s-1)');
legend('Ch1','Ch2','Ch3','Ch4',1)

%Data 2008 and 2009

Ch1_08 = output_2008(:,16);
Ch2_08 = output_2008(:,26);
Ch3_08 = output_2008(:,36);
Ch4_08 = output_2008(:,46);

Ch1_09 = output_2009(:,16);
Ch2_09 = output_2009(:,26);
Ch3_09 = output_2009(:,36);
Ch4_09 = output_2009(:,46);

all_Ch1 = [Ch1_08; Ch1_09];
all_Ch2 = [Ch2_08; Ch2_09];
all_Ch3 = [Ch3_08; Ch3_09];
all_Ch4 = [Ch4_08; Ch4_09];

figure(18);
hold on;
subplot (4,1,1);
hold on;
plot (all_Ch1, 'r')
title ('Ch1 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch1',1)

subplot (4,1,2);
hold on;
plot (all_Ch2, 'b')
title ('Ch2 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch2',1)

subplot (4,1,3);
hold on;
plot (all_Ch3, 'g')
title ('Ch3 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch3',1)

subplot (4,1,4);
hold on;
plot (all_Ch4, 'c')
title ('Ch4 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch4',1)


%Clean for 2008--excludes zeros
cleaned_Ch1_08 = output_2008(:,16);
cleaned_Ch1_08(cleaned_Ch1_08 == 0,1) = NaN;

cleaned_Ch2_08 = output_2008(:,26);
cleaned_Ch2_08(cleaned_Ch2_08 == 0,1) = NaN;

cleaned_Ch3_08 = output_2008(:,36);
cleaned_Ch3_08(cleaned_Ch3_08 == 0,1) = NaN;

cleaned_Ch4_08 = output_2008(:,46);
cleaned_Ch4_08(cleaned_Ch4_08 == 0,1) = NaN;

%Clean for 2009
cleaned_Ch1_09 = output_2009(:,16);
cleaned_Ch1_09(cleaned_Ch1_09 == 0,1) = NaN;

cleaned_Ch2_09 = output_2009(:,26);
cleaned_Ch2_09(cleaned_Ch2_09 == 0,1) = NaN;

cleaned_Ch3_09 = output_2009(:,36);
cleaned_Ch3_09(cleaned_Ch3_09 == 0,1) = NaN;

cleaned_Ch4_09 = output_2009(:,46);
cleaned_Ch4_09(cleaned_Ch4_09 == 0,1) = NaN;

%Put 2008 and 2009 cleaned data together

cleaned_all_Ch1 = [cleaned_Ch1_08; cleaned_Ch1_09];
cleaned_all_Ch2 = [cleaned_Ch2_08; cleaned_Ch2_09];
cleaned_all_Ch3 = [cleaned_Ch3_08; cleaned_Ch3_09];
cleaned_all_Ch4 = [cleaned_Ch4_08; cleaned_Ch4_09];

%Plot cleaned 2008 and 2009 data together

figure(20);
hold on;
subplot (4,1,1);
hold on;
plot (cleaned_all_Ch1, 'r')
title ('Ch1 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch1',1)

subplot (4,1,2);
hold on;
plot (cleaned_all_Ch2, 'b')
title ('Ch2 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch2',1)

subplot (4,1,3);
hold on;
plot (cleaned_all_Ch3, 'g')
title ('Ch3 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch3',1)

subplot (4,1,4);
hold on;
plot (cleaned_all_Ch4, 'c')
title ('Ch4 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 25000 -1 8]);
legend('Ch4',1)

%Plot all on the same figure 

figure(23); 
hold on;
plot(cleaned_all_Ch1 , 'r')
plot(cleaned_all_Ch2 , 'b')
plot(cleaned_all_Ch3 , 'g')
plot(cleaned_all_Ch4 , 'c')
%axis([6144 6336 -1 5]);
title('Soil CO2 Efflux')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
legend('Ch1','Ch2','Ch3','Ch4',1)

figure(24); 
hold on;
plot(cleaned_Ch1_09 , 'r')
plot(cleaned_Ch2_09 , 'b')
plot(cleaned_Ch3_09 , 'g')
plot(cleaned_Ch4_09 , 'c')
axis([1000 2500 -1 5]);
title('Soil CO2 Efflux')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
legend('Ch1','Ch2','Ch3','Ch4',1)

figure(25);
hold on;
subplot (6,1,1);
hold on;
plot (cleaned_Ch1_08, 'r')
title ('Ch1 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 18000 -0.5 8]);
legend('Ch1',1)

subplot (6,1,2);
hold on;
plot (cleaned_Ch2_08, 'b')
title ('Ch2 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 18000 -0.5 8]);
legend('Ch2',1)

subplot (6,1,3);
hold on;
plot (cleaned_Ch3_08, 'g')
title ('Ch3 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 18000 -0.5 8]);
legend('Ch3',1)

subplot (6,1,4);
hold on;
plot (cleaned_Ch4_08, 'c')
title ('Ch4 August 08 to May 09')
xlabel('HHOUR')
ylabel ('Efflux (umol CO2 m-2 s-1)');
axis([10000 18000 -0.5 8]);
legend('Ch4',1)

subplot (6,1,5);
hold on;
plot (PAR_DOWN, 'm')
title ('PAR DOWN')
xlabel('HHOUR')
ylabel ('PAR DOWN');
axis([10000 18000 -0.5 2500]);
legend('PAR DOWN',1)

subplot (6,1,6);
hold on;
plot (PAR_UP, 'k')
title ('PAR UP')
xlabel('HHOUR')
ylabel ('PAR UP');
axis([10000 18000 -0.5 100]);
legend('PAR UP',1)


% subplot (6,1,5);
% hold on;
% plot (SM20_A, 'b')
% plot (SM5_A, 'k')
% title ('Soil Moisture')
% xlabel('HHOUR')
% ylabel ('Soil Moisture (m3 m-3');
% axis([4400 4500 0 0.35]);
% legend('SM20',1)
% 
% subplot (6,1,6);
% hold on;
% plot (Ts5_A, 'm')
% title ('Soil Temperature')
% xlabel('HHOUR')
% ylabel ('Soil Temperature (oC)');
% axis([4400 4500 -5 10]);
% legend('Ts5',1)

