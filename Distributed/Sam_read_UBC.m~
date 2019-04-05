loadstart = addpath_loadstart;

fid = fopen('/home/brodeujj/Matlab/Data/Distributed/BC-DF49_FlxTwr_SM3_2003-01-00.csv');

j = 1;
eofstat = 0;


while eofstat == 0;
    %%% Read line of data from file
    tline = fgets(fid);
    %%% Find commas
    tline(length(tline)+1) = ','
    star = find(tline == ',');
    cols = length(star);
    %%% Write first column
%     if j = 1;
        for i = 1:1:cols+1
%     
    
    name(j,:) = cellstr(tline(1:star(1)-1));
    %%% Write middle columns
%     data(j,1) = NaN;
    for ctr = 2:1:cols
    data(j,ctr-1) = str2double(tline(star(ctr-1)+1:star(ctr)-1));
    end
    %%% Write final column
    data(j,cols) = str2double(tline(star(cols):length(tline)));

    j = j+1;
    eofstat = feof(fid);

end