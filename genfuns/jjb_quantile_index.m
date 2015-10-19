function [quant_index] = jjb_quantile_index(num_pts, num_qtiles)
%%% This function separates data into 

t= round(linspace(1,num_pts+1,num_qtiles+1));
quant_index(:,1) = t(1:num_qtiles);
quant_index(:,2) = t(2:end)-1;
quant_index(:,3) = quant_index(:,2)- quant_index(:,1); 

