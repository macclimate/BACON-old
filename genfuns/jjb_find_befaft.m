function [bef_ind aft_ind] = jjb_find_befaft(data_in, current_row)
ind = (1:1:length(data_in))';

good_data = ~isnan(data_in);
bef_ind = find(good_data == 1 & ind < current_row,1,'last') ;
aft_ind = find(good_data == 1 & ind > current_row,1,'first');
