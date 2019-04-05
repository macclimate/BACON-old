% load('/1/fielddata/Matlab/Data/Flux/Gapfilling/TPD/NEE_GEP_RE/Default/TPD_Gapfill_NEE_default.mat')
load('\\130.113.210.243\fielddata\Matlab\Data\Flux\Gapfilling\TPD\NEE_GEP_RE\Default\TPD_Gapfill_NEE_default.mat')

%%% If we wanted to extract Ustar_th for the 'SiteSpec_region' estimation, then we'd want the third branch in the master data
%%% structure. This can be gleaned by opening the master variable.
right_branch = 3; %change this to select the correct estimation

master(right_branch).tag

[years,ia] = unique(master(right_branch).Year,'rows')

Ustar_th = [years master(right_branch).Ustar_th(ia)];


