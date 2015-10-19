function [ncsum] =  nancumsum(x)

x(isnan(x)) = 0;

ncsum = cumsum(x);

