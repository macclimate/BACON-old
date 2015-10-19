function err = fitGEP_PAR_Ts_VPD(coeff,x)

global X Y

% y_hat = (coeff(1)*coeff(2)*X(:,1)./(coeff(1)*X(:,1) + coeff(2))) ...
%     .*(coeff(3)*coeff(4)*X(:,2)./(coeff(3)*X(:,2) + coeff(4))) ...
%     .*coeff(5).*X(:,3) + coeff(6);

y_hat=(coeff(1)*coeff(2)*X./(coeff(1)*X + coeff(2))) ./ (coeff(1)*coeff(2)*2200./(coeff(1)*2200 + coeff(2)));

% y_hat = ((2200*coeff(1) + coeff(2)).*(coeff(1).*coeff(2).*X(:,1)))./ ...
%     ((X(:,1).*coeff(1) + coeff(2)) .*(2200.*coeff(1).*coeff(2)));

err = sum((y_hat - Y).^2);