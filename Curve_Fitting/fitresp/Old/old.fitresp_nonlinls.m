function [c_hat, y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = fitresp_nonlinls(coeff_0, funName, Xin, Yin, X_eval, stdev_in, min_method, costfun)

if nargin < 8;
    stdev_in = []; costfun = 'OLS';
    disp('found less than the 7 expected input arguments.');
    disp('Please check the function to make sure you have all arguments');
    disp('Currently assuming you are using OLS as an objective function');
end

stats = struct;
global X Y stdev objfun;
X = Xin;
Y = Yin;
stdev = stdev_in;
objfun = costfun;
%% Run the minimization:
if strcmp(min_method,'LM')==1
    alg_in = {'levenberg-marquardt',.005};
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0, [],[], optimset('Algorithm', alg_in, 'MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8));
elseif strcmp(min_method,'GN')==1
%     alg_in = ['''LargeScale''',off, LevenbergMarquardt, off'];
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0,[],[], optimset('LargeScale','off','LevenBergMarquardt', 'off','MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8));
else
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0,[],[],optimset('MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8));
end
    
num_iter = output.iterations;
%% This part evaluates the function using the best-fit coefficients to
%%% get estimates for parameterization data (when Y_in is good), and for
%%% all periods covered by X_eval:

switch funName
    %%% Lloyd and Taylor (A - Ts only, B - Ts+SM)
    case 'fitresp_1A'
        y_hat = c_hat(1).*exp( (-1.*c_hat(2)) ./ ( X(:,1)+(273.15-c_hat(3)) ) );
        y_pred = c_hat(1).*exp( (-1.*c_hat(2)) ./ ( X_eval(:,1)+(273.15-c_hat(3)) ) );
    case 'fitresp_1B'
        y_hat = c_hat(:,1).*exp( (-1.*c_hat(2)) ./ ( X(:,1)+(273.15-c_hat(3)) ) ) .* ...
            1./(1 + exp(c_hat(4)-c_hat(5).*X(:,2)));
        y_pred = c_hat(:,1).*exp( (-1.*c_hat(2)) ./ ( X_eval(:,1)+(273.15-c_hat(3)) ) ) .* ...
            1./(1 + exp(c_hat(4)-c_hat(5).*X_eval(:,2)));
        
        %%% Barr logistic (A - Ts only, B - Ts+SM)
    case 'fitresp_2A'
        y_hat = (c_hat(1))./(1 + exp(c_hat(2).*(c_hat(3)-X(:,1))));
        y_pred = (c_hat(1))./(1 + exp(c_hat(2).*(c_hat(3)-X_eval(:,1))));
    case 'fitresp_2B'
        y_hat = (c_hat(1))./(1 + exp(c_hat(2).*(c_hat(3)-X(:,1)))) .* ...
            1./(1 + exp(c_hat(4)-c_hat(5).*X(:,2)));
        y_pred = (c_hat(1))./(1 + exp(c_hat(2).*(c_hat(3)-X_eval(:,1)))) .* ...
            1./(1 + exp(c_hat(4)-c_hat(5).*X_eval(:,2)));
    case 'fitresp_2C'
        y_hat = c_hat(1).*(1./(1 + exp(c_hat(2)-c_hat(3).*X(:,1)))).* ...
    (1./(1 + exp(c_hat(4)-c_hat(5).*X(:,2))));
        y_pred = c_hat(1).*(1./(1 + exp(c_hat(2)-c_hat(3).*X_eval(:,1)))).* ...
    (1./(1 + exp(c_hat(4)-c_hat(5).*X(:,2))));
    
        
        
        %%% Q10 (A - Ts only, B - Ts+SM(logi), C - Ts+SM(Carlyle))
    case 'fitresp_3A'
        y_hat = c_hat(1).*c_hat(2).^((X(:,1) - 10)./10);
        y_pred = c_hat(1).*c_hat(2).^((X_eval(:,1) - 10)./10);
        
    case 'fitresp_3B'
        y_hat = c_hat(1).*c_hat(2).^((X(:,1) - 10)./10) .* ...
            1./(1 + exp(c_hat(3)-c_hat(4).*X(:,2)));
        y_pred = c_hat(1).*c_hat(2).^((X_eval(:,1) - 10)./10) .* ...
            1./(1 + exp(c_hat(3)-c_hat(4).*X_eval(:,2)));
        
    case 'fitresp_3C'
        y_hat = c_hat(1).*c_hat(2).^((X(:,1) - 10)./10) .* ...
            (X(:,2)./(X(:,2)+c_hat(3))) .* (c_hat(4)./(X(:,2)+c_hat(4)));
        y_pred = c_hat(1).*c_hat(2).^((X_eval(:,1) - 10)./10) .* ...
            (X_eval(:,2)./(X_eval(:,2)+c_hat(3))) .* (c_hat(4)./(X_eval(:,2)+c_hat(4)));
        
    case 'fitresp_3D'
        y_hat = c_hat(1).*c_hat(2).^((X(:,1) - 10)./10).* (c_hat(3) + c_hat(4).*X(:,2) + c_hat(5)./X(:,2));
        y_pred = c_hat(1).*c_hat(2).^((X_eval(:,1) - 10)./10).* (c_hat(3) + c_hat(4).*X_eval(:,2) + c_hat(5)./X_eval(:,2));
        
        %%% Exponential (A - Ts only, B - Ts+SM)
    case 'fitresp_4A'
        y_hat = c_hat(1).*exp(c_hat(2)*X(:,1));
        y_pred = c_hat(1).*exp(c_hat(2)*X_eval(:,1));
        
    case 'fitresp_4B'
        y_hat = c_hat(1).*exp(c_hat(2)*X(:,1)) .* ...
            1./(1 + exp(c_hat(3)-c_hat(4).*X(:,2)));
        y_pred = c_hat(1).*exp(c_hat(2)*X_eval(:,1)) .* ...
            1./(1 + exp(c_hat(3)-c_hat(4).*X_eval(:,2)));
        
        %%% Non-Rectangular Hyperbola:
    case 'fitresp_6A'
        y_hat = -1./(2.*c_hat(1)) .* (  c_hat(2).*X(:,3) + c_hat(3) ...
            - sqrt( (c_hat(2).*X(:,3) + c_hat(3)).^2 - 4.*c_hat(2).*c_hat(3).*c_hat(1).*X(:,3))) +c_hat(4);
        y_pred = -1./(2.*c_hat(1)) .* (  c_hat(2).*X_eval(:,3) + c_hat(3) ...
            - sqrt( (c_hat(2).*X_eval(:,3) + c_hat(3)).^2 - 4.*c_hat(2).*c_hat(3).*c_hat(1).*X_eval(:,3))) +c_hat(4);
        
        %%% Saiz Model:
    case 'fitresp_7A'
        y_hat = (c_hat(1).*exp(c_hat(2).*X(:,1))).*(c_hat(3).*X(:,2) + c_hat(4).*X(:,2).^2);
        y_pred = (c_hat(1).*exp(c_hat(2).*X_eval(:,1))).*(c_hat(3).*X_eval(:,2) + c_hat(4).*X_eval(:,2).^2);
        
end

%% Do Stats:

try
    [stats.RMSE stats.rRMSE stats.MAE stats.BE] = model_stats(y_hat, Y, 'off');
    
catch
    disp('calculating stats failed')
    stats.RMSE = NaN; stats.rRMSE = NaN;  stats.MAE = NaN;  stats.BE = NaN;
end

try
         res=sum((y_hat-Y).^2);
  total=sum((Y-mean(Y)).^2);
  stats.R2=1.0-res/total;
  sigma=sqrt(res);
  %     stats.R2 = rsquared(Y, y_out(ind_good_Y));

catch
    disp('calculating R-squared failed')
    stats.R2 = NaN;
end

