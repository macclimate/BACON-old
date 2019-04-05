function [f1] = eval_SMcoeffs(coeff_in)

if nargin == 0
    plot_flag = 0;
else
    plot_flag = 1;
end

r = 2.*rand(2000,2)-1;
mids = [12.55 176];
ranges = [12.5 175];
for i = 1:1:length(r)
    coeff_test(i,1:2) = mids +r(i,1:2).*ranges;
end

ok_flag = find_ok_SM_coeffs(coeff_test(:,1:2));
% Meaning of flags:
% 0: function decreases
% 1: function pases -- appears good
% 2: function does not top out at high SM
% -1: function serves no purpose(tops out before reaching meaningful SM
% axis([0 10000 0 1000 0 500])
f1 = figure('Name','SM-Coeff Categories');clf
ind_1 = find(ok_flag == 1);
h1(1) = plot(coeff_test(ind_1,1), coeff_test(ind_1,2),'o','MarkerEdgeColor',[0.2 0.8 0.5],'MarkerFaceColor',[0.2 0.8 0.5],'MarkerSize',10); hold on;
ind_m1 = find(ok_flag==-1);
h1(2) = plot(coeff_test(ind_m1,1), coeff_test(ind_m1,2),'o','MarkerEdgeColor',[0.4 0.2 0.5],'MarkerFaceColor',[0.4 0.2 0.5],'MarkerSize',10); hold on;
ind_2 = find(ok_flag==2);
h1(3) = plot(coeff_test(ind_2,1), coeff_test(ind_2,2),'o','MarkerEdgeColor',[0.9 0.6 0.2],'MarkerFaceColor',[0.9 0.6 0.2],'MarkerSize',10); hold on;
grid on;

if plot_flag ==1
%     h1(4) = plot(coeff_in(1,1), coeff_in(1,2),'s','Color','k','MarkerFaceColor',[0.9 0.1 0.1],'MarkerSize',12); hold on;
    for k = 1:1:size(coeff_in,1)
%         plot(coeff_in(k,1), coeff_in(k,2),'s','Color','k','MarkerFaceColor',[0.9 0.1 0.1],'MarkerSize',12);
        text(coeff_in(k,1), coeff_in(k,2),num2str(k),'Color','k','FontSize',8,'BackgroundColor','r')
    end
    legend({'good','no-use','no-top'})
    axis([-5 30 -50 400])
else
    legend(h1,{'good','no-use','no-top'})
    axis([0 25 0 350])
end