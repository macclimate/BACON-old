function [ok_flag] = find_ok_SM_coeffs(coeff_in)
%%% Criteria we are looking for to give an 'ok' rating to a set of SM
%%% logistic function coefficients:
% 1. Scaling factor increases with increasing SM value
% 2. Function Peaks by the time SM=1
% 3. Function Peaks after 0.05 (or else it's useless)
% Meaning of flags:
% 0: function decreases
% 1: function pases -- appears good
% 2: function does not top out at high SM
% -1: function serves no purpose(tops out before reaching meaningful SM
x = (-0.5:0.001:0.5)';
num_reps = size(coeff_in,1);
clrs = colormap(lines(num_reps));
hp = coeff_in(:,1)./coeff_in(:,2);

% figure('Name','SM_coeff_test');clf;
SM_pred = NaN.*ones(length(x),num_reps);
% SM_pred_neg = NaN.*ones(length(xneg),num_reps);

for i = 1:1:num_reps
    SM_pred(:,i) = 1./(1 + exp(coeff_in(i,1)-coeff_in(i,2).*x(:,1)));
    dsf = diff(SM_pred(:,i));
    % Make sure the function is increasing with increasing SM
    if length(find(dsf>=0)) == (length(x)-1)
        incr_flag(i,1) = 1;
    else
        incr_flag(i,1) = 0;
    end
    % Check if the function makes it to 0.95 by the time it gets to SM=1
    if SM_pred(end,i) < 0.95
        pass_flag1(i,1) = 2;
    else
        % if it does, see where it gets to 0.95
        if x(find(SM_pred(:,i)>=0.95,1,'first'))<0.05
            pass_flag1(i,1) = -1;
        else
            pass_flag1(i,1) = 1;
        end
    end
    clear dsf;
end
ok_flag = incr_flag.*pass_flag1;

