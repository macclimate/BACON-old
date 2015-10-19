function err = fit_NEE(coeff,x)
% NEE = RE(Ts,SM) - GEP(PAR+Ta+Ts+VPD+SM)
%%% Functional form of GEP relationship with environmental variables.
% This function uses variables: PAR, Ta, Ts, VPD + SM to predict GEP.
% X is [PAR Ta Ts VPD SM], while Y is measured (and filtered) GEP.
% Created Feb 18, 2009 by JJB

global X Y stdev;

y_hat=((coeff(1))./(1 + exp(coeff(2).*(coeff(3)-X(:,1))))) .*...
        (1./(1 + exp(coeff(4)-coeff(5).*X(:,2)))) - ( ...
        ((coeff(6)*coeff(7)*X(:,3))./(coeff(6)*X(:,3) + coeff(7))).* ...
        (1./(1 + exp(coeff(8)-coeff(9).*X(:,1)))) .* ...
        (1./(1 + exp(coeff(10)-coeff(11).*X(:,4)))) .* ...
        (1./(1 + exp(coeff(12)-coeff(13).*X(:,5)))) .* ...
        (1./(1 + exp(coeff(14)-coeff(15).*X(:,2)))));  

if isempty(stdev)==1;
    err = sum((y_hat - Y).^2);
else
     err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev)); 
end