function [ind_bad_tracker array_out] = Papale_spike_removal2(array_in,z, PAR, win_size, time_int)
%%% Instead of using a fixed window size, let's use 500 consecutive 'good'
%%% data points during either day or night

if nargin == 3
    time_int = 30;
    win_size = 10;
elseif nargin == 4
    time_int = 30;
end
% Changes the window size from days to total number of data points 
% (Thus, the default window size is 480 data points.
win_size = win_size*(1440./time_int);

% Separate data into periods of good daytime data and good nighttime data
ind_nonan_night = find(isnan(array_in)==0 & PAR < 15);
ind_nonan_day = find(isnan(array_in)==0 & PAR >= 15);
array_nonan_night = array_in(ind_nonan_night); % condense the dataset to numbers only (no NaNs)
array_nonan_day = array_in(ind_nonan_day); % condense the dataset to numbers only (no NaNs)
ind_bad_tracker = ones(length(array_in),1);
% Step 1: Nighttime:
ind_bad_tracker_night = ones(length(array_nonan_night),1);
for i= 0:win_size:length(ind_nonan_night)-1
    st_pt = min(i+1,length(ind_nonan_night) - win_size +1);
    end_pt = st_pt+win_size-1;
    % Pad array_nonan_night:
    disp(['pap loop ' num2str(i)])
    if st_pt == 1;pad_st = array_nonan_night(end);
    else pad_st = array_nonan_night(st_pt-1); end
    if end_pt == length(ind_nonan_night); pad_end = array_nonan_night(1);
    else        pad_end = array_nonan_night(end_pt+1);    end
    night_data = array_nonan_night(st_pt:end_pt);
    tmp_tracker = ones(length(night_data),1);
    d_bef = night_data(1:length(night_data)) - [pad_st;night_data(1:length(night_data)-1)];
    d_aft = [night_data(2:length(night_data)); pad_end] - night_data(1:length(night_data));
    di = d_bef-d_aft;
    MAD = median(abs(di-median(di)));
    tmp_tracker(di < (median(di)- (z*MAD)./0.6745) | di > (median(di) + (z*MAD)./0.6745),1) = NaN;
    ind_bad_tracker_night(st_pt:end_pt,1) = tmp_tracker;
    
    %%%%%%%% Stuff for inspection:
%     figure(1);clf;
%     plot(night_data,'k-'); hold on;
%     %         plot(d_bef,'r')
%     %         plot(d_aft,'g')
%     plot(di,'b.-');
%     plot(1:1:length(night_data),(median(di)- (z*MAD)./0.6745).*ones(length(night_data),1),'r--');
%     plot(1:1:length(night_data),(median(di) + (z*MAD)./0.6745).*ones(length(night_data),1),'r--');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear tmp_tracker MAD di d_bef d_aft night_data st_pt end_pt pad_st pad_end;
end

%%% Daytime:
ind_bad_tracker_day =  ones(length(array_nonan_day),1);
for i= 0:win_size:length(ind_nonan_day)-1
    st_pt = min(i+1,length(ind_nonan_day) - win_size +1);
    end_pt = st_pt+win_size-1;
    % Pad array_nonan_day:
    if st_pt == 1;pad_st = array_nonan_day(end);
    else pad_st = array_nonan_day(st_pt-1); end
    if end_pt == length(ind_nonan_day); pad_end = array_nonan_day(1);
    else        pad_end = array_nonan_day(end_pt+1);    end
    day_data = array_nonan_day(st_pt:end_pt);
    tmp_tracker = ones(length(day_data),1);
    d_bef = day_data(1:length(day_data)) - [pad_st;day_data(1:length(day_data)-1)];
    d_aft = [day_data(2:length(day_data)); pad_end] - day_data(1:length(day_data));
    di = d_bef-d_aft;
    MAD = median(abs(di-median(di)));
    tmp_tracker(di < (median(di)- (z*MAD)./0.6745) | di > (median(di) + (z*MAD)./0.6745),1) = NaN;
    ind_bad_tracker_day(st_pt:end_pt,1) = tmp_tracker;
    
    %%%%%%%% Stuff for inspection:
%     figure(2);clf;
%     plot(day_data,'k-'); hold on;
%     %         plot(d_bef,'r')
%     %         plot(d_aft,'g')
%     plot(di,'b.-');
%     plot(1:1:length(day_data),(median(di)- (z*MAD)./0.6745).*ones(length(day_data),1),'r--');
%     plot(1:1:length(day_data),(median(di) + (z*MAD)./0.6745).*ones(length(day_data),1),'r--');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear tmp_tracker MAD di d_bef d_aft day_data st_pt end_pt pad_st pad_end;
end

%%% Make the final output data and index:
array_out = array_in;
array_out(ind_nonan_night) = array_out(ind_nonan_night).*ind_bad_tracker_night;
array_out(ind_nonan_day) = array_out(ind_nonan_day).*ind_bad_tracker_day;
ind_bad_tracker(ind_nonan_night)= ind_bad_tracker_night;
ind_bad_tracker(ind_nonan_day)= ind_bad_tracker_day;