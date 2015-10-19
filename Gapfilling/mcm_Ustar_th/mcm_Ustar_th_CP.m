function [Ustar_th f_out diagn] = mcm_Ustar_th_CP(data, plot_flag,window_mode,num_bs)

% Ustar_th - output columns:
% col 1 -> annual-mean ustar threshold
% col 2 -> annual-mean ustar threshold 90% CI lower bound
% col 3 -> annual-mean ustar threshold 90% CI upper bound
% col 4 -> seasonally-fitted ustar threshold

if nargin == 1
    plot_flag = 1;
    window_mode = 'monthly';
    num_bs = 100;
elseif nargin == 2
    window_mode = 'monthly';
    num_bs = 100;
elseif nargin == 3
    num_bs = 100;
end

if isempty(window_mode)==1
    window_mode = 'monthly';
end

if isempty(num_bs) ==1
    num_bs = 100;
end

switch window_mode
    case 'seas'
        win_size = 90*48;
        centres(:,1) = (45*48:win_size:17520);
    case 'monthly'
        win_size = 30*48;
        centres(:,1) = (15*48:win_size:17520);
        
    case 'biweekly'
        win_size = 16*48;
        centres(:,1) = (10*48:win_size:17520);
        
end

if isfield(data,'year_start')==1
    year_start = data.year_start;
    year_end = data.year_end;
else
    year_start = min(data.Year);
    year_end = max(data.Year);
    disp('No field for year_start and year_end.');
    disp(['Using year_start = ' num2str(year_start) ', and year_end = ' num2str(year_end)]);
end
Ustar_th = NaN.*ones(length(data.Year),4);
% Ustar_th_seas = NaN.*ones(length(data.Year),1);

%% Part 1: Establish the appropriate u* threshold:
%%% 1 Reichstein, 2005 approach, but calculated for different intervals:
ctr = 1;
data.recnum = NaN.*ones(length(data.PAR),1);
% win_size = 16*48;
% centres(:,1) = (10*48:16*48:17520);
% num_bs = 100;
diagn.u_th_all = {};
diagn.c_hat_all = [];
diagn.p_all = {};
for year = year_start:1:year_end
%     disp(['year = ' num2str(year) ' Remove this before running in SHARCNET!']);
%     if year == 2011
%         pause;
%     end
    data.recnum(data.Year == year) = 1:1:yr_length(year,30);
    dt_ctr = 1;
    for dt_centres = 1:1:length(centres)%:win_size:yr_length(year,30,0)%seas = 1:1:4
        tic;
        ind_bot = max(1,centres(dt_centres)-win_size);
        ind_top = min(centres(dt_centres)+win_size,yr_length(year,30,0));
        ind = find(data.Year == year & data.recnum >= ind_bot & data.recnum <= ind_top);
        %         [u_th_est_tmp u_th(dt_ctr,ctr) dt_mean(dt_ctr,ctr)] = CPD_uth(data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind), data.dt(ind));
        %%%%%%% Runs bootstrapping for the ustar determination (CPD_uth.m)
        [out] = bootstrp(num_bs,@CPD_uth,data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
        % Restructure the output (uth and slopes):
        out_array = struct2array(out);
        u_th_out(:,:,dt_centres) = out_array(1:4,1:2:size(out_array,2))';
        p_out(:,:,dt_centres) = out_array(1:4,2:2:size(out_array,2))';
        clear out out_array;
        diagn.t(dt_ctr,ctr) = toc;
        % End of seasonal loop (n_s in Barr notation)
        dt_ctr = dt_ctr+1;
    end
    
    %%% Do QA step 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Remove any uth estimates that come from the lesser of Deficits and
    % Excesses (Our site shows strong Deficits, it appears, so we don't lose
    % much):
    pos_slope = length(find(p_out(:)>0));
    neg_slope = length(find(p_out(:)<0));
    if pos_slope >= neg_slope
        u_th_out(p_out<0) = NaN;
    else
        u_th_out(p_out>0) = NaN;
    end
    
    %%% Part 2: Get Average Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% 1. Determine Annual Mean and 90% CI:
    % u_th_out is structured as (num_bs,T_quantile,season)
    for i = 1:1:num_bs 
        tmp = u_th_out(i,:,:); %collect all T*seas data for a selected bootstrap run
        u_th_mean(i,1) = nanmean(tmp(~isinf(tmp(:)))); % mean u_th for that year is the 
        u_th_median(i,1) = nanmedian(tmp(~isinf(tmp(:)))); % median u_th for that year is the   
        u_th_max(i,1) = nanmax(tmp(~isinf(tmp(:))));
    end
    
    u_th_mean_annual = mean(u_th_mean(:));
    pctiles = prctile(u_th_mean,[5 95]);
    u_th_mean_annual(2:3) = pctiles;
    
    % Also record the median of these, since it seems to be quite different
    % from the mean:
    u_th_median_annual = mean(u_th_median(:)); % Take mean of median values
    pctiles = prctile(u_th_median,[5 95]);
    u_th_median_annual(2:3) = pctiles;

     % Also record the max of these, since it seems to be quite different
    % from the mean & median:
    u_th_max_annual = mean(u_th_max(:)); % Take mean of max values
    pctiles = prctile(u_th_max,[5 95]);
    u_th_max_annual(2:3) = pctiles;   
    
    %%% 2. Fit a sine wave to the data for seasonally-variable u*_th
    % Need to average across all bs and nT strata for each ns
    for i = 1:1:length(centres)
        tmp = u_th_out(:,:,i);
        u_th_seas(i,1) = nanmean(tmp(:));
    end
    %     figure(1);clf;
    %     plot(data.dt(centres),u_th_seas,'ro','MarkerFaceColor','k');
    
    %%% fit the sine wave (use function uth_sinefn):
    c_hat = fminsearch(@uth_sinefn,[0.35 0.2 0],[],data.dt(centres),u_th_seas);
    u_th_mean_seas = uth_sinefn(c_hat,data.dt(data.Year==year),[],2);
%     figure(1);
%     hold on;
%     plot(data.dt,u_th_mean_seas,'b-');
        
    % Output a Ustar_th vector, the same length as the input data:
    % [mean uth | 5% uth | 95% uth | savg uth]
    Ustar_th(data.Year==year,1:3) = repmat(u_th_mean_annual,length(find(data.Year==year)),1);
    Ustar_th(data.Year==year,4) = u_th_mean_seas;

    %%% Put ancillary information into a another variable:
    diagn.u_th_all{ctr,1} = u_th_out;
    diagn.p_all{ctr,1} = p_out;
    diagn.c_hat_all(ctr,1:3) = c_hat;
    diagn.u_th_mean{ctr,1} = u_th_mean;
    diagn.u_th_mean_annual{ctr,1} = u_th_mean_annual;
    diagn.u_th_median{ctr,1} = u_th_median;
    diagn.u_th_median_annual{ctr,1} = u_th_median_annual;    
    diagn.u_th_max{ctr,1} = u_th_max;
    diagn.u_th_max_annual{ctr,1} = u_th_max_annual;       
    %%%%%%%%%% End of yearly loop    
    clear u_th_out p_out
    ctr = ctr+1;
end

%% Plot results (if plot_flag == 1);
if plot_flag == 1
    clrs = jjb_get_plot_colors;
    f_out = figure(1);clf;
    ctr = 1;
    for year = year_start:1:year_end
        h1(ctr,1) = plot(data.dt(data.Year==year,1),Ustar_th(data.Year==year,1),'--',...
            'LineWidth',2,'Color',clrs(ctr,:));
        hold on;
        plot(data.dt(data.Year==year,1),Ustar_th(data.Year==year,4),'-','Color',clrs(ctr,:));
        ctr = ctr + 1;
    end
    ylabel('u^{*}_{TH}', 'FontSize',16)
    xlabel('DOY');
    legend(h1,num2str((year_start:1:year_end)'));
    else f_out = 0;
end

end