function [diff_nums2,start_col2,end_col2]= jjb_find_diff(col)
entry = 1;
diff_nums(entry,1) = col(1,1);
start_col(entry,1) = 1;

for i = 1:(length(col)-1)
    if isequal(col(i,1),col(i+1,1))==0
        entry = entry+1;
        diff_nums(entry,1) = col(i+1);
        end_col(entry-1,1) = i;
        start_col(entry,1) = i+1;
    end
end

end_col(entry,1)=length(col);

diff_nums2 = diff_nums(~isnan(diff_nums));
start_col2 = start_col(~isnan(diff_nums));
end_col2 = end_col(~isnan(diff_nums));