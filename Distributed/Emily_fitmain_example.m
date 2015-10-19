Emily_fitmain_example.m
loadstart = addpath_loadstart;
load([loadstart 'Matlab/Project_Folders/rEC/TP39.mat']);

[NEEraw] = jjb_struct2col(TP39, 'NEPraw',5).*-1; [Ts5] = jjb_struct2col(TP39, 'Ts5',5);
[VPD] = jjb_struct2col(TP39, 'VPD',5); [Ta] = jjb_struct2col(TP39, 'Ta',5);
[PAR] = jjb_struct2col(TP39, 'PAR',5); [SMa] = jjb_struct2col(TP39, 'SMa',5);
[ustar] = jjb_struct2col(TP39, 'ustar',5); [SMb] = jjb_struct2col(TP39, 'SMb',5);
year = jjb_struct2col(TP39, 'Year',5); dt = jjb_struct2col(TP39, 'dt',5);
[WS] = jjb_struct2col(TP39, 'WS',5); [RH] = jjb_struct2col(TP39, 'RH',5); 
[SM] = jjb_struct2col(TP39, 'SM',5);

NEEraw(ustar < 0.325) = NaN;

% Fit exponential relationship between Ts5 and NEEraw
ind = find(PAR < 20 & ~isnan(Ts5) & ~isnan(NEEraw) ); % pick out nighttime.
%[equation coefficients, predicted y values (Resp), r-squared, sigma] =
%fitmain([starting numbers for coefficients], type of curve, x values (Ts), y values (Rs) )
[coeff_exp,y_pred_exp,r2_exp,sigma_exp] = fitmain([5 .1], 'fitexp', Ts5(ind), NEEraw(ind)); %- exponential
[coeff_log,y_pred_log,r2_log,sigma_log] = fitmain([5 .1 .1], 'fitlogi5', Ts5(ind), NEEraw(ind)); %- logistic

figure(1); clf;
plot(Ts5(ind),NEEraw(ind),'.','Color',[0.7 0.7 0.7]); hold on; % plot raw data
% plot(Ts5(ind),y_pred_exp,'b-'); % plot predicted exp data
% plot(Ts5(ind),y_pred_log,'r.'); %

%%% put a line through data following the exponential regression equation:
plotting_Ts = (-5:0.1:25)';
plotting_y_pred = coeff_exp(1)*exp(coeff_exp(2)*plotting_Ts);
figure(1);
plot(plotting_Ts,plotting_y_pred,'k-','LineWidth',2);
text(15,15,'RE = 0.9459e^{0.1006\cdotTs}','FontSize',16);
text(15,13.5,'R^{2} = 0.526','FontSize',16);
%%% put a line through data following the logistic regression equation:
% plotting_Ts = (-5:0.1:25)';
plotting_y_pred_log = (coeff_log(1))./(1 + exp(coeff_log(2).*(coeff_log(3)-plotting_Ts)));
figure(1);
plot(plotting_Ts,plotting_y_pred_log,'r-','LineWidth',2);
text(15,-5,'RE = 10.52 / (1 + e^{0.16(16.2\cdotTs)})','FontSize',16);
text(15,-3,'R^{2} = 0.536','FontSize',16);

%%% This script shows how the function fitmain.m can be used to fit either
%%% an exponential or logistic relationships...

% what it looks like in general form:
% [coeff,y_pred,r2,sigma] = fitmain([5 .1 .1], 'fitlogi5', x, y); - logistic
% [coeff,y_pred,r2,sigma] = fitmain([5 .1 .1], 'fitexp', x, y); - exponential

% what it looks like in respiration application:
% [test_coeff,test_y,test_r2,test_sigma] = fitmain([5 .1 .1], 'fitlogi5', Ts5(ind_resp,1), NEEraw(ind_resp,1));



