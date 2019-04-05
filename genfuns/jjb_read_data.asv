function [out] = jjb_read_data(file_path,delim)
%% This function reads data in a file containing text with or without
%%% numbers as well.  'delim' specifies the character used as a delimiter.
%%% This function outputs a cell array containing all data.
%%% Created by JJB, April 24, 2008.

fid = fopen(file_path);

if nargin < 2
    delim = [];
end

if isempty(delim)==1
    delim = ',';
    disp('No delimiter specified, using commas');
end

j = 1;
eofstat = 0;
while eofstat == 0;
    
    %%% Read line of data from file
    tline = fgets(fid);
    
    %%% Find commas
    star = find(tline == delim);
    cols = length(star) + 1;
    
    %%% Read first column if only one column exists:
    if cols == 1
    out(j,1) = cellstr(tline(1:length(tline)));
    %%% If only two columns exist:
    elseif cols==2
    out(j,1) = cellstr(tline(1:star(1)-1));
    out(j,cols) = cellstr(tline(star(cols-1)+1:length(tline)));
    
    else    
    %%% Write first column
    out(j,1) = cellstr(tline(1:star(1)-1));
    %%% Write middle columns
    for ctr = 2:1:cols-1
    out(j,ctr) = cellstr(tline(star(ctr-1)+1:star(ctr)-1));
    end
    %%% Write final column
    out(j,cols) = cellstr(tline(star(cols-1):length(tline)));
    end
    
    j = j+1;
    eofstat = feof(fid); %% checks if MATLAB is at the end of the file - if not, goes around again

end