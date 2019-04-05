function [] = mcm_quickplot_cpec(year, site)

loadstart = addpath_loadstart;
dstr = datestr(now, 30);
fig_path = [loadstart 'Matlab/Figs/Quickplot/' site '/CPEC/' site '_CPEC_figs_' dstr(1:8) '/'];
jjb_check_dirs([loadstart 'Matlab/Figs/Quickplot/' site '/CPEC/']);
unix(['mkdir ' fig_path]);

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


for j = 1:1:length(vars)
    %%% Load variable:
    tmp_var = load([load_path site '_' year '.' vars(j).name]);
    %     tmp_var_backup = load([])
    f1(j) = figure('Name',vars(j).name); clf;
    plot(tmp_var,'b.-');
    xlabel('hhour of year');
    title(vars(j).name);
    try
        ylabel(vars(j).ylabel);
    catch
        ylabel('??');
    end
    print(f1(j),'-dpng',[fig_path site '_' year '_' vars(j).name]);
    saveas(f1(j),[fig_path site '_' year '_' vars(j).name '.fig']);
    set(gca,'XTick',x_tick);
    set(gca,'XTickLabel',x_tick_label);
    clear tmp_var;
end

