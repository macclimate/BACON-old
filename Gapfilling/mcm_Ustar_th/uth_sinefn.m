function out = uth_sinefn(coeff,X,Y,out_flag)
if nargin < 4
    out_flag = 1; % 1 means fun in fitting mode
end
% Sine curve used to fit seasonally-estimate u*th estimates
% X is decdoy
% Y is ustar threshold (observed)
objfun = 'OLS';
w = (2*pi())./365.2425;

y_hat = coeff(:,1) + coeff(:,2).*sin(w.*(X-coeff(:,3)));

switch out_flag
    
    case 1
        
        switch objfun
            case 'OLS'
                err = sum((y_hat - Y).^2);
            case 'WSS'
                err = sum(((y_hat - Y).^2)./(stdev.^2));
            case 'MAWE'
                err = (1./length(X)) .* ( sum(abs(y_hat - Y)./stdev));
            otherwise
                disp('no objective function specified')
        end
        out = err;
    case 2
        out = y_hat;
end

