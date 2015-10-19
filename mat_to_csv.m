load('/1/fielddata/Matlab/Data/Master_Files/TPD/TPD_data_master.mat');

master.data = master.data(master.data(:,1)>=2012 & master.data(:,1)<=2014,:);

csvwrite('/1/fielddata/Matlab/Data/Distributed/MK/TPD_2012_2014.csv',master.data);