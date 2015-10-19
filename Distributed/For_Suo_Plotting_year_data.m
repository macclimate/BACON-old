% Make some random X and Y data:
data = rand(365*5,1).*rand(365.*5,1)+0.5;
x = 1:1:length(data);

%%% Make a loop through years - makes the xticks (for each month)
start_year = 2003; 
end_year = 2007;
days = [];
for i = start_year:1:end_year
[days] = [days; jjb_days_in_month(i)];
end
    month_ticks = cumsum(days)-30;

    
%%% Makes XTickLabels -- makes blanks for labels except in the middle of
%%% each year

% Makes the blanks
for j = 1:1:length(month_ticks)
    mon_label(j,1) = cellstr('');
end
% Makes the labels in the middle of each year
for k = 7:12:length(mon_label)
    mon_label(k) = cellstr(num2str(start_year+ floor(k./12)));
end
    
% set minimum and maximum for the y axis of the graph
min_y = 0;
max_y = 1;

figure(1); clf;
plot(x,data,'--');
set(gca, 'XTick', month_ticks);
set(gca, 'XTickLabel', mon_label);
set(gca, 'TickLength'  , [.005 .01]);
axis([0 x(end)+1 min_y max_y])
box off;
set(gca,'TickDir','in');


%%% Option 1 - I am not sure if this will always work, you may have to
%%% adjust the ./50 part to make proper larger ticks
for p = 13:12:length(month_ticks)
line([month_ticks(p) month_ticks(p)], [min_y (min_y + (max_y-min_y)./50 )  ], 'LineStyle','-', 'Color','k');
end

% %%% Option 2 - This one puts full-sized lines for the start of each year
% for p = 13:12:length(month_ticks)
% line([month_ticks(p) month_ticks(p)], [min_y max_y], 'LineStyle','--', 'Color','k');
% end












    