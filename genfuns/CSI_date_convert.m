function [timevec] = CSI_date_convert(CSI_timevec, CSI_timedec)
%% CSI_date_convert.m
%%% This script converts date vectors reported in binary data by CSI (5000)
%%% data loggers, and returns the time vector used in matlab.
%%% INPUTS: 
%%% CSI_timevec -- The integer time vector (first column) in CSI bin data.
%%% CSI_timedec -- The decimal time vector (second column in CSI bin data.
%%% Note that first two columns of binary data are in unsigned integer,
%%% 'uint32' format, while the other columns are in floating 'float32'
%%% format.
% Created Feb 20, 2008 by JJB

CSIvec = CSI_timevec(:,1) + CSI_timedec(:,1)./1e9;
p = [0.000011574061994 726834.0063825655];

timevec = polyval(p,CSIvec);
