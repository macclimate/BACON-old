% Load Air Pressure
Pa1 (:,1) = get_stats_field(HHourAll,'Chamber(1).Sample(1).airPressure');
Pa1 (:,2) = get_stats_field(HHourAll,'Chamber(1).Sample(2).airPressure');
Pa1 (:,3) = get_stats_field(HHourAll,'Chamber(1).Sample(3).airPressure');

Pa2 (:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).airPressure');
Pa2 (:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).airPressure');
Pa2 (:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).airPressure');

Pa3 (:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).airPressure');
Pa3 (:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).airPressure');
Pa3 (:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).airPressure');

Pa4 (:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).airPressure');
Pa4 (:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).airPressure');
Pa4 (:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).airPressure');

%% Average across all 3 Pa samples:
Pa1 = Pa1';Pa2=Pa2';Pa3=Pa3';Pa4=Pa4';
Pa1_avg = mean(Pa1);
Pa2_avg = mean(Pa2);
Pa3_avg = mean(Pa3);
Pa4_avg = mean(Pa4);

%% Plot average Pa values on a new plot:
figure(5); clf
plot(tv,Pa1_avg,'b-');
hold on;
plot(tv,Pa2_avg,'m-')
plot(tv,Pa3_avg,'g-')
plot(tv,Pa4_avg,'c-')
ylabel('Air Pressure')
xlabel('date')
datetick('x')
legend('Pa 1','Pa 2','Pa 3', 'Pa 4',1)
