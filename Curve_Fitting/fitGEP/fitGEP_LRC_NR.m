function out = fitGEP_LRC_NR(c_hat,x)
%%
%%% fitGEP_NR_LRC.m
%%% This function estimates NEE a non-rectangular
%%% hyperbolic function and subtracting RE (using the L&T method, with only
%%% one flexible parameter -- rb [a.k.a. Rref]).
%%% The Eo parameter is set, but is not a fixed value.  Therefore, it needs
%%% to be inputted as a third column in x.
%%% Input: x (or X) must be in the form: [PAR T Eo VPD k(optional)]

%%% Four total coefficients: [alpha beta curve_param Rref]

global X Y stdev objfun fixed_coeff coeffs_to_fix;

%%% Fix coefficient values if specified:
%%% Modified 4-Dec-2010:  
%%% When we have fixed coefficients, the coefficients that are fed into 
%%% this function (c_hat), does not include the fixed coefficient (or else
%%% it would get adjusted by fminsearch, fmincon, etc...).However, we need
%%% that value in the proper place in c_hat, so that the function can be
%%% evaluated properly.  Therefore, we need to put it back into the right
%%% spot in c_hat, and evaluate the function, 
%%% We do not have to put it back in, as the only output is the cost
%%% function value.  Still with me?  Good.
%%% Put the coefficient in the right spot in c_hat for evaluation purposes:
if sum(coeffs_to_fix) > 0
    c_tmp = fixed_coeff;
    c_tmp(coeffs_to_fix==0) = c_hat(1:end);
    clear c_hat;
    c_hat = c_tmp;
    clear c_tmp;
end

%% Evaluation:
%%% If nargin > 1, we want to evaluate with an x value that's been inputted
%%% by the user for final evaluation purposes.  Otherwise, the evaluation
%%% is being done by the optimization function (one argument required):

if nargin > 1
        y_hat = c_hat(4).*(exp( x(:,3).*( (1./(10-(-46.02))) - (1./(x(:,2)-(-46.02)))) )) - ...
            ((c_hat(1).*x(:,1) + c_hat(2) - sqrt( (c_hat(1).*x(:,1) + c_hat(2)).^2 - 4.*c_hat(1).*c_hat(2).*c_hat(3).*x(:,1))) ./2.*c_hat(3));
        y_hat = real(y_hat);
        out = y_hat;
else
        y_hat = c_hat(4).*(exp( X(:,3).*( (1./(10-(-46.02))) - (1./(X(:,2)-(-46.02)))) )) - ...
            ((c_hat(1).*X(:,1) + c_hat(2) - sqrt( (c_hat(1).*X(:,1) + c_hat(2)).^2 - 4.*c_hat(1).*c_hat(2).*c_hat(3).*X(:,1))) ./2.*c_hat(3));
        y_hat = real(y_hat);

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

