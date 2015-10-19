function [array_out] = jjb_timeshifter(array_in, num_pts_to_shift)

if strcmp(num_pts_to_shift,'EST2UTC') == 1;
    shift = 10;
elseif strcmp(num_pts_to_shift,'UTC2EST') == 1;
    shift = -10;
else
    shift = num_pts_to_shift;
end

[r c] = size(array_in);

if shift > 0
array_out(1:shift,:) = NaN;
array_out(shift+1:r,:) = array_in(1:r-shift,:);
elseif shift < 0
    array_out(1:r-shift,:) = array_in(shift+1:r,:);
    array_out(shift:r,:) = NaN;
end