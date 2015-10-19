% load('/home/brodeujj/Matlab/Data/KM_footprint_test/KM_TP39_2010_results.mat');
ls = addpath_loadstart;
clrs = jjb_get_plot_colors;

yr_list = (2006:1:2011)';
Year = [];
Xind = [];
Xdist = [];
inbounds_p = [];
max_fetch = [];
max_contour_inbounds = [];

for i = 1:1:6
load([ls 'Matlab/Data/KM_footprint_test/KM_TP39_' num2str(yr_list(i)) '_results.mat']);
Year = [Year; yr_list(i).*ones(size(out.Xind,1),1)];
Xind = [Xind; out.Xind];
Xdist = [Xdist; out.Xdist];
inbounds_p = [inbounds_p; out.inbounds_p];
max_fetch = [max_fetch; out.max_fetch];
max_contour_inbounds = [max_contour_inbounds; out.pct_in_fetch];
end
%%%%%%%
% Load the traditional footprint flag file:
load([ls 'Matlab/Data/Flux/Footprint/TP39_footprint_flag.mat']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% histogram of the total % of flux originating from within the bounds, per
%%% half-hour
f1 = figure('Position',[1 1 512 384]);clf;
hist(inbounds_p);

%%% Histogram of the maximum contour contained within the flux for a given
%%% half-hour
f2 = figure('Position',[1 1 512 384]);clf;
hist(max_contour_inbounds);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3 = figure('Position',[1 1 512 384]);clf;
plot_ctr = 1;
for yr = 2006:1:2011
    ind_abv50 = find(inbounds_p >= 0.5 & Year == yr);
f3h(plot_ctr,1) = plot(max_contour_inbounds(ind_abv50,1)/100,inbounds_p(ind_abv50,1),'.','Color',clrs(plot_ctr,:));hold on;
plot_ctr = plot_ctr+1;
end
grid on;
f3h(plot_ctr,1) = plot([0.5 1],[0.5 1],'k--','LineWidth',2);
legend([cellstr(num2str((2006:1:2011)')); '1:1 Line'],'Location','NorthWest');
ylabel('total inbounds %');xlabel('max alongwind %');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% So what if we use >70%?  What kind of distribution can we expect?
ind70 = find(inbounds_p >= 0.5 & max_contour_inbounds > 70); n70 = length(ind70)./length(max_contour_inbounds);
ind75 = find(inbounds_p >= 0.5 & max_contour_inbounds > 75); n75 = length(ind75)./length(max_contour_inbounds);
ind80 = find(inbounds_p >= 0.5 & max_contour_inbounds > 80); n80 = length(ind80)./length(max_contour_inbounds);

%%% Figure out proportion of hhours with total inbounds flux > 50%,55%...
n_real = (0.5:0.05:0.9)';
for j = 1:1:length(n_real)
n_real(j,2) = length(find(inbounds_p >= n_real(j,1)))./length(max_contour_inbounds); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot a cumulative distribution function for the inbounds proportion%%%
bins = (0.1:0.05:0.95)';
n_inbounds = histc(inbounds_p,bins);
n_contour = histc(max_contour_inbounds./100,bins);
n_inbounds_cumprop = 1 - (cumsum(n_inbounds)./sum(n_inbounds));
n_contour_cumprop = 1 - (cumsum(n_contour)./sum(n_contour));
f4 = figure('Position',[1 1 512 384]);clf;
h4_p1 = plot(bins.*100,n_inbounds_cumprop,'Color',clrs(1,:),'LineWidth',2); hold on;
h4_p2 = plot(bins.*100,n_contour_cumprop,'Color',clrs(2,:),'LineWidth',2);
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


for j = 1:1:length(n_real)
n_real(j,2) = length(find(inbounds_p >= n_real(j,1)))./length(max_contour_inbounds); 
end

n_elements = histc(y,x);
%%%

fetch_diff = max_fetch-Xdist(:,7);
f5 = figure('Tag','f5','Position',[1 1 512 384]);clf;
bar(fetch_diff);


%     n70real= 
% n75real= length(find(inbounds_p >= 0.75))./length(max_contour_inbounds);
% n80real= length(find(inbounds_p >= 0.8))./length(max_contour_inbounds);


f6 = figure('Position',[1 1 512 384]);clf;
plot(out.Xdist(:,5)-out.max_fetch,'k.');hold on;
% plot(out.max_fetch,'r.');