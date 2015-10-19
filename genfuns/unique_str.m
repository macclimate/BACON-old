function [list_out] = unique_str(cell_in, skip_NaN_flag)
%%% This function will find the unique strings in a cell array
%%% The first column of output will be the unique strings, while the second
%%% column will be a list of the rows in the input cell file that these
%%% strings can be found:
%%% If skip_NaN_flag = 1, then NaNs will be ignored

%%% Created Jan 25, 2011 by JJB


if nargin == 1
    skip_NaN_flag = 0;
end

%%% Part One: Find unique strings
list_out = {};
for i = 1:1:length(cell_in)
   s = size(list_out,1);
    if isempty(find(strcmp(list_out,cell_in{i,1}), 1))==1;
        if skip_NaN_flag ==1 && strcmp(cell_in{i,1},'NaN')==1
        else
       list_out{s+1,1} = cell_in{i,1};
        end
   end
    
end

%%% Second Part: 
for k = 1:1:length(list_out)
    list_out{k,2} = find(strcmp(cell_in,list_out{k,1})==1);
end
