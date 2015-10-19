function [] = old_mcm_Gapfill_LE_H_default(site,year)

if nargin == 1 || isempty(year)
    year = input('Enter Years to process, as integer (e.g. 2008) or sequence (e.g. 2003:2008): ');
end
year_start = min(year);
year_end = max(year);
clear year
%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/Gapfilling/' site '/LE_H/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
fig_path = [ls 'Matlab/Figs/Gapfilling/'];


%% Load defaults for each site.
%%% Distill whether there are different groups of data to process by
%%% looking for differences in rows of the default file:

default_header = jjb_hdr_read([ls 'Matlab/Data/Flux/Gapfilling/Docs/LE_H_Gapfilling_Defaults.csv'],',');
right_cols = find(strcmp(site,default_header(1,:))==1);
default = struct;
default_num = 1;
default(1).year = [];
ctr = 1;
for year= year_start:1:year_end
    right_row(ctr,1) = find(strcmp(num2str(year),default_header(:,right_cols(1)))==1);
    %     years(ctr,1) = year;
    if ctr == 1
        default(default_num).year = year;
        % default(default_num).model =
        % default_header{right_row(ctr,1),right_cols(2)};
    else
        % See if some setting has changed:
        diff_stat = strcmp(default_header{right_row(ctr,1),right_cols(2)}, default_header{right_row(ctr-1,1),right_cols(2)}).* ...
            strcmp(default_header{right_row(ctr,1),right_cols(3)}, default_header{right_row(ctr-1,1),right_cols(3)}).* ...
            strcmp(default_header{right_row(ctr,1),right_cols(4)}, default_header{right_row(ctr-1,1),right_cols(4)}).* ...
            strcmp(default_header{right_row(ctr,1),right_cols(5)}, default_header{right_row(ctr-1,1),right_cols(5)}).*...
            strcmp(default_header{right_row(ctr,1),right_cols(6)}, default_header{right_row(ctr-1,1),right_cols(6)});
        if diff_stat == 1
            default(default_num).year = [default(default_num).year; year];
        else
            default_num = default_num + 1;
            default(default_num).year = [];
            default(default_num).year = [default(default_num).year; year];
        end
    end
    
    default(default_num).model = default_header{right_row(ctr,1),right_cols(2)};
    default(default_num).ustar_th = default_header{right_row(ctr,1),right_cols(3)};
    default(default_num).fp = default_header{right_row(ctr,1),right_cols(4)};
    %%% This field lets us choose from which data we want from a file
    %%% (some gapfilling programs have multiple outputs - e.g. noVPD, etc.)
    tmp = default_header{right_row(ctr,1),right_cols(6)};
    
    default(default_num).model_tag = default_header{right_row(ctr,1),right_cols(6)};
    if strcmp('NaN',tmp)==1
        default(default_num).model_tag = default(default_num).model;
    else
        default(default_num).model_tag = [default(default_num).model '_' tmp];
    end
    clear tmp;
    ctr = ctr + 1;
end

%% Load data files:
sum_labels = {'Year';'LE_filled';'ET_filled';'H_filled'};
data_labels = {'LE_filled';'ET_filled';'H_filled'};

%%% Load the master gapfilling input file:
load([load_path site '_gapfill_data_in.mat']);

%%% Load the master file (if it exists).  Otherwise, make a new one:
if exist([save_path site '_Gapfill_LE_H_default_master.mat'],'file') == 2;
    load([save_path site '_Gapfill_LE_H_default_master.mat']);
else
%%%% Get an output file ready:
master.Year = data.Year;
master.LE_filled = NaN.*ones(length(data.Year),1);
master.ET_filled = NaN.*ones(length(data.Year),1);
master.H_filled = NaN.*ones(length(data.Year),1);
end

%%% Prepare the file of annual sums:
sums = NaN.*ones(year_end-year_start+1,4);
sums(:,1) = (year_start:1:year_end)';

%%% The first data trimming: Trim the data to the years entered to fill:
data = trim_data_files(data,year_start, year_end,0);

%%% Load footprint file:
load([footprint_path site '_footprint_flag.mat'])
tmp_fp_flag = footprint_flag.Schuepp70;
% Flag file for Schuepp 70% footprint:
fp_flag(:,1) = tmp_fp_flag(tmp_fp_flag(:,1) >= year_start & tmp_fp_flag(:,1) <= year_end,2);
% Flag file for No footprint:
fp_flag(:,2) = ones(length(fp_flag(:,1)),1); % The
data.fp_flag = fp_flag;

%% &&&&&&&&&&&&&&&&&&& Condition data, Conduct gapfilling: &&&&&&&&&&&&&&&
%%% Repeat procedures for different groups (if there is more than one group):
for grp = 1:1:length(default)
    yr_start = min(default(grp).year);
    yr_end = max(default(grp).year);
    %%% trim data to appropriate years:
    data_in = trim_data_files(data,yr_start,yr_end,1);
    data_in.site = site;
    %%% Apply Footprint
    switch default(grp).fp % Apply Schuepp 70% footprint:
        case 'on'
            data_in.LE = data_in.LE.*data_in.fp_flag(:,1);
            data_in.H = data_in.H.*data_in.fp_flag(:,1);
            
        case 'off' % No change in data
            data_in.LE = data_in.LE.*data_in.fp_flag(:,2);
            data_in.H = data_in.H.*data_in.fp_flag(:,2);   
    end
    %%% Calculate Ustar threshold:
    const_check = str2num(default(grp).ustar_th);
    if isempty(const_check)
        ustar_tag = default(grp).ustar_th;
        eval(['data_in.Ustar_th = ' default(grp).ustar_th '(data_in,0);'])
    else
        ustar_tag = ['Ustar_' default(grp).ustar_th];
        
        data_in.Ustar_th = const_check.*ones(length(data_in.Year),1);
    end
    fig_tag = ['(LE_H_default)_(FP_' default(grp).fp ')_(' ustar_tag ')_(' num2str(yr_start) '-' num2str(yr_end) ')'];
    %%% Calculate Random Error:
%     [data_in.NEE_std f_fit f_std] = NEE_random_error_estimator_v6(data_in,[],[],0);
%     figure(f_fit); print('-dpdf',[fig_path fig_tag '_std_fit']);   close(f_fit);
%     figure(f_std); print('-dpdf',[fig_path fig_tag '_std_pred']);  close(f_std);
    
    %%% Finally, run gapfilling:
    [results fig_out] = feval(['mcm_Gapfill_' default(grp).model],data_in,0,0);
    % Save output figure:
    for i = 1:1:length(fig_out)
        print('-dpdf',[fig_path fig_tag '_fig' num2str(i)])
    end
    close(fig_out);
    
    %%% If the gapfilling output (results) is more than 1-dimensional, then
    %%% we have to figure out which output we want (there may be more than
    %%% one dimension in cases where the gapfilling function has more than
    %%% one possible model output).
    for j = 1:1:length(results)
       if strcmp(results(j).tag, default(grp).model_tag)==1
           ind = j;
       end
    end
        
    %%% Now, take out of this the data that we need:
    for yr = yr_start:1:yr_end
        for j = 1:1:length(data_labels)
            try
                %           master.NEE_filled(master.Year == yr,1) = results.master.NEE_filled(results.master.Year==yr,1);
                eval(['master.' data_labels{j,1} '(master.Year == yr,1) = results(ind).master.' data_labels{j,1} '(results.master.Year==yr,1);']);
            catch
                eval(['master.' data_labels{j,1} '(master.Year == yr,1) = NaN;']);
                disp(['Problem transfering ' data_labels{j,1} ' to master file for year: ' num2str(yr)])
            end
        end
        try
            sums(sums(:,1)==yr,2:end) = results(ind).master.sums(sums(:,1)==yr,2:end);
        catch
            disp(['Problem with sums for year: ' num2str(yr)])
        end
    end
end

%% Save the final output:
% 1. Save the half-hourly flux output:
save([save_path site '_Gapfill_LE_H_default.mat'],'master');
% 2. Save the sums into a table that can be opened easily by a spreadsheet:
fid = fopen([save_path site '_LE_H_sums_' datestr(now,29) '.dat'],'w+');

%%% Print column headers:
for k = 1:1:length(sum_labels)
    fprintf(fid, '%10s\t',sum_labels{k,1});
end
%%% Set up the format code:
format_code = '\n %4.0f\t ';
for k = 2:1:size(sums,1)
    format_code = [format_code '%6.1f\t '];
end
%6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t  %6.1f\t
%%% Output the data to file:
for k = 1:1:size(sums,1)
    fprintf(fid, format_code, sums(k,:));
end
fclose(fid);






