function err = fit_RE_Ts_fixed_SM(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT logistic function plus a logistical
%   scaling factor (0 - 1) for a second variable.
% For current uses, X is structured as [Ts SM]
%       
%       Y = ( a/(1 + exp(b*(c-x1))) ) * (1./ ( 1 + exp(c-d*x2)) )
%
%   Created by JJB - Feb 19, 2010.
%   If it breaks, blame Emily.
%

global X Y stdev SM_coeff;
% y_hat=coeff(1)*exp(coeff(2)*X(:,1)).* (1./(1 + exp(coeff(3)-coeff(4).*X(:,2)))); 
 y_hat=((coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X(:,1))))) ...
     .* (1./(1 + exp(SM_coeff(1)-179.*SM_coeff(2).*X(:,2))));
% % y_hat=(coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X)));

if isempty(stdev)==1;
 err = sum((y_hat - Y).^2);
else
err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev)); 
end
