clear all; close all;
site = 'TP_OAK';
year_start = 2005;
year_end = 2005;
fp_type = 'Schuepp';
Xcrit = (70:10:80)';
ustar_thresh = 0.325;
z = 32:2:36; % EC Measurement Height
h = 24; % Tree Height
zanm = 28; % Height at which anemometer information comes from (TP39)
[clrs, clrguide] = jjb_get_plot_colors;
stab_thresh = 0.04; % stability threshold
plot_ang = (0:pi/180:2*pi)';

fig_path = '/home/brodeujj/Matlab/Figs/Footprint/TP_OAK2/';
jjb_check_dirs(fig_path);
met_path = '/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_AA_analysis_data.mat';

%%% Step 1: Load the fetch information into program and check it's right
TP_OAK1_angles = csvread('/home/brodeujj/Matlab/Data/Flux/Footprint/TP-OAK2/TP-OAK.csv');
% TP_OAK2_angles = csvread('/home/brodeujj/Matlab/Data/Flux/Footprint/TP-OAK/TP-OAK_Site2.csv');
% TP_OAK3_angles = csvread('/home/brodeujj/Matlab/Data/Flux/Footprint/TP-OAK/TP-OAK_Site3.csv');
%%% Plot the fetch information for each site:
[angles_out1 dist_out1 f1] = fetchdist(TP_OAK1_angles, 1);
[angles(1).sorted index1] = sort(angles_out1);dist(1).sorted = dist_out1(index1);clear angles_out1 dist_out1;
% [angles_out2 dist_out2 f2] = fetchdist(TP_OAK2_angles, 1);
% [angles(2).sorted index2] = sort(angles_out2);dist(2).sorted = dist_out2(index2);clear angles_out2 dist_out2;
% [angles_out3 dist_out3 f3] = fetchdist(TP_OAK3_angles, 1);
% [angles(3).sorted index3] = sort(angles_out3);dist(3).sorted = dist_out3(index3);clear angles_out3 dist_out3;


%%% Save figures:
figure(f1); set(gca, 'FontSize', 16);print('-dtiff', [fig_path 'Site1_Outline']);
% figure(f2); set(gca, 'FontSize', 16); print('-dtiff', [fig_path 'Site2_Outline']);
% figure(f3); set(gca, 'FontSize', 16); print('-dtiff', [fig_path 'Site3_Outline']);

%%% Step 2: Get meteorological data
load(met_path);
data = trim_data_files(data, year_start, year_end,1);
%%% Step 3: What height are we preposing this tower at?  Need to extend
%%% windspeed up to preposed height from the current measured height (28m)
% yr_ctr = 1;
% for year = year_start:1:year_end
ind_use = find(data.Year>=year_start & data.Year <= year_end);
u = data.WS(ind_use,1);
ustar = data.Ustar(ind_use,1);
H = data.H_filled(ind_use,1);
Ta = data.Ta(ind_use,1);
RH = data.RH(ind_use,1);
APR = data.APR(ind_use,1);
W_Dir = data.W_Dir(ind_use,1);
RE_flag = data.RE_flag(ind_use,1);
GEP_flag = data.GEP_flag(ind_use,1);
% PAR = data.PAR(ind_use,1);
%%% Convert wind data to polar direction coordinates
[W_Dir_rad] = CSWind2Polar(W_Dir,'rad');
[W_Dir_deg] = CSWind2Polar(W_Dir,'deg');
% Prepare Other Data:
%         temp_flag_file = zeroes(length(u),1);
temp_max_fetch = NaN.*ones(length(u),1);

%%% Run Footprint:
[x_max_m, x_max_h, xf_m, xf_h, L2, zL] = mcm_Schuepp_footprint(u, ustar, H, Ta, RH, APR, 32, h, zanm);
x_max32 = x_max_h; % Distance of maximum contribution to measured flux
Xpct32  = xf_h; % Fetch distances for given % of measured flux
[x_max_m, x_max_h, xf_m, xf_h, L2, zL] = mcm_Schuepp_footprint(u, ustar, H, Ta, RH, APR, 34, h, zanm);
x_max34 = x_max_h; % Distance of maximum contribution to measured flux
Xpct34  = xf_h; % Fetch distances for given % of measured flux
[x_max_m, x_max_h, xf_m, xf_h, L2, zL] = mcm_Schuepp_footprint(u, ustar, H, Ta, RH, APR, 36, h, zanm);
x_max36= x_max_h; % Distance of maximum contribution to measured flux
Xpct36 = xf_h; % Fetch distances for given % of measured flux

%%% Sort the wind directions into bins
    max_fetch = NaN.*ones(length(u),1);
for k = 1:1:length(angles(1).sorted)-1
        ind2 = find(W_Dir_rad >= angles(1).sorted(k) & W_Dir_rad < angles(1).sorted(k+1));
        max_fetch(ind2) = dist(1).sorted(k);
end
    

for i = 1:1:length(z)
        temp(i).flag_file = zeros(length(u),4);
    Xpct = eval(['Xpct' num2str(z(i))]);
    ctr_Xcrit = 1;
    for Xcrit_col = 3:2:9 % cycle through 60,70,80 and 90% fetch requirement
        % Case 1: When the Xpct is less than max fetch (keep data)
        temp(i).flag_file(Xpct(:,Xcrit_col) <=max_fetch, ctr_Xcrit) = 1;
        % Case 2: When the Xpct is more than max fetch (remove data)
        temp(i).flag_file(Xpct(:,Xcrit_col) > max_fetch, ctr_Xcrit) = NaN;
        % This current setup will leave flag = 0 when there is no WDir data
        ctr_Xcrit = ctr_Xcrit+1;
    end
    temp(i).Xpct = [Xpct(:,3) Xpct(:,5) Xpct(:,7) Xpct(:,9)];
end

fp_out = temp;
% fp_out(1).Xpct = [Xpct(:,3) Xpct(:,5) Xpct(:,7) Xpct(:,9)];
clear temp ind2;
%
% flag_file= temp_flag_file;
% max_fetch = temp_max_fetch;
% Xpct_all = Xpct;
% clear temp_max_fetch ind2 temp_flag_file;



%% Plotting and Statistics:
%%% Data is in structure (fp_out(site).flag_file(:,1:4)), where columns 1
%%% to 4 are flags for 60, 70, 80 and 90 %
XCrit_col_labels = {'60'; '70';'80';'90'};
for i = 1:1:length(z)
    site = 1;
    for Xcrit_col = 1:1:4
        %%% Plot 1: do plot for all years and calculate statistics:
        f1(site,Xcrit_col) = figure('Name',['z =  ' num2str(z(i)) ', all, XCrit = ' XCrit_col_labels{Xcrit_col,1}], 'Tag',[num2str(site) 'all' XCrit_col_labels{Xcrit_col,1}]);clf;
%         set(gcf, 'PaperOrientation', 'landscape', 'PaperType','usletter');
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 5 5]);

        % plot the position of the XCrit isopleth
        h1 = polar(W_Dir_rad, fp_out(i).Xpct(:,Xcrit_col),'.'); hold on; % plot distances
        set(h1, 'Color', clrs(1,:));
        hh = polar(angles(site).sorted,dist(site).sorted); % plot the site
        set(hh,'Color', 'r', 'LineWidth', 2);
        % plot contours
        for pl_dist = 200:200:max(dist(site).sorted)+200
            hL = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
            set(hL,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
            t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','r');
            t2 = text(0,-1*pl_dist-10,num2str(pl_dist)); set(t2, 'FontSize',8,'Color','r');
            
        end
        axis([-3000 2000 -3000 2000])
        title(['z = ' num2str(z(i)) ', all, XCrit = ' XCrit_col_labels{Xcrit_col,1}]);
        print('-dtiff', [fig_path 'FP - z' num2str(z(i)) 'XC_' XCrit_col_labels{Xcrit_col,1} '_z' num2str(z(i)) '_h' num2str(h)]);
        
        %%% Stats: %%%%%%%
        
        coverage_stats(i, Xcrit_col) = length(find(fp_out(i).flag_file(:,Xcrit_col)==1))./ ...
            length(find(fp_out(i).flag_file(:,Xcrit_col)~=0));
        coverage_stats_ustar(i, Xcrit_col) = length(find(fp_out(i).flag_file(:,Xcrit_col)==1 & ustar >= ustar_thresh  )) ./ ...
            length(find(fp_out(i).flag_file(:,Xcrit_col)~=0 & ustar >= ustar_thresh));
        
        
        
        %%% Make second set of figures: %%%%%%%%%%%%
        flag_file_rs1 = [];
        RE_flag_list = [];
        GEP_flag_list = [];
        for yr = year_start:1:year_end
            tmp_use = fp_out(i).flag_file(data.Year == yr,Xcrit_col);
            flag_file_rs1 = [flag_file_rs1 tmp_use(1:17520)];
            RE_flag_list = [RE_flag_list; data.RE_flag(data.Year == yr)];
            GEP_flag_list = [GEP_flag_list; data.GEP_flag(data.Year == yr)];
            clear tmp_use
        end
        flag_file_rs2 = nansum(flag_file_rs1,2);
%         flag_file_rs2= flag_file_rs2';
        RE_prop = length(find(RE_flag_list==2 & flag_file_rs1(:) == 1)) ./ length(find(RE_flag_list == 2));
        GEP_prop = length(find(GEP_flag_list>=1 & flag_file_rs1(:) == 1)) ./ length(find(GEP_flag_list >= 1));
        
        flag_file_rs3 = reshape(flag_file_rs2,48,[])./(year_end - year_start +1);
        
        f2(i,Xcrit_col) = figure('Name',['z =  ' num2str(z(i)) ', all, XCrit = ' XCrit_col_labels{Xcrit_col,1}], ...
            'Tag',[num2str(site) 'Likelihood' XCrit_col_labels{Xcrit_col,1}]);clf;
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 7 3.5]);

%         set(gcf, 'PaperOrientation', 'landscape', 'PaperType','usletter');

        pcolor(flag_file_rs3);
        shading flat;
        colorbar
        caxis([0 1])
        ylabel('Time, EST');
        xlabel('DOY');
        title(['z =  ' num2str(z(i)) ', all, XCrit = ' XCrit_col_labels{Xcrit_col,1} ';  RE_{prop} = ' num2str(RE_prop) ',  GEP_{prop} = ' num2str(GEP_prop)],'FontSize',14);
%         set(gca, 'YTick', (0:6:48), 'YTickLabel', {'0';'3';'6';'9';'12';'15';'18';'21';'24'})
        set(gca, 'YTick', (4:6:48), 'YTickLabel', {'9pm';'12am';'3am';'6am';'9am';'12pm';'3pm';'6pm'})
        set(gca, 'FontSize', 16);
        % Figure out proportion of day & nighttime data that would be OK:   
        print('-dtiff', [fig_path 'Flags - z = ' num2str(z(i)) 'XC_' XCrit_col_labels{Xcrit_col,1} '_z' num2str(z) '_h' num2str(h)]);
  
        if i == 1 && Xcrit_col == 3
            flags(1).out = flag_file_rs3;
        elseif i ==2 && Xcrit_col == 3
            flags(2).out = flag_file_rs3;
        end
        
clear flag_file* GEP_prop RE_prop;

    end
    close all;
end
% 
% to_plot = flags(1).out - flags(2).out; % difference between site 1 and 2 data coverage at 0.8 Xcrit
% figure('Name', 'Site 1 coverage - Site 2 coverage, Xcrit = 0.8');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperPosition', [0 0 7 3.5]);
%         
%         pcolor(to_plot);
%         shading flat;
%         colorbar
%         caxis([-0.6 0.2])
%         ylabel('Time, EST');
%         xlabel('DOY');
%         title('Site 1 coverage - Site 2 coverage, Xcrit = 0.8');
% %         set(gca, 'YTick', (0:6:48), 'YTickLabel', {'0';'3';'6';'9';'12';'15';'18';'21';'24'})
%         set(gca, 'YTick', (4:6:48), 'YTickLabel', {'9pm';'12am';'3am';'6am';'9am';'12pm';'3pm';'6pm'})
%  set(gca, 'FontSize', 16);
%         print('-dtiff', [fig_path 'Flags - Site1vs2' 'XC_80_z' num2str(z) '_h' num2str(h)]);
