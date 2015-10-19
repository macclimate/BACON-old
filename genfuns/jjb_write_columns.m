function [] = jjb_write_columns(data,save_path)
%% Function to save matrix data to individual column vectors:
% inputs: data - input matrix
% save_path: full path name of file to save, without extension (e.g:'.003')
% usage jjb_write_columns(data,save_path)
% Created june 18, 2008 by JJB

[junk cols] = size(data);

ext = create_label((1:1:cols)', 3);

for j = 1:1:cols;
    temp = data(:,j);
    save([save_path '.' ext(j,:)],'temp','-ASCII')
    clear temp;
end
