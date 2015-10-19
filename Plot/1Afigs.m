figure(10)
subplot(2,1,1)
plot((1:1:17568),NEE1(52705:70272,1).*-0.0216,'b.-')
XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
XTicks = [1;30*48; 60*48;91*48; 121*48;152*48; 182*48; 213*48; 244*48; 274*48; 305*48; 335*48;365*48];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 17520 -0.5 0.8])
% line([0 6],[0 0], 'LineStyle','--','Color','k','LineWidth',1)
set(gca,'YGrid','on')
ylabel('NEP (g C m^{-2} s^{-1})','FontSize',18);

subplot(2,1,2)
plot((1:1:4*48),NEE1(52705+7536:52705+7536+(4*48)-1,1).*-0.0216,'b.-')
XTickLabels = ['06-Jun'; '07-Jun'; '08-Jun'; '09-Jun'];
XTicks = (1:1:4).*48-47;
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 4*48 -0.5 0.8])
ylabel('NEP (g C m^{-2} s^{-1})','FontSize',18);


print('-dbmp','/home/jayb/Desktop/1A_Figs/06NEP')



vars_out = jjb_flux_load('1A', '2007', '1', 'processed', 'processed');
%                   1     2     3      4    5     6     7   8       9   10   11     12   13  14 
%      vars_out = [SM5a SM10a SM100a SM5b SM10b SM50b Ts2a Ts20a Ts100a PAR PAR_up T_air WS Wdir];

[year JD HHMM dt]  = jjb_makedate(str2double(2007),30);
%% SM
figure(11); clf;
plot(dt,vars_out(:,1)*100,'b','LineWidth',1.5); hold on
plot(dt,vars_out(:,6)*100,'r','LineWidth',1.5);
XTicks = [1;30; 60;91; 121;152; 182; 213; 244; 274; 305; 335;365];
XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 365 0 30])
ylabel('% Water in Soil','FontSize',18);
set(gca,'YGrid','on')


print('-dbmp','/home/jayb/Desktop/1A_Figs/SM')

%% Ts

figure(12); clf

plot(dt,vars_out(:,7),'m','LineWidth',1.5); hold on
plot(dt,vars_out(:,8),'b','LineWidth',1.5);
plot(dt,vars_out(:,9),'g','LineWidth',1.5);
XTicks = [1;30; 60;91; 121;152; 182; 213; 244; 274; 305; 335;365];
XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 365 -5 30])
ylabel('Soil Temperature (^{o}C)','FontSize',18);
set(gca,'YGrid','on')


print('-dbmp','/home/jayb/Desktop/1A_Figs/Ts')

%% Ts, Ta

figure(13); clf


plot(dt,vars_out(:,12),'b','LineWidth',1.5);hold on
plot(dt,vars_out(:,7),'r','LineWidth',1.5); hold on
XTicks = [1;30; 60;91; 121;152; 182; 213; 244; 274; 305; 335;365];
XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 365 -20 35])
ylabel('Soil, Air Temperature (^{o}C)','FontSize',18);
set(gca,'YGrid','on')


print('-dbmp','/home/jayb/Desktop/1A_Figs/Ts_Ta')

%% Ts, Ta
% 
% figure(14); clf
% 
% 
% plot(dt,vars_out(:,10),'b','LineWidth',1.5);hold on
% plot(dt,vars_out(:,11),'r','LineWidth',1.5); hold on
% % XTicks = [1;30; 60;91; 121;152; 182; 213; 244; 274; 305; 335;365];
% % XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
% % set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
% axis([0 365 -10 2500])
% ylabel('Soil, Air Temperature (^{o}C)','FontSize',18);
% set(gca,'YGrid','on')
% 
% 
% print('-dbmp','/home/jayb/Desktop/1A_Figs/PAR')

figure(16); clf;
plot(1:1:3*48,vars_out(149*48+1:152*48,10),'bx-','LineWidth',1.5,'MarkerSize',6); hold on;
XTicks = (1:48:48*2+1);
XTickLabels = ['29-May';'30-May';'31-May';];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
ylabel('Downward Solar Radiation','FontSize',18);


print('-dbmp','/home/jayb/Desktop/1A_Figs/PAR')

figure(17); clf
plot(1:1:48, vars_out(35*48:35*48+47,10),'rx-','LineWidth',1.5,'MarkerSize',6); hold on;
plot(1:1:48, vars_out(162*48:162*48+47,10),'bx-','LineWidth',1.5,'MarkerSize',6); hold on;
plot(1:1:48, vars_out(212*48:212*48+47,10),'gx-','LineWidth',1.5,'MarkerSize',6); hold on;


XTicks = (0:8:48);
XTickLabels2 = ['00:00';'04:00';'08:00';'12:00'; '16:00';'20:00';'24:00'];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels2, 'FontSize', 18)
ylabel('Downward Solar Radiation','FontSize',18);
xlabel('Time of Day')
print('-dbmp','/home/jayb/Desktop/1A_Figs/PAR_comp')


%% Ts, Ta

figure(15); clf


plot(dt,vars_out(:,13),'b','LineWidth',1.5);hold on
XTicks = [1;30; 60;91; 121;152; 182; 213; 244; 274; 305; 335;365];
XTickLabels = ['Jan';'   '; 'Mar';'   '; 'May';'   '; 'Jul';'   '; 'Sep' ;'   ';'Nov';'   ';'Jan'];
set(gca, 'XTick', XTicks, 'XTickLabel',XTickLabels, 'FontSize', 18)
axis([0 365 0 10])
ylabel('Soil, Air Temperature (^{o}C)','FontSize',18);
set(gca,'YGrid','on')


print('-dbmp','/home/jayb/Desktop/1A_Figs/PAR')



