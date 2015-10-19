function [nmed] = nanmedian(array_in)

[rows cols] = size(array_in);

for i = 1:1:cols
indfin = find(isfinite(array_in(:,i))==1);
nmed(1,i) = median(array_in(indfin,i));
end