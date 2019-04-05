% sapfluxnet_prep_2017.m
% What we need: 
% Jt in cm3 s-1 

%%% environmental_hd
% Ta | RH | VPD | SW_in | PPFD_in | Rn | WS | precip | VWC_30 | VWC_100
% 

cd('\\130.113.210.243\fielddata\Matlab\Data\Master_Files\');
%% TP39

% load environmental data 
env = load('TP39\TP39_data_master.mat');

% load sapflow data:
sf = load('TP39_sapflow\TP39_sapflow_data_master.mat');

ind_env = find(env.master.data(:,1)>=2009 & env.master.data(:,1)<=2016);
ind_sf = find(sf.master.data(:,1)>=2009 & sf.master.data(:,1)<=2016);

% Prepare environmental data
Ta = env.master.data(ind_env,106);
RH = env.master.data(ind_env,107);
vpd = VPD_calc(Ta,RH);

% Ta | RH | VPD | SW_in | PPFD_in | Rn | WS | precip | VWC_30 | VWC_100
env_data_out = [Ta RH vpd env.master.data(ind_env,[112 108 111 109 123 119 76])];
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP39_env.xlsx',env_data_out);

% Prepare Timestamp
YYYY = num2str(env.master.data(ind_env,1));
MM = num2str(env.master.data(ind_env,2));
DD = num2str(env.master.data(ind_env,3));
HH = num2str(env.master.data(ind_env,4));
mm = num2str(env.master.data(ind_env,5));
ss = num2str(zeros(length(mm),1));


timestr = {};
for i = 1:1:length(ss)
    if strcmp(MM(i,1),' ')==1; MM(i,1:2) = ['0' MM(i,2)]; end
    if strcmp(DD(i,1),' ')==1; DD(i,1:2) = ['0' DD(i,2)]; end
    if strcmp(HH(i,1),' ')==1; HH(i,1:2) = ['0' HH(i,2)]; end
    if strcmp(mm(i,1),' ')==1; mm(i,1:2) = ['0' mm(i,2)]; end

timestr{i,1} = [YYYY(i,:) '/' MM(i,:) '/' DD(i,:) ' ' HH(i,:) ':' mm(i,:) ':00'];
end
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP39_timestamps.xlsx',timestr);

%%% Prepare sapflow data:
sf_data_out = sf.master.data(ind_sf,25:49).*1e6; %convert to cm3/m2/sec
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP39_sf.xlsx',sf_data_out);

%% TP74

% load environmental data 
env = load('TP74\TP74_data_master.mat');

% load sapflow data:
sf = load('TP74_sapflow\TP74_sapflow_data_master.mat');

ind_env = find(env.master.data(:,1)>=2009 & env.master.data(:,1)<=2016);
ind_sf = find(sf.master.data(:,1)>=2009 & sf.master.data(:,1)<=2016);

% Prepare environmental data
Ta = env.master.data(ind_env,82);
RH = env.master.data(ind_env,83);
vpd = VPD_calc(Ta,RH);

% Ta | RH | VPD | SW_in | PPFD_in | Rn | WS | precip | VWC_30 | VWC_100
env_data_out = [Ta RH vpd env.master.data(ind_env,[88 84 87 85 99 95 68])];
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP74_env.xlsx',env_data_out);

% Prepare Timestamp
YYYY = num2str(env.master.data(ind_env,1));
MM = num2str(env.master.data(ind_env,2));
DD = num2str(env.master.data(ind_env,3));
HH = num2str(env.master.data(ind_env,4));
mm = num2str(env.master.data(ind_env,5));
ss = num2str(zeros(length(mm),1));


timestr = {};
for i = 1:1:length(ss)
    if strcmp(MM(i,1),' ')==1; MM(i,1:2) = ['0' MM(i,2)]; end
    if strcmp(DD(i,1),' ')==1; DD(i,1:2) = ['0' DD(i,2)]; end
    if strcmp(HH(i,1),' ')==1; HH(i,1:2) = ['0' HH(i,2)]; end
    if strcmp(mm(i,1),' ')==1; mm(i,1:2) = ['0' mm(i,2)]; end

timestr{i,1} = [YYYY(i,:) '/' MM(i,:) '/' DD(i,:) ' ' HH(i,:) ':' mm(i,:) ':00'];
end
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP74_timestamps.xlsx',timestr);

%%% Prepare sapflow data:
sf_data_out = sf.master.data(ind_sf,7:23).*1e6;
xlswrite('\\130.113.210.243\fielddata\SiteData\Sapfluxnet\TP74_sf.xlsx',sf_data_out);
