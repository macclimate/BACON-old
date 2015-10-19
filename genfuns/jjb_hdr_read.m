function [hdr_cell] = jjb_hdr_read(hdr_txt_path, sep, num_cols)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% jjb_hdr_read %%%%%%%%%%%%%%%%%%%%%%
%%% This function loads a .txt file with headers and other information, and
%%% returns the data in a structure array
% hdr_txt_path = ('C:\Home\Matlab\Data\Met\Organized2\Docs\Met1Output_Columns_2007.txt');
% 'sep' is a string denoting the symbol used to separate different columns
% of information (e.g. '_' or '*')
% num_cols specifies the number of columns in the file to be read-in
% usage: [hdr_cell] = jjb_hdr_read(hdr_txt_path, sep, num_cols)
%%
%%%%% Revision History:
% 29-Jun-2010 by JJB: added a line to remove all quotation marks from lines
% that are read into the program - avoids " in output.

if nargin == 2;
elseif nargin == 1;
     sep = ',';
end


eofstat = 0;
i = 1;

fid = fopen(hdr_txt_path);


while eofstat == 0;
    tline = fgets(fid);
    tline(tline == '"') = ''; %removes all quotation marks
    tline(isspace(tline==1)) = '';
    star = find(tline == sep);
    % notspace = find(~isspace(tline)==1);
    %%% Store data into a structure array %%%%
    % col_num(i,1) = str2double(tline(1:spaces(1)-1));

    star = [0 star length(tline+1)];

    for col = 1:1:length(star)-1
        hdr_cell(i,col) = cellstr(tline(star(col)+1:star(col+1)-1));
    end

    i = i + 1;
    eofstat = feof(fid);

end
