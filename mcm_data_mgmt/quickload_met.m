function [var_out] = quickload_met(year,site,var_name)
% This function loads a desired variable based on the year and site, and
% the name inputted into it.  It uses the name variable to search through
% the output_template file to find what variable it should load in the
% /Cleaned3 folder.
% Created July 17, 2007 by JJB.

if ischar(year)
    year = str2double(year);
end

loadstart = mcm_loadstart;

load_path = [loadstart 'Data/Met/Cleaned3/' site '/' site '_' num2str(year) '.'];
% load header:
hdr = jjb_hdr_read([loadstart 'Data\Met\Raw1\Docs\' site '_OutputTemplate.csv'],',',3);

col = find(strcmp(var_name,hdr(:,2))==1);
col_str = create_label(col,3);
var_out(:,1) = load([load_path col_str]);