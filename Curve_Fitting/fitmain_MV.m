function [coeff_hat, Y_hat, R2, sigma] = fitmain_MV(coeff_0, funName, Xin, Yin, Xin2, stdev_in)

%________________________________________________________%
%                                                        %
% MAIN PROGRAM                                           %
%                                                        %
%________________________________________________________%
if nargin == 5;
     stdev_in = [];  
end
 
 global X Y X2 stdev
 X = Xin;
 Y = Yin;
 
 X2 = Xin2;

 
 
  stdev = stdev_in;
% X=linspace(0,1,20); Y=2*exp(0.5*X)+0.1*randn(1,20);
% coeff_0=[.45,-.16];
 coeff_hat=fminsearch(funName, coeff_0);

if funName(1:6) == 'fitexp' 
    Y_hat=coeff_hat(1)*exp(coeff_hat(2)*X);
elseif funName(1:7) == 'fitline'
    Y_hat = coeff_hat(1)*X + coeff_hat(2);
elseif funName(1:8) == 'fitlogi1' 
    Y_hat=(coeff_hat(1)-coeff_hat(4))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X)))...
            + coeff_hat(4);
elseif funName(1:8) == 'fitlogi2' 
    Y_hat = coeff_hat(1)./(coeff_hat(2)+coeff_hat(3)*exp(coeff_hat(4)*X));
elseif funName(1:8) == 'fitlogi3' 
    Y_hat=1./(coeff_hat(1) + coeff_hat(2).^(-(X-10)./10))+coeff_hat(3);
elseif funName(1:8) == 'fitlogi4' 
    Y_hat=(coeff_hat(1)-coeff_hat(4))./(1 + (X./coeff_hat(3)).^coeff_hat(2))...
            + coeff_hat(4);
elseif funName(1:10) == 'fitlogi5MV' 
    Y_hat = (coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X))) + (coeff_hat(4))./(1 + exp(coeff_hat(5).*(coeff_hat(6)-X2)));
elseif funName(1:11) == 'fitlogi5MV2' 
    Y_hat = ((coeff_hat(1))./(1 + exp(coeff_hat(2).*(coeff_hat(3)-X)))) .* ((coeff_hat(4))./(1 + exp(coeff_hat(5).*(coeff_hat(6)-X2))));
elseif funName(1:11) == 'fitlogi5MV3' 
     Y_hat = (coeff_hat(1).*coeff_hat(4)) ./ 1 + (exp( (coeff_hat(2).*(coeff_hat(3)-X)) .* (coeff_hat(5).*(coeff_hat(6) - X2))));
elseif funName(1:11) == 'fitlogi5M4' 
     Y_hat = (coeff_hat(1) + coeff_hat(4)) ./ 1 + (exp( (coeff_hat(2).*(coeff_hat(3)-X)) .* (coeff_hat(5).*(coeff_hat(6) - X2))));
        

end

% plot(X,Y,'co',X,Y_hat)

%% R2 (R_squared)

  res=sum((Y_hat-Y).^2);
  total=sum((Y-mean(Y)).^2);
  R2=1.0-res/total;
  sigma=sqrt(res);
  