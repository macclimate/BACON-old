clear all;
close all;
addpath_loadstart;
path = [loadstart '/Matlab/Data/PPT/Raw_Delhi_Files/Daily/'];

%% Get original data
D = dir(path);
for i = 3:1:length(D)
if  isdir(D(i).name) == 0 && strcmp(D(i).name(1:3),'eng') ==1
    to_load(i,1) = 1;
else to_load(i,1) = 0;
end
end

ok_files = find(to_load == 1);

%%% Replace characters in original file and save as temp file
for j = 1:length(ok_files)
EC_replace([path D(ok_files(j)).name],'ren_');
end

%% 
D2 = dir(path);

%%% Find which files we should load
for i = 3:1:length(D2);
    if strcmp(D2(i).name(1:4),'ren_') ==1;
        new_files(i,1) = 1;
    else
        new_files(i,1) = 0;
    end
end

to_load2 = find(new_files == 1);
    
%%% Load files and take out needed column (can look at produced header file
%%% to find necessary columns:
for j = 1:length(to_load2)
    len = length(D2(to_load2(j)).name);
    rain(j).year = D2(to_load2(j)).name(len-7:len-4);
    tmp = dlmread([path D2(to_load2(j)).name],',');
    rain(j).data =  tmp(:,19);
    
clear len tmp;
end
%% Put data in one file:
delhi_PPT_02_08 = NaN.*ones(366,k);
for k = 1:1:length(rain)
delhi_PPT_02_08(1:length(rain(k).data),k) = rain(k).data;
end

save([loadstart 'Matlab/Data/PPT/Delhi_PPT_02-08.dat'],'delhi_PPT_02_08','-ASCII');