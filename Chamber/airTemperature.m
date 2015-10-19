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

%% Average across all 3 Ta samples:
Ta1 = Ta1';Ta2=Ta2';Ta3=Ta3';Ta4=Ta4';
Ta1_avg = mean(Ta1);
Ta2_avg = mean(Ta2);
Ta3_avg = mean(Ta3);
Ta4_avg = mean(Ta4);

%% Plot average Ta values on a new plot:
figure(1); clf
plot(tv,Ta1_avg,'b-');
hold on;
plot(tv,Ta2_avg,'m-')
plot(tv,Ta3_avg,'g-')
plot(tv,Ta4_avg,'c-')
ylabel('Air Temperature')
xlabel('date')
datetick('x')
legend('Ta 1','Ta 2','Ta 3', 'Ta 4',1)

%% Scatterplot between Ta and Ch2 efflux

figure(2); clf;
plot(Ta1,ch1_avg,'pm');
title('T_{a} vs Ch1 efflux')
ylabel('efflux')
xlabel('Air Temperature')

figure(3); clf;
plot(Ta3,ch3_avg,'pm');
title('T_{a} vs Ch3 efflux')
ylabel('efflux')
xlabel('Air Temperature')

figure(4); clf;
plot(Ta3,ch3_avg,'pm');
title('T_{a} vs Ch3 efflux')
ylabel('efflux')
xlabel('Air Temperature')

figure(5); clf;
plot(Ta4,ch4_avg,'pm');
title('T_{a} vs Ch4 efflux')
ylabel('efflux')
xlabel('Air Temperature')
