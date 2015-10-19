function[outflag] = find_leapyr(input_yr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests a given year to see if it is a leap year.  If a given year is a
% leap year, returns outflag = 1; otherwise, outflag = 0.
%
% Usage [outflag] = find_leapyr(input_yr)
%
% Created Apr 7, 2006 by JJB


%%%%%%%%%%%%%%%%%%% Check for leap year
if mod(input_yr,400)==0
    disp([num2str(input_yr) ' is a leap year']);
    outflag = 1;
%     data_add = 288;
    
elseif mod(input_yr,4) ==0
    disp([num2str(input_yr) ' is a leap year']);
   outflag = 1;
%     data_add = 288;
    
else 
    disp([num2str(input_yr) ' is not a leap year']);
   outflag = 0;
%     data_add = 0;
end
