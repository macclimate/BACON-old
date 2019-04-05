% TP_rain_comp.m
%% This script attempts to fix problems with PPT data for TP met stations
%% OPTION - adjust this to toggle between options:
% opt = 2;
%% Path -- change to location of attached (unzipped) zip file
path = 'C:\HOME\MATLAB\Data\DataChecks\';
%% Load daily files:
Delhi_data = dlmread([path 'Delhi_Day_Precip_2002_2007.csv'], ',');
Delhi_PPT = Delhi_data(2:367,1:6); % 2002-2007 data
TP02_data = load([path 'TP02_Daily_Precip_2002_2007.txt']);
%% Load 1/2 hourly files
TP39hh = dlmread([path 'TP39_hh_Precip.csv'],',');
TP39_2007_RMY = load([path 'Met1_2007.017']);
TP02hh = dlmread([path 'TP02_hh_Precip.csv'],',');
%% Rules:
% MET 4:
% if Ta < 0 - use Delhi data
% treat summer data as real data, unless a problem is found.
%%% Missing data:
% take rainfall hours from Met 1
% apply proportion to Delhi daily data

for k = 1:1:5
    TP02(k).data = TP02hh(:,k);
    TP02(k).cumsum = cumsum(TP02hh(:,k));
    TP02(k).nancumsum = nancumsum(TP02hh(:,k));
    TP02(k).nans = find(isnan(TP02hh(:,k)));
    TP02(k).ptsused = length(find(~isnan(TP02hh(:,k))));

    TP39(k).data = TP39hh(:,k);
    TP39(k).cumsum = cumsum(TP39hh(:,k));
    TP39(k).nancumsum = nancumsum(TP39hh(:,k));
    TP39(k).nans = find(isnan(TP39hh(:,k)));
    TP39(k).ptsused = length(find(~isnan(TP39hh(:,k))));

    %     figure(1)
    Delhi_cumsum = nancumsum(Delhi_PPT);
    Delhi_tot = Delhi_cumsum(end,:);

end

%% Quickly compare number outputs between 3 sites for each year.

figure(2); clf

for j = 1:1:5
    plot(j,TP02(j).nancumsum(end),'r.'); hold on
    plot(j,TP39(j).nancumsum(end),'b.');
    plot(j,Delhi_tot(j+1),'g.');

end


%% Just for fun -- seeing if stuff fits together:
comb_PPT = [TP39_2007_RMY(1:9150); TP39hh(9151:17520,5)];
comb_PPT_nansum = nansum(comb_PPT) % gives value of 704.74 (compare to delhi 749.3)

comb_PPT2 = [TP39_2007_RMY(1:13565); TP39hh(13566:17520,5)];
comb_PPT_nansum2 = nansum(comb_PPT2) % gives value of 826.33 (compare to delhi 749.3)

%% Adding both rain guage data together for TP39, 2007:
TP39hh(1:17520,5) = comb_PPT;

%% Scatterplot btw RMY and CS rainguages:
ok_data = find (~isnan(TP39_2007_RMY) & ~isnan(TP39hh(1:17520,5)) & TP39_2007_RMY > 0 & TP39hh(1:17520,5) > 0 );
figure(7); clf
plot(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),'b.')
p = polyfit(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),1);
pred_RMY = polyval(p,TP39hh(ok_data,5));
rsq = rsquared(TP39_2007_RMY(ok_data), pred_RMY);
%%% Results - RMY is consistently 2X higher than CS Rsq = 0.94

%% %%%%%%%%%%%%%%***********************%%%%%%%%%%%%***********************

%% Adjust data based on delhi daily totals and timing of events as taken
%% from each site.

TP39_adj(1:17568,1:5) = NaN; TP39_adj2(1:17568,1:5) = NaN;
TP02_adj(1:17568,1:5) = NaN; TP02_adj2(1:17568,1:5) = NaN;

TP02_raw_daysum(1:366,1:5) = NaN; TP39_raw_daysum(1:366,1:5) = NaN;

TP39_adj_daysum(1:366,1:5) = NaN; TP39_adj2_daysum(1:366,1:5) = NaN;
TP02_adj_daysum(1:366,1:5) = NaN; TP02_adj2_daysum(1:366,1:5) = NaN;

%%% Cycle through years
for yr = 1:1:5
    disp(yr);

    for day = 1:1:366
        switchflag39 = 0; switchflag02 = 0;
        %%%%% finds if there is PPT recorded during a day at each site:
        daytot = Delhi_PPT(day,yr+1); if daytot > 0; Delhi_flag = 1; else Delhi_flag = 0; end;% gets the daily precip
        daytot39 = nansum(TP39hh(day*48-47:day*48,yr)); if daytot39 > 0; TP39_flag = 1; else TP39_flag = 0; end;% daily sum
        daytot02 = nansum(TP02hh(day*48-47:day*48,yr)); if daytot02 > 0; TP02_flag = 1; else TP02_flag = 0; end % daily sum

        %%%% CASE A: All guages report zero rain:
        if Delhi_flag == 0 && TP39_flag == 0 && TP02_flag == 0;
            TP39_adj1(day*48-47:day*48,yr) = 0; TP39_adj2(day*48-47:day*48,yr) = 0; TP39_adj3(day*48-47:day*48,yr) = 0;
            TP39_adj4(day*48-47:day*48,yr) = 0; TP39_adj5(day*48-47:day*48,yr) = 0; TP39_adj6(day*48-47:day*48,yr) = 0;
            TP39_adj7(day*48-47:day*48,yr) = 0; TP39_adj8(day*48-47:day*48,yr) = 0;

            TP02_adj1(day*48-47:day*48,yr) = 0; TP02_adj2(day*48-47:day*48,yr) = 0; TP02_adj3(day*48-47:day*48,yr) = 0;
            TP02_adj4(day*48-47:day*48,yr) = 0; TP02_adj5(day*48-47:day*48,yr) = 0; TP02_adj6(day*48-47:day*48,yr) = 0;
            TP02_adj7(day*48-47:day*48,yr) = 0; TP02_adj8(day*48-47:day*48,yr) = 0;

            %%%% CASE B: All guages report 1:
        elseif Delhi_flag == 1 && TP39_flag == 1 && TP02_flag == 1;
            TP39_adj1(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj2(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj3(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
            TP39_adj4(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj5(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj6(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
            TP39_adj7(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj8(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);

            TP02_adj1(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj2(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj3(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
            TP02_adj4(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj5(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj6(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
            TP02_adj7(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj8(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);

            %%%% CASE C: Delhi reports no rain, but the other two guages do:
        elseif Delhi_flag == 0 && TP39_flag+TP02_flag == 2;
            TP39_adj1(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj2(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj3(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
            TP39_adj4(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj5(day*48-47:day*48,yr) = 0; TP39_adj6(day*48-47:day*48,yr) = 0;
            TP39_adj7(day*48-47:day*48,yr) = 0; TP39_adj8(day*48-47:day*48,yr) = 0;

            TP02_adj1(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj2(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj3(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
            TP02_adj4(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj5(day*48-47:day*48,yr) = 0; TP02_adj6(day*48-47:day*48,yr) = 0;
            TP02_adj7(day*48-47:day*48,yr) = 0; TP02_adj8(day*48-47:day*48,yr) = 0;

            %%%% CASE D: Delhi reports rain and so does one of the two other stations:
        elseif Delhi_flag == 1 && TP39_flag+TP02_flag == 1;

            if Delhi_flag == 1 && TP39_flag== 1 && TP02_flag == 0;
                TP39_adj1(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj2(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj3(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
                TP39_adj4(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj5(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj6(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
                TP39_adj7(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj8(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
                dayfrac39 = TP39hh(day*48-47:day*48,yr)./daytot39;

                TP02_adj1(day*48-47:day*48,yr) = dayfrac39.*daytot; TP02_adj2(day*48-47:day*48,yr) = dayfrac39.*daytot; TP02_adj3(day*48-47:day*48,yr) = dayfrac39.*daytot;
                TP02_adj4(day*48-47:day*48,yr) = dayfrac39.*daytot; TP02_adj5(day*48-47:day*48,yr) = dayfrac39.*daytot; TP02_adj6(day*48-47:day*48,yr) = dayfrac39.*daytot;
                TP02_adj7(day*48-47:day*48,yr) = dayfrac39.*daytot; TP02_adj8(day*48-47:day*48,yr) = dayfrac39.*daytot;

            elseif Delhi_flag == 1 && TP39_flag== 0 && TP02_flag == 1;
                TP02_adj1(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj2(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj3(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
                TP02_adj4(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj5(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj6(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
                TP02_adj7(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj8(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
                datfrac02 = TP02hh(day*48-47:day*48,yr)./daytot02;
                TP39_adj1(day*48-47:day*48,yr) = dayfrac02.*daytot; TP39_adj2(day*48-47:day*48,yr) = dayfrac02.*daytot; TP39_adj3(day*48-47:day*48,yr) = dayfrac02.*daytot;
                TP39_adj4(day*48-47:day*48,yr) = dayfrac02.*daytot; TP39_adj5(day*48-47:day*48,yr) = dayfrac02.*daytot; TP39_adj6(day*48-47:day*48,yr) = dayfrac02.*daytot;
                TP39_adj7(day*48-47:day*48,yr) = dayfrac02.*daytot; TP39_adj8(day*48-47:day*48,yr) = dayfrac02.*daytot;
            end

            %%%% CASE E: Delhi reads precip, but there is no rain at either station:
        elseif Delhi_flag == 1 && TP39_flag+TP02_flag == 0;

            TP39_adj1(day*48-47:day*48,yr) = daytot./48; TP39_adj2(day*48-47:day*48,yr) = 0; TP39_adj3(day*48-47:day*48,yr) = daytot./48;
            TP39_adj4(day*48-47:day*48,yr) = 0; TP39_adj5(day*48-47:day*48,yr) = daytot./48; TP39_adj6(day*48-47:day*48,yr) = 0;
            TP39_adj7(day*48-47:day*48,yr) = daytot./48; TP39_adj8(day*48-47:day*48,yr) = 0;

            TP02_adj1(day*48-47:day*48,yr) = daytot./48; TP02_adj2(day*48-47:day*48,yr) = 0; TP02_adj3(day*48-47:day*48,yr) = daytot./48;
            TP02_adj4(day*48-47:day*48,yr) = 0; TP02_adj5(day*48-47:day*48,yr) = daytot./48; TP02_adj6(day*48-47:day*48,yr) = 0;
            TP02_adj7(day*48-47:day*48,yr) = daytot./48; TP02_adj8(day*48-47:day*48,yr) = 0;

            %%%% CASE F: Delhi reads precip, but there is no rain at either station:
        elseif Delhi_flag == 0 && TP39_flag+TP02_flag == 1;
            if Delhi_flag == 0 && TP39_flag == 1 && TP02_flag == 0;
                TP39_adj1(day*48-47:day*48,yr) = 0; TP39_adj2(day*48-47:day*48,yr) = 0; TP39_adj3(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
                TP39_adj4(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj5(day*48-47:day*48,yr) = 0; TP39_adj6(day*48-47:day*48,yr) = 0;
                TP39_adj7(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr); TP39_adj8(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);

                TP02_adj1(day*48-47:day*48,yr) = 0; TP02_adj2(day*48-47:day*48,yr) = 0; TP02_adj3(day*48-47:day*48,yr) = 0;
                TP02_adj4(day*48-47:day*48,yr) = 0; TP02_adj5(day*48-47:day*48,yr) = 0; TP02_adj6(day*48-47:day*48,yr) = 0;
                TP02_adj7(day*48-47:day*48,yr) = 0; TP02_adj8(day*48-47:day*48,yr) = 0;

            elseif Delhi_flag == 0 && TP39_flag == 1 && TP02_flag == 0;
                TP39_adj1(day*48-47:day*48,yr) = 0; TP39_adj2(day*48-47:day*48,yr) = 0; TP39_adj3(day*48-47:day*48,yr) = 0;
                TP39_adj4(day*48-47:day*48,yr) = 0; TP39_adj5(day*48-47:day*48,yr) = 0; TP39_adj6(day*48-47:day*48,yr) = 0;
                TP39_adj7(day*48-47:day*48,yr) = 0; TP39_adj8(day*48-47:day*48,yr) = 0;

                TP02_adj1(day*48-47:day*48,yr) = 0; TP02_adj2(day*48-47:day*48,yr) = 0; TP02_adj3(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
                TP02_adj4(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj5(day*48-47:day*48,yr) = 0; TP02_adj6(day*48-47:day*48,yr) = 0;
                TP02_adj7(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr); TP02_adj8(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);

            end

        end % ends 'if' loop
        TP39_adj1_daysum(day,yr) = nansum(TP39_adj1(day*48-47:day*48,yr)); TP39_adj2_daysum(day,yr) = nansum(TP39_adj2(day*48-47:day*48,yr));
        TP39_adj3_daysum(day,yr) = nansum(TP39_adj3(day*48-47:day*48,yr)); TP39_adj4_daysum(day,yr) = nansum(TP39_adj4(day*48-47:day*48,yr));
        TP39_adj5_daysum(day,yr) = nansum(TP39_adj5(day*48-47:day*48,yr)); TP39_adj6_daysum(day,yr) = nansum(TP39_adj6(day*48-47:day*48,yr));
        TP39_adj7_daysum(day,yr) = nansum(TP39_adj7(day*48-47:day*48,yr)); TP39_adj8_daysum(day,yr) = nansum(TP39_adj8(day*48-47:day*48,yr));

        TP02_adj1_daysum(day,yr) = nansum(TP02_adj1(day*48-47:day*48,yr)); TP02_adj2_daysum(day,yr) = nansum(TP02_adj2(day*48-47:day*48,yr));
        TP02_adj3_daysum(day,yr) = nansum(TP02_adj3(day*48-47:day*48,yr)); TP02_adj4_daysum(day,yr) = nansum(TP02_adj4(day*48-47:day*48,yr));
        TP02_adj5_daysum(day,yr) = nansum(TP02_adj5(day*48-47:day*48,yr)); TP02_adj6_daysum(day,yr) = nansum(TP02_adj6(day*48-47:day*48,yr));
        TP02_adj7_daysum(day,yr) = nansum(TP02_adj7(day*48-47:day*48,yr)); TP02_adj8_daysum(day,yr) = nansum(TP02_adj8(day*48-47:day*48,yr));

    end % ends day loop
    TP39(yr).dayraw = TP39_raw_daysum(:,yr);
    TP39(yr).PPT_adj1 = TP39_adj1(:,yr); TP39(yr).adj1cumsum = nancumsum(TP39_adj1(:,yr)); TP39(yr).adj1sum = TP39(yr).adj1cumsum(end); TP39(yr).dayadj1 = TP39_adj_day1sum(:,yr);
    TP39(yr).PPT_adj2 = TP39_adj2(:,yr); TP39(yr).adj2cumsum = nancumsum(TP39_adj2(:,yr)); TP39(yr).adj2sum = TP39(yr).adj2cumsum(end); TP39(yr).dayadj2 = TP39_adj_day2sum(:,yr);
    TP39(yr).PPT_adj3 = TP39_adj3(:,yr); TP39(yr).adj3cumsum = nancumsum(TP39_adj3(:,yr)); TP39(yr).adj3sum = TP39(yr).adj3cumsum(end); TP39(yr).dayadj3 = TP39_adj_day3sum(:,yr);
    TP39(yr).PPT_adj4 = TP39_adj4(:,yr); TP39(yr).adj4cumsum = nancumsum(TP39_adj4(:,yr)); TP39(yr).adj4sum = TP39(yr).adj4cumsum(end); TP39(yr).dayadj4 = TP39_adj_day4sum(:,yr);
    TP39(yr).PPT_adj5 = TP39_adj5(:,yr); TP39(yr).adj5cumsum = nancumsum(TP39_adj5(:,yr)); TP39(yr).adj5sum = TP39(yr).adj5cumsum(end); TP39(yr).dayadj5 = TP39_adj_day5sum(:,yr);
    TP39(yr).PPT_adj6 = TP39_adj6(:,yr); TP39(yr).adj6cumsum = nancumsum(TP39_adj6(:,yr)); TP39(yr).adj6sum = TP39(yr).adj6cumsum(end); TP39(yr).dayadj6 = TP39_adj_day6sum(:,yr);
    TP39(yr).PPT_adj7 = TP39_adj7(:,yr); TP39(yr).adj7cumsum = nancumsum(TP39_adj7(:,yr)); TP39(yr).adj7sum = TP39(yr).adj7cumsum(end); TP39(yr).dayadj7 = TP39_adj_day7sum(:,yr);
    TP39(yr).PPT_adj8 = TP39_adj8(:,yr); TP39(yr).adj8cumsum = nancumsum(TP39_adj8(:,yr)); TP39(yr).adj8sum = TP39(yr).adj8cumsum(end); TP39(yr).dayadj8 = TP39_adj_day8sum(:,yr);

    TP02(yr).dayraw = TP02_raw_daysum(:,yr);
    TP02(yr).PPT_adj1 = TP02_adj1(:,yr); TP02(yr).adj1cumsum = nancumsum(TP02_adj1(:,yr)); TP02(yr).adj1sum = TP02(yr).adj1cumsum(end); TP02(yr).dayadj1 = TP02_adj_day1sum(:,yr);
    TP02(yr).PPT_adj2 = TP02_adj2(:,yr); TP02(yr).adj2cumsum = nancumsum(TP02_adj2(:,yr)); TP02(yr).adj2sum = TP02(yr).adj2cumsum(end); TP02(yr).dayadj2 = TP02_adj_day2sum(:,yr);
    TP02(yr).PPT_adj3 = TP02_adj3(:,yr); TP02(yr).adj3cumsum = nancumsum(TP02_adj3(:,yr)); TP02(yr).adj3sum = TP02(yr).adj3cumsum(end); TP02(yr).dayadj3 = TP02_adj_day3sum(:,yr);
    TP02(yr).PPT_adj4 = TP02_adj4(:,yr); TP02(yr).adj4cumsum = nancumsum(TP02_adj4(:,yr)); TP02(yr).adj4sum = TP02(yr).adj4cumsum(end); TP02(yr).dayadj4 = TP02_adj_day4sum(:,yr);
    TP02(yr).PPT_adj5 = TP02_adj5(:,yr); TP02(yr).adj5cumsum = nancumsum(TP02_adj5(:,yr)); TP02(yr).adj5sum = TP02(yr).adj5cumsum(end); TP02(yr).dayadj5 = TP02_adj_day5sum(:,yr);
    TP02(yr).PPT_adj6 = TP02_adj6(:,yr); TP02(yr).adj6cumsum = nancumsum(TP02_adj6(:,yr)); TP02(yr).adj6sum = TP02(yr).adj6cumsum(end); TP02(yr).dayadj6 = TP02_adj_day6sum(:,yr);
    TP02(yr).PPT_adj7 = TP02_adj7(:,yr); TP02(yr).adj7cumsum = nancumsum(TP02_adj7(:,yr)); TP02(yr).adj7sum = TP02(yr).adj7cumsum(end); TP02(yr).dayadj7 = TP02_adj_day7sum(:,yr);
    TP02(yr).PPT_adj8 = TP02_adj8(:,yr); TP02(yr).adj8cumsum = nancumsum(TP02_adj8(:,yr)); TP02(yr).adj8sum = TP02(yr).adj8cumsum(end); TP02(yr).dayadj8 = TP02_adj_day8sum(:,yr);
end




%     %% Compare the results:
%     results(1:8,1:5) = NaN;
%     results(1,1:5) = Delhi_tot(1,2:6); % Delhi numbers
%     for k = 1:1:5
%         results(2,k) = TP39(k).nancumsum(end);
%         results(3,k) = TP39(k).adjsum;
%         results(4,k) = TP39(k).adj2sum;
%         results(5,k) = TP02(k).nancumsum(end);
%         results(6,k) = TP02(k).adjsum;
%         results(7,k) = TP02(k).adj2sum;
% 
% 
%         figure(10+k);clf
%         plot(nancumsum(Delhi_PPT(:,k+1)),'b-'); hold on
%         plot(nancumsum(TP39(k).dayraw),'r-');
%         plot(nancumsum(TP39(k).dayadj),'r--');
%         plot(nancumsum(TP39(k).dayadj2),'r:');
%         plot(nancumsum(TP02(k).dayraw),'g-');
%         plot(nancumsum(TP02(k).dayadj),'g--');
%         plot(nancumsum(TP02(k).dayadj2),'g:');
% 
%         legend('Delhi','TP39raw','TP39adj1','TP39adj2','TP02raw','TP02adj1','TP02adj2',2);
%     end
%     %% Package the data:
    %
    % for k = 1:1:5
    % out_TP02_raw(:,k) = TP02(k).data;
    % out_TP02_adj1(:,k) = TP02(k).PPT_adj1;
    % out_TP02_adj2(:,k) = TP02(k).PPT_adj2;
    %
    % for k = 1:1:5
    % out_TP02_raw(:,k) = TP02(k).data;
    % out_TP02_adj1(:,k) = TP02(k).PPT_adj1;
    % out_TP02_adj2(:,k) = TP02(k).PPT_adj2;

