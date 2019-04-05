function [x_out, y_out] = plot_TsQ10(coeff_in, plot_flag)


if nargin == 1
plot_flag = 1;
end

x = (-15:1:30)';
num_reps = size(coeff_in,1);
% clrs = colormap(lines(num_reps));
clrs = jjb_get_plot_colors;
if plot_flag ==1 
figure('Name','Ts_coeff_test');clf;
end
RE_pred = NaN.*ones(length(x),num_reps);
for i = 1:1:num_reps
RE_pred(:,i) = coeff_in(i,1).*coeff_in(i,2).^((x(:,1) - 10)./10);
if plot_flag==1
h(i) = plot(x,RE_pred(:,i),'.-','Color',clrs(i,:)); hold on;
end
legend_title{i,1} = num2str(i);
end

if plot_flag==1
xlabel('Ts (C)');
ylabel('RE');
legend(h,legend_title)
end

% x_out = [xneg.*ones(length(xneg),num_reps); x.*ones(length(x),num_reps)];
y_out = RE_pred;
x_out = x;