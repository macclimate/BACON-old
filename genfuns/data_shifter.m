function [sh] = data_shifter(unsh, shift)
% THis function shifts data by a prescribed amount of data points.

if shift > 0; % shift ahead:
    
sh = [NaN.*ones(shift,1); unsh(1:length(unsh)-shift,1)];

else
    
    sh = [unsh(shift:length(unsh),1); NaN.*ones(shift,1)];
    
end