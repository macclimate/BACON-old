% Monthly time series of PAR, Ta, PPT
% Altaf Arain, 20 October 2008

close all; clear all; clc

%% Load H-Hour and Daily Mean SM data

days = 1;

load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2003.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2004.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2005.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2006.dat
load C:\Data\turkey\TP_2003_07_FinalCD_JB\Master_Files\Final_dat\TP39_final_2007.dat

dt03 = TP39_final_2003(:,6);
dt04 = TP39_final_2004(:,6);
dt05 = TP39_final_2005(:,6);
dt06 = TP39_final_2006(:,6);
dt07 = TP39_final_2007(:,6);

SM50a39_03 = TP39_final_2003(:,61);
SM50a39_04 = TP39_final_2004(:,61);
SM50a39_05 = TP39_final_2005(:,61);
SM50a39_06 = TP39_final_2006(:,61);
SM50a39_07 = TP39_final_2007(:,61);

SM50b39_03 = TP39_final_2003(:,66);
SM50b39_04 = TP39_final_2004(:,66);
SM50b39_05 = TP39_final_2005(:,66);
SM50b39_06 = TP39_final_2006(:,66);
SM50b39_07 = TP39_final_2007(:,66);

% Daily
[SM50a39_03sum,SM50a39_03mean,TimeX03] = integzBC1(dt03(~isnan(SM50a39_03)),  SM50a39_03(~isnan(SM50a39_03)),1:365,days);  SM50a39_03Mean  = SM50a39_03mean'; 
[SM50a39_04sum,SM50a39_04mean,TimeX04] = integzBC1(dt04(~isnan(SM50a39_04)),  SM50a39_04(~isnan(SM50a39_04)),1:366,days);  SM50a39_04Mean  = SM50a39_04mean'; 
[SM50a39_05sum,SM50a39_05mean,TimeX05] = integzBC1(dt05(~isnan(SM50a39_05)),  SM50a39_05(~isnan(SM50a39_05)),1:365,days);  SM50a39_05Mean  = SM50a39_05mean'; 
[SM50a39_06sum,SM50a39_06mean,TimeX06] = integzBC1(dt06(~isnan(SM50a39_06)),  SM50a39_06(~isnan(SM50a39_06)),1:365,days);  SM50a39_06Mean  = SM50a39_06mean'; 
[SM50a39_07sum,SM50a39_07mean,TimeX07] = integzBC1(dt07(~isnan(SM50a39_07)),  SM50a39_07(~isnan(SM50a39_07)),1:365,days);  SM50a39_07Mean  = SM50a39_07mean'; 

[SM50b39_03sum,SM50b39_03mean,TimeX03] = integzBC1(dt03(~isnan(SM50b39_03)),  SM50b39_03(~isnan(SM50b39_03)),1:365,days);  SM50b39_03Mean  = SM50b39_03mean'; 
[SM50b39_04sum,SM50b39_04mean,TimeX04] = integzBC1(dt04(~isnan(SM50b39_04)),  SM50b39_04(~isnan(SM50b39_04)),1:366,days);  SM50b39_04Mean  = SM50b39_04mean'; 
[SM50b39_05sum,SM50b39_05mean,TimeX05] = integzBC1(dt05(~isnan(SM50b39_05)),  SM50b39_05(~isnan(SM50b39_05)),1:365,days);  SM50b39_05Mean  = SM50b39_05mean'; 
[SM50b39_06sum,SM50b39_06mean,TimeX06] = integzBC1(dt06(~isnan(SM50b39_06)),  SM50b39_06(~isnan(SM50b39_06)),1:365,days);  SM50b39_06Mean  = SM50b39_06mean'; 
[SM50b39_07sum,SM50b39_07mean,TimeX07] = integzBC1(dt07(~isnan(SM50b39_07)),  SM50b39_07(~isnan(SM50b39_07)),1:365,days);  SM50b39_07Mean  = SM50b39_07mean'; 

%Monthly

SM50a39_03m = monmean(TimeX03(~isnan(SM50a39_03Mean)),SM50a39_03Mean(~isnan(SM50a39_03Mean)),0);
SM50a39_04m = monmean(TimeX04(~isnan(SM50a39_04Mean)),SM50a39_04Mean(~isnan(SM50a39_04Mean)),0);
SM50a39_05m = monmean(TimeX05(~isnan(SM50a39_05Mean)),SM50a39_05Mean(~isnan(SM50a39_05Mean)),0);
SM50a39_06m = monmean(TimeX06(~isnan(SM50a39_06Mean)),SM50a39_06Mean(~isnan(SM50a39_06Mean)),0);
SM50a39_07m = monmean(TimeX07(~isnan(SM50a39_07Mean)),SM50a39_07Mean(~isnan(SM50a39_07Mean)),0);

SM50b39_03m = monmean(TimeX03(~isnan(SM50b39_03Mean)),SM50b39_03Mean(~isnan(SM50b39_03Mean)),0);
SM50b39_04m = monmean(TimeX04(~isnan(SM50b39_04Mean)),SM50b39_04Mean(~isnan(SM50b39_04Mean)),0);
SM50b39_05m = monmean(TimeX05(~isnan(SM50b39_05Mean)),SM50b39_05Mean(~isnan(SM50b39_05Mean)),0);
SM50b39_06m = monmean(TimeX06(~isnan(SM50b39_06Mean)),SM50b39_06Mean(~isnan(SM50b39_06Mean)),0);
SM50b39_07m = monmean(TimeX07(~isnan(SM50b39_07Mean)),SM50b39_07Mean(~isnan(SM50b39_07Mean)),0);

% all year in one
TP39_SM50a = [SM50a39_03m SM50a39_04m  SM50a39_05m  SM50a39_06m  SM50a39_07m];
TP39_SM50b = [SM50b39_03m SM50b39_04m  SM50b39_05m  SM50b39_06m  SM50b39_07m];
TP39_SM50 = mean([TP39_SM50a  TP39_SM50b]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(gcf)
figure('unit','inches','PaperOrientation','Landscape','PaperPosition',[.1 0.1 9. 7.5],...
'position',[0.1    0.1    9.0    7.5]);

axes('Position',[.1 .7 .45 .25])
hold on

plot(M1_SM_monts,'ko-',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',4);   
plot(M2_SM_monts,'k-','LineWidth',1)  
plot(M3_SM_monts,'Color',[.6 .6 .6],'LineWidth',1.0)  
plot(M4_SM_monts,'k:','LineWidth',1)  


set(gca,'box','on','xlim',[0 61],'FontSize',12);
set(gca,'XTick',[0;6;12;18;24;30;36;42;48;54;60]);
%set(gca,'XTickLabel',['2003|2004|2005|2006|2007']);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[0 0.25],'FontSize',12);
set(gca,'YTick',[0;0.05;0.1;0.15;0.2;0.25]);
%set(gca,'YTickLabel',['0.4|0.6|0.8|1.0|1.2|1.4']);
 %xlabel('Year','FontSize',13)
ylabel('\theta_{20cm} (m^{3}m^{-3})','FontSize',13)

%aa=legend('TP39','TP74','TP89','TP02',2);
%set(aa,'box','off','FontSize',10);
text(57,0.23,'(a)','FontSize',13);
            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.57 .7 .30 .25])
hold on

plot(M1_SM(:,1),'k-','LineWidth',1.0)              
plot(M1_SM(:,2),'Color',[.6 .6 .6],'LineWidth',1.0)              
plot(M1_SM(:,3),'k-','LineWidth',2)                
plot(M1_SM(:,4),'k:','LineWidth',1.0)                
plot(M1_SM(:,5),'Color',[.6 .6 .6],'LineWidth',2) 
            
set(gca,'box','on','xlim',[0 13],'FontSize',12);
set(gca,'XTick',[0;1;2;3;4;5;6;7;8;9;10;11;12;13]);
set(gca,'XTickLabel',[  ]);

set(gca,'box','on','ylim',[0.05 0.2],'FontSize',12);
set(gca,'YAxisLocation','right');
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
%set(gca,'YTickLabel',[ ]);
%xlabel('Year','FontSize',13)
%ylabel('PAR (umol m^{-2} month^{-1})','FontSize',13)

text(0.5,0.185,'(b)','FontSize',13);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes('Position',[.1 .4 .45 .25])
hold on

% plot(TP74_SM100a,'ko-',...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','k',...
%                 'MarkerSize',4);   
% plot(TP74_SM100a,'k-','LineWidth',1)  
% plot(TP74_SM100a,'Color',[.6 .6 .6],'LineWidth',1.0)  
% plot(TP02_SM100a,'k:','LineWidth',1)  


plot(M1_SM100_monts,'ko-',...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',4);   
plot(TP74_SM50a,'k-','LineWidth',1)  
plot(M3_SM100_monts,'Color',[.6 .6 .6],'LineWidth',1.0)  
plot(M4_SM_monts,'k:','LineWidth',1)  

set(gca,'box','on','xlim',[0 61],'FontSize',12);
set(gca,'XTick',[0;6;12;18;24;30;36;42;48;54;60]);
set(gca,'XTickLabel',['|2003||2004||2005||2006||2007|']);

set(gca,'box','on','ylim',[0.0 0.40],'FontSize',12);
%set(gca,'YTick',[0;0.05;0.1;0.15;0.2;0.25]);
%set(gca,'YTickLabel',['0.4|0.6|0.8|1.0|1.2|1.4']);
 %xlabel('Year','FontSize',13)
ylabel('\theta_{1m} (m^{3}m^{-3})','FontSize',13)
xlabel('Year','FontSize',12)

aa=legend('TP39','TP74','TP89','TP02',2);
set(aa,'box','off','FontSize',10);
text(57,0.36,'(c)','FontSize',13);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes('Position',[.57 .4 .30 .25])
hold on

% plot(TP39_SM50a(1:12),'k-','LineWidth',1.0)              
% plot(TP39_SM50a(13:24),'Color',[.6 .6 .6],'LineWidth',1.0)              
% plot(TP39_SM50a(25:36),'k-','LineWidth',2)                
% plot(TP39_SM50a(37:48),'k:','LineWidth',1.0)                
% plot(TP39_SM50a(49:60),'Color',[.6 .6 .6],'LineWidth',2) 

plot(M1_SM100(1:12),'k-','LineWidth',1.0)              
plot(M1_SM100(13:24),'Color',[.6 .6 .6],'LineWidth',1.0)              
plot(M1_SM100(25:36),'k-','LineWidth',2)                
plot(M1_SM100(37:48),'k:','LineWidth',1.0)                
plot(M1_SM100(49:60),'Color',[.6 .6 .6],'LineWidth',2) 

set(gca,'box','on','xlim',[0 13],'FontSize',12);
set(gca,'XTick',[0;1;2;3;4;5;6;7;8;9;10;11;12;13]);
set(gca,'XTickLabel',['|J|F|M|A|M|J|J|A|S|O|N|D']);

set(gca,'box','on','ylim',[0.05 0.2],'FontSize',12);
set(gca,'YAxisLocation','right');
%set(gca,'YTick',[0.4;0.6;0.8;1.0;1.2;1.4]);
%set(gca,'YTickLabel',[ ]);
xlabel('Month','FontSize',12)
%ylabel('PAR (umol m^{-2} month^{-1})','FontSize',13)

text(0.5,0.185,'(d)','FontSize',13);
aa=legend('2003','2004','2005','2006','2007','Location','Southwest');
set(aa,'box','off','FontSize',8);


print -dmeta SM_monthly_ts; 
print -dtiff -r300 SM_monthly_ts; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

