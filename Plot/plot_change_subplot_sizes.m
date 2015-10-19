site = 'TP39';
% %%% Paths:
% ls = addpath_loadstart;
% load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
% save_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
% footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Load gapfilling file and make appropriate adjustments:
% load([load_path site '_gapfill_data_in.mat']);
% data = trim_data_files(data,2003, 2009,1);
% data.site = site;
% close all

% Ta = data.Ta(data.Year == 2005);
% PAR = data.PAR(data.Year == 2005);
% RH = data.RH(data.Year == 2005);
% WS = data.WS(data.Year == 2005);
% f1 = figure(1);clf
% sh1 = subplot(1,4,1); plot(Ta);
% sh2 = subplot(1,4,2); plot(PAR);
% sh3 = subplot(1,4,3); plot(RH);
% sh4 = subplot(1,4,4); plot(WS);

test = rand(10000,4);

f1 = figure(1);clf
sh1 = subplot(1,4,1); plot(test(:,1));
sh2 = subplot(1,4,2); plot(test(:,2));
sh3 = subplot(1,4,3); plot(test(:,3));
sh4 = subplot(1,4,4); plot(test(:,4));

set(f1,'Units', 'normalized') 
set(sh1, 'Position', [0.05, 0.4, 0.2, 0.2]);
set(sh1, 'YTick',[-1:0.2:1])
set(sh1, 'YTickLabel', []);
set(sh2, 'Position', [0.30, 0.4, 0.2, 0.2])
set(sh3, 'Position', [0.55, 0.4, 0.2, 0.2])
set(sh4, 'Position', [0.80, 0.4, 0.2, 0.2])


figure(2);axes;
plot(test(:,1))
set(gca,'XTick',
xlabel('not to change')
ylabel('\bfElectrode channel')
h = findobj('string','\bfElectrode channel');
set(h,'FontSize',24) 