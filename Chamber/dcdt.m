% Load dcdt
dcdt1 (:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).dcdt');
dcdt1 (:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).dcdt');
dcdt1 (:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).dcdt');

dcdt2 (:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).dcdt');
dcdt2 (:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).dcdt');
dcdt2 (:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).dcdt');

dcdt3 (:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).dcdt');
dcdt3 (:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).dcdt');
dcdt3 (:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).dcdt');

dcdt4 (:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).dcdt');
dcdt4 (:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).dcdt');
dcdt4 (:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).dcdt');

%% Average across all 3 dcdt samples:
dcdt1 = dcdt1';dcdt2=dcdt2';dcdt3=dcdt3';dcdt4=dcdt4';
dcdt1_avg = mean(dcdt1);
dcdt2_avg = mean(dcdt2);
dcdt3_avg = mean(dcdt3);
dcdt4_avg = mean(dcdt4);

%% Plot average dcdt values on a new plot:
figure(1); clf
plot(tv,dcdt1_avg,'b-');
hold on;
plot(tv,dcdt2_avg,'m-')
plot(tv,dcdt3_avg,'g-')
plot(tv,dcdt4_avg,'c-')
ylabel('dcdt')
xlabel('date')
datetick('x')
legend('dcdt 1','dcdt 2','dcdt 3', 'dcdt 4',1)

%% Scatterplot between dcdt and Ch? efflux

figure(2); clf;
plot(dcdt1,ch1_avg,'pb');
title('dcdt} vs Ch1 efflux')
ylabel('efflux')
xlabel('dcdt')

figure(3); clf;
plot(dcdt2,ch2_avg,'pm');
title('dtdt vs Ch3 efflux')
ylabel('efflux')
xlabel('dcdt')

figure(4); clf;
plot(dcdt3,ch3_avg,'pg');
title('dcdt vs Ch3 efflux')
ylabel('efflux')
xlabel('dcdt')

figure(5); clf;
plot(dcdt4,ch4_avg,'pc');
title('dcdt vs Ch4 efflux')
ylabel('efflux')
xlabel('dcdt')