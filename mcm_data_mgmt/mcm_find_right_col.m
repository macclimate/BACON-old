function [right_col] = mcm_find_right_col(label_list,label_in)
%%% mcm_find_right_col.m
%%% This function finds the correct column in a master data file by
%%% searching through the label list that is inputted to the funtion.
%%% inputs 
%%%% label_list - is the list of variable names (either cell or string)
%%%% label_in --- the string name of variable in the master file that you
%%%% want to load.
%%% Created July 19, 2010 by JJB.

%%% Convert character array to cell array if label_list is in that form:
if ischar(label_list)==1
    label_list = cellstr(label_list);
else
    r1 = size(label_list,1);
    for j = 1:1:r1
        tmp = label_list{j,:};
        tmp(tmp == ' ') = '';
        label_list_new{j,1} = tmp;
        clear tmp;
    end
    clear label_list;
    label_list = label_list_new;
    clear label_list_new;
end

%%%% Find the Right Row:
c = size(label_list,2);
right_col = [];
col_ctr = 1;

while isempty(right_col)==1 && col_ctr <= c
    %     for col_ctr = 3:1:c
    %     try
    right_col = find(strcmp(label_in,label_list(:,col_ctr))==1);
    %     catch
    %     right_col = find(strncmp(label_in,label_list(:,1),length(label_in))==1);
    %     end
    col_ctr = col_ctr+1;
end
end