%%% make_dir_list
function [] = make_dir_list(input_dir)
if nargin == 0;
    input_dir = uigetdir;
end

if input_dir(end) == '/' || input_dir(end) == '\';
else
    input_dir = [input_dir '/'];
end

output_dir = uigetdir(input_dir,'Select Folder to Output File List');

input_dir(input_dir == '\') = '/'; % changes slashes
slsh = find(input_dir == '/');
folder_name = input_dir(slsh(end-1)+1:slsh(end)-1);
parent_folder = input_dir(1:slsh(end-1));
output_filename = [parent_folder folder_name '_folder_name_dir_' datestr(now,1) '.txt']

fid = fopen(output_filename,'w');

D = dir(input_dir);

for i = 3:1:length(D)
    fullname = [input_dir D(i).name];
    format = ['%' num2str(length(fullname)) 's\n'];
    fprintf(fid,format, fullname);
    
    
    clear fullname format;
end

fclose(fid);