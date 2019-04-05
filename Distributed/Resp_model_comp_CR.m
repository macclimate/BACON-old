%% Specify paths and options
clear all
close all
st_yr = 2003;
end_yr = 2005;
n_yrs = end_yr - st_yr +1;
model_type = 1;  
ustar_th = 0.3;
% 1 specifies models for each separate year, 
% 2 specifies average resp model and yearly GEP, and 
% 3 specifies average models for both
% 4 specifies each seperate year, using Ta > 8
% 5 specifies avg resp eqn, using Ta > 8
GEP_model = 1; 
% 1 -- Ts, VPD, SM
% 2 -- Tair, Ts, VPD and SM

path = 'C:\MacKay\data\CR0305\';
site = 'CR'; % switch to 'OR' for Oregon

% [T_air1 PAR1 Ts1 Ts51 SM1 NEE1 ustar1 dt1 year1 WS1 Wdir1 VPD1]

if exist([path site '_Fluxdata.dat']) == 2;
all_vars = load([path site '_Fluxdata.dat']);
T_air1 = all_vars(:,1);
PAR1 = all_vars(:,2);
Ts2 = all_vars(:,3);
Ts5 = all_vars(:,4);
SM1 = all_vars(:,5);
NEE1 = all_vars(:,6); %NEE1(NEE1 > 35 | NEE1 < -35) = NaN;
ustar1 = all_vars(:,7);
dt1 = all_vars(:,8);
year1 = all_vars(:,9);
WS1 = all_vars(:,10);
Wdir1 = all_vars(:,11);
VPD1 = all_vars(:,12);
else 
    disp('Where is the data?')
end

%% For the time being.... use 5cm soil temp as the main one:

Ts1 = Ts5;

%% Establish Ts vs Re relationship:

Ts_test = (-4:2:20)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;
for jj = st_yr:1:end_yr
    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts1 > 0 & PAR1 < 100 & ~isnan(Ts1) & ~isnan(NEE1) & year1 == jj & ustar1 > ustar_th & NEE1 < 60 & NEE1 > -25);%
    ind_regress2 = find(Ts1 > 0 & PAR1 < 10 & ~isnan(Ts1) & ~isnan(NEE1) & year1 == jj & ustar1 > ustar_th & NEE1 < 60 & NEE1 > -25);%
    Resp(counter).ind = ind_regress;
    Resp(counter).ind2 = ind_regress2;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts1(ind_regress), NEE1(ind_regress), 0.5,60, -25);  
Resp(counter).bavg2 = jjb_blockavg(Ts1(ind_regress2), NEE1(ind_regress2), 0.5,60, -25);
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
ind_okdata2 = find(~isnan(Resp(counter).bavg2(:,1).*Resp(counter).bavg2(:,2)));
%%% Step 3: Use logistic function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitlogi5', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
[Resp(counter).coeff2,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma2] = fitmain([5 .1 .1], 'fitlogi5', Resp(counter).bavg2(ind_okdata2,1), Resp(counter).bavg2(ind_okdata2,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));
X2 = [Resp(counter).bavg2(ind_okdata2,1) ones(length(Resp(counter).bavg2(ind_okdata2,1)),1)];
        [b_ln2,bint_ln2,r_ln2,rint_ln2,stats_ln2] = regress_analysis(log(Resp(counter).bavg2(ind_okdata2,2)),X2,0.05);
        pR_ln2 = (exp(b_ln2(2))).* exp(Resp(counter).bavg2(ind_okdata2,1).*b_ln2(1));
%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));
Resp(counter).est_R2 = Resp(counter).coeff2(1) ./(1 + exp(Resp(counter).coeff2(2).*(Resp(counter).coeff2(3)-Ts_test)));
    %%% exponential
Resp(counter).est_exp = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));
Resp(counter).est_exp2 = (exp(b_ln2(2))).* exp(Ts_test.*b_ln2(1));
%%% Plot this stuff:
figure(2)
 subplot(2,2,counter);
plot (Ts1(ind_regress),NEE1(ind_regress),'k.');
    hold on;
    plot(Ts_test, Resp(counter).est_R,'r-');
    plot(Ts_test,Resp(counter).est_exp,'g-.')
plot (Ts1(ind_regress2),NEE1(ind_regress2),'ko');
    hold on;
    plot(Ts_test, Resp(counter).est_R2,'r--');
    plot(Ts_test,Resp(counter).est_exp2,'g--x')
    
    
figure(1)
plot(Ts_test, Resp(counter).est_R,'Color',plot_color(counter,1:3));
plot(Ts_test, Resp(counter).est_exp,'Color',plot_color(counter,1:3));
hold on;
plot(Ts_test, Resp(counter).est_R2,'Color',plot_color(counter,1:3));
plot(Ts_test, Resp(counter).est_exp2,'Color',plot_color(counter,1:3));

figure(99)
 subplot(2,2,counter);
plot(Ts1(ind_regress),NEE1(ind_regress),'k.');
hold on;
plot(Ts1(ind_regress2),NEE1(ind_regress2),'bo');
legend('PAR < 100','PAR < 10',2);
%%% Count the number of data points in the year for which Respiration will
%%% be modeled:
    ind_yr = find(year1==jj);
%     used_data = length(find(~isnan(Ts1(ind_yr))==1));
    
%%% Estimate Respiration for the whole year, based on Ts data:
    Resp(counter).resp = Resp(counter).coeff(1)./(1+exp(Resp(counter).coeff(2)*(Resp(counter).coeff(3)-Ts1(ind_yr))));
    Resp(counter).lnresp = (exp(b_ln(2))).* exp(Ts1(ind_yr).*b_ln(1));

Resp(counter).resp2 = Resp(counter).coeff2(1)./(1+exp(Resp(counter).coeff2(2)*(Resp(counter).coeff2(3)-Ts1(ind_yr))));
    Resp(counter).lnresp2 = (exp(b_ln2(2))).* exp(Ts1(ind_yr).*b_ln2(1));

%%% Do some stats on each model to see which fits best to measured data:

exp_RMSE_all(counter,1) = sqrt((sum((Resp(counter).lnresp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)).^2))./(length(ind_regress)-2));
log_RMSE_all(counter,1) = sqrt((sum((Resp(counter).resp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)).^2))./(length(ind_regress)-2));

exp_rRMSE_all(counter,1) = sqrt((sum((Resp(counter).lnresp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)).^2))./(sum(NEE1(ind_regress).^2)));
log_rRMSE_all(counter,1) = sqrt((sum((Resp(counter).resp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)).^2))./(sum(NEE1(ind_regress).^2)));

exp_MAE(counter,1) = (sum(abs(Resp(counter).lnresp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress))))./(length(ind_regress));
log_MAE(counter,1) = (sum(abs(Resp(counter).resp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress))))./(length(ind_regress));

exp_BE(counter,1) = (sum(Resp(counter).lnresp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)))./(length(ind_regress));
log_BE(counter,1) = (sum(Resp(counter).resp(ind_regress-((counter-1).*17568)) - NEE1(ind_regress)))./(length(ind_regress));


clear  ind_regress ind_yr used_data;    
counter = counter+1;
end

%% Put all years together to make one column vector with all Resp data: 
Resp1 = [Resp(1).resp ;NaN*ones(48,1); Resp(2).resp; Resp(3).resp; NaN*ones(48,1)];
Resp1ln = [Resp(1).lnresp ;NaN*ones(48,1); Resp(2).lnresp; Resp(3).lnresp; NaN*ones(48,1)];
% Resp1 = Resp1ln;
Resp2 = [Resp(1).resp2 ;NaN*ones(48,1); Resp(2).resp2; Resp(3).resp2; NaN*ones(48,1)];
Resp2ln = [Resp(1).lnresp2 ;NaN*ones(48,1); Resp(2).lnresp2; Resp(3).lnresp2; NaN*ones(48,1)];
% Resp1 = Resp1ln;

for k = 1:1:3
Resp_results_log(k) = nansum(Resp1(k*17568-17567:k*17568,1)).*0.0216;
Resp_results_exp(k) = nansum(Resp1ln(k*17568-17567:k*17568,1)).*0.0216;
Resp_results_log2(k) = nansum(Resp2(k*17568-17567:k*17568,1)).*0.0216;
Resp_results_exp2(k) = nansum(Resp2ln(k*17568-17567:k*17568,1)).*0.0216;
end
