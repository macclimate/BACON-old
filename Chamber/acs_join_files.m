function acs_join_files(dateIn,pth)
%pth = 'E:\Site_DATA\PortableChambers\Data from U of A\CD for 2006\acs-dc02\MET-DATA\data';
%startDate = datenum(2006,9,24);
%endDate = datenum(2006,9,24);
if ischar(dateIn)
    dateIn = eval(dateIn);
end
startDate = min(floor(dateIn));
endDate   = max(floor(dateIn));
for currentDate = startDate+datenum(0,0,0,0,30,0):datenum(0,0,0,0,30,0):endDate+1
    [currentFileName,currentPath] = local_find_file_name(pth,currentDate);
    [nextFileName,   nextPath]    = local_find_file_name(pth,currentDate+datenum(0,0,0,0,30,0));
    if ~isempty(currentFileName) & ~isempty(nextFileName)
        [currentData,currentHeader] = fr_read_digital2_file(fullfile(currentPath,currentFileName));
        [nextData   ,nextHeader]    = fr_read_digital2_file(fullfile(nextPath,   nextFileName));
        newData = [currentData ; nextData];
        if length(currentData) >= length(nextData)
            newHeader = currentHeader;
            newHeaderChar = local_read_header(fullfile(currentPath,currentFileName));
            newFileName = fullfile(currentPath,currentFileName);
        else
            newHeader = nextHeader;
            newHeaderChar = local_read_header(fullfile(nextPath,    nextFileName));
            newFileName = fullfile(nextPath,nextFileName);
        end
        % move the original files currentFileName and nextFileName to the
        % subfolder .\originalFiles and save the joined data into the file
        % newFileName
        if ~exist(fullfile(currentPath,'originalFiles'),'dir'); mkdir(fullfile(currentPath,'originalFiles'));end
        movefile(fullfile(currentPath,currentFileName),fullfile(currentPath,'originalFiles', currentFileName));
        if ~exist(fullfile(nextPath,   'originalFiles'),'dir'); mkdir(fullfile(nextPath,   'originalFiles'));end
        movefile(fullfile(nextPath,   nextFileName),   fullfile(nextPath,'originalFiles',    nextFileName));
        ret = local_save_digital2_file(newFileName, newHeaderChar, newData, newHeader);
        disp(sprintf('New file name: %s.  File write success: %d',newFileName,ret));

%         figure(1)
%         plot(newData(:,1))
%         hold on
    end
    
end
hold off

function [fileName,filePath] = local_find_file_name(pth,currentDate)
    hhourDate = fr_round_time(currentDate,'30min',1);
    [junk,junk,junk,hourX,minuteX,junk] = datevec(hhourDate);
    if hourX == 0 & minuteX == 0 
        folderName =  datestr(hhourDate-1,30);
        hourX = 24;
    else
        folderName =  datestr(hhourDate,30);
    end
    folderName = folderName(3:8);
    fileNameWildcard = [folderName sprintf('%0.2d',hourX*4+fix(minuteX/30)*2) '.*'];
    sDir = dir(fullfile(pth,folderName,fileNameWildcard));
    if ~isempty(sDir)
        fileName = sDir.name;
        filePath = fullfile(pth,folderName);
    else
        fileName = [];
        filePath = [];
    end

 function Header = local_read_header(fileName)
    fid = fopen(fileName,'rb');
    if fid < 3
        Header = NaN;
    else
        headerVersion = setstr(fread(fid,[1,7],'char'));
        headerSize = fread(fid,[1,1],'int16') * 1000;
        fseek(fid,0,-1);
        Header = fread(fid,[headerSize,1],'char');
    end
    fclose(fid);
    
function ret = local_save_digital2_file(fileName, headerChar, dataIn, headerIn)
    fid = fopen(fileName,'wb');
    if fid < 3
        ret = -1;
    else
        fwrite(fid,headerChar,'char');
        for i=1:headerIn.NumOfChans
            dataOut(:,i) = round((dataIn(:,i)-headerIn.Poly(i,2))/headerIn.Poly(i,1));
        end
        fwrite(fid,dataOut','int16');
        fclose(fid);
        ret = 0;
    end
    
       