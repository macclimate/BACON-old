function [] = GOES_extract_tif()
ls = addpath_loadstart;
savepath = [ls 'Matlab/Data/wx_kmz/GOES/'];

d = dir(savepath);

for i = 1:1:length(d)
    [pathstr, name, ext] = fileparts(d(i).name);

    if d(i).isdir == 0 && strcmp(ext,'.kml') == 1
        ftype = name(6:9);
        
        fid = fopen([savepath d(i).name]);
            eofstat = 0;
            while eofstat ~=1
                tline = fgets(fid);
                checkline = strfind(tline,'http://goes.gsfc');
                if ~isempty(checkline)==1
                    endofstring = strfind(tline,'</href>');
                    tif_URL = tline(checkline:endofstring-1);
                    fname_out = ['GOES-' ftype '_' tif_URL(end-13:end)];
                    [filestr, status] = urlwrite(tif_URL,[savepath fname_out]);
                end
                clear tline checkline endofstring tif_URL
                eofstat = feof(fid);
            end
            fclose(fid);
        clear ftype;
        
    else 
    end
end
end
