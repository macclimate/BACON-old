function[TV] = make_tv(year,interval)
% make_tv  Creates a continuous datenumber (column) vector.
%
% make_tv(year) creates the datenumber vector for the specified year using a 
% timestep defined by the value of interval (in minutes).
% Year should be an integer scalar or column vector. 
%
%
% Usage tv = make_tv(2004, 60)  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -gbd, Aug 10, 2004.
% - Modified by JJB, May 07, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start_time = datenum(year, 1, 1) + interval/1440;
  end_time = datenum(year+1, 1, 1);

        TV = [start_time : interval/1440 : end_time]';





