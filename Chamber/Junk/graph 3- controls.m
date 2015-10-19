%% This script is designed to show controls of CO2 efflux, Ts at 5 cm and
%% SM at 20 cm. Scatterplots are used%%

%load data
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all3updated.csv');

clear all;
[Year, JD, HHMM, dt] = jjb_makedate(2008, 30);
[no_days] = jjb_days_in_month(2008);

 ctr = 1;
for m = 1:1:12
    
    for d = 1:1:no_days(m)
        for h = 1:1:48
        Month(ctr,1) = m;
        Day(ctr,1) = d;
        ctr = ctr+1;
        end
    end
end

% output_2008 = [Year Month Day HH]
HHMMs = num2str(HHMM);

HH = NaN.*ones(length(Year),1);
MM = NaN.*ones(length(Year),1);

for c = 1:1:length(HH)
    try
HH(c,1) = str2num(HHMMs(c,1:2));
    catch
 HH(c,1) = 0;
    end
    MM(c,1) = str2num(HHMMs(c,3:4));
end

HH(HH == 24,1) = 0;
output_2008(1:length(Year),1:46) = NaN;
output_2008 = [Year Month JD Day HH MM];

clear Year JD HHMM HH MM dt no_days d m HHMMs Month Day
%% For 2009:
[Year, JD, HHMM, dt] = jjb_makedate(2009, 30);
[no_days] = jjb_days_in_month(2009);

 ctr = 1;
for m = 1:1:12
    
    for d = 1:1:no_days(m)
        for h = 1:1:48
        Month(ctr,1) = m;
        Day(ctr,1) = d;
        ctr = ctr+1;
        end
    end
end

HHMMs = num2str(HHMM);

HH = NaN.*ones(length(Year),1);
MM = NaN.*ones(length(Year),1);

for c = 1:1:length(HH)
    try
HH(c,1) = str2num(HHMMs(c,1:2));
    catch
 HH(c,1) = 0;
    end
    MM(c,1) = str2num(HHMMs(c,3:4));
end

HH(HH == 24,1) = 0;

output_2009(1:length(Year),1:46) = NaN;
output_2009 = [Year Month JD Day HH MM];

%% 
%%% turn 
d_2008 = datenum(output_2008(:,1), output_2008(:,2), output_2008(:,4), output_2008(:,5), output_2008(:,6),0);
d_2009 = datenum(output_2009(:,1), output_2009(:,2), output_2009(:,4), output_2009(:,5), output_2009(:,6),0);
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all3updated.csv');

d_data = datenum(chamber_data(:,1),chamber_data(:,2),chamber_data(:,3),chamber_data(:,4),chamber_data(:,5),0);

[c i_output i_data] = intersect(d_2008, d_data);
output_2008(i_output,7:46) = chamber_data(i_data,6:45);


clear c i_output i_data
[c i_output i_data] = intersect(d_2009, d_data);
output_2009(i_output,7:46) = chamber_data(i_data,6:45);

save('C:\DATA\condensed\output_2008.dat','output_2008','-ASCII');
save('C:\DATA\condensed\output_2009.dat','output_2009','-ASCII');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load Met data


JD = load('C:/DATA/metdata 2008/TP39_2008.003');
HHMM = load('C:/DATA/metdata 2008/TP39_2008.004');

Ts5_A=load ('C:/DATA/metdata 2008/TP39_2008.091');
Ts5_B= load ('C:/DATA/metdata 2008/TP39_2008.097');
SM20_A= load('C:/DATA/metdata 2008/TP39_2008.101');
SM20_B= load('C:/DATA/metdata 2008/TP39_2008.106');


%Scatter Plot Soil T vs. Efflux ch1-ch4
C_1 = output_2008(:,16);
C_2 = output_2008(:,26);
C_3 = output_2008(:,36);
C_4 = output_2008(:,46);

C_1(14250:14650,1) = NaN;
C_2(14250:14650,1) = NaN;
C_2(10900:10950,1) = NaN;
C_3(14250:14650,1) = NaN;
C_4(14250:14650,1) = NaN;

ind_regress1 = find(C_1 < 0.000001);
ind_regress2 = find(C_2 < 0.000001);
ind_regress3 = find(C_3 < 0.18);
ind_regress4 = find(C_4 < 0.000001);
C_1(ind_regress1) = NaN;
C_2(ind_regress2) = NaN;
C_3(ind_regress3) = NaN;
C_4(ind_regress4) = NaN;

figure(3); clf;
hold on;
subplot (2,2,1);
title('Soil Temperature at 5 cm Depth and Efflux')
hold on;
plot(Ts5_A, C_1, 'r.') 
subplot (2,2,3);
plot(Ts5_A, C_2, 'b.')
subplot (2,2,2);
plot (Ts5_A, C_3, 'g.')
title('Soil Temperature at 5 cm Depth and Efflux')
subplot (2,2,4);
plot (Ts5_A, C_4, 'c.')
%xlabel('Soil Temperature (oC)')
%ylabel('Efflux (umol C m-2 s-1)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_A>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_A(ind_regress), C_1(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_A>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_A(ind_regress), C_2(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp2 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_A>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_A(ind_regress), C_3(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp3 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_A>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_A(ind_regress), C_4(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp4 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(12); 
hold on;
subplot (2,2,1);
ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
hold on;
plot(Ts5_A, C_1, 'r.') 
plot(Ts_test,Resp(counter).est_exp,'k-')
title('Soil Temperature at 5 cm Depth and Soil CO2 Efflux')
axis ([-5 25 -2 12]);
subplot (2,2,3);
hold on;
plot(Ts5_A, C_2, 'b.')
plot(Ts_test,Resp(counter).est_exp2,'k-')
axis ([-5 25 -2 12]);
xlabel('Soil Temperature (oC)')
ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
subplot (2,2,2);
hold on;
plot (Ts5_A, C_3, 'g.')
plot(Ts_test,Resp(counter).est_exp3,'k-')
title('Soil Temperature at 5 cm Depth and Soil CO2 Efflux')
axis ([-5 25 -2 12]);
subplot (2,2,4);
hold on;
plot (Ts5_A, C_4, 'c.')
plot(Ts_test,Resp(counter).est_exp4,'k-')
axis ([-5 25 -2 12]);
xlabel('Soil Temperature (oC)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%This script is for Soil Pit B soil temperature at 5 cm and efflux%%%%%%

%Scatter Plot Soil T vs. Efflux ch1-ch4
C_1 = output_2008(:,16);
C_2 = output_2008(:,26);
C_3 = output_2008(:,36);
C_4 = output_2008(:,46);

C_1(14250:14650,1) = NaN;
C_2(14250:14650,1) = NaN;
C_2(10900:10950,1) = NaN;
C_3(14250:14650,1) = NaN;
C_4(14250:14650,1) = NaN;

ind_regress1 = find(C_1 < 0.000001);
ind_regress2 = find(C_2 < 0.000001);
ind_regress3 = find(C_3 < 0.18);
ind_regress4 = find(C_4 < 0.000001);
C_1(ind_regress1) = NaN;
C_2(ind_regress2) = NaN;
C_3(ind_regress3) = NaN;
C_4(ind_regress4) = NaN;

figure(3); clf;
hold on;
subplot (2,2,1);
title('Soil Temperature at 5 cm Depth and Efflux')
hold on;
plot(Ts5_B, C_1, 'r.') 
subplot (2,2,3);
plot(Ts5_B, C_2, 'b.')
subplot (2,2,2);
plot (Ts5_B, C_3, 'g.')
title('Soil Temperature at 5 cm Depth and Efflux')
subplot (2,2,4);
plot (Ts5_B, C_4, 'c.')
%xlabel('Soil Temperature (oC)')
%ylabel('Efflux (umol C m-2 s-1)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_B>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_B(ind_regress), C_1(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_B>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_B(ind_regress), C_2(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp2 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_B>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_B(ind_regress), C_3(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp3 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

    
%%% Select needed data for ustar-delimited and non-ustar delimited:
    ind_regress = find(Ts5_B>-1);% & NEE1 < 50 & NEE1 > 0);%
   
    Resp(counter).ind = ind_regress;
%%% Step 1: Block average Ts and NEE
Resp(counter).bavg = jjb_blockavg(Ts5_B(ind_regress), C_4(ind_regress), 0.5,60, -25);  
%%% Step 2: Make sure we don't use any values with NaN;
ind_okdata = find(~isnan(Resp(counter).bavg(:,1).*Resp(counter).bavg(:,2)));
%%% Step 3: Use exponential function to regress respiration with Ts for bin-avg data with ustar threshold
[Resp(counter).coeff,Resp(counter).y,Resp(counter).r2,Resp(counter).sigma] = fitmain([5 .1 .1], 'fitexp', Resp(counter).bavg(ind_okdata,1), Resp(counter).bavg(ind_okdata,2));
%%% Fit data to linear function
X = [Resp(counter).bavg(ind_okdata,1) ones(length(Resp(counter).bavg(ind_okdata,1)),1)];
        [b_ln,bint_ln,r_ln,rint_ln,stats_ln] = regress_analysis(log(Resp(counter).bavg(ind_okdata,2)),X,0.05);
        pR_ln = (exp(b_ln(2))).* exp(Resp(counter).bavg(ind_okdata,1).*b_ln(1));

%%% Step 4: Estimate Respiration Function using logistic function:
Resp(counter).est_R = Resp(counter).coeff(1) ./(1 + exp(Resp(counter).coeff(2).*(Resp(counter).coeff(3)-Ts_test)));

    %%% exponential
Resp(counter).est_exp4 = (exp(b_ln(2))).* exp(Ts_test.*b_ln(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(13); 
hold on;
subplot (2,2,1);
ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
hold on;
plot(Ts5_B, C_1, 'r.') 
plot(Ts_test,Resp(counter).est_exp,'k-')
title('Soil Temperature from Pit B and Soil CO2 Efflux')
axis ([-5 25 -2 12]);
subplot (2,2,3);
hold on;
plot(Ts5_B, C_2, 'b.')
plot(Ts_test,Resp(counter).est_exp2,'k-')
axis ([-5 25 -2 12]);
xlabel('Soil Temperature (oC)')
ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
subplot (2,2,2);
hold on;
plot (Ts5_B, C_3, 'g.')
plot(Ts_test,Resp(counter).est_exp3,'k-')
title('Soil Temperature from Pit B and Soil CO2 Efflux')
axis ([-5 25 -2 12]);
subplot (2,2,4);
hold on;
plot (Ts5_B, C_4, 'c.')
plot(Ts_test,Resp(counter).est_exp4,'k-')
axis ([-5 25 -2 12]);
xlabel('Soil Temperature (oC)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%This script is designed to show how soil moisture at 20 cm depth is a
%%control on soil CO2 efflux using a scatterplot in Pit A%%


%Scatter Plot Soil T vs. Efflux ch1-ch4
C_1 = output_2008(:,16);
C_2 = output_2008(:,26);
C_3 = output_2008(:,36);
C_4 = output_2008(:,46);

C_1(14250:14650,1) = NaN;
C_2(14250:14650,1) = NaN;
C_2(10900:10950,1) = NaN;
C_3(14250:14650,1) = NaN;
C_4(14250:14650,1) = NaN;

ind_regress1 = find(C_1 < 0.000001);
ind_regress2 = find(C_2 < 0.000001);
ind_regress3 = find(C_3 < 0.18);
ind_regress4 = find(C_4 < 0.000001);
C_1(ind_regress1) = NaN;
C_2(ind_regress2) = NaN;
C_3(ind_regress3) = NaN;
C_4(ind_regress4) = NaN;

figure(14); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture at 20 cm Depth for Pit A and Soil CO2 Efflux')
hold on;
plot(SM20_A, C_1, 'r.')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_A, C_2, 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_A, C_3, 'g.')
title('Soil Moisture at 20 cm Depth for Pit B and Soil CO2 Efflux')
subplot (2,2,4);
plot (SM20_A, C_4, 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%This script is designed to show how soil moisture at 20 cm depth is a
%%control on soil CO2 efflux using a scatterplot in Pit B%%


%Scatter Plot Soil T vs. Efflux ch1-ch4
C_1 = output_2008(:,16);
C_2 = output_2008(:,26);
C_3 = output_2008(:,36);
C_4 = output_2008(:,46);

C_1(14250:14650,1) = NaN;
C_2(14250:14650,1) = NaN;
C_2(10900:10950,1) = NaN;
C_3(14250:14650,1) = NaN;
C_4(14250:14650,1) = NaN;

ind_regress1 = find(C_1 < 0.000001);
ind_regress2 = find(C_2 < 0.000001);
ind_regress3 = find(C_3 < 0.18);
ind_regress4 = find(C_4 < 0.000001);
C_1(ind_regress1) = NaN;
C_2(ind_regress2) = NaN;
C_3(ind_regress3) = NaN;
C_4(ind_regress4) = NaN;

cleaned_Ch1 = output_2008(:,16);
cleaned_Ch1(cleaned_Ch1==0,1) = NaN;

cleaned_Ch2 = output_2008(:,26);
cleaned_Ch2(cleaned_Ch2==0,1) = NaN;

cleaned_Ch3 = output_2008(:,36);
cleaned_Ch3(cleaned_Ch3==0,1) = NaN;

cleaned_Ch4 = output_2008(:,46);
cleaned_Ch4(cleaned_Ch4==0,1) = NaN;

%august
figure(15); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture at 20 cm Depth and Soil CO2 Efflux')
hold on;
plot(SM20_B, C_1, 'r.')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B, C_2, 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B, C_3, 'g.')
title('Soil Moisture at 20 cm Depth and Soil CO2 Efflux')
subplot (2,2,4);
plot (SM20_B, C_4, 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

Ts_test = (-2:2:22)';
plot_color = [1 0 0 0.5 0 0; 0 1 0 0.8 0.5 0.7 ; 0 0 1 0.2 0.1 0.1; 1 1 0 0.4 0.5 0.1; 1 0 1 0.9 0.9 0.4; 0 1 1 0.4 0.8 0.1];
counter = 1;

%september
figure(16); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture and Soil CO2 Efflux-September')
hold on;
plot(SM20_B(11760:13152), C_1(11760:13152), 'r.')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(11760:13152), C_2(11760:13152), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(11760:13152), C_3(11760:13152), 'g.')
title('Soil Moisture and Soil CO2 Efflux-September')
subplot (2,2,4);
plot (SM20_B(11760:13152), C_4(11760:13152), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%october
figure(17); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture and Soil CO2 Efflux-October')
hold on;
plot(SM20_B(13200:14640),C_1(13200:14640), 'r.')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(13200:14640), C_2(13200:14640), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(13200:14640), C_3(13200:14640), 'g.')
title('Soil Moisture and Soil CO2 Efflux-October')
subplot (2,2,4);
plot (SM20_B(13200:14640), C_4(13200:14640), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%november
figure(18); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture and Soil CO2 Efflux-November')
hold on;
plot(SM20_B(14688:16080),C_1(14688:16080), 'r.')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(14688:16080), C_2(14688:16080), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(14688:16080), C_3(14688:16080), 'g.')
title('Soil Moisture and Soil CO2 Efflux-November')
subplot (2,2,4);
plot (SM20_B(14688:16080), C_4(14688:16080), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%december
figure(19); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture Soil CO2 Efflux-December')
hold on;
plot(SM20_B(16128:16848),C_1(16128:16848), 'r.')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(16128:16848), C_2(16128:16848), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Soil CO2 Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(16128:16848), C_3(16128:16848), 'g.')
title('Soil Moisture and Soil CO2 Efflux-December')
subplot (2,2,4);
plot (SM20_B(16128:16848), C_4(16128:16848), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)


%check SM curve-after rewetting
figure(20); clf;
hold on;
subplot (2,2,1);
title('Soil Moisture at 20 cm Depth and Soil CO2 Efflux after Rewetting')
hold on;
plot(SM20_B(12000:12480),C_1(12000:12480), 'r.')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(12000:12480), C_2(12000:12480), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(12000:12480), C_3(12000:12480), 'g.')
title('Soil Moisture at 20 cm Depth and Soil CO2 Efflux after Rewetting')
subplot (2,2,4);
plot (SM20_B(12000:12480), C_4(12000:12480), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

%check SM curve-during dry period and wet
figure(21); clf;
hold on;
subplot (2,2,1);
title('Scatterplot of Soil Moisture and Efflux after Rewetting Soil')
hold on;
plot(SM20_B(11520:12576),C_1(11520:12576), 'r.')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,3);
plot(SM20_B(11520:12576), C_2(11520:12576), 'b.')
xlabel('Soil Moisture (m3 m-3)')
ylabel('Efflux (umol C m-2 s-1)')
subplot (2,2,2);
plot (SM20_B(11520:12576), C_3(11520:12576), 'g.')
title('Scatterplot of Soil Moisture and Efflux after Rewetting Soil')
subplot (2,2,4);
plot (SM20_B(11520:12576), C_4(11520:12576), 'c.')
xlabel('Soil Moisture (m3 m-3)')
%legend('Ch SE','Ch SW','Ch NE', 'Ch NW',1)

% figure(22);clf;
% hold on;
% subplot (3,1,1);
% title('August 16 2008 Soil Temperature, Soil Moisture and Soil CO2 Efflux')
% ylabel('Efflux (umol C m-2 s-1)')
% hold on;
% plot(C_1(12288:12384),'r')
% plot(C_2(12288:12384),'b')
% %plot(C_3((12288:12384),'g')
% plot(C_4(12288:12384),'c')
% subplot(3,1,2);
% ylabel('Soil Temperature (oC)')
% plot(Ts5_A(12288:12384),'r')
% subplot(3,1,3);
% ylabel('Soil Moisture (m3 m-3)')
% xlabel('HHOUR')
% plot(SM20_A(12288:12384),'b')
