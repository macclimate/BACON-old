% Plot GEP, RE and NEP Month;y mean values 
% Altaf Arain, 20 October 2008


clc; close all; clear all

m03 = [1 2 3 4 5 6 7 8 9 10 11 12];
m04 = [1 2 3 4 5 6 7 8 9 10 11 12];
m05 = [1 2 3 4 5 6 7 8 9 10 11 12];
m06 = [1 2 3 4 5 6 7 8 9 10 11 12];
m07 = [1 2 3 4 5 6 7 8 9 10 11 12];

month = [m03 m04 m05 m06 m07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_GEP_2007_model4_monsum.dat
GEP39m_03 = TP39_GEP_2003_model4_monsum; 
GEP39m_04 = TP39_GEP_2004_model4_monsum; 
GEP39m_05 = TP39_GEP_2005_model4_monsum; 
GEP39m_06 = TP39_GEP_2006_model4_monsum; 
GEP39m_07 = TP39_GEP_2007_model4_monsum; 
GEP39m = [GEP39m_03 GEP39m_04 GEP39m_05 GEP39m_06 GEP39m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_GEP_2007_model3_monsum.dat
GEP74m_03 = TP74_GEP_2003_model3_monsum; 
GEP74m_04 = TP74_GEP_2004_model3_monsum; 
GEP74m_05 = TP74_GEP_2005_model3_monsum; 
GEP74m_06 = TP74_GEP_2006_model3_monsum; 
GEP74m_07 = TP74_GEP_2007_model3_monsum; 
GEP74m = [GEP74m_03 GEP74m_04 GEP74m_05 GEP74m_06 GEP74m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_GEP_2007_model3_monsum.dat
GEP89m_03 = TP89_GEP_2003_model3_monsum; 
GEP89m_04 = TP89_GEP_2004_model3_monsum; 
GEP89m_05 = TP89_GEP_2005_model3_monsum; 
GEP89m_06 = TP89_GEP_2006_model3_monsum; 
GEP89m_07 = TP89_GEP_2007_model3_monsum; 
GEP89m = [GEP89m_03 GEP89m_04 GEP89m_05 GEP89m_06 GEP89m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_GEP_2007_model3_monsum.dat
GEP02m_03 = TP02_GEP_2003_model3_monsum; 
GEP02m_04 = TP02_GEP_2004_model3_monsum; 
GEP02m_05 = TP02_GEP_2005_model3_monsum; 
GEP02m_06 = TP02_GEP_2006_model3_monsum; 
GEP02m_07 = TP02_GEP_2007_model3_monsum; 
GEP02m = [GEP02m_03 GEP02m_04 GEP02m_05 GEP02m_06 GEP02m_07];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_R_2007_model4_monsum.dat
RE39m_03 = TP39_R_2003_model4_monsum; 
RE39m_04 = TP39_R_2004_model4_monsum; 
RE39m_05 = TP39_R_2005_model4_monsum; 
RE39m_06 = TP39_R_2006_model4_monsum; 
RE39m_07 = TP39_R_2007_model4_monsum; 
RE39m = [RE39m_03 RE39m_04 RE39m_05 RE39m_06 RE39m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_R_2007_model3_monsum.dat
RE74m_03 = TP74_R_2003_model3_monsum; 
RE74m_04 = TP74_R_2004_model3_monsum; 
RE74m_05 = TP74_R_2005_model3_monsum; 
RE74m_06 = TP74_R_2006_model3_monsum; 
RE74m_07 = TP74_R_2007_model3_monsum; 
RE74m = [RE74m_03 RE74m_04 RE74m_05 RE74m_06 RE74m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_R_2007_model3_monsum.dat
RE89m_03 = TP89_R_2003_model3_monsum; 
RE89m_04 = TP89_R_2004_model3_monsum; 
RE89m_05 = TP89_R_2005_model3_monsum; 
RE89m_06 = TP89_R_2006_model3_monsum; 
RE89m_07 = TP89_R_2007_model3_monsum; 
RE89m = [RE89m_03 RE89m_04 RE89m_05 RE89m_06 RE89m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_R_2007_model3_monsum.dat
RE02m_03 = TP02_R_2003_model3_monsum; 
RE02m_04 = TP02_R_2004_model3_monsum; 
RE02m_05 = TP02_R_2005_model3_monsum; 
RE02m_06 = TP02_R_2006_model3_monsum; 
RE02m_07 = TP02_R_2007_model3_monsum; 
RE02m = [RE02m_03 RE02m_04 RE02m_05 RE02m_06 RE02m_07];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2003_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2004_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2005_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2006_model4_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP39_NEP_2007_model4_monsum.dat
NEP39m_03 = TP39_NEP_2003_model4_monsum; 
NEP39m_04 = TP39_NEP_2004_model4_monsum; 
NEP39m_05 = TP39_NEP_2005_model4_monsum; 
NEP39m_06 = TP39_NEP_2006_model4_monsum; 
NEP39m_07 = TP39_NEP_2007_model4_monsum; 
NEP39m = [NEP39m_03 NEP39m_04 NEP39m_05 NEP39m_06 NEP39m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP74_NEP_2007_model3_monsum.dat
NEP74m_03 = TP74_NEP_2003_model3_monsum; 
NEP74m_04 = TP74_NEP_2004_model3_monsum; 
NEP74m_05 = TP74_NEP_2005_model3_monsum; 
NEP74m_06 = TP74_NEP_2006_model3_monsum; 
NEP74m_07 = TP74_NEP_2007_model3_monsum; 
NEP74m = [NEP74m_03 NEP74m_04 NEP74m_05 NEP74m_06 NEP74m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP89_NEP_2007_model3_monsum.dat
NEP89m_03 = TP89_NEP_2003_model3_monsum; 
NEP89m_04 = TP89_NEP_2004_model3_monsum; 
NEP89m_05 = TP89_NEP_2005_model3_monsum; 
NEP89m_06 = TP89_NEP_2006_model3_monsum; 
NEP89m_07 = TP89_NEP_2007_model3_monsum; 
NEP89m = [NEP89m_03 NEP89m_04 NEP89m_05 NEP89m_06 NEP89m_07];

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2003_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2004_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2005_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2006_model3_monsum.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Daily_Monthly\TP02_NEP_2007_model3_monsum.dat
NEP02m_03 = TP02_NEP_2003_model3_monsum; 
NEP02m_04 = TP02_NEP_2004_model3_monsum; 
NEP02m_05 = TP02_NEP_2005_model3_monsum; 
NEP02m_06 = TP02_NEP_2006_model3_monsum; 
NEP02m_07 = TP02_NEP_2007_model3_monsum; 
NEP02m = [NEP02m_03 NEP02m_04 NEP02m_05 NEP02m_06 NEP02m_07];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GEP39mmean = mean(GEP39m,2); 
RE39mmean = mean(RE39m,2); 
NEP39mmean = mean(NEP39m,2); 

GEP74mmean = mean(GEP74m,2); 
RE74mmean = mean(RE74m,2); 
NEP74mmean = mean(NEP74m,2); 

GEP89mmean = mean(GEP89m,2); 
RE89mmean = mean(RE89m,2); 
NEP89mmean = mean(NEP89m,2); 

GEP02mmean = mean(GEP02m,2); 
RE02mmean = mean(RE02m,2); 
NEP02mmean = mean(NEP02m,2); 

stdGEP39mmean = std(GEP39m,0,2); 
stdRE39mmean  = std(RE39m,0,2); 
stdNEP39mmean = std(NEP39m,0,2); 

stdGEP74mmean = std(GEP74m,0,2); 
stdRE74mmean  = std(RE74m,0,2); 
stdNEP74mmean = std(NEP74m,0,2); 

stdGEP89mmean = std(GEP89m,0,2); 
stdRE89mmean  = std(RE89m,0,2); 
stdNEP89mmean = std(NEP89m,0,2); 

stdGEP02mmean = std(GEP02m,0,2); 
stdRE02mmean  = std(RE02m,0,2); 
stdNEP02mmean = std(NEP02m,0,2); 

GEPmmean = [GEP39mmean GEP74mmean GEP89mmean GEP02mmean];
REmmean  = [RE39mmean  RE74mmean  RE89mmean  RE02mmean];
NEPmmean = [NEP39mmean NEP74mmean NEP89mmean NEP02mmean];

stdGEPmmean = [stdGEP39mmean stdGEP74mmean stdGEP89mmean stdGEP02mmean];
stdREmmean  = [stdRE39mmean  stdRE74mmean  stdRE89mmean  stdRE02mmean];
stdNEPmmean = [stdNEP39mmean stdNEP74mmean stdNEP89mmean stdNEP02mmean];


m = [1:12];
zero(m) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cumulative GEP and RE
figure(gcf)
figure('unit','inches','PaperOrientation','Landscape','PaperPosition',[.1 0.1 9. 7.0],...
'position',[0.1    0.1    9.0    7.0]);

axes('Position',[0.10 0.60 0.35 0.35])
hold on

plot(m03,GEP39m_03,'k-','LineWidth',1.0) 
plot(m04,GEP39m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,GEP39m_05,'k-','LineWidth',2) 
plot(m06,GEP39m_06,'k--','LineWidth',2.0)  
plot(m07,GEP39m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m03,-RE39m_03,'k-','LineWidth',1.0) 
plot(m04,-RE39m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,-RE39m_05,'k-','LineWidth',2) 
plot(m06,-RE39m_06,'k--','LineWidth',2.0)  
plot(m07,-RE39m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m, zero,'k:','LineWidth',1)

set(gca,'box','on','xlim',[1 12],'FontSize',12);
set(gca,'box','on','ylim',[-350 550],'FontSize',12);
set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12]);
set(gca,'YTick',[-350,-300,-250,-200,-150,-100,-50,0,50,100,150,200,250,300,350,400,450,500,550]);
set(gca,'YTickLabel',['|-300||-200||-100||0||100||200||300||400||500|']);
ylabel('GEP & RE (g C m^{-2} month^{-1})','FontSize',12)
text(1.5,500,'(a)','FontSize',12)
text(2.5,200,'GEP','FontSize',12)
text(2.5,-200,'RE','FontSize',12)

%aa = legend('2003','2004','2005','2006','2007','Location','Best');
%set(aa,'Vis','on');



axes('Position',[0.55 0.60 0.35 0.35])
hold on
plot(m03,GEP02m_03,'k-','LineWidth',1.0) 
plot(m04,GEP02m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,GEP02m_05,'k-','LineWidth',2) 
plot(m06,GEP02m_06,'k--','LineWidth',2.0)  
plot(m07,GEP02m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m03,-RE02m_03,'k-','LineWidth',1.0) 
plot(m04,-RE02m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,-RE02m_05,'k-','LineWidth',2) 
plot(m06,-RE02m_06,'k--','LineWidth',2.0)  
plot(m07,-RE02m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m, zero,'k:','LineWidth',1)

set(gca,'box','on','xlim',[1 12],'FontSize',12);
set(gca,'box','on','ylim',[-350 550],'FontSize',12);
set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12]);
set(gca,'YTick',[-350,-300,-250,-200,-150,-100,-50,0,50,100,150,200,250,300,350,400,450,500,550]);
set(gca,'YTickLabel',['|-300||-200||-100||0||100||200||300||400||500|']);
%set(gca,'YTick',[-150,-100,-50,0,50,100,150,200,250]);
%set(gca,'YTickLabel',['-150|-100|-50|0|50|100|150|200|250']);
%ylabel('Cumulative NEP (g C m^{-2})','FontSize',12)
text(1.5,500,'(d)','FontSize',12)
%aa = legend('2003','2004','2005','2006','2007','Location','Best');
%set(aa,'Vis','on');


axes('Position',[0.10 0.2 0.35 0.35])
hold on

plot(m03,GEP74m_03,'k-','LineWidth',1.0) 
plot(m04,GEP74m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,GEP74m_05,'k-','LineWidth',2) 
plot(m06,GEP74m_06,'k--','LineWidth',2.0)  
plot(m07,GEP74m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m03,-RE74m_03,'k-','LineWidth',1.0) 
plot(m04,-RE74m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,-RE74m_05,'k-','LineWidth',2) 
plot(m06,-RE74m_06,'k--','LineWidth',2.0)  
plot(m07,-RE74m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m, zero,'k:','LineWidth',1)

set(gca,'box','on','xlim',[1 12],'FontSize',12);
set(gca,'box','on','ylim',[-350 550],'FontSize',12);
set(gca,'XTick',[0 1 2 3 4 5 6 7 8 9 10 11 12]);
set(gca,'XTickLabel',['|J|F|M|A|M|J|J|A|S|O|N|D']);
set(gca,'YTick',[-350,-300,-250,-200,-150,-100,-50,0,50,100,150,200,250,300,350,400,450,500,550]);
set(gca,'YTickLabel',['|-300||-200||-100||0||100||200||300||400||500|']);
ylabel('GEP & RE (g C m^{-2} month^{-1})','FontSize',12)
text(1.5,500,'(b)','FontSize',12)
aa = legend('2003','2004','2005','2006','2007','Location','best');
set(aa,'Vis','on','box','off','FontSize',8);
xlabel('Month','FontSize',12)


axes('Position',[0.55 0.2 0.35 0.35])
hold on

plot(m03,GEP89m_03,'k-','LineWidth',1.0) 
plot(m04,GEP89m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,GEP89m_05,'k-','LineWidth',2) 
plot(m06,GEP89m_06,'k--','LineWidth',2.0)  
plot(m07,GEP89m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m03,-RE89m_03,'k-','LineWidth',1.0) 
plot(m04,-RE89m_04,'Color',[.5 .5 .5],'LineWidth',1.0) 
plot(m05,-RE89m_05,'k-','LineWidth',2) 
plot(m06,-RE89m_06,'k--','LineWidth',2.0)  
plot(m07,-RE89m_07,'Color',[.5 .5 .5],'LineWidth',2) 

plot(m, zero,'k:','LineWidth',1)

set(gca,'box','on','xlim',[1 12],'FontSize',12);
set(gca,'box','on','ylim',[-350 550],'FontSize',12);
set(gca,'XTick',[0 1 2 3 4 5 6 7 8 9 10 11 12]);
set(gca,'XTickLabel',['|J|F|M|A|M|J|J|A|S|O|N|D']);
set(gca,'YTick',[-350,-300,-250,-200,-150,-100,-50,0,50,100,150,200,250,300,350,400,450,500,550]);
set(gca,'YTickLabel',['|-300||-200||-100||0||100||200||300||400||500|']);
%ylabel('NEP (g C m^{-2})','FontSize',12)
xlabel('Month','FontSize',12)
text(1.5,500,'(c)','FontSize',12)

print -dmeta   GEP_RE__monthly_lineplot; 
print -dtiff -r300  GEP_RE__monthly_lineplot; 



