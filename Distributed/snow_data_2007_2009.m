ls = addpath_loadstart;


data_2002 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2002.mat']);
data_2003 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2003.mat']);
data_2004 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2004.mat']);
data_2005 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2005.mat']);
data_2006 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2006.mat']);
data_2007 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2007.mat']);
data_2008 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2008.mat']);
data_2009 = load([ls 'Matlab/Data/Met/Final_Cleaned/TP39/TP39_met_cleaned_2009.mat']);

snow_col = mcm_find_right_col(data_2007.master.labels,'SnowDepth');

figure(1);clf;
plot(data_2002.master.data(:,snow_col),'Color',[0.7 0.7 0.7]);hold on;
plot(data_2003.master.data(:,snow_col),'y');
plot(data_2004.master.data(:,snow_col),'m');
plot(data_2005.master.data(:,snow_col),'c');
plot(data_2006.master.data(:,snow_col),'b');
plot(data_2007.master.data(:,snow_col),'r');hold on;
plot(data_2008.master.data(:,snow_col),'k');
plot(data_2009.master.data(:,snow_col),'g');

[TV_2007 Year_2007 dt_2007 Mon_2007 Day_2007 HH_2007 MM_2007 ] = mcm_makedates(2007, 30);
[TV_2008 Year_2008 dt_2008 Mon_2008 Day_2008 HH_2008 MM_2008 ] = mcm_makedates(2008, 30);
[TV_2009 Year_2009 dt_2009 Mon_2009 Day_2009 HH_2009 MM_2009 ] = mcm_makedates(2009, 30);

snow_07 = [TV_2007 Year_2007 dt_2007 Mon_2007 Day_2007 HH_2007 MM_2007 data_2007.master.data(:,snow_col)];
snow_08 = [TV_2008 Year_2008 dt_2008 Mon_2008 Day_2008 HH_2008 MM_2008 data_2008.master.data(:,snow_col)];
snow_09 = [TV_2009 Year_2009 dt_2009 Mon_2009 Day_2009 HH_2009 MM_2009 data_2009.master.data(:,snow_col)];

save([ls 'Matlab/Data/Distributed/snow_2007.dat'],'snow_07','-ASCII');
save([ls 'Matlab/Data/Distributed/snow_2008.dat'],'snow_08','-ASCII');
save([ls 'Matlab/Data/Distributed/snow_2009.dat'],'snow_09','-ASCII');


