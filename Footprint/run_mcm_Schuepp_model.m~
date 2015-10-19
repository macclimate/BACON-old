%% mcm_Schuepp_model
clear all;
close all;
ls = addpath_loadstart;

site = 'TP02'; ustar_thresh = 0.15;
year = 2008;
path = [ls 'Matlab/Data/Master_Files/' site '/'];
load([path site '_gapfill_data_in.mat']);

[Heights] = params(year, site, 'Heights');
u = data.WS(data.Year == year);
ustar = data.Ustar(data.Year == year);
H = data.H(data.Year == year);
Ta = data.Ta(data.Year == year);
RH = data.RH(data.Year == year);
APR = data.APR(data.Year == year);
W_Dir = data.W_Dir(data.Year == year);
PAR = data.PAR(data.Year == year);
z = Heights(1,1); 
h = Heights(1,2);
thresh = 0.04; % stable threshold

%%% Convert wind data to polar direction coordinates
[W_Dir_rad] = CSWind2Polar(W_Dir,'rad');
%%% Convert Fetch Info to polar coordinates:
[fetch] = params(year, site, 'Fetch');
[angles_out dist_out] = fetchdist(fetch);
[angles_sorted index] = sort(angles_out);
dist_sorted = dist_out(index);

[x_max_m, x_max_h, xf_m, xf_h,L2,zL] = mcm_Schuepp_footprint_v2(u, ustar, H, Ta, RH, APR, z, h);
% mcm_Schuepp_footprint(data,2005,2005,0.35,0.7)
%%% Plot Footprint Fetches:
% clrs = rand(9,3);
clrs = [0.07,0.99,0.6;0.41,0.86,0.15;0.67,0.39,0.9;0.93,0.45,0.45;0.81,0.25,0.21;0.48,0.78,0.9;0.76,0.88,0.76;0.42,0.91,0.88;0.97,0.56,0.28;];

figure('Name', 'Schuepp - All Data');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(xf_h(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(xf_h(:,plot_num)));
    h(plot_num) = polar(W_Dir_rad(ind),xf_h(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux'])
     rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:

end

%%% Plot Footprint Fetches for unstable/neutral periods:
figure('Name', 'Schuepp - Neutral + Unstable');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(xf_h(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(xf_h(:,plot_num)) & zL < thresh);
    h(plot_num) = polar(W_Dir_rad(ind),xf_h(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux. Unstable + Neutral'])
     rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
end

%%% Plot Footprint Fetches for stable periods:
figure('Name', 'Schuepp - Stable');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(xf_h(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(xf_h(:,plot_num)) & zL > thresh);
    h(plot_num) = polar(W_Dir_rad(ind),xf_h(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux. Stable'])
     rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
end

%%% Plot Footprint Fetches for stable periods:
figure('Name', 'Schuepp - u_{*} filtered');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(xf_h(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(xf_h(:,plot_num)) & ((ustar >= ustar_thresh & PAR < 20)|PAR >=20));
    h(plot_num) = polar(W_Dir_rad(ind),xf_h(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,pl_dist.*ones(length(plot_ang),1));
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux. u_{*} accepted'])
     rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph
end


%% RUNS HSIEH FOOTPRINT MODEL:
clear all;
close all;
site = 'TP02'; ustar_thresh = 0.15;
year = 2008;
ls = addpath_loadstart;
path = [ls 'Matlab/Data/Master_Files/' site '/'];
load([path site '_gapfill_data_in.mat']);
data.site = site;
clrs = [0.07,0.99,0.6;0.41,0.86,0.15;0.67,0.39,0.9;0.93,0.45,0.45;0.81,0.25,0.21;0.48,0.78,0.9;0.76,0.88,0.76;0.42,0.91,0.88;0.97,0.56,0.28;];

[Heights] = params(year, site, 'Heights');
%%%% Vegetation heights
hcan = Heights(1,2);    % vegetation height (m)
d    = hcan*2/3;        % displacemeny height (m)
zo   = hcan*0.1;        % roughness heigh (m)
%%% Measurement heights:
z    = Heights(1,1);    % flux instrument height at proposed 20m tower (m)
zm = z - d;
%%% Data:
ustar = data.Ustar(data.Year == year);
H = data.H(data.Year == year);
Ta = data.Ta(data.Year == year);
W_Dir = data.W_Dir(data.Year == year);
PAR = data.PAR(data.Year == year);
thresh = 0.04;
%%% Run Footprint Calculation:
[Fc,L,xp,F2H,stab] = mcm_footprint_hsieh(ustar,H,Ta,zm,zo);
%%% Convert wind data to polar direction coordinates
[windd_math_rad] = CSWind2Polar(W_Dir,'rad');
%%% Convert Fetch Info to polar coordinates:
[fetch] = params(year, site, 'Fetch');
[angles_out dist_out] = fetchdist(fetch);
[angles_sorted index] = sort(angles_out);
dist_sorted = dist_out(index);
%%% Plot Footprint Fetches:
figure('Name', 'Hsieh - All Data');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(Fc(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(Fc(:,plot_num)));
    h(plot_num) = polar(windd_math_rad(ind),Fc(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,[pl_dist.*ones(length(plot_ang),1)]);
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux'])
rlim = max(dist_sorted)+100;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:

end

figure('Name', 'Hsieh - Neutral/Unstable');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
            %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,[pl_dist.*ones(length(plot_ang),1)]);hold on;
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end
rlim = max(dist_sorted).*1.5;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:

    ind = find(Fc(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(Fc(:,plot_num)) & stab(:,1) < thresh);
    h(plot_num) = polar(windd_math_rad(ind),Fc(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux; neutral & unstable'])

end

figure('Name', 'Hsieh - Stable');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(Fc(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(Fc(:,plot_num)) & stab(:,1) > thresh);
    h(plot_num) = polar(windd_math_rad(ind),Fc(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
        %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,[pl_dist.*ones(length(plot_ang),1)]);
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end

    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux; stable'])
  rlim = max(dist_sorted);axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:

end

figure('Name', 'Hsieh - u_{*} filtered');clf;
for plot_num = 1:1:9
    subplot(3,3,plot_num)
    
    ind = find(Fc(:,plot_num) < max(dist_sorted).*1.5 & ~isnan(Fc(:,plot_num)) & ((ustar >= ustar_thresh & PAR < 20)|PAR >=20) );
    h(plot_num) = polar(windd_math_rad(ind),Fc(ind,plot_num),'.'); hold on;
    set(h(plot_num),'Color', clrs(plot_num,:));
    
    hh(plot_num) = polar(angles_sorted,dist_sorted);
    set(hh(plot_num),'Color', 'r', 'LineWidth', 2);
    
        %%% Plot Contour Distancs Rings
plot_ang = (0:pi/180:2*pi)';
for pl_dist = 100:100:max(dist_sorted)+100
    h2 = polar(plot_ang,[pl_dist.*ones(length(plot_ang),1)]);
  set(h2,'LineStyle','--','LineWidth',2,'Color',[0.5 0.5 0.5]);
  t1 = text(0,pl_dist+10,num2str(pl_dist)); set(t1, 'FontSize',8,'Color','k');
end

    title(['Fetches for ' num2str(45+ (5.*plot_num)) ' % Flux; u_{*}-accepted'])
        rlim = max(dist_sorted);axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:

end




rlim = 1000;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:
%% Plotting stuff
figure(33);clf;
plot(L); hold on;
% plot(ustr,'r');
plot(monl,'g');
axis([0 17520 -500 500])
figure(34);clf;
plot(tv)
axis([0 17520 0 2])

figure(35);clf
plot(xcorrm_real,'.');hold on;
plot(xcorrhs_real,'r.')
axis([1 17520 0 500])

figure(36);clf;
plot(hs); hold on;
plot(xcorrhs_real,'r.')
axis([1 17520 -200 500])