function[loadstart] = addpath_loadstart(disp_flag)

if ispc ~= 1
    if exist('/home/brodeujj/1/fielddata/Matlab/','dir') ==7;
    loadstart = '/home/brodeujj/1/fielddata/';
    else
        loadstart = '/1/fielddata/';
    end
else
    disp('This function is not currently setup for operation on Windows Machines');
%     
%     if exist('D:/Matlab/','dir')==7; % This takes care of usage on Field PC
%         loadstart = 'D:/';
%     else
% 
%         disp('1 = Windows - School');
%         disp('2 = Windows - Home');
%         disp('3 = Windows - Laptop');
%         disp('9 = Windows -- Run From portable drive');
%         resp = input('Enter a number to select the setup you wish to run: ');
% 
% 
%         switch resp
%             case 1
%                 loadstart = 'D:/home/';
%             case 2
%                 loadstart = 'D:/home/';
%             case 3
%                 loadstart = 'C:/home/';
%             case 9
%                 loadstart = 'E:/home/brodeujj/';
%         end
%     end
end

assignin('base', 'loadstart', loadstart)

% end
if nargin == 0 || strcmp(disp_flag,'off') == 1
else
disp(['loadstart = ' loadstart]);
end
%%
%
% if ispc == 1
%     if exist('D:/home/') == 7;
%     loadstart = 'D:/home/';
%     else
%             loadstart = 'C:/HOME/';
%     end
% else
%     if exist('/home/brodeujj/') == 7;
%     loadstart = '/home/brodeujj/';
%     elseif exist('/home/jayb/') == 7
%     loadstart = '/home/jayb/';
%     elseif exist('/media/storage/home/');
%         loadstart = '/media/storage/home/';
%     end
% end
%
% assignin('base', 'loadstart', loadstart)