%%% This function calculates the footprint & ustar data coverage
%%% Variables
% site = 'TP02';
site = 'TPD';
load_path = '\\130.113.210.243\fielddata\Matlab\Data\';
begin_year = 2012;
end_year = 2016;

%% Extract the ustar thresholds for the site by year:
gf = load([load_path 'Flux\Gapfilling\' site '\NEE_GEP_RE\Default\' site '_Gapfill_NEE_default.mat']); %% Load gapfilling model outputs
right_branch = 3; % 3 = SiteSpec_region approach
% gf.master(right_branch).tag
[years,ia] = unique(gf.master(right_branch).Year,'rows');
Ustar_th = [years gf.master(right_branch).Ustar_th(ia)]; % table of [year | Ustar_th]

%% Load Master File:

load([load_path 'Master_Files/' site '/' site '_data_master.mat']);
gf_input = load([load_path 'Master_Files/' site '/' site '_gapfill_data_in.mat']);
[gf_input.data] = trim_data_files(gf_input.data,begin_year,end_year, 1);

NEE_filled_col = find(strcmp('GapFilledPIPref_NEE',master.labels(:,1))==1);
NEE_meas_col = find(strncmp('NetEcosystemExchange_AbvCnpy',master.labels(:,1),length('NetEcosystemExchange_AbvCnpy'))==1);

ctr = 1;
for i = begin_year:1:end_year
    ind = find(gf_input.data.Year==i);
    ind2 = find(master.data(:,1)==i);
    prop_meas(ctr,1) = sum(~isnan(gf_input.data.NEE(ind,1)))./length(ind);
    prop_fp_pass(ctr,1) = sum(~isnan( gf_input.data.NEE(ind,1).*gf_input.data.Kljun_Regional_90flag(ind,1) )) ./length(ind);
%     ind3 = find(master.data(ind2,111) == gf_input.data.NEE(ind,1));
    prop_ustar_pass(ctr,1) = length(find(master.data(ind2,NEE_filled_col) == gf_input.data.NEE(ind,1))) ./length(ind);
%     mcm_GEP_RE_flag
    table_out(ctr,:) = [i prop_meas(ctr,1) prop_fp_pass(ctr,1) prop_ustar_pass(ctr,1)];
    ctr = ctr + 1;
end

%%% 
variable_names = {'year' 'pMeasured' 'pFPpassing' 'pUstarThpassing'};
T = array2table(table_out,'VariableNames',variable_names)


ind2 = find(master.data(:,1)>=begin_year & master.data(:,1)<=end_year);
plot(master.data(ind2,NEE_filled_col),'b');hold on;
plot(gf_input.data.NEE,'r'); hold on;

figure(2);clf;
plot(master.data(ind2,NEE_meas_col),'b');hold on;
plot(gf_input.data.NEE,'r'); hold on;
