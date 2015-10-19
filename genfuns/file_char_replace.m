function [] = file_char_replace(file_in,char_out,char_in, file_prefix)
% This function opens the desired file, making replacement to a given
% character type and saving a new file with a different name.
% file_in - file to load
% char_out - Character to remove
% char_in - Character to replace removed character ('') to not replace
% file_prefix - specifies the prefix given to a new file.

%%% Created Jan 27, 2009 by JJB:

if nargin == 3;
    file_prefix = 'rep_';
end


[pathstr, name, ext, versn] = fileparts(file_in);
name = [file_prefix name];
file_out = fullfile(pathstr, [name ext versn]);

% Copy file
% copyfile(file_in, copy_file);

fid_in = fopen(file_in,'r');
fid_out = fopen(file_out,'w');

eofstat = 0;

while eofstat == 0;
    %%% Read line of data from file
    tline = fgets(fid_in);
    %%% Replace characters:
    out_cols = find(tline == char_out);
    tline(out_cols) = char_in;
    
    fprintf(fid_out,'%s',tline);
    
    clear tline;
    eofstat = feof(fid_in);
end

% Save file:
fclose(fid_in)
fclose(fid_out)






