clear all
close all

[yr JD HHMM] = jjb_makedate(2007, 30);
master = [yr JD HHMM];

sf07_path = ('C:\Home\Matlab\Data\met_data\Sapflow\2007\');
D_sf07 = dir(sf07_path);

for i = 10
    load_path = [sf07_path D_sf07(i).name];
 
    rawfile = jjb_loadmet(load_path, 1, 'all');
    fid101 = find(rawfile(:,1)==101);
    
    [row101 col101] = size(rawfile(fid101,:));
    
    startgo = 8193-row101;
    
    master(startgo+1:8193,4:col101) = rawfile(fid101,4:col101);
    
    
 clear rawfile load_path fid101 row101 col101
end
%%%%%
for i = 9
    load_path = [sf07_path D_sf07(i).name];
 
    rawfile = jjb_loadmet(load_path, 1, 'all');
    fid101 = find(rawfile(:,1)==101);
    
    [row101 col101] = size(rawfile(fid101,:));
    
    new_start = startgo;
    startgo = startgo-row101;
    master(startgo+1:new_start,4:col101) = rawfile(fid101,4:col101);
    
clear rawfile load_path fid101 row101 col101
end

for i = 8
    load_path = [sf07_path D_sf07(i).name];
 
    rawfile = jjb_loadmet(load_path, 1, 'all');
    fid101 = find(rawfile(:,1)==101);
    
    [row101 col101] = size(rawfile(fid101,:));
    
    new_start = startgo;
    startgo = startgo-row101;
    master(startgo+1:new_start,4:col101) = rawfile(fid101,4:col101);
    
clear rawfile load_path fid101 row101 col101
end

