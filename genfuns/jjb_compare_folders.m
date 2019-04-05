function[] = jjb_compare_folders(source_path, dest_path)
%% This function compares two folders (a source and destination.
% It checks the destination folder for files present in the source and then
% fills in files if needed.
if source_path(end) == '/'
else
    source_path = [source_path '/'];
end

if dest_path(end) == '/'
else
    dest_path = [dest_path '/'];
end


dir_source = dir(source_path);

transfer_ctr = 0;
if length(dir_source) > 2 % checks that folder is not empty
    for j = 3:1:length(dir_source)
        if exist([dest_path dir_source(j).name])==2
        else
        copyfile([source_path dir_source(j).name],[dest_path dir_source(j).name]);
    transfer_ctr = transfer_ctr+1;
        end
    end
end

disp(['Transfered a total of ' num2str(transfer_ctr) ' files from: ' source_path]);