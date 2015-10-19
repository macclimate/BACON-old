x = load('C:\HOME\MATLAB\Data\Met\Organized2\Met1\Column\30min\Met1_2004.081');
y = load('C:\HOME\MATLAB\Data\Met\Organized2\Met1\Column\30min\Met1_2004.080');

%% Load soil heat storage component:
hstor = load('C:\HOME\MATLAB\Data\Met\Calculated4\Met1\Met1_2004_soil_Hstor.dat');
x = x + hstor;
y = y + hstor;
x(5975:8380) = NaN;

figure(23); clf; hold on; plot(TP39_04(:,23),'r'); %plot(TP39_03(:,23),'b');plot(TP39_04(:,23),'r');plot(TP39_05(:,23),'g');plot(TP39_06(:,23),'c');plot(TP39_07(:,23),'m');
plot(y,'b'); axis([1 18000 -40 140]); plot(x,'g');

figure(94)
plot(x,TP39_04(:,23),'r.');hold on
axis([-20 100 -20 100])
ok_x = find (~isnan(x) & ~isnan(TP39_04(:,23)) & abs(x) < 40 & abs(TP39_04(:,23)) < 150);
px = polyfit(x(ok_x),TP39_04(ok_x,23),1);
pred_G = polyval(px,x(ok_x));
plot(x(ok_x),pred_G,'g.')
plot(x(ok_x),x(ok_x).*4,'b')



figure(95)
plot(y,TP39_04(:,23),'r.');hold on;
axis([-20 100 -20 100])
ok_y = find (~isnan(y) & ~isnan(TP39_04(:,23)) & abs(y) < 40 & abs(TP39_04(:,23)) < 150);
py = polyfit(y(ok_y),TP39_04(ok_y,23),1);
pred_G2 = polyval(py,y(ok_y));
plot(y(ok_y),pred_G2,'g.')
plot(y(ok_y),y(ok_y).*4,'b')