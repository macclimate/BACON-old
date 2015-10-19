function [avg] = quick_nanmean(a, b)

avg = NaN.*ones(length(a),1);
avg(~isnan(a.*b),1) = mean([a(~isnan(a.*b),1) b(~isnan(a.*b),1)],2);
avg(isnan(a),1) = b(isnan(a),1);
avg(isnan(b),1) = a(isnan(b),1);

