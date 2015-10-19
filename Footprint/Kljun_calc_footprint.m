function [xr,xmax,x,f]=Kljun_calc_footprint(zm,znot,h,sigmaw,ustar,r)

% Derive a footprint estimate based on a simple parameterisation
% [xr,xmax,x,f]=calc_footprint(zm,znot,h,sigmaw,ustar,r)
%
% Details see Kljun, N., Calanca, P., Rotach, M.W., Schmid, H.P., 2004:
% Boundary-Layer Meteorology 112, 503-532.
%
% online version: http://footprint.kljun.net
% contact: n.kljun@swansea.ac.uk
%
% Restriction:
% -200 <= zm/L <= 1
% u* >= 0.2 m s-1
% zm >  1   m
% r  <  90  %
%
% Model Input for Initialisation of Footprint Parameterisation
%    zm        = Measurement height [m]
%    znot      = Roughness length [m]
%    h         = Boundary layer height [m]
%    sigmaw    = sigmaw [m s-1]
%    ustar     = u* [m s-1]
%    r         = Percentage to be included [%]
%
%
% Output:
% xr - The upwind distance from the receptor at which the specified r% of
% flux is contained within
% xmax - The upwind distance from which the LARGEST proportion of flux
% originates
% x - Upwind distances (m) from receptor
% f - fraction of flux originating from corresponding x value
%
% created: 30 March 2005 natascha kljun
% last change: 30 March 2005 nk

% Output results on screen (1=yes)
xout = 0;
% Output values outside limits (1=yes)
limitout = 0;

%--------------------------------------------------------------------
% Check input variables

if limitout == 1;
    if sigmaw < 0
        display('sigmaw needs to be larger than 0')
        xr   = NaN;
        xmax = NaN;
        return
    elseif ustar < 0.2
        display('u* needs to be larger than 0.2 m s-1')
        xr   = NaN;
        xmax = NaN;
        return
    elseif zm < 1
        display('zm needs to be larger than 1 m')
        xr   = NaN;
        xmax = NaN;
        return
    elseif h < 1
        display('h needs to be larger than 1 m')
        xr   = NaN;
        xmax = NaN;
        return
    elseif h < zm
        display('zm needs to be smaller than h')
        xr   = NaN;
        xmax = NaN;
        return
    elseif znot < 0
        display('znot needs to be larger than 0')
        xr   = NaN;
        xmax = NaN;
        return
    elseif r > 96
        display('r needs to be smaller than 96')
        xr   = NaN;
        xmax = NaN;
        return
    end %if
else
    if sigmaw < 0
        xr   = NaN;
        xmax = NaN;
        return
    elseif ustar < 0.2
        xr   = NaN;
        xmax = NaN;
        return
    elseif zm < 1
        xr   = NaN;
        xmax = NaN;
    elseif h < 1
        xr   = NaN;
        xmax = NaN;
        return
    elseif h < zm
        xr   = NaN;
        xmax = NaN;
        return
    elseif znot < 0
        xr   = NaN;
        xmax = NaN;
        return
    elseif r > 96
        xr   = NaN;
        xmax = NaN;
        return
    end %if
end

%--------------------------------------------------------------------
% Initialize variables

n     = 206;
nr    = 96;
xstar = zeros(n,1);
fstar = zeros(n,1);
x     = zeros(n,1);
f     = zeros(n,1);

af = 0.175;
bb = 3.418;
ac = 4.277;
ad = 1.685;
b  = 3.69895;

a = (af/(bb-log(znot)));
c = (ac*(bb-log(znot)));
d = (ad*(bb-log(znot)));

lall = [0.000000 0.302000 0.368000 0.414000 0.450000 0.482000 0.510000 0.536000 ...
    0.560000 0.579999 0.601999 0.621999 0.639999 0.657998 0.675998 0.691998 ...
    0.709998 0.725998 0.741997 0.755997 0.771997 0.785997 0.801997 0.815996 ...
    0.829996 0.843996 0.857996 0.871996 0.885995 0.899995 0.911995 0.925995 ...
    0.939995 0.953995 0.965994 0.979994 0.993994 1.005994 1.019994 1.033994 ...
    1.045993 1.059993 1.073993 1.085993 1.099993 1.113993 1.127992 1.141992 ...
    1.155992 1.169992 1.183992 1.197991 1.211991 1.225991 1.239991 1.253991 ...
    1.269991 1.283990 1.299990 1.315990 1.329990 1.345990 1.361989 1.379989 ...
    1.395989 1.411989 1.429989 1.447988 1.465988 1.483988 1.501988 1.521987 ...
    1.539987 1.559987 1.581987 1.601986 1.623986 1.647986 1.669985 1.693985 ...
    1.719985 1.745984 1.773984 1.801984 1.831983 1.863983 1.895983 1.931982 ...
    1.969982 2.009982 2.053984 2.101986 2.153988 2.211991 2.279994 2.355998];

xstar(1) = -5;
while xstar(1) < -d
    xstar(1) = xstar(1)+1;
end %while


%--------------------------------------------------------------------
for i = 1:(n-1)
    
    %--------------------------------------------------------------------
    % Calculate X*
    
    if i > 1
        xstar(i) = xstar(i-1)+1;
    end %if
    
    
    %--------------------------------------------------------------------
    % Calculate F*
    
    fstar(i) = a.*((xstar(i)+d)./c).^b .* exp(b.*(1-(xstar(i)+d)./c));
    
    
    %--------------------------------------------------------------------
    % Calculate x and f
    
    x(i) = xstar(i) .* zm .* (sigmaw./ustar).^(-0.8);
    f(i) = fstar(i) ./ zm .* (1-(zm./h)) .* (sigmaw./ustar).^(0.8);
    
end %for


%--------------------------------------------------------------------
% Calculate maximum location of influence (peak location)

xstarmax = c-d;
xmax     = xstarmax .* zm .*(sigmaw./ustar).^(-0.8);

%--------------------------------------------------------------------
% Get L

for i = 1:(nr-1)
    jj = i-1;
    if jj == r
        lr = lall(i);
    end %if
end %for


%--------------------------------------------------------------------
% Calculate distance including R percentage of the footprint

xstarr = lr.*c - d;
xr     = xstarr .* zm .*(sigmaw./ustar).^(-0.8);


%--------------------------------------------------------------------
% Output of results

if xout == 1
    
    display('Results of Flux Footprint Parameterisation')
    display('------------------------------------------')
    display(['Measurement height [m]:                 ' num2str(zm)])
    display(['Roughness length [m]:                   ' num2str(znot)])
    display(['Planetary boundary layer height [m]:    ' num2str(h)])
    display(['sigma_w [m s-1]:                        ' num2str(sigmaw)])
    display(['u* [m s-1]:                             ' num2str(ustar)])
    display(['R [%]:                                  ' num2str(r)])
    display(['X*max [ ]:                              ' num2str(xstarmax)])
    display(['xmax [m]:                               ' num2str(xmax)])
    display(['X*R [ ]:                                ' num2str(xstarr)])
    display(['xR [m]:                                 ' num2str(xr)])
    display('X* [ ]')
    display(num2str(xstar))
    display('F* [ ]')
    display(num2str(fstar))
    display('x [m]')
    display(num2str(x))
    display('f[m-1]')
    display(num2str(f))
end %if

return
