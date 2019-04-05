clear all
close all

sf_path = ['C:\Home\Matlab\Data\Organized\Sapflow\Column\30min\'];
sf_rain = load([sf_path 'Metsf_2006.023']);

M1_path = ['C:\Home\Matlab\Data\Organized\Met1\Column\30min\'];
M1_rain = load([M1_path 'Met1_2006.017']);
M1_par_d = load([M1_path 'Met1_2006.016']);
M1_par_u = load([M1_path 'Met1_2006.015']);
M1_Ws = load([M1_path 'Met1_2006.013']);

figure (1)
plot(sf_rain,'r-');
hold on;
plot(M1_rain,'b-');
axis([0 17520 0 10]);

figure (2)
clf;
plot(M1_rain,'b-');
hold on;
plot(M1_par_u./800,'r-');
plot(M1_Ws./1.5,'g-');
axis([0 17520 0 10]);

%     metload(D_sf(i).name, 'Metsf_Input0406_.txt', 2006, 'sf')
% end
