function [loadstart] = mcm_loadstart

if ispc == 1;
    loadstart = 'D:/Matlab/';
else
    loadstart = 'media/Storage/Matlab/'; % <-- this will have to be changed.
end

assignin('base', 'loadstart', loadstart)

disp(['loadstart = ' loadstart]);
