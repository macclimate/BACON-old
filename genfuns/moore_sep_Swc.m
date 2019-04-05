function[dFoverF] = moore_sep_Swc(z, u, s, zL)
%%%%%%%
% This function calculates scalar flux covariance loss as a
% result of seperation length between scalar intake and anemometer - following
% Moore, 1986
% Usage: [dFoverF] = moore_sep_Swc(z, u, s)
% where dFoverF is the ratio of 'true' covariance to measured covariance,
% which represents the factor of correction - summed over frequencies 0.001 to 10 Hz.
% Inputs: z is instrument height (m)
%         u is mean wind speed (m/s)
%         s is sensor separation (m)
%         zL is stability parameter 
% clear all;
% close all;

%%%%%%%%% Parameter Input

n = [logspace(-4,2,2000)]'; 

f_sep = n.*s./u;
f = n.*z./u;
Ts = exp(-9.9.*f_sep.^1.5); 

if zL >= 0;                      % stable conditions
    Awc2 = 0.284.*(1+ 6.4.*zL).^0.75;
    Bwc2 = 2.34.*Awc2;
    
    nSwc2 = f./(Awc2 + Bwc2.*(f.^(2.1)));
end

if zL < 0;     
    ind = find (f<0.54);
    nSwc2(ind) = (12.92.*f(ind))./((1+26.7.*f(ind)).^(1.375));
    
    clear ind;
    
    ind = find(f>=0.54);
    nSwc2(ind) = (4.378.*f(ind))./((1+3.8.*f(ind)).^(2.4));
    nSwc2 = nSwc2';
end

dFoverF = (sum(nSwc2)./sum(Ts.*nSwc2));

