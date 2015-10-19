TPD_2012 = load('/1/fielddata/Matlab/Data/Master_Files/TPD/TPD_data_master_2012.mat'); % loads as 'TPD_2012.master'
NEE = TPD_2012.master.data(:,7);
PAR = TPD_2012.master.data(:,95);
Ts5 = TPD_2012.master.data(:,101);
Ta = TPD_2012.master.data(:,93);
RH = TPD_2012.master.data(:,94);
VWC = TPD_2012.master.data(:,106);


% Calculate VPD (need function VPD_calc -- in /genfuns):
[VPD] = VPD_calc(RH, Ta);

ind_night = find(PAR<30 & ~isnan(NEE));

f2 = figure(2);clf;
%%% Plot Ts5 vs NEE at night (RE)
plot(Ts5(ind_night),NEE(ind_night),'kv');
xlabel('Ts'); ylabel('NEE');
title('Respiration Against Soil Temp')

print(f2,'-dpng','/1/fielddata/Matlab/Figs/Distributed/Ananta/RevsTs');

%%%