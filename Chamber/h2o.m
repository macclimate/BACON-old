% Load h2o data
h2o1 (:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).Channel.h2o.avg');
h2o1 (:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).Channel.h2o.avg');
h2o1 (:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).Channel.h2o.avg');

h2o2 (:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).Channel.h2o.avg');
h2o2 (:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).Channel.h2o.avg');
h2o2 (:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).Channel.h2o.avg');

h2o3 (:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).Channel.h2o.avg');
h2o3 (:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).Channel.h2o.avg');
h2o3 (:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).Channel.h2o.avg');

h2o4 (:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).Channel.h2o.avg');
h2o4 (:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).Channel.h2o.avg');
h2o4 (:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).Channel.h2o.avg');

%% Plot average h2o values on a new plot:
figure(1); clf
plot(tv,h2o1,'b-');
hold on;
plot(tv,h2o2,'m-')
plot(tv,h2o3,'g-')
plot(tv,h2o4,'c-')
ylabel('h2o')
xlabel('date')
datetick('x')
legend('h2o 1','h2o 2','h2o 3', 'h2o 4',1)

%%Plot h2o values versus efflux values 

figure(2); clf;
plot(h2o1,ch1_avg,'pm');
title('h2o vs Ch1 efflux')
ylabel('efflux')
xlabel('h2o')

figure(3); clf;
plot(h2o2,ch2_avg,'pm');
title('h2o vs Ch2 efflux')
ylabel('efflux')
xlabel('h2o')

figure(4); clf;
plot(h2o3,ch3_avg,'pm');
title('h2o vs Ch3 efflux')
ylabel('efflux')
xlabel('h2o')

figure(5); clf;
plot(h2o4,ch4_avg,'pm');
title('h2o vs Ch4 efflux')
ylabel('efflux')
xlabel('h2o')
