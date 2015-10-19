% TP_rain_comp.m
%% This script attempts to fix problems with PPT data for TP met stations
%% OPTION - adjust this to toggle between options:
opt = 2;
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
% comb_PPT = [TP39_2007_RMY(1:9150); TP39hh(9151:17520,5)];
% comb_PPT_nansum = nansum(comb_PPT) % gives value of 704.74 (compare to delhi 749.3)
% 
% comb_PPT2 = [TP39_2007_RMY(1:13565); TP39hh(13566:17520,5)];
% comb_PPT_nansum2 = nansum(comb_PPT2) % gives value of 826.33 (compare to delhi 749.3)
% 
% %% Adding both rain guage data together for TP39 2007:
% TP39hh(1:17520,5) = comb_PPT;
% 

xval = (1:1:length(TP39_2007_RMY))';
TP39_2007_RMY_lin(1:length(TP39_2007_RMY),1) = 0;
TP39_2007_RMY_lin(1:length(TP39_2007_RMY),1) = 0;

TP39_2007_RMY_lin(xval>=1 & xval <= 9150 & TP39_2007_RMY > 0)= (TP39_2007_RMY(xval>=1 & xval <= 9150 & TP39_2007_RMY > 0)+0.2648)./1.9568;
test1 = nansum(TP39_2007_RMY_lin(1:9150))

TP39_2007_RMY_lin0(1:9150)= (TP39_2007_RMY(1:9150))./1.8503;
test2 = nansum(TP39_2007_RMY_lin0(1:9150))
test3 = nansum(TP39hh(1:17520,5))
%% Scatterplot btw RMY and CS rainguages:
ok_data = find (~isnan(TP39_2007_RMY) & ~isnan(TP39hh(1:17520,5)) & TP39_2007_RMY > 0 & TP39hh(1:17520,5) > 0 );
figure(7); clf
plot(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),'b.')
p = polyfit(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),1);
p2 = mmpolyfit(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),1,'ZeroCoef',[0]);
pred_RMY = polyval(p,TP39hh(ok_data,5));
pred_RMY2 = polyval(p2,TP39hh(ok_data,5));
rsq = rsquared(TP39_2007_RMY(ok_data), pred_RMY);
rsq2 = rsquared(TP39_2007_RMY(ok_data), pred_RMY2);
hold on;
plot(TP39hh(ok_data,5),pred_RMY,'ro')
plot(TP39hh(ok_data,5),pred_RMY2,'go')
%%% Try log transforming data:
% ln_RMY = log(TP39_2007_RMY(ok_data));
% ln_CS = log(TP39hh(ok_data,5)+3);
figure(8);clf;
% plot(ln_CS,ln_RMY,'ro'); hold on;
% p_pwr = polyfit(ln_CS,ln_RMY,1);
% pred_RMY_pwr = ((TP39hh(ok_data,5)+3).^p_pwr(1)).*p_pwr(2) ;
p_exp = polyfit(TP39hh(ok_data,5),TP39_2007_RMY(ok_data),2);
pred_RMY_exp = polyval(p_exp,TP39hh(ok_data,5));
rsq_exp = rsquared(TP39_2007_RMY(ok_data), pred_RMY_exp);

figure(7); hold on;
% plot(TP39hh(ok_data,5),pred_RMY_pwr,'go')
plot(TP39hh(ok_data,5),pred_RMY_exp,'co')
%%% Results - RMY is consistently 2X higher than CS Rsq = 0.94

%% Adjust data based on delhi daily totals and timing of events as taken
%% from each site.

TP39_adj(1:17568,1:5) = NaN; TP39_adj2(1:17568,1:5) = NaN;

TP02_adj(1:17568,1:5) = NaN; TP02_adj2(1:17568,1:5) = NaN;

TP02_raw_daysum(1:366,1:5) = NaN; TP39_raw_daysum(1:366,1:5) = NaN;

TP39_adj_daysum(1:366,1:5) = NaN; TP39_adj2_daysum(1:366,1:5) = NaN;
TP02_adj_daysum(1:366,1:5) = NaN; TP02_adj2_daysum(1:366,1:5) = NaN;


for yr = 1:1:5
    disp(yr);
    for day = 1:1:366
        switchflag39 = 0; switchflag02 = 0;

        daytot = Delhi_PPT(day,yr+1); % gets the daily precip

        daytot39 = nansum(TP39hh(day*48-47:day*48,yr)); % daily sum
        daytot02 = nansum(TP02hh(day*48-47:day*48,yr)); % daily sum

        TP39_raw_daysum(day,yr) = daytot39;
        TP02_raw_daysum(day,yr) = daytot02;
        if opt == 2
        if daytot39 == 0 && daytot > 0 %% This command works as a crosscheck btw sites for rain
            daytot39 = daytot02;
            switchflag39 = 1;
        end
        end
        
        if daytot39 == 0 %&& daytot == 0
            TP39_adj(day*48-47:day*48,yr) = 0; TP39_adj2(day*48-47:day*48,yr) = 0;
        elseif daytot39 ~=0 && daytot == 0
            TP39_adj(day*48-47:day*48,yr) = 0; TP39_adj2(day*48-47:day*48,yr) = TP39hh(day*48-47:day*48,yr);
        else
            if switchflag39 == 1
                dayfrac39 = TP02hh(day*48-47:day*48,yr)./daytot39;
            else
                dayfrac39 = TP39hh(day*48-47:day*48,yr)./daytot39;
            end

            daytot39_adj = dayfrac39.*daytot;
            TP39_adj(day*48-47:day*48,yr) = daytot39_adj; TP39_adj2(day*48-47:day*48,yr) = daytot39_adj;
        end
TP39_adj_daysum(day,yr) = nansum(TP39_adj(day*48-47:day*48,yr));
TP39_adj2_daysum(day,yr) = nansum(TP39_adj2(day*48-47:day*48,yr));     

%%%%%%%%%%%%
if opt == 2
        if daytot02 == 0 && daytot > 0 %% This command works as a crosscheck btw sites for rain
            daytot02 = daytot39;
            switchflag02 = 1;
        end
end

        if daytot02 == 0 %&& daytot == 0
            TP02_adj(day*48-47:day*48,yr) = 0; TP02_adj2(day*48-47:day*48,yr) = 0;
        elseif daytot02 ~=0 && daytot == 0
            TP02_adj(day*48-47:day*48,yr) = 0; TP02_adj2(day*48-47:day*48,yr) = TP02hh(day*48-47:day*48,yr);
        else
            if switchflag02 == 1
                dayfrac02 = TP39hh(day*48-47:day*48,yr)./daytot02;
            else
                dayfrac02 = TP02hh(day*48-47:day*48,yr)./daytot02;
            end
            daytot02_adj = dayfrac02.*daytot;
            TP02_adj(day*48-47:day*48,yr) = daytot02_adj; TP02_adj2(day*48-47:day*48,yr) = daytot02_adj;
        end
TP02_adj_daysum(day,yr) = nansum(TP02_adj(day*48-47:day*48,yr));
TP02_adj2_daysum(day,yr) = nansum(TP02_adj2(day*48-47:day*48,yr));  
        
        clear daytot39_adj daytot02_adj;


    end
    TP39(yr).PPT_adj = TP39_adj(:,yr);
    TP39(yr).adjcumsum = nancumsum(TP39_adj(:,yr));
    TP39(yr).adjsum = TP39(yr).adjcumsum(end);
    TP39(yr).PPT_adj2 = TP39_adj2(:,yr);
    TP39(yr).adj2cumsum = nancumsum(TP39_adj2(:,yr));
    TP39(yr).adj2sum = TP39(yr).adj2cumsum(end);
    TP39(yr).dayraw = TP39_raw_daysum(:,yr);
    TP39(yr).dayadj = TP39_adj_daysum(:,yr);
    TP39(yr).dayadj2 = TP39_adj2_daysum(:,yr);
    
    
    TP02(yr).PPT_adj = TP02_adj(:,yr);
    TP02(yr).adjcumsum = nancumsum(TP02_adj(:,yr));
    TP02(yr).adjsum = TP02(yr).adjcumsum(end);
    TP02(yr).PPT_adj2 = TP02_adj2(:,yr);
    TP02(yr).adj2cumsum = nancumsum(TP02_adj2(:,yr));
    TP02(yr).adj2sum = TP02(yr).adj2cumsum(end);
    TP02(yr).dayraw = TP02_raw_daysum(:,yr);
    TP02(yr).dayadj = TP02_adj_daysum(:,yr);
    TP02(yr).dayadj2 = TP02_adj2_daysum(:,yr);
end

%% Compare the results:
results(1:8,1:5) = NaN;
results(1,1:5) = Delhi_tot(1,2:6); % Delhi numbers
for k = 1:1:5
    results(2,k) = TP39(k).nancumsum(end);
    results(3,k) = TP39(k).adjsum;
    results(4,k) = TP39(k).adj2sum;
    results(5,k) = TP02(k).nancumsum(end);
    results(6,k) = TP02(k).adjsum;
    results(7,k) = TP02(k).adj2sum;
    
    
  figure(10+k);clf
  plot(nancumsum(Delhi_PPT(:,k+1)),'b-'); hold on
  plot(nancumsum(TP39(k).dayraw),'r-');
  plot(nancumsum(TP39(k).dayadj),'r--');
  plot(nancumsum(TP39(k).dayadj2),'r:');
  plot(nancumsum(TP02(k).dayraw),'g-');
  plot(nancumsum(TP02(k).dayadj),'g--');
  plot(nancumsum(TP02(k).dayadj2),'g:');  
  
  legend('Delhi','TP39raw','TP39adj1','TP39adj2','TP02raw','TP02adj1','TP02adj2',2);
end

save('C:\HOME\MATLAB\Data\Ancillary Data\TP39_adj2.dat','TP39_adj2','-ASCII');
save('C:\HOME\MATLAB\Data\Ancillary Data\TP02_adj2.dat','TP02_adj2','-ASCII');
% save('C:\HOME\MATLAB\Data\Ancillary Data\TP39_adj2n.dat','TP39_adj2');
% save('C:\HOME\MATLAB\Data\Ancillary Data\TP02_adj2n.dat','TP02_adj2');


%% Package the data:
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

