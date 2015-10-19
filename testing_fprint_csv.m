a = jjb_hdr_read('/1/fielddata/Matlab/Data/Master_Files/Docs/TP39_master_list.csv',',');

cols_to_use = [1; 3; 22; 25; 39; 100];

fid = fopen('/1/fielddata/Matlab/Data/Master_Files/Docs/test1.txt','w+');
for i = 1:1:length(cols_to_use)
    a_out = a{cols_to_use(i,1),1};
    fprintf(fid,'%s\t',a_out);
    clear a_out;
end
fclose(fid);


fid2 = fopen('/1/fielddata/Matlab/Data/Master_Files/Docs/test1.csv','w+');
for i = 1:1:length(cols_to_use)
    a_out = a{cols_to_use(i,1),1};
    
    if i == length(cols_to_use)
        fprintf(fid2,'%s\n',a_out);
    else
        a_out = [a_out ','];
        fprintf(fid2,'%s',a_out);
        
    end
    
    clear a_out;
end
fclose(fid2);
