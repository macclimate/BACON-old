%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is a junk program, written to find a time shift in the data that
%% may be caused by the datalogger being shifted ahead by 1 hour for DST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all; 
% close all;
% 
% pth = ['C:\Home\Matlab\Data\met_data\Met2\Backup_nocsv'];
% input_file = 'Met06M2.DAT';
% 
% metdata = jjb_loadmet([pth input_file],1,'all');    % **NOTE ** Must open file in excel and save as CSV before processing
% 
% HHMM_up1(1:length(metdata)-1,1) = metdata(2:length(metdata),4);
% HHMM = metdata(1:length(metdata)-1,4);
% 
% shift = HHMM_up1 - HHMM;
% 
% % uniques = jjb_unique_value(shift);
% 
% [B IX] = sort(shift);
% 
% A = [B IX];


clear all; 
close all;

eofstat = 0;
i = 1;

pth = ['C:\Home\Matlab\Data\met_data\Met2\'];
input_file = 'Met07M2.DAT';

fid = fopen([pth input_file]);

% while eofstat == 0;                             %% Scans through the lines of the header file until reaching the end of file
%     tline = fgets(fid);  %% Read a line
%     spaces = find(isspace(tline)==1);               %% Find blank spaces in file (use these to locate where desired data is)
%     cm = find(tline == ',');
%     
%     A(i,1) = str2num(tline(1:cm(1)));
%     
%     for j = 2:length(cm)
%         A(i,j) = str2num(tline(cm(j-1)+1:cm(j)-1));
%     end
%     A(i,j+1) = str2num(tline(cm(j)+1:spaces(1)));
%     
%     
%     i=i+1;
%     eofstat = feof(fid);
% end

B = dlmread([pth input_file],',');
b_start = B(1:500,:);
b_end = B(length(B)-1000:length(B),:);
%%%%%%%% Check is something isn't right with the data
ind5 = find(B(:,1) == 5);       %%% finds rows with Field ID 5
B1 = B(ind5(1),:);              %%% Takes the first row with FID 5
[rows, cols] = size(B);         %%% size
checkcol = cols - 7 + 1;        %%% sets the number of columns in FID that should be 0
zer = zeros(1,checkcol);        %%% makes a row vector with that many columns of 0

%%%%% IF first line of FID 5 is all zeros (good) then nothing done.. but
%%%%% data is there (bad), shift the data...

if isequal(zer,B1(1,7:cols))== 1 
    display('Data looks good!  It does not need to be shifted')
else
    display ('Error in reading columns -- reshifting data')
    
    for j = 8:cols
        num_shifts = j -7;
        temp_move = B(length(B)-num_shifts+1:length(B),j);
        B(num_shifts+1:length(B),j) = B(1:length(B)-num_shifts,j); 
        B(1:num_shifts,j) = temp_move(:,1);
        test_a = B(1:500,:);    % use for real-time display

        clear temp_move
    end
end
b2_start = B(1:500,:);
b2_end = B(60000:61610,:);
        
  

