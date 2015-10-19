for i = 2005:1:2008
    load(['/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Calculated/TP39_CPEC_calculated_' num2str(i) '.mat'])
    eval(['Fc_new_' num2str(i) ' = master.data(:,end);'])
end

% Fc_new_2005 = load('/1/fielddata/SiteData/TP39/MET-DATA/annual/TP39_2005.Fc');
% Fc_new_2006 = load('/1/fielddata/SiteData/TP39/MET-DATA/annual/TP39_2006.Fc');
% Fc_new_2007 = load('/1/fielddata/SiteData/TP39/MET-DATA/annual/TP39_2007.Fc');
% Fc_new_2008 = load('/1/fielddata/SiteData/TP39/MET-DATA/annual/TP39_2008.Fc');
%

Fc_old_2005 = load('/media/Deskie/Fc05.dat');
Fc_old_2006 = load('/media/Deskie/Fc06.dat');
Fc_old_2007 = load('/media/Deskie/Fc07.dat');
Fc_old_2008 = load('/media/Deskie/Fc08.dat');

figure('Name', '2005');clf
plot(Fc_new_2005,'b')
hold on;
plot(Fc_old_2005,'r')
axis([1 17568 -35 20])
legend('new', 'old');
title('NEE');

figure('Name', '2006');clf
plot(Fc_new_2006,'b')
hold on;
plot(Fc_old_2006,'r')
axis([1 17568 -35 20])
legend('new', 'old');

figure('Name', '2007');clf
plot(Fc_new_2007,'b')
hold on;
plot(Fc_old_2007,'r')
axis([1 17568 -35 20])
legend('new', 'old');

figure('Name', '2008');clf
plot(Fc_new_2008,'b')
hold on;
plot(Fc_old_2008,'r')
axis([1 17568 -35 20])
legend('new', 'old');

%% Part 2 - Compare NEEs and storage calculations -- what's different?
clear all;
close all;
clrs = colormap(lines(10));
ls = addpath_loadstart;
old_path = [ls 'Matlab/Data/CCP/Final_dat/'];
NEE = [];
NEEfilled = [];
dcdt = [];
Year = [];
Fc = [];
for yr = 2003:1:2007
    tmp = load([old_path 'TP39_final_' num2str(yr) '.dat']);
    NEE = [NEE; tmp(:,7)];
    NEEfilled = [NEEfilled; tmp(:,10)];
    dcdt = [dcdt; tmp(:,15)];
    Year = [Year; tmp(:,1)];
    Fc = [Fc; tmp(:,11)];
end
NEE = NEE.*-1; % was actually NEP;

load([ls 'Matlab/Data/Master_Files/TP39/TP39_AA_analysis_data.mat']);
data = trim_data_files(data,2003,2007);
tmp2 = [data.NEE(8:end); NaN.*ones(7,1)];
data.NEE = tmp2;
data.Fc = [data.FC(8:end); NaN.*ones(7,1)];

f1 = figure(1);clf;
plot(NEE);
hold on;
plot(data.NEE,'g')
legend('old','new');
saveas(f1,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig1.fig']);

f2 = figure(2);clf;
plot(NEE,data.NEE,'k.');hold on;
plot([-30 20],[-30 20],'y--','LineWidth',3)
xlabel('old')
ylabel('new')
axis([-30 30 -30 30]); grid on;
ind = find(~isnan(NEE.*data.NEE));
p = polyfit(NEE(ind),data.NEE(ind),1);
saveas(f2,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig2.fig']);

f3 = figure(3);clf
for yr = 2003:1:2007
    subplot(2,3,yr-2002);
    plot(nancumsum(NEE(Year == yr)).*0.0216,'--','Color',[0 0 1],'LineWidth',2); hold on;
    plot(nancumsum(data.NEE(data.Year == yr)).*0.0216,'-','Color',[0 1 0]);
    title(num2str(yr));
end
legend('old','new');
saveas(f3,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig3.fig']);

f4 = figure(4);clf;
subplot(311);
ind1 = find(NEE > 5 & data.NEE > 5);
plot(cumsum(NEE(ind1)).*0.0216,'b-');hold on;
plot(cumsum(data.NEE(ind1)).*0.0216,'g-');
title('NEE > 5')
subplot(312);
ind0 = find(abs(NEE) < 5 & abs(data.NEE) < 5);
plot(cumsum(NEE(ind0)).*0.0216,'b-');hold on;
plot(cumsum(data.NEE(ind0)).*0.0216,'g-');
title('|NEE| < 5')
subplot(313);
ind2 = find(NEE < -5 & data.NEE < -5);
plot(cumsum(NEE(ind2)).*0.0216,'b-');hold on;
plot(cumsum(data.NEE(ind2)).*0.0216,'g-');
title('NEE < -5')
saveas(f4,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig4.fig']);

f5 = figure(5);clf;
plot(Fc); hold on;
plot(data.Fc,'g');
legend('old','new');
title('Fc');
saveas(f5,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig5.fig']);

f6 = figure(6);clf
for yr = 2003:1:2007
    subplot(2,3,yr-2002);
    plot(nancumsum(Fc(Year == yr)).*0.0216,'--','Color',[0 0 1],'LineWidth',2); hold on;
    plot(nancumsum(data.Fc(data.Year == yr)).*0.0216,'-','Color',[0 1 0]);
    title(num2str(yr));
end
legend('old','new');
saveas(f6,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig6.fig']);

%% Comparing two differently processed days for 2007:
new = load([ls 'SiteData/TP39/MET-DATA/hhour/070508.hMCM1.mat']);
% spans = [-50 50]; %MaxAutoSampleReduction = 10;
test1 = load([ls 'SiteData/TP39/MET-DATA/test1_070508.hMCM1.mat']);
% spans = [-100 100]; %MaxAutoSampleReduction = 15;
orig = load([ls 'SiteData/TP39/MET-DATA/orig_070508.hMCM1.mat']);
% spans = [-300 300]; %MaxAutoSampleReduction = 30;
old = load([ls 'SiteData/TP39/MET-DATA/hhour_pre_2009/070508.hMcM.mat']);

for i = 1:1:48
    orig_Fc(i,1) = orig.Stats(i).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc;
    new_Fc(i,1) = new.Stats(i).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc;
    test1_Fc(i,1) = test1.Stats(i).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc;
    old_Fc(i,1) = old.Stats(i).MainEddy.Three_Rotations.LinDtr.Fluxes.Fc;
    new_TP(i,1:2) = [new.Stats(i).MiscVariables.Tair new.Stats(i).MiscVariables.BarometricP];
    
    orig_ns(i,1) = orig.Stats(i).MainEddy.MiscVariables.NumOfSamples;
    new_ns(i,1) = new.Stats(i).MainEddy.MiscVariables.NumOfSamples;
    test1_ns(i,1) = test1.Stats(i).MainEddy.MiscVariables.NumOfSamples;
    old_ns(i,1) = old.Stats(i).MainEddy.MiscVariables.NumOfSamples;
    
end
% load met data for this day:
met = load([ls 'Matlab/Data/Met/Final_Filled/TP39/TP39_met_filled_2007.mat']);
[Mon Day] = make_Mon_Day(2007, 30);
right_col = find(Mon == 5 & Day == 8);
Tmeas = met.master.data(right_col,1);
Pmeas = met.master.data(right_col,5);
corr_factor = (Pmeas./new_TP(:,2)) .* ((new_TP(:,1) + 273)./(Tmeas + 273));
new_Fc = new_Fc.*corr_factor;

f7 = figure(7);clf;
subplot(311);
plot(orig_Fc);
hold on;
plot(test1_Fc,'r');
plot(new_Fc,'g');
plot(old_Fc,'k');
ylabel('Fc (\mumol C m^{-2} s^{-1})');
subplot(312);
plot(cumsum(orig_Fc).*0.0216,'b'); hold on;
plot(cumsum(test1_Fc).*0.0216,'r');
plot(cumsum(new_Fc).*0.0216,'g');
plot(cumsum(old_Fc).*0.0216,'k');

ylabel('Cumulative Fc (g C)');
legend({'spans = [-300 300], MaxAutoSampleReduction = 30';...
    'spans = [-100 100], MaxAutoSampleReduction = 15';...
    'spans = [-100 100], MaxAutoSampleReduction = 3'; 'old'})
subplot(313);
plot(orig_ns,'b.'); hold on;
plot(test1_ns,'r.');
plot(new_ns,'g.');
plot(old_ns,'k.');
ylabel('number of samples');
saveas(f7,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig7.fig']);

%% Extract the number of points used in old and new files:
day_list = makedaylist(2006);

numsamples_old = [];
numsamples_new = [];
for k = 1:1:length(day_list)
    tmp_old = load(['/1/fielddata/SiteData/TP39/MET-DATA/hhour_pre_2009/' day_list(k,:) '.hMcM.mat']);
    tmp_new = load(['/1/fielddata/SiteData/TP39/MET-DATA/hhour/' day_list(k,:) '.hMCM1.mat']);
    
    for j = 1:1:48
        
        try
            numsamples_old = [numsamples_old; tmp_old.Stats(j).MainEddy.MiscVariables.NumOfSamples]
        catch
            numsamples_old = [numsamples_old; NaN];
        end
        
        try
            numsamples_new = [numsamples_new; tmp_new.Stats(j).MainEddy.MiscVariables.NumOfSamples];
        catch
            numsamples_new = [numsamples_new; NaN];
        end
        
    end
    
    clear tmp_*
end

f8 = figure(8);clf;
subplot(211)
plot(numsamples_old,'b.');hold on;
plot(numsamples_new,'g.');
legend('old','new');
axis([0 17568 35700 36000])
ylabel('num samples');
subplot(212)
plot(numsamples_old-numsamples_new,'b.');hold on;
ylabel('N(old) - N(new)');
saveas(f8,[ls 'Matlab/Data/Distributed/Altaf_20100903/fig8.fig']);

save([ls 'Matlab/Data/Distributed/Altaf_20100903/ns_new.dat'],'numsamples_new','-ASCII');
save([ls 'Matlab/Data/Distributed/Altaf_20100903/ns_old.dat'],'numsamples_old','-ASCII');

%% Extract Alignment and Delays data:
ls = addpath_loadstart;
day_list = makedaylist(2006);

old = struct;
new = struct;
ctr = 1;
for k = 1:1:length(day_list)
    tmp_old = load(['/1/fielddata/SiteData/TP39/MET-DATA/hhour_pre_2009/' day_list(k,:) '.hMcM.mat']);
    tmp_new = load(['/1/fielddata/SiteData/TP39/MET-DATA/hhour/' day_list(k,:) '.hMCM1.mat']);
    
    for j = 1:1:48
        
        for i = 1:1:2
            try
                old(ctr,i).Alignment = tmp_old.Stats(j).MainEddy.MiscVariables.Instrument(i).Alignment;
            catch
                old(ctr,i).Alignment = [];
            end
            try
                new(ctr,i).Alignment = tmp_new.Stats(j).MainEddy.MiscVariables.Instrument(i).Alignment;
            catch
                new(ctr,i).Alignment = [];
            end
        end
        try
            old(ctr,1).Delays = tmp_old.Stats(j).MainEddy.Delays;
        catch
            old(ctr,1).Delays = [];
        end
        try
            new(ctr,1).Delays = tmp_new.Stats(j).MainEddy.Delays;
        catch
            new(ctr,1).Delays = [];
        end
        ctr = ctr+1;
    end
    
    clear tmp_*
end

save([ls 'Matlab/Data/Distributed/Altaf_20100903/new_align_delays.mat'],'new');
save([ls 'Matlab/Data/Distributed/Altaf_20100903/old_align_delays.mat'],'old');
