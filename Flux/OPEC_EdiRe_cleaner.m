function [] = OPEC_EdiRe_cleaner(site)

if nargin == 0 || isempty(site)==1 || (~isempty(site) && ~ischar(site))
    site = input('Enter Site Name (e.g. TP74, TP02, etc): ','s'); %Gets site name
end

ls = addpath_loadstart('off');
%%% Declare Paths:
load_path = [ls 'Matlab/Data/Flux/OPEC/' site '/Organized/'];
% thresh_path = [ls 'Matlab/Data/Flux/OPEC/Docs/'];
thresh_path = [ls 'Matlab/Config/Flux/OPEC/']; % Changed 01-May-2012
save_path = [ls 'Matlab/Data/Flux/OPEC/' site '/Cleaned/'];
jjb_check_dirs(save_path,0);
%%% Load the Master File:
load([load_path site '_OPEC_EdiRe_master.mat']);

%%% Clean the data using thresholds
% load threshold file:
thresh = jjb_hdr_read([thresh_path site '_OPEC_EdiRe_thresholds.csv'],',');
low_thresh = NaN.*ones(length(thresh),1);
high_thresh = NaN.*ones(length(thresh),1);
% Start at the 7th column, since the first 6 are time variables
for j = 7:1:length(thresh)
    low_thresh(j,1) = str2num(char(thresh{j,4}));
    high_thresh(j,1) = str2num(char(thresh{j,5}));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Insert some site-specific cleans/fixes that need to be done before
%%%% doign threshold cleans
switch site
    case 'TP74'
        %fix upside-down Htc readings, and all measurements associated
        %with an upside-down thermocouple:
        cols_to_fix1 = [30 43];
        ind_fix1 = [13857:14530 30215:35635 52496:68563];
        master.data(ind_fix1,cols_to_fix1) = master.data(ind_fix1,cols_to_fix1).*-1;
        clear *fix1;
        
    case 'TP89'
                cols_to_fix1 = [30 43];
        ind_fix1 = [29079:29635 33056:35635 45489:46734 54796:78788 ];
        master.data(ind_fix1,cols_to_fix1) = master.data(ind_fix1,cols_to_fix1).*-1;
        clear *fix1;

    case 'TP02'
                cols_to_fix1 = [30 43];
        ind_fix1 = [29654:30210 55668:67024];
        master.data(ind_fix1,cols_to_fix1) = master.data(ind_fix1,cols_to_fix1).*-1;
        clear *fix1;

end

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Clean outliers from data using thresholds
[r c] = size(master.data);
skip_flag = 0;
for loop = 1:1:c
    if skip_flag == 0 && ~isnan(low_thresh(loop,1).*high_thresh(loop,1));
        accept = 1;
        % columns 4 and 5 are the lower/upper thresholds, respectively.
        if ~isnan(thresh{loop,4})
            var_title = [char(thresh{loop,2}) ' ('   char(thresh{loop,3})   ')' ];
            figure(1); clf;
            plot(master.data(:,loop),'b-'); hold on; grid on;
            set(gca, 'XMinorGrid','on');
            line([1 length(master.data)],[low_thresh(loop,1) low_thresh(loop,1)],'Color',[1 0 0], 'LineStyle','--'); %lower limit
            line([1 length(master.data)],[high_thresh(loop,1) high_thresh(loop,1)],'Color',[1 0 0], 'LineStyle','--'); %upper limit
            thresh_range = abs(high_thresh(loop,1)- low_thresh(loop,1));
            axis([1 length(master.data) low_thresh(loop,1)-(.1*thresh_range) high_thresh(loop,1)+(.1.*thresh_range)]);
            title([var_title ', column ' num2str(loop) ' of ' num2str(c)]);
            response = input('Press enter to accept, "1" to enter new thresholds, 9 to accept all thresholds, or any other key to reject: ', 's');
            
            if isequal(str2double(response),9)==1;
                skip_flag = 1;
            end

            %%% If user wants to change thresholds..
            if isequal(str2double(response),1)==1;
                accept = 0;
                
                while accept == 0;
                    low_lim = input('enter new lower limit: ','s');
                    low_thresh(loop,1) = str2double(low_lim);
                    up_lim = input('enter new upper limit: ','s');
                    high_thresh(loop,1) = str2double(up_lim);
                    %%% plot again
                    figure (1)
                    clf;
                    plot(master.data(:,loop),'b-'); hold on; grid on;
                    line([1 length(master.data)],[low_thresh(loop,1) low_thresh(loop,1)],'Color',[1 0 0], 'LineStyle','--'); %lower limit
                    line([1 length(master.data)],[high_thresh(loop,1) high_thresh(loop,1)],'Color',[1 0 0], 'LineStyle','--'); %upper limit
                    thresh_range = abs(high_thresh(loop,1)- low_thresh(loop,1));
                    axis([1 length(master.data) low_thresh(loop,1)-(.1*thresh_range) high_thresh(loop,1)+(.1.*thresh_range)]);
                    title([var_title ', column ' num2str(loop) ' of ' num2str(c)]);
                    accept_resp = input('hit enter to accept, 1 to change again: ','s');
                    if isempty(accept_resp)
                        accept = 1;
                    else
                        accept = 0;
                    end
                end
                
                saveflag = 1;
                
            end
            
            master.data(master.data(:,loop) < low_thresh(loop,1) | master.data(:,loop) > high_thresh(loop,1) ,loop) = NaN;
            %         else
            %         data(data(:,loop) < low_thresh(loop,1) | data(:,loop) > high_thresh(loop,1) ,loop) = NaN;
            
        end
    else
        master.data(master.data(:,loop) < low_thresh(loop,1) | master.data(:,loop) > high_thresh(loop,1) ,loop) = NaN;
    end
end

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Save threshold file (if it has been changed)
for j = 1:1:length(thresh);
    thresh{j,4} = low_thresh(j,1);
    thresh{j,5} = high_thresh(j,1);
end

format = '%s';
fid = fopen([thresh_path site '_OPEC_EdiRe_thresholds.csv'],'w');
for j = 1:1:length(thresh)
    for k = 1:1:3
        fprintf(fid, format, [char(thresh{j,k}) ',']);
    end
    fprintf(fid, '%10.4g',thresh{j,k+1});
    fprintf(fid,'%s', ',');
    fprintf(fid,'%10.4g\n', thresh{j,k+2});
end
fclose(fid);

%%% Save the cleaned master file to the /Matlab/Data/Flux/OPEC/<site>/Cleaned/ Folder:
disp(['saving data to ' save_path site '_OPEC_EdiRe_cleaned.mat']);
save([save_path site '_OPEC_EdiRe_cleaned.mat'],'master');
disp('done!')


