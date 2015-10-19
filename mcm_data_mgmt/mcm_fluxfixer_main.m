function [] = mcm_fluxfixer_main(year, site, data_type)

switch data_type
    case 'chamber'
       site = [site '_chamber'];
    if strcmp(site,'edit') == 1;
            eval('edit mcm_ACSfixer');
        else
            mcm_ACSfixer(year,site);
    end
        
    case 'CPEC'
        if strcmp(site,'edit') == 1;
            eval('edit mcm_fluxfixer');
        else
            mcm_fluxfixer(year,site);
        end
        
    case 'OPEC'
        if strcmp(site,'edit') == 1;
            eval('edit OPEC_10min_fixer.m');
            eval('edit OPEC_EdiRe_fixer.m');
        else
        disp('Running OPEC_10min_fixer.........');
        OPEC_10min_fixer(site,0);
        disp('Hit any key to continue to EdiRe_fixer: >');
        pause;
        disp('Running OPEC_EdiRe_fixer.........');
        OPEC_EdiRe_fixer(site,0);
        disp('Hit any key to continue to run OPEC_compiler: >');
        pause
        OPEC_compiler(site)
        disp('Done...........');
        end
        
end