function [] = mcm_metfill_tmp(year)
close all;
mcm_start_mgmt;    

% This will give us year (number) and yr_str (string)
if ischar(year)
    yr_str = year;
    year = str2num(year);
else
    yr_str = num2str(year);
end

ls = addpath_loadstart;

%%% If after 2008, exclude TP89 -- discontinued
if year <= 2008
site_labels = ['TP39'; 'TP74';'TP89'; 'TP02'];
site_refs = (1:1:4)';
TP39 = []; TP89 = []; TP74 = []; TP02 = [];
else
site_labels = ['TP39'; 'TP74'; 'TP02'];
site_refs = [1;2;4];
TP39 = []; TP74 = []; TP02 = [];
end
[num_sites ~] = size(site_labels);


master_out_path =           [ls 'Matlab/Data/Master_Files/'];
save_path = [ls 'Matlab/Data/Met/Final_Filled/'];


% info = struct;
%  for i = 1:1:num_sites
%      
% %     %%% Declare Paths:
% %     if year >= 2008 || (year == 2007 && i == 1)
% %         %Path for Cleaned data -- 2008 onwards:
% %         
% %         
% %         info(i).hdr_path = [ls 'Matlab/Data/Met/Raw1/Docs/'];
% %         info(i).hdr_name = '_OutputTemplate.csv';
% %         info(i).hdr_cols = 3;
% %         info(i).load_dir = [ls 'Matlab/Data/Met/Final_Cleaned/'];
% %     else
% %         info(i).hdr_path = [ls 'Matlab/Data/Met/Final_Cleaned/CCP/Headers/'];
% %         info(i).hdr_name = '_CCP_Names.csv';
% %         info(i).hdr_cols = 2;
% %         info(i).load_dir = [ls 'Matlab/Data/Met/Final_Cleaned/CCP/'];
% %     end
% %     
% info.header = jjb_hdr_read([master_out_path '/Docs/' site_labels(i,:) '_master_list.csv'],',');
% 
%  end
%%% Load Header for the site:




% Load the file that keeps track of what pits were used in Ts averaging:
soil_tracker_path = [ls 'Matlab/Data/Met/Final_Filled/Docs/'];
if exist([soil_tracker_path 'soil_pit_keep_' num2str(year) '.dat'],'file')==2
    
    resp_tracker = input('Tracker for soil pit averaging found.  Enter <1> to use these values, <0> to input manually: ');
    if resp_tracker == 1
        prompt_flag = 1;
        soil_tracker = csvread([soil_tracker_path 'soil_pit_keep_' num2str(year) '.dat']);   
    else
        
        prompt_flag = 0;
        soil_tracker = zeros(6,4);
    end
    
else
    disp('tracker for soil pit averaging not found. Must be done manually');
    soil_tracker = zeros(6,4);
    prompt_flag = 0;
    
end

%%%
labels(1,1) = cellstr('AirTemp_AbvCnpy'); labels(1,2) = cellstr('RelHum_AbvCnpy'); 
labels(1,3) = cellstr('DownPAR_AbvCnpy'); labels(1,4) = cellstr('WindSpd'); 
labels(1,5) = cellstr('Pressure'); labels(1,6) = cellstr('SoilTemp_2cm'); 
labels(1,7) = cellstr('SoilTemp_5cm'); labels(1,8) = cellstr('SoilTemp_10cm'); 
labels(1,9) = cellstr('SoilTemp_20cm'); labels(1,10) = cellstr('SoilTemp_50cm'); 
labels(1,11) = cellstr('SoilTemp_100cm'); labels(1,12) = cellstr('SM_A_30_avg'); 
labels(1,13) = cellstr('SM_B_30_avg'); 

%% Load data:
% We want to load the following data:
% Ta, Ts, SM, PAR, WS, APR
% Ts must be averaged and then filled
% SM is just going to be averaged (over top 30cm)
% APR -- will likely have sites without pressure data at all.


for i = 1:1:num_sites
    site = site_labels(i,:);
    %%%% Load Data
    load([master_out_path site '/' site '_data_master.mat']);
    
%     data(1).header = jjb_hdr_read([info(i).hdr_path site info(i).hdr_name], ',', info(i).hdr_cols);
%     temp(1).load_path = [info(i).load_dir site '/' site '_' yr_str '.'];
    %%%% Load Variables:
    temp(1).Ta = sf_load_from_master(year, master,'AirTemp_AbvCnpy');
    temp(1).RH = sf_load_from_master(year, master,'RelHum_AbvCnpy');
    temp(1).PAR = sf_load_from_master(year, master,'DownPAR_AbvCnpy');
    temp(1).WS = sf_load_from_master(year, master,'WindSpd');
    temp(1).Wdir = sf_load_from_master(year, master,'WindDir');
    
    Ts(i).Ts2a = sf_load_from_master(year, master,'SoilTemp_A_2cm');
    Ts(i).Ts2b = sf_load_from_master(year, master,'SoilTemp_B_2cm');
    Ts(i).Ts5a = sf_load_from_master(year, master,'SoilTemp_A_5cm');
    Ts(i).Ts5b = sf_load_from_master(year, master,'SoilTemp_B_5cm');
    Ts(i).Ts10a = sf_load_from_master(year, master,'SoilTemp_A_10cm');
    Ts(i).Ts10b = sf_load_from_master(year, master,'SoilTemp_B_10cm');
    Ts(i).Ts20a = sf_load_from_master(year, master,'SoilTemp_A_20cm');
    Ts(i).Ts20b = sf_load_from_master(year, master,'SoilTemp_B_20cm');
    Ts(i).Ts50a = sf_load_from_master(year, master,'SoilTemp_A_50cm');
    Ts(i).Ts50b = sf_load_from_master(year, master,'SoilTemp_B_50cm');
    Ts(i).Ts100a = sf_load_from_master(year, master,'SoilTemp_A_100cm');
    Ts(i).Ts100b = sf_load_from_master(year, master,'SoilTemp_B_100cm');
    
    SM(i).SM5a = sf_load_from_master(year, master,'SM_A_5cm');
    SM(i).SM5b = sf_load_from_master(year, master,'SM_B_5cm');
    SM(i).SM10a = sf_load_from_master(year, master,'SM_A_10cm');
    SM(i).SM10b = sf_load_from_master(year, master,'SM_B_10cm');
    SM(i).SM20a = sf_load_from_master(year, master,'SM_A_20cm');
    SM(i).SM20b = sf_load_from_master(year, master,'SM_B_20cm');
    SM(i).SM50a = sf_load_from_master(year, master,'SM_A_50cm');
    SM(i).SM50b = sf_load_from_master(year, master,'SM_B_50cm');
    
     %%%%% APR might not exist, so if it doesn't, we don't load it.
        try
            data(i).APR = sf_load_from_master(year, master,'Pressure');
    
        catch
            data(i).APR = NaN.*ones(length(temp(1).Ta),1);

            disp(['Can''t find Pressure data for site ' site]);
%             lasterror
        end
    
    
% 
%     
%         temp(1).Ta = jjb_load_var(data(1).header, temp(1).load_path, 'AirTemp_AbvCnpy',2);
%         temp(1).RH = jjb_load_var(data(1).header, temp(1).load_path, 'RelHum_AbvCnpy',2);
%         temp(1).PAR = jjb_load_var(data(1).header, temp(1).load_path, 'DownPAR_AbvCnpy',2);
%         temp(1).WS = jjb_load_var(data(1).header, temp(1).load_path, 'WindSpd',2);
%         temp(1).Wdir = jjb_load_var(data(1).header, temp(1).load_path, 'WindDir',2);
%         
%         %%% We're making Ts load into a different variable because we
%         %%% need to do some averaging before we put it in the final file..
%         Ts(i).Ts5a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_5cm',2);
%         Ts(i).Ts5b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_5cm',2);
%         
%         Ts(i).Ts2a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_2cm',2);
%         Ts(i).Ts2b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_2cm',2);
%         
%         Ts(i).Ts10a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_10cm',2);
%         Ts(i).Ts10b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_10cm',2);
%         
%         Ts(i).Ts20a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_20cm',2);
%         Ts(i).Ts20b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_20cm',2);        
%         
%         Ts(i).Ts50a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_50cm',2);
%         Ts(i).Ts50b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_50cm',2);        
%         
%         try
%         Ts(i).Ts100a = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_A_100cm',2);
%         catch
%           Ts(i).Ts100a = NaN.*ones(length(Ts(i).Ts10a),1);
%          disp('Problem loading 100cm Ts data from Pit A.');
%          lasterror
%         end
%         
%         try
%         Ts(i).Ts100b = jjb_load_var(data(1).header, temp(1).load_path, 'SoilTemp_B_100cm',2);        
%         catch
%         Ts(i).Ts100b = NaN.*ones(length(Ts(i).Ts10a),1);
%         disp('Problem loading 100cm Ts data rom Pit B.');
%         lasterror
%         end
%         
%         %%% We're making SM load into a different variable because we
%         %%% really don't need to fill it at all..
%         SM(i).SM5a = jjb_load_var(data(1).header, temp(1).load_path, 'SM_A_5cm',2);
%         SM(i).SM5b = jjb_load_var(data(1).header, temp(1).load_path, 'SM_B_5cm',2);
%         SM(i).SM10a = jjb_load_var(data(1).header, temp(1).load_path, 'SM_A_10cm',2);
%         SM(i).SM10b = jjb_load_var(data(1).header, temp(1).load_path, 'SM_B_10cm',2);
%         SM(i).SM20a = jjb_load_var(data(1).header, temp(1).load_path, 'SM_A_20cm',2);
%         SM(i).SM20b = jjb_load_var(data(1).header, temp(1).load_path, 'SM_B_20cm',2);
%         SM(i).SM50a = jjb_load_var(data(1).header, temp(1).load_path, 'SM_A_50cm',2);
%         SM(i).SM50b = jjb_load_var(data(1).header, temp(1).load_path, 'SM_B_50cm',2);        
            
%         %% APR might not exist, so if it doesn't, we don't load it.
%         try
%             data(i).APR = jjb_load_var(data(1).header, temp(1).load_path, 'Pressure',2);
%         catch
%             data(i).APR = NaN.*ones(length(temp(1).Ta),1);
%             disp(['Can''t find Pressure data for site ' site]);
% %             lasterror
%         end
        
        %% This command restructures all the variables from temp into one
        %% matrix per site --  removed first column that was just a 'year'
        %% tag year.*ones(length(temp(1).Ta),1)
        % Any variables you want filled, throw into this matrix..
        eval([site ' = [' site ' ;  temp(1).Ta temp(1).RH temp(1).PAR temp(1).WS];' ]);

        clear temp master;     
end

        
%% Step 2:  Do Some averaging for Ts 2--100cm:

for i = 1:1:num_sites
        site = site_labels(i,:);
        right_col = site_refs(i);
    figure('Name',[site ': Ts'],'NumberTitle','off'); clf;
        subplot(3,2,1); plot(Ts(i).Ts2a,'b'); hold on; plot(Ts(i).Ts2b,'c');title('2cm'); legend('Pit A', 'Pit B');
        subplot(3,2,2); plot(Ts(i).Ts5a,'b'); hold on; plot(Ts(i).Ts5b,'c');title('5cm')
        subplot(3,2,3); plot(Ts(i).Ts10a,'b'); hold on; plot(Ts(i).Ts10b,'c');title('10cm')
        subplot(3,2,4); plot(Ts(i).Ts20a,'b'); hold on; plot(Ts(i).Ts20b,'c');title('20cm')
        subplot(3,2,5); plot(Ts(i).Ts50a,'b'); hold on; plot(Ts(i).Ts50b,'c');title('50cm')
        subplot(3,2,6); plot(Ts(i).Ts100a,'b'); hold on; plot(Ts(i).Ts100b,'c');title('100cm')
  
        if prompt_flag == 1; 
            resp2 = soil_tracker(1,right_col); resp5 = soil_tracker(2,right_col); resp10 = soil_tracker(3,right_col); 
            resp20 = soil_tracker(4,right_col); resp50 = soil_tracker(5,right_col); resp100 = soil_tracker(6,right_col); 
        else
disp(['Please look at Ts data for ' site_labels(i,:)]);
resp2 = input('2cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');
resp5 = input('5cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');
resp10 = input('10cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');
resp20 = input('20cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');
resp50 = input('50cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');
resp100 = input('100cm -- enter <1> to use pit A only, <2> for pit B only, <3> to use average of both: ');

            soil_tracker(1,right_col) = resp2; soil_tracker(2,right_col)= resp5;  soil_tracker(3,right_col) = resp10; 
            soil_tracker(4,right_col) = resp20; soil_tracker(5,right_col)= resp50;  soil_tracker(6,right_col) = resp100;    

        end


switch resp2;   case 1; Ts(i).Ts2 = Ts(i).Ts2a;      case 2; Ts(i).Ts2 = Ts(i).Ts2b;    case 3; Ts(i).Ts2 = row_nanmean([Ts(i).Ts2a Ts(i).Ts2b]); end
switch resp5;   case 1; Ts(i).Ts5 = Ts(i).Ts5a;      case 2; Ts(i).Ts5 = Ts(i).Ts5b;    case 3; Ts(i).Ts5 = row_nanmean([Ts(i).Ts5a Ts(i).Ts5b]); end
switch resp10;  case 1; Ts(i).Ts10 = Ts(i).Ts10a;    case 2; Ts(i).Ts10 = Ts(i).Ts10b;  case 3; Ts(i).Ts10 = row_nanmean([Ts(i).Ts10a Ts(i).Ts10b]); end
switch resp20;  case 1; Ts(i).Ts20 = Ts(i).Ts20a;    case 2; Ts(i).Ts20 = Ts(i).Ts20b;  case 3; Ts(i).Ts20 = row_nanmean([Ts(i).Ts20a Ts(i).Ts20b]); end
switch resp50;   case 1; Ts(i).Ts50 = Ts(i).Ts50a;      case 2; Ts(i).Ts50 = Ts(i).Ts50b;    case 3; Ts(i).Ts50 = row_nanmean([Ts(i).Ts50a Ts(i).Ts50b]); end
switch resp100;  case 1; Ts(i).Ts100 = Ts(i).Ts100a;    case 2; Ts(i).Ts100 = Ts(i).Ts100b;  case 3; Ts(i).Ts100 = row_nanmean([Ts(i).Ts100a Ts(i).Ts100b]); end

ind_Ts2 = find(isnan(Ts(i).Ts2) & (~isnan(Ts(i).Ts2a) | ~isnan(Ts(i).Ts2b)));
if ~isempty(ind_Ts2);   Ts(i).Ts2(ind_Ts2) = row_nanmean([Ts(i).Ts2a(ind_Ts2) Ts(i).Ts2b(ind_Ts2)]); end
ind_Ts5 = find(isnan(Ts(i).Ts5) & (~isnan(Ts(i).Ts5a) | ~isnan(Ts(i).Ts5b)));
if ~isempty(ind_Ts5);   Ts(i).Ts5(ind_Ts5) = row_nanmean([Ts(i).Ts5a(ind_Ts5) Ts(i).Ts5b(ind_Ts5)]); end
ind_Ts10 = find(isnan(Ts(i).Ts10) & (~isnan(Ts(i).Ts10a) | ~isnan(Ts(i).Ts10b)));
if ~isempty(ind_Ts10);   Ts(i).Ts10(ind_Ts10) = row_nanmean([Ts(i).Ts10a(ind_Ts10) Ts(i).Ts10b(ind_Ts10)]); end
ind_Ts20 = find(isnan(Ts(i).Ts20) & (~isnan(Ts(i).Ts20a) | ~isnan(Ts(i).Ts20b)));
if ~isempty(ind_Ts20);   Ts(i).Ts20(ind_Ts20) = row_nanmean([Ts(i).Ts20a(ind_Ts20) Ts(i).Ts20b(ind_Ts20)]); end
ind_Ts50 = find(isnan(Ts(i).Ts50) & (~isnan(Ts(i).Ts50a) | ~isnan(Ts(i).Ts50b)));
if ~isempty(ind_Ts50);   Ts(i).Ts50(ind_Ts50) = row_nanmean([Ts(i).Ts50a(ind_Ts50) Ts(i).Ts50b(ind_Ts50)]); end
ind_Ts100 = find(isnan(Ts(i).Ts100) & (~isnan(Ts(i).Ts100a) | ~isnan(Ts(i).Ts100b)));
if ~isempty(ind_Ts100);   Ts(i).Ts100(ind_Ts100) = row_nanmean([Ts(i).Ts100a(ind_Ts100) Ts(i).Ts100b(ind_Ts100)]); end


clear resp2 resp5 resp10 resp20 resp50 resp100;
end

%% Step 3: Do 30cm averaging for SM:

for  i = 1:1:num_sites
    
   SM(i).SM30a = SM30cm_avg(SM(i).SM5a, SM(i).SM10a, SM(i).SM20a, SM(i).SM50a);
   SM(i).SM30b = SM30cm_avg(SM(i).SM5b, SM(i).SM10b, SM(i).SM20b, SM(i).SM50b);

end


%% Step 4: If Pressure has NaNs, just fill it with Pressure from TP39, then with Pressure from TP74:
for i = 1:1:num_sites

    ind_ok = find(isnan(data(i).APR)==1);
    data(i).APR(ind_ok,1) = data(1).APR(ind_ok,1); % fill with TP39 if needed
    ind_ok2 = find(isnan(data(i).APR)==1);
    data(i).APR(ind_ok2,1) = data(2).APR(ind_ok2,1); % fill with TP74 if needed
    
    ind_ok3 = find(isnan(data(i).APR)==1);
    data(i).APR(ind_ok3,1) = data(3).APR(ind_ok3,1); % fill with TP02 if needed
    
    ind_ok4 = find(isnan(data(i).APR)==1);
    data(i).APR(ind_ok4,1) = 99; % fill with 99 if there are still NaNs
    
end    
    

%% Put all variables into their proper site-label matricies:

for i = 1:1:num_sites
    site = site_labels(i,:);
eval([site '=[' site ' data(i).APR Ts(i).Ts2 Ts(i).Ts5 Ts(i).Ts10 Ts(i).Ts20 Ts(i).Ts50 Ts(i).Ts100 SM(i).SM30a SM(i).SM30b];']);    
end

%% Fill Ta, RH, PAR, WS using regression between sites:
%%% I am still not decided whether to parameterize these comparisons on one
%%% year of data, or to load in all years to get a better fit...

for i = 1:1:num_sites
site = site_labels(i,:);

    eval([site '_filled = ' site ';'])
%         TP39_filled = TP39;
%         TP74_filled = TP74;
%         TP89_filled = TP89;
%         TP02_filled = TP02;
end   

% We are only filling the first 4 variables in this method:
fill_cols = [1:1:4 6:7]';

for fill_loop = 1:1:length(fill_cols)
    tic; 
    
    left_side = '';
    right_side = '';
    for i = 1:1:num_sites
site = site_labels(i,:);
% left_side = [left_side site '_filled(:,fill_cols(fill_loop,1)) ']; 
right_side = [right_side site '(:,fill_cols(fill_loop,1)) '];
  
    end
    
    eval(['data_in = [' right_side '];']);
    data_filled = mcm_fillvars(data_in);
    
    for i = 1:1:num_sites
site = site_labels(i,:);
eval([site '_filled(:,' num2str(fill_cols(fill_loop,1)) ') = data_filled(:,' num2str(i) ');']);
    end
    clear data_filled;
    
%     eval(['[' left_side '] = mcm_fillvars(' right_side ');'])
    
%     if year >= 2009
%         
%     else 
%     [TP39_filled(:,fill_cols(fill_loop,1)) TP74_filled(:,fill_cols(fill_loop,1)) TP89_filled(:,fill_cols(fill_loop,1)) TP02_filled(:,fill_cols(fill_loop,1))] = mcm_fillvars(TP39(:,fill_cols(fill_loop,1)), TP74(:,fill_cols(fill_loop,1)), TP89(:,fill_cols(fill_loop,1)), TP02(:,fill_cols(fill_loop,1)));
%     end
    t = toc;
    disp(['one variable finished in ' num2str(t) ' seconds']);

end

%% Clean up RH values (if they are > 100);
    for i = 1:1:num_sites
site = site_labels(i,:);
eval([site '_filled(' site '_filled(:,2)>100,2) = 100; ' site '_filled(' site '_filled(:,2)<0,2) = 0;']);
eval([site '_filled(' site '_filled(:,3)<25,3) = 0;']);

    end

% 
% TP39_filled(TP39_filled(:,2)>100,2) = 100; TP39_filled(TP39_filled(:,2)<0,2) = 0;
% TP74_filled(TP74_filled(:,2)>100,2) = 100; TP74_filled(TP74_filled(:,2)<0,2) = 0;
% TP89_filled(TP89_filled(:,2)>100,2) = 100; TP89_filled(TP89_filled(:,2)<0,2) = 0;
% TP02_filled(TP02_filled(:,2)>100,2) = 100; TP02_filled(TP02_filled(:,2)<0,2) = 0;

%% We can try to fill Ts within sites by a regression with air temperature:
 % loops through Ts5 and Ts2
 
 for i = 1:1:num_sites
    site = site_labels(i,:);
    eval([ '[' site '_Ts2_px_y ' site '_Ts2_pred] = Ts_fit(' site '_filled(:,1), ' site '_filled(:,6),''pw'');']);
    eval([ '[' site '_Ts5_px_y ' site '_Ts5_pred] = Ts_fit(' site '_filled(:,1), ' site '_filled(:,7),''pw'');']);
       
    
 ind_Ts2 = eval(['find(isnan(' site '_filled(:,6))==1);']);
 ind_Ts5 = eval(['find(isnan(' site '_filled(:,7))==1);']);
 
 eval ([site '_filled(ind_Ts2,6) = ' site '_Ts2_pred(ind_Ts2,1);']);
 eval ([site '_filled(ind_Ts5,7) = ' site '_Ts5_pred(ind_Ts5,1);']);
    
 clear ind_Ts2 ind_Ts5;
    
 end

 %% Plot data for each site and Determine if there's any data still missing:
varnames(1,1) = cellstr('Ta'); varnames(2,1) = cellstr('RH'); varnames(3,1) = cellstr('PAR');
varnames(4,1) = cellstr('WS'); varnames(5,1) = cellstr('APR'); varnames(6,1) = cellstr('Ts2');
varnames(7,1) = cellstr('Ts5'); varnames(8,1) = cellstr('Ts10'); varnames(9,1) = cellstr('Ts20'); 
varnames(10,1) = cellstr('Ts50'); varnames(11,1) = cellstr('Ts100');
varnames(12,1) = cellstr('SM_30_avg');
% 
% varnames(12,1) = cellstr('SM5a'); varnames(13,1) = cellstr('SM5b');
% varnames(14,1) = cellstr('SM10a'); varnames(15,1) = cellstr('SM10b');
% varnames(16,1) = cellstr('SM20a'); varnames(17,1) = cellstr('SM20b');
plot_list = [(1:1:11) ];
for i = 1:1:num_sites
    site = site_labels(i,:);
    figure('Name',site_labels(i,:),'NumberTitle','off'); clf;
    for j = 1:1:12
        subplot(4,3,j);
        if j < 12
            eval (['plot(' site '_filled(:,j),''r'')']); hold on;
            eval (['plot(' site '(:,j),''b'')']);
        else
            eval (['plot(' site '_filled(:,j),''r'')']); hold on;
            eval (['plot(' site '_filled(:,j+1),''b'')']); hold on;
            legend('Pit A', 'Pit B');
        end
        
        title(char(varnames(j,1)));
        % find number of NaNs in each variable:
        nans(i,j) = eval (['length(find(isnan(' site '_filled(:,j))==1));']);
        
    end

end

%% Save the Final Data:

for i = 1:1:num_sites
    site = site_labels(i,:);
    
master.data = eval([site '_filled']);
master.labels = char(labels);  
    
    save([save_path '/' site '/' site '_met_filled_' yr_str '.mat'], 'master');
    clear master;
end

%%% Save soil_tracker:
csvwrite([soil_tracker_path 'soil_pit_keep_' num2str(year) '.dat'],soil_tracker)
disp('soil tracker saved');

disp('done!');

end

function [data_out] = sf_load_from_master(year, data_in,var_name)
right_col = find(strcmp(data_in.labels(:,3),var_name)==1 & strcmp(data_in.labels(:,5),'Final_Cleaned')==1);
data_out = data_in.data(data_in.data(:,1) == year,right_col);
end
