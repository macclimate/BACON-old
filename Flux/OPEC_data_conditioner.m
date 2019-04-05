function [] = OPEC_data_conditioner(conv_path)
ls = addpath_loadstart;
% if ischar(site)
% else
% disp('Be sure to enter site as a string');
% end
% 
% %dir_path = uigetdir([ls 'Matlab/Data/Flux/OPEC/Raw1'],'Select Folder to Process');
% dir_path = [ls 'Matlab/Data/Flux/OPEC/Raw1/' site '/DAT_all'];
% D = dir(dir_path);
% %out_path = uigetdir([ls 'Matlab/Data/Flux/OPEC/Raw1'],'Select Folder for Output');
% out_path = [ls 'Matlab/Data/Flux/OPEC/Raw1/' site '/DAT_all_L1'];
if nargin == 0 ||isempty(conv_path)==1
conv_path = uigetdir([ls 'SiteData/'],'Navigate to /Converted folder for conditioning');
disp(conv_path);
end
% Put an '/' at the end of the path if it's not there already:
if conv_path(end) == '/';
else
    conv_path = [conv_path '/'];
end

D = dir(conv_path);

% Establish the proper directory for the Conditioned data:
t = findstr(conv_path,'/Converted/');
out_path = [conv_path(1:t) 'Conditioned/'];
jjb_check_dirs(out_path,0);

if length(D) > 2
    for i = 3:length(D)
        filenames{i-2,1} = D(i).name;
    end
    num_files = length(filenames);

    for fnum = 1:1:num_files
        disp(['now loading file ' conv_path char(filenames{fnum,1}) ', file '  num2str(fnum) ' of ' num2str(num_files)]);
        %         [s(fnum), msg(fnum)] = replaceinfile('-1.#IND', 'NaN', [dir_path '/' char(filenames{fnum,1})], [dir_path '/' char(filenames{fnum,1}) '.cl.']);
        %% Loads orginal and creates output file:
        fid = fopen([conv_path '/' char(filenames{fnum,1})]);
        fid_out = fopen([out_path '/' char(filenames{fnum,1}) 'L1'],'w');

        eofstat = 0;
        ctr = 1;
        while eofstat == 0;
            clear tline;
            %%% Replaces all quotation marks
            tline = fgets(fid);
            tline(tline == '"') = '';
           

            if ctr > 4
            %%% Replaces F's with D's (some files have -1.#INF instead of
            %%% -1.#IND)
            tline(tline == 'F') = 'D';
              %%% Makes sure that the timestamps are all in the proper format:
                first_col = find(tline == ',',1,'first');
                ts = tline(1:first_col-1);
                dashes = find(ts == '-'); % finds hyphens in date
                spce = find(ts == ' '); %finds space btw date and time
                if dashes(2) - dashes(1) == 2
                    tline = [tline(1:5) '0' tline(6:end)];
                end
                if spce - dashes(2) == 2
                    tline = [tline(1:8) '0' tline(9:end)];
                end
            %%% Also have to fix the problem where sometimes we get '1.#INF' 
            %%% instead of '-1#INF'
                b = findstr(',1.#IND',tline);
                added_chars = 0;
            for k = 1:1:length(b)
               tline = [tline(1:b(k)+added_chars) '-' tline(b(k)+added_chars+1:end)];
                added_chars = added_chars+1;
            end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% OUTPUT:
            fprintf(fid_out, ['%' num2str(length(tline)) 's'], tline);
            ctr = ctr+1;
            eofstat = feof(fid);
        end

        fclose(fid);
        fclose(fid_out);
    end
else
    disp('no files in the directory. ');
end
