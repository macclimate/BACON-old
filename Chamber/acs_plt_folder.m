function acs_plt_folder(pth,dateIn)
fileName = fr_datetofilename(dateIn);
fileName = fileName(1:6);
listOfFiles = dir(fullfile(pth,fileName,[fileName '*']));
for currentFile = 1:length(listOfFiles);
    disp(sprintf('%d/%d. %s',currentFile,length(listOfFiles),listOfFiles(currentFile).name))
    x=fr_read_digital2_file(fullfile(pth,fileName,listOfFiles(currentFile).name));
    figure(1)
    plot(x(:,1))
    title(listOfFiles(currentFile).name)
    figure(2)
    plot(x(:,2))
    figure(3)
    plot(x(:,3:4))
    figure(4)
    plot(x(:,9:18));
    axis([0 600 -5 30]);
    pause;
end