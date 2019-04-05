% function [] = TP39_FluxCalc_fig(GEP_model)
GEP_model = 4;
site = '1';

%% GEP_model specifies the combination of env variables used to model GEP.
% GEP_model = 3;
% GEP_model = modellist(iii);
% 1 -- Ts, VPD, SM -- using pooled parameters for R and GEP
% 2 -- Tair, Ts, VPD and SM
% 3 -- model 1, pooled R, individual GEP
% 4 -- model 1, individual R and GEP
% 5 -- average GEP/PAR relationship for each year
% 6 -- average GEP/PAR -- pooled data for all years:

st_yr = 2003; end_yr = 2007;
ustar_th = 0.25;
colorlist = ['r';'g';'b';'k';'c';'m'];
if ispc == 1
    path = 'C:\HOME\MATLAB\Data\Data_Analysis\M1_allyears\';
                 fig_path = 'C:\HOME\MATLAB\Data\CCP Pres\CCP_Figs\';
else
    path = '/home/jayb/MATLAB/Data/Data_Analysis/M1_allyears/';
    fig_path = '/home/jayb/Desktop/CCP_Figs/';
end
%% Load variables for 2003-2007
all_vars = load([path 'M1_all_yrs_data.dat']);

T_air1 = all_vars(:,1);
PAR1 = all_vars(:,2);
Ts1_2 = all_vars(:,3);
SM1 = all_vars(:,4);
NEE1 = all_vars(:,5); %NEE1(NEE1 > 35 | NEE1 < -35) = NaN;
ustar1 = all_vars(:,6);
dt1 = all_vars(:,7);
year1 = all_vars(:,8);
WS1 = all_vars(:,9);
Wdir1 = all_vars(:,10);
VPD1 = all_vars(:,11);
Ts1_5 = all_vars(:,12);
clear all_vars;
NEE_raw = NEE1;
%% For the time being.... use 5cm soil temp as the main one:
Ts1 = Ts1_5;
clear Ts1_5;
%% Establish Ts vs Re relationship:

Ts_test = (-4:2:26)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
yrlist = ['2003';'2004';'2005';'2006';'2007'];

counter = 1;
for jj = st_yr:1:end_yr

    %%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts1 > -6 & PAR1 < 10 & ~isnan(Ts1) & ~isnan(NEE1) & year1 == jj & ustar1 > ustar_th);%

    %%% Step 1: Block average Ts and NEE
    Resp(counter).bavg = jjb_blockavg(Ts1(ind_regress), NEE1(ind_regress), 0.5,20, -10);
    %%% Step 2: Make sure we don't use any values with NaN;
    ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
    %%% Step 3: Use logistic function to regress respiration with Ts for bin-avg data with ustar threshold
    [Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitlogi5', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));

    %%% Step 4: Estimate Respiration Function using logistic function:
    Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));
    est_R(counter).regbavg = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));
    est_R(counter).Tstest = Ts_test;
    
    
    %%% Plot this stuff:
    figure(2)
    subplot(3,2,counter);
    plot (Ts1(ind_regress),NEE1(ind_regress),'k.');
    hold on;
    plot(Ts_test, Resp(counter).est_R,'r-');
    
    if jj == 2004
          figure(41); clf;
    plot (Ts1(ind_regress),NEE1(ind_regress),'k.','MarkerSize',10);
    hold on;
    plot(Ts_test, Resp(counter).est_R,'LineStyle','-','Color','r', 'LineWidth',4);
    ylabel('R_{E} \mu mol C m^{-2}s^{-1}','FontSize',18);
    xlabel('T_{soil}   ^{o}C','FontSize',18)
    set(gca,'FontSize',18)
    legend('Observed','Modeled',2)
    axis([-5 25 -2 12])
    print('-dbmp',[fig_path 'Ts_RE'])
    print('-depsc',[fig_path 'Ts_RE'])
    end

    figure(1)
    plot(Ts_test, Resp(counter).est_R,'Color',plot_color(counter,1:3));
    hold on;
    %%% Count the number of data points in the year for which Respiration will
    %%% be modeled:
    ind_yr = find(year1==jj);
    %     used_data = length(find(~isnan(Ts1(ind_yr))==1));

    %%% Estimate Respiration for the whole year, based on Ts data:
    Resp(counter).resp = Resp(counter).coeff(1)./(1+exp(Resp(counter).coeff(2)*(Resp(counter).coeff(3)-Ts1(ind_yr))));

    clear  ind_regress ind_yr used_data;
    counter = counter+1;

end
figure(1)
legend(yrlist)

%% All years respiration curve:

ind_all_resp = find(Ts1 > -6 & PAR1 < 10 & ~isnan(Ts1) & ~isnan(NEE1) & ustar1 > ustar_th );%& NEE1 > -5 & NEE1 < 15 & T_air1 > 8
%     [R_all_coeff,R_all_y,R_all_r2,R_all_sigma] = fitmain([1 1 1], 'fitlogi5', Ts1(ind_all_resp), NEE1(ind_all_resp));%
% est_R_all = R_all_coeff(1) ./(1 + exp(R_all_coeff(2).*(R_all_coeff(3)-Ts_test)));

R_allbavg = jjb_blockavg(Ts1(ind_all_resp), NEE1(ind_all_resp), 0.5,20, -3);
ind_okdata_all = find(~isnan(R_allbavg(:,1).*R_allbavg(:,2)));
[R_allbavg_coeff,R_allbavg_y,R_allbavg_r2,R_allbavg_sigma] = fitmain([1 1 1], 'fitlogi5', R_allbavg(ind_okdata_all,1), R_allbavg(ind_okdata_all,2));%
est_R_allbavg = R_allbavg_coeff(1) ./(1 + exp(R_allbavg_coeff(2).*(R_allbavg_coeff(3)-Ts_test)));

Resp_allyrs = R_allbavg_coeff(1) ./(1 + exp(R_allbavg_coeff(2).*(R_allbavg_coeff(3)-Ts1)));

%%% Plot all years data alongside each year of data:
figure(2)
subplot(3,2,6)
plot(Ts1(ind_all_resp),NEE1(ind_all_resp),'k.');
hold on;
plot(R_allbavg(ind_okdata_all,1),R_allbavg(ind_okdata_all,2),'ro');
plot(Ts_test, est_R_allbavg,'g')

%%% Plot average curve with other curves for single years:
figure(1)
plot(Ts_test, est_R_allbavg,'Color','c', 'LineWidth', 3);
hold on;
legend([yrlist; 'all '],2);

%% Plot 2004 Resp Curve and data:



%% Put all years together to make one column vector with all Resp data:
if GEP_model == 1 || GEP_model == 3 || GEP_model == 5 || GEP_model == 6;
Resp1 = Resp_allyrs;
elseif GEP_model == 4
Resp1 = [Resp(1).resp ;NaN*ones(48,1); Resp(2).resp ; Resp(3).resp ;NaN*ones(48,1) ; Resp(4).resp; NaN*ones(48,1) ; Resp(5).resp ;NaN*ones(48,1)];%%%% NOTE: The reason that 48 NaNs are added at the end of 2003 and 2005 is
end
% Resp1 = [Resp(1).resp ;NaN*ones(48,1); Resp(2).resp ; Resp(3).resp ;NaN*ones(48,1) ; Resp(4).resp; NaN*ones(48,1) ; Resp(5).resp ;NaN*ones(48,1)];%%%% NOTE: The reason that 48 NaNs are added at the end of 2003 and 2005 is
%%%% to make the length of all years = 17568, to make for easy comparison
%%%% with the rest of the met data, which is in the same format...

%% Create GEP:
GEP1 = Resp1 - NEE1;
GEP_raw = GEP1;
GEP_pred(1:length(GEP1),1) = NaN;
%% Plot GEP vs. PAR relationship for each year (using all available data):
PAR_test = (0:200:2200);

for jk = 2003:1:2007
    counter_3 = jk-2002;

    ind_ok_GEP = find(Ts1 > 0 & T_air1 > -5 & PAR1 > 20 & ~isnan(Ts1) ...
        & ~isnan(GEP1) & dt1 > 95 & dt1 < 330 & year1 == jk);

    GEP_PAR(counter_3).GEP = GEP1(ind_ok_GEP);
    GEP_PAR(counter_3).PAR = PAR1(ind_ok_GEP);

    GEP_PAR(counter_3).bavg = jjb_blockavg(GEP_PAR(counter_3).PAR, GEP_PAR(counter_3).GEP, 100, 70, -25);
    ok_compare = find(~isnan(GEP_PAR(counter_3).bavg(:,1) .* GEP_PAR(counter_3).bavg(:,2)));

    [GEP_PAR(counter_3).coeff GEP_PAR(counter_3).y GEP_PAR(counter_3).r2 GEP_PAR(counter_3).sigma] = hypmain1([0.01 10 0.1], 'fit_hyp1', GEP_PAR(counter_3).bavg(ok_compare,1), GEP_PAR(counter_3).bavg(ok_compare,2));

    GEP_PAR(counter_3).pred = GEP_PAR(counter_3).coeff(1).*PAR_test.*GEP_PAR(counter_3).coeff(2)./(GEP_PAR(counter_3).coeff(1).*PAR_test + GEP_PAR(counter_3).coeff(2));
    GEP_PAR(counter_3).PAR_test = PAR_test;

    clear ok_compare;

figure(71)
plot(PAR_test, GEP_PAR(counter_3).pred,'-','Color',colorlist(counter_3),'LineWidth', 3);hold on;
% legend([yrlist ;'all '],2);

%% Make a new variable that models GEP based on PAR only using relationship
%%%from 2003
if GEP_model == 5 
GEP_pred(year1 == jk) = GEP_PAR(counter_3).coeff(1).*PAR1(year1 == jk).*GEP_PAR(counter_3).coeff(2)./(GEP_PAR(counter_3).coeff(1).*PAR1(year1 == jk) + GEP_PAR(counter_3).coeff(2));
end
clear ind_ok_GEP
end

counter_3 = counter_3+1;
%%% Make an all-years curve:

ind_ok_GEP_all = find(Ts1 > 0 & T_air1 > -5 & PAR1 > 20 & ~isnan(Ts1) & ~isnan(GEP1) & dt1 > 95 & dt1 < 330);

GEP_PAR(counter_3).GEP = GEP1(ind_ok_GEP_all);
GEP_PAR(counter_3).PAR = PAR1(ind_ok_GEP_all);

GEP_PAR(counter_3).bavg = jjb_blockavg(GEP_PAR(counter_3).PAR, GEP_PAR(counter_3).GEP, 100, 70, -25);
ok_compare = find(~isnan(GEP_PAR(counter_3).bavg(:,1) .* GEP_PAR(counter_3).bavg(:,2)));

[GEP_PAR(counter_3).coeff GEP_PAR(counter_3).y GEP_PAR(counter_3).r2 GEP_PAR(counter_3).sigma] = hypmain1([0.01 10 0.1], 'fit_hyp1', GEP_PAR(counter_3).bavg(ok_compare,1), GEP_PAR(counter_3).bavg(ok_compare,2));

GEP_PAR(counter_3).pred = GEP_PAR(counter_3).coeff(1).*PAR_test.*GEP_PAR(counter_3).coeff(2)./(GEP_PAR(counter_3).coeff(1).*PAR_test + GEP_PAR(counter_3).coeff(2));
GEP_PAR(counter_3).PAR_test = PAR_test;

if GEP_model ~= 5
GEP_pred = GEP_PAR(counter_3).coeff(1).*PAR1.*GEP_PAR(counter_3).coeff(2)./(GEP_PAR(counter_3).coeff(1).*PAR1 + GEP_PAR(counter_3).coeff(2));
end

figure(71)
plot(PAR_test, GEP_PAR(counter_3).pred,'-','Color',colorlist(counter_3),'LineWidth', 3);
legend([yrlist ;'all '],2);

%% Look for general relationships between env. variables and GEP (richardson)
%%% Plot some figures to look at relationships:

ind_good_GEP = find(Ts1 > -5 & T_air1 > -5 & PAR1 > 20 & ~isnan(Ts1) ...
    & ~isnan(T_air1) & ~isnan(GEP1) & ~isnan(SM1) & dt1 > 0 & dt1 < 366 ...
    );

figure(3)
clf;
subplot(3,2,1); plot(Ts1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('Ts vs. GEP'); hold on;
subplot(3,2,2); plot(T_air1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('T_{air} vs. GEP'); hold on;
subplot(3,2,3); plot(PAR1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('PAR vs. GEP'); hold on;
subplot(3,2,4); plot(Wdir1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('Wind dir. vs. GEP'); hold on;
subplot(3,2,5); plot(VPD1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('VPD. vs. GEP'); hold on;
subplot(3,2,6); plot(SM1(ind_good_GEP), GEP1(ind_good_GEP), 'b.'); title('SM. vs. GEP'); hold on;

% Block average data to see average trends
b_avg_Ts = jjb_blockavg(Ts1(ind_good_GEP), GEP1(ind_good_GEP),      0.50, 80, -30);
b_avg_T_air = jjb_blockavg(T_air1(ind_good_GEP), GEP1(ind_good_GEP),0.50, 80, -30);
b_avg_PAR = jjb_blockavg(PAR1(ind_good_GEP), GEP1(ind_good_GEP),    100, 80, -30);
b_avg_Wdir = jjb_blockavg(Wdir1(ind_good_GEP), GEP1(ind_good_GEP),  10, 80, -30);
b_avg_VPD = jjb_blockavg(VPD1(ind_good_GEP), GEP1(ind_good_GEP),    0.1, 80, -30);
b_avg_SM = jjb_blockavg(SM1(ind_good_GEP), GEP1(ind_good_GEP),      0.0025, 80, -30);

figure(3)
subplot(3,2,1); plot(b_avg_Ts(:,1), b_avg_Ts(:,2), 'ro');
subplot(3,2,2); plot(b_avg_T_air(:,1), b_avg_T_air(:,2), 'ro');
subplot(3,2,3); plot(b_avg_PAR(:,1), b_avg_PAR(:,2), 'ro');
subplot(3,2,4); plot(b_avg_Wdir(:,1), b_avg_Wdir(:,2), 'ro');
subplot(3,2,5); plot(b_avg_VPD(:,1), b_avg_VPD(:,2), 'ro');
subplot(3,2,6); plot(b_avg_SM(:,1), b_avg_SM(:,2), 'ro');

%% STEP 2. Establish max GEP equation -- for each season:
PAR_test = (0:200:2200);
GEP_max(1:length(GEP1),1) = NaN;



figure(5)
clf;
figure(4)
clf;
if GEP_model == 3 || GEP_model == 4;
for mm = 2003:1:2007
    ctr_year = mm-2002;

%     ideal_GEP = find(Ts1 > 14 & T_air1 > 20  & year1 == mm... %% & VPD1 < 1.3& Ts1 < 20 & T_air1 < 26& PAR1 < 1700
%         & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 ...
%         & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3); % & (year1 == 2003 | year1 == 2006) ); %
% 
%     figure(4)
%     hold on;
%     subplot(3,2,ctr_year)
%     plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')
% 
%     % Blockaverage GEP data into PAR bins:
%     if mm == 2007
%         b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 150, 70, -25);
%     else
%         b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
%     end
% 
%     figure(4)
%     subplot(3,2,ctr_year); hold on;
%     plot(b_avg(ctr_year).ideal(:,1), b_avg(ctr_year).ideal(:,2),'ro');

    switch mm
        case 2003
        ideal_GEP = find(Ts1 > 17 & T_air1 > 23  & year1 == 2003 & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3);
        b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
        b_avg_ideal = b_avg(ctr_year).ideal;    
    figure(4)
    subplot(3,2,ctr_year); hold on;    
    plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on; 
        ideal_x = [0; b_avg(ctr_year).ideal(1:19,1)];
            ideal_y = [0; b_avg(ctr_year).ideal(1:19,2) ];
            
        case 2004
        ideal_GEP_low = find(year1 == 2004 & ~isnan(GEP1) & Ts1 > 17 & T_air1 > 22 & dt1 > 150 & dt1 < 270 & VPD1 < 0.7 & VPD1 > 0 & SM1 > 0.085& GEP1 > 0 & PAR1 > 30 & PAR1 < 800 & ustar1 > 0.3);    
        ideal_GEP_high = find(year1 == 2004 & ~isnan(GEP1) & Ts1 > 16 & T_air1 > 23 & dt1 > 150 & dt1 < 270 & VPD1 < 0.65 & VPD1 > 0 & SM1 > 0.085 & GEP1 > 8 & PAR1 >= 800 & PAR1 < 3000 & ustar1 > 0.3);    
         ideal_GEP = [ideal_GEP_low; ideal_GEP_high];
            
%         ideal_GEP = find(Ts1 > 18 & T_air1 > 23  & year1 == 2004 & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3);
        b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
                    b_avg_ideal = b_avg(ctr_year).ideal;  
                        figure(4);clf
    subplot(3,2,ctr_year); hold on;    
    plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on;
   ideal_x = [0; b_avg(ctr_year).ideal(1:13,1); b_avg(ctr_year).ideal(15:18,1)];% b_avg(ctr_year).ideal(17:18,1)]; %b_avg(ctr_year).ideal(15:19,1)];
            ideal_y = [0; b_avg(ctr_year).ideal(1:13,2); b_avg(ctr_year).ideal(15:18,2)];% b_avg(ctr_year).ideal(17:18,2)];% b_avg(ctr_year).ideal(15:19,2)];    
    
%         ideal_x = [0; b_avg(ctr_year).ideal(1:14,1); b_avg(ctr_year).ideal(15:19,1)];
%             ideal_y = [0; b_avg(ctr_year).ideal(1:14,2); b_avg(ctr_year).ideal(15:19,2)];
            
        case 2005
        ideal_GEP = find(Ts1 > 17 & T_air1 > 23  & year1 == 2005 & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3);            
        b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
                    b_avg_ideal = b_avg(ctr_year).ideal;    
                        figure(4)
    subplot(3,2,ctr_year); hold on;    
    plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on;
        ideal_x = [0; b_avg(ctr_year).ideal(1:15,1);b_avg(ctr_year).ideal(17,1);b_avg(ctr_year).ideal(20,1)];
            ideal_y = [0; b_avg(ctr_year).ideal(1:15,2);b_avg(ctr_year).ideal(17,2);b_avg(ctr_year).ideal(20,2)];
            
        case 2006
        ideal_GEP = find(Ts1 > 17 & T_air1 > 23  & year1 == 2006 & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3);            
        b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
                    b_avg_ideal = b_avg(ctr_year).ideal;    
                        figure(4)
    subplot(3,2,ctr_year); hold on;    
    plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on;
        ideal_x = [0; b_avg(ctr_year).ideal(1:19,1); b_avg(ctr_year).ideal(21,1)];
            ideal_y = [0; b_avg(ctr_year).ideal(1:19,2); b_avg(ctr_year).ideal(21,2)];
            
            figure(42); clf
                plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.','MarkerSize',10)  ;  hold on;       
                
            
        case 2007
        ideal_GEP_low = find(year1 == 2007 & ~isnan(GEP1) & Ts1 > 16 & T_air1 > 22 & dt1 > 130 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085 & GEP1 > -5 & PAR1 > 30 & PAR1 < 800 & ustar1 > 0.3);    
        ideal_GEP_high = find(year1 == 2007 & ~isnan(GEP1) & Ts1 > 16 & T_air1 > 23 & dt1 > 130 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085 & GEP1 > 7 & PAR1 >= 800 & PAR1 < 3000 & ustar1 > 0.3);    
         ideal_GEP = [ideal_GEP_low; ideal_GEP_high];
%         ideal_GEP = find(Ts1 > 17 & T_air1 > 23  & year1 == 2007 & ~isnan(GEP1) & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085  & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.3);            
        b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 150, 70, -25);
                    b_avg_ideal = b_avg(ctr_year).ideal;    
                        figure(4)
    subplot(3,2,ctr_year); hold on;    
    plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on;
        ideal_x = [0; b_avg(ctr_year).ideal(1:10,1); b_avg(ctr_year).ideal(12,1);b_avg(ctr_year).ideal(14,1)];
            ideal_y = [0; b_avg(ctr_year).ideal(1:10,2); b_avg(ctr_year).ideal(12,2);b_avg(ctr_year).ideal(14,2)];
    end
    plot(b_avg(ctr_year).ideal(:,1), b_avg(ctr_year).ideal(:,2),'ro');

    
    
    [coeff_ideal2 y_ideal2 r2_ideal2 sigma_ideal2] = hypmain1([0.01 10 0.1], 'fit_hyp1', ideal_x, ideal_y);

    P_ideal2 = coeff_ideal2(1).*PAR_test.*coeff_ideal2(2)./(coeff_ideal2(1).*PAR_test + coeff_ideal2(2));
    figure(4)
    subplot(3,2,ctr_year)
    plot(PAR_test,P_ideal2,'r','LineWidth',2);

    if mm ==2006
        figure(42)
        plot(PAR_test,P_ideal2,'r','LineWidth',4);
    xlabel('PPFD \mu mol m^{-2}s^{-1}','FontSize',18);
    ylabel('GEP \mumol C m^{-2}s^{-1}','FontSize',18)
    set(gca,'FontSize',18)
    legend('Observed','Averaged','Modeled',4)
    axis([-0 2250 0 28])
    print('-dbmp',[fig_path 'max_GEP'])
    print('-depsc',[fig_path 'max_GEP'])
    end
        

    figure(5)
    plot(PAR_test,P_ideal2,'Color', colorlist(ctr_year),'LineWidth',2); hold on;
grid on;
    GEP_max(year1==mm,1) = coeff_ideal2(1).*PAR1(year1==mm).*coeff_ideal2(2)./(coeff_ideal2(1).*PAR1(year1==mm) + coeff_ideal2(2));

    clear ideal_x ideal_y P_ideal2 ideal_GEP coeff_ideal2 y_ideal2 r2_ideal2 sigma_ideal2  ;

end
clear mm ctr_year
else
ctr_year = 1;
           ideal_GEP_low = find(~isnan(GEP1) & Ts1 > 18 & T_air1 > 24 & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085 & GEP1 > -5 & PAR1 > 30 & PAR1 < 800 & ustar1 > 0.3);    
           ideal_GEP_high = find(~isnan(GEP1) & Ts1 > 18 & T_air1 > 24 & dt1 > 150 & dt1 < 270 & VPD1 < 0.8 & VPD1 > 0 & SM1 > 0.085 & GEP1 > 5 & PAR1 >= 800 & PAR1 < 3000 & ustar1 > 0.3);    
           ideal_GEP = [ideal_GEP_low; ideal_GEP_high];


% ideal_GEP = find(~isnan(GEP1) & Ts1 > 18 & T_air1 > 20 & dt1 > 120 & dt1 < 240 & VPD1 < 0.85 & VPD1 > 0 & SM1 > 0.085 & GEP1 > -5 & PAR1 > 30 & ustar1 > 0.25);
figure(4) ; clf
plot(PAR1(ideal_GEP),GEP1(ideal_GEP),'k.')  ;  hold on;
b_avg(ctr_year).ideal = jjb_blockavg(PAR1(ideal_GEP), GEP1(ideal_GEP), 100, 70, -25);
b_avg_ideal = b_avg(ctr_year).ideal;
figure(4)
    plot(b_avg(ctr_year).ideal(:,1), b_avg(ctr_year).ideal(:,2),'ro');
         ideal_x = [0; b_avg(ctr_year).ideal(1:21,1)];
         ideal_y = [0; b_avg(ctr_year).ideal(1:21,2) ];
[coeff_ideal2 y_ideal2 r2_ideal2 sigma_ideal2] = hypmain1([0.01 10 0.1], 'fit_hyp1', ideal_x, ideal_y);
P_ideal2 = coeff_ideal2(1).*PAR_test.*coeff_ideal2(2)./(coeff_ideal2(1).*PAR_test + coeff_ideal2(2));
    figure(4)
    plot(PAR_test,P_ideal2,'r','LineWidth',2);

    
    GEP_max(:,1) = coeff_ideal2(1).*PAR1.*coeff_ideal2(2)./(coeff_ideal2(1).*PAR1 + coeff_ideal2(2));
   
end
    
figure(5)
legend('2003','2004','2005','2006','2007',4)

%% Create Logistic functions to scale GEP with met variables: SM, VPD & Ts

%% STEP 1a: Air Temperature Logistic Function:
T_air_test = (-5:1:34);

max_T_airy = 14;
T_air_x = [-9; -8; -7,; -6,; -5;-4.5; -4; b_avg_T_air(4:67,1); 29; 30 ];
T_air_y = [ -2;  -2;  -2; -2; -2;-2; -2;b_avg_T_air(4:67,2); max_T_airy; max_T_airy];

%%% Normalize values (to make function from 0 to 1)
T_air_y = T_air_y./max_T_airy;

%%% Fit these data with the logistic model:
[b_T_air,y_T_air,stats_T_air,sigma_T_air] = fitmain([1 1 1], 'fitlogi5', T_air_x, T_air_y);
p_T_air = (b_T_air(1).*max_T_airy)./(1+exp(b_T_air(2).*(b_T_air(3)-T_air_x)));
p_n_T_air = b_T_air(1)./(1+exp(b_T_air(2).*(b_T_air(3)-T_air_x)));

figure(6)
clf;
plot(T_air_x, T_air_y,'bx-');
hold on;
plot(T_air_x, p_n_T_air, 'rv-');
grid on;

%%% Create GEP scaling factor from the developed logistic equation:
GEP_T_air_sf = b_T_air(1)./(1+exp(b_T_air(2).*(b_T_air(3)-T_air1)));
GEP_T_air_sf(GEP_T_air_sf > 1) = 1;
GEP_T_air_sf(T_air1 < 0) = 0;

%%  Reduce the modeled MAX GEP by the T_air scaling factor
GEP_T_air_red = GEP_max .* GEP_T_air_sf;

%%% Remove the influence of T_air on measured GEP by dividing GEP by the
%%% scaling factor:
GEP_T_air_adj = GEP1 ./ GEP_T_air_sf;

%%% See if a relationship between Ts and GEP is still existent:

b_Ts_avg2 = jjb_blockavg(Ts1(ind_good_GEP), GEP_T_air_adj(ind_good_GEP),      0.50, 80, -30);

figure(7); clf
subplot(2,1,1)

plot(Ts1,GEP_T_air_adj,'b.')
hold on
plot(b_Ts_avg2(:,1),b_Ts_avg2(:,2),'ro')
axis ([-5 30 0 20])
title('Ts vs GEP after removing T_air influence')
%%% Model for this still-existent relationship(at low soil temperatures:
Ts_test = (-2:1:28)';
max_Tsy2 = 15;
min_Tsy2 = 4;

Ts_x2 = [-5; -3; -2; b_Ts_avg2(6:18,1); 6.5; 7.5; 8.5];
Ts_y2 = [min_Tsy2; min_Tsy2; min_Tsy2; b_Ts_avg2(6:18,2); max_Tsy2; max_Tsy2; max_Tsy2];

%%% Normalize Values
Ts_y2 = Ts_y2./max_Tsy2;

%%% Fit these data with the logistic model:
[b_Ts2,y_Ts2,stats_Ts2,sigma_Ts2] = fitmain([1 1 1], 'fitlogi5', Ts_x2, Ts_y2);
p_Ts2 = (b_Ts2(1).*(max_Tsy2-min_Tsy2))./(1+exp(b_Ts2(2).*(b_Ts2(3)-Ts_x2))) + min_Tsy2;
p_n_Ts2 = b_Ts2(1)./(1+exp(b_Ts2(2).*(b_Ts2(3)-Ts_x2)));

figure(7); subplot(2,1,2)
plot(Ts_x2, Ts_y2,'bx-');
hold on;
plot(Ts_x2, p_n_Ts2, 'rv-');
title('Ts vs GEP model after including T_air in model')

%%% Create GEP scaling factor from the developed logistic equation:
GEP_Ts2_sf = b_Ts2(1)./(1+exp(b_Ts2(2).*(b_Ts2(3)-Ts1)));
GEP_Ts2_sf(GEP_Ts2_sf > 1) = 1;
GEP_Ts2_sf(GEP_Ts2_sf < (min_Tsy2./max_Tsy2)) = min_Tsy2./max_Tsy2;

%% Create New Scaling Factors, and adjusted numbers (Comment to remove Ts
%% factor)
GEP_T_air_red = GEP_T_air_red.*GEP_Ts2_sf;
GEP_T_air_adj = GEP_T_air_adj./GEP_Ts2_sf;

%% STEP 1a. Soil Temperature Logistic Function:
%%% Look at the variable - b_avg_Ts to assess the Max value of Ts
if GEP_model == 4;
max_Tsy = 12.5;
Ts_x = [-5; -3; -2; b_avg_Ts(2:49,1); 24.5; 25.5;  26.5 ];
Ts_y = [ 0;  0;  0; b_avg_Ts(2:49,2); max_Tsy; max_Tsy; max_Tsy];

%%% Normalize values
Ts_y = Ts_y./max_Tsy;

%%% Fit these data with the logistic model:
[b_Ts,y_Ts,stats_Ts,sigma_Ts] = fitmain([1 1 1], 'fitlogi5', Ts_x, Ts_y);
p_Ts = (b_Ts(1).*max_Tsy)./(1+exp(b_Ts(2).*(b_Ts(3)-Ts_x)));
p_n_Ts = b_Ts(1)./(1+exp(b_Ts(2).*(b_Ts(3)-Ts_x)));    
    
else
max_Tsy = 12.8;
Ts_x = [-5; -3; -2; b_avg_Ts(2:49,1); 24.5; 25.5;  26.5 ];
Ts_y = [ 0;  0;  0; b_avg_Ts(2:49,2); max_Tsy; max_Tsy; max_Tsy];

%%% Normalize values
Ts_y = Ts_y./max_Tsy;

%%% Fit these data with the logistic model:
[b_Ts,y_Ts,stats_Ts,sigma_Ts] = fitmain([1 1 1], 'fitlogi5', Ts_x, Ts_y);
p_Ts = (b_Ts(1).*max_Tsy)./(1+exp(b_Ts(2).*(b_Ts(3)-Ts_x)));
p_n_Ts = b_Ts(1)./(1+exp(b_Ts(2).*(b_Ts(3)-Ts_x)));
end

figure(8)
clf;
plot(Ts_x, Ts_y,'bx-');
hold on;
plot(Ts_x, p_n_Ts, 'rv-');
grid on;

figure(43); clf;
p_n_Ts2 = p_n_Ts;
p_n_Ts2(p_n_Ts2 >1) = 1;
p_n_Ts2(Ts_x < 0) = 0;

h1 = plot(Ts1(ind_good_GEP), GEP1(ind_good_GEP)./max_Tsy, 'k.'); hold on;
h2 = plot(b_avg_Ts(2:49,1), b_avg_Ts(2:49,2)./max_Tsy, 'ro','Markersize',10);

line([-2 25], [1 1],'LineStyle','--','Color','b','LineWidth',3)

h3 = plot(Ts_x(3:51), p_n_Ts2(3:51), 'r-','LineWidth',4);
set(gca,'YGrid','on')
axis([-5 25 0 2])
text(-4.5,1 ,'12.5','FontSize',22,'Color','k')
text(-4.5,0 ,'0','FontSize',22,'Color','k')
    ylabel('GEP Scaling Factor, GEP \mu mol C m^{-2}s^{-1}','FontSize',18);
    xlabel('T_{soil}   ^{o}C','FontSize',22)
    set(gca,'FontSize',22)
    legend([h1 h2 h3],'Observed','Averaged','Modeled',2)
    print('-dbmp',[fig_path 'Ts_GEPsf'])
    print('-depsc',[fig_path 'Ts_GEPsf'])



%% Create GEP scaling factor for Ts
GEP_Ts_sf = b_Ts(1)./(1+exp(b_Ts(2).*(b_Ts(3)-Ts1)));
GEP_Ts_sf(GEP_Ts_sf > 1) = 1;
GEP_Ts_sf(Ts1 < 0) = 0;

% GEP_T_air_red = GEP_max .* GEP_T_air_sf;
GEP_T_air_sf(GEP_T_air_sf > 1) = 1;
GEP_T_air_sf(T_air1 < -5) = 0;
%  GEP_Ts_sf=GEP_T_air_sf;

%% Remove influence of Ts on GEP:
GEP_Ts_red = GEP_max .* GEP_Ts_sf; % modeled GEP with soil temperature influence included
GEP_Ts_adj = GEP1 ./ GEP_Ts_sf;


%% STEP 2. VPD logistic function:
clear kk ss vpd;
%%% Divide the day into 3 separate times, based on PAR values:
PAR_bottoms = [0 500  1200]';
PAR_tops =  [500 1200 2200]';

figure(9)
clf;
figure(91)
clf;

for kk = 1:1:length(PAR_bottoms)
    %%% These values should be adjusted according to site characteristics:
    vpd_ind = find(Ts1 > 8  & T_air1 > 10 & PAR1 > 20 & ~isnan(VPD1) ...
        & ~isnan(GEP1) & dt1 > 120 & dt1 < 270  ...
        & PAR1 > PAR_bottoms(kk) & PAR1 <= PAR_tops(kk) & SM1 > 0.08);

    %%% Plot raw data points for GEP_model = 1
    figure(9)
    title('Data for Ts, VPD & SM GEP Model')
    subplot(2,2,kk)
    plot(VPD1(vpd_ind,1),GEP_Ts_adj(vpd_ind,1),'b.')
    title([num2str(PAR_tops(kk)) ' > PAR > ' num2str(PAR_bottoms(kk))]);
    %%% Plot raw data points for GEP_model = 2
    figure(91)
    title('Data for T_air, Ts, VPD & SM GEP Model')
    subplot(2,2,kk)
    plot(VPD1(vpd_ind,1),GEP_T_air_adj(vpd_ind,1),'b.')
    title([num2str(PAR_tops(kk)) ' > PAR > ' num2str(PAR_bottoms(kk))]);
    
    % Bin-average data:
    vpd(kk).bavg = jjb_blockavg(VPD1(vpd_ind,1),GEP_Ts_adj(vpd_ind,1), 0.2, 40, 0); % for model 1
    vpd2(kk).bavg = jjb_blockavg(VPD1(vpd_ind,1),GEP_T_air_adj(vpd_ind,1), 0.2, 40, 0); % for model 1
    
    %%% Plot bin-averaged data - model 1
    figure(9)
    subplot(2,2,kk)
    hold on;
    plot(vpd(kk).bavg(:,1), vpd(kk).bavg(:,2), 'ro')
    axis([0 3 0 30])
    %%% Plot bin-averaged data - model 2
    figure(91)
    subplot(2,2,kk)
    hold on;
    plot(vpd2(kk).bavg(:,1), vpd2(kk).bavg(:,2), 'ro')
    axis([0 3 0 30])
       
    clear vpd_ind;     
end
%%% Depending on the similarity of each curve, may have to use different
%%% curve for each, however, curves are fairly similar for TP site, so use
%%% the PAR 1200 - 2200 dataset as the model
if GEP_model == 1 || GEP_model == 3 || GEP_model == 5 || GEP_model == 6
vpd_bavg = vpd(3).bavg; %% VPD vs GEP for PAR > 1200 - model 1
vpd_bavg2 = vpd(2).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 -model 1
vpd_bavg3 = vpd(1).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 - model 1
% These must be adjusted to fit the PAR > 1200 data, by looking at values
% in vpd_bavg
max_VPD = 20.5;
min_VPD = 12.1;
VPD_x = [-0.3; -0.15; 0; vpd_bavg(5:19,1); 3.2; 3.5;  3.9 ];
VPD_y = [max_VPD+0.5; max_VPD+0.5; max_VPD; vpd_bavg(5:19,2); min_VPD; min_VPD; min_VPD];
max_VPD2 = 17;
min_VPD2 = 9.5;
VPD_x2 = [-0.15; 0; 0.15; vpd_bavg2(6:15,1); 3.2; 3.5;  3.9 ];
VPD_y2 = [max_VPD2; max_VPD2; max_VPD2;  vpd_bavg2(6:15,2); min_VPD2; min_VPD2; min_VPD2];
elseif GEP_model == 2 
vpd_bavg = vpd2(3).bavg; %% VPD vs GEP for PAR > 1200 - model 2
vpd_bavg2 = vpd2(2).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 -model 2
vpd_bavg3 = vpd2(1).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 - model 2
% These must be adjusted to fit the PAR > 1200 data, by looking at values
% in vpd_bavg
max_VPD = 22;
min_VPD = 14;
VPD_x = [-0.15; 0; vpd_bavg(5:18,1); 3.2; 3.5;  3.9 ];
VPD_y = [max_VPD;  max_VPD;  vpd_bavg(5:18,2); min_VPD; min_VPD; min_VPD];
max_VPD2 = 19;
min_VPD2 = 9.5;
VPD_x2 = [-0.15; 0; 0.15; vpd_bavg2(5:15,1); 3.2; 3.5;  3.9 ];
VPD_y2 = [max_VPD2; max_VPD2; max_VPD2;  vpd_bavg2(5:15,2); min_VPD2; min_VPD2; min_VPD2];

elseif GEP_model == 4 
vpd_bavg = vpd2(3).bavg; %% VPD vs GEP for PAR > 1200 - model 2
vpd_bavg2 = vpd2(2).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 -model 2
vpd_bavg3 = vpd2(1).bavg; %% VPD vs GEP for PAR > 500 PAR < 1200 - model 2
% These must be adjusted to fit the PAR > 1200 data, by looking at values
% in vpd_bavg
max_VPD = 23.7;
min_VPD = 14;
VPD_x = [-0.15; 0; vpd_bavg(5:18,1); 3.2; 3.5;  3.9 ];
VPD_y = [max_VPD;  max_VPD;  vpd_bavg(5:18,2); min_VPD; min_VPD; min_VPD];
max_VPD2 = 19;
min_VPD2 = 9.5;
VPD_x2 = [-0.15; 0; 0.15; vpd_bavg2(5:15,1); 3.2; 3.5;  3.9 ];
VPD_y2 = [max_VPD2; max_VPD2; max_VPD2;  vpd_bavg2(5:15,2); min_VPD2; min_VPD2; min_VPD2];



end

VPD_test = (0:0.25:3);

%%% Normalize values:
VPD_y = (VPD_y - min_VPD)./(max_VPD-min_VPD);
VPD_y2 = (VPD_y2 - min_VPD2)./(max_VPD2-min_VPD2);

%%% Fit these data with a logistic model:
[b_VPD,y_VPD,stats_VPD,sigma_VPD] = fitmain([1 1 1], 'fitlogi5', VPD_x, VPD_y);
p_VPD = (b_VPD(1).*(max_VPD-min_VPD))./(1+exp(b_VPD(2).*(b_VPD(3)-VPD_x))) + min_VPD;
p_n_VPD = b_VPD(1)./(1+exp(b_VPD(2).*(b_VPD(3)-VPD_x)));

%%% Fit these data with a logistic model:
[b_VPD2,y_VPD2,stats_VPD2,sigma_VPD2] = fitmain([1 1 1], 'fitlogi5', VPD_x2, VPD_y2);
p_VPD2 = (b_VPD2(1).*(max_VPD2-min_VPD2))./(1+exp(b_VPD2(2).*(b_VPD2(3)-VPD_x2))) + min_VPD2;
p_n_VPD2 = b_VPD2(1)./(1+exp(b_VPD2(2).*(b_VPD2(3)-VPD_x2)));

%% Create GEP scaling factor for VPD when PAR > 1200
GEP_VPD_sf1 = ((b_VPD(1).*(max_VPD-min_VPD))./(1+exp(b_VPD(2).*(b_VPD(3)-VPD1))) + min_VPD)./max_VPD;
GEP_VPD_sf1(GEP_VPD_sf1 > 1) = 1;

%%% Create GEP scaling factor for VPD when 1200 > PAR > 500
GEP_VPD_sf2 = ((b_VPD2(1).*(max_VPD2-min_VPD2))./(1+exp(b_VPD2(2).*(b_VPD2(3)-VPD1))) + min_VPD2)./max_VPD2;
GEP_VPD_sf2(GEP_VPD_sf2 > 1) = 1;

%%% Put scaling factors together:
GEP_VPD_sf(1:length(VPD1),1) = 1;
GEP_VPD_sf(PAR1 > 1200,1) = GEP_VPD_sf1(PAR1 > 1200,1);
GEP_VPD_sf(PAR1 > 500 & PAR1 <= 1200,1) = GEP_VPD_sf2(PAR1 > 500 & PAR1 <= 1200,1);


%% Plot the VPD reduction factor (0 to 1) for influence on GEP
figure(10)
clf;
subplot(2,1,1)
plot(VPD_x, VPD_y, 'b.')
hold on;
plot(VPD_x, p_n_VPD,'r')

subplot(2,1,2)
plot(VPD_x2, VPD_y2, 'b.')
hold on;
plot(VPD_x2, p_n_VPD2,'r')

%%
figure(44); clf
plot(VPD_x, VPD_y, 'ro','MarkerSize',10,'MarkerFaceColor','k')
hold on;
p_n_VPD(p_n_VPD > 1) = 1;
plot(VPD_x, p_n_VPD,'r','LineWidth',4)
set(gca,'YGrid','on')
axis([0 2 0 1.2])
% text(-4.5,1 ,'12.5','FontSize',20,'Color','k')
% text(-4.5,0 ,'0','FontSize',20,'Color','k')
    ylabel('GEP Scaling Factor','FontSize',22);
    xlabel('VPD   kPa','FontSize',22)
    set(gca,'FontSize',12)
    legend('Averaged','Modeled',3)
 line([0 2], [1 1],'LineStyle','--','Color','b','LineWidth',3)
YTicks = [0 0.25 0.5 0.75 1];
YTicklab = ['0.50'; '0.63'; '0.75';'0.88';'1.00'];
set(gca,'YTick',YTicks,'YTickLabel', YTicklab);
       print('-dbmp',[fig_path 'VPD_GEPsf'])
    print('-depsc',[fig_path 'VPD_GEPsf'])
    
%% Reduce MAX GEP according to VPD relationship:
if GEP_model ~=2 
GEP_TsVPD_red = GEP_Ts_red .* GEP_VPD_sf; % modeled GEP with soil temperature influence included
%%% New adjusted GEP (removing effects of soil temperature and VPD)
GEP_TsVPD_adj = GEP_Ts_adj ./ GEP_VPD_sf;
elseif GEP_model ==2
GEP_TsVPD_red = GEP_T_air_red .* GEP_VPD_sf; % modeled GEP with soil temperature influence included
%%% New adjusted GEP (removing effects of soil temperature and VPD)
GEP_TsVPD_adj = GEP_T_air_adj ./ GEP_VPD_sf;   
% elseif GEP_model ==3
% GEP_TsVPD_red = GEP_T_air_red;  % modeled GEP with soil temperature influence included
% %%% New adjusted GEP (removing effects of soil temperature and VPD)
% GEP_TsVPD_adj = GEP_T_air_adj; 
end

%% Step 4. Hyperbolic (or logistic) SM function to control GEP at low soil
%%%%%%%%%% moistures

SM_ind = find(Ts1 > 5 & T_air1 > 4 & PAR1 > 20 & PAR1 < 2200 & ~isnan(SM1) ...
    & ~isnan(GEP1) & dt1 > 90 & dt1 < 330  ...
    & SM1 > 0.04 & SM1 <= 0.1 ); %& VPD1 < 1.0

figure(11)
clf;
plot(SM1(SM_ind),GEP_TsVPD_adj(SM_ind),'b.'); %GEP_TsVPD_adj
hold on;

%%% Block average values
SM_bavg = jjb_blockavg(SM1(SM_ind,1),GEP_TsVPD_adj(SM_ind,1), 0.0025, 40, 0);

figure(11)
plot(SM_bavg(:,1),SM_bavg(:,2),'ro');
% clear SM_ind

%%% Set data to be used to make model:
if GEP_model == 2 
min_SM = 11.651;
max_SM = 17;
SM_x = [SM_bavg(1:21,1); (0.10:0.01:0.25)' ]-0.05;
SM_y = [SM_bavg(1:21,2); max_SM.*ones(16,1) ];
fudge_fac = 0.0446;
elseif GEP_model == 1 || GEP_model == 3 || GEP_model == 5 || GEP_model == 6
min_SM = 11.996;
max_SM = 15;
SM_x = [SM_bavg(1:21,1); (0.10:0.01:0.25)' ]-0.047;
SM_y = [SM_bavg(1:21,2); max_SM.*ones(16,1) ];  
fudge_fac = 0.04661;
elseif GEP_model == 4
min_SM = 9.7388;
max_SM = 14;
SM_x = [SM_bavg(1:21,1); (0.10:0.01:0.25)' ]-0.05;
SM_y = [SM_bavg(1:21,2); max_SM.*ones(16,1) ];  
fudge_fac = 0.04498;


end

%%% Normalize
SM_y = (SM_y )./(max_SM );

%%% Fit hyperbolic function to data:
[coeff_SM y_SM r2_SM sigma_SM] = hypmain1([1 1 1], 'fit_hyp1', SM_x, SM_y);

%%% Predict Relationship
P_SM = coeff_SM(1).*(SM_x).*coeff_SM(2)./(coeff_SM(1).*(SM_x) + coeff_SM(2));

%%% Plot Relationship
figure(12)
clf;
plot(SM_x, SM_y,'b.')
hold on;
plot(SM_x, P_SM, 'kx-', 'LineWidth', 2);

figure(45)
clf;
P_SM(P_SM > 1) = 1;
% plot(SM1(SM_ind),GEP_TsVPD_adj(SM_ind)./16,'k.','MarkerSize',10); 
hold on;
plot(SM_bavg(:,1),SM_bavg(:,2)./16,'ro','MarkerSize',10,'MarkerFaceColor','k');
axis([0.045 0.075 0.5 1.2 ])
plot(SM_x+0.046, P_SM, 'r-', 'LineWidth', 4);
set(gca,'YGrid','on')
line([0.045 0.075], [1 1],'LineStyle','--','Color','b','LineWidth',3)

    ylabel('GEP Scaling Factor','FontSize',22);
    xlabel('\theta _{V}  %','FontSize',22)
    set(gca,'FontSize',22)
    legend('Averaged','Modeled',2)
 
% YTicks = [0 0.25 0.5 0.75 1];
% YTicklab = ['0.50'; '0.63'; '0.75';'0.88';'1.00'];
% set(gca,'YTick',YTicks,'YTickLabel', YTicklab);
       print('-dbmp',[fig_path 'SM_GEPsf'])
    print('-depsc',[fig_path 'SM_GEPsf'])



%% Scaling Factor for SM

GEP_SM_sf = coeff_SM(1).*(SM1-fudge_fac).*coeff_SM(2)./(coeff_SM(1).*(SM1-fudge_fac) + coeff_SM(2));
GEP_SM_sf(GEP_SM_sf > 1) = 1;
GEP_SM_sf(isnan(GEP_SM_sf)) = 1;
GEP_SM_sf(GEP_SM_sf < (min_SM/max_SM)) = (min_SM/max_SM);

%% Plot the Scaling factor to make sure it works properly
figure(13)
clf;
plot(GEP_SM_sf)


%% Reduce GEP model by SM scaling factor:

GEP_all_red = GEP_TsVPD_red .* GEP_SM_sf;
% GEP_all_red = GEP_TsVPD_red %GEP_TsVPD_red; % uncomment this to bypass scaling factors
% GEP_all_red = GEP_pred;
% GEP_all_red = GEP_Ts_red;
%% Compare Raw GEP with maximum and modeled GEP
figure(14)
plot(GEP1,'b');
hold on;
plot(GEP_max,'g')
plot(GEP_all_red,'r')
plot(GEP_pred,'m')
 






%%
if GEP_model == 5 || GEP_model == 6;
    GEP_all_red = GEP_pred;
end
%% Calculate annual GEP:

% - calculate totals for NEE, GEP & modeled GEP.


%% Clean NEE
NEE1(NEE1 < -35 | NEE1 > 20, 1) = NaN;
NEE1(PAR1 <= 20 & NEE1 <= 0, 1) = NaN;     % no photosynthesis at dark
% NEE1(Ts1 <= 0 & NEE1 <= 0, 1) = NaN;    % no photosynthesis when soil is frozen
% NEE1(Ts1 <= 0 & NEE1 > 1.2, 1) = NaN;
NEE1(71100:72750,1) = NaN; % Remove obvious period of bad data
NEE1(Ts1 <= 5 & NEE1 >= 7, 1) = NaN;    % nighttime & low-temp respiration cap
NEE1(PAR1 <= 20 & NEE1 >= 15, 1) = NaN;    % nighttime respiration cap
NEE1(ustar1 < ustar_th) = NaN;
NEE1_clean = NEE1;

%%
% NEP_pred = GEP_pred-Resp1;
% NEP_real = -1*NEE1_clean;
% NEP_model = GEP_all_red - Resp1;
% colors = colormap(lines(10));
% 
% figure(46); clf
% plot(NEP_real,'-','Color',colors(1,:));
% hold on
% plot(NEP_pred,'-','Color',colors(2,:));
% plot(NEP_model,'-','Color',colors(3,:))
% 
% figure(47); clf
% NEP_pred(dt1 < 90 | dt1 > 330) = 0;




clear NEP_model NEP_real NEP_pred
%% Calculate % coverage for each year:
len_yr = [365;366;365;365;365];

ctr = 1;
for j = 1:17568:70273
    ok = find(~isnan(NEE1_clean(j:j+17567,1)));
    cover(1,ctr) = length(ok)./(len_yr(ctr).*48);
    clear ok;
    ctr = ctr+1;
end

cover(1,6) = mean(cover(1,1:5));




%% Clean GEP

clear GEP1;
GEP1 = Resp1 - NEE1;


GEP_all_red(dt1< 85 | dt1 > 335) = 0;

GEP1(GEP1 < 0) = NaN;
GEP1(dt1 < 85 | dt1 > 335) = 0;
GEP1(PAR1 < 10) = 0;
%%% Create these two to see how GEP is changed by different operations on it
GEP_clean = GEP1;
GEP_raw_fill = GEP_clean;
%% Plot Measured vs. modeled GEP:
% Model seems to overestimate measured GEP for most years -- investigate

% Block average data
GEPa_bavg = jjb_blockavg(GEP1(:,1),GEP_all_red(:,1), 1, 50, 0);
GEP2003_bavg = jjb_blockavg(GEP1(year1==2003,1),GEP_all_red(year1==2003,1), 1, 50, 0);
GEP2004_bavg = jjb_blockavg(GEP1(year1==2004,1),GEP_all_red(year1==2004,1), 1, 50, 0);
GEP2005_bavg = jjb_blockavg(GEP1(year1==2005,1),GEP_all_red(year1==2005,1), 1, 50, 0);
GEP2006_bavg = jjb_blockavg(GEP1(year1==2006,1),GEP_all_red(year1==2006,1), 1, 50, 0);
GEP2007_bavg = jjb_blockavg(GEP1(year1==2007,1),GEP_all_red(year1==2007,1), 1, 50, 0);
figure(15)
clf;

subplot(2,2,1); plot(GEP1,GEP_all_red,'b.');title('all years'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,1); plot(GEPa_bavg(:,1),GEPa_bavg(:,2),'ro');
subplot(2,2,2); plot(GEP1(year1==2003),GEP_all_red(year1==2003),'b.'); title('2003'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,2); plot(GEP2003_bavg(:,1),GEP2003_bavg(:,2),'ro');
subplot(2,2,3); plot(GEP1(year1==2004),GEP_all_red(year1==2004),'b.'); title('2004'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,3); plot(GEP2004_bavg(:,1),GEP2004_bavg(:,2),'ro');
subplot(2,2,4); plot(GEP1(year1==2005),GEP_all_red(year1==2005),'b.'); title('2005'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,4); plot(GEP2005_bavg(:,1),GEP2005_bavg(:,2),'ro');
ylabel('modeled GEP'); xlabel('real GEP')

figure(16)
clf;
subplot(2,2,1); plot(GEP1(year1==2006),GEP_all_red(year1==2006),'b.'); title('2006'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,1); plot(GEP2006_bavg(:,1),GEP2006_bavg(:,2),'ro');
subplot(2,2,2); plot(GEP1(year1==2007),GEP_all_red(year1==2007),'b.'); title('2007'); line([0 30],[0 30],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(2,2,2); plot(GEP2007_bavg(:,1),GEP2007_bavg(:,2),'ro');
ylabel('modeled'); xlabel('real GEP')



%% Fill empty GEPs with modeled GEP
GEP1(isnan(GEP1)) = GEP_all_red(isnan(GEP1));

GEP_raw_fill(isnan(GEP_raw_fill)) = GEP_all_red(isnan(GEP_raw_fill));

%% Another Check for GEP:
figure(17)
clf;
plot(GEP1,'b')
hold on;
plot(GEP_raw,'g');
plot(GEP_clean,'b');
plot(GEP_all_red,'c')
plot(Ts1,'m')
plot(Resp1,'r')

colors = colormap(lines(10));
GEP_pred2 = GEP_pred;
GEP_pred2(dt1 < 85 | dt1 > 335) = 0;

figure(46); clf;
plot(GEP1,'.','Color', colors(1,:),'MarkerSize',10,'LineWidth',3)
hold on;
plot(GEP_pred2,'.','Color', colors(5,:),'MarkerSize',10,'LineWidth',3)
plot(GEP_all_red,'.','Color', colors(6,:),'MarkerSize',10,'LineWidth',3)
% legend('Observed',')
axis([0 87480 -0.5 40])
XTicks = (0:4397:87840)';
XTickLabels = ['Jan';'   '; 'Jul';'   '; ...
               'Jan';'   ';'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   '; 'Jul';'   '; ...
                'Jan';'   ';'Jul';'   '];
                
set(gca,'XTick',XTicks)
set(gca,'XTickLabel',XTickLabels,'FontSize',20,'TickDir','out')
for mult = 1:1:5
     txt = yrlist(mult,:);
line([17568.*mult 17568.*mult],[0 40], 'LineStyle','--','Color','k','LineWidth',4)
text(4000+17568*(mult-1),1.01,txt,'FontSize',22,'Color','k')
ylabel('GEP \mu mol C m^{-2}s^{-1}','FontSize',22);
% legend('Observed','Average', 'Richardson',2)
end
print('-dbmp',[fig_path 'GEP_comp'])
print('-depsc',[fig_path 'GEP_comp'])



figure(47);clf
plot(GEP1(62832:62832+(48*4)),'s','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(1,:))
hold on;
plot(GEP_pred2(62832:62832+(48*4)),'v','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(5,:))
plot(GEP_all_red(62832:62832+(48*4)),'o','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(6,:))
XTicks = (1:48:(48*4));
ylabel('GEP \mu mol C m^{-2}s^{-1}','FontSize',22);
xlabel('July-August, 2006','FontSize',22);
axis([1 48*4 -1 30]);
st = 210;
for k = 1:1:4
XTickLab(k,:) = datestr(datenum(2006,0,st,0,0,0),6);
st = st+1;
end

set(gca,'XTick',XTicks, 'XTickLabel',XTickLab, 'FontSize',22)
% legend('Observed','Average', 'Richardson',2)
print('-dbmp',[fig_path 'GEP_summer'])
print('-depsc',[fig_path 'GEP_summer'])


figure(48); clf;
plot(GEP1(68350:68350+(48*4)),'s','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(1,:))
hold on;
plot(GEP_pred2(68350:68350+(48*4)),'v','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(5,:))
plot(GEP_all_red(68350:68350+(48*4)),'o','MarkerEdgeColor', 'k','MarkerSize',8,'MarkerFaceColor',colors(6,:))
XTicks = (1:48:(48*4));
ylabel('GEP \mu mol C m^{-2}s^{-1}','FontSize',22);
xlabel('November, 2006','FontSize',22);
axis([1 48*4 -1 15]);
st = 325;
for k = 1:1:4
XTickLab(k,:) = datestr(datenum(2006,0,st,0,0,0),6);
st = st+1;
end

set(gca,'XTick',XTicks, 'XTickLabel',XTickLab, 'FontSize',22)
% legend('Observed','Average', 'Richardson',2)
print('-dbmp',[fig_path 'GEP_spring'])
print('-depsc',[fig_path 'GEP_spring'])


%% Compare NEE from times when we have real measurements to modeled data:

NEE_model = Resp1-GEP_all_red;
figure(19)
clf;
for jj = 2003:1:2007
    ctr = jj-2002;
 good(ctr).NEE = find(year1 == jj & ~isnan(NEE1_clean));
 NEE_clean_sum(ctr,1) = nansum(NEE1_clean(good(ctr).NEE)).*0.0216;
 NEE_model_sum(ctr,1) = nansum(NEE_model(good(ctr).NEE)).*0.0216;

NEEbavg(ctr).bavg = jjb_blockavg(NEE1_clean(good(ctr).NEE,1),NEE_model(good(ctr).NEE,1), 1, 20, -50);

subplot(3,2,ctr); plot(NEE1_clean(good(ctr).NEE,1), NEE_model(good(ctr).NEE,1),'b.');title(['year: ' num2str(jj)]); line([-50 20],[-50 20],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(3,2,ctr); plot(NEEbavg(ctr).bavg(:,1),NEEbavg(ctr).bavg(:,2),'ro');

end
% All years:
ctr = ctr+1;
good(ctr).NEE = find(~isnan(NEE1_clean));
NEEbavg(ctr).bavg = jjb_blockavg(NEE1_clean(good(ctr).NEE,1),NEE_model(good(ctr).NEE,1), 1, 20, -50);

subplot(3,2,ctr); plot(NEE1_clean(good(ctr).NEE,1), NEE_model(good(ctr).NEE,1),'b.');title('all years'); line([-50 20],[-50 20],'Color',[1 0 0],'LineWidth',3);
hold on; subplot(3,2,ctr); plot(NEEbavg(ctr).bavg(:,1),NEEbavg(ctr).bavg(:,2),'ro');
ylabel('modeled'); xlabel('real NEE')

%% Clean Respiration and fill in values from the night that are good:
Resp_filled(1:length(dt1),1) = NaN;
%%% Nighttime value filled by model
Resp_filled(PAR1 < 10) = Resp1(PAR1 < 10);

%%% Nighttime with ustar > critical overwritten with measured NEE
Resp_filled(PAR1 < 10 & ustar1 >= ustar_th & ~isnan(NEE1)) = NEE1(PAR1 < 10 & ustar1 >= ustar_th & ~isnan(NEE1));

%%% Daytime Growing Season R with Model
Resp_filled(PAR1 >= 10 & dt1 >= 85 & dt1 <= 335) = Resp1(PAR1 >= 10 & dt1 >= 85 & dt1 <= 335);
% Resp(PAR > 10 & dt >= gsstart & dt <= gsend) = 25;

%%% All other times filled with model
%%% Daytime Non - Growing Season R with Model
Resp_filled(PAR1 >= 10 & (dt1 < 85 | dt1 > 335) & ~isnan(NEE1)) = NEE1(PAR1 >= 10 & (dt1 < 85 | dt1 > 335) & ~isnan(NEE1));

%%% Transpose and remove where Resp < 0
% Resp = Resp';
Resp_filled(Resp_filled < 0 | isnan(Resp_filled)) = Resp1(Resp_filled < 0 | isnan(Resp_filled));

%% Fill NEE
ind_bn_NEE = find(PAR1 < 10 & (isnan(NEE1) | ustar1 < ustar_th));
NEE1(ind_bn_NEE) = Resp1(ind_bn_NEE);

%%% Fill in data for outside of G.S. during the day
ind_nongs_NEE = find(PAR1 >= 10 & (isnan(NEE1) | ustar1 < ustar_th) & (dt1 < 85 | dt1 > 335));
NEE1(ind_nongs_NEE) = Resp1(ind_nongs_NEE);

%%% Replace for day when values are missing
ind_gs_NEE = find(PAR1 >= 10 & (isnan(NEE1) | ustar1 < ustar_th) & dt1 >= 85 & dt1 <= 335);
NEE1(ind_gs_NEE) = Resp1(ind_gs_NEE) - GEP_all_red(ind_gs_NEE);

%% Calculate final numbers:
Results(1:5,1:20) = NaN;
for mm = 2003:1:2007
    ctr_year = mm-2002;

    NEE_yr = NEE1(year1==mm);
    NEE_raw_yr = NEE_raw(year1 ==mm);
    Resp_filled_yr = Resp_filled(year1==mm);
    Resp_modeled_yr = Resp1(year1==mm);
    GEP_filled_yr = GEP1(year1==mm);
    GEP_modeled_yr = GEP_all_red(year1==mm);
    GEP_clean_yr = GEP_clean(year1==mm);
    GEP_raw_fill_yr = GEP_raw_fill(year1==mm);
    
    output = [dt1(year1 == mm) -1.*NEE_raw_yr -1*NEE_yr Resp_filled_yr GEP_filled_yr T_air1(year1 == mm) Ts1(year1 == mm) SM1(year1 == mm) PAR1(year1 == mm)];

    save([path 'M' site 'output_model' num2str(GEP_model)  '_' num2str(mm) '.dat'],'output','-ASCII');
    clear output;

    sum_NEE = nansum(NEE_yr).*0.0216;
    sum_Resp_filled = nansum(Resp_filled_yr).*0.0216;
    sum_Resp_modeled = nansum(Resp_modeled_yr).*0.0216;
    sum_GEP_filled = nansum(GEP_filled_yr).*0.0216;
    sum_GEP_modeled = nansum(GEP_modeled_yr).*0.0216;
    sum_GEP_clean = nansum(GEP_clean_yr).*0.0216;
    sum_GEP_raw_fill = nansum(GEP_raw_fill_yr).*0.0216;
    
    used_NEE = length(find(isnan(NEE_yr)==0));
    used_Resp_filled = length(find(isnan(Resp_filled_yr)==0));
    used_Resp_modeled = length(find(isnan(Resp_modeled_yr)==0));
    used_GEP_filled = length(find(isnan(GEP_filled_yr)==0));
    used_GEP_modeled = length(find(isnan(GEP_modeled_yr)==0));
    used_GEP_clean = length(find(isnan(GEP_clean_yr)==0));
    used_GEP_raw_fill = length(find(isnan(GEP_raw_fill_yr)==0));
    used_NEE_clean = length(good(ctr_year).NEE);
    
    Results(ctr_year,1:18) = [mm sum_NEE          used_NEE           sum_Resp_filled   used_Resp_filled ...
                              sum_Resp_modeled used_Resp_modeled  sum_GEP_filled    used_GEP_filled ...
                              sum_GEP_modeled  used_GEP_modeled   sum_GEP_clean       used_GEP_clean ... 
                              sum_GEP_raw_fill used_GEP_raw_fill NEE_clean_sum(ctr_year,1) used_NEE_clean ...
                              NEE_model_sum(ctr_year,1)];


    clear NEE_yr Resp_filled_yr Resp_modeled_yr GEP_filled_yr GEP_modeled_yr GEP_clean_yr GEP_raw_fill_yr;
    clear used_NEE used_Resp_filled used_Resp_modeled used_GEP_filled used_GEP_modeled used_NEE_clean;
    clear sum_NEE sum_Resp_filled sum_Resp_modeled sum_GEP_clean sum_GEP_modeled sum_GEP_clean sum_GEP_raw_fill
    
end

save([path 'M' site '_model' num2str(GEP_model) '_flux_results.dat'],'Results','-ASCII');

%% Prepare Output file to use in plotting variables and doing further
%% analysis

M1_output.GEP = GEP1; M1_output.R = Resp_filled; M1_output.NEE = NEE1;
M1_output.GEP_PAR = GEP_PAR; M1_output.est_R = est_R;
save ([path 'M' site '_model' num2str(GEP_model) '_output.mat'], 'M1_output');

% clear all


%%
TP39_GEPmodel_stats;



