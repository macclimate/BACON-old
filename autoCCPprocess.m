%%% first compile:
site_all = {'TP39';'TP74';'TP89';'TP02';'TPD';'TP_PPT'};
site_CPEC = {'TP39', 2002:2015;'TP74', 2008:2015;'TP02', 2008:2015;'TPD', 2012:2015};
site_CCP_output = {'TP39', 2002:2015;'TP74', 2008:2015;'TP02', 2008:2015;'TPD', 2012:2015;'TP_PPT', 2007:2015};

% site_short = {'TP39', 2003:2013;'TP74', 2003:2013;'TP02', 2003:2013;'TPD', 2012:2013};
site_short = {'TP39', 2002:2015, 'all';'TP74', 2002:2015, 'all';'TP02', 2002:2015, 'all'; ...
                'TPD', 2012:2015, 'all';'TP89',2002:2008, 'all';'TP_PPT', 2007:2015, 'all'; ...
                'TP39',2007:2015, 'sapflow'; 'MCM_WX', 2007:2015, 'all'};

            
            
%%% Full compile, no prompts, all sites:            
for i = 1:1:length(site_short);
mcm_data_compiler(site_short{i,2}, site_short{i,1}, site_short{i,3},-2)
end

% %%% FROM SCRATCH Full compile, no prompts, all sites:            
% for i = 1:1:length(site_short);
% mcm_data_compiler(site_short{i,2}, site_short{i,1}, site_short{i,3},-9)
% end

%%% Full compile, no prompts, CPEC sites:            
for i = 1:1:length(site_CPEC);
mcm_data_compiler(site_CPEC{i,2}, site_CPEC{i,1}, 'all',-2)
end

%%% CCP Output
for i = 1:1:length(site_CCP_output);
mcm_CCP_output(site_CCP_output{i,2}, site_CCP_output{i,1},[],[])
end


%%%
mcm_CCP_output(2015, 'TP39',[],[]);
mcm_CCP_output(2015, 'TPD',[],[]);



%%%

%%% CCP Output
for i = 1:1:length(site_CCP_output);
mcm_CCP_output(site_CCP_output{i,2}, site_CCP_output{i,1},[],[])
end


%%% LE Gap-filling:
for i = 4:1:length(site_short);
mcm_Gapfill_LE_H_default(site_short{i,1},site_short{i,2},0);
end

for i = 1:1:length(site_CPEC);
mcm_Gapfill_LE_H_default(site_CPEC{i,1},site_CPEC{i,2},0);
end

for i = 1:1:length(site_CPEC);
mcm_Gapfill_NEE_default(site_CPEC{i,1},[],0);
end

% mcm_CCP_output(2002:2013,'TP39',[],[]);
% mcm_CCP_output(2002:2013,'TP74',[],[]);
% mcm_CCP_output(2002:2013,'TP02',[],[]);
% mcm_CCP_output(2002:2008,'TP89',[],[]);
mcm_CCP_output(2012:2013,'TPD',[],[]);
mcm_CCP_output(2008:2013,'TP_PPT',[],[]);

mcm_CPEC_storage(2015,'TP39')
mcm_CPEC_storage(2015,'TP74')
mcm_CPEC_storage(2015,'TPD')


for i = 1:1:length(site_CPEC)
run_mcm_footprint(site_CPEC{i},[],0);
end