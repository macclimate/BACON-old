function [datastr] = mcm_make_datastr(year, time_int)
% This function makes a list of 6 character tags for daily files:
%e.g. 080101 --- 081231... or hhourly (08010102 08010104...)
% usage: [datastr] = mcm_make_datastr(year,time_int), where time_int is
% either 30 (hhourly) or 1440 (daily).
% Created June 2, 2009 by JJB.

if ischar(year)
    year = str2double(year);
end

[Mon Day] = make_Mon_Day(year, time_int);
YYYY = num2str(year);
YY = YYYY(3:4);

switch time_int
    case 30
     for i = 1:1:length(Mon)
         for j = 2:2:96
    datastr(i*48 -48 + j./2 ,:) = [YY create_label(Mon(i,1),2) create_label(Day(i,1),2) create_label(num2str(j),2)];
         end
     end
  
case 1440
     for i = 1:1:length(Mon)
    datastr(i,:) = [YY create_label(Mon(i,1),2) create_label(Day(i,1),2)];
     end
end
 
    
        
        








