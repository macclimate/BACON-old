function [] = mcm_quickplot_chamber(year, site)

loadstart = addpath_loadstart;
    maxNch = 8 % change this to allow more chambers..
if ischar(year)
else
    year = num2str(year);
end
%% Paths
load_path = [loadstart 'SiteData/' site '/MET-DATA/annual/'];
%%% Get names of variables
% vars = mcm_get_varnames(site);
vars = mcm_get_fluxsystem_info(site, 'varnames');
%%% Make x-ticks:
[junk1 junk2 junk3 junk4] = jjb_makedate(str2double(year),30);
% [Mon Day] = make_Mon_Day(str2double(year), 1440);
% YY = year(3:4);
% 
% for i = 1:1:length(Mon)
%     datastr(i,:) = [YY create_label(Mon(i,1),2) create_label(Day(i,1),2) ];
% end
[datastr] = mcm_make_datastr(year, 1440);
ctr = 1;
for k = 1:48:length(junk1);
    x_tick(ctr,1) = k;
    x_tick_label(ctr,:) = datastr(ctr,:);
    ctr = ctr+1;
end

plot_x = (1:1:length(junk1))';
for j = 1:1:length(vars)
    %%% Load variable:
    tmp_var = load([load_path site '_' year '.' vars(j).name '_all']);
%     tmp_var_backup = load([])
    figure('Name',vars(j).name); clf;
    plot(plot_x,tmp_var);
set(gca,'XTick',x_tick);
set(gca,'XTickLabel',x_tick_label);
    
    clear tmp_var;
end