% CCP_file_editor.m
% This program edits CCP files, to make any changes to the variables after
% the fact:
ls = addpath_loadstart;
path = [ls 'Matlab/Data/CCP/Final_dat/'];
%% Fix 1: 
% TP74 data for 2007 - Some wind data is bad, which hasn't been fixed:
TP74_2007 = load([path 'TP74_final_2007.dat']);
header = jjb_hdr_read([ls 'Matlab/Data/CCP/Template/TP74_CCP_List.csv'],',',2);
% Plot all variables:
close all;
all_ctr = 6;
    ctr = 1;
    fig_ctr = 1;
    for i = 6:1:70
        figure(fig_ctr)
        subplot(3,2,ctr)
        plot(TP74_2007(:,i));
        title([char(header(all_ctr,1)) ': column ' num2str(i)] );
    ctr = ctr+1;
    if ctr == 7
        ctr = 1;
        fig_ctr = fig_ctr+1;
    end
    all_ctr = all_ctr+1;
    end
    % Remove errors in wind data:
    TP74_2007([688:1073 4343:5732]',32:33) = NaN;
    % Re-save file:
    save([path 'TP74_final_2007.dat'], 'TP74_2007','-ASCII');
    
    
%% Fix 2: 
% TP89 data for 2007 - Some wind data is bad, which hasn't been fixed:
TP89_2007 = load([path 'TP89_final_2007.dat']);
header = jjb_hdr_read([ls 'Matlab/Data/CCP/Template/TP89_CCP_List.csv'],',',2);
% Plot all variables:
close all;
all_ctr = 6;
    ctr = 1;
    fig_ctr = 1;
    for i = 6:1:70
        figure(fig_ctr)
        subplot(3,2,ctr)
        plot(TP89_2007(:,i));
        title([char(header(all_ctr,1)) ': column ' num2str(i)] );
    ctr = ctr+1;
    if ctr == 7
        ctr = 1;
        fig_ctr = fig_ctr+1;
    end
    all_ctr = all_ctr+1;
    end
    % Remove errors in wind data:
     TP89_2007([695:1238]',32:33) = NaN;
    % Re-save file:
    save([path 'TP89_final_2007.dat'], 'TP89_2007','-ASCII');
    
    %% Fix 3:
    % TP02 PAR data for 2003--2006 needs to be multiplied by 1.2419
%         TP02_2003 = load([path 'TP02_final_2003.dat']);
%         TP02_2004 = load([path 'TP02_final_2004.dat']);
%         TP02_2005 = load([path 'TP02_final_2005.dat']);
%         TP02_2006 = load([path 'TP02_final_2006.dat']);
%         
% TP02_2003(:,27) = TP02_2003(:,27).*1.2419;
% TP02_2004(:,27) = TP02_2004(:,27).*1.2419;
% TP02_2005(:,27) = TP02_2005(:,27).*1.2419;
% TP02_2006(1:7371,27) = TP02_2006(1:7371,27).*1.2419;
%     save([path 'TP02_final_2003.dat'], 'TP02_2003','-ASCII');
%     save([path 'TP02_final_2004.dat'], 'TP02_2004','-ASCII');
%     save([path 'TP02_final_2005.dat'], 'TP02_2005','-ASCII');
%     save([path 'TP02_final_2006.dat'], 'TP02_2006','-ASCII');

%% Fix 4

% header = jjb_hdr_read([ls 'Matlab/Data/CCP/Template/TP89_CCP_List.csv'],',',2);
