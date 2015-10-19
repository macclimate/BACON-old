function KM_footprint_JJBtest4
%%% Load data
% input_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Input/';
% output_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Output/';
% input_path = '/1/fielddata/Matlab/Data/KM_footprint_test/Input/';
% ls = '/home/brodeujj/';
% output_path = '/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/';
output_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test/'];
fig_path = ['/home/brodeujj/Matlab/Data/KM_footprint_test/JJBtest4-figs/'];
jjb_check_dirs(fig_path);

year = 2010;
TP39_master = load(['/home/brodeujj/Matlab/Data/Master_Files/TP39/TP39_data_master_' num2str(year) '.mat']);
TP39_CPEC = load(['/home/brodeujj/Matlab/Data/KM_footprint_test/Input/TP39_CPEC_cleaned_' num2str(year) '.mat']);
TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
p_bar = TP39_master.master.data(:,120);
wd = TP39_master.master.data(:,67);
u =  TP39_master.master.data(:,119);
T_a =  TP39_master.master.data(:,116);
RH =  TP39_master.master.data(:,117);
H =  TP39_master.master.data(:,10);
LE =  TP39_master.master.data(:,9);
sig_v = TP39_CPEC.master.data(:,24);
ust = TP39_master.master.data(:,11);
wd_polar = CSWind2Polar(wd);
Mon = TP39_master.master.data(:,2);
Day = TP39_master.master.data(:,3);
HH = TP39_master.master.data(:,4);
MM = TP39_master.master.data(:,5);

%%% Site parameters:
% [heights] = params(year, 'TP39', 'Heights');
h_c = [24.2; 8; 1];
z_m = [28; 12; 4];
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;
height_tags = {'tall';'med';'short'};
%%% Site Variables:
%%% Variables to vary: wd, u, Ta, RH, LE, sig_v ust
ind_1 = 9954; %10230;
ind_3 = 10595;
ind_2 = 9955;%10279;
ind_4 = 10016;

inputs(1,:) = [p_bar(ind_1) pi() u(ind_1) T_a(ind_1) RH(ind_1) H(ind_1) LE(ind_1) sig_v(ind_1) ust(ind_1)];
inputs(2,:) = [p_bar(ind_2) pi() u(ind_2) T_a(ind_2) RH(ind_2) H(ind_2) LE(ind_2) sig_v(ind_2) ust(ind_2)];
inputs(3,:) = [p_bar(ind_3) pi() u(ind_3) T_a(ind_3) RH(ind_3) H(ind_3) LE(ind_3) sig_v(ind_3) ust(ind_3)];
inputs(4,:) = [p_bar(ind_4) pi() u(ind_4) T_a(ind_4) RH(ind_4) H(ind_4) LE(ind_4) sig_v(ind_4) ust(ind_4)];

stab_tags = {'ex1';'ex2';'ex3';'ex4'};
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
f1 = figure('visible','off');
f2 = figure('visible','off');
inputs(1:size(inputs,1),10) = NaN;
m_tags = {'ust-pred';'ust'};
for m = 1:1:2
    for k = 1:1:length(h_c) % 3 heights
        h_c_tmp = h_c(k,1);
        z_m_tmp = z_m(k,1);
        z_0_tmp = z_0(k,1);
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
                [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c_tmp, z_m_tmp, u_tmp, T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
                inputs(i,10) = ust_pred(i,1);
                Lstar(i,1) = calc_monin_obhukov_L(ust_tmp,T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
                
                switch m
                    case 1
                        [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0_tmp,z_m_tmp,u_tmp,ust_pred(i,1),sig_v_tmp,L(i,1),y_max,x_max,pix);
                    case 2
                        [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0_tmp,z_m_tmp,u_tmp,ust_tmp,sig_v_tmp,Lstar(i,1),y_max,x_max,pix);
                end
                %         [ust_pred2(i,1),L2(i,1)] = calc_ustar_L(h_c, z_m, u_tmp, T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp,ust_tmp);
                
                
                %        Lstar(i,1) = calc_monin_obhukov_L(ust_tmp,T_a_tmp, RH_tmp, p_bar_tmp, H_tmp, LE_tmp);
                
                %%% Footprint Calculation
                %         [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0_tmp,z_m_tmp,u_tmp,ust_tmp,sig_v_tmp,Lstar(i,1),y_max,x_max,pix);
                %         [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0_tmp,z_m_tmp,u_tmp,ust_pred(i,1),sig_v_tmp,L(i,1),y_max,x_max,pix);
                %         phi = real(phi);phi(isnan(phi))=0;
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
                title([height_tags{k,1} ', ' stab_tags{i,1} ', inb % = ' num2str(inbounds_prop(i,1))]);
                %%% parameter labels:
                text(min(xx_mask(:))+10, max(yy_mask(:))-50,{['pbar = ' num2str(inputs(i,1))], ['wdpolar = ' num2str(inputs(i,2))], ['u = ' num2str(inputs(i,3))],...
                    ['Ta = ' num2str(inputs(i,4))], ['RH = ' num2str(inputs(i,5))], ['H = ' num2str(inputs(i,6))],...
                    ['LE = ' num2str(inputs(i,7))], ['sigv = ' num2str(inputs(i,8))],['ust = ' num2str(inputs(i,9))],['ust-pred = ' num2str(inputs(i,10))],...
                    ['L = ' num2str(L(i,1))],['L* = ' num2str(Lstar(i,1))],['z_m* = ' num2str(z_m_tmp)],['h_c* = ' num2str(h_c_tmp)]},...
                    'FontSize',6, 'VerticalAlignment','top');
                
                figure(f2); set(gcf,'visible','off')
                subplot(2,2,sp_ctr);
                contour(xx_mask,yy_mask,cumu_phi_mask,[50 70 80 90]);
                colormap(gray);hold on;caxis([50 110]);%colorbar;
                polar(angles_out-wd_polar_tmp+pi()/2,dist_out,'r-');hold on;
                title([height_tags{k,1} ', ' stab_tags{i,1} ', inb % = ' num2str(inbounds_prop(i,1))]);
                %%% Contour line labels:
                
                if Xdist(i,1) < max(yy_mask(:)); text(0,Xdist(i,1),'50'); end;
                if Xdist(i,5) < max(yy_mask(:)); text(0,Xdist(i,5),'70'); end;
                if Xdist(i,7) < max(yy_mask(:)); text(0,Xdist(i,7),'80'); end;
                if Xdist(i,9) < max(yy_mask(:)); text(0,Xdist(i,9),'90'); end;
                %%% parameter labels:
                text(min(xx_mask(:))+10, max(yy_mask(:))-50,{['pbar = ' num2str(inputs(i,1))], ['wdpolar = ' num2str(inputs(i,2))], ['u = ' num2str(inputs(i,3))],...
                    ['Ta = ' num2str(inputs(i,4))], ['RH = ' num2str(inputs(i,5))], ['H = ' num2str(inputs(i,6))],...
                    ['LE = ' num2str(inputs(i,7))], ['sigv = ' num2str(inputs(i,8))],['ust = ' num2str(inputs(i,9))],['ust-pred = ' num2str(inputs(i,10))],...
                    ['L = ' num2str(L(i,1))],['L* = ' num2str(Lstar(i,1))],['z_m* = ' num2str(z_m_tmp)],['h_c* = ' num2str(h_c_tmp)]},...
                    'FontSize',6, 'VerticalAlignment','top');
                
                sp_ctr = sp_ctr + 1;
                
                if sp_ctr == 5;
                    figure(f1);set(gcf,'visible','off')
                    print('-dpng',[fig_path 'fp_' height_tags{k,1} '_method_' m_tags{m,1}])
                    clf;
                    figure(f2);set(gcf,'visible','off')
                    print('-dpng',[fig_path 'cumfp_' height_tags{k,1} '_method_' m_tags{m,1}])
                    clf;
                    sp_ctr = 1;
                end
                
            catch
                disp(['Error running data point ' num2str(i) '.']);
            end
            t_out = toc;
            disp(['Done point ' num2str(i) ', Time = ' num2str(t_out)]);
        end
    end
end
% save([output_path 'Xind_2010.mat'],'Xind');
% save([output_path 'Xdist_2010.mat'],'Xdist');
% save([output_path 'inbounds_p.mat'],'inbounds_prop');
out.Xind = Xind;
out.Xdist = Xdist;
out.input = inputs;
out.input_labels = {'p_bar', 'wd_polar', 'u', 'T_a', 'RH', 'H', 'LE', 'sig_v','ust','ust_pred'};
out.inbounds_p = inbounds_prop;
out.max_fetch = max_fetch;
out.pct_in_fetch = pct_in_fetch;
out.L = L;
% out.Lstar = Lstar;
% out.ust_pred = ust_pred;
save([output_path 'KMtest4_' num2str(year) '_results.mat'],'out');
end