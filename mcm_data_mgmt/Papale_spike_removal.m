function [ind_bad_tracker array_out] = Papale_spike_removal(array_in, z)
%%% modified_Papale_spike_removal.m
% This function uses the Papale (2006) spike detection system to remove
% outliers from data.  The modification simply calculates Md and MAD values
% in a moving window fashion (whereas the Papale method uses one set Md and
% MAD for the entire year.
% usage: [ind_bad_tracker array_out] = modified_Papale_spike_removal(array_in, z)
% inputs: array_in - the complete dataset to be cleaned
% z - the z value, which determines the tolerance of spike detection
% (usually between 4-6)
% outputs: ind_bad_tracker - an index that is 1 if it is a positive spike
% (too high), and -1 if it is a negative spike (too low).
% array_out: spike-removed data, with spikes replaced by NaNs (same length
% as array_in).
%
%
% Created October 2009 by JJB
%
% Revision History:
%
%
%



ind_nonan = find(~isnan(array_in)); % Find only non- NAN data
array_nonan = array_in(ind_nonan); % condense the dataset to numbers only (no NaNs)

ind_bad_tracker(1:length(array_in),3) = NaN;
ind_bad_di_tracker(1:length(array_nonan),1) = 0;
ind_bad_highlow_tracker(1:length(array_nonan),1) = 0;
ind_up_down_tracker(1:length(array_nonan),1) = 0;

d_bef(2:length(array_nonan),1) = array_nonan(2:length(array_nonan),1) - array_nonan(1:length(array_nonan)-1);
d_aft(1:length(array_nonan)-1,1) = array_nonan(2:length(array_nonan)) - array_nonan(1:length(array_nonan)-1);
%%% First and last entries for each are calculated by wrapping around
d_bef(1,1) = array_nonan(1) - array_nonan(length(array_nonan));
d_aft(length(array_nonan),1) = array_nonan(1) - array_nonan(length(array_nonan));
%%% Calculate d_i
d_i = d_bef - d_aft;

loop_ctr = 1;
for i = 1:800:length(array_nonan)
    if length(array_nonan)-i >=799;
        ind_loop = (i:1:i+799)';
    else
        ind_loop = (i:1:length(array_nonan))';
    end
    
    % ind_good = find(~isnan(d_i));
    Md(loop_ctr,1) = median(d_i(ind_loop),1);
    MAD(loop_ctr,1) = median(abs(d_i(ind_loop,1) - Md(loop_ctr,1)));
    
    up_thresh(loop_ctr,1) = Md(loop_ctr,1) + ((z.*MAD(loop_ctr,1))./0.6745);
    down_thresh(loop_ctr,1) = Md(loop_ctr,1) - ((z.*MAD(loop_ctr,1))./0.6745);
    
    %%%% Testing:
    ind_bad_di = find(d_i(ind_loop,1) < down_thresh(loop_ctr,1) | d_i(ind_loop,1) > up_thresh(loop_ctr,1));
    ind_bad_di_tracker(ind_loop(ind_bad_di),1) = 1;
    
    ind_bad_high = find(d_bef(ind_loop,1) > up_thresh(loop_ctr,1) | d_aft(ind_loop,1) > up_thresh(loop_ctr,1));
    ind_bad_low = find(d_bef(ind_loop,1) < down_thresh(loop_ctr,1) | d_aft(ind_loop,1) < down_thresh(loop_ctr,1));
    ind_bad_highlow_tracker(ind_loop(ind_bad_high),1) = +1;
    ind_bad_highlow_tracker(ind_loop(ind_bad_low),1) = -1;
    
    %%%%%%%%%%
    
    no_good = find((d_bef(ind_loop,1) > up_thresh(loop_ctr,1) | d_bef(ind_loop,1) < down_thresh(loop_ctr,1)) ...
        & (d_aft(ind_loop,1) > up_thresh(loop_ctr,1) | d_aft(ind_loop,1) < down_thresh(loop_ctr,1)));
    
    %%%%%%%% Testing:
    ind_up_down_tracker(ind_loop(no_good),1) = 1;
    %%%%%%%%%%%%%%%
    
    
    array_nonan(ind_loop(ind_bad_di)) = NaN;
    loop_ctr = loop_ctr+1;
    clear ind_loop no_good ind_bad_high ind_bad_low ind_bad_di;
end

array_out(1:length(array_in),1) = array_in;
array_out(ind_nonan) = array_nonan;

ind_bad_tracker(ind_nonan,1) = ind_bad_di_tracker;
ind_bad_tracker(ind_nonan,2) = ind_bad_highlow_tracker;
ind_bad_tracker(ind_nonan,3) = ind_up_down_tracker;