function[a] = read_bin(loc, cols)
fid = fopen(loc, 'r');
a = fread(fid, [cols,500], 'int16');
a = a';
fclose(fid);

