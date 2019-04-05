function [var_out] = jjb_load_var(hdr_cell, load_path, var_string,comp_col)
% % load the needed variable depending on the name of the variable..
% load_path is everything but the extension (e.g. '/home/file.')
if nargin == 3;
    comp_col = 2;
end
    
    
    
col = find(strcmp(var_string,hdr_cell(:,comp_col))==1);
col_str = create_label(col,3);
var_out(:,1) = load([load_path col_str]);

end