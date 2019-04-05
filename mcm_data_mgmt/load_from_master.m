function [var_out, varargout] = load_from_master(struct_in, var_to_find)
%% load_from_master.m:
%%% This function is used to load a variable in a master file, using it's variable name in the 
%%% 'labels' structure.  struct_in is the structure variable with both the data and labels in it, and
%%% var_to_find is a string name of the variable you want to load.
%%% usage:
% var_out = load_from_master(struct_in, var_to_find) OR
% [var_out column_number] = load_from_master(struct_in, var_to_find)
%%% Created sometime by JJB

[r c] = size(struct_in.labels);
% var_to_find = 'Hs';
right_row = [];
for i = 1:1:r
    try
        % loads data from a string array
    test(i,1) = strncmp(var_to_find, struct_in.labels(i,:),length(var_to_find));
    catch
        % loads from a cell array
    test(i,1) = strcmp(var_to_find, char(struct_in.labels(i,1)));
    end        
end
    right_col = find(test == 1);
    
    if isempty(right_col)
        disp(['Cannot find the right row for the variable ' var_to_find])
    var_out = [];
    else
        var_out = struct_in.data(:,right_col);
    end

    nout = max(nargout,1)-1;
    for k = 1:nout
        varargout = {right_col};
    end
%     if nargout == 1
%         varargout = var_out;
%     else 
%         varargout = [right_col var_out];
%     end
end    
    