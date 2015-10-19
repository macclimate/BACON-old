function [] = jjb_play_sounds(sound_type)
if nargin == 0
    sound_type = 'done';
end

addpath = addpath_loadstart;
sound_path = [addpath '/Matlab/Other/Sounds/'];
selectn = 0;
r = rand(100,1);
i = 1;
d = dir([addpath '/Matlab/Other/Sounds/']);

if ispc ~= 1
    try
        switch sound_type
            case 'done'
                while selectn < 3
                selectn = round(r(i).*size(d,1));
                i = 1+1;
                end
                
                [status, result] = unix(['mplayer ' sound_path d(selectn).name]);

            case 'error'
                [status, result] = unix(['mplayer ' sound_path 'homcra.wav']);
            case 'continue'
                 [status, result] = unix(['mplayer ' sound_path 'anykey.WAV']);
             

        end


    catch
        disp('To play sounds you need to install mplayer, or install the data files');
        disp('use <sudo apt-get install mplayer-nogui> in terminal');

    end


end