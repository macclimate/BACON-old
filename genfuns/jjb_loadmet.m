function[met_file] = jjb_loadmet(load_path, file_type, field_ID)

% Loads a met data file using 3 input parameters:
% load_path - the path to the file needed to be loaded
% file_type - 1 for comma delimited data, 2 for .....
% field_ID  - inputted number specifies the field ID of the desired data 
%              (i.e. '5' - 5 minute output table
%                    '10' - 30 minute output table etc.
%           - entering the string 'all' commands that all data be
%           downloaded


%%% Load weather station file %%%
if field_ID == 'all'
    
    if file_type == 1
        disp(['loading ' load_path]);       %% confirms load path and comma delimited
        disp('comma delimited');
        met_file = dlmread(load_path,',');
    elseif file type == 2
        disp ('this function is not enabled yet')
    end
    
else
    if file_type == 1                       %% runs for comma delimited data
        disp(['loading ' load_path]);       %% confirms load path and comma delimited
        disp('comma delimited');
        met2raw = dlmread(load_path,',');       %% uses dlmread function to load raw data file
        ind = find(met2raw(:,1)==field_ID);     %% Searches for all rows with proper field ID 
        met_file = met2raw(ind,:);              %% Creates output file
        
    elseif file type == 2
        disp ('this function is not enabled yet')
    end 
end