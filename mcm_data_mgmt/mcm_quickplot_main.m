function [] = mcm_quickplot_main(year, site, data_type)
if isempty(year)==1
    commandwindow;
    year = input('Only one year at a time permitted.  Enter Year: > ');
end
switch data_type
    case 'chamber'
        mcm_quickplot_chamber(year, [site '_chamber']);
    case {'met','WX','TP_PPT'}
        mcm_quickplot_met(year, site);
    case 'CPEC'
        mcm_quickplot_cpec(year, site);
    case 'OPEC'
        disp('this function not ready for OPEC data');
    case {'sapflow','trenched','OTT','NRL','PPT'}
        mcm_quickplot_met(year, [site '_' data_type]);
%         
%     case 'sapflow'
%         mcm_quickplot_met(year, [site '_sapflow']);
%     case 'trenched'
%         mcm_quickplot_met(year, [site '_trenched']);
%     case 'OTT'
%         mcm_quickplot_met(year, [site '_OTT']);
%     case 'PPT'
%         mcm_quickplot_met(year, site);
end