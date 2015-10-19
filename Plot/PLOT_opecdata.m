% function [] = PLOT_opecdata(site)
%% ***************** PLOT_opecdata.m ***************************
%%% This function is designed to plot flux variables for inspection of
%%% inter and intra-annual relationships.
clear all
close all
site = 2; 

%% Make Sure site and year are in string format

if ischar(site) == false
    site = num2str(site);
end
% if ischar(year) == false
%     year = num2str(year);
% end

%% Load Variables

% %%% dt
[junk(:,1) junk(:,2) junk(:,3) dt]  = jjb_makedate(str2double('2004'),30);

NEE(1:17568,1:5) = NaN;
NEE_raw(1:17568,1:5) = NaN;
GEP(1:17568,1:5) = NaN;
Resp(1:17568,1:5) = NaN;
LE(1:17568,1:5) = NaN;

G0(1:17568,1:5) = NaN;
T_air(1:17568,1:5) = NaN;
Ts2a(1:17568,1:5) = NaN;
PAR(1:17568,1:5) = NaN;

SM5a(1:17568,1:5) = NaN;
SM10a(1:17568,1:5) = NaN;
SM20a(1:17568,1:5) = NaN;
SM50a(1:17568,1:5) = NaN;
SM100a(1:17568,1:5) = NaN;
SM5b(1:17568,1:5) = NaN;
SM10b(1:17568,1:5) = NaN;
SM20b(1:17568,1:5) = NaN;
SM50b(1:17568,1:5) = NaN;
SM100b(1:17568,1:5) = NaN;

ctr_1 = 1;
% for site2 = 1:1:4

%% Load variables
for year2 = 2002:1:2006

    %%% Master Flux Table paths
    load_path_op = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Met' site '\Column\Met' site '_' num2str(year2) '.']);
    hdr_path_op = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Docs\Met' site '_FluxColumns.csv']);

    %% Load Header Files
    % [hdr_cell_met] = jjb_hdr_read(hdr_path_met,',',3);
    [hdr_cell_op]  = jjb_hdr_read(hdr_path_op,',',2);

    out_path_op = (['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_']);
    load_path_op = (['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Met' site '\Column\Met' site '_' num2str(year2) '.']);
    calc_path_met = (['C:\Home\Matlab\Data\Met\Calculated4\Met' site '\Met' site '_' num2str(year2) '_']);

    NEE_x = load(['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_NEE_final_4.dat']);
    NEE(1:length(NEE_x),ctr_1) = NEE_x;

    NEE_raw_x = load([out_path_op 'NEE_raw.dat']);
    NEE_raw(1:length(NEE_raw_x),ctr_1) = NEE_raw_x;

    LE_x = load(['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_LE.dat']);
    LE(1:length(LE_x),ctr_1) = LE_x;

    Hs_x = load(['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_Hs.dat']);
    Hs(1:length(Hs_x),ctr_1) = Hs_x;
    
    Jt_x = load(['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_Jt.dat']);
    Jt(1:length(Jt_x),ctr_1) = Jt_x;
    
    G0_x = load(['C:\Home\Matlab\Data\Met\Calculated4\Met' site '\Met' site '_' num2str(year2) '_g0.dat']);
    G0(1:length(G0_x),ctr_1) = G0_x;

%     Rn_x = load(['C:\Home\Matlab\Data\Flux\OPEC\Calculated4\Met' site '\Met' site '_' num2str(year2) '_Rn.dat']);
%     Rn(1:length(Rn_x),ctr_1) = Rn_x;
    
    Rn_x = jjb_load_var(hdr_cell_op, load_path_op, 'NetRad_AbvCnpy');
    Rn(1:length(Rn_x),ctr_1) = Rn_x;

    T_air_x = jjb_load_var(hdr_cell_op, load_path_op, 'AirTemp_AbvCnpy');
    T_air(1:length(T_air_x),ctr_1) = T_air_x;

    Ts2a_x = load([calc_path_met 'Ts.dat']);
    Ts2a(1:length(Ts2a_x),ctr_1) = Ts2a_x;

    PAR_x = jjb_load_var(hdr_cell_op, load_path_op, 'DownPAR_AbvCnpy');
    PAR(1:length(PAR_x),ctr_1) = PAR_x;

    GEP_x = load([out_path_op 'GEP.dat']);
    GEP(1:length(GEP_x),ctr_1) = GEP_x;

    Resp_x = load([out_path_op 'Resp.dat']);
    Resp(1:length(Resp_x),ctr_1) = Resp_x;

    % Soil Moisture Profile

    SM5a_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_A_5cm');
    SM10a_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_A_10cm');
    SM20a_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_A_20cm');
    SM50a_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_A_50cm');

    SM5a(1:length(SM5a_x),ctr_1) = SM5a_x;
    SM10a(1:length(SM10a_x),ctr_1) = SM10a_x;
    SM20a(1:length(SM20a_x),ctr_1) = SM20a_x;
    SM50a(1:length(SM50a_x),ctr_1) = SM50a_x;

    SM5b_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_B_5cm');
    SM10b_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_B_10cm');
    SM20b_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_B_20cm');
    SM50b_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_B_50cm');

    SM5b(1:length(SM5b_x),ctr_1) = SM5b_x;
    SM10b(1:length(SM10b_x),ctr_1) = SM10b_x;
    SM20b(1:length(SM20b_x),ctr_1) = SM20b_x;
    SM50b(1:length(SM50b_x),ctr_1) = SM50b_x;


    %% Load 1m Soil Moisture data if it exists
    ind1a = strcmp('SM_A_100cm',hdr_cell_op(:,2))==1;
    ind2a = find(ind1a(:,1)==1);
    if ~isempty(ind2a)
        SM100a_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_A_100cm');
        SM100a(1:length(SM100a_x),ctr_1) = SM100a_x;
    end

    ind1b = strcmp('SM_B_100cm',hdr_cell_op(:,2))==1;
    ind2b = find(ind1b(:,1)==1);
    if ~isempty(ind2a)
        SM100b_x = jjb_load_var(hdr_cell_op, load_path_op, 'SM_B_100cm');
        SM100b(1:length(SM100b_x),ctr_1) = SM100b_x;

    end

    %%% Load coefficients calculated for PAR vs GEP curve and Ts vs R:
    PAR_GEP(:,:) = load([out_path_op 'GEP_PAR_cx_Avg.dat']);
    PAR_scale(:,ctr_1) = PAR_GEP(:,1);
    GEP_pred(:,ctr_1) = PAR_GEP(:,2);
    
    Ts_R(:,:) = load([out_path_op 'NEE_Ts_cx_Avg.dat']);
    Ts_scale(:,ctr_1) = Ts_R(:,1);
    R_pred(:,ctr_1) = Ts_R(:,2);
    
    
    clear *_x PAR_GEP Ts_R;
    ctr_1 = ctr_1 + 1;
end

%% Calculate avg root-depth water availability
SMa_avg = .375*SM5a + .375*SM10a + 0.25*SM20a;
SMb_avg = .375*SM5b + .375*SM10b + 0.25*SM20b;
for jj = 1:1:5
SMa_avg(isnan(SMa_avg(:,jj)),jj) = SMb_avg(isnan(SMa_avg(:,jj)),jj);
end
%% Plot met variables and NEE for all years in separate plots
years = (2002:1:2006)';
close all
for a = 1:1:5
    figure(a)
    plot(dt,NEE_raw(:,a))
    hold on;
    plot(dt,T_air(:,a),'r')
    plot(dt,Ts2a(:,a),'k')
    plot(dt,SM5a(:,a)*100,'g')
    title(['Year' num2str(years(a))])
    axis tight
    grid on
end

%% Calculate daily averages of variables and plot
clear NEE_day NEE_day_avg NEE_d_avg ;
% NEE_d_avg(1:17568,1:5) = NaN;
% GEP_d_avg(1:17568,1:5) = NaN;
% Resp_d_avg(1:17568,1:5) = NaN;
% Ts_d_avg(1:17568,1:5) = NaN;
% PAR_d_avg(1:17568,1:5) = NaN;
% Tair_d_avg(1:17568,1:5) = NaN;
% SMa_d_avg(1:17568,1:5) = NaN;
% SMb_d_avg(1:17568,1:5) = NaN;

for n = 1:1:5

    avg_length = 48; %288 = 6-day avg, 48 = 1-day
    day_int_plot = (avg_length/48);

    % NEE
    NEE_day = reshape(NEE(:,n),avg_length,[]);
    NEE_day_avg =  mean(NEE_day);
    NEE_d_avg(:,n) = NEE_day_avg';
% GEP
    GEP_day = reshape(GEP(:,n),avg_length,[]);  %% makes 6-day avg when 288
    GEP_day_avg = mean(GEP_day);
    GEP_d_avg(:,n) = GEP_day_avg';
%Resp
    Resp_day = reshape(Resp(:,n),avg_length,[]);  %% makes 6-day avg when 288
    Resp_day_avg = mean(Resp_day);
    Resp_d_avg(:,n) = Resp_day_avg';
% Ts
Ts_day = reshape(Ts2a(:,n),avg_length,[]);
Ts_day_avg = mean(Ts_day);
Ts_d_avg(:,n) = Ts_day_avg';
% PAR
PAR_day = reshape(PAR(:,n),avg_length,[]);
PAR_day_avg = mean(PAR_day);
PAR_d_avg(:,n) = PAR_day_avg';

% T_air
Tair_day = reshape(T_air(:,n),avg_length,[]);
Tair_day_avg = mean(Tair_day);
Tair_d_avg(:,n) = Tair_day_avg';    
    
% SMa_avg
SMa_day = reshape(SMa_avg(:,n),avg_length,[]);
SMa_day_avg = mean(SMa_day);
SMa_d_avg(:,n) = SMa_day_avg';    

% SMb_avg
SMb_day = reshape(SMb_avg(:,n),avg_length,[]);
SMb_day_avg = mean(SMb_day);
SMb_d_avg(:,n) = SMb_day_avg';    
end

colour_list = [1 0 1; 1 0 0; 1 1 0; 0 1 1; 0 0 1];
for b = 1:1:5
    figure(6)
    HNEE(b) = plot((day_int_plot:day_int_plot:366), NEE_d_avg(:,b), 'Color', colour_list(b,:), 'LineStyle','-');
    hold on;
    figure(7)
    hold on;
    HGEP(b) = plot((day_int_plot:day_int_plot:366), GEP_d_avg(:,b), 'Color', colour_list(b,:), 'LineStyle','-');
    figure(8)
    hold on;
    HResp(b) = plot((day_int_plot:day_int_plot:366), Resp_d_avg(:,b), 'Color', colour_list(b,:), 'LineStyle','-');
end
figure (6)
title(['NEE for Met' num2str(site)])
legend(HNEE, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(7)
title(['GEP for Met' num2str(site)])
legend(HGEP, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(8)
title(['Resp for Met' num2str(site)])
legend(HResp, '2002', '2003', '2004', '2005', '2006',4);
axis tight


%% Calculate Monthly averages of variables
%%% Create variable recording start and end days-of-year for each month
%%% ** NOTE- values are slightly off for Feb & Mar to accommodate for leap
%%% years in file.

month_days = ...
[ 1  1 31;...
  2  32  60;...
  3  61  90;...
  4  91  120;...
  5  121 151;...
  6  152 181;...
  7  182 212;...
  8  213 243;...
  9  244 273;...
  10 274 304;...
  11 305 334;...
  12 335 366];

for b2 = 1:1:5
for month = 1:1:12
    NEE_mon(month,b2) = nanmean(NEE_d_avg(month_days(month,2):month_days(month,3),b2));
    GEP_mon(month,b2) = nanmean(GEP_d_avg(month_days(month,2):month_days(month,3),b2));
    Resp_mon(month,b2) = nanmean(Resp_d_avg(month_days(month,2):month_days(month,3),b2));
end
end

month_list = (1:1:12);
colour_list = [1 0 1; 1 0 0; 1 1 0; 0 1 1; 0 0 1];
for c = 1:1:5
    figure(9)
    HNEE_mon(c) = plot(month_list, NEE_mon(:,c), 'Color', colour_list(c,:), 'LineStyle','-');
    hold on;
    figure(10)
    hold on;
    HGEP_mon(c) = plot(month_list, GEP_mon(:,c), 'Color', colour_list(c,:), 'LineStyle','-');
    figure(11)
    hold on;
    HResp_mon(c) = plot(month_list, Resp_mon(:,c), 'Color', colour_list(c,:), 'LineStyle','-');
end

figure (9)
title(['Monthly avg NEE for Met' num2str(site)])
legend(HNEE_mon, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(10)
title(['Monthly avg GEP for Met' num2str(site)])
legend(HGEP_mon, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(11)
title(['Monthly avg Resp for Met' num2str(site)])
legend(HResp_mon, '2002', '2003', '2004', '2005', '2006',4);
axis tight

%% Cumulative Sums for each year

for b3 = 1:1:5
    NEE_cs(:,b3) = cumsum(NEE_d_avg(:,b3));
    GEP_cs(:,b3) = cumsum(GEP_d_avg(:,b3));
    Resp_cs(:,b3) = cumsum(Resp_d_avg(:,b3));
end

for d = 1:1:5
    figure(12)
    HNEE_cs(d) = plot((day_int_plot:day_int_plot:366), NEE_cs(:,d), 'Color', colour_list(d,:), 'LineStyle','-');
    hold on;
    figure(13)
    hold on;
    HGEP_cs(d) = plot((day_int_plot:day_int_plot:366), GEP_cs(:,d), 'Color', colour_list(d,:), 'LineStyle','-');
    figure(14)
    hold on;
    HResp_cs(d) = plot((day_int_plot:day_int_plot:366), Resp_cs(:,d), 'Color', colour_list(d,:), 'LineStyle','-');
end

figure (12)
title(['Cumulative NEE for Met' num2str(site)])
legend(HNEE_cs, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(13)
title(['Cumulative GEP for Met' num2str(site)])
legend(HGEP_cs, '2002', '2003', '2004', '2005', '2006',4);
axis tight
figure(14)
title(['Cumulative Resp for Met' num2str(site)])
legend(HResp_cs, '2002', '2003', '2004', '2005', '2006',4);
axis tight

%% Compare PAR vs GEP curves for different years at the same site

for e = 1:1:5
    
    figure(15)
    H_PAR_GEP(e)= plot(PAR_scale(:,1), GEP_pred(:,e), 'Color', colour_list(e,:), 'LineStyle','-', 'Marker', '.');
    hold on;

    figure(16)
    H_Ts_R(e) = plot(Ts_scale(:,1), R_pred(:,e), 'Color', colour_list(e,:), 'LineStyle','-', 'Marker', '.');
    hold on;
end


figure (15)
title(['PAR vs GEP for Met' num2str(site)])
legend(H_PAR_GEP, '2002', '2003', '2004', '2005', '2006',4);
ylabel('GEP')
xlabel('PPFD')
axis tight
figure(16)
title(['Ts vs Resp for Met' num2str(site)])
legend(H_Ts_R, '2002', '2003', '2004', '2005', '2006',4);
ylabel('Respiration')
xlabel('Ts')
axis tight

%% plot different met variables for comparison between years

figure(17)
for f = 1:1:5
    subplot(4,1,1)
    hold on;
    H_Ta_day(f) = plot((day_int_plot:day_int_plot:366),Tair_d_avg(:,f), 'Color', colour_list(f,:), 'LineStyle','-');
 
    
    subplot(4,1,2)
    hold on;
    H_Ts_day(f) = plot((day_int_plot:day_int_plot:366),Ts_d_avg(:,f), 'Color', colour_list(f,:), 'LineStyle','-');
  
    
      subplot(4,1,3)
    hold on;
    H_PAR_day(f) = plot((day_int_plot:day_int_plot:366),PAR_d_avg(:,f), 'Color', colour_list(f,:), 'LineStyle','-');
   
    
      subplot(4,1,4)
    hold on;
    H_SMa_day(f) = plot((day_int_plot:day_int_plot:366),SMa_d_avg(:,f), 'Color', colour_list(f,:), 'LineStyle','-');
  
    
end

figure (17)
subplot(4,1,1)
legend(H_Ta_day,  '2002', '2003', '2004', '2005', '2006',4);
ylabel('Air Temp')

subplot(4,1,2)
legend(H_Ts_day,  '2002', '2003', '2004', '2005', '2006',4);
ylabel('Soil SFC Temp')

subplot(4,1,3)
legend(H_PAR_day,  '2002', '2003', '2004', '2005', '2006',4);
ylabel('PAR')

subplot(4,1,4)
legend(H_SMa_day,  '2002', '2003', '2004', '2005', '2006',4);
ylabel('Root Zone SM')
xlabel('Day of Year')




    
