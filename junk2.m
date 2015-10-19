site = 'TP39';
%%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
data = trim_data_files(data,2003, 2009,1);
data.site = site;
data.SM = data.SM_a_filled;
close all
    Rraw = NaN.*data.NEE;
    xi = (1:1:length(Rraw))';
data.Ustar_th = 0.3.*ones(length(data.Ustar),1);
NEE_clean = data.NEE;
NEE_clean(data.PAR < 15 & data.Ustar < data.Ustar_th, 1) = NaN;

%%% Preliminary NEE fill column vectors:
NEE_fill = NaN.*ones(length(NEE_clean),3);
for i = 1:1:3
    NEE_fill(~isnan(NEE_clean),i) = NEE_clean(~isnan(NEE_clean),1);
end

    ind_Rraw = find((data.Ustar >= data.Ustar_th & ~isnan(data.NEE) & data.PAR < 15 ) |... % growing season
        (data.Ustar >= data.Ustar_th & ~isnan(data.NEE) & ((data.dt < 85 | data.dt > 335) & data.Ts5 < 0.2)) & ~isnan(data.SM) );                             % non-growing season

Rraw(ind_Rraw) = data.NEE(ind_Rraw);

R_param = Rraw(ind_Rraw);
Ts_param = data.Ts5(ind_Rraw);
SM_param = data.SM(ind_Rraw);

x = [Ts_param SM_param];


win_size = round(4*48/2);
incr = 2*48;
%%% Wrap the variables:
wrap_Ts = [data.Ts2(end-win_size+1:end,1); data.Ts2; data.Ts2(1:win_size,1)];
wrap_PAR = [data.PAR(end-win_size+1:end,1); data.PAR; data.PAR(1:win_size,1)];
wrap_Eo = ones(length(wrap_PAR),1);
wrap_VPD = [data.VPD(end-win_size+1:end,1); data.VPD; data.VPD(1:win_size,1)];
wrap_ind = [xi(length(xi)-win_size+1:end,1); xi; xi(1:win_size,1)];
wrap_NEE = [NEE_clean(end-win_size+1:end,1); NEE_clean; NEE_clean(1:win_size,1)];

centres = (win_size+1:incr:length(wrap_ind)-win_size)';
if centres(end) < length(wrap_NEE)-win_size; centres = [centres; length(wrap_NEE)-win_size]; end
%%%% Variables to use within loop:
c_hat1 = NaN.*ones(length(centres),5);c_hat2 = NaN.*ones(length(centres),5);
c_hat3 = NaN.*ones(length(centres),5);
stats1= NaN.*ones(length(centres),2); stats2= NaN.*ones(length(centres),2);
stats3= NaN.*ones(length(centres),2);
y_pred1 = NaN.*ones(length(wrap_NEE),2); y_pred2 = NaN.*ones(length(wrap_NEE),2);
y_pred3 = NaN.*ones(length(wrap_NEE),2);
num_pts = NaN.*ones(length(centres),1); num_pts_d = NaN.*ones(length(centres),1);
num_pts_n = NaN.*ones(length(centres),1);

Rref_start = NaN.*ones(length(centres),1);
beta_start = NaN.*ones(length(centres),1);

%%% Windowed Parameterization:
for i = 1:1:length(centres)
    tic
    Ts_temp = wrap_Ts(centres(i)-win_size:centres(i)+win_size);
    PAR_temp = wrap_PAR(centres(i)-win_size:centres(i)+win_size);
    Eo_temp = wrap_Eo(centres(i)-win_size:centres(i)+win_size);
    VPD_temp = wrap_VPD(centres(i)-win_size:centres(i)+win_size);
    NEE_temp = wrap_NEE(centres(i)-win_size:centres(i)+win_size);
    ind_check = Ts_temp.*PAR_temp.*Eo_temp.*VPD_temp.*NEE_temp;
    
    %%% Determine the starting values for Rref:    
    try Rref_start(i,1) = nanmean(NEE_temp(PAR_temp< 15,1)); catch; Rref_start(i,1) = NaN; end
    if isempty(Rref_start(i,1))==1 || isnan(Rref_start(i,1))==1 || Rref_start(i,1) >100; Rref_start(i,1) = 5; 
    elseif Rref_start(i,1)<0; Rref_start(i,1) = 2; 
    end
    %%% Determine the starting values for beta: 
    try beta_start(i,1) = abs(quantile(NEE_temp,0.03)-quantile(NEE_temp,0.97));    
    catch; beta_start(i,1) = NaN; end
        if isempty(beta_start(i,1))==1 || isnan(beta_start(i,1))==1 || beta_start(i,1) > 100; beta_start(i,1) = 20; 
    elseif beta_start(i,1)<=0; beta_start(i,1) = 0.5; 
        end
    
    % Run parameterization, gather c_hat values:
    X_eval = [PAR_temp Ts_temp Eo_temp VPD_temp];
    X_in = [PAR_temp(~isnan(ind_check)==1) Ts_temp(~isnan(ind_check)==1) ...
        Eo_temp(~isnan(ind_check)==1) VPD_temp(~isnan(ind_check)==1)];
    num_pts(i,1) = size(X_in,1);
    num_pts_d(i,1) = length(find(X_in(:,1)>15));
    num_pts_n(i,1) = length(find(X_in(:,1)<=15));
    
    %%%%%%%%%%% 2. _noVPDall
    %%% We add in here a line that will constrain Eo, since otherwise Eo
    %%% will go crazy:
    options.costfun ='OLS'; options.min_method ='NMC';options.f_coeff = [0.05 NaN NaN NaN]; %options.f_coeff = [0.05 NaN NaN];
    options.lbound = [-1e6 -1e6 -1e6 50];    options.ubound = [1e6 1e6 1e6 600];
    [c_hat, y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = ...
        fitGEP([0.01 beta_start(i,1) Rref_start(i,1) 250], 'fitGEP_Lasslop_noVPDall', X_in ,NEE_temp(~isnan(ind_check)),  X_eval, [], options);
    % predicted values:
    y_pred2(centres(i)-win_size:centres(i)+win_size,rem(i,2)+1) = y_pred;
    % gather stats:
    stats2(i,1:2) = [stats.rRMSE stats.MAE];
    % Coefficients: [alpha beta rRef Eo]
    c_hat2(i,1:4) = c_hat;
    clear c_hat y_pred stats options;
    clear global
t = toc;
disp(['run ' num2str(i) ' completed in ' num2str(t) ' seconds.'])
    
% This line is VERY important, as it removes hidden global variables that
% may exist in the other stacks.
    clear global 
end
