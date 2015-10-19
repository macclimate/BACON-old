% load('/home/brodeujj/Matlab/Data/KM_footprint_test/KM_TP39_2010_results.mat');
clear all;
close all;
ls = addpath_loadstart;
clrs = jjb_get_plot_colors;

yr_list = 2006:1:2011;%(2006:1:2011)';
% yr_list = [2006 2008:1:2011];%(2006:1:2011)';
fig_dir = [ls 'Matlab/Figs/Paper_Figs/'];
jjb_check_dirs(fig_dir);

Year = [];
Xind = [];
Xdist = [];
inbounds_flux_2D = [];
max_fetch = [];
max_contour_inbounds = [];
CWI = [];
CWI_orig = [];
Year_orig = [];
Xind_orig = [];
Xdist_orig = [];
inbounds_p_orig = [];
max_fetch_orig = [];
max_contour_inbounds_orig = [];
sig_v = []; ust = []; wd = [];

for i = 1:1:length(yr_list)
load([ls 'Matlab/Data/Footprint/KM_TP39_' num2str(yr_list(i)) '_2D_results.mat']);
Year = [Year; yr_list(i).*ones(size(out.Xind,1),1)];
Xind = [Xind; out.Xind];
Xdist = [Xdist; out.Xdist];
inbounds_flux_2D = [inbounds_flux_2D; out.inbounds_flux_2D];
max_fetch = [max_fetch; out.max_fetch];
max_contour_inbounds = [max_contour_inbounds; out.max_contour];
CWI = [CWI; out.CWI];
TP39_CPEC = load([ls 'Matlab/Data/TP39_CPEC_cleaned/TP39_CPEC_cleaned_' num2str(yr_list(i)) '.mat']);
sig_v = [sig_v; TP39_CPEC.master.data(:,24)];
TP39_master = load([ls 'Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(yr_list(i)) '.mat']);
ust = [ust; TP39_master.master.data(:,11)];
wd = [wd; TP39_master.master.data(:,67)];
% load([ls 'Matlab/Data/KM_footprint_test/KM_TP39_' num2str(yr_list(i)) '_results_orig.mat']);
% Year_orig = [Year_orig; yr_list(i).*ones(size(out.Xind,1),1)];
% Xind_orig = [Xind_orig; out.Xind];
% Xdist_orig = [Xdist_orig; out.Xdist];
% inbounds_p_orig = [inbounds_p_orig; out.inbounds_flux_2D];
% max_fetch_orig = [max_fetch_orig; out.max_fetch];
% max_contour_inbounds_orig = [max_contour_inbounds_orig; out.pct_in_fetch];
end
clear TP39_CPEC TP39_master
%%%%%%%
% Load the traditional footprint flag file:
load([ls 'Matlab/Data/Footprint/TP39_jjb_footprint_flag.mat']);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% histogram of the total % of flux originating from within the bounds, per
%%% half-hour
% f1 = figure('Position',[1 1 512 384]);clf;
% hist(inbounds_flux_2D);
% 
% %%% Histogram of the maximum contour contained within the flux for a given
% %%% half-hour
% f2 = figure('Position',[1 1 512 384]);clf;
% hist(CWI);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% try close(f1a);catch;end; f1a = figure('Units','pixels','Position',[300 800 400 400],...
%     'Color','w','PaperPositionMode','Auto','Name','CWI vs 2D');clf;
try close(f1a);catch;end; f1a = figure('Units','centimeters','Position',[10 23 12 12],...
    'Color','w','PaperPositionMode','Auto','Name','CWI vs 2D');clf;

    ind = find(~isnan(inbounds_flux_2D.*CWI));
h1a(1,1) = plot(inbounds_flux_2D(ind,1),CWI(ind,1),'o','MarkerFaceColor','none',...
    'MarkerEdgeColor',clrs(6,:),'MarkerSize',2);hold on;
h1a_tmp(1,1) = plot([0 1],[0 1],'--','LineWidth',1,'Color',[0.4 0.4 0.4]);
hXLabel = xlabel('F_{in}  KM01-2D', 'FontName', 'Arial','FontSize',12,'VerticalAlignment','top','FontWeight','bold');
hYLabel = ylabel('F_{in}  KM01-1D', 'FontName', 'Arial','FontSize',12,'VerticalAlignment','bottom','FontWeight','bold');
set( gca,...
    'XTick',(0:0.2:1),'YTick',(0:0.2:1),...
    'FontName', 'Times','FontSize',10,...
  'Box'         , 'on'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.01 .01] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XGrid'       , 'on'      , ...
  'XColor'      , [.1 .1 .1], ...
  'YColor'      , [.1 .1 .1], ...
  'DataAspectRatio',[1 1 1],  ...
  'YTick'       ,0:0.2:1,     ...
  'XTick'       ,0:0.2:1,     ...
  'LineWidth'   , 1         );

% Tighten up the margins:
tightInset = get(gca, 'TightInset');
position(1) = tightInset(1);
position(2) = tightInset(2);
position(3) = 1 - tightInset(1) - tightInset(3);
position(4) = 1 - tightInset(2) - tightInset(4);
set(gca, 'Position', position);


% Export:
% plot2svg([fig_dir 'TP39_1Dvs2D.svg'],f1a);
fname2 = [fig_dir 'Figure1-TP39_1Dvs2D'];

% export_fig(fname2,'-png','-r300');
print(f1a,'-dpng','-r600',fname2);
export_fig([fname2 '-ef.png'],'-png', '-r200');

%{
% 
% 
% 
% 
% plot_ctr = 1;
% for yr_ctr = 1:1:length(yr_list)%2006:1:2011
%     yr = yr_list(yr_ctr);
%     ind = find(~isnan(inbounds_flux_2D.*CWI) & Year == yr);
% % h1a(plot_ctr,1) = plot(inbounds_flux_2D(ind,1),CWI(ind,1),'.','Color',clrs(plot_ctr,:));hold on;
% h1a(plot_ctr,1) = plot(inbounds_flux_2D(ind,1),CWI(ind,1),'o','MarkerFaceColor','none',...
%     'MarkerEdgeColor',clrs(plot_ctr,:),'MarkerSize',3);hold on;
% 
% h1a_tmp(plot_ctr,1) = plot(-1,-1,'o','MarkerFaceColor','none',...
%     'MarkerEdgeColor',clrs(plot_ctr,:),'MarkerSize',6);hold on;
% plot_ctr = plot_ctr+1;
% end
% 
% h1a_tmp(plot_ctr,1) = plot([0 1],[0 1],'k--','LineWidth',2);
% hLegend = legend(h1a_tmp,[cellstr(num2str((yr_list)')); '1:1 Line'],'Location','SouthEast',...
%     'Color','w','EdgeColor',[1 1 1],'Box','off');
% hXLabel = xlabel('F_{in}  KM01-2D');
% hYLabel = ylabel('F_{in}  KM01-1D');
% axis(gca,[0 1 0 1])
% 
% % Adjust font
% set( gca                             , 'FontName'   , 'Helvetica','FontSize',12 );
% set([hXLabel, hYLabel], 'FontName'   , 'AvantGarde');
% set([hLegend, gca]                   , 'FontSize'   , 10           );
% set([hXLabel, hYLabel]        , 'FontSize'   , 12          );
% % set( hTitle                          , 'FontSize'   , 12          ,'FontWeight' , 'bold'      );
% 
% % Final Aesthetics:
% set(gca, ...
%   'Box'         , 'off'     , ...
%   'TickDir'     , 'out'     , ...
%   'TickLength'  , [.01 .01] , ...
%   'XMinorTick'  , 'off'      , ...
%   'YMinorTick'  , 'off'      , ...
%   'YGrid'       , 'on'      , ...
%   'XGrid'       , 'on'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'DataAspectRatio',[1 1 1],  ...
%   'YTick'       ,0:0.2:1,     ...
%   'XTick'       ,0:0.2:1,     ...
%   'LineWidth'   , 1         );

%%% Export the figure:
% fname = [fig_dir 'TP39_1Dvs2D.eps'];
% print('-depsc2',fname);
% fixPSlinestyle(fname,fname);
% plot2svg([fig_dir 'TP39_1Dvs2D.svg'],f1a);
% fname2 = [fig_dir 'TP39_1Dvs2D.png'];
% export_fig(fname2,'-png','-r600');
% export_fig([fig_dir 'pdata_vs_NEE,RE,GEP-all2'], '-png','-r200');

% print(f1a,'-dtiff','-r600',fname2);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fit a line of best fit through this?
ind = find(~isnan(inbounds_flux_2D.*CWI));
p_1a = polyfit(inbounds_flux_2D(ind),CWI(ind),1); % Overall slope is 1.04, int=0.
rsq_1a = rsquared(CWI(ind),polyval(p_1a,inbounds_flux_2D(ind))); % rsq is 0.96
corrcoef(CWI(ind),polyval(p_1a,inbounds_flux_2D(ind)));
% plot((0:0.1:1),polyval(p_1a,(0:0.1:1)),'k-');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%% These figures attempt to explain the spread in the linear relationship
%%% to one of the 3 possible influencing variables: sig_v, ust or wd
% It turns out it's wind direction, so these others have been commented.
%     ind = find(~isnan(inbounds_flux_2D.*CWI));
% f3b = figure('Position',[1 1 512 384],'Name','1d-2d - vs sigv plot');clf;
% h3b = plot3(max_contour_inbounds(ind_abv50b,1)/100,sig_v(ind_abv50b,1), inbounds_flux_2D(ind_abv50b,1),'.','Color',clrs(1,:));hold on;
%     grid on;  
% f3c = figure('Position',[1 1 512 384],'Name','1d-2d - vs ust plot');clf;
% h3c = plot3(max_contour_inbounds(ind_abv50b,1)/100,ust(ind_abv50b,1), inbounds_flux_2D(ind_abv50b,1),'.','Color',clrs(2,:));hold on;
%     grid on;
% try close(f1b);catch;end; f1b = figure('Position',[300 1000 800 500],'Name','CWI vs 2D vs WDir');clf;
% h1b = plot3(CWI(ind,1),wd(ind,1), inbounds_flux_2D(ind,1),'.','Color',clrs(3,:));hold on;
%     grid on;
    
%%
% Since we now understand that wind direction greatly determines the relationship between the 1d and 2d
% estimates of WFFP (within-fetch footprint proportion), we can bin the
% data by small increments of wind direction, extract the slope and
% intercepts of the binned relationships, and use those relationships to
% correct the 1d estimates
wd_incr = 2.5;
wd_bins = [0:wd_incr:360-wd_incr]';
try close(f1b);catch;end; f1b = figure('Units','pixels','Position',[300 100 800 400],'PaperPositionMode','Auto','Name','CWI vs 2D, binned WD');clf;
s_1b = tight_subplot(1,2,[0.1 0.1],[0.15 0.05],[0.1 0.1]);


% clrs_f1b = colormap(lines(360/wd_incr));
clrs_f1b = colormap(jet(360/wd_incr));
% clrs_f1b = colormap(gray(360/wd_incr));
CWI_pred = NaN.*ones(length(CWI),1);
for s = 1:1:2
    subplot(s_1b(s));
    clear ind_wd h1b p_1b;
    for j = 1:1:length(wd_bins)
        ind_wd_inbounds{j,1} = find(wd >=wd_bins(j) & wd < wd_bins(j)+wd_incr & CWI > 0.05 & ~isnan(wd.*inbounds_flux_2D.*CWI));
        ind_wd{j,1} = find(wd >=wd_bins(j) & wd < wd_bins(j)+wd_incr & CWI > 0.05 & ~isnan(wd.*inbounds_flux_2D.*CWI));
        if ~isempty(ind_wd{j,1});
%             h1b(j,1) = plot3(CWI(ind_wd{j,1},1),wd(ind_wd{j,1}),inbounds_flux_2D(ind_wd{j,1},1),'.','Color',clrs_f1b(j,:));hold on;
            h1b(j,1) = plot3(inbounds_flux_2D(ind_wd{j,1},1),wd(ind_wd{j,1}),CWI(ind_wd{j,1},1),'o','MarkerFaceColor',clrs_f1b(j,:),...
                'MarkerSize',3,'MarkerEdgeColor','none');hold on;
            
            p_1b(j,:) = polyfit(CWI(ind_wd{j,1},1),inbounds_flux_2D(ind_wd{j,1},1),1);
            tmp_pred = polyval(p_1b(j,:),CWI(ind_wd{j,1},1));
            CWI_pred(ind_wd{j,1},1) = tmp_pred;
            rsq(j,1) = rsquared(CWI(ind_wd{j,1},1),tmp_pred);
%             corrcoef_1b(j,1)
            clear tmp_pred;
        else
            p_1b(j,:) = [NaN NaN];
        end
    end
    grid on;

    %%%%%%%%%%%% FORMATTING
switch s
    case 1; view(33,8)
    case 2; view(111,40)
end
axis([0 1 0 360 0 1])
hXLabel = xlabel('F_{in} - 2D');
hYLabel = ylabel('Wind Dir (deg)');
hZLabel = zlabel('F_{in} - 1D');
    grid on;
% Adjust font
set( gca                             , 'FontName'   , 'Helvetica' );
set([hXLabel, hYLabel], 'FontName'   , 'AvantGarde');
set([hXLabel, hYLabel]        , 'FontSize'   , 10          );
set([hZLabel, hZLabel]        , 'FontSize'   , 10          );

% Final Aesthetics:
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
'ZMinorTick'  , 'off'      , ...
  'YGrid'       , 'on'      , ...
  'XGrid'       , 'on'      , ...
  'ZGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'ZColor'      , [.3 .3 .3], ...  
  'YTick'       ,0:90:360,     ...
  'XTick'       ,0:0.2:1,     ...
  'ZTick'       ,0:0.2:1,     ...
  'LineWidth'   , 1         );
        
        
end

%%% Export the figure:
% fname = [fig_dir 'TP39_1Dvs2D-wdbinned.eps'];
% print(f1b,'-depsc2',fname);
% fixPSlinestyle(fname,fname);
% fname2 = [fig_dir 'TP39_1Dvs2D-wdbinned.png'];
% print(f1b,'-r300','-dpng',fname2);
% export_fig([fig_dir 'TP39_1Dvs2D-wdbinned-ef.png'],'-png');
ind = find(~isnan(inbounds_flux_2D.*CWI));
rsq_1b = rsquared(CWI(ind),CWI_pred(ind)); % rsq is 0.96

 figure();clf;
 plot(rsq); hold on;
 plot(p_1b,'r');
 figure();clf;
 plot(CWI_pred,CWI, 'k.');
    
 ind2 = find(~isnan(inbounds_flux_2D.*CWI) & CWI > 0.1);
 rsq_adj1 = rsquared(CWI(ind2),polyval(p_1a,inbounds_flux_2D(ind2))); % rsq is 0.96
corrcoef_adj1 = corrcoef(inbounds_flux_2D(ind2),CWI(ind2));

 rsq_adj2 = rsquared(CWI(ind2),CWI_pred(ind2));
 corrcoef_adj2 = corrcoef(CWI_pred(ind2),CWI(ind2));

 ind3 = find(~isnan(inbounds_flux_2D.*CWI) & CWI > 0.5);
 rsq_adj1b = rsquared(CWI(ind3),polyval(p_1a,inbounds_flux_2D(ind3))); % rsq is 0.96
corrcoef_adj1b = corrcoef(inbounds_flux_2D(ind3),CWI(ind3));

 rsq_adj3b = rsquared(CWI(ind3),CWI_pred(ind3));
 corrcoef_adj3b = corrcoef(CWI_pred(ind3),CWI(ind3));
%     saveas(f1b,[ ls 'Matlab/Figs/Footprint/TP39_1Dvs2D-wdbinned.png'])

%% Plot using linear relationships only.
% a_1b2 = axes();
    try close(f1b2);catch;end; f1b2 = figure('Units','centimeters','Position',[10 23 16 12],...
    'Color','w','PaperPositionMode','Auto');clf;
   s_1b2 = tight_subplot(1,2,[0.1 0.1],[0.15 0.05],[0.12 0.1]);
for s = 1:1:2
    subplot(s_1b2(s));
    for j = 1:1:length(wd_bins)
        X(:,j) = (0:0.1:1.1);
        Z(:,j) = polyval(p_1b(j,:),(0:0.1:1.1));
        Y(:,j) = repmat(wd_bins(j),12,1);
        C(:,j) = repmat(j,12,1);
%             plot3((0:0.1:1.1),repmat(wd_bins(j),12,1),polyval(p_1b(j,:),(0:0.1:1.1)),'-','Color','k'); hold on;
    end
    
    %Surface plot:
surf(X,Y,Z,C); colormap(gray);shading faceted;

switch s
    case 1; view(51,18)
        hYLabel = ylabel('         Wind Dir (\circ)', 'FontName', 'Arial','FontSize',12,'FontWeight','bold');

    case 2; view(120,24)
end
axis([-0.1 1.2 0 360 -0.1 1.4])
hXLabel = xlabel('F_{in} - 2D', 'FontName', 'Arial','FontSize',12,'FontWeight','bold');
hZLabel = zlabel('F_{in} - 1D', 'FontName', 'Arial','FontSize',12,'FontWeight','bold');
%     grid on;
% Adjust font
set( gca, 'FontName'   , 'Arial' );

% Final Aesthetics:
set(gca, ...
  'XTick',(0:0.2:1),'ZTick',(0:0.2:1),...
  'FontName', 'Times','FontSize',10,...   
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
'ZMinorTick'  , 'off'      , ...
  'YGrid'       , 'on'      , ...
  'XGrid'       , 'on'      , ...
  'ZGrid'       , 'on'      , ...
  'XColor'      , [.1 .1 .1], ...
  'YColor'      , [.1 .1 .1], ...
  'ZColor'      , [.1 .1 .1], ...  
  'YTick'       ,0:90:360,     ...
  'XTick'       ,0:0.25:1,     ...
  'XTickLabel'  ,{'0','','0.5','','1'},...
  'ZTick'       ,0:0.25:1,     ...
  'LineWidth'   , 1         );
end

%%% Export the figure:
% fname = [fig_dir 'TP39_1Dvs2D-wdbinned-linear.eps'];
% print(f1b2,'-depsc2',fname);
% fixPSlinestyle(fname,fname);
fname2 = [fig_dir 'Figure2-TP39_1Dvs2D-wdbinned-linear.png'];
print(f1b2,'-r600','-dpng',fname2);
export_fig([fig_dir 'Figure2-TP39_1Dvs2D-wdbinned-linear-ef.png'],'-png', '-r200');


%% Plot the slopes and intercepts:
try close(f1c);catch;end; f1c = figure('Position',[300 1000 800 500],'Name','1Dvs2D-slopes_ints_r2');clf;
plot(wd_bins,p_1b(:,1),'b.-'); grid on; hold on;
plot(wd_bins,p_1b(:,2),'r.-'); 
plot(wd_bins,rsq(:,1),'g.-'); 
legend('slope','int','r2','Location','East');
axis([0 360 -0.15 1.25])
saveas(f1c,[ ls 'Matlab/Figs/Footprint/TP39_1Dvs2D-slopes_ints_r2.png']);

% Clean up coefficients. Run prediction of 1d footprint (slope,int corrected)
coeff_1dcorr = p_1b;
% coeff_1dcorr(23:47,1:2) = NaN;
mc_pred = NaN.*ones(length(CWI),1);
corr_factor = [ones(length(CWI),1) zeros(length(CWI),1)];
for j = 1:1:length(wd_bins)
   ind_wd{j,1} = find(wd >=wd_bins(j) & wd < wd_bins(j)+wd_incr & CWI > 0.05 & ~isnan(wd.*inbounds_flux_2D.*CWI));
CWI_corr(ind_wd{j,1},1) = polyval(coeff_1dcorr(j,:),CWI(ind_wd{j,1},1));
corr_factor(ind_wd{j,1},1) = coeff_1dcorr(j,1);
corr_factor(ind_wd{j,1},2) = coeff_1dcorr(j,2);
end

% try close(f3g);catch;end
% f3g = figure('Position',[300 1 512 384],'Name','1d-pred');clf;    
% plot(max_contour_inbounds(ind_abv50b),'b-'); hold on;
% plot(mc_pred(ind_abv50b).*100,'r-'); hold on;
   ind= find(CWI > 0.05 & ~isnan(wd.*inbounds_flux_2D.*CWI));

diff_mc = (CWI_corr(ind))-CWI(ind);

%% Histogram of Corrections to 1D Footprint Estimate
try close(f1d);catch;end; f1d = figure('Units','centimeters','Position',[10 23 12 10],...
    'Color','w','PaperPositionMode','Auto');clf;
%     try close(f1b2);catch;end; f1b2 = figure('Units','pixels','Position',[300 1000 800 400],'PaperPositionMode','Auto','Name','CWI vs 2D, binned WD');clf;

incr = 0.02;
mc_bins = (-0.3:incr:0.3)';
[n_diffmc] = histc(diff_mc,mc_bins);
h1_1d = bar(mc_bins+(incr/2), n_diffmc./sum(n_diffmc),'EdgeColor',[0.3 0.3 0.3],'FaceColor',[0.6 0.6 0.6]); hold on;
ax1 = gca;
% set(ax1,'YColor',[0 0 0.4]);
axis(ax1,[-0.3 0.3 0 0.25])
% plot([0 0],[0 0.25],'k-','LineWidth',2);
% ylabel('Proportion of all Half-hours');
ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'XAxisLocation','bottom',...
           'Color','none',...
           'XColor','k','YColor','k');
     axis(ax2,[-0.3 0.3 0 1])
hold on;
h2_1d = plot(ax2,mc_bins+(incr/2),cumsum(n_diffmc./sum(n_diffmc)),'-','Color','k','LineWidth',2);

grid on; axis([-0.3 0.3 0 1])

% Adjusting Axes:
axes(ax1);
hYLabel = ylabel('Proportion of Half-hours','FontName','Arial','FontSize',12,'FontWeight','bold','Color',[0.5 0.5 0.5]);
set(ax1,  'FontName'   , 'Arial','YColor','k','Position',[0.15 0.15 0.7 0.82],...
  'Box'         , 'on'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.015 .015] , ...
'XTick', [], ...
  'YGrid'       , 'on'      , ...
  'XGrid'       , 'on'      , ...
  'XColor'      , [1 1 1], ...
  'YTick'       ,0:0.05:0.25,     ...
  'LineWidth'   , 1         );    

axes(ax2);
hYLabel = ylabel('Cumulative Proportion','FontName','Arial','FontSize',12,'FontWeight','bold');
hXLabel = xlabel('Absolute Correction to F_{in} - 1D','FontName','Arial','FontSize',12,'FontWeight','bold','VerticalAlignment','top');
set(ax2,  'FontName'   , 'Times','YColor','k','Position',[0.15 0.15 0.7 0.82],...
  'Box'         , 'on'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.015 .015] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'off'      , ...
  'YGrid'       , 'off'      , ...
  'XGrid'       , 'off'      , ...
  'XColor'      , [.1 .1 .1], ...
  'YTick'       ,0:0.2:1,     ...  
  'XTick'       ,-0.3:0.1:0.3,     ...  
  'LineWidth'   , 1         );
%%% Export the figure:
% fname = [fig_dir '1D-corrections.eps'];
% print(f1d,'-deps2',fname);
% fixPSlinestyle(fname,fname);
fname2 = [fig_dir 'Figure3-1D-corrections.png'];
print(f1d,'-r600','-dpng',fname2);
export_fig([fig_dir 'Figure3-1D-corrections-ef.png'],'-png', '-r200');


%%
%%%% Let's output some of this:
KM.KM1d_corr = CWI_corr;
KM.KM1d_orig = CWI;
KM.KM2d = inbounds_flux_2D;
KM.corr_factor = corr_factor;
save([ ls 'Matlab/Data/Footprint/KM_fpdata.mat'],'KM');

%% Comparing the different footprint outputs:

%{
%%% So what if we use >70%?  What kind of distribution can we expect?
ind70 = find(inbounds_flux_2D >= 0.5 & max_contour_inbounds > 70); n70 = length(ind70)./length(max_contour_inbounds);
ind75 = find(inbounds_flux_2D >= 0.5 & max_contour_inbounds > 75); n75 = length(ind75)./length(max_contour_inbounds);
ind80 = find(inbounds_flux_2D >= 0.5 & max_contour_inbounds > 80); n80 = length(ind80)./length(max_contour_inbounds);

%%% Figure out proportion of hhours with total inbounds flux > 50%,55%...
n_real = (0.5:0.05:0.9)';
for j = 1:1:length(n_real)
n_real(j,2) = length(find(inbounds_flux_2D >= n_real(j,1)))./length(max_contour_inbounds); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot a cumulative distribution function for the inbounds proportion%%%
bins = (0.1:0.05:0.95)';
n_inbounds = histc(inbounds_flux_2D,bins);
n_contour = histc(max_contour_inbounds./100,bins);
n_inbounds_cumprop = 1 - (cumsum(n_inbounds)./sum(n_inbounds));
n_contour_cumprop = 1 - (cumsum(n_contour)./sum(n_contour));
% n_inbounds_orig = histc(inbounds_p_orig,bins);
% n_contour_orig = histc(max_contour_inbounds_orig./100,bins);
% n_inbounds_cumprop_orig = 1 - (cumsum(n_inbounds_orig)./sum(n_inbounds_orig));
% n_contour_cumprop_orig = 1 - (cumsum(n_contour_orig)./sum(n_contour_orig));

f4 = figure('Position',[1 1 512 384]);clf;
h4_p1 = plot(bins.*100,n_inbounds_cumprop,'Color',clrs(1,:),'LineWidth',2); hold on;
h4_p2 = plot(bins.*100,n_contour_cumprop,'Color',clrs(2,:),'LineWidth',2);
% h4_p5 = plot(bins.*100,n_inbounds_cumprop_orig,'--','Color',clrs(1,:),'LineWidth',2); hold on;
% h4_p6 = plot(bins.*100,n_contour_cumprop_orig,'--','Color',clrs(2,:),'LineWidth',2);

grid on; set(gca,'XTick',[10:5:95]); set(gca,'YTick',[0:0.1:1]);
ylabel('Total Proportion of usable half-hours');
xlabel('Required % flux coming from inside forest bounds');
title('Usable hhours for selected % within-footprint requirement (2006-2011)');

% Add in the other methods (Schuepp, Kljun) for comparison:
Sch_fp = (60:5:90)';
Sch_cumprop = NaN.*ones(length(n_contour_cumprop),1);
Klj_cumprop = NaN.*ones(length(n_contour_cumprop),1);
start_row = find(bins >= 0.5999 & bins <=0.6005);
for j = 1:1:length(Sch_fp)
    Sch_tmp = eval(['footprint_flag.Schuepp' num2str(Sch_fp(j))]);
    Sch_use = Sch_tmp(footprint_flag.Year>=2006 & footprint_flag.Year<=2011,2); 
    Sch_cumprop(start_row+j-1,1) = nansum(Sch_use)./length(Sch_use);
    Klj_tmp = eval(['footprint_flag.Kljun' num2str(Sch_fp(j))]);
    Klj_use = Klj_tmp(footprint_flag.Year>=2006 & footprint_flag.Year<=2011,2); 
    Klj_cumprop(start_row+j-1,1) = nansum(Klj_use)./length(Klj_use);
end

h4_p3 = plot(bins.*100,Sch_cumprop,'Color',clrs(3,:),'LineWidth',2);
h4_p4 = plot(bins.*100,Klj_cumprop,'Color',clrs(4,:),'LineWidth',2);
legend({'KM-total inbounds sum','KM-largest contour','Sch-largest contour','Klj-largest contour'});
print('-dpng','-r300','/home/brodeujj/Matlab/Data/KM_footprint_test/TP39_UsableData')
% print('-dpng','-r300','/home/brodeujj/Desktop/test1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% for j = 1:1:length(n_real)
% n_real(j,2) = length(find(inbounds_flux_2D >= n_real(j,1)))./length(max_contour_inbounds); 
% end
% 
% % n_elements = histc(y,x);
% %%%
% 
% fetch_diff = max_fetch-Xdist(:,7);
% f5 = figure('Tag','f5','Position',[1 1 512 384]);clf;
% bar(fetch_diff);
% 
% 
% %     n70real= 
% % n75real= length(find(inbounds_p >= 0.75))./length(max_contour_inbounds);
% % n80real= length(find(inbounds_p >= 0.8))./length(max_contour_inbounds);
% 
% 
% f6 = figure('Position',[1 1 512 384]);clf;
% plot(out.Xdist(:,5)-out.max_fetch,'k.');hold on;
% % plot(out.max_fetch,'r.');
% 
% f7 = figure('Position',[1 1 512 384]);clf;
% plot(inbounds_p,'k.');hold on;
% % plot(inbounds_p_orig,'r.');hold on;
%}