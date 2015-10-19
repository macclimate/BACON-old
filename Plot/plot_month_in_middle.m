Ta = data.Ta(data.Year == 2005);

a = jjb_days_in_month(2005);
month_ticks = [1; cumsum(a(1:end-1)).*48];
mon_labels = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};

figure(1);clf;
plot(Ta); 
set(gca, 'XTick',month_ticks+(15*48), 'XTickLabel', mon_labels, 'TickLength',[0 0])

% min, max values of x and y on the graph:
ymin = -30;
ymax = 35;
xmin = 1;
xmax = 17520; 
% set axis limits to min and max:
axis([xmin xmax ymin ymax])

y_ticklen = 1; % how long the ticks are -- depends on the units in graph:
x_ticklen = 300; % how long the ticks are -- depends on the units in graph:

%% Draw the ticks on:
for i = 1:1:length(month_ticks)
    figure(1); hold on
    % XTicks
plot([month_ticks(i) month_ticks(i)], [ymin ymin+y_ticklen], 'k-','LineWidth',1)  
plot([month_ticks(i) month_ticks(i)], [ymax ymax-y_ticklen], 'k-','LineWidth',1)  
end

%% Draw on YTicks:

for yt = ymin:5:ymax
   figure(1); hold on
    % YTicks
plot([xmin xmin+x_ticklen], [yt yt], 'k-','LineWidth',1)  
plot([xmax xmax-x_ticklen], [yt yt], 'k-','LineWidth',1)    
end