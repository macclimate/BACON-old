clear all
close all

color_list = colormap(Lines(10));
yrlist = ['2003';'2004';'2005';'2006';'2007'];



figure(1)
clf;

if ispc 
    dataloc = 'C:/HOME/MATLAB/Data/';
    fig_path = 'C:\HOME\MATLAB\Data\CCP Pres\CCP_Figs\';
else
    dataloc = '/home/jayb/MATLAB/Data/';
    fig_path = '/home/jayb/Desktop/CCP_Figs/';
end


for cut = 4:1:6

cutlist = ['cut_A'; 'cut_B'; 'cut_C'; 'M2cut'; 'M3cut'; 'M4cut'; 'cut_D'; 'cut_E'];
if isempty(cut)
    cutstr = [];
else
    cutstr = cutlist(cut,:);
end


if isempty(cut)
else
    cuts(:,cut-3) = load([dataloc 'Data_Analysis/Model_Comparison/' cutstr '.dat']);
    switch cut
        case 4
            cuts(cuts(:,cut-3)==1,cut-3) = 0.98;
        case 5
            cuts(cuts(:,cut-3)==1,cut-3) = 1;
         case 6
            cuts(cuts(:,cut-3)==1,cut-3) = 1.02;  
    end
end



figure(1)

if cut == 5
    plotcol = cut+1;
else
    plotcol = cut-3;
end
plot(1:1:87840,cuts(:,cut-3),'s','MarkerFaceColor',color_list(plotcol,:),'MarkerEdgeColor',color_list(plotcol,:),'MarkerSize',2);hold on;
end

axis([0 87480 0.9 1.1])
XTicks = (0:4397:87840)';
XTickLabels = ['Jan';'   '; 'Jul';'   '; ...
               'Jan';'   ';'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   ';'Jul';'   '];
                
set(gca,'XTick',XTicks,'YTick',[])
set(gca,'XTickLabel',XTickLabels,'FontSize',18,'TickDir','out')
for mult = 1:1:5
     txt = yrlist(mult,:);
line([17568.*mult 17568.*mult],[1.1 0.9], 'LineStyle','--','Color','k','LineWidth',4)
text(4000+17568*(mult-1),1.01,txt,'FontSize',20,'Color','k')
end
grid on;
legend('TP74','TP89','TP02',3);
print('-dbmp',[fig_path 'OPEC_coverage'])
print('-depsc',[fig_path 'OPEC_coverage'])
% print('-dmeta',[fig_path 'OPEC_coverage'])

%% Met 2
figure(2);clf
plot(cuts(:,1),'-','Color',color_list(1,:));hold on;
axis([0 87480 0.9 1.02])
XTicks = (0:4397:87840)';
XTickLabels = ['Jan';'   '; 'Jul';'   '; ...
               'Jan';'   ';'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   ';'Jul';'   '];
                
set(gca,'XTick',XTicks)
set(gca,'YTick',[]);
set(gca,'XTickLabel',XTickLabels,'FontSize',18,'TickDir','out')

for mult = 1:1:5
    txt = yrlist(mult,:);
line([17568.*mult 17568.*mult],[1.1 0.9], 'LineStyle','--','Color','k','LineWidth',4)
text(3000+17568*(mult-1),1.01,txt,'FontSize',20,'Color','k')
end
print('-dbmp',[fig_path 'M2_coverage'])
print('-depsc',[fig_path 'M2_coverage'])
% print('-dmeta',[fig_path 'M2_coverage'])

%%
figure(3);clf
plot(cuts(:,2),'-','Color',color_list(2,:),'LineWidth',4);hold on;
axis([0 87480 0.9 1.02])
XTicks = (0:4397:87840)';
XTickLabels = ['Jan';'   '; 'Jul';'   '; ...
               'Jan';'   ';'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   ';'Jul';'   '];
                
set(gca,'XTick',XTicks,'YTick',[])
set(gca,'XTickLabel',XTickLabels,'FontSize',18,'TickDir','out')
yrlist = ['2003';'2004';'2005';'2006';'2007'];
for mult = 1:1:5
    txt = yrlist(mult,:);
line([17568.*mult 17568.*mult],[1.1 0.9], 'LineStyle','--','Color','k','LineWidth',4)
text(3000+17568*(mult-1),1.01,txt,'FontSize',20,'Color','k')
end
print('-dbmp',[fig_path 'M3_coverage'])
print('-depsc',[fig_path 'M3_coverage'])
% print('-dmeta',[fig_path 'M3_coverage'])

%%
figure(4);clf
plot(cuts(:,3),'-','Color',color_list(3,:));hold on;
axis([0 87480 0.9 1.02])
XTicks = (0:4397:87840)';
XTickLabels = ['Jan';'   '; 'Jul';'   '; ...
               'Jan';'   ';'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   ';'Jul';'   '];
                
set(gca,'XTick',XTicks,'YTick',[])
set(gca,'XTickLabel',XTickLabels,'FontSize',18,'TickDir','out')
yrlist = ['2003';'2004';'2005';'2006';'2007'];
for mult = 1:1:5
    txt = yrlist(mult,:);
line([17568.*mult 17568.*mult],[1.1 0.9], 'LineStyle','--','Color','k','LineWidth',4)
text(3000+17568*(mult-1),1.01,txt,'FontSize',20,'Color','k')
end
print('-dbmp',[fig_path 'M4_coverage'])
print('-depsc',[fig_path 'M4_coverage'])
% print('-dmeta',[fig_path 'M4_coverage'])

%% Calculate Gap % for each site, each year
len_yr = [365;366;365;365;365];
for i = 1:1:3
ctr = 1;
for j = 1:17568:70273
    ok = find(cuts(j:j+17567,i)==1);
    cover(i,ctr) = length(ok)./(len_yr(ctr).*48);
    clear ok;
    ctr = ctr+1;
end

cover(i,6) = mean(cover(i,1:5));
end

% st = 1;
% en = 17568;
% for k = 1:1:5
% dt(st:en,1) = (1+1/48:1/48:1 + 17568/48)';
% st = st+17568;
% en = en+ 17568;
% end
% plot((dt/100000)+1,'k')