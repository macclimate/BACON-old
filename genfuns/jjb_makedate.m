function [Year, JD, HHMM, dt] = jjb_makedate(input_yr, min_int)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes the input year and creates three column vectors:  year, julian day
% and HHMM, for the selected minute interval 
% ** minute interval must be divisable into 60 **
% File checks for a leap year and creates output file accordingly.
%
% Usage [year JD HHMM dt] = jjb_makedate(input_year, min_input)
%
% Created May 8, 2007 by JJB
% Modified May 22, 2007 by JJB to allow for different minute intervals
% Modified May 24, 2007 by JJB to correct for first entry being 0 min into
% year. (new version starts entries at 1 interval into year).

if ischar(input_yr)
    input_yr = str2num(input_yr);
end

%%%%%%%%%%%%%%%%%%% Check for leap year
if mod(input_yr,400)==0
    %disp([num2str(input_yr) ' is a leap year']);
    daynum = 366;
%     data_add = 288;
    
elseif mod(input_yr,4) ==0
    %disp([num2str(input_yr) ' is a leap year']);
    daynum = 366;
%     data_add = 288;
    
else 
    %disp([num2str(input_yr) ' is not a leap year']);
    daynum = 365;
%     data_add = 0;
end
%%%%%%%%%%%%%%%  Set variables
cnt = 1;
Year(1:((daynum*1440)/min_int),1) = input_yr;
dt(1:((daynum*1440)/min_int),1) = (1+min_int/1440:min_int/1440:daynum+1);
day_cnt=1;    
%%%%%%%%%%%%%%% make HHMM file for each day
    for HH = 0:23
        for MM = 0:min_int:(60-min_int)
            if MM ==0
                HHMMstr = [num2str(HH) '00'];               %converting to string to get proper format
                HHMMset(cnt,1) = str2num(HHMMstr);
            elseif MM >0 && MM<10
                HHMMstr = [num2str(HH) '0' num2str(MM)];
                HHMMset(cnt,1) = str2num(HHMMstr);
            else
                HHMMstr = [num2str(HH) num2str(MM)];
                HHMMset(cnt,1) = str2num(HHMMstr);
            end
            cnt = cnt+1;
        end
    end
    
%%%%%%%%%%%%%%%%%%%% Attach HHMM to days  
    for day = 1:daynum                                      
        JD(day_cnt:(day*(1440./min_int)),1) = day;
        
        if length(Year) == 365 || length(Year) == 366
         HHMM(1:(day*(1440./min_int)),1) = 0;
         else
        HHMM(day_cnt:(day*(1440./min_int)),1) = HHMMset;
        end
        day_cnt = day_cnt+(1440./min_int);  
    end

    
%%%%%%%%%%%%%%%% Adjust output so that first HHMM entry is one interval
%%%%%%%%%%%%%%%% into the year, and that the last entry occurs exactly on
%%%%%%%%%%%%%%%% the new year.  (Earlier version produced first output
%%%%%%%%%%%%%%%% row with Y, D, HHMM e.g. 2007 1 0 -- desired is 2007 1 5
if length(Year) == 365 || length(Year) == 366
else
HHMM(1,1) = min_int;
HHMM(2:(length(HHMM)-1),1) = HHMM(3:length(HHMM),1);
HHMM(length(HHMM),1)= 2400;

%%%%%%%%%%%%%%%% Also adjust so that HHMM = 0000 is displayed as 2400
dbl_zero = find(HHMM ==0);
HHMM(dbl_zero) = 2400;
end
