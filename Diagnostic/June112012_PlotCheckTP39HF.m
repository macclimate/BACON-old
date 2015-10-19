clear all; close all;
cd /1/fielddata/Matlab/ubc_PC_setup/Site_Specific/TP39;
c = MCM1_init_all(datestr([2012,06,11,18,30,00]));
dateIn = datenum([2012,06,11,18,30,00]);
% LI7000 is DMCM4
% CSAT is DMCM5
irga_path = '/1/fielddata/SiteData/TP39/MET-DATA/data/120525/';
irga_file = [irga_path '12052516.DMCM4'];
csat_file = [irga_path '12052516.DMCM5'];
% IRGA = fr_read_Digital2(dateIn, c,1);

[Irga_EngUnits,Irga_Header] = fr_read_Digital2_file(irga_file);
[CSAT_EngUnits,CSAT_Header] = fr_read_Digital2_file(csat_file);

plot(Irga_EngUnits(:,1)-nanmean(Irga_EngUnits(:,1)));
hold on;
plot(CSAT_EngUnits(:,3)-nanmean(CSAT_EngUnits(:,3)),'r');

