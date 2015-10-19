function [x_out, y_out] = plot_TsLogi(coeff_in, plot_flag, x)


if nargin == 1
    plot_flag = 1;
    x = (-15:1:35)';
elseif nargin == 2
    if isempty(plot_flag)==1
        plot_flag = 1;
    end
    x = (-15:1:35)';
else
    if isempty(x)
        x = (-15:1:35)';
    end
end



num_reps = size(coeff_in,1);
clrs = colormap(lines(num_reps));

if plot_flag ==1
    figure('Name','Ts_coeff_test');clf;
end
RE_pred = NaN.*ones(length(x),num_reps);
for i = 1:1:num_reps
    RE_pred(:,i) = (coeff_in(i,1))./(1 + exp(coeff_in(i,2).*(coeff_in(i,3)-x(:,1))));
    
    
    if plot_flag==1
        h(i) = plot(x,RE_pred(:,i),'.-','Color',clrs(i,:)); hold on;
    end
    % legend_title{i,1} = num2str(i);
    legend_title{i,1} = [num2str(jjb_round(coeff_in(i,1),2)) ', ' num2str(jjb_round(coeff_in(i,2),2)) ', ' num2str(jjb_round(coeff_in(i,3),2))];
    
end

if plot_flag==1
    xlabel('Ts (C)');
    ylabel('RE');
    legend(h,legend_title,'Location','NorthWest', 'FontSize',16)
    grid on;
end

% x_out = [xneg.*ones(length(xneg),num_reps); x.*ones(length(x),num_reps)];
y_out = RE_pred;
x_out = x;