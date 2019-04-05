function [data_filled] = mcm_fillvars(data_in)
%% mcm_metfill.m
%%% This function (when completed), will allow the user to fill met data
%%% from one site with data from another site, based on a simple
%%% regression of values between the two.
%
%%% Inputs should be:
%%%
% var_type options:
% 
[junk num_sites] = size(data_in);
% site_labels = ['TP39'; 'TP74';'TP89'; 'TP02'];

% Put all data into one matrix so to check which ones have been entered
% data_in = [TP39 TP74 TP89 TP02];
% %%%%%%%%%%%%%%%%%%%% Pre-allocated sizes to output variables:
tracker = zeros(length(data_in),num_sites);
data_out = NaN.*ones(length(data_in),num_sites); 
%data_out = zeros(length(data_in),4); 
data_check = NaN.*ones(1,num_sites);
status_matrix = eye(num_sites); % matrix that indicates if data exists for comparison
master_slopes = eye(num_sites);
master_r2 = eye(num_sites);
master_r2_adj = eye(num_sites);
lin = struct;
linadj = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% Go through input data and find which sites do and don't have data:
for site = 1:1:num_sites
    data_check(1,site) = isempty(data_in(:,site));
    if data_check(1,site) == 1
        status_matrix(:,site) = NaN;   % Makes rows and columns NAN in regression matrix if the dataset is empty
        status_matrix(site,:) = NaN;
    end
end

good_sites = find(data_check == 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare each site with other sites for slope and r2 --Ts_fit returns the 
% linear and adjusted linear slopes for relationship, 
% as well as predicted values using each approach
% Modified Apr 21, 2009 -- Made this to load in all years of data (requires
% additional argin 'var_type', which will specify the variable type for
% comparison.

%%% Loop here that will load in all available years of data so that we can
%%% get the best parameterization possible:
% 
% plot_min = min(data_in); plot_max = max(data_in);
%   figure(81);
%             subplot(3,2,1); plot(data_in(:,1),data_in(:,2),'b.');hold on; title('1 vs 2'); plot([plot_min plot_max],[plot_min plot_max],'g');
%             subplot(3,2,2); plot(data_in(:,1),data_in(:,3),'b.');hold on; title('1 vs 3'); plot([plot_min plot_max],[plot_min plot_max],'g');
%             subplot(3,2,3); plot(data_in(:,1),data_in(:,4),'b.');hold on; title('1 vs 4'); plot([plot_min plot_max],[plot_min plot_max],'g');
%             subplot(3,2,4); plot(data_in(:,2),data_in(:,3),'b.');hold on; title('2 vs 3'); plot([plot_min plot_max],[plot_min plot_max],'g');
%             subplot(3,2,5); plot(data_in(:,2),data_in(:,4),'b.');hold on; title('2 vs 4'); plot([plot_min plot_max],[plot_min plot_max],'g');
%             subplot(3,2,6); plot(data_in(:,3),data_in(:,4),'b.');hold on; title('3 vs 4'); plot([plot_min plot_max],[plot_min plot_max],'g');
% 

for site_row = 1:1:num_sites
    for site_col = 1:1:num_sites
%         [lin(site_row,site_col).p lin(site_row,site_col).pred linadj(site_row,site_col).p linadj(site_row,site_col).pred] = Ts_fit(data_in(:,site_col),data_in(:,site_row));
        [lin(site_row,site_col).p linadj(site_row,site_col).pred] = Ts_fit(data_in(:,site_col),data_in(:,site_row));
        
        if status_matrix(site_row,site_col) == 0;
%             master_slopes(site_row, site_col) = lin(site_row,site_col).p(1);
%             master_r2(site_row, site_col) = lin(site_row,site_col).p(3);
            master_r2_adj(site_row, site_col) = lin(site_row,site_col).p(4);
 
        end
    end
end


%% FILL GAPS:

for site = 1:1:length(good_sites)  % This will cycle through only site data that are unempty

    [a, ix] = sort(master_r2_adj(good_sites(site),:),'descend'); % sort the r2 values to find best site data to fill it with:
    best(:,1) = ix(a>0);

    for kk = 1:1:length(best)
        
        empty_rows = find(isnan(data_out(:,good_sites(site)))); % find the rows that need to be filled
        
        data_out(empty_rows,good_sites(site)) = linadj(good_sites(site),best(kk)).pred(empty_rows);
        
%         tracker(isnan(data_in(:,good_sites(site))) & ~isnan(data_out(:,good_sites(site))) & tracker(:,good_sites(site)) == 0, good_sites(site)) = best(kk);
        
    end
end
data_filled = data_out;
%%% Final output of filled data:
% TP39_filled = data_out(:,1);
% TP74_filled = data_out(:,2);
% TP89_filled = data_out(:,3);
% TP02_filled = data_out(:,4);