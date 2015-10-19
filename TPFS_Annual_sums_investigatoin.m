load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master.mat');
TP74 = load('/1/fielddata/Matlab/Data/Master_Files/TP74/TP74_data_master.mat');

clrs = colormap(jet(12));

%NEP
figure(1);clf;
for i = 2003:1:2013
    ind = find(master.data(:,1)==i);
    plot(cumsum(master.data(ind,159))*-0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');

%%% RE
figure(2);clf;
for i = 2003:1:2013
    ind = find(master.data(:,1)==i);
    plot(cumsum(master.data(ind,158))*0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');

%%% GEP
figure(3);clf;
for i = 2003:1:2013
    ind = find(master.data(:,1)==i);
    plot(cumsum(master.data(ind,157))*0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');


figure(4);clf;
for i = 2003:1:2013
    ind = find(master.data(:,1)==i);
    plot(sum(master.data(ind,158))*0.0216,sum(master.data(ind,157))*0.0216,'o','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
axis([1000 1600 1000 1600])
legend(num2str((2003:1:2013)'),'Location','NorthWest');


figure(5);clf
ind = find(master.data(:,1)==2011);
%plot(master.data(ind,

figure(6);clf;
plot(master.data(:,106)); hold on;
plot(master.data(:,45),'r');


%% TP74:
%NEP
figure(10);clf;
for i = 2003:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,119))*-0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');

%%% RE
figure(11);clf;
for i = 2003:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,118))*0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');

%%% GEP
figure(12);clf;
for i = 2003:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,117))*0.0216,'-','Color',clrs(i-2002,:),'LineWidth',2);
    hold on;
end
legend(num2str((2003:1:2013)'),'Location','NorthWest');

%%% PAR
figure(13);clf;
clrs2 = colormap(lines(5));
for i = 2009:1:2013
    ind = find(master.data(:,1)==i);
    plot(cumsum(master.data(ind,106)),'-','Color',clrs2(i-2008,:),'LineWidth',2);
    hold on;
end
legend(num2str((2009:1:2013)'),'Location','NorthWest');
title('PAR @ Tp39');

%%% PAR @ TP74
figure(7);clf;
for i = 2009:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,82)),'-','Color',clrs2(i-2008,:),'LineWidth',2);
    hold on;
end
legend(num2str((2009:1:2013)'),'Location','NorthWest');
title('PAR @ Tp74');

%% Precip
figure(8);clf;
for i = 2009:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,97)),'-','Color',clrs2(i-2008,:),'LineWidth',2);
    hold on;
end
legend(num2str((2009:1:2013)'),'Location','NorthWest');
title('PPT');

%%% Ts5
figure(20);clf;
for i = 2009:1:2013
    ind = find(master.data(:,1)==i);
    plot(cumsum(master.data(ind,112)),'-','Color',clrs2(i-2008,:),'LineWidth',2);
    hold on;
end
legend(num2str((2009:1:2013)'),'Location','NorthWest');
title('Ts5');

%%% Ts5
figure(21);clf;
for i = 2019:1:2013
    ind = find(TP74.master.data(:,1)==i);
    plot(cumsum(TP74.master.data(ind,88)),'-','Color',clrs2(i-2008,:),'LineWidth',2);
    hold on;
end
legend(num2str((2009:1:2013)'),'Location','NorthWest');
title('Ts5 @ TP74');

figure(99);clf;
ind = find(master.data(:,51) < 99);
plot(master.data(ind,51)-master.data(ind,52));hold on;

figure(98);clf;
plot(master.data(ind,51),master.data(ind,52),'k.');hold on;

figure(97);clf;
ind = find(master.data(:,51) < 99);
plot(master.data(ind,51)-TP74.master.data(ind,41));hold on;

