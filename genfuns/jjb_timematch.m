function [input_loc, imaster_TV, iinput_TV] = jjb_timematch(master_TV, raw_file, field_ID, yr_col, jd_col, hhmm_col)


fid = find(raw_file(:,1)==field_ID);  % Find rows in master file with desired field ID
input_TV(:,1) = JJB_DL2Datenum(raw_file(fid,yr_col),raw_file(fid,jd_col),raw_file(fid,hhmm_col));

%%% Round the timevectors to avoid significant digit errors:
input_TV = (floor(input_TV.*100000))./100000;
master_TV = (floor(master_TV.*100000))./100000;

%%% Find where the timevectors are equal (i.e where loaded data fits into
%%% the annual file)
%%% C=rows common to both, 
%%% imaster_TV= rows on master_TV that match rows on input_TV
%%% iinput_TV = rows on input_TV that match rows on master_TV 
[C imaster_TV iinput_TV] = intersect(master_TV, input_TV);

%%% Create column vector that corresponds to proper rows in the master file
%%% (this is done since the input_TV file is a selection of rows taken from
%%% the raw file). 
input_loc = fid(iinput_TV);

