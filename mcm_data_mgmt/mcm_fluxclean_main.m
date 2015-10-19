function [] = mcm_fluxclean_main(year, site, data_type)

switch data_type
    case 'chamber'
       site = [site '_chamber'];
       mcm_ACSclean(year, site, 0);
    case 'CPEC'
        mcm_fluxclean(year,site);
    case 'OPEC'
        disp('Running OPEC_10min_cleaner.........');
        OPEC_10min_cleaner(site);
        disp('Running OPEC_EdiRe_cleaner.........');
        OPEC_EdiRe_cleaner(site);
end
    
