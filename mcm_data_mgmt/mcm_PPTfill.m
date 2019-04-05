function [] = mcm_PPTfill(year)

close all;
% mcm_start_mgmt;

%%%%%%%%%%%%%%%%%
[year_start year_end] = jjb_checkyear(year);

% if isempty(year)==1
%     year = input('Enter year(s) to process; single or sequence (e.g. [2007:2010]): >');
% elseif ischar(year)==1
%     year = str2double(year);
% end
% 
% if numel(year)>1
%         year_start = min(year);
%         year_end = max(year);
% else
%     year_start = year;
%     year_end = year;
% end
% 
% if numel(year) == 1 || ischar(year)==1
%     if ischar(year)
%         year = str2double(year);
%     end
%     year_start = year;
%     year_end = year;
% elseif numel(year) > 1
%     year_start = year(1);
%     year_end = year(end);
% end
% 
% if isempty(year)==1
%     year_start = input('Enter start year: > ');
%     year_end = input('Enter end year: > ');
% end
%%%%%%%%%%%%%%%%%


% site = 'TP_PPT';

ls = addpath_loadstart;

% Declare Paths:
load_dir = [ls 'Matlab/Data/Met/Final_Cleaned/'];
% hdr_path = [ls 'Matlab/Data/Met/Raw1/Docs/'];
output_path = [ls 'Matlab/Data/Met/Final_Filled/TP_PPT/'];
jjb_check_dirs(output_path);
% Load Header:
% header = jjb_hdr_read([hdr_path site '_OutputTemplate.csv'], ',', 3);
%
% %%%% Take information from columns of the header file
% % Column vector number
% col_num = str2num(char(header(:,1)));
%
% % Title of variable
% var_names = char(header(:,2));
%
% num_vars = max(col_num);
%
%

for year_ctr = year_start:1:year_end
    close all
    yr_str = num2str(year_ctr);
    disp(['Working on year ' yr_str '.']);
    
    
    %% Load data from different rain guages:
    [~, ~, ~, dt] = jjb_makedate(year_ctr, 30);
    % A: TP_PPT
    %%% GEONOR guage
    GEO_PPT = load([load_dir 'TP_PPT/TP_PPT_' yr_str '.GN_Precip']);
    TX_PPT =  load([load_dir 'TP_PPT/TP_PPT_' yr_str '.TX_Rain']);
    % B: TP39:
    try
        TP39 = load([load_dir 'TP39/TP39_met_cleaned_' yr_str '.mat']);
        if year_ctr >=2007
            TP39_PPT = load_from_master(TP39.master,'CS_Rain');
        else
            TP39_PPT = load_from_master(TP39.master,'RMY_Rain');
        end
        Ta = load_from_master(TP39.master,'AirTemp_AbvCnpy');
        % C. TP02:
        TP02 = load([load_dir 'TP02/TP02_met_cleaned_' yr_str '.mat']);
        TP02_PPT = load_from_master(TP02.master,'Rain');
        % D. TPD:
        if year_ctr >=2013
        TPD = load([load_dir 'TPD_PPT/TPD_PPT_met_cleaned_' yr_str '.mat']);
        TPD_PPT = load_from_master(TPD.master,'PrecipA');
        else
        TPD_PPT = NaN.*ones(length(TP02_PPT),1);
        end
    catch
        disp('Error.  Please make sure you''ve run mcm_metfixer on TP02 and TP39 before you try to run this');
    end
    
    %% Fill TP_PPT from TP39 when precip is likely rain (Ta >= 5 degrees, not
    %%% winter).  Otherwise, fill from TPD, then TP02;
    fill_rain = find(dt > 90 & dt<330 & Ta > 5 & isnan(GEO_PPT));
    GEO_PPT(fill_rain,1) = TX_PPT(fill_rain,1);
    fill_rain2 = find(dt > 90 & dt<330 & Ta > 5 & isnan(GEO_PPT));
    disp(['A total of ' num2str(length(fill_rain)-length(fill_rain2)) ' filled from TX_PPT to GEONOR']);
    GEO_PPT(fill_rain2,1) = TP39_PPT(fill_rain2,1);
    fill_rain3 = find(dt > 90 & dt<330 & Ta > 5 & isnan(GEO_PPT));
    disp(['A total of ' num2str(length(fill_rain2)-length(fill_rain3)) ' filled from TP39 to GEONOR']);
    
    %%% TPD:
    fill_other = find(isnan(GEO_PPT));
    GEO_PPT(fill_other,1) = TPD_PPT(fill_other,1);
    fill_left_GEO = find(isnan(GEO_PPT));
    disp(['A total of ' num2str(length(fill_other)-length(fill_left_GEO)) ' filled from TPD to GEONOR']);
    disp(['A total of ' num2str(length(fill_left_GEO)) ' gaps remain in GEONOR PPT data.']);
    
    %%%% TP02
    fill_other = find(isnan(GEO_PPT));
    GEO_PPT(fill_other,1) = TP02_PPT(fill_other,1);
    fill_left_GEO = find(isnan(GEO_PPT));
    disp(['A total of ' num2str(length(fill_other)-length(fill_left_GEO)) ' filled from TP02 to GEONOR']);
    disp(['A total of ' num2str(length(fill_left_GEO)) ' gaps remain in GEONOR PPT data.']);
    
    if ~isempty(fill_left_GEO)
        fill_other = find(isnan(GEO_PPT));
        disp('No other option -- must fill rest of gaps from TP39 during questionable period.');
        GEO_PPT(fill_left_GEO,1) = TP39_PPT(fill_left_GEO,1);
        fill_left_GEO = find(isnan(GEO_PPT));
disp(['A total of ' num2str(length(fill_other)-length(fill_left_GEO)) ' filled from questionable TP39 data to GEONOR']);
        disp(['A total of ' num2str(length(fill_left_GEO)) ' gaps remain in GEONOR PPT data.']);
    end
    
    %% Do the same for TX rain at TP_PPT:
    fill_rain = find(dt > 90 & dt<330 & Ta > 5 & isnan(TX_PPT));
    TX_PPT(fill_rain,1) = GEO_PPT(fill_rain,1);
    fill_rain2 = find(dt > 90 & dt<330 & Ta > 5 & isnan(TX_PPT));
    disp(['A total of ' num2str(length(fill_rain)-length(fill_rain2)) ' filled from GEONOR to TX_PPT']);
    TX_PPT(fill_rain2,1) = TP39_PPT(fill_rain2,1);
    fill_rain3 = find(dt > 90 & dt<330 & Ta > 5 & isnan(TX_PPT));
    disp(['A total of ' num2str(length(fill_rain2)-length(fill_rain3)) ' filled from TP39 to TX_PPT']);

    %%% TPD:
    fill_other = find(isnan(TX_PPT));
    TX_PPT(fill_other,1) = TPD_PPT(fill_other,1);
    fill_left_TX = find(isnan(TX_PPT));
    disp(['A total of ' num2str(length(fill_other)-length(fill_left_TX)) ' filled from TPD to TX_PPT']);
    disp(['A total of ' num2str(length(fill_left_TX)) ' gaps remain in TX_PPT data.']);
    
    %%%% TP02
    fill_other = find(isnan(TX_PPT));
    TX_PPT(fill_other,1) = TP02_PPT(fill_other,1);
    fill_left_TX = find(isnan(TX_PPT));
    disp(['A total of ' num2str(length(fill_other)-length(fill_left_TX)) ' filled from TP02 to TX_PPT']);
    disp(['A total of ' num2str(length(fill_left_TX)) ' gaps remain in TX_PPT data.']);
    
    if ~isempty(fill_left_TX)
        disp('No other option -- must fill rest of gaps from TP39 during questionable period.');
        TX_PPT(fill_left_TX,1) = TP39_PPT(fill_left_TX,1);
        fill_left_TX = find(isnan(TX_PPT));
        disp(['A total of ' num2str(length(fill_left_TX)) ' gaps remain in TX_PPT data.']);
    end
    
    %% Fill TP39, TP02, TPD with GEONOR data
    TP39_PPT(isnan(TP39_PPT)) = GEO_PPT(isnan(TP39_PPT));
    disp(['TP39 PPT filled.  A total of ' num2str(length(find(isnan(TP39_PPT)))) ' gaps remain.']);

    %%% TP02
    % First fill from TPD:
    TP02_PPT(isnan(TP02_PPT)) = TPD_PPT(isnan(TP02_PPT));
    TP02_PPT(isnan(TP02_PPT)) = GEO_PPT(isnan(TP02_PPT));
    disp(['TP02 PPT filled.  A total of ' num2str(length(find(isnan(TP02_PPT)))) ' gaps remain.']);
    
    %%% TPD
    % First fill from TP02:
    TPD_PPT(isnan(TPD_PPT)) = TP02_PPT(isnan(TPD_PPT));
    TPD_PPT(isnan(TPD_PPT)) = GEO_PPT(isnan(TPD_PPT));
    disp(['TPD PPT filled.  A total of ' num2str(length(find(isnan(TPD_PPT)))) ' gaps remain.']);
    
    
    %% Plot the final results:
    % 1. GEONOR DATA
    figure('Name', 'TP_PPT Final filled Precipitation data'); clf;
    subplot(2,1,1);
    [h1] = plot(dt,GEO_PPT,'b'); hold on;
    plot(dt(fill_left_GEO),zeros(length(fill_left_GEO),1),'rx');
    [h2] = plot(dt, TX_PPT,'g');
    plot(dt(fill_left_TX),zeros(length(fill_left_TX),1),'rx');
    legend([h1 h2],'GEO_PPT', 'TX_PPT','Location','NorthWest');
    
    cum_GEO_PPT = nancumsum(GEO_PPT);
    cum_TX_PPT = nancumsum(TX_PPT);
    
    subplot(2,1,2);
    [h1] = plot(dt,cum_GEO_PPT,'b'); hold on;
    plot(dt(fill_left_GEO),cum_GEO_PPT(fill_left_GEO),'rx');
    [h2] = plot(dt,cum_TX_PPT,'g');
    plot(dt(fill_left_TX),cum_TX_PPT(fill_left_TX),'rx');
    legend([h1 h2],'GEO_PPT', 'TX_PPT','Location','NorthWest');
    
    % 2. Other Sites:
    fill_left_TP39 = find(isnan(TP39_PPT));
    fill_left_TP02 = find(isnan(TP02_PPT));
    fill_left_TPD = find(isnan(TPD_PPT));
    
    figure('Name', 'Met Sites filled Precipitation data'); clf;
    subplot(2,1,1);
    [h1] = plot(dt,TP39_PPT,'b'); hold on;
    plot(dt(fill_left_TP39),zeros(length(fill_left_TP39),1),'rx');
    [h2] = plot(dt, TP02_PPT,'g');
    plot(dt(fill_left_TP02),zeros(length(fill_left_TP02),1),'rx');
    [h3] = plot(dt, TPD_PPT,'k');
    plot(dt(fill_left_TPD),zeros(length(fill_left_TPD),1),'rx');
    legend([h1 h2 h3],'TP39', 'TP02','TPD','Location','NorthWest');
    
    cum_TP39_PPT = nancumsum(TP39_PPT);
    cum_TP02_PPT = nancumsum(TP02_PPT);
    cum_TPD_PPT = nancumsum(TPD_PPT);   
    
    subplot(2,1,2);
    [h1] = plot(dt,cum_TP39_PPT,'b'); hold on;
    plot(dt(fill_left_TP39),cum_TP39_PPT(fill_left_TP39),'rx');
    [h2] = plot(dt,cum_TP02_PPT,'g');
    plot(dt(fill_left_TP02),cum_TP02_PPT(fill_left_TP02),'rx');
    [h3] = plot(dt,cum_TPD_PPT,'k');
    plot(dt(fill_left_TPD),cum_TPD_PPT(fill_left_TPD),'rx');
    
     legend([h1 h2 h3],'TP39', 'TP02','TPD','Location','NorthWest');

   
    %% Save the final data:
    master.data = [GEO_PPT TX_PPT TP39_PPT TP02_PPT cum_GEO_PPT TPD_PPT];
    master.labels = {'GEO_PPT';'TX_PPT';'TP39_PPT';'TP02_PPT'; 'GEO_PPT_cum';'TPD_PPT'};
    
    save([output_path 'TP_PPT_' yr_str '.GEO_PPT'],'GEO_PPT','-ASCII');
    save([output_path 'TP_PPT_' yr_str '.TX_PPT'],'TX_PPT','-ASCII');
    save([output_path 'TP_PPT_' yr_str '.TP39_PPT'],'TP39_PPT','-ASCII');
    save([output_path 'TP_PPT_' yr_str '.TP02_PPT'],'TP02_PPT','-ASCII');
    save([output_path 'TP_PPT_' yr_str '.GEO_PPT_cum'],'cum_GEO_PPT','-ASCII');
    save([output_path 'TP_PPT_' yr_str '.TPD_PPT'],'TPD_PPT','-ASCII');
    
    save([output_path 'TP_PPT_filled_' yr_str '.mat'],'master');
    disp('done!');
end
mcm_start_mgmt;
end
