function err = fiterror_gs(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT linear function, plus logistic scaling
%   factor
% For current uses, X is structured as [PAR Ts]
%       
%       Y = ( a/(1 + exp(b*x1)) ) * (1./ ( 1 + exp(c-d*x2)) )
%
%   Created by JJB - Feb 19, 2010.


global X Y stdev;
y_hat=(coeff(1).*X(:,1) + coeff(2)).* (1./(1 + exp(coeff(3)-coeff(4).*X(:,2)))); 
% y_hat=(coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X)));

if isempty(stdev)==1;
 err = sum((y_hat - Y).^2);
else
     err = sum(abs(y_hat - Y)./stdev); 
end
