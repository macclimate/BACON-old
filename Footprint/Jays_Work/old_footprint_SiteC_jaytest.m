%***********************************************************************
%The trees are 25 m tall.
%I would suggest for daytime sensible heat flux (H) of 300 W m-2,
%wind speed (u) of 2.5 m s-1 (ustar = 0.4 m s-1), air temperature (Ta) 23 C and relative humidity (RH) of 50%.
%For nighttime, H = -30 W m-2, u = 0.5 m s-1 (ustar = 0.1 m s-1), Ta = 13 C and RH = 60%.
%My quick rough calculation of L is for daytime -20 and for nighttime 3.
%measurement heights (zm) of 2, 4, 6  and 8 m above the tops of the trees?
%putting the tower on the east side of the southern 'operator select' area.
%assumig preveiling wind direction is 315 degree
%This leaves only about 250 m of fetch

%By Baozhang Chen
%
%May 27, 2009
%***********************************************************************

function footprint_SiteC_jaytest

%%% Load data
% input_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Input/';
% output_path = '/home/brodeujj/Matlab/Data/KM_footprint_test/Output/';
% input_path = '/1/fielddata/Matlab/Data/KM_footprint_test/Input/';
output_path = '/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/';


TP39_master = load(['/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master_2010.mat']);
TP39_CPEC = load(['/1/fielddata/Matlab/Data/Flux/CPEC/TP39/Final_Cleaned/TP39_CPEC_cleaned_2010.mat']);
TP39_CPEC.master.labels = cellstr(TP39_CPEC.master.labels);
%%% Site parameters:
[heights] = params(2010, 'TP39', 'Heights');
h_c = heights(2);
z_m = heights(1);
z_0 = .1*h_c; %10% of h_c
d = 0.67*h_c;

%%% Site Variables:
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
% function this time is for getting the size of retated matrix in order to
[B,TransferF] = footprint_rotate(x_x,y_y,x_x,0);%   this is the reference point for rotation B(6,6)=99

     x_x = round(x_x);
     y_y = round(y_y);
     y_y = flipud(y_y);

%% Set up Site Grid:
XCrit = (50:5:95);
Xind = NaN.*ones(size(u,1),size(XCrit,2));
Xdist =NaN.*ones(size(u,1),size(XCrit,2));
inbounds_prop = NaN.*ones(size(u,1),1);
max_fetch = NaN.*ones(size(u,1),1);
pct_in_fetch = NaN.*ones(size(u,1),1);

[fetch] = params(2009,'TP39', 'Fetch');
[angles_out dist_out] = fetchdist(fetch);


%% hhour by hhour calculations:
ind_data = prod([u wd p_bar T_a RH H LE sig_v ust],2);
L = NaN.*ones(length(ind_data),1);
ust_pred = NaN.*ones(length(ind_data),1);
fig_ctr = 1;
for i = 1:1:17520
    if ~isnan(ind_data(i,1))
        try
            tic;
        [ust_pred(i,1),L(i,1)] = calc_ustar_L(h_c, z_m, u(i,1), T_a(i,1), RH(i,1), p_bar(i,1), H(i,1), LE(i,1));
        %%% Footprint Calculation
        [phi,f,D_y,xs,ys,param] = footprint_kormann_and_meixner_bob(z_0,z_m,u(i,1),ust(i,1),sig_v(i,1),L(i,1),y_max,x_max,pix);
        
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
        ind_dir = find(abs(wd_polar(i,1)-angles_out) == min(abs(wd_polar(i,1)-angles_out)));
        max_fetch(i,1) = dist_out(ind_dir);
        
        % along-wind maximum in-bounds footprint %:
        ind_rightdist = find(abs(max_fetch(i,1)-y_y(:,1)) == min(abs(max_fetch(i,1)-y_y(:,1))));
        pct_in_fetch(i,1) = cumu_phi_nr(ind_rightdist,mpnt);
        
        %% Added by Jay - 06-Feb - Instead of rotating footprint, let's
        %%% rotate the site each time -- much easier and quicker:
        
        [xsite_rot ysite_rot] = pol2cart(angles_out-wd_polar(i,1)+pi()/2,dist_out/2);
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
        
        %%% Plot a couple figures for every 10th datapoint we do:
        if fig_ctr ==10
            timetag = [create_label(Mon(i,1),2) create_label(Day(i,1),2) create_label(HH(i,1),2) create_label(MM(i,1),2)];
            % Phi within the bounds:
            figure(1); clf; pcolor(xx_mask,yy_mask,phi_mask);shading flat;hold on;
            colormap(flipud(gray));caxis([0 1e-5]);
            polar(angles_out-wd_polar(i,1)+pi()/2,dist_out,'r-');hold on;
            print('-dpng',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/fp'  timetag '_dp' num2str(i)])
            
            figure(2); clf; contour(xx_mask,yy_mask,cumu_phi_mask,[50 70 80 90]);
            colormap(gray);hold on;caxis([50 110]);%colorbar;
            polar(angles_out-wd_polar(i,1)+pi()/2,dist_out,'r-');hold on;
            text(0,Xdist(i,1),'50');
            text(0,Xdist(i,5),'70');
            text(0,Xdist(i,7),'80');
            text(0,Xdist(i,9),'90');
            print('-dpng',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/cumfp'  timetag '_dp' num2str(i)])
            
            fig_ctr = 1;
        else
            fig_ctr = fig_ctr + 1;
        end
      
        
        catch
            disp(['Error running data point ' num2str(i) '.']);
        end
        t_out = toc;
        disp(['Done point ' num2str(i) 'Time = ' num2str(t_out)]);
    end
end

% save([output_path 'Xind_2010.mat'],'Xind');
% save([output_path 'Xdist_2010.mat'],'Xdist');
% save([output_path 'inbounds_p.mat'],'inbounds_prop');
 out.Xind = Xind;
       out.Xdist = Xdist;
       out.inbounds_p = inbounds_prop;
       out.max_fetch = max_fetch;
       out.pct_in_fetch = pct_in_fetch;
        
       save([output_path 'KM_TP39_2010_results.mat'],'out');
end
%{
       
% % %         polar(angles_out,dist_out)
% %
% % % %%% Make a grid that is larger than outline, and 1m
% % % [xsite ysite] = pol2cart(angles_out,dist_out);
% % % xsite = round(xsite);
% % % ysite = round(ysite);
% % %%% Make a grid that is larger than outline, and 2m
% % [xsite ysite] = pol2cart(angles_out,dist_out/2);
% % xsite = round(xsite);
% % ysite = round(ysite);
% %
% % % shift the x and y values by the min x and y (origin is also at these two
% % % points):
% % x_min_site = min(xsite);
% % % x_max_site = max(xsite);
% % y_min_site = min(ysite);
% % % y_max_site = max(ysite);
% % xsite_off = xsite+abs(x_min_site);
% % ysite_off = ysite+abs(y_min_site);
% % gridsize =  max(max(xsite_off),max(ysite_off));
% % site_grid = poly2mask(xsite_off,ysite_off,gridsize,gridsize);
% % site_grid = double(site_grid);
% % %%% This is for a grid spacing of 1m:
% % %         x_plot = repmat((x_min_site:1:x_min_site+gridsize-1),gridsize,1);
% % % y_plot = repmat((y_min_site:1:y_min_site+gridsize-1)',1,gridsize);
% % %%% This is for a grid spacing of 2m:
% % x_plot = repmat((x_min_site*2:2:x_min_site*2+gridsize*2-1),gridsize,1);
% % y_plot =
% repmat((y_min_site*2:2:y_min_site*2+gridsize*2-1)',1,gridsize);


       figure(6);clf; pcolor(xx_mask,yy_mask,inbounds_fp);shading flat;hold on;colormap(flipud(gray));hold on;
       polar(angles_out-wd1_r+pi()/2,dist_out,'r-');hold on;


        
        %% Footprint Rotation
        % Rotate the matix of phi using new retating fuction
        % with wind direction of alpha_rot_dgr = wd_cur:
        alpha_rot_dgr = wd(i,1);
        % Rotate input matrix within a 1.5 times larger matrix
        [phi_rot,TransferF] = footprint_rotate(x_x,y_y,phi,alpha_rot_dgr); % call rotating function: this is the reference point for rotation B(6,6)=99
        
        cumu_phi = footcumsort(phi_rot)*100;
        %    save (fullfile (path_out,['Zm=',int2str(z_m), '=', int2str(H)]),'cumu_phi', '-v6');

        Ax = TransferF.Ax;
        Bx = TransferF.Bx;
        x_off = TransferF.x_offset;
        [n2,m2] = size(cumu_phi);
        x_l = linspace(-pix*(TransferF.Bx+TransferF.x_offset-1),pix*(TransferF.Bx+TransferF.x_offset-1),m2);
        x_l = x_l(ones(1,n2),:);
        y_l = linspace(pix*(TransferF.By+TransferF.y_offset-1),-pix*(TransferF.By+TransferF.y_offset-1),n2)';
        y_l = y_l(:,ones(1,m2));
        
        %% Trim the cumu_phi variable and x_l and y_l to match our site?
        x_l = round(x_l);
        y_l = round(y_l);
        ind_keep_xl = find(x_l(1,:)>=x_plot(1,1) & x_l(1,:)<=x_plot(1,end));
        ind_keep_yl = find(y_l(:,1)>=y_plot(1,1) & y_l(:,1)<=y_plot(end,1));
        xl_mask = x_l(ind_keep_yl,ind_keep_xl);
        yl_mask = y_l(ind_keep_yl,ind_keep_xl);
        cumu_phi_mask = cumu_phi(ind_keep_yl,ind_keep_xl);
        phi_rot_mask = phi_rot(ind_keep_yl,ind_keep_xl);
        
        inbounds_fp = site_grid.*phi_rot_mask;
        inbounds_prop(i,1) = sum(sum(inbounds_fp,1),2);
        
        
        %         figure(1);clf;pcolor(x_plot,y_plot,site_grid);shading flat; hold on; plot(0,0,'ro')
        %         hold on;
        %         figure(2);clf;
        %         C = contourc(cumu_phi, [90 90]);
        %         figure(3);clf;
        %         patch(C(1,2:end),C(2,2:end),'r')
        % %         fp_mask = poly2mask(
        
        %         [C h] = contour(x_l, y_l, cumu_phi, 90);
        if fig_ctr ==10
            timetag = [num2str(Mon(i,1)) num2str(Day(i,1)) num2str(HH(i,1)) num2str(MM(i,1))];
        figure(1);clf;pcolor(xl_mask, yl_mask, phi_rot_mask);shading flat; hold on;
        caxis([0 0.1e-4]);colormap(flipud(gray));
        polar(angles_out,dist_out);
        polar([wd_polar(i,1),wd_polar(i,1)],[0, Xdist(i,XCrit(1,:)==90)],'w--')
        polar(wd_polar(i,1),Xdist(i,XCrit(1,:)==90),'ko')
        print('-dpng',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/fp'  timetag '_dp' num2str(i)])
%         print('-deps',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/fp2010_dp' num2str(i)])
%         print('-dbmpmono',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/fp2010_dp' num2str(i)])
        
        figure(2);clf;pcolor(xl_mask, yl_mask, cumu_phi_mask);shading flat; hold on;
        caxis([70 100]); colormap(gray);colorbar;
        polar(angles_out,dist_out);
                polar([wd_polar(i,1),wd_polar(i,1)],[0, Xdist(i,XCrit(1,:)==90)],'w--')
        polar(wd_polar(i,1),Xdist(i,XCrit(1,:)==90),'ko')
        print('-dpng',['/1/fielddata/Matlab/Data/Flux/Footprint/KM_footprint_test/figs/cumfp'  timetag '_dp' num2str(i)])

        fig_ctr = 1;
        else
            fig_ctr = fig_ctr + 1;
        end
        
%         plot(-1.*Xdist(i,XCrit(1,:)==90),0,'ko','MarkerFaceColor','w')
    end
end
save([output_path 'Xind_2010.mat'],'Xind');
save([output_path 'Xdist_2010.mat'],'Xdist');
save([output_path 'inbounds_p.mat'],'inbounds_prop');

%         Xind = NaN.*ones(size(u,1),size(XCrit,2));
% Xdist =NaN.*ones(size(u,1),size(XCrit,2));
% inbounds_prop = NaN.*ones(size(u,1),1);
        %% Commented
        
        %bob_fig_ini(['u=',int2str(u), 'H=', int2str(H)],100/70);
        % fig=0;
        % fig=fig+1;
%         figure();
%         [Cd,hd] = contour(x_l, y_l, cumu_phi, [50,80,90]);
%
%         %    [Cd,hd] = contour(x_l,y_l,filtfilt(fir1(20,1e-2,'low'),1,cumu_phi),[10,20,40,60,70,80,90,95,99]);
%         %colorbar;
%         %clabel(Cd,hd,'manual')
%         xlim([-400 400]);ylim([-200 200])
%         clabel(cd,hd,'fontsize',8,'color','r','rotation',0)
%         hold on
%         h=line(0,0,...
%             'marker','+','markeredgecolor','r','markerfacecolor','r');
%         set(1,'name','pcolor','numbertitle','off')
%         ylabel('Distance from tower S-N (m)','fontsize',12,'color','k' );
%         xlabel('Distance from tower W-E (m)','fontsize',12,'color','k');
%         set(gca,'FontSize',10)
%         set(gca,'DefaultTextFontName','Arial')
%         reg_line_str = sprintf('H = %3.3g \nLE = %3.3g',H,LE);
%         text(-270,8,reg_line_str);
%         %view(-90,90);
%         %set(gca,'ydir','rev')
%         %    pathfig = [path_out ['Zm=',int2str(z_m), 'H=', int2str(H)]];
%         %    print('-depsc',parthfig);
%         %    save (path_out,['u=',int2str(u), 'H=', int2str(H)]);
%         hold off
%
        %        figure(2);
        %        pcolor(x_l,y_l,log10(abs(phi_rot)));
        %        caxis([-5 0]);
        %        colormap jet;
        %        shading flat;
        %        colorbar;
        %       h=line(0,0,...
        %            'marker','+','markeredgecolor','w','markerfacecolor','w');
        %        ylabel('Distance from tower S-N (m)');
        %        xlabel('Distance from tower W-E (m)');
        %        text(3100, -3100,'log(\phi)','FontSize',18);
        %        hold off;
        %        %hgsave (fullfile (path_out,[SiteId, yrId '_purefp']), '-v6');
        %       %figtitle_yrd = [SiteId, yrId '_purefp'];
        %       %pathfig_out_yrd = [path_out figtitle_yrd];
        %      % hgsave (pathfig_out_yrd);
        %      % print('-djpeg', pathfig_out_yrd);
        
        %% Commented stuff:
        %%%%%%%%% Site C parameters %%%%%%%%%%%%%%%%%%%%%
        
        % h_c = 3; %canopy height in meter
        % z_m = 6; %EC sensor height in meter
        % z_0 = .1*h_c; %10% of h_c
        % d = 0.67*h_c;
        % p_bar = 98;
        
        %daytime
        % u = 3; %in m/s_a
        % wd = 90; %in degree
        % T_a = 23; %air temperature at z_m in oC
        % RH = 50;  %air relative humidity at z_m in %
        % H = 100;  % sensible heat flux in w/m^2
        % LE = 400; %latent heat flux in w/m^2
        % sig_v = 0.5*u;
        % % nighttime
        % u = 1.5; %in m/s_a
        % wd = 70; %in degree
        % T_a = 13; %air temperature at z_m in oC
        % RH = 80;  %air relative humidity at z_m in %
        % H = -3;  % sensible heat flux in w/m^2
        % LE = 0; %latent heat flux in w/m^2
        % sig_v = 0.1*u; %first assumption
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}