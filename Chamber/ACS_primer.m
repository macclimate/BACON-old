
The main check list:
- copy HF data from DVD to D:\Paul_data....
- move ..\hhour\*.mat files into ...\hhour\old    
- recalculate data using acs_calc_and_save (this may not be needed if the new setup at CR site is OK)
- update the data base by running db_new_eddy
- plot the data
    fluxes, soil temp, co2, h2o, Tirga, Pirga, rmse
- run cleaning
- plot the cleaned data





%=========================================================================
% to process the CR site data for November 2007 follow this procedure:
cd D:\Paul_Data\CR_Chambers\ACS_DC
acs_calc_and_save(datenum(2007,11,1):datenum(2007,11,30),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,0);

%% Create/Update database CR-ACS-DC

[k,StatsAll,dbFileNames, dbFieldNames] = db_new_eddy('d:\paul_data\cr_chambers\acs_dc\met-data\hhour',...
    '08*.ACS_Flux_CR16.mat','d:\paul_data\cr_chambers\acs_dc\met-data\database\2008\cr_acs\chambers\',[],'DataHF');


%% Cleaning on this computer... Don't forget to create a folder "Clean" when
%% starting a new year

fr_automated_cleaning(2008,'CR_ACS',[1],'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA\database\');


%%%% look at raw data for a day(before cleaning)
load D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA\hhour\080410.ACS_Flux_CR16.mat
xx=[];for k=1:8;for i=1:48;xx(i,k)=HHour(i).Chamber(k).Sample(1).efflux;end;end;plot(xx)

%%%% Lokk at High Frequency half-hourly files
load D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA\hhour\080410.ACS_Flux_CR16.mat; HHour


% to plot HF data
acs_plot_HF('D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA','D:\Zoran\acs_init_all.txt')

% how to extract something from HHour
k=1;ef(:,k) = get_stats_field(HHour,sprintf('Chamber(%d).Sample.efflux',k));

% to recalucate one day (no plotting)
acs_calc_and_save(datenum(2007,9,1),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,0);

% to recalucate many day (no plotting) (Sep 1 - Sep 10)
acs_calc_and_save(datenum(2007,9,1):datenum(2007,9,10),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,0);

% to recalucate one day (with plotting)
acs_calc_and_save(datenum(2007,9,1),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,1);

%% Read all chamber effluxes
eff=[];for k=1:8;eff(:,k) = read_bor(sprintf('D:\\Paul_Data\\CR_Chambers\\ACS_DC\\MET-DATA\\database\\2007\\cr\\chambers\\chamber_%d.Sample.efflux',k));end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ???????

x=[];for i=1:10;dataIn = fr_read_digital2_file(sprintf('D:\\Paul_Data\\CR_Chambers\\ACS_DC\\MET-DATA\\data...
    \\07090%d\\07090%d66.DC16',i,i));x(i)=size(dataIn,1);end;x
    
%% load all mat files (if you want to plot the raw data without updating
%% the data base
dirInfo = dir('d:\paul_data\cr_chambers\acs_dc\met-data\hhour\*.ACS_Flux_CR16.mat');
HHourAll = [];
for i=1:length(dirInfo)
    if dirInfo(i).isdir == 0
        load(fullfile('d:\paul_data\cr_chambers\acs_dc\met-data\hhour',dirInfo(i).name))
        HHourAll = [HHourAll  HHour];
        disp(sprintf('%d. %s',i,dirInfo(i).name))
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ???????
    x=[];for i=1:length(HHourAll);x(i) = length(HHourAll(i).DataHF.co2);end
    HHourAll(1)
     x=[];for i=1:length(HHourAll);if ~isempty(HHourAll(i).DataHF);x(i) = length(HHourAll(i).DataHF.co2);end;end