function [var_out] = load_from_master2(master,var_name)

        if ~iscell(master.labels)
            labels = cellstr(master.labels);
        else
            labels = master.labels;
        end
        
  right_col = find(strcmp(labels(:,1),var_name)==1,1,'first');
  var_out = master.data(:,right_col);
  
end