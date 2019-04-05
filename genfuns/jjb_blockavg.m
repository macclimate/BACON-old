function average = jjb_blockavg(criterion_array, x, step, upper_limit, lower_limit, weight)

% usage: jjb_blockavg(x, y, step, upper_limit, lower_limit, weight)
%==================================================================================
%
%   THIS FUNCTION IS TO DO THE BLOCK AVERAGE ACCORDING TO ANY CRITERION
%     WHICH IS DEFINED IN THE CRITERION_ARRAY FOR THE WHOLE DATASET
%
%   Syntex:
%       average = blockavg(criterion_array, x, step, upper_limit, lower_limit)
%
%   Input:
%        criterion_array:  The criterion data set for averaging (Sigma_w, u*, etc.)
%                      x:  The variable for averaging (Fc39 etc.)
%            upper_limit:  The upper_limit for good data of x (1000 w/m2 for Solar etc.)
%            lower_limit:  The lower_limit for good data of x (-100 w/m2 for Solar etc.)
%
%   Output:
%       average:  The average of x (col 1: mean_criterion; col 2: average; 
%                   col 3: sigma; col 4: n)
%       sigma:    The standard deviation of x:
%       
%   Note:
%       time array should start from 1 Jan, 1996 = 1;
%
%       First generated on: 08 Nov. 1996 by Paul Yang
%       Last modified on:   21 Aug. 1997 by Paul Yang
%       Modified 19 Nov, 2007 by JJB -- includes weighted mean calculation, using
%       inputted weight value
%
%=======================================================================================
if nargin == 5
    weight = [];
end

% %%% Added Feb 19 by JJB - gets rid of NaNs in the data %%%%%%%%%%%%%%%
% good_data = find(~isnan(criterion_array.*x));
% x_tmp = x(good_data); clear x;
% x = x_tmp; clear x_tmp;
% criterion_array_tmp = criterion_array(good_data); clear criterion_array;
% criterion_array = criterion_array_tmp; clear criterion_array_tmp;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

indnotnan = find(~isnan(criterion_array) & ~isnan(x));
criterion_array = criterion_array(indnotnan);
x = x(indnotnan);

d_begin = floor(min(criterion_array)/step)*step;
l = length(criterion_array);
d_end = max(criterion_array);

n = ceil(abs(d_end - d_begin)/step)+1;
average = nan*ones(n,4);

for i = 1:n                  
        k = (i-1)*step + d_begin;
        j = (i)*step + d_begin;
        ind = find((criterion_array>=k & criterion_array<j) & ~isnan(x) & (x>lower_limit & x<upper_limit));
        if isempty(ind)==0
                d = mean(criterion_array(ind));
                sigma = std(x(ind));
                N = length(ind);
        else
                d = (k+j)/2;
                xx = nan*ones(1,1);
                sigma = nan*ones(1,1);
                N = 0;
        end        
        if isempty(weight)==0
        xx = (sum(weight(ind,1).*x(ind,1)))./sum(weight(ind,1));
        else
        xx = mean(x(ind,1));
        end
        
        average(i,1) = d; % for 1 Jan = 1.00 - 2.00
        average(i,2) = xx;
        average(i,3) = sigma;
        average(i,4) = N; 
end        
