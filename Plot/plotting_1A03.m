loadstart = addpath_loadstart;
% clrs = rand(20,3);
clrs = colormap(lines(6));
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP39.mat'],'TP39');
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP74.mat'],'TP74');
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP89.mat'],'TP89');
load([loadstart 'Matlab/Data/Data_Analysis/Uncert/TP02.mat'],'TP02');

years = (2003:1:2008)';
yr_labels = num2str(years);

figure(1);clf; figure(2);clf; figure(3);clf;
figure(4); clf


for i = 1:1:6
figure(1);
h1(i) = plot(cumsum(TP39(i).NEP).*0.0216,'Color',clrs(i,:),'LineWidth',2); hold on;

figure(2);
h2(i) = plot(cumsum(TP39(i).GEP).*0.0216,'Color',clrs(i,:),'LineWidth',2); hold on;

figure(3);
h3(i) = plot(cumsum(TP39(i).R).*0.0216,'Color',clrs(i,:),'LineWidth',2); hold on;

TP39_NEP(i,1) = nansum(TP39(i).NEP).*0.0216;
try
TP74_NEP(i,1) = nansum(TP74(i).NEP).*0.0216;
TP89_NEP(i,1) = nansum(TP89(i).NEP).*0.0216;
TP02_NEP(i,1) = nansum(TP02(i).NEP).*0.0216;
end

% figure(4);
% plot(years(i,1),nansum(TP39(i).NEP).*0.0216,'o-','LineStyle','--','MarkerFaceColor',clrs(i,:),'MarkerSize',10,'Color','k','LineWidth',2); hold on;

end


days = cumsum(jjb_days_in_month(2003).*48)-1487;
MonTicks = [days(1); days(4); days(7); days(10)];

MonLabels = ['Jan-1' ; '     ' ; 'Mar-1'; '     '; 'May-1'; '     '; 'Jul-1';...
            '     ' ;'Sep-1'; '     '; 'Nov-1'; '     '];



figure(1)
set(gca,'FontSize',16)
plot([0 17568],[0 0],'k--','LineWidth',2)
legend(h1,yr_labels,2)
axis([0 17568 -100 300])
xlabel('Month')
ylabel('NEP - g C m^{-2} y^{-1}')
set(gca, 'XTick',days)
set(gca, 'XTickLabel',MonLabels)
set(gca,'YGrid','on')

figure(2)
set(gca,'FontSize',16)
% plot([0 17568],[0 0],'k--','LineWidth',2)
legend(h2,yr_labels,2)
axis([0 17568 0 1700])
xlabel('Month')
ylabel('GEP - g C m^{-2} y^{-1}')
set(gca, 'XTick',days)
set(gca, 'XTickLabel',MonLabels)
set(gca,'YGrid','on')

figure(3)
set(gca,'FontSize',16)
% plot([0 17568],[0 0],'k--','LineWidth',2)
legend(h3,yr_labels,2)
axis([0 17568 0 1700])
xlabel('Month')
ylabel('R - g C m^{-2} y^{-1}')
set(gca, 'XTick',days)
set(gca, 'XTickLabel',MonLabels)
set(gca,'YGrid','on')


figure(4); clf
plot(years,TP39_NEP,'k-o','MarkerFaceColor',clrs(i,:),'Color','k','MarkerSize',10,'LineWidth',2)
set(gca,'FontSize',16)

ylabel('NEP - g C m^{-2} y^{-1}')
axis([2003 2008 0 250])
set(gca,'XTick',(2003:1:2008)')
set(gca,'YGrid','on')

figure(5); clf
ages = [1:1:5; 15:1:19; 30:1:34; 65:1:69];

% for site_ctr = 1:1:4
    for year_ctr = 1:1:5
       h5(1) = plot(ages(1,year_ctr),TP02_NEP(year_ctr),'p','MarkerFaceColor',clrs(4,:),'MarkerSize',10); hold on;
        h5(2) =plot(ages(2,year_ctr),TP89_NEP(year_ctr),'s','MarkerFaceColor',clrs(3,:),'MarkerSize',10); hold on;
        h5(3) =plot(ages(3,year_ctr),TP74_NEP(year_ctr),'v','MarkerFaceColor',clrs(2,:),'MarkerSize',10); hold on;
        h5(4) =plot(ages(4,year_ctr),TP39_NEP(year_ctr),'o','MarkerFaceColor',clrs(1,:),'MarkerSize',10); hold on;
    end

figure(5);
set(gca,'FontSize',16)
xlabel('Forest Age (years)')
ylabel('NEP - g C m^{-2} y^{-1}')
axis([0 85 -200 1000])
plot([0 17568],[0 0],'k--','LineWidth',2)
set(gca,'YGrid','on')
legend(h5,['TP02'; 'TP89'; 'TP74'; 'TP39'],1)
% set(gca,'XTick',(2003:1:2008)')
% set(gca,'YGrid','on')
% 
    
