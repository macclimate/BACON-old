function [angles_out dist_out] = fetchdist(angles_in, plot_flag)

if nargin == 1;
    plot_flag = 'off';
end
%%% This function converts a set of sector angle and length designations
%%% with a degree-by-degree output of angle and length designations.  Used
%%% in footprint work, when site layout information is given as sector
%%% information.

%%% input is form of [sector start angle|sector end angle|sector start distance|sector end distance]

% angles_in = fetch; % used for testing only.
angles_in(:,1:2) = deg2rad(angles_in(:,1:2)); % convert to radians
angles_in(:,1:2) = angles_in(:,1:2)+ pi()./2; % rotate so 0 is at East
angles_in(angles_in(:,1)>=2*pi(),1) = angles_in(angles_in(:,1)>=2*pi(),1) -2*pi();  % correct to make East = 0;
angles_in(angles_in(:,2)>2*pi(),2) = angles_in(angles_in(:,2)>2*pi(),2) -2*pi();    % correct to make East = 0;

% incr = pi()/180; % one degree in radians
% incr_angles = (min(angles_in(:,1)):incr:max(angles_in(:,2)))';

% Convert from polar coordinates to cartesian
[x_st y_st] = pol2cart(angles_in(:,1),angles_in(:,3));
[x_end y_end] = pol2cart(angles_in(:,2),angles_in(:,4));

% figure(1);clf
% % polar(angles_in(:,1)+90,500.*ones(length(angles_in),1),'r.')
% 
% for i = 1:1:length(fetch)
%     polar([angles_in(i,1) angles_in(i,1)],[0 angles_in(i,3)]); hold on;
%     polar([angles_in(i,2) angles_in(i,2)],[0 angles_in(i,4)])
% polar([angles_in(i,1) angles_in(i,2)],[angles_in(i,3) angles_in(i,4)])
% end
% rlim = 500;axis([-1 1 -1 1]*rlim); % Sets the limits for the graph:
% 
% polar(angles_in(:,1),angles_in(:,3),'ro'); hold on;
% polar(angles_in(:,2),angles_in(:,4),'b.')

%%% Main loop - calculates distance from origin for 100 points in between
%%% each starting and ending point:
final_xy = [];
for j = 1:1:length(x_st)
    drun = x_end(j) - x_st(j);
    drise = y_end(j) - y_st(j);
    % make a total of 100 pts in between these:
    run_incr = drun/100;
    rise_incr = drise/100;
    x_list = x_st(j):run_incr:x_end(j);
    y_list = y_st(j):rise_incr:y_end(j);
    
    final_xy = [final_xy ; [x_list' y_list']];
    
   clear x_list y_list run_incr rise_incr drun drise; 
end
%%% Final conversion back to polar:
[angles_out dist_out] = cart2pol(final_xy(:,1),final_xy(:,2));
%%% Make the scale from 0 to 2pi, instead of -pi to +pi:
angles_out(angles_out < 0) = angles_out(angles_out < 0) + 2.*pi();
if strcmp(plot_flag,'on')==1
figure(2);clf;
plot(x_st,y_st,'ro');hold on;
plot(x_end,y_end,'b.'); 
plot(final_xy(:,1),final_xy(:,2),'g.')
polar(angles_out, dist_out,'m-');
title('Outline of study area for site');
legend('starting points', 'ending points', 'xy-points', 'polar points',3);
end