function [mon_sums] = mcm_monsum(data_in, year)

[days] = jjb_days_in_month(year);
hhrs = days.*48; % converts days into half-hours

    st = 1;
for i = 1:1:length(days) % cycles from months 1 -- 12

    mon_sums(i,1) = sum(data_in(st:st+hhrs(i)-1,1));
    mon_sums(i,2) = nansum(data_in(st:st+hhrs(i)-1,1));
    
    st = st + hhrs(i);
   
end


% C_1 = output_2008(:,16);
% C_2 = output_2008(:,26);
% C_3 = output_2008(:,36);
% C_4 = output_2008(:,46);
