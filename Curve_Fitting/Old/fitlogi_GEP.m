function err = fitlogi_GEP(coeff,x)
% GEP = PAR+Ta+Ts+VPD
%%% Functional form of GEP relationship with environmental variables.
% This function uses variables: PAR, Ta, Ts, VPD to scale GEP
% X is [PAR Ta Ts VPD], while Y is measured (and filtered) GEP.
% Created Feb 18, 2009 by JJB

global X Y stdev;

y_hat = (coeff(1)*coeff(2)*X(:,1)./(coeff(1)*X(:,1) + ...
    coeff(2))).* (1./(1 + exp(coeff(3)-coeff(4).*X(:,2)))) .* ...
    (1./(1 + exp(coeff(5)-coeff(6).*X(:,3)))) .* ...
    (1./(1 + exp(coeff(7)-coeff(8).*X(:,4))));

if isempty(stdev)==1;
    err = sum((y_hat - Y).^2);
else
     err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev)); 
end
