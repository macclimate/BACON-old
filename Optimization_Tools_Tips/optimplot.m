function stop = optimplot(x, optimValues, state)
% plots the current point of a 2-d otimization
stop = [];
hold on;
plot(x(1),x(2),'.');
drawnow

