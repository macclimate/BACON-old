function [str_out] = removeblankspaces(str_in)
str_out = str_in;
str_out(str_in==' ') = '';
