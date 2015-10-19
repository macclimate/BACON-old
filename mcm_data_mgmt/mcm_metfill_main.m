function [] = mcm_metfill_main(year, site)

switch site
    
    case 'TP_PPT'
        mcm_PPTfill(year);
    otherwise
        mcm_metfill(year);
end