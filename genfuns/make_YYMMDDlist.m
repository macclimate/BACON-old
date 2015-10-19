function [file_list] = make_YYMMDDlist(year)
% This function outputs a list of YYMMDD strings, to be used when
% referencing folders outputted by flux programs.


tmp = num2str(year);
yr_str = tmp(3:4);


[day_list] = jjb_days_in_month(year);
% no_days = sum(day_list);


total_ctr = 1;
for mon_ctr = 1:1:length(day_list)
    month = num2str(mon_ctr);
    if length(month) == 1;
        month = ['0' month]; %%% pad with a '0' if a single digit
    end

        for day_ctr = 1:1:day_list(mon_ctr)
        day = num2str(day_ctr);
        if length(day) == 1;
            day = ['0' day]; %%% pad with a '0' if a single digit
        end
        
        file_list(total_ctr,:) = [yr_str month day];
        clear day;
        total_ctr = total_ctr + 1;
        end
        clear month;
end

        