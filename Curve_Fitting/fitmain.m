
function [coeff_hat, Y_hat, R2, sigma] = fitmain(coeff_0, funName, Xin, Yin, stdev_in)

%________________________________________________________%
%                                                        %
% MAIN PROGRAM                                           %
%                                                        %
%________________________________________________________%
if nargin == 4;
     stdev_in = [];  
end
 
 global X Y stdev SM_coeff GEP_SM_coeff GEP_scalar_coeff;
 X = Xin;
 Y = Yin;
 
  stdev = stdev_in;
% X=linspace(0,1,20); Y=2*exp(0.5*X)+0.1*randn(1,20);
% coeff_0=[.45,-.16];

% Runs fminsearch, which minimizes the output of the called function, in
% these cases, it is error (eiter OLS or MAWE):
 coeff_hat=fminsearch(funName, coeff_0, optimset('MaxFunEvals', 10000,'MaxIter',10000));
% coeff_hat is the outputted best-fit coefficients, and are used below to
% create predicted values for the inputted X values
 
switch funName
    case 'fitexp' 
    Y_hat=coeff_hat(1)*exp(coeff_hat(2)*X);
    case 'fitline'
    Y_hat = coeff_hat(1)*X + coeff_hat(2);
    case 'fitlogi1' 
    Y_hat=(coeff_hat(1)-coeff_hat(4))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X)))...
            + coeff_hat(4);
    case 'fitlogi2' 
    Y_hat = coeff_hat(1)./(coeff_hat(2)+coeff_hat(3)*exp(coeff_hat(4)*X));
    case 'fitlogi3' 
    Y_hat=1./(coeff_hat(1) + coeff_hat(2).^(-(X-10)./10))+coeff_hat(3);
    case 'fitlogi4' 
    Y_hat=(coeff_hat(1)-coeff_hat(4))./(1 + (X./coeff_hat(3)).^coeff_hat(2))...
            + coeff_hat(4);
    case 'fitlogi5' 
    Y_hat=(coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X)));
    case 'fitlogi6'
    Y_hat = 1./(1 + exp(coeff_hat(1)-coeff_hat(2).*X));
    case 'fitlogi_GEP' %  GEP = PAR+Ta+Ts+VPD
    Y_hat = ((coeff_hat(1)*coeff_hat(2)*X(:,1))./(coeff_hat(1)*X(:,1) + coeff_hat(2))).* ...
        (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))) .* ...
        (1./(1 + exp(coeff_hat(5)-coeff_hat(6).*X(:,3)))) .* ...
        (1./(1 + exp(coeff_hat(7)-coeff_hat(8).*X(:,4))));
    case 'fitlogi_GEP2' % GEP = PAR+Ta+Ts+VPD+SM
    Y_hat = ((coeff_hat(1)*coeff_hat(2)*X(:,1))./(coeff_hat(1)*X(:,1) + coeff_hat(2))).* ...
        (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))) .* ...
        (1./(1 + exp(coeff_hat(5)-coeff_hat(6).*X(:,3)))) .* ...
        (1./(1 + exp(coeff_hat(7)-coeff_hat(8).*X(:,4)))) .* ...
        (1./(1 + exp(coeff_hat(9)-coeff_hat(10).*X(:,5))));   
    case 'fitexp_R_Ts_SM' % R = Ts+SM
    Y_hat = (coeff_hat(1)*exp(coeff_hat(2)*X(:,1))) ...
        .* (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))); 
    case 'fiterror_gs' % [PAR Ta]
    Y_hat = (coeff_hat(1).*X(:,1) + coeff_hat(2)) ...
        .* (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))); 
    case 'fit_hyp1' % rectangular hyperbola:
 Y_hat = ((coeff_hat(1)*coeff_hat(2)*X(:,1))./(coeff_hat(1)*X(:,1) + coeff_hat(2)));
    case 'fitlogi_R_Ts_SM'
 Y_hat=((coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X(:,1))))) ...
     .* (1./(1 + exp(coeff_hat(4)-coeff_hat(5).*X(:,2))));     
    case 'fit_NEE' % inputs [Ts SM PAR Ta VPD]
  Y_hat=((coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X(:,1))))) .*...
        (1./(1 + exp(coeff_hat(4)-coeff_hat(5).*X(:,2)))) - ( ...
        ((coeff_hat(6)*coeff_hat(7)*X(:,3))./(coeff_hat(6)*X(:,3) + coeff_hat(7))).* ...
        (1./(1 + exp(coeff_hat(8)-coeff_hat(9).*X(:,1)))) .* ...
        (1./(1 + exp(coeff_hat(10)-coeff_hat(11).*X(:,4)))) .* ...
        (1./(1 + exp(coeff_hat(12)-coeff_hat(13).*X(:,5)))) .* ...
        (1./(1 + exp(coeff_hat(14)-coeff_hat(15).*X(:,2)))));     
    case 'fit_RE_Ts_fixed_SM'
   Y_hat=((coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X(:,1))))) ...
     .* (1./(1 + exp(SM_coeff(1)-SM_coeff(2).*X(:,2))));     
    case 'fit_GEP_fixed_SM'
     Y_hat = ((coeff_hat(1)*coeff_hat(2)*X(:,1))./(coeff_hat(1)*X(:,1) + coeff_hat(2))).* ...
        (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))) .* ...
        (1./(1 + exp(coeff_hat(5)-coeff_hat(6).*X(:,3)))) .* ...
        (1./(1 + exp(coeff_hat(7)-coeff_hat(8).*X(:,4)))) .* ...
        (1./(1 + exp(GEP_SM_coeff(1)-GEP_SM_coeff(2).*X(:,5))));   
        case 'fit_GEP_fixed_scalars'
     Y_hat = ((coeff_hat(1)*coeff_hat(2)*X(:,1))./(coeff_hat(1)*X(:,1) + coeff_hat(2))).* ...
        (1./(1 + exp(GEP_scalar_coeff(1)-GEP_scalar_coeff(2).*X(:,2)))) .* ...
        (1./(1 + exp(GEP_scalar_coeff(3)-GEP_scalar_coeff(4).*X(:,3)))) .* ...
        (1./(1 + exp(GEP_scalar_coeff(5)-GEP_scalar_coeff(6).*X(:,4)))) .* ...
        (1./(1 + exp(GEP_scalar_coeff(7)-GEP_scalar_coeff(8).*X(:,5))));   
    case 'fit_gamma'
        Y_hat = (X(:,1).^coeff_hat(1)).*(exp(coeff_hat(2) + (coeff_hat(3)*X(:,1))));
    case 'fitlogi_GEP_logi1'
       Y_hat = (coeff_hat(1)*coeff_hat(2)*X(:,1)./(coeff_hat(1)*X(:,1) + ...
    coeff_hat(2))).* (1./(1 + exp(coeff_hat(3)-coeff_hat(4).*X(:,2)))) .* ...
    ((0-1)./(1 + exp(coeff_hat(5).*(coeff_hat(6)-X(:,3)))) + 1) .* ...
    (1./(1 + exp(coeff_hat(7)-coeff_hat(8).*X(:,4)))); 
end


%% R2 (R_squared)

  res=sum((Y_hat-Y).^2);
  total=sum((Y-mean(Y)).^2);
  R2=1.0-res/total;
  sigma=sqrt(res);
  
