function [REW] = VWC_to_REW(VWC,fc, wp)
% This function converts VWC to REW
if nargin == 1
    fc = 0.3;
    wp = 0.01;
    disp('Using defaults for REW -> fc = 0.3, wp=0.01');
end

REW = (VWC-wp)./(fc - wp);