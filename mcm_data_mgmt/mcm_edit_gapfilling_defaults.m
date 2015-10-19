function [] = mcm_edit_gapfilling_defaults(type)
ls = addpath_loadstart;

menu_flag = 0;
if nargin == 0
    menu_flag = 1;
else
    if isempty(type)==1
        menu_flag = 1;
    end
end

if menu_flag == 1
    opts = {'LE & H','NEE'};
    seltn = menu('Select Gapfilling File to Edit',opts);
    type = opts{seltn};
end

config_path = [ls 'Matlab/Config/Flux/Gapfilling/Defaults/'];

switch type
    case {'LE','H','LE & H'} 
unix(['gnumeric ' config_path 'LE_H_Gapfilling_Defaults.csv']);
        
    case 'NEE'
unix(['gnumeric ' config_path 'NEE_Gapfilling_Defaults.csv']);
        
end