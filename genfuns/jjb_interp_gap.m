function [a_fill] = jjb_interp_gap(a, x_val, max_gap)
%% jjb_interp_gap.m
%%% This function is used to find all gaps within a dataset that are as
%%% much as, or less than a specified number of data points.
%%% The output is a list of locations in the input file where this
%%% condition exists
%%% usage: [filled] = jjb_interp_gap(data_to_fill, x_values, max_gap)
% Where: 
% data_to_fill is the column vector with gaps in it, 
% x_values is just a counter from 1:1:length(data_to_fill)
% max_gap is the maximum size of gap to fill -- currently, only appropriate
% for gaps of 3 or 2.

if nargin == 1;
    x_val = (1:1:length(a))';
    max_gap = 3;
end

if isempty(x_val)
    x_val = (1:1:length(a))';
end

ind_nan = find(isnan(a));

if max_gap == 3;
    
%%% shifted back 1 point
a_b1(1:length(a)-1,1) = a(2:length(a));
a_b1(length(a)) = a(length(a));
%%% shifted back 2 points
a_b2(1:length(a)-2,1) = a(3:length(a));
a_b2(length(a)-1:length(a)) = a(length(a)-1:length(a));
%%% shifted back 3 points
a_b3(1:length(a)-3,1) = a(4:length(a));
a_b3(length(a)-2:length(a)) = a(length(a)-2:length(a));


%%% Shifted ahead 1 point
a_a1(1,1) = a(1);
a_a1(2:length(a),1) = a(1:length(a)-1);
%%% Shifted ahead 2 points
a_a2(1:2,1) = a(1:2,1);
a_a2(3:length(a),1) = a(1:length(a)-2);
% Shifted ahead 3 points
a_a3(1:3,1) = a(1:3,1);
a_a3(4:length(a),1) = a(1:length(a)-3);

ind_interp = find (isnan(a) & (~isnan(a_b1.*a_a1) |  ...
    ~isnan(a_b1.*a_a2) | ~isnan(a_b2.*a_a1) | ...
    ~isnan(a_b2.*a_a2) | ~isnan(a_b3.*a_a1) | ...
    ~isnan(a_b1.*a_a3) ));

a_interp = interp_nan(x_val,a);
a_fill = a_interp;
a_fill(ind_nan,1) = NaN;
a_fill(ind_interp,1) = a_interp(ind_interp);


elseif max_gap == 2;
    %%% shifted back 1 point
a_b1(1:length(a)-1,1) = a(2:length(a));
a_b1(length(a)) = a(length(a));
%%% shifted back 2 points
a_b2(1:length(a)-2,1) = a(3:length(a));
a_b2(length(a)-1:length(a)) = a(length(a)-1:length(a));

%%% Shifted ahead 1 point
a_a1(1,1) = a(1);
a_a1(2:length(a),1) = a(1:length(a)-1);
%%% Shifted ahead 2 points
a_a2(1:2,1) = a(1:2,1);
a_a2(3:length(a),1) = a(1:length(a)-2);

ind_interp = find (isnan(a) & (~isnan(a_b1.*a_a1) |  ...
    ~isnan(a_b1.*a_a2) | ~isnan(a_b2.*a_a1) | ...
    ~isnan(a_b2.*a_a2)));

a_interp = interp_nan(x_val,a);
a_fill = a_interp;
a_fill(ind_nan,1) = NaN;
a_fill(ind_interp,1) = a_interp(ind_interp);

else
    disp('this is not ready yet');
end