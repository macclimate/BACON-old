function [data sum header] = Load_NACP_data(dir_in, year)
% ls = addpath_loadstart;
% path = [ls 'Matlab/Data/NACP/'];
% dir_in = '/1/fielddata/Matlab/Data/NACP/';
% year = 2003:2007;

year_start = min(year);
year_end = max(year);


FC3 = NaN.*ones(yr_length(year),10);
FC4 = NaN.*ones(yr_length(year),10);
MDS = NaN.*ones(yr_length(year),10);

YYYY = [];
ctr = 1;
%%%%%%%%% Settings for jjb_rip_header:
options.Delimiter = ' ';
options.MultipleDelimsAsOne = 1;
options.nanvalues = -9999;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = year_start:1:year_end
    YYYY = [YYYY; i.*ones(yr_length(i),1)]; 
    [hdr_FC3 tmp] = jjb_rip_header([dir_in 'nacpFilledNEE_FC3_CATP4-' num2str(i) '.dat'],2,options);
    
    FC3(YYYY==i,1:size(tmp,2)) = tmp(1:end,1:end);
    clear tmp;
    [hdr_FC4 tmp] = jjb_rip_header([dir_in 'nacpFilledNEE_FC4_CATP4-' num2str(i) '.dat'],2,options);
    FC4(YYYY==i,1:size(tmp,2)) = tmp(1:end,1:end);
    clear tmp;
    [hdr_MDS tmp] = jjb_rip_header([dir_in 'nacpFilledNEE_MDS_CATP4-' num2str(i) '.dat'],2,options);
    MDS(YYYY==i,1:size(tmp,2)) = tmp(1:end,1:end);
    clear tmp;

%     
% tmp = load([path 'nacpFilledNEE_FC4_CATP4-' num2str(i) '.dat']);
%     FC3(YYYY==year,2:size(tmp,2)) = tmp(1:end,2:end);
%     clear tmp;
% 
% tmp = load([path 'nacpFilledNEE_MDS_CATP4-' num2str(i) '.dat']);
%     MDS(1:length(tmp),ctr) = tmp(:,5);

FC3_sum(ctr,1:5) = [i nansum(FC3(FC3(:,1)==i,5:8)).*0.0216];
FC4_sum(ctr,1:5) = [i nansum(FC4(FC4(:,1)==i,5:8)).*0.0216];
MDS_sum(ctr,1:5) = [i nansum(MDS(MDS(:,1)==i,5:8)).*0.0216];

ctr = ctr+1;
end

data.FC3 = FC3;
data.FC4 = FC4;
data.MDS = MDS;

sum.FC3 = FC3_sum;
sum.FC4 = FC4_sum;
sum.MDS = MDS_sum;
sum.header = hdr_FC3(1, [1 5:8]);

header.FC3 = hdr_FC3;
header.FC4 = hdr_FC4;
header.MDS = hdr_MDS;


% end
