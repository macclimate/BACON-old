% Load co2
co21 (:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).Channel.co2.avg');
co21 (:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).Channel.co2.avg');
co21 (:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).Channel.co2.avg');

co22 (:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).Channel.co2.avg');
co22 (:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).Channel.co2.avg');
co22 (:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).Channel.co2.avg');

co23 (:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).Channel.co2.avg');
co23 (:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).Channel.co2.avg');
co23 (:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).Channel.co2.avg');

co24 (:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).Channel.co2.avg');
co24 (:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).Channel.co2.avg');
co24 (:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).Channel.co2.avg');

%% Plot average co2 values on a new plot:
figure(1); clf
plot(tv,co21,'b-');
hold on;
plot(tv,co22,'m-')
plot(tv,co23,'g-')
plot(tv,co24,'c-')
ylabel('co2')
xlabel('date')
datetick('x')
legend('co2 1','co2 2','co2 3', 'co2 4',1)

%%Plot co2 values versus efflux values 

figure(2); clf;
plot(co21,ch1_avg,'pm');
title('co2 vs Ch1 efflux')
ylabel('efflux')
xlabel('co2')

figure(3); clf;
plot(co22,ch2_avg,'pm');
title('co2 vs Ch2 efflux')
ylabel('efflux')
xlabel('co2')

figure(4); clf;
plot(co23,ch3_avg,'pm');
title('co2 vs Ch3 efflux')
ylabel('efflux')
xlabel('co2')

figure(5); clf;
plot(co24,ch4_avg,'pm');
title('co2 vs Ch4 efflux')
ylabel('efflux')
xlabel('co2')
