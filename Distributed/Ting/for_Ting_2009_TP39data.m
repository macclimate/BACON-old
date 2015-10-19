ls = addpath_loadstart;
load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_2009.mat');

data_out = master.data(:,[1:5 97 42 98 45 100 112]);

% Condense to hourly:
data_out_1h = NaN.*ones(length(data_out)/2,size(data_out,2));
ctr = 1;
for i = 2:2:length(data_out)
    data_out_1h(ctr,:) = mean(data_out(i-1:i,:),1);
    ctr = ctr+1;
end

%%% Convert PPT from average of 2 half-hour totals, to an hourly total:
data_out_1h(:,11) = data_out_1h(:,11).*2;

sum(data_out_1h(:,11));

dlmwrite('/1/fielddata/Matlab/Data/Distributed/Ting/TP39_2009_halfhourly.dat',data_out,',');
dlmwrite('/1/fielddata/Matlab/Data/Distributed/Ting/TP39_2009_hourly.dat',data_out_1h,',');