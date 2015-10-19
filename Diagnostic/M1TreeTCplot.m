clear all
close all

path = ('C:\Home\Matlab\Data\Met\Organized2\Met1\Column\30min\');

Tair = load ([path 'Met1_2007.008']);
for i  = 40:1:61

Trees(:,i-39) = load([path 'Met1_2007.' create_label(i,3)]);
end


figure(1)
plot(Tair,'r-')
hold on;
T1 = plot(Trees(:,1),'b-');
T2 = plot(Trees(:,2),'g-');
T3 = plot(Trees(:,3),'y-');
T4 = plot(Trees(:,4),'m-');
T5 = plot(Trees(:,5),'c-');
T6 = plot(Trees(:,5),'k-');

h1 = [T1 T2 T3 T4 T5 T6]

legend(h1, 'T1', 'T2', 'T3', 'T4', 'T5', 'T6');
axis ([1 17520 -10 30]);

figure (2)

plot(Tair,'r-')
hold on;
T7 = plot(Trees(:,7),'b-');
T8 = plot(Trees(:,8),'g-');
T9 = plot(Trees(:,9),'y-');
T10 = plot(Trees(:,10),'m-');
T11 = plot(Trees(:,11),'c-');


h2 = [T7 T8 T9 T10 T11]

legend(h2, 'T7', 'T8', 'T9', 'T10', 'T11');
axis ([1 17520 -10 30]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure (3)

plot(Tair,'r-')
hold on;
T12 = plot(Trees(:,12),'b-');
T13 = plot(Trees(:,13),'g-');
T14 = plot(Trees(:,14),'y-');
T15 = plot(Trees(:,15),'m-');
T16 = plot(Trees(:,16),'c-');


h3 = [T12 T13 T14 T15 T16]

legend(h3, 'T12', 'T13', 'T14', 'T15', 'T16');
axis ([1 17520 -10 30]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure (4)
clf;

plot(Tair,'r-')
hold on;
T17 = plot(Trees(:,17),'b-');
T18 = plot(Trees(:,18),'g-');
T19 = plot(Trees(:,19),'y-');
T20 = plot(Trees(:,20),'m-');
T21 = plot(Trees(:,21),'c-');
T22 = plot(Trees(:,21),'k-');


h4 = [T17 T18 T19 T20 T21 T22]

legend(h4, 'T17', 'T18', 'T19', 'T20', 'T21', 'T22');
axis ([1 17520 -10 30]);

save('C:\Tree_TC_2007.dat', 'Trees','-ASCII');
