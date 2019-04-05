function [RMSE rRMSE MAE BE R2 Ei] = model_stats(data_model, data_meas, plot_flag)
%% model_stats.m
% This function compares measured and modeled data, outputting the
% following:
% RMSE - absolute Root Mean Squared Error
% rRMSE - relative RMSE
% MAE - Mean Average Error
% BE - Bias Error
% R2 - Coefficient of Determination
% Ei - Model Efficiency
% usage:
% [RMSE rRMSE MAE BE R2 Ei] = model_stats(data_model, data_meas)
% Created Feb 23, 2009 by JJB:
% Revision History:
%
if nargin == 2;
    plot_flag = [];
end

good = find(~isnan(data_meas) & ~isnan(data_model));

RMSE    = sqrt((sum((data_model(good) - data_meas(good)).^2))./(length(good)-2));
rRMSE   = sqrt((sum((data_model(good) - data_meas(good)).^2))./(sum(data_meas(good).^2)));
MAE     = (sum(abs(data_model(good) - data_meas(good))))./(length(good));
BE      = (sum(data_model(good) - data_meas(good)))./(length(good));

%%% Do R2
try
%     ESS = sum( (data_meas(good) - data_model(good)).^2 ); % Error sum of squares
%     RSS = sum( (data_model(good) - mean(data_meas(good))).^2 ); % Regression sum of squares (Explained SS)
%     MSS = sum( (data_meas(good) - mean(data_meas(good))).^2);   % Sums of squared due to the mean
%     TSS = ESS + RSS + MSS; % Total sum of squares
%     
%     R2_1a = 1 - (ESS./MSS);
%     R2_1b = RSS./MSS;
    
    data_model2 = polyval(polyfit(data_model(good),data_meas(good),1),data_model);
    ESS2 = sum( (data_meas(good) - data_model2(good)).^2 ); % Error sum of squares
%     RSS2 = sum( (data_model2(good) - mean(data_meas(good))).^2 ); % Regression sum of squares (Explained SS)
    MSS2 = sum( (data_meas(good) - mean(data_meas(good))).^2);   % Sums of squared due to the mean

    R2 = 1 - (ESS2./MSS2);

catch
    R2 = NaN;
end

%%% Do Model Efficiency:
try
   Ei = 1- ( (sum((data_meas(good) -data_model(good)).^2)) ./ (sum( (data_meas(good) - mean(data_meas(good))) .^2))); 
catch
    Ei = NaN;
end


figurecount = length(findobj('Type','figure')); 

if strcmp(plot_flag,'on') == 1;
   figure(figurecount+70); clf;
   plot(data_meas(good),data_model(good),'b.');
else 
    
end