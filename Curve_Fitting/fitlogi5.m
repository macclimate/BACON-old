function err = fitlogi5(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT OF RECTANGULAR
%       HYPERBOLA 
%       
%       Y = a/(1 + exp(b*(c-x))) 
%
%   First created on: 20 June 1997 by Paul Yang
%        Modified on: 20 June 1997 by Paul Yang 
%

global X Y stdev;

y_hat=(coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X)));

if isempty(stdev)==1;
err = sum((y_hat - Y).^2);
else
err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev)); 
end
