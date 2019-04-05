function[input_date] = JJB_DL2Datenum(year, month, day, hour, min, sec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       This function allows for the input of time columns of Campbell Scientific dataloggers to
%       be converted into corresponding timevector number.  This function may require modification
%       to allow operation with various formats of date recording.
%
%       usage: JJB_DL2Datenum(year, month, day, hour, min, sec) outputs corresponding datenum
%       for inputted time values 
%       JJB_DL2Datenum(year, day of year, HHMM)  allows for calculation
%       of datenum using column inputs of year (YYYY), Julian day of year
%       (DDD) and 4-digit hour-minute timestamp (HHMM).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 3 %% if 3 columns of data are entered, assumptions of values of other inputs must
    % be assumed, and data must be properly identified (see usage)
    input_month(1:length(year),1) = 0;  
    input_sec(1:length(year),1) = 0;
    input_year = year;
    input_day  = month;
    HHMM = day;
    input_hour = floor(HHMM/100);
    input_min = (HHMM - input_hour.*100);
    input_date = datenum(input_year, input_month, input_day, input_hour, input_min, input_sec);
    
else
    input_date = datenum(year, month, day, hour, min, sec);
    
end