function out = fitGEP_1H1_1L1fixed_2L6(c_hat,x)
%%
global X Y stdev objfun fixed_coeff coeffs_to_fix;

%%% Fix coefficient values if specified:
if sum(coeffs_to_fix) > 0
    c_hat(coeffs_to_fix==1) = fixed_coeff(coeffs_to_fix==1);
end


if nargin > 1
       y_hat = ((c_hat(1)*c_hat(2)*x(:,1))./(c_hat(1)*x(:,1) + c_hat(2))).* ...
        ((0-1)./(1 + exp(c_hat(3).*(c_hat(4)-x(:,2)))) + 1) .* ...
        (1./(1 + exp(c_hat(5)-c_hat(6).*x(:,3)))) .* ...
        (1./(1 + exp(c_hat(7)-c_hat(8).*x(:,4))));
    out = y_hat;
else
       y_hat = ((c_hat(1)*c_hat(2)*X(:,1))./(c_hat(1)*X(:,1) + c_hat(2))).* ...
        ((0-1)./(1 + exp(c_hat(3).*(c_hat(4)-X(:,2)))) + 1) .* ...
        (1./(1 + exp(c_hat(5)-c_hat(6).*X(:,3)))) .* ...
        (1./(1 + exp(c_hat(7)-c_hat(8).*X(:,4))));


switch objfun
    case 'OLS'
        err = sum((y_hat - Y).^2);
    case 'WSS'
        err = sum(((y_hat - Y).^2)./(stdev.^2));
    case 'MAWE'
        err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev));
    otherwise
        disp('no objective function specified - using least-squares')
      err = sum((y_hat - Y).^2);
end
out = err;
end
