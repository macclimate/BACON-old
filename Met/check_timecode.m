
%% 
% This function compares inputted downward PAR to estimated suntimes, to
% try and help figure out what timecode is being used with the data - and if it
% changes throughout the year:
%
% inputs:
% year
% site
clear all;
year = '2008';
site = 'TP02';
% Load data from /Cleaned3 folder (or should I use /Organized2 folder?)
loadstart = addpath_loadstart;
% loadstart = addpath_loadstart_portable;

%%% load header
hdr = jjb_hdr_read([loadstart 'Matlab/Data/Met/Raw1/Docs/' site '_OutputTemplate.csv'], ',', 3);
%%% Use header to find the extension for PAR, and load it:
right_ext = str2num(char(hdr((strcmp(hdr(:,2),'DownPAR_AbvCnpy')==1),1)));
right_ext = create_label(right_ext, 3);
PAR = load([loadstart 'Matlab/Data/Met/Organized2/' site '/Column/30min/' site '_' year '.' right_ext]);

TP39st = make_suntimes_year(year, site);

figure(1); clf
plot(PAR,'r'); hold on;
plot(TP39st,'b--');
grid on;

ctr = 1;
for k = 2:1:length(TP39st);
    if PAR(k,1) >0 && PAR(k-1,1) == 0
        meas_sr(ctr,1) = k;
        ctr = ctr+1;
    end
end

ctr = 1;
for j = 2:1:length(TP39st);
    if TP39st(j,1) >0 && TP39st(j-1,1) == 0
        pred_sr(ctr,1) = j;
        ctr = ctr+1;
    end
end


% %%% Load latitude and longitude using params.m:
% [final] = params(year, site, 'Sun');
% lat = final(1);
% long = final(2);
% 
% %%% Use suntimes.m to calculate sun_up and sundown times
% for j = 1:1:365
% [srhr(j,1) srmin(j,1) sshr(j,1) ssmin(j,1) snhr(j,1) snmin(j,1)] = suntimes(lat, long, j, 0);
% end






