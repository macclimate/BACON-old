clear all;
year = 2007;
[Mon Day] = make_Mon_Day(2007, 30);
daylist = makedaylist(year);
ls = addpath_loadstart;
new_path = [ls 'SiteData/TP39/MET-DATA/hhour/'];
old_path = [ls 'SiteData/TP39/MET-DATA/hhour_pre_2009/'];

old_Fc = [];
new_Fc = [];
T_P = [];
old_ns = [];
new_ns = [];
for i = 1:1:length(daylist)
    new = load([new_path daylist(i,:) '.hMCM1.mat']);
    old = load([old_path daylist(i,:) '.hMcM.mat']);

    for k = 1:1:48
        
    try old_Fc = [old_Fc; old.Stats(k).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc]; catch; old_Fc = [old_Fc; NaN]; end
    try new_Fc = [new_Fc; new.Stats(k).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc]; catch; new_Fc = [new_Fc; NaN]; end
    try T_P = [T_P; [new.Stats(k).MiscVariables.Tair new.Stats(k).MiscVariables.BarometricP]]; catch; T_P = [T_P; [NaN NaN]]; end
    try old_ns = [old_ns; old.Stats(k).MainEddy.MiscVariables.NumOfSamples]; catch; old_ns = [old_ns; NaN]; end
    try new_ns = [new_ns; new.Stats(k).MainEddy.MiscVariables.NumOfSamples]; catch; new_ns = [new_ns; NaN]; end
    
    for j = 1:1:2
        try old_data.day(i).hhour(k).instr(j).Alignment = old.Stats(k).MainEddy.MiscVariables.Instrument(j).Alignment; catch; old_data.day(i).hhour(k).instr(j).Alignment = [];end
        try new_data.day(i).hhour(k).instr(j).Alignment = new.Stats(k).MainEddy.MiscVariables.Instrument(j).Alignment; catch; new_data.day(i).hhour(k).instr(j).Alignment = [];end
    end
    try old_data.day(i).hhour(k).Delays = old.Stats(k).MainEddy.Delays; catch; old_data.day(i).hhour(k).Delays = []; end
    try new_data.day(i).hhour(k).Delays = new.Stats(k).MainEddy.Delays; catch; new_data.day(i).hhour(k).Delays = []; end
    
    end
    clear new old
end

% T and P correction:
met = load([ls 'Matlab/Data/Met/Final_Filled/TP39/TP39_met_filled_2007.mat']);
Tmeas = [met.master.data(9:end,1); NaN.*ones(8,1)];
Pmeas = [met.master.data(9:end,5); NaN.*ones(8,1)];
corr_factor = (Pmeas./T_P(:,2)) .* ((T_P(:,1) + 273)./(Tmeas + 273));
new_Fc = new_Fc.*corr_factor;


figure('Name','2007, old vs new Fc -- T,P corrected');clf;
plot(old_Fc,'b');
hold on;
plot(new_Fc,'g');
set(gca,'XTick',(1:(7*48):length(old_Fc))','XTickLabel',daylist(1:7:length(daylist),:));
% xticklabel_rotate;
axis([1 17520 -35 20])
legend('old','new');


%% Look at specific period:

day_start_str = '070501';
day_end_str = '070515';
MD_start = [str2num(day_start_str(3:4)) str2num(day_start_str(5:6))];
MD_end = [str2num(day_end_str(3:4)) str2num(day_end_str(5:6))];

for i = 1:1:length(daylist)
if strcmp(daylist(i,:),day_start_str) == 1;    daylist_start = i;end
if strcmp(daylist(i,:),day_end_str) == 1;    daylist_end = i;end

end

ind_use = find(Mon >= MD_start(1,1) & Mon <= MD_end(1,1) & Day >= MD_start(1,2) & Day <= MD_end(1,2));

figure('Name','2007- spec period, old vs new Fc -- T,P corrected');clf;
subplot(3,1,1)
plot(old_Fc(ind_use),'b');
hold on;
plot(new_Fc(ind_use),'g');
set(gca,'XTick',(1:48:length(ind_use))','XTickLabel',daylist(daylist_start:1:daylist_end,3:6));
axis([1 length(ind_use) -35 20])
grid on;
legend('old','new');
subplot(3,1,2)
plot(nancumsum(old_Fc(ind_use)).*0.0216,'b');
hold on;
plot(nancumsum(new_Fc(ind_use)).*0.0216,'g');
set(gca,'XTick',(1:48:length(ind_use))','XTickLabel',daylist(daylist_start:1:daylist_end,3:6));
axis([1 length(ind_use) -40 5])
grid on;
legend('old','new');
subplot(3,1,3)
plot(old_ns,'b.');
hold on;
plot(new_ns,'gx');
set(gca,'XTick',(1:48:length(ind_use))','XTickLabel',daylist(daylist_start:1:daylist_end,3:6));
axis([1 length(ind_use) 35600 36000])
grid on;
legend('old','new');

dev = new_Fc(ind_use)./old_Fc(ind_use);

figure('Name','newFc/oldFc');clf;
plot(dev);
set(gca,'XTick',(1:48:length(ind_use))','XTickLabel',daylist(daylist_start:1:daylist_end,3:6));
axis([1 length(ind_use) 0.5 1.5])
