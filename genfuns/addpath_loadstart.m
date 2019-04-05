function[loadstart] = addpath_loadstart(disp_flag)

if ispc ~= 1
    if exist('/home/brodeujj/1/fielddata/Matlab/','dir') ==7
    loadstart = '/home/brodeujj/1/fielddata/';
    elseif exist('/work/brodeujj/1/fielddata/Matlab/','dir')==7
    loadstart = '/work/brodeujj/1/fielddata/';
    else
        loadstart = '/1/fielddata/';
    end
else
     if exist('\\130.113.210.243\fielddata\Matlab\','dir') ==7
        loadstart = '\\130.113.210.243\fielddata\';
     else
        disp('This function is not currently setup for operation on this machine');
     end
end

assignin('base', 'loadstart', loadstart)

% end
if nargin == 0 || strcmp(disp_flag,'off') == 1
else
disp(['loadstart = ' loadstart]);
end

