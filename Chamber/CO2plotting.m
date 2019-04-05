% Load efflux from samples 1-3 for chamber 2
co2(1,1) = get_stats_field(HHourAll,'DataHF.co2');
co21(:,2) = get_stats_field(HHourAll,'DataHF.co2');
co21(:,3) = get_stats_field(HHourAll,'DataHF.co2');

ch2(:,1) = get_stats_field(HHourAll,'Chamber(2).Sample(1).efflux');
ch2(:,2) = get_stats_field(HHourAll,'Chamber(2).Sample(2).efflux');
ch2(:,3) = get_stats_field(HHourAll,'Chamber(2).Sample(3).efflux');

ch3(:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).efflux');
ch3(:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).efflux');
ch3(:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).efflux');

ch4(:,1) = get_stats_field(HHourAll,'Chamber(4).Sample(1).efflux');
ch4(:,2) = get_stats_field(HHourAll,'Chamber(4).Sample(2).efflux');
ch4(:,3) = get_stats_field(HHourAll,'Chamber(4).Sample(3).efflux');
