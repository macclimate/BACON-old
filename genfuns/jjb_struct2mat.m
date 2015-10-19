function [mat_out fnames] = jjb_struct2mat(struct_in)
err_flag = 0;
fnames = fieldnames(struct_in);
mat_out = NaN.*ones(length(fnames),1);
for i = 1:1:length(fnames)
    tmp = eval(['struct_in.' fnames{i,1} ';']);
    if numel(tmp)==1
        mat_out(i,1) = double(tmp);
    else
        mat_out(i,1) = NaN;
        err_flag = 1;
    end
clear tmp;    
end
    
if err_flag == 1;
    disp('At least one structure element has more than one element.')
disp('It was set to NaN -- This function only works on single element structures.')
end
