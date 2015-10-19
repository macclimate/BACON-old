function [en_avg] = ensemble_avg(data_in,pts_day)

if nargin == 1;
    pts_day = 48;
end

p = reshape(data_in,pts_day,[]);
en_avg(:,1) = row_nanmean(p);
en_avg(:,2) = row_nanstd(p);
en_avg(:,3) = row_nanmed(p);
end
