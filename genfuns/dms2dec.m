function [dec_out] = dms2dec(deg_in, min_in, sec_in)
% dms2dec.m
% This function converts an angle given in degree,minutes,sec to a simple
% degree decimal
% Usage: [dec_out] = dms2dec(deg_in, min_in, sec_in)
% Input: degrees, minutes, and seconds of angle
% Output: angle in decimal

% Created Mar 13, 2009 by JJB
% Revision History:

dec_out = deg_in + (min_in/60) + (sec_in/60)./60;