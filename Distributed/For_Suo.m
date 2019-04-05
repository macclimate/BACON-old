model = (1:1:10)' + 2.*rand(10,1);
meas = (1:1:10)' + 2.*rand(10,1);

figure(1); clf;
subplot(2,2,1);
plot(meas, model,'k.');
axis([0 12 0 12])
 box on;

subplot(2,2,2);
plot(meas, model,'ro');
axis([0 12 0 12])

%1:1 Line
hold on;
plot([0 12], [0 12],'k--', 'LineWidth',1.5)
box on;
% RMSE values
[RMSE rRMSE MAE BE] = model_stats(model, meas); % calculates stats
text(5,4, ['RMSE = ' num2str((round(100.*RMSE))./100)], 'FontSize',16); % writes text at the x and y coordinates
text(5,2, ['MAE = ' num2str((round(100.*MAE))./100)], 'FontSize',16);
set(gca, 'FontSize',16) % sets the fontsize for everything in subplot

subplot(2,2,3);
plot(meas, model,'bx');
axis([0 12 0 12])
box on;
ylabel('Modeled Data');
xlabel('Measured Data');

subplot(2,2,4);
plot(meas, model,'mp');
axis([0 12 0 12])
box on;


