function out = fitGEP_Lasslop_VPD(c_hat,x)
%%
%%% fitGEP_Lasslop_noVPD.m
%%% This function estimates NEE (not GEP) using the MM rectangular
%%% hyperbolic function and subtracting RE (using the L&T method, with only
%%% one flexible parameter -- rb [a.k.a. Rref]).
%%% The Eo parameter is set, but is not a fixed value.  Therefore, it needs
%%% to be inputted as a third column in x.
%%% Input: x (or X) must be in the form: [PAR T Eo VPD k(optional)]

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




    % Note that c_hat(2) has been replaced with:
    % c_hat(2).*exp(-1.*c_hat(4).*(x(ind_VPD_up,4)-1))
    %%% If x has 5 columns, it means that k has been pre-determined, and is
    %%% entered as a variable instead of an adjustable parameter:
    %%% Input: x (or X) must be in the form: [PAR T Eo VPD k(optional)]
    
%% Evaluation Mode: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin > 1
    y_hat = NaN.*ones(size(x,1),1);
    %%% Evaluation Mode, Dynamic k value (triggered when x has 5 columns):
    if size(x,2) == 5
        ind_VPD_up = find(x(:,4) > 1);
        y_hat(ind_VPD_up,1) = (c_hat(3).*exp(x(ind_VPD_up,3).*( (1./(10-(-46.02))) - (1./(x(ind_VPD_up,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*(c_hat(2).*exp(-1.*x(ind_VPD_up,5).*(x(ind_VPD_up,4)-1))).*x(ind_VPD_up,1))./(c_hat(1).*x(ind_VPD_up,1) + (c_hat(2).*exp(-1.*x(ind_VPD_up,5).*(x(ind_VPD_up,4)-1)))) );
        ind_VPD_down = find(x(:,4) <= 1);
        y_hat(ind_VPD_down,1) = (c_hat(3).*exp(x(ind_VPD_down,3).*( (1./(10-(-46.02))) - (1./(x(ind_VPD_down,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*c_hat(2).*x(ind_VPD_down,1))./(c_hat(1).*x(ind_VPD_down,1) + c_hat(2)) );
    else
        %%% Evaluation Mode, Static k value (triggered when x has <= 4 columns):
        ind_VPD_up = find(x(:,4) > 1);
        y_hat(ind_VPD_up,1) = (c_hat(3).*exp(x(ind_VPD_up,3).*( (1./(10-(-46.02))) - (1./(x(ind_VPD_up,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*(c_hat(2).*exp(-1.*c_hat(4).*(x(ind_VPD_up,4)-1))).*x(ind_VPD_up,1))./(c_hat(1).*x(ind_VPD_up,1) + (c_hat(2).*exp(-1.*c_hat(4).*(x(ind_VPD_up,4)-1)))) );
        ind_VPD_down = find(x(:,4) <= 1);
        y_hat(ind_VPD_down,1) = (c_hat(3).*exp(x(ind_VPD_down,3).*( (1./(10-(-46.02))) - (1./(x(ind_VPD_down,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*c_hat(2).*x(ind_VPD_down,1))./(c_hat(1).*x(ind_VPD_down,1) + c_hat(2)) );
    end
    out = y_hat;

%% Parameterization Mode: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else    
        y_hat = NaN.*ones(size(X,1),1);
    %%% Paramaterization Mode, Dynamic k value (triggered when X has 5
    %%% columns):
    if size(X,2) == 5
        ind_VPD_up = find(X(:,4) > 1);
        y_hat(ind_VPD_up,1) = (c_hat(3).*exp(X(ind_VPD_up,3).*( (1./(10-(-46.02))) - (1./(X(ind_VPD_up,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*(c_hat(2).*exp(-1.*X(ind_VPD_up,5).*(X(ind_VPD_up,4)-1))).*X(ind_VPD_up,1)) ./ (c_hat(1).*X(ind_VPD_up,1) + (c_hat(2).*exp(-1.*X(ind_VPD_up,5).*(X(ind_VPD_up,4)-1)))) );
        ind_VPD_down = find(X(:,4) <= 1);
        y_hat(ind_VPD_down,1) = (c_hat(3).*exp(X(ind_VPD_down,3).*( (1./(10-(-46.02))) - (1./(X(ind_VPD_down,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*c_hat(2).*X(ind_VPD_down,1))./(c_hat(1).*X(ind_VPD_down,1) + c_hat(2)) );
    else
        %%% Paramaterization Mode, Static k value (triggered when X has <= 4
        %%% columns):
        ind_VPD_up = find(X(:,4) > 1);
        y_hat(ind_VPD_up,1) = (c_hat(3).*exp(X(ind_VPD_up,3).*( (1./(10-(-46.02))) - (1./(X(ind_VPD_up,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*(c_hat(2).*exp(-1.*c_hat(4).*(X(ind_VPD_up,4)-1))).*X(ind_VPD_up,1))./(c_hat(1).*X(ind_VPD_up,1) + (c_hat(2).*exp(-1.*c_hat(4).*(X(ind_VPD_up,4)-1)))) );
            
        ind_VPD_down = find(X(:,4) <= 1);
        y_hat(ind_VPD_down,1) = (c_hat(3).*exp(X(ind_VPD_down,3).*( (1./(10-(-46.02))) - (1./(X(ind_VPD_down,2)-(-46.02))) ))) - ...
        ( (c_hat(1).*c_hat(2).*X(ind_VPD_down,1))./(c_hat(1).*X(ind_VPD_down,1) + c_hat(2)) );
    end

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
