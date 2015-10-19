function [std_est] = Rs_error_estimation(efflux_in, Ts_in, SM_in, plot_flag)
%%% Rs_error_estimation.m
%%% usage: [std_est] = Rs_error_estimation(efflux_in, Ts_in, SM_in, plot_flag)
% This function estimates the standard deviation associated with each
% efflux measurement.  These standard deviations should then be used 
% a) in maximum likelihood parameter estimation, and
% b) to produce random noise, used in monte carlo estimations
%
% How to make random noise from std_est:
% noise = random('norm',zeros(length(std_est),1),std_est);

% Created by JJB on March 8, 2011.


%% Part 1: Loop through data and estimate standard deviation
%%% What this loop does:
% This loop goes through the data a point at a time.
% If there is good data at this point, then it compares the efflux, Ts and
% SM at this point to the following points:
% The following 2 half-hours
% Values for the next day within +/- 1 hour of that same time of day
% Values for the next+1 day within +/- 1 hour of that same time of day
% The idea is that if the Ts and SM are similar within a given threshold,
% then the value of efflux should be very close to the same when you
% compare data that are at about the same time, and within 2 days of each
% other.  
% The differences in efflux during these valid periods provide an estimate
% of the random measurement error.  We can then see if the standard
% deviation of the error changes with different magnitudes of a given
% variable.   Here we choose to scale it with Ts:

error_data = [];
for i = 1:1:length(Ts_in)-98
    % Only calculate if data exists at i:
    if ~isnan(Ts_in(i,1).*SM_in(i,1).*efflux_in(i,1))
        ind_main = [(i+1:i+2) (i+45:i+49) (i+93:i+97)]';
        % Differences for next 2 half-hours, and the following 2 days at the same time of day: 
        tmp_diff_Ts = Ts_in(i,1) - Ts_in(ind_main,1);
        tmp_diff_SM = SM_in(i,1) - SM_in(ind_main,1);
        tmp_diff_efflux = efflux_in(i,1) - efflux_in(ind_main,1);
        
        rows_to_add = find(abs(tmp_diff_Ts) < 0.1 & ~isnan(tmp_diff_efflux) & abs(tmp_diff_SM) < 0.005);
        
        if ~isempty(rows_to_add) % changed from if ~isnan(rows_to_add) March 30, 2011
            Ts_mean = Ts_in(i,1) - tmp_diff_Ts(rows_to_add)./2;% changed from '+' to '-' March 30, 2011
            SM_mean = SM_in(i,1) - tmp_diff_SM(rows_to_add)./2;% changed from '+' to '-' March 30, 2011
            efflux_mean = efflux_in(i,1) - tmp_diff_efflux(rows_to_add)./2;% changed from '+' to '-' March 30, 2011
            error_data = [error_data; [Ts_mean SM_mean efflux_mean tmp_diff_efflux(rows_to_add)]];
        end
        
    end
end

%% Bin the error by Soil Temperature:
Ts_bins = [-20 -6:1:22 26]';

for i_Ts = 1:1:length(Ts_bins)-1
    ind = find(error_data(:,1) >= Ts_bins(i_Ts) & error_data(:,1) < Ts_bins(i_Ts+1));
    num_pts(i_Ts,1) = length(ind);
    Error_std(i_Ts,1) = std(error_data(ind,4));
    Ts_mid(i_Ts,1) = median(error_data(ind));
    clear ind;
end

if plot_flag == 1
figure(1);clf
plot(Ts_mid(num_pts>100),Error_std(num_pts>100),'k.');
end

%%% Fit a line to Ts vs Error relationship:
p = polyfit(Ts_mid(num_pts>100),Error_std(num_pts>100),1);

if plot_flag == 1
   Ts_plot = (-2:1:25)';
   Error_plot = polyval(p, Ts_plot);
   figure(1); hold on;
   plot(Ts_plot, Error_plot, 'b-', 'LineWidth', 2);
   title('Ts vs Standard devation of chamber measurement error');
   ylabel('\sigma_{efflux}');
   xlabel('T_s');
end

%%% Estimate standard deviation for every point:
std_est = polyval(p,Ts_in);

% % %%% Use that standard deviation to create random noise
% % % noise_pred = random('norm',zeros(length(std_est),1),std_est);
if plot_flag == 1
    figure(2);clf;
    plot(std_est);
    title('\sigma _{error} for entire year');
   ylabel('\sigma_{efflux}');
end

