
% Load efflux from samples 1-3 for chamber 2

ch1(:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).efflux');
ch1(:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).efflux');
ch1(:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).efflux');

ch2(:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).efflux');
ch2(:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).efflux');
ch2(:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).efflux');

ch3(:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).efflux');
ch3(:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).efflux');
ch3(:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).efflux');

ch4(:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).efflux');
ch4(:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).efflux');
ch4(:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).efflux');

% Load Air Temperature
Ta1 (:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).airTemperature');
Ta1 (:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).airTemperature');
Ta1 (:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).airTemperature');

Ta2 (:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).airTemperature');
Ta2 (:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).airTemperature');
Ta2 (:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).airTemperature');

Ta3 (:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).airTemperature');
Ta3 (:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).airTemperature');
Ta3 (:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).airTemperature');

Ta4 (:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).airTemperature');
Ta4 (:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).airTemperature');
Ta4 (:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).airTemperature');

% Plot data for inspection
figure(1); clf;
subplot(2,2,1)
plot(tv,ch1(:,1),'r');
hold on;
plot(tv,ch1(:,2),'b');
plot(tv,ch1(:,3),'g');
title('chamber1')
ylabel('efflux')
datetick('x')


subplot(2,2,2)
plot(tv,ch2(:,1),'r');
hold on;
plot(tv,ch2(:,2),'b');
plot(tv,ch2(:,3),'g');
title('chamber2')
datetick('x')

subplot(2,2,3)
plot(tv,ch3(:,1),'r');
hold on;
plot(tv,ch3(:,2),'b');
plot(tv,ch3(:,3),'g');
title('chamber3')
ylabel('efflux')
xlabel('date')
datetick('x')

subplot(2,2,4)
plot(tv,ch4(:,1),'r');
hold on;
plot(tv,ch4(:,2),'b');
plot(tv,ch4(:,3),'g');
title('chamber4')
xlabel('date')
datetick('x')

%% Average across all 3 efflux samples:
ch1 = ch1';ch2=ch2';ch3=ch3';ch4=ch4';
ch1_avg = mean(ch1);
ch2_avg = mean(ch2);
ch3_avg = mean(ch3);
ch4_avg = mean(ch4);

%% Plot average values on a new plot:
figure(2); clf
plot(tv,ch1_avg,'b-');
hold on;
plot(tv,ch2_avg,'m-')
plot(tv,ch3_avg,'g-')
plot(tv,ch4_avg,'c-')
ylabel('efflux')
xlabel('date')
datetick('x')
legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%% Scatterplot between Ta and Ch2 efflux

figure(3); clf;
plot(Ta,ch2_avg,'pm');
title('T_{a} vs Ch2 efflux')
ylabel('efflux')
xlabel('Air Temperature')

%% Average across all 3 Ta samples:
Ta1 = Ta1';Ta2=Ta2';Ta3=Ta3';Ta4=Ta4';
Ta1_avg = mean(Ta1);
Ta2_avg = mean(Ta2);
Ta3_avg = mean(Ta3);
Ta4_avg = mean(Ta4);

%% Plot average Ta values on a new plot:
figure(4); clf
plot(tv,Ta1_avg,'b-');
hold on;
plot(tv,Ta2_avg,'m-')
plot(tv,Ta3_avg,'g-')
plot(tv,Ta4_avg,'c-')
ylabel('Air Temperature')
xlabel('date')
datetick('x')
legend('Ta 1','Ta 2','Ta 3', 'Ta 4',1)