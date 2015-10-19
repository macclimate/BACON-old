function [output] = OPEC_Rotations(covs)
% covs must be in a specific arrangement:
% col 1 - x
% col 2 - y
% col 3 - z
% col 4 - xx
% col 5 - yy
% col 6 - zz
% col 7 - xy
% col 8 - xz
% col 9 - yz
% col 10 - xc
% col 11 - yc
% col 12 - zc
%%% 
% out columns are as follows:
%col 1 - u
% col 2 - v
% col 3 - w
% col 4 - uu
% col 5 - vv
% col 6 - ww
% col 7 - uv
% col 8 - uw
% col 9 - vw
% col 10 - uc
% col 11 - vc
% col 12 - wc

x = covs(:,1); y = covs(:,2); z = covs(:,3); xx = covs(:,4); yy = covs(:,5); zz = covs(:,6);
xy = covs(:,7); xz = covs(:,8); yz = covs(:,9); xc = covs(:,10); yc = covs(:,11); zc = covs(:,12);

% eta is horizontal angle between mean wind and sonic axis
eta = atan(y./x);
ind = find(y>0&x<0);
eta(ind) = eta(ind) + pi;
ind = find(y<0&x<0);
eta(ind) = eta(ind) - pi;

% theta is angle between mean wind and horizontal sonic plane.
theta = atan(z./sqrt(x.^2 + y.^2));

%% All the wind rotations straight from the Tanner/Thurtell manual
u = x.*cos(theta).*cos(eta) + y.*cos(theta).*sin(eta) + z.*sin(theta);
v = y.*cos(eta) - x.*sin(eta);
w = z.*cos(theta) - x.*sin(theta).*cos(eta) - y.*sin(theta).*sin(eta);

uu = xx.*cos(theta).^2.*cos(eta).^2 +...
        yy.*cos(theta).^2.*sin(eta).^2 + zz.*sin(theta).^2 +...
        2*xy.*cos(theta).^2.*cos(eta).*sin(eta) +...
        2*xz.*cos(theta).*sin(theta).*cos(eta) +...
        2*yz.*cos(theta).*sin(theta).*sin(eta);
vv = yy.*cos(eta).^2 + xx.*sin(eta).^2 -...
        2*xy.*cos(eta).*sin(eta);
ww = zz.*cos(theta).^2 + xx.*sin(theta).^2.*cos(eta).^2 + ...
        yy.*sin(theta).^2.*sin(eta).^2 - ...
        2*xz.*cos(theta).*sin(theta).*cos(eta) - ...
        2*yz.*cos(theta).*sin(theta).*sin(eta) + ...
        2*xy.*sin(theta).^2.*cos(eta).*sin(eta);

uw = xz.*cos(eta).*(cos(theta).^2 - sin(theta).^2) -...
      2*xy.*cos(theta).*sin(theta).*cos(eta).*sin(eta) +...
      yz.*sin(eta).*(cos(theta).^2 - sin(theta).^2) -...
      xx.*cos(theta).*sin(theta).*cos(eta).^2 -...
      yy.*cos(theta).*sin(theta).*sin(eta).^2 +...
      zz.*cos(theta).*sin(theta);
uv = xy.*cos(theta).*(cos(eta).^2 - sin(eta).^2) +...
      yz.*sin(theta).*cos(eta) - xz.*sin(theta).*sin(eta) -...
      xx.*cos(theta).*cos(eta).*sin(eta) +...
      yy.*cos(theta).*cos(eta).*sin(eta);
vw = yz.*cos(theta).*cos(eta) - xz.*cos(theta).*sin(eta) -...
      xy.*sin(theta).*(cos(eta).^2-sin(eta).^2) +...
      xx.*sin(theta).*cos(eta).*sin(eta) -...
      yy.*sin(theta).*cos(eta).*sin(eta);

phi = (1/2)*atan( (2*vw)./(vv - ww));

uw = uw.*cos(phi) - uv.*sin(phi);
uv = uv.*cos(phi) + uw.*sin(phi);
vw = vw.*(cos(phi).^2 - sin(phi).^2) + ww.*cos(phi).*sin(phi) - ...
     vv.*cos(phi).*sin(phi);
 
%% Correcting for Scalar Flux:
uc = xc.*cos(theta).*cos(eta) + yc.*cos(theta).*sin(eta) + zc.*sin(theta);
vc = yc.*cos(eta) - xc.*sin(eta);
wc = zc.*cos(theta) - xc.*sin(theta).*cos(eta) - yc.*sin(theta).*sin(eta);

wc = wc.*cos(phi) - vc.*sin(phi);

%% Output:

output = [u v w uu vv ww uv uw vw uc vc wc];

%col 1 - u
% col 2 - v
% col 3 - w
% col 4 - uu
% col 5 - vv
% col 6 - ww
% col 7 - uv
% col 8 - uw
% col 9 - vw
% col 10 - uc
% col 11 - vc
% col 12 - wc