function out = fitGEP_1H1_1L6(c_hat,x)
%%
global X Y stdev objfun fixed_coeff coeffs_to_fix;

if ~isempty(coeffs_to_fix)==1
    ctr = 1;
    for i = 1:1:length(fixed_coeff)
        if isnan(fixed_coeff(i))
            c_hat_tmp(i) = c_hat(ctr);
            ctr = ctr+1;
        else
            c_hat_tmp(i) = fixed_coeff(i);
        end
        
    end
    
    c_hat = c_hat_tmp;
end

if nargin > 1
    y_hat = ((c_hat(1)*c_hat(2)*x(:,1))./(c_hat(1)*x(:,1) + c_hat(2))).* ...
        (1./(1 + exp(c_hat(3)-c_hat(4).*x(:,2))));
    out = y_hat;
    
else
    y_hat = ((c_hat(1)*c_hat(2)*X(:,1))./(c_hat(1)*X(:,1) + c_hat(2))).* ...
        (1./(1 + exp(c_hat(3)-c_hat(4).*X(:,2))));
    
    
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
