
clear all
close all

open_path = ('C:\Home\Matlab\Data\Organized\Met1\Column\30min\');

%%%% load shf files for 2007
H_flux1 = load([open_path 'Met1_2007.080']);
H_flux2 = load([open_path 'Met1_2007.081']); 

shf1 = load([open_path 'Met1_2007.072']);
shf2 = load([open_path 'Met1_2007.073']);

cal1 = load([open_path 'Met1_2007.076']);
cal2 = load([open_path 'Met1_2007.077']);
x_axis = (1:1:17520);
x_axis365 = (x_axis./48);



figure (1)
subplot(3,1,1)
plot (x_axis,H_flux1,'rx-')
hold on
plot (x_axis,H_flux2,'bx-')
legend ('H_flux1', 'H_flux2');
grid on;
axis ([1 9000 -15 25]);

subplot(3,1,2)
plot (x_axis,shf1,'rx-')
hold on
plot (x_axis,shf2,'bx-')
legend ('shf1', 'shf2');
grid on;
axis ([1 9000 -5 25]);

subplot(3,1,3)
plot (x_axis,cal1,'rx-')
hold on
plot (x_axis,cal2,'bx-')
legend ('cal1', 'cal2');
grid on;
axis ([1 9000 0 20]);

figure (2)
clf;
subplot(2,1,1);
plot (x_axis,H_flux1,'rx-')
hold on
plot (x_axis,shf1,'gx-')
axis ([1 9000 -15 25]);
grid on;

subplot(2,1,2);
plot (x_axis,H_flux2,'rx-')
hold on
plot (x_axis,shf2,'gx-')
axis ([1 9000 -15 25]);
grid on;
