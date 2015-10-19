function [Ustar_th f_out diagn] = mcm_Ustar_th_Reich(data, plot_flag,window_mode,num_bs)

if nargin == 1
    plot_flag = 1;
    window_mode = 'seas';
    num_bs = 100;
elseif nargin == 2
    window_mode = 'seas';
    num_bs = 100;
elseif nargin == 3
    num_bs = 100;
end

if isempty(window_mode)==1
    window_mode = 'seas';
end

if isempty(num_bs) ==1
    num_bs = 100;
end

switch window_mode
    case 'seas' 
        seasons = [1 3; 4 6; 7 9; 10 12]; % Starting and ending months for seasons
    case 'monthly'
        seasons = [(1:1:12)' (1:1:12)'];
    otherwise
        seasons = [1 3; 4 6; 7 9; 10 12]; % Starting and ending months for seasons

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
%%% 1a: The Reichstein, 2005 approach:
% seasons = [1 3; 4 6; 7 9; 10 12]; % Starting and ending months for seasons
ctr = 1;
for year = year_start:1:year_end
    for seas = 1:1:size(seasons,1)
        ind = find(data.Year == year & data.Month >= seasons(seas,1) & data.Month <= seasons(seas, 2));
        out = bootstrp(num_bs,@Reichsten_uth,data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
%         [u_th_est seas_u_th(seas,ctr)] = Reichsten_uth(data.NEE(ind), data.Ts5(ind), data.Ustar(ind), data.RE_flag(ind));
%     Ustar_th_seas(ind,1) = seas_u_th(seas,ctr);
    % Restructure the output
    out_array = struct2array(out);
    u_th_out(:,:,seas) = out_array(:,:)';
        clear out out_array;
    end
  %%% Part 2: Get Average Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%% Select annual u*_th as the maximum of seasonal median values esimates(conservative)
    %%% Instead, let's switch this to median of seasonal estimates:
   
    %%% 1. Determine Annual Mean and 90% CI:
        % u_th_out is structured as (num_bs,T_quantile,season)
        u_th_out(isinf(u_th_out))=NaN;
        tmp1 = nanmedian(u_th_out,2);
        tmp2 = reshape(tmp1,num_bs,size(seasons,1));
        u_th_max = nanmax(tmp2,[],2);
        u_th_mean = nanmean(tmp2,2);
        u_th_median = nanmedian(tmp2,2);
%     for i = 1:1:num_bs
%         tmp = u_th_out(i,:,:); %collect all T*s data for a selected bootstrap run
%         u_th_median(i,1) = nanmedian(tmp(~isinf(tmp(:))));
%         try
%         u_th_max(i,1) = nanmax(tmp(~isinf(tmp(:))));
%         catch
%          u_th_max(i,1) = NaN;   
%         end
%     end
    u_th_median_annual = mean(u_th_median(:));
    pctiles_median = prctile(u_th_median,[5 95]);
    u_th_median_annual(2:3) = pctiles_median;

    u_th_max_annual = mean(u_th_max(:));
    pctiles_max = prctile(u_th_max,[5 95]);
    u_th_max_annual(2:3) = pctiles_max;
    
    u_th_mean_annual = mean(u_th_mean(:));
    pctiles_mean = prctile(u_th_mean,[5 95]);
    u_th_mean_annual(2:3) = pctiles_mean;    
    
    % Output a Ustar_th vector, the same length as the input data:
    Ustar_th(data.Year==year,1:3) = repmat(u_th_median_annual,length(find(data.Year==year)),1);
    
    %%% Put ancillary information into a another variable:
    diagn.u_th_all{ctr,1} = u_th_out;
%     diagn.p_all{ctr,1} = p_out;
%     diagn.c_hat_all(ctr,1:3) = c_hat;
    diagn.u_th_median{ctr,1} = u_th_median;
    diagn.u_th_median_annual{ctr,1} = u_th_median_annual;    
    diagn.u_th_max{ctr,1} = u_th_max;
    diagn.u_th_max_annual{ctr,1} = u_th_max_annual;
    diagn.u_th_mean{ctr,1} = u_th_mean;
    diagn.u_th_mean_annual{ctr,1} = u_th_mean_annual;
    
    clear u_th_out;
%     %     Ustar_th(ctr,1) = nanmax(seas_u_th(:,ctr));
%     Ustar_th_med(ctr,1) = nanmedian(seas_u_th(:,ctr)); % Changed to median:
%     Ustar_th(data.Year == year,1) = Ustar_th_med(ctr,1);
    ctr = ctr+1;
end
if plot_flag == 1
    clrs = jjb_get_plot_colors;
    f_out = figure(1);clf;
    ctr = 1;
    for year = year_start:1:year_end
        h1(ctr,1) = plot(data.dt(data.Year==year,1),Ustar_th(data.Year==year,1),'--',...
            'LineWidth',2,'Color',clrs(ctr,:));
        hold on;
        plot(data.dt(data.Year==year,1),u_th_max_annual(1,1).*ones(length(find(data.Year==year)),1),'-','Color',clrs(ctr,:));
        ctr = ctr + 1;
        axis([0 366 0 1.5])
    end
    ylabel('u^{*}_{TH}', 'FontSize',16)
    xlabel('DOY');
    legend(h1,num2str((year_start:1:year_end)'));
else f_out = 0;
end
end

