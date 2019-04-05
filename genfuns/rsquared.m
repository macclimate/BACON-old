function[rsq] = rsquared(obs_y, pred_y)
% Calculates the r-squared for observed and predicted values:
% usage: [r2] = rsquared(obs_y, pred_y);
% Created 2008 by JJB

% Revision History:

ind = find(~isnan(obs_y.*pred_y));
mean_obs = mean(obs_y(ind));

%%% Try it this way:

Er_SS = sum((pred_y(ind)-obs_y(ind)).^2); %error sum of squares
Tot_SS = sum((obs_y(ind) - mean_obs).^2); %total sum of squares

rsq = 1 - (Er_SS./Tot_SS);