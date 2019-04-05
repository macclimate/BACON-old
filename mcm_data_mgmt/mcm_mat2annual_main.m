function [] = mcm_mat2annual_main(year, site, data_type)

switch data_type
    case 'chamber'
        mcm_chamber_mat2annual(year, [site '_chamber']);
    case 'met'
        disp('this function not used for Met data');
    case 'CPEC'
        mcm_CPEC_mat2annual(year, site);
    case 'OPEC'
        disp('this function not used for OPEC data');
    case 'sapflow'
        disp('this function not used for sapflow data');
    case 'trenched'
        disp('this function not used for trenched data');    
end

