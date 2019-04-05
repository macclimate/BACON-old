%Script to look at RMSE

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


%load data
chamber_data = dlmread('C:\DATA\condensed\hhour_all_current.csv');

rsquared_Ch1_08 = output_2008(:,14);
rsquared_Ch2_08 = output_2008(:,24);
rsquared_Ch3_08 = output_2008(:,34);
rsquared_Ch4_08 = output_2008(:,44);

rsquared_Ch1_09 = output_2009(:,14);
rsquared_Ch2_09 = output_2009(:,24);
rsquared_Ch3_09 = output_2009(:,34);
rsquared_Ch4_09 = output_2009(:,44);

rsquared_Ch1_all = [rsquared_Ch1_08; rsquared_Ch1_09];
rsquared_Ch2_all = [rsquared_Ch2_08; rsquared_Ch2_09];
rsquared_Ch3_all = [rsquared_Ch3_08; rsquared_Ch3_09];
rsquared_Ch4_all = [rsquared_Ch4_08; rsquared_Ch4_09];

rmse_Ch1_08 = output_2008(:,15);
rmse_Ch2_08 = output_2008(:,25);
rmse_Ch3_08 = output_2008(:,35);
rmse_Ch4_08 = output_2008(:,45);

rmse_Ch1_09 = output_2009(:,15);
rmse_Ch2_09 = output_2009(:,25);
rmse_Ch3_09 = output_2009(:,35);
rmse_Ch4_09 = output_2009(:,45);

rmse_Ch1_all = [rmse_Ch1_08; rmse_Ch1_09];
rmse_Ch2_all = [rmse_Ch2_08; rmse_Ch2_09];
rmse_Ch3_all = [rmse_Ch3_08; rmse_Ch3_09];
rmse_Ch4_all = [rmse_Ch4_08; rmse_Ch4_09];

