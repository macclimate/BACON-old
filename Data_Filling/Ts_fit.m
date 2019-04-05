function [px_y2 pred_adj_y2] = Ts_fit(x, y,type)
%% x is indep variable, y is dependent variable (to be filled)
if nargin == 2;
    type = 'pw';
end

% px_y(1,1:2) = mmpolyfit(x(~isnan(x .* y)) ,y(~isnan(x .* y)),1,'ZeroCoef',0); % fits regression with intercept through origin
% pred_y = polyval(px_y,x); % predicts values for dependent variable based on slope of model
% px_y(1,3) = rsquared(y(~isnan(y .* pred_y)) ,pred_y(~isnan(y .* pred_y)));
% 
% pw = jjb_AB_gapfill(pred_y, y, [], 200, 20,'off',[],[], type);
% pred_adj_y = pred_y .* pw(:,2);
% pw_rsq =  rsquared(y(~isnan(y .* pred_adj_y)) ,pred_adj_y(~isnan(y .* pred_adj_y)));
% px_y(1,4) = rsquared(y(~isnan(y .* pred_adj_y)) ,pred_adj_y(~isnan(y .* pred_adj_y)));

px_y2(1,1:2) = polyfit(x(~isnan(x .* y)) ,y(~isnan(x .* y)),1);
pred_y2 = polyval(px_y2,x);
px_y2(1,3) = rsquared(y(~isnan(y .* pred_y2)) ,pred_y2(~isnan(y .* pred_y2)));

pw2 = jjb_met_TVP(pred_y2, y, [], 500, 20,'off',[],[], type);
pred_adj_y2 = pred_y2 .* pw2(:,2);
pw_rsq2 =  rsquared(y(~isnan(y .* pred_adj_y2)) ,pred_adj_y2(~isnan(y .* pred_adj_y2)));
px_y2(1,4) = pw_rsq2;

% pred_adj_y2b = pred_y2 ./ pw2(:,2);
% pw_rsq2b =  rsquared(y(~isnan(y .* pred_adj_y2b)) ,pred_adj_y2b(~isnan(y .* pred_adj_y2b)));
%%%%% for inspection purposes only:
% figure(32);clf;
% plot(x,y,'.');
% 
% figure(33);clf;
% plot(pw2(:,2));
% 
% figure(34);clf;
% plot(y); hold on;
% plot(pred_y2,'r');
% % plot(pred_adj_y,'g');
% plot(pred_adj_y2,'c');
% plot(pred_adj_y2b,'k');
%%%%%%%%%
%  disp('hi');
% 

