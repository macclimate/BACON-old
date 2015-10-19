load('/1/fielddata/Matlab/Data/Met/Final_Cleaned/MCM_WX/MCM_WX_met_cleaned_2011.mat');
master.labels = cellstr(master.labels);
% get suntimes?
            [sunup_down] = annual_suntimes('TP39', 2011, 0,15);
            ind_sundown = find(sunup_down< 1);
figure(2);clf;
plot(master.data(:,1)) % Col 1 is down SW
hold on;
plot(ind_sundown,master.data(ind_sundown,1),'r.');


wxorg = load('/1/fielddata/Matlab/Data/Met/Organized2/MCM_WX/HH_Files/MCM_WX_HH_2011.mat');



ts_test = timestamp(35083:35300,:);
ts_datenum = datenum(str2num(ts_test(:,1:4)), str2num(ts_test(:,6:7)), ...
        str2num(ts_test(:,9:10)), str2num(ts_test(:,12:13)), str2num(ts_test(:,15:16)), 00);
ts_datenum2 = JJB_DL2Datenum(str2num(ts_test(:,1:4)), str2num(ts_test(:,6:7)), ...
        str2num(ts_test(:,9:10)), str2num(ts_test(:,12:13)), str2num(ts_test(:,15:16)), 00);
        
ts_datestr = datestr(ts_datenum);
ts_datestr2 = datestr(ts_datenum2);
%%%%%%%%%%%%%%%%%%%%%%%%%%
tv_test = make_tv(2011,15);
tv_datestr = datestr(tv_test);

%%%%%%%%%%%%%5
row_common(1)
datestr(row_common(1))
row_in(1,:)
input_date(row_in(1))
timestamp(row_in(1),:)
datestr(TV(row_master(1)))
