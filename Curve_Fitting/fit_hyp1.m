function err = fit_hyp1(coeff,x)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT OF RECTANGULAR
%       HYPERBOLA 
%       
%       Y = alpha*Q*Amax/(alpha*Q + Amax)
%
%   First created on: 22 Mar 1996 by Paul Yang
%        Modified on: 01 Oct 1996 by Paul Yang 
%
%   Revisions:
%	01 Oct. 1997: Forcing it pass the origin (0,0)	


global X Y stdev;

y_hat=coeff(1)*coeff(2)*X./(coeff(1)*X + coeff(2));

if isempty(stdev)==1;
err = sum((y_hat - Y).^2);
else 
    err = sum(abs(y_hat - Y)./stdev); 
end

