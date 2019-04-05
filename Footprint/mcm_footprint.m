function [flag_file, max_fetch, Xpct_all] = mcm_footprint(data, site, year_start, year_end, fp_type, Xcrit, ustar_thresh, plot_flag)
% mcm_footprint.m
% usage [flag_file, max_fetch, Xpct_all] = ...
% mcm_footprint(data, site, year_start, year_end, fp_type, Xcrit, ustar_thresh, plot_flag)
% This function is called by run_mcm_footprint, and is the main footprint
% calculating function.  The inputs are used to run either the Hsieh or
% Scheupp models with the specified parameters.
% Inputs:
% 1. data - structure with all necessary data (gapfilling data)
% 2. site - string specifying site
% 3. year_start - starting year for footprint filtering
% 4. year_end - ending year for footprint filtering
% 5. fp_type - string specifying which footprint model to use:
% 6. Xcrit - The % of flux that MUST be within the fetch to keep a
% measurement - NOT NEEDED AS OF JUNE 21, 2011 (JJB)
%%% ---- 'Schuepp' or 'Hsieh'
%
% Outputs:
% 1. flag file of accepted (1) or rejected (NaN) data poitns:
% 2. cleaned flux data file
% 3. Figures for footprints - saved to an appropriate folder
%%% Created June, 2010 by JJB
%
%
%
% Revision History:
% JUNE 21, 2011 (JJB):
% - Reworked the entire function so that all XCrit values were evaluated
% and put into the flag_file simultaneously (instead of running it in
% loops). 
% - Added the Kljun footprint scheme. 
%
%
%
%



close all;
if nargin == 7
    plot_flag = 'on';
end

%% Load data file
%%% We may or may not use this -- depends on if we want to pass 'data' file
%%% through, or have it be able to run in standalone-mode
ls = addpath_loadstart;
fig_path = [ls 'Matlab/Figs/Footprint/'];
% path = [ls 'Matlab/Data/Master_Files/' site '/'];
% load([path site '_gapfill_data_in.mat']);
% data = trim_data_files(data,year_start, year_end);
%%% Make empty entries for output data:

flag_file = NaN.*ones(length(data.Year),9);
max_fetch = NaN.*ones(length(data.Year),1);
Xpct_all = NaN.*ones(length(data.Year),9);
%%% Constants:
% colors for plotting:
clrs = [0.07,0.99,0.6;0.41,0.86,0.15;0.67,0.39,0.9;...
    0.93,0.45,0.45;0.81,0.25,0.21;0.48,0.78,0.9;...
    0.76,0.88,0.76;0.42,0.91,0.88;0.97,0.56,0.28;];
% Xcrit = floor(Xcrit.*100)./100; % round XCrit for consistency
stab_thresh = 0.04; % stability threshold
Xpct_index = [(1:1:9)' (0.50:0.05:0.90)'];
Xpct_index(:,2) = floor(Xpct_index(:,2).*100)./100;
% find(Xpct_index == Xcrit)

% col_to_use = Xpct_index(Xpct_index(:,2)==Xcrit,1);
plot_ang = (0:pi/180:2*pi)';

%% Run through years:
yr_ctr = 1;
for year = year_start:1:year_end
%     if year ==2008
%     disp('pause - remove this');
%     else
%     end
    
    %%% Information to pass through to footprint functions:
    % Height Data
    try
%         [Heights] = params(year, site, 'Heights');
%         z = Heights(1,1); % Measurement height (m)
%         h = Heights(1,2); % Tree top height (m)
        
        % Met & Flux Data:
        u = data.WS(data.Year == year);
        ustar = data.Ustar(data.Year == year);
        H = data.H(data.Year == year);
        Ta = data.Ta(data.Year == year);
        RH = data.RH(data.Year == year);
        APR = data.APR(data.Year == year);
        W_Dir = data.W_Dir(data.Year == year);
        PAR = data.PAR(data.Year == year);
        sigmaw = data.w_std(data.Year == year);
        z = data.z_meas(data.Year == year);
        h = data.z_tree(data.Year == year);
        %     if ~isempty(find(~isnan(u), 1))
        
        % Other Data:
        temp_flag_file = NaN.*ones(length(u),1);
        temp_max_fetch = NaN.*ones(length(u),1);
        %%%%%%%%%%%%%%%%%%%%% (i.e. |z/L| < stab_thresh when neutral,
        %%%%%%%%%%%%%%%%%%%%%       z/L < -1*stab_thresh when unstable
        %%%%%%%%%%%%%%%%%%%%%       z/L > stab_thresh when stable
        %%% Convert wind data to polar direction coordinates
        [W_Dir_rad] = CSWind2Polar(W_Dir,'rad');
        [W_Dir_deg] = CSWind2Polar(W_Dir,'deg');
        
        if ~isempty(strfind(fp_type,'_all'))
            param_options.fetch_type = 'all';
        else
            param_options.fetch_type = 'tight';
        end
        
        %%% Convert Fetch Info to polar coordinates:
        [fetch] = params(year, site, 'Fetch',param_options);
        [angles_out dist_out] = fetchdist(fetch);
        [angles_sorted index] = sort(angles_out);
        dist_sorted = dist_out(index);
        clear angles_out dist_out;
        
        
        switch fp_type
            case {'Schuepp'; 'Schuepp_all'}
                [x_max_m, x_max_h, xf_m, xf_h,L,zL] = mcm_Schuepp_footprint(u, ustar, H, Ta, RH, APR, z, h);
                x_max = x_max_h; % Distance of maximum contribution to measured flux
                Xpct  = xf_h; % Fetch distances for given % of measured flux

            case {'Hsieh'; 'Hsieh_all'}
                [Fc,L,xp,F2H,zL] = mcm_footprint_hsieh(ustar,H,Ta,z,h);
                x_max = xp;  % Distance of maximum contribution to measured flux
                Xpct  = Fc;  % Fetch distances for given % of measured flux
                
            case {'Kljun'; 'Kljun_all'}
                [Xpct,x_max] = mcm_footprint_Kljun(z,h./10,500,sigmaw,ustar,floor(Xpct_index(:,2).*100));
                
                
                
        % Calculate z/L:
        [zL] = calc_zL(z,h,Ta,RH,APR,ustar,H);
        end
        
        for k = 1:1:length(angles_sorted)-1
            ind2 = find(W_Dir_rad >= angles_sorted(k) & W_Dir_rad < angles_sorted(k+1));
            temp_max_fetch(ind2) = dist_sorted(k);
        end
        
        %%% Put the flag_file data into the appropriate spot:
        for i = 1:1:size(Xpct_index,1)
            %             Xcrit_tmp = Xcrit(i);
            %         col_to_use = Xpct_index(Xpct_index(:,2)==Xcrit_tmp,1);
            
            % Case 1: When the Xpct is less than max fetch (keep data)
            temp_flag_file(Xpct(:,i) <=temp_max_fetch) = 1;
            % Case 2: When the Xpct is more than max fetch (remove data)
            temp_flag_file(Xpct(:,i) > temp_max_fetch) = NaN;
            % Fill the data into the appropriate place in flag_file
            flag_file(data.Year == year,i) = temp_flag_file;
        end
        
        max_fetch(data.Year == year) = temp_max_fetch;
        Xpct_all(data.Year == year, :) = Xpct;
        clear temp_max_fetch ind2 temp_flag_file;
        
        
        switch plot_flag
            case 'on'
                %%% Plotting
                %%%%%%%%%%%%%%%% FIGURE 1 %%%%%%%%%%%%%%%%%%%%%%
                % Wind Rose for each year
                %%%NEED to fix this -- for some reason, the background is always black
                %      h1 = figure('Name','Wind Rose');
                %          set(h1, 'Color','None')
                try
                    figure(1);clf;
                    hwr = jjb_wind_rose(W_Dir_deg(~isnan(W_Dir_deg.*u)), u(~isnan(W_Dir_deg.*u)),'percbg', 'None');
                    set(hwr(1),'FaceColor','None');
                    title(['Wind Roses, ' site ', ' num2str(year)])
                    print('-dpdf', [fig_path 'wind_rose_' site '_' num2str(year)])
                catch
                end
                %%%%%%%%%%%%%%%% FIGURE 2 %%%%%%%%%%%%%%%%%%%%%%
                % Plot the distribution of Xpct fetches for different values of Xpct
                % Plot at 70, 80, 90 %
                
                ctr2 = 0;
                try
                    for X_use = 0.7:0.1:0.9
                        figure(2);clf
                        set(gcf, 'PaperOrientation', 'portrait', 'PaperType','usletter');
                        right_col = 5 + (2.*ctr2);
                        % Neutral and Unstable:
                        subplot(3,1,1)
                        ind_n_un = find(Xpct(:,right_col) < max(dist_sorted).*3 & ~isnan(Xpct(:,right_col)) & zL < stab_thresh);
                        h2(ctr2+1,1) = polar(W_Dir_rad(ind_n_un), Xpct(ind_n_un,right_col),'.'); hold on; % plot distances
                        set(h2(ctr2+1,1),'Color', clrs(ctr2+1,:));
                        hh = polar(angles_sorted,dist_sorted); % plot the site
                        set(hh,'Color', 'r', 'LineWidth', 2);
                        for pl_dist = 100:100:max(dist_sorted)+100
                            hL = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
                            set(hL,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
                            t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
                        end
                        title(['Fetches for ' num2str(X_use.*100) ' % Flux. Neutral + Unstable'])
                        %         rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
                        set(gca,'Position',[0.1 0.67 0.9 0.25])
                        % Stable:
                        subplot(3,1,2)
                        ind_st = find(Xpct(:,right_col) < max(dist_sorted).*5 & ~isnan(Xpct(:,right_col)) & zL > stab_thresh);
                        h2(ctr2+1,2) = polar(W_Dir_rad(ind_st), Xpct(ind_st,right_col),'.'); hold on; % plot distances
                        set(h2(ctr2+1,2),'Color', clrs(ctr2+1,:));
                        hh = polar(angles_sorted,dist_sorted); % plot the site
                        set(hh,'Color', 'r', 'LineWidth', 2);
                        for pl_dist = 100:100:max(dist_sorted)+100
                            hL = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
                            set(hL,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
                            t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
                        end
                        title(['Fetches for ' num2str(X_use.*100) ' % Flux. Stable'])
                        %         rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
                        set(gca,'Position',[0.1 0.33 0.9 0.25])
                        
                        % u* accepted:
                        subplot(3,1,3)
                        ind_ustar = find(Xpct(:,right_col) < max(dist_sorted).*5 & ~isnan(Xpct(:,right_col)) ...
                            & ((ustar >= ustar_thresh & PAR < 20)|PAR >=20));
                        h2(ctr2+1,3) = polar(W_Dir_rad(ind_ustar), Xpct(ind_ustar,right_col),'.'); hold on; % plot distances
                        set(h2(ctr2+1,3),'Color', clrs(ctr2+1,:));
                        hh = polar(angles_sorted,dist_sorted); % plot the site
                        set(hh,'Color', 'r', 'LineWidth', 2);
                        for pl_dist = 100:100:max(dist_sorted)+100
                            hL = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
                            set(hL,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
                            t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
                        end
                        title(['Fetches for ' num2str(X_use.*100) ' % Flux. u_{*} accepted'])
                        %         rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
                        ctr2 = ctr2+1;
                        %      figure(2);
                        title(['Fetches for ' num2str(X_use.*100) '% of measured flux'])
                        set(gca,'Position',[0.1 0 0.9 0.25])
                        
                        print('-dpdf', [fig_path fp_type '_X' num2str(X_use.*100) '_' site '_' num2str(year)])
                        
                    end
                catch
                end
                
                
                
                %%%%%%%%%%%%%%%%%%% FIGURE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % make 70, 80, 90% isopleths around tower:
                try
                    figure(3);clf;
                    hh = polar(angles_sorted,dist_sorted); hold on; % plot the site
                    set(hh,'Color', 'r', 'LineWidth', 2);
                    rlim = max(dist_sorted).*1.5;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
                    ctr3 = 0;
                    for X_use = 0.5:0.1:0.9
                        right_col = 1 + (2.*ctr3);
                        incr = 2*pi()/180;
                        ctr_rad = 1;
                        for rads = 0:incr:2*pi()
                            ind = find(~isnan(Xpct(:,right_col)) & W_Dir_rad > rads-incr.*3 & W_Dir_rad <= rads+incr.*3 ...
                                & ((ustar >= ustar_thresh & PAR < 20)|PAR >=20));
                            Xmean(ctr_rad,ctr3+1) = mean(Xpct(ind,right_col));
                            rads_plot(ctr_rad,1) = rads; %+(incr./2);
                            ctr_rad = ctr_rad + 1;
                        end
                        
                        h3(ctr3+1) = polar(rads_plot,Xmean(:,ctr3+1),'.-'); hold on;
                        set(h3(ctr3+1),'Color', clrs(ctr3+1,:));
                        t3(ctr3+1) = text(Xmean(1,ctr3+1)+5,0, num2str(X_use.*100));
                        set(t3(ctr3+1), 'FontSize',14, 'Color',clrs(ctr3+1,:));
                        
                        ctr3 = ctr3 + 1;
                    end
                    legend({'Boundary';'50';'60';'70';'80';'90'});
                    title(['Mean Footprints for site: ' site ', year: ' num2str(year)])
                    print('-dpdf', [fig_path fp_type '_mean_footprint_' site '_' num2str(year)])
                catch
                end
            case 'off'
        end
    catch
        disp(['year ' num2str(year) ' skipped -- no data or there is a problem.'])
    end
    yr_ctr = yr_ctr +1;
    
end
end
        function [zL] = calc_zL(z,h,Ta,RH,APR,ustar,H)
        d    = h.*2/3; roh = 1.293; k = 0.41;  Cp = 1012; g = 9.81; 
        [e,ea] = vappress(Ta, RH); rv     = (0.622.*e)./(APR-e); tv     = (1+0.61.*rv).*(Ta+273.15);  
        L  = -1.*(roh.*Cp.*tv.*ustar.^3)./(k.*g.*H); zL = (z-d)./L;
        end