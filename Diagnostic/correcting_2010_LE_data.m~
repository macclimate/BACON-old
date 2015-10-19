%% TP39:
%%% These numbers come from the Comp7000 program, where the li-7000 calibration
%%% coefficients were entered into the program, and the span value was
%%% changed for a given W_Raw value.
clear all;
IRGA = [1233000,3.25900000000000,4.79700000000000;1220000,5.10600000000000,7.69200000000000;1200000,8.40500000000000,13.0680000000000;1185000,11.2610000000000,17.8780000000000;1170000,14.4580000000000,23.3950000000000;1155000,18.0100000000000,29.6550000000000;1142000,21.3860000000000,35.7080000000000;1130000,24.7550000000000,41.8350000000000;1120000,27.7530000000000,47.3500000000000;1110000,30.9290000000000,53.2480000000000;1100000,34.2870000000000,59.5390000000000;1090000,37.8310000000000,66.2350000000000;];
% Col 1 = W_raw
% Col 2 = H2O-span = 1.01
% Col 3 = H2O-span = 1.40
p = polyfit(IRGA(:,2),IRGA(:,3),1);
lin_est = polyval(p,IRGA(:,2));
rsq = rsquared(IRGA(:,3),lin_est);
%%% What we find is that the h2o (span=1.4) is offset from span=1.01 by a
%%% linear function with slope = 1.7807 and intercept = -1.8670

figure();
plot(IRGA(:,2),IRGA(:,3),'k.')
hold on;
plot(IRGA(:,2),lin_est,'b-')
ylabel('H_{2}O-span = 1.40');
xlabel('H_{2}O-span = 1.01');
title('Figure 1: TP39 - H_{2}O correction')
text(5,50,['y = ' num2str(p(1)) 'x + ' num2str(p(2))],'Color','b');
text(5,47,['R^{2} = ' num2str(rsq)],'Color','b');
print('-dpng','/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP39_h2o');
% The non-zero y-int means that we can't simply divide by the ratio between
% the two values -- We have to use the linear equation to change the
% values.

% What does this mean for fluxes?
%%% What we've done is insert lines of code into fr_calc_eddy.m that will
%%% correct the h2o values (by linear relationship) and recalculate the 
%%% LE flux, and save the results to the following file:
test = load('/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP39_LE_test.txt');
test2 = test(2:4:end,1:2); % only need the first of every 4 values
figure();
plot(test2(:,1),test2(:,2),'k.')
p_LE = polyfit(test2(:,1),test2(:,2),1);
pred_LE = polyval(p_LE,test2(:,1));
rsq2 = rsquared(test2(:,2),pred_LE);
ylabel('LE-span = 1.01');
xlabel('LE-span = 1.4');
title('Figure 3: TP39 - LE correction')
text(0,450,['y = ' num2str(p_LE(1)) 'x + ' num2str(p_LE(2))],'Color','b');
text(0,400,['R^{2} = ' num2str(rsq2)],'Color','b');
print('-dpng','/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP39_LE');

%%% Results show that the relationship between the span=1.4 LE and the
%%% span=1.01 LE is linear, with near 0 intercept and slope of 0.57122
%%% So, we should be able to multiply the span = 1.4 LE values by the slope
%%% and get corrected values.  BUT, this will only work for periods where
%%% the h2o value is not maxed out... Those will have to be removed.
%% TP02:
clear all;
IRGA = [1050000,2.62700000000000,0.710000000000000;1030000,5.43100000000000,4.05100000000000;1010000,8.76800000000000,8.36700000000000;990000,12.6470000000000,13.6790000000000;970000,17.0760000000000,20.0070000000000;960000,19.5000000000000,23.5590000000000;950000,22.0650000000000,27.3730000000000;940000,24.7710000000000,31.4510000000000;930000,27.6200000000000,35.7970000000000;920000,30.6140000000000,40.4130000000000;910000,33.7520000000000,45.3020000000000;900000,37.0360000000000,50.4650000000000;];
% Col 1 = W_raw
% Col 2 = H2O-span = 1.01
% Col 3 = H2O-span = 1.40
p = polyfit(IRGA(:,2),IRGA(:,3),1);
lin_est = polyval(p,IRGA(:,2));
rsq = rsquared(IRGA(:,3),lin_est);
%%% What we find is that the h2o (span=1.36) is offset from span=1.02 by a
%%% linear function with slope = 1.4544 and intercept = -4.2219

figure();
plot(IRGA(:,2),IRGA(:,3),'k.')
hold on;
plot(IRGA(:,2),lin_est,'b-')
ylabel('H_{2}O-span = 1.36; Z = 1.17');
xlabel('H_{2}O-span = 1.02; Z = 1.15');
title('Figure 2: TP02 - H_{2}O correction')
text(5,50,['y = ' num2str(p(1)) 'x + ' num2str(p(2))],'Color','b');
text(5,47,['R^{2} = ' num2str(rsq)],'Color','b');
print('-dpng','/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP02_h2o');

% The non-zero y-int means that we can't simply divide by the ratio between
% the two values -- We have to use the linear equation to change the
% values.

% What does this mean for fluxes?
%%% What we've done is insert lines of code into fr_calc_eddy.m that will
%%% correct the h2o values (by linear relationship) and recalculate the 
%%% LE flux, and save the results to the following file:
test = load('/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP02_LE_test.txt');
test2 = test(2:4:end,1:2); % only need the first of every 4 values
figure();
plot(test2(:,1),test2(:,2),'k.')
p_LE = polyfit(test2(:,1),test2(:,2),1);
pred_LE = polyval(p_LE,test2(:,1));
rsq2 = rsquared(test2(:,2),pred_LE);
xlabel('LE-span = 1.36; Z = 1.17');
ylabel('LE-span = 1.02; Z = 1.15');
title('Figure 4: TP02 - LE correction')
text(0,100,['y = ' num2str(p_LE(1)) 'x + ' num2str(p_LE(2))],'Color','b');
text(0,80,['R^{2} = ' num2str(rsq2)],'Color','b');
print('-dpng','/1/fielddata/Matlab/Data/Other/Fixing_2011_Li7000_cal/TP02_LE');

%%% Results show that the relationship between the span=1.36 LE and the
%%% span=1.02 LE is linear, with near 0 intercept and slope of 0.6895
%%% So, we should be able to multiply the span = 1.36 LE values by the slope
%%% and get corrected values.  BUT, this will only work for periods where
%%% the h2o value is not maxed out... Those will have to be removed.

