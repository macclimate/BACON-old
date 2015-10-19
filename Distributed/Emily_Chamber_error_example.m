%% This script will show you how to do a random error analysis for 1
%%% chamber
% In this script, C1 is the hhourly vector for Chamber 1 (for 1 or 2 years)
%%% There are 2 parts to this script --> The first looks for pairs that are
%%% exactly 1-day apart, while the second looks for pairs that are 1
%%% half-hour apart.  I am not sure which way you would want to do this,
%%% but you can try both and see what happens..
%%% You may also want to play around with the acceptable differences for
%%% Ts, and SM...

%% Part 1 - Uses pairs of observations that are 1-day apart but same time
%%% of day

%%% Loading the SM and Ts -- uncomment these and put in the correct paths..
% SM = load(...); %load SM for one chamber for (both?) years
% Ts = load(...); %load Ts for one chamber 

ind_all = (1:1:length(C1)-48)'; % an index for all hhours in the years of data
ind_d_after = (49:1:length(C1))'; % another index that is shifted by one day (so we can compare one day with the next).

SM_diff = SM(ind_all) - SM(ind_d_after);
Ts_diff = Ts(ind_all) - Ts(ind_d_after);
C1_diff = C1(ind_all) - C1(ind_d_after);


%%% The index that finds when back-to-back days have the same conditions
ind_C1 = find(SM_diff < 0.01 & Ts_diff < 0.2);

C1_stdev = std(C1_diff(ind_C1));
C1_error = (C1_stdev.*(C1(ind_C1))) ./ sqrt(2); %% This is the one you're interested in.
C1_Beta = C1_stdev./sqrt(2);

%%% Plot the distribution of error:
[y xout] = hist(C1_error,20);
figure(1)
bar(xout,y)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 2 - Uses pairs of observations that are 1-half hour apart in the
%%% same day

ind_all_hh = (1:1:length(C1)-1)'; % an index for all hhours in the years of data
ind_d_after_hh = (2:1:length(C1))'; % another index that is shifted by one day (so we can compare one day with the next).

SM_diff_hh = SM(ind_all_hh) - SM(ind_d_after_hh);
Ts_diff_hh = Ts(ind_all_hh) - Ts(ind_d_after_hh);
C1_diff_hh = C1(ind_all_hh) - C1(ind_d_after_hh);

%%% The index that finds when back-to-back days have the same conditions
ind_C1_hh = find(SM_diff_hh < 0.01 & Ts_diff_hh < 0.2);

C1_stdev_hh = std(C1_diff_hh(ind_C1_hh));
C1_error_hh = (C1_stdev_hh.*(C1(ind_C1_hh))) ./ sqrt(2); %% This is the one you're interested in.
C1_Beta_hh = C1_stdev_hh./sqrt(2);

%%% Plot the distribution of error:
[y xout] = hist(C1_error_hh,20);
figure(2)
bar(xout,y)

