function [hrs mins secs] = min2hms(min_in)
%%% Converts time (in minutes into a day) into hrs mins and secs
% Created Mar 13, 2009 by JJB

hrs = floor(min_in./60);

mins = floor(min_in - hrs*60);

secs = ((min_in-hrs*60)-mins).*60;