sf2009 = load('/1/fielddata/Matlab/Data/Met/Organized2/TP39_sapflow/HH_Files/TP39_sapflow_HH_2009.mat');

sap1 = sf2009.master.data(:,7);
plot(sap1,'r'); hold on;

% manuall remove a bad value
sap1([13838:13839 13844],1) = NaN;
plot(sap1,'b');