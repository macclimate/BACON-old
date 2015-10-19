ls = addpath_loadstart;
clear all;
site = 'TP39';

switch site
    case 'TP39'
        tag = '.hMCM1.mat';
    case 'TP74'
        tag = '.hMCM2.mat';
    case 'TP02'
        tag = '.hMCM3.mat';
end

path = ['/1/fielddata/SiteData/' site '/MET-DATA/hhour/'];

ctr = 1;
for mon = 1:1:12
    mon_str = num2str(mon);
    if length(mon_str) == 1; mon_str = ['0' mon_str];end
    for day = 1:1:31
    day_str = num2str(day);
        
     if length(day_str) == 1; day_str = ['0' day_str];end
try
   load([path '08' mon_str day_str tag]);     
for hh = 1:1:48
    try
   delays_impl(ctr,1:2) = Stats(1,hh).MainEddy.Delays.Implemented(1,1:2);
    catch
   delays_impl(ctr,1:2) = NaN;
    end
    
    try
   delays_calc(ctr,1:2) = Stats(1,hh).MainEddy.Delays.Calculated(1,1:2);
    catch
   delays_calc(ctr,1:2) = NaN;
    end    
    ctr = ctr+1;
end
catch
    delays_impl(ctr:ctr+47,1:2) = NaN;
    delays_calc(ctr:ctr+47,1:2) = NaN;
    ctr = ctr+48;
end   
   
    end
end


del1 = delays_calc(delays_calc(:,1)>0,1);
del2 = delays_calc(delays_calc(:,2)>0,2);
figure(1);clf;
hist(del1,100)
figure(2);clf;
hist(del2,100)