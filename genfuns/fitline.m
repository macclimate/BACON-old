function err = fitline(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT OF a line
%       
%       
%       Y = a/(1 + exp(b*(c-x))) 
%
%   First created on: 20 June 1997 by Paul Yang
%        Modified on: 20 June 1997 by Paul Yang 
%



global X Y stdev;
y_hat = coeff(1)*X + coeff(2);

% y_hat=(coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X)));

if isempty(stdev)==1;
 err = sum((y_hat - Y).^2);
else
     err = sum(abs(y_hat - Y)./stdev); 
end
