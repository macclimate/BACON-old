function [col] = jjb_struct2col(struct_in, field, max_num)
% field = 'Ta';
if nargin == 2
    max_num = length(struct_in);
end


names = who; loadname = char(names(3,1));
clear names;

col = [];

for j= 1:1:max_num
    temp = eval([loadname '(' num2str(j) ').' field]);
    
    col = [col ; temp];
    
    clear temp;
end