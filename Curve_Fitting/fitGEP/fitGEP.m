function [c_hat, y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = ...
    fitGEP(coeff_0, funName, Xin, Yin, X_eval, stdev_in, options)
%%% usage: [c_hat, y_hat, y_pred, stats, sigma, err, exitflag, num_iter] =
%%% fitGEP(coeff_0, funName, Xin, Yin, X_eval, stdev_in, options)
%%% OUTPUTS:
%%% c_hat = best estimates for coefficients
%%% y_hat = estimated values for Y (GEP), evaluated from Xin, where only certain points have been included for parameterization
%%% y_pred = estimated values for Y (GEP), evaluated from X_eval, which is usually an annual or longer continuous timeseries
%%% stats = structure with statistics (RMSE, MAE, BE, R2, etc)
%%% err = final value of objective function at end of minimization
%%% exitflag = flag to indicate convergence (1), or non-convergence (0, -1)
%%% num_iter = number of iterations needed to reach convergence
%%% INPUTS:
%%% coeff_0 = starting estimates for coefficient values
%%% fun_Name = string name of function to be used (e.g.'fitGEP_1H1_2L6' is hyperbolic with 2 logistic scaling functions)
%%% Xin: input X data for parameterization (i.e. X data when you have
%%%    acceptable GEP data).  Depending in the function you are using, Xin may
%%%    be a column vector (e.g. Xin = PAR;), or a matrix, with separate variables as
%%%    columns (e.g. Xin = [PAR VPD SM];)
%%% Yin: input raw GEP data for parameterization (good GEP data)
%%% X_eval: annual or longer timeseries of continuous X values -- used to
%%%     make timeseries of predicted GEP. Similar to Xin, X_eval may be a single
%%%     column or a matrix with as many columns as needed env. variables.
%%% stdev_in: standard deviation estimates (weights) corresponding with Yin
%%%     values (can use [] to indicate no use of stdev)
%%% options: allows the user to change the details of the minimization.
%%%%% options.costfun specifies the cost function to be used (e.g. Sum of
%%%%%   Squares ('OLS'), Weighted Sum of Squares ('WSS'), or
%%%%%   Mean Absolute Weighted Error ('MAWE')
%%%%%   If nothing is specified, then the default is set as OLS.  ** Note
%%%%%   that to use WSS or MAWE, you must have non-zero standard deviations
%%%%%   applied for each measurement.
%%%%% options.min_method specifies the minimization method.  Default is
%%%%%   Nelder-Mead Simplex ('NM', fminsearch function).  Also available is
%%%%%   Levenberg-Marquardt ('LM'), and Simmulated Annealing ('SA').
%%%%% options.f_coeff lets you fix specified parameter values, while letting others be optimized.
%%%%%   Default is no fixed coefficients.
%%% SAMPLE USAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 1: Using the Nelder-Mead minimization approach (fminsearch), with
% Original Least Squares (same as Sum of Squares, 'OLS) cost function, and
% no fixed coefficients (normal use).  We are using a relationship with PAR, Ts, VPD and SWC
%%%%% options.costfun ='OLS'; %
%%%%% options.min_method ='NM';
%%%%% options.f_coeff = [NaN NaN 1 2 -2 4 8 180]; % This will allow the PAR relationship (hyperbolic) to vary, but keep the other scaling relationships constant,
%%%%% with fixed parameter values (i.e. you are fitting for only the PAR relationship in this case).

%%%    [c_hat(ctr).GEP, y_hat(ctr).GEP, y_pred(ctr).GEP, stats(ctr).GEP, sigma(ctr).GEP, err(ctr).GEP, exitflag(ctr).GEP, num_iter(ctr).GEP] = ...
%%%        fitGEP(starting_coeffs, 'fitGEP_1H1_3L6', X_in,GEPraw(ind_param(ctr).GEP),  X_eval, data.NEEstd(ind_param(ctr).GEP), options);

%%% *** Note here that we don't have to specify options.f_coeff is we don't
%%% want to fix any coefficients (we're letting the function determine all
%%% the best fits).  Also, we can enter stdev as [], since we don't need it
%%% when using OLS.

clear global; % Added May 2, 2011 by JJB.  This hopefully will work and not cause problems.

%%% Set the Cost function name:
if isfield(options, 'costfun')
    costfun = options.costfun;
else
    costfun = 'OLS'
end

%%% Set the minimization method name:
if isfield(options, 'min_method')
    min_method = options.min_method;
else
    min_method = 'NM'
end

%%% Check if there are fixed coefficients.  If so, sort out which are to be
%%% fixed:
if isfield(options, 'f_coeff');
    fixed_coeff_tmp = options.f_coeff;
    %     coeffs_to_fix_tmp = find(~isnan(fixed_coeff_tmp));
    coeffs_to_fix_tmp = ~isnan(fixed_coeff_tmp);
    
else
    coeffs_to_fix_tmp = [];
    fixed_coeff_tmp = [];
end

%%% Added 4-Dec-2010.  Desire is to remove the fixed coefficient from the
%%% initial guess coefficients when we are running in fixed coeff mode.
if isequal(length(coeff_0), length(coeffs_to_fix_tmp))==1
c_tmp = coeff_0(coeffs_to_fix_tmp == 0);
clear coeff_0;
coeff_0 = c_tmp;
clear c_tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% If using constrained NM approach, make sure that there are upper and
%%% lower bounds inputted.  If there are not, then return and leave
%%% function.
if strcmp(options.min_method,'NMC')==1
    if isfield(options, 'lbound')
        lbound = options.lbound;
        bound_flag1 = 1;
    else
        bound_flag1 = 0;
    end
    if isfield(options, 'ubound')
        ubound = options.ubound;
        bound_flag2 = 1;
    else
        bound_flag2 = 0;
    end
    if bound_flag1*bound_flag2 ~=1
        disp('Please enter upper and lower bounds for function.');
        return
    else
    end
    
    % Added 6-Dec-2010. Trim upper and lower bounds if we have fixed
    % coefficients:
    if sum(coeffs_to_fix_tmp) > 0;
    lbound = lbound(coeffs_to_fix_tmp==0);
    ubound = ubound(coeffs_to_fix_tmp==0);
    end
end


if nargin < 7;
    min_method = 'NM';
    disp('found less than the 8 possible input arguments.');
    disp('Please check the function to make sure you have all arguments');
    disp('Assuming that all arguments are entered correctly except for final (''method'') argument');
    disp('Using Nelder-Mead Approach and original least-squares');
    costfun = 'OLS'
    min_method = 'NM'
    
    %     disp('only found 5 input parameters -- assuming you included X_eval, but not stdev');
    %     disp('In future use, make sure you include X_eval, and set stdev = [].');
end


stats = struct;
global X Y stdev objfun fixed_coeff coeffs_to_fix;
X = Xin;
Y = Yin;
stdev = stdev_in;
objfun = costfun;
fixed_coeff = fixed_coeff_tmp;
coeffs_to_fix = coeffs_to_fix_tmp;
%% Run the minimization:
if strcmp(min_method,'LM')==1
    alg_in = {'levenberg-marquardt',.005};
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0, [],[], optimset('Algorithm', alg_in, 'MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8, 'Display','off'));
elseif strcmp(min_method,'GN')==1
    %     alg_in = ['''LargeScale''',off, LevenbergMarquardt, off'];
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0,[],[], optimset('LargeScale','off','LevenBergMarquardt', 'off','MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8, 'Display','off'));
elseif strcmp(min_method,'TRR')==1
    [c_hat err resid exitflag output] = lsqnonlin(funName,coeff_0,[],[],optimset('MaxFunEvals', 10000,'MaxIter',10000, 'TolX',1e-8, 'TolFun', 1e-8, 'Display','off'));
elseif strcmp(min_method,'SA')==1
    eval (['fun_to_use = @' funName ';']);
    [c_hat,err,exitflag,output] = simulannealbnd(fun_to_use,coeff_0);
elseif strcmp(min_method,'NMC');
    % Run constrained nelder-mead approach (min_method = 'NMC');
    [c_hat, err, exitflag,output] =fmincon(funName, coeff_0, [],[],[],[],lbound, ubound,[], ...
        optimset('Algorithm', 'interior-point','MaxFunEvals', 5000,'MaxIter',5000,'TolX',1e-10, 'TolFun', 1e-10, 'TolCon', 1e-12, 'Display','off'));
else
    % Otherwise, we run the nelder-mead approach (min_method = 'NM'):
    [c_hat, err, exitflag,output] =fminsearch(funName, coeff_0, optimset('MaxFunEvals', 5000,'MaxIter',5000,'TolX',1e-10, 'TolFun', 1e-10, 'Display','off'));
end
% Record number of iterations needed:
try
    num_iter = output.iterations;
catch
    num_iter = NaN;
end

%% This part evaluates the function using the best-fit coefficients to
%%% get estimates for parameterization data (when Y_in is good), and for
%%% all periods covered by X_eval:

eval(['y_hat = feval(@' funName ',c_hat,X);']); % The predicted values for the selected data points
eval(['y_pred = feval(@' funName ',c_hat,X_eval);']); % The predicted values for all data points

%% Do Stats:
try
    %     [stats.RMSE stats.rRMSE stats.MAE stats.BE stats.R2 stats.Ei] = model_stats(y_hat, Y, 'off');
    stats = model_stats(y_hat, Y, []);
catch
    disp('Warning (fitGEP.m):  Calculating stats failed')
    %     stats.RMSE = NaN; stats.rRMSE = NaN;  stats.MAE = NaN;  stats.BE = NaN;
    %     stats.R2 = NaN; stats.Ei = NaN;
    stats = model_stats([],[],9);
end
sigma = NaN; % Disabled.

%% Put the fixed coefficients back in (if necessary):
%%% Updated 4-Dec-2010 by JJB:
%%% We had to take the fixed value of c_hat out earlier, so that we passed
%%% only the varying coefficients to fminsearch to optimize.
%%% Now, we need to put the fixed coefficient back for the final output:
if sum(coeffs_to_fix) > 0
    c_tmp = fixed_coeff;
    c_tmp(coeffs_to_fix==0) = c_hat(1:end);
    clear c_hat;
    c_hat = c_tmp;
    clear c_tmp;
end    
    
%     for j = 1:1:length(coeffs_to_fix)
%         % Send a warning message if the actual value differs from fixed value:
%         if coeffs_to_fix(j)==1 && c_hat(j)~= fixed_coeff(j)
%             disp(['c_{hat} mismatch for variable ' num2str(j)]);
%             disp(['fixed value = ' num2str(fixed_coeff(j)) ', current value = ' num2str(c_hat(j))]);
%         end
%     end
%     c_hat(coeffs_to_fix==1) = fixed_coeff(coeffs_to_fix==1);
% end
% if sum(coeffs_to_fix) > 0
%     c_hat(coeffs_to_fix==1) = fixed_coeff(coeffs_to_fix==1);
% end
clear fixed_coeff coeffs_to_fix fixed_coeff_tmp coeffs_to_fix_tmp;
