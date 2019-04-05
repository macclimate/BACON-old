function err = fitlogi4(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT OF RECTANGULAR
%       HYPERBOLA 
%       
%       Y = ((a-d) /(1 + (x/c)^b)) + d 
%
%   First created on: 14 Nov 2007 by J Brodeur
%

global X Y;

y_hat=(coeff(1)-coeff(4))./(1 + (X./coeff(3)).^coeff(2))...
            + coeff(4);

err = sum((y_hat - Y).^2);