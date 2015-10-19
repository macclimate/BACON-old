test = load('/1/fielddata/SiteData/TP39_chamber/MET-DATA/hhour/100720.ACS_Flux_16.mat');

LE = [];

for hhour = 1:1:48
    
   for ch = 1:1:8 
    tmp_LE(1,ch) = test.HHour(1,hhour).Chamber(1,ch).Sample(1,1).LE;
   end
   LE = [LE; tmp_LE];
   clear tmp_LE;
    
    
end