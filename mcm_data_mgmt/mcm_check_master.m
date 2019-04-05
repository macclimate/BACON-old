function [] = mcm_check_master(site,plot_option)
%%% mcm_check_master.m
%%% This function allows the user to scroll through the master data file
%%% for a given site, to make sure it's ready for output to CCP files.
if nargin ==1
    resp1 = input('Enter <1> to plot all data in master; <2> to plot CCP data only; <3> to plot Ameriflux data: > ');
    switch resp1
        case 2
            plot_option = 'CCP';
        case 3
            plot_option = 'Ameriflux';
        otherwise
            plot_option = 'all';
    end
end

close all;

ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/' site '_data_master.mat'];

%%% Load the master file:
load(load_path);

switch plot_option
    case {2,'CCP'}
        cols_use = find(strcmp('NaN',master.labels(:,7))==0);
        cols_use = [(1:1:6)' ; cols_use];
        master.data = master.data(:,cols_use);
        master.labels = master.labels(cols_use,:);
    case {3,'Amerifux'}
        cols_use = find(strcmp('NaN',master.labels(:,14))==0 & cellfun(@isempty,master.labels(:,14))==0);
        cols_use = [(1:1:6)' ; cols_use];
        master.data = master.data(:,cols_use);
        master.labels = master.labels(cols_use,:);
end
%%% Added 20180329 by JJB - standardize first and last years that are
%%% plotted
tmp = ~isnan(master.data(:,7:end));
tmp2 = sum(tmp,2);
min_year = master.data(find(tmp2>0,1,'first'),1);
max_year = master.data(find(tmp2>0,1,'last'),1);
clear tmp tmp2

j = 1;
% op = [723   304   518   465];
while j <= size(master.labels,1)
    
    tag_name = master.labels{j,1};
%     min_year = master.data(find(~isnan(master.data(:,j)),1,'first'),1);
%     max_year = master.data(find(~isnan(master.data(:,j)),1,'last'),1);
%     if isempty(min_year) || isempty(max_year)
%         %         f1 = figure('Name', tag_name, 'OuterPosition', op);
%         figure(1);
%         plot(master.data(:,j),'b.-');
%         ylabel(master.labels{j,2});
%         xlabel('Date');
%         title([tag_name ' -- C:' num2str(j) ' of ' num2str(size(master.labels,1))]);
%         grid on;
%         
%     else
        ind = find(master.data(:,1) >= min_year & master.data(:,1) <= max_year);
        
        dt_plot = master.data(ind,1)+master.data(ind,6)./367;
        %         f1 = figure('Name', tag_name, 'OuterPosition', op);
        figure(1);
        plot(dt_plot,master.data(ind,j),'b.-');
        ylabel(master.labels{j,2});
        xlabel('Date');
        title([tag_name ' -- C:' num2str(j) ' of ' num2str(size(master.labels,1))]);
        grid on;
%         axis tight;
        set(gca,'XLim',[min_year, max_year+1]);
%     end
    response = input('Press <enter> to move forward, or <1> to move backward: > ', 's');
    
    if isempty(response)==1
        j = j+1;
        
    elseif strcmp(response,'1')==1 && j > 1;
        j = j-1;
    else
    end
    %                 op = get(gcf,'OuterPosition');
    clf;
    
end
mcm_start_mgmt;