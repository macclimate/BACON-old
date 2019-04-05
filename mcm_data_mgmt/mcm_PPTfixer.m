function [] = mcm_PPTfixer(year, PPT, PPT_raw, PPT_tx)
%% This function is meant to be run on cleaned TP_PPT (Fish Hatchery)
%%% data, with the only needed input being 'year' (string format)
%%%
%%% Created Jan 23, 2009 by JJB
%%% Revision History:
%%%
%%%
%%%%%%%%%%%%%%%%%

% if numel(year) == 1 || ischar(year)==1
%     if ischar(year)
%         year = str2double(year);
%     end
%     year_start = year;
%     year_end = year;
% end
% 
% if isempty(year)==1
%     year_start = input('Enter start year: > ');
%     year_end = input('Enter end year: > ');
% end
%%%%%%%%%%%%%%%%%

% if ischar(year) == false
% year = num2str(year);
% end

% Change these paths if output_header changes in subsequent years
% defaults:
% hdr_path = [loadstart 'Matlab/Data/Met/Raw1/Docs/TP_PPT_OutputTemplate.csv'];
%         PPT_string = 'GN_Precip';
%         PPT_tx_string = 'TX_Rain';
% switch year
%     case '2008'
loadstart = addpath_loadstart;
% hdr_path = [loadstart 'Matlab/Data/Met/Raw1/Docs/TP_PPT_OutputTemplate.csv'];
% PPT_string = 'GN_Precip';
% PPT_tx_string = 'TX_Rain';
%     case '2009'
% % Add stuff in here is titles/ header files change...
% end

% Load Header:
% [hdr_cell] = jjb_hdr_read(hdr_path, ',', 3);


%% Main Loop
% for year_ctr = year_start:1:year_end
%     close all
    yr_str = num2str(year);
     disp(['Running mcm_PPTfixer on year ' yr_str '.']);
    
%     load_path = [loadstart 'Matlab/Data/Met/Organized2/TP_PPT/Column/30min/TP_PPT_' yr_str '.'];
    % Load PPT data:
%     [PPT] = jjb_load_var(hdr_cell, load_path, PPT_string);
%     [PPT_tx] = jjb_load_var(hdr_cell, load_path, PPT_tx_string);
%                 PPT_raw = PPT;
    %% Do manual fixes that need to be done before first cleans:
    switch yr_str
        case '2008'
        case '2009'
        case '2010'
%             % Added Oct 09, 2010 by JJB:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%% We need to insert an algorithm for removing large
%             %%% diurnal(ish) variations in bucket level during the start of
%             %%% 2010, due to the bucket being improperly balanced.  We'll
%             %%% do this by manually removing points where there seems to be
%             %%% no precipitation, and making these values equal to the last
%             %%% good point before it.  Doing this creates a much more
%             %%% acceptible result for PPT, as otherwise, these variations
%             %%% will be incorrectly counted as precipitation events.
%             %%% The list defines regions where we want to make the values
%             %%% constant (i.e. no precipitation)
%             bad_data = {522:862 891:1130 1324:1550 1610:1883 1954:2112 2170:2280 2286:2300 ...
%                 2322:2525 2570:2615 2622:2686 2775:3359 3492:3731};
%             for k = 1:1:length(bad_data)
%                ind_last = find(~isnan(PPT_raw(1:bad_data{1,k}(1,1)-1)),1,'last');
%                last_good = PPT_raw(ind_last);
%                PPT(bad_data{1,k}(1,:),1) = last_good;
%             end        
            
    end
    
    %% Plot Raw data:
    figure('Name','Input Data')
    clf
    plot(PPT_raw,'b.-')
    title('Input Data')
    hold on;
    plot(PPT,'r.-');
    legend('raw input', 'cleaned for variation');
    
    % Offset PPT by 1 and compare the two to get 1/2 hour accumulation numbers
    PPT = [PPT; NaN];
    PPT_offset(1:length(PPT),1) = [NaN; PPT(1:length(PPT)-1)];
    event = PPT - PPT_offset;
    gaps = find(isnan(event(2:length(event)-1)));
    
    % Added Oct 09, 2010 by JJB: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Do the same for raw PPT 
    PPT_raw = [PPT_raw; NaN];
    PPT_raw_offset(1:length(PPT_raw),1) = [NaN; PPT_raw(1:length(PPT_raw)-1)];
    event_raw = PPT_raw - PPT_raw_offset;
    gaps_raw = find(isnan(event_raw(2:length(event_raw)-1)));
    
    % Plot to inspect
    figure('Name', '1/2hour GEONOR event-based'); clf;
    % Added 20101009
     h1(1) = plot(event_raw,'g');   hold on;  
    h1(2) = plot(event); hold on;
    if isempty(gaps)
         h1(3) = plot(NaN,NaN,'rx');
    else
    h1(3) = plot(gaps,zeros(length(gaps),1),'rx');
    end
    
    %% Clean up Data:
    %%% Clean step 1 -- remove up-spikes occuring before a large downspike (emptying bucket)
    % lag event by 1 point.
    
    event_m(1:length(event),1) = [ event(2:length(event)); NaN];
    error1 = find(event > 4 & event_m < -20);
    eventc1 = event;eventc1(error1,1) = 0;eventc1(eventc1 > 40,1) = 0;

    %%% Remove all events that are less than 0.08mm
    eventc3 = eventc1; eventc3(eventc3 <= 0.08,1) = 0;    
    h1(4) = plot(eventc3, 'c');
    legend(h1, 'raw','var-cleaned', 'gaps', 'cleaned'); axis([1 17568 -10 40])
    cum_eventc3(:,1) = nancumsum(eventc3);
    
  
    % Re-arrange to proper length:
    PPT_out = eventc3(1:length(eventc3)-1);
    cum_PPT_out = cum_eventc3(1:length(cum_eventc3)-1);
    
    %% Tx Instruments Guage:
    figure('Name','TX Rain'); clf
    plot(PPT_tx);hold on;
    gaps_tx = find(isnan(PPT_tx));
    plot(gaps_tx,zeros(length(gaps_tx),1),'rx');
    
    PPT_tx(PPT_tx > 40,1) = 0;
    % PPT_tx(isnan(PPT_tx),1) = 0;
    cum_PPT_tx = nancumsum(PPT_tx);
    
    figure('Name', 'Cumulative Amounts'); clf
    h2(1) = plot(cum_eventc3,'g'); hold on;
    if isempty(gaps)
         h2(2) = plot(NaN,NaN,'rx');
    else
    h2(2) = plot(gaps, cum_eventc3(gaps),'rx');
    end
    h2(3) = plot(cum_PPT_tx,'b');
    
    if isempty(gaps_tx)
         h2(4) = plot(NaN,NaN,'rx');
    else
    h2(4) = plot(gaps_tx, cum_PPT_tx(gaps_tx),'rx');
    end    
%   plot(cum_eventc3_2,'c');
    title('processed cumulative output')
    legend(h2,'cumulative PPT','gaps', 'Tx Rain Guage', 'Tx-gaps','Location','NorthWest');
    
    jjb_check_dirs([loadstart 'Matlab/Data/Met/Cleaned3/TP_PPT/'],0);
    jjb_check_dirs([loadstart 'Matlab/Data/Met/Final_Cleaned/TP_PPT/'],0);
    
    %% Output Cleaned Data
% PPT_string = 'GN_Precip';
% PPT_tx_string = 'TX_Rain';    
    save([loadstart 'Matlab/Data/Met/Cleaned3/TP_PPT/TP_PPT_' yr_str '.GN_Precip' ],'PPT_out','-ASCII');
    save([loadstart 'Matlab/Data/Met/Cleaned3/TP_PPT/TP_PPT_' yr_str '.GN_Precip_cum'],'cum_PPT_out','-ASCII');
    save([loadstart 'Matlab/Data/Met/Cleaned3/TP_PPT/TP_PPT_' yr_str '.TX_Rain' ],'PPT_tx','-ASCII');
    save([loadstart 'Matlab/Data/Met/Cleaned3/TP_PPT/TP_PPT_' yr_str '.TX_Rain_cum'],'cum_PPT_tx','-ASCII');
    %% Do manual fixes on PPT data:
    disp('To remove specific bad points, please edit the mcm_PPTfixer script');
    
    
    switch yr_str
        case '2008'
            % Make a minor shift -- problem with datalogger at one point
%             Geo_PPT_shift = [PPT_out(1:9000); PPT_out(9002:end); NaN];
%             PPT_out = Geo_PPT_shift;
%             clear Geo_PPT_shift;
%             PPT_tx_shift = [PPT_tx(1:9000); PPT_tx(9002:end); NaN];
%             PPT_tx = PPT_tx_shift;
%             clear PPT_tx_shift;
         % Take out obvious bad data;
            PPT_out([5496:5497 938 13707 16833],1) = 0;
            
        case '2009'
         % Take out obvious bad data;
            PPT_out(6031,1) = 0;
            
        case '2010'
         % Take out obvious bad data;
            PPT_out(13427,1) = 0;
          
        case '2013'
            PPT_out([1901:1904 1909 1910],1) = 0;
        
        case '2014'
            PPT_out(13262,1) = NaN;
        case '2015'
            
    end
    
    % Load PAR data from TP39, so we can do a quick inspection to see if there
    % are rain events being recorded during times of high sun intensity (likely
    % outliers).
    try
        TP39_filled = load([loadstart 'Matlab/Data/Met/Final_Filled/TP39/TP39_met_filled_' yr_str '.mat']);
    PAR = load_from_master(TP39_filled.master,'DownPAR_AbvCnpy');
    catch
        PAR = NaN.*ones(yr_length(str2num(yr_str),30),1);
    end
    TP39_cleaned = load([loadstart 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_' yr_str '.mat']);
    PAR_cleaned = load_from_master(TP39_cleaned.master,'DownPAR_AbvCnpy');
    PAR(isnan(PAR)==1,1) = PAR_cleaned(isnan(PAR)==1,1);
    clear TP39_cleaned TP39_filled PAR_cleaned;
    
    ind_vs = find(PPT_out>0 & PPT_out < 0.1);
    ind_s = find(PPT_out >=0.1 & PPT_out < 1);
    ind_m = find(PPT_out >= 1 & PPT_out < 5);
    ind_l = find(PPT_out >= 5 & PPT_out < 10);
    ind_vl = find(PPT_out >= 10);
    figure('Name','Inspect for rain during high-sun');clf;
    h3(1) = plot(PAR,'b');
    hold on;
    h3(2) = plot(ind_vs,PAR(ind_vs),'s','MarkerSize',2,'MarkerFaceColor','c','MarkerEdgeColor','c');
    h3(3) = plot(ind_s,PAR(ind_s),'s','MarkerSize',4,'MarkerFaceColor','y','MarkerEdgeColor','k');
    h3(4) = plot(ind_m,PAR(ind_m),'s','MarkerSize',6,'MarkerFaceColor','m','MarkerEdgeColor','m');
    h3(5) = plot(ind_l,PAR(ind_l),'s','MarkerSize',8,'MarkerFaceColor','g','MarkerEdgeColor','g');
    try
    h3(6) = plot(ind_vl,PAR(ind_vl),'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','k');
    catch
    end
    legend(h3,'PAR','<0.1mm','0.1-1mm','1-5mm','5-10mm','>10mm');
    
    figure('Name','Final Cleaned PPT'); clf
    subplot(2,1,1);
    plot(PPT_out);hold on;
    gaps_out = find(isnan(PPT_out));
    plot(gaps_out,zeros(length(gaps_out),1),'rx');
    legend('GEONOR');
    
    subplot(2,1,2);
    plot(PPT_tx);hold on;
    gaps_tx = find(isnan(PPT_tx));
    plot(gaps_tx,zeros(length(gaps_tx),1),'rx');
    legend('TX Rain Guage');
    
    %% Output Final fixed data to /Final_Cleaned/ directory:
    % PPT_string = 'GN_Precip';
% PPT_tx_string = 'TX_Rain';    

    save([loadstart 'Matlab/Data/Met/Final_Cleaned/TP_PPT/TP_PPT_' yr_str '.GN_Precip' ],'PPT_out','-ASCII');
    save([loadstart 'Matlab/Data/Met/Final_Cleaned/TP_PPT/TP_PPT_' yr_str '.TX_Rain' ],'PPT_tx','-ASCII');
mcm_start_mgmt;
end
%{
function [PPT_out] = PPT_diurnal_clean(PPT_in)
        PPT_out = PPT_in;
                 

        
        
        

        
        
        % Step 1: Identify the continuous regions:
        tmp_diff = diff(PPT_in);
        chg_pts = find(tmp_diff < -1);
        % chg_pts = chg_pts -1;
        st_pts = 1;
        end_pts = chg_pts(1);
        for i = 2:1:length(chg_pts)
            if chg_pts(i-1)+1 <= chg_pts(i)-1
                st_pts = [st_pts; chg_pts(i-1)+1];
                end_pts = [end_pts; chg_pts(i)];
            end
            %     if chg_pts(i) - chg_pts(i+1)== -1 % if pt is first of two in a row
            %        end_pts = [end_pts; chg_pts(i)-1];
            %        if chg_pts(i)
        end
        
        st_pts = [st_pts; chg_pts(i)+1];
        end_pts = [end_pts; length(PPT_in)];
        
        
        
        check_len = 99;
        rep_flag = 0;
        flag_tracker = NaN.*ones(length(PPT_in),1);
        
    end

% for i = 2:1:length(PPT_in)-check_len
%}




%     if PPT_in(i) - PPT_in(i+1) > 5
%         rep_flag = 0;
%     elseif PPT_in(i) - PPT_in(i+1) < - 0.5
%         rep_flag = 0;
%     elseif PPT_in(i) - PPT_in(i-1) > 0.5
%         rep_flag = 0;
%     else
%         tmp =  PPT_in(i) - PPT_in(i+1:i+check_len);
%     isless = find(tmp >= 0 & tmp < 5 ,1);
%     tmp2 = PPT_in(i) - PPT_in(i-1);
%     if ~isempty(isless) && abs(tmp2) < 1
%     rep_flag = 1;
%     else
%     rep_flag = 0;
%     end
%     end
%     %%% Replace value with previous one if flag is set to 1:
%     if rep_flag == 0
%         PPT_out(i) = PPT_in(i);
%     else
%         PPT_out(i) = PPT_out(i-1);
%     end
%     flag_tracker(i,1) = rep_flag;
% %
% %     %%% Set rep_flag:
% %     tmp =  PPT_in(i) - PPT_in(i+1:i+check_len);
% % %    tmp(:,i-1) = PPT_in(i) - PPT_in(i+1:i+99);
% %     tmp2 = PPT_in(i) - PPT_in(i-1);
% %     isless = find(tmp >= 0 ,1);
% %     if ~isempty(isless) && abs(tmp2) < 1
% % %         PPT_out(i) = PPT_out(i-1);
% % rep_flag = 1;
% %     else
% %         rep_flag = 0;
% %     end





