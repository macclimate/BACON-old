function KM_footprint_JJBtest1

%%% Load data
% input_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Input/';
% output_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Output/';
% input_path = '/1/fielddata/Matlab/Data/KM_footprint_test/Input/';
% ls = '/home/brodeujj/';
% output_path = '/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/';
output_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test'];
year = 2010;
% TP39_master = load(['/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
% TP39_CPEC = load(['/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Cleaned/TP39_CPEC_cleaned_' num2str(year) '.mat']);
% TP39_master = load(['/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
% TP39_CPEC = load(['/home/brodeujj/Matlab/Data/KM_footprint_test/Input/TP39_CPEC_cleaned_' num2str(year) '.mat']);

% TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
%%% Site parameters:
[heights] = params(year, 'TP39', 'Heights');
h_c = heights(2);
z_m = heights(1);
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;

%%% Site Variables:
%%% Variables to vary: wd, u, Ta, RH, LE, sig_v ust

p_bar = 100;
wd = [1;270]; wd_polar = CSWind2Polar(wd);
u = [1; 4];
T_a = [5; 20];
RH = [50; 95];
H = [50; 400];
LE = [30; 400];
sig_v = [0.3; 2];
ust = [0.1; 0.8];
inputs = [];
for a1 = 1:1:size(p_bar,1)
    for a2 = 1:1:size(wd_polar,1)    
        for a3 = 1:1:size(u,1)
            for a4 = 1:1:size(T_a,1)
                for a5 = 1:1:size(RH,1)
                    for a6 = 1:1:size(H,1)
                        for a7 = 1:1:size(LE,1)
                            for a8 = 1:1:size(sig_v,1)
                                for a9 = 1:1:size(ust,1)
                                    inputs = [inputs;[p_bar(a1) wd_polar(a2) u(a3) T_a(a4) RH(a5) H(a6) LE(a7) sig_v(a8) ust(a9)]];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
num_runs = size(inputs,1);
%% Set up Footprint Grid:
% Definition of the grid over which the footprint phi is going to be  calculated
y_max = 2000;  %caution: make sure the x_max, y_max is same as that defined in footprint_kormann_and_meixner
x_max = 2000;
pix = 2;  %pix= d in footprint_kormann_and_meixner

% Definition of the grid over which the footprint phi is going to be
% calculated
x = [-x_max:pix:x_max];
y = [0:pix:y_max]; y = y(end:-1:1)';

M = length(x);  % pixels in x direction
N = length(y);  % pixels in y direction
x_x = x(ones(1,N),:);
y_y = y(:,ones(1,M));

% Rotate input matrix within a 1.5 times larger matrix. To call this
% function this time is for getting the size of rotated matrix in order to
% [B,TransferF] = footprint_rotate(x_x,y_y,x_x,0);%   this is the reference point for rotation B(6,6)=99

x_x = round(x_x);
y_y = round(y_y);
y_y = flipud(y_y);

%% Set up Site Grid:
XCrit = (50:5:95);
Xind = NaN.*ones(num_runs,size(XCrit,2));
Xdist =NaN.*ones(num_runs,size(XCrit,2));
inbounds_prop = NaN.*ones(num_runs,1);
max_fetch = NaN.*ones(num_runs,1);
pct_in_fetch = NaN.*ones(num_runs,1);

[fetch] = params(year,'TP39', 'Fetch');
[angles_out dist_out] = fetchdist(fetch);

%% hhour by hhour calculations:
% ind_data = prod([u wd p_bar T_a RH H LE sig_v ust],2);
L = NaN.*ones(num_runs,1);ust_pred = NaN.*ones(num_runs,1);Lstar = NaN.*ones(num_runs,1);
% inputs = NaN.*ones(num_runs,9);
% fig_ctr = 1; 
sp_ctr = 1;
f1 = figure('visible','off');
f2 = figure('visible','off');
for i = 1:1:num_runs
    p_bar_tmp = inputs(i,1);
    wd_polar_tmp  = inputs(i,2); u_tmp = inputs(i,3); T_a_tmp = inputs(i,4);
    RH_tmp = inputs(i,5); H_tmp = inputs(i,6); LE_tmp = inputs(i,7);
    sig_v_tmp = inputs(i,8); ust_tmp = inputs(i,9);
    try
        tic;
        [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c, z_m, u_tmp, T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
        
        %%% Footprint Calculation
        [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0,z_m,u_tmp,ust_tmp,sig_v_tmp,L(i,1),y_max,x_max,pix);
        
        % cal relative footprint function per pixe
        sumphi = sum(abs(phi(:)));  %the following loop is for uniform the whole footprint area equals to 1
        if sumphi ~= 0
            phi = phi/sumphi;   %relative footprint function; %unit:total=1
        end
        %         phi = flipud(phi);
        
        %% Calculate Xdist: Farthest extent of the alongwind cumulative
        %%% 50,55,...90,95% footprint
        cumu_phi_nr = footcumsort(phi)*100;
        
        mpnt = ceil(size(cumu_phi_nr,2)/2);
        for j = 1:1:size(XCrit,2)
            %             Xind(i,j) = find(cumu_phi_nr(:,mpnt)<XCrit(1,j),1,'first');
            Xind(i,j) = find(cumu_phi_nr(:,mpnt)<XCrit(1,j),1,'last');
            Xdist(i,j) = y_y(Xind(i,j),1);
        end
        
        % Fetch available for each data point:
        ind_dir = find(abs(wd_polar_tmp-angles_out) == min(abs(wd_polar_tmp-angles_out)),1,'first');
        max_fetch(i,1) = dist_out(ind_dir);
        
        % along-wind maximum in-bounds footprint %:
        ind_rightdist = find(abs(max_fetch(i,1)-y_y(:,1)) == min(abs(max_fetch(i,1)-y_y(:,1))),1,'last');
        pct_in_fetch(i,1) = cumu_phi_nr(ind_rightdist,mpnt);
        
        %% Added by Jay - 06-Feb - Instead of rotating footprint, let's
        %%% rotate the site each time -- much easier and quicker:
        [xsite_rot ysite_rot] = pol2cart(angles_out-wd_polar_tmp+pi()/2,dist_out/2);
        xsite_rot = round(xsite_rot);
        ysite_rot = round(ysite_rot);
        x_min_site_rot = min(xsite_rot);
        y_min_site_rot = min(ysite_rot);
        xsite_off_rot = xsite_rot+abs(x_min_site_rot);
        ysite_off_rot = ysite_rot+abs(y_min_site_rot);
        gridsize_rot =  max(max(xsite_off_rot),max(ysite_off_rot));
        site_grid_rot = poly2mask(xsite_off_rot,ysite_off_rot,gridsize_rot,gridsize_rot);
        site_grid_rot = double(site_grid_rot);
        x_plot_rot = repmat((x_min_site_rot*2:2:x_min_site_rot*2+gridsize_rot*2-1),gridsize_rot,1);
        y_plot_rot = repmat((y_min_site_rot*2:2:y_min_site_rot*2+gridsize_rot*2-1)',1,gridsize_rot);
        
        %%% Trim site_grid_rot to remove any y < 0:
        ind_trim_grid = find(y_plot_rot(:,1)>=0);
        x_plot_rot = x_plot_rot(ind_trim_grid,:);
        y_plot_rot = y_plot_rot(ind_trim_grid,:);
        site_grid_rot = site_grid_rot(ind_trim_grid,:);
        
        %%% Trim phi,x_x and y_y to match the limits of
        % x_x = x(ones(1,N),:);
        % y_y = y(:,ones(1,M));
        %         x_x = round(x_x);
        %         y_y = round(y_y);
        %         y_y = flipud(y_y);
        ind_keep_xx = find(x_x(1,:)>=x_plot_rot(1,1) & x_x(1,:)<=x_plot_rot(1,end));
        ind_keep_yy = find(y_y(:,1)>=y_plot_rot(1,1) & y_y(:,1)<=y_plot_rot(end,1));
        xx_mask = x_x(ind_keep_yy,ind_keep_xx);
        yy_mask = y_y(ind_keep_yy,ind_keep_xx);
        cumu_phi_mask = cumu_phi_nr(ind_keep_yy,ind_keep_xx);
        phi_mask = phi(ind_keep_yy,ind_keep_xx);
        
        %%% Lay phi overtop of the site mask (0s and 1s to represent what
        %%% isn't and is inside the site bounds)
        inbounds_fp = site_grid_rot.*phi_mask; % total phi that in-bounds
        inbounds_prop(i,1) = sum(inbounds_fp(:)); % proportion of flux in-bounds
        clear inbounds_fp
        %%% Plot a couple figures for every datapoint we do:
        % Phi within the bounds:
        figure(f1); set(gcf,'visible','off')
         subplot(2,2,sp_ctr);
        pcolor(xx_mask,yy_mask,phi_mask);shading flat;hold on;
        colormap(flipud(gray));caxis([0 1e-5]);
        polar(angles_out-wd_polar_tmp+pi()/2,dist_out,'r-');hold on;
        title(['run = ' num2str(i) ', inb % = ' num2str(inbounds_prop(i,1))]);
        %%% parameter labels:
        text(min(xx_mask(:))+10, max(yy_mask(:))-50,{['pbar = ' num2str(inputs(i,1))], ['wdpolar = ' num2str(inputs(i,2))], ['u = ' num2str(inputs(i,3))],...
            ['Ta = ' num2str(inputs(i,4))], ['RH = ' num2str(inputs(i,5))], ['H = ' num2str(inputs(i,6))],...
            ['LE = ' num2str(inputs(i,7))], ['sigv = ' num2str(inputs(i,8))],['ust = ' num2str(inputs(i,9))], ['L = ' num2str(L(i,1))]},...
            'FontSize',6, 'VerticalAlignment','top');
        
        figure(f2); set(gcf,'visible','off')
        subplot(2,2,sp_ctr);
        contour(xx_mask,yy_mask,cumu_phi_mask,[50 70 80 90]);
        colormap(gray);hold on;caxis([50 110]);%colorbar;
        polar(angles_out-wd_polar_tmp+pi()/2,dist_out,'r-');hold on;
        title(['run = ' num2str(i) ', inb % = ' num2str(inbounds_prop(i,1))]);
        %%% Contour line labels:
        
        if Xdist(i,1) < max(yy_mask(:)); text(0,Xdist(i,1),'50'); end;
        if Xdist(i,5) < max(yy_mask(:)); text(0,Xdist(i,5),'70'); end;
        if Xdist(i,7) < max(yy_mask(:)); text(0,Xdist(i,7),'80'); end;
        if Xdist(i,9) < max(yy_mask(:)); text(0,Xdist(i,9),'90'); end;
        %%% parameter labels:
        text(min(xx_mask(:))+10, max(yy_mask(:))-50,{['pbar = ' num2str(inputs(i,1))], ['wdpolar = ' num2str(inputs(i,2))], ['u = ' num2str(inputs(i,3))],...
            ['Ta = ' num2str(inputs(i,4))], ['RH = ' num2str(inputs(i,5))], ['H = ' num2str(inputs(i,6))],...
            ['LE = ' num2str(inputs(i,7))], ['sigv = ' num2str(inputs(i,8))],['ust = ' num2str(inputs(i,9))], ['L = ' num2str(L(i,1))]},...
            'FontSize',6, 'VerticalAlignment','top');
        
        sp_ctr = sp_ctr + 1;
        
        if sp_ctr == 5;
            figure(f1);set(gcf,'visible','off')
            print('-dpng',['/home/brodeujj/Matlab/Data/KM_footprint_test/JJBtest1-figs/fp_run_' num2str(i-3) '-' num2str(i)])
            clf;
            figure(f2);set(gcf,'visible','off')
            print('-dpng',['/home/brodeujj/Matlab/Data/KM_footprint_test/JJBtest1-figs/cumfp_run_' num2str(i-3) '-' num2str(i)])
            clf;
            sp_ctr = 1;
        end
        
    catch
        disp(['Error running data point ' num2str(i) '.']);
    end
    t_out = toc;
    disp(['Done point ' num2str(i) ', Time = ' num2str(t_out)]);
end

% save([output_path 'Xind_2010.mat'],'Xind');
% save([output_path 'Xdist_2010.mat'],'Xdist');
% save([output_path 'inbounds_p.mat'],'inbounds_prop');
out.Xind = Xind;
out.Xdist = Xdist;
out.input = inputs;
out.input_labels = {'p_bar', 'wd_polar', 'u', 'T_a', 'RH', 'H', 'LE', 'sig_v','ust'};
out.inbounds_p = inbounds_prop;
out.max_fetch = max_fetch;
out.pct_in_fetch = pct_in_fetch;
out.L = L;
out.Lstar = Lstar;
out.ust_pred = ust_pred;
save([output_path 'KMtest1_' num2str(year) '_results.mat'],'out');
end