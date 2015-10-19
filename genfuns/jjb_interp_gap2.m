function [filled] = jjb_interp_gap2(data_in, max_gap, extrap_mode)
% extrap_mode can be either 'incremental', or 'same'

if nargin == 1
    max_gap = size(data_in,1)-2;
extrap_mode = 'incremental';
end

if nargin == 2
    extrap_mode = 'incremental';
end

if isempty(max_gap)==1
        max_gap = size(data_in,1)-2;
end
    
if strcmp(extrap_mode,'same')==1
    same_flag = 1;
else
    same_flag = 0;
end

%%% testing only:
% data_in = SMRef_2009;
% data_in([1 3],1) = NaN;
%%%%%%%%%%%%%%%
filled = data_in;
[starts_tmp len_tmp gaplist_tmp] = jjb_gapfinder(data_in, NaN);

ind_fill = find(len_tmp <= max_gap);
starts = starts_tmp(ind_fill);
len = len_tmp(ind_fill);


for i = 1:1:length(starts)
% have to do something different if it's the first point (extrapolate)
    if starts(i,1) == 1
        ind1 = find(~isnan(data_in),2,'first');
        diff1 = data_in(ind1(1)) - data_in(ind1(2));
        if same_flag == 1;
        incr1 = 0;    
        else
        incr1 = diff1/(ind1(2)-ind1(1));
        end
        fill_in_tmp1 = data_in(starts(i,1)+len(i,1),1) + cumsum(incr1.*ones(len(1,1),1));
        filled(starts(i,1):(starts(i,1)+len(i,1)-1)) = data_in(starts(i,1)+len(i,1)) - fill_in_tmp1;  

        % have to do something different if it's at the end (extrapolate)      
    elseif starts(i,1)+len(i,1) > size(data_in,1)

        ind_last = find(~isnan(data_in),2,'last');
        diff_last = data_in(ind_last(1)) - data_in(ind_last(2));
        if same_flag == 1;
        incr_last = 0;    
        else
        incr_last = diff_last/(ind_last(1)-ind_last(2));
        end
        fill_in_tmp_last = data_in(starts(i,1)-1,1) + cumsum(incr_last.*ones(len(i,1),1));
        filled(starts(i,1):(starts(i,1)+len(i,1)-1)) = fill_in_tmp_last;  
    else
% For everything else:    
diff = data_in(starts(i,1)+len(i,1),1) - data_in(starts(i,1)-1,1);
incr = diff/(len(i,1)+1);
fill_in_tmp = data_in(starts(i,1)-1,1) + cumsum(incr.*ones(len(i,1),1));
filled(starts(i,1):(starts(i,1)+len(i,1)-1)) = fill_in_tmp;
    end
end