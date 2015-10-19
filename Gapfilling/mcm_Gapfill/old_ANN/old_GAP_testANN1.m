%% GAP_testANN1
%%% This script is the first written for the gap-filling paper.  The
%%% purpose of this script is to assess what the best method is to produce
%%% an 'artificial' NEE data set.
clear all;
%%% Beginning stuff:
site = 'TP39'; year_start = 2003; year_end = 2009; fp_type = 'none'; Ustar_th = 0.325;

clrs = [11 29 138; ... %     dark Blue
    253 127 26; ... %    orange
    213 0 25;   ... %    dark red
    192 14 198; ... %    purple
    25 191 64; ...  %    green
    186 191 200; ...%    grey
    36 193 227; ... %    light blue
    255 183 176; ...%    salmon
    102 73 41;   ...%    brown
    255 235 11; ... %    yellow
    3 97 19; ...    %    forest green
    241 16 249; ... %    hot purple
    ]./255;

%%% Declare Paths and Load Data:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/' site '_gapfill_data_in.mat'];
work_path = [ls 'Matlab/Data/GAP_Paper/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/' site '_footprint_flag.mat'];
load(load_path);

data = trim_data_files(data,year_start, year_end, 1);
data.site = site;
data.DOY = round(data.dt);

NEE_cleaned = NaN.*ones(length(data.NEE),1);
%% Do Footprint Filtering (if activated);
if strcmpi(fp_type, 'none') == 1;
else
    % Load the footprint flag file:
    load(footprint_path)
    eval(['tmp_flag = footprint_flag.' fp_type ';']);
    data.fp_flag = tmp_flag(tmp_flag(:,1) >= year_start & tmp_flag(:,1) <= year_end,2);
    %%% Remove NEE values when outside of footprint:
    data.NEE = data.NEE.*data.fp_flag;
end

%%% Make cleaned NEE file:
ind_cleaned = find(~isnan(data.NEE) & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th)));
NEE_cleaned(ind_cleaned,1) = data.NEE(ind_cleaned);
clear ind_cleaned;

%% Neural Network %1:%
if exist([work_path 'nnet1.mat'],'file') == 2
    nnet1_loadflag = input('NNet 1 exists, enter <1> to load, or <2> to rerun >> ');
else
    nnet1_loadflag = 2;
end
%%% Use the following variables:
% NEE, PAR, Ts5, Ta, SM, VPD, Year, DOY
inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.Year data.DOY];
target = NEE_cleaned;
%%%%%%%%%%% Step 1: Initialization and Training of ANN %%%%%%%%%%%%%
%%% Make an index of useable data:
ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target)); % & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th))  );
%%% Inputs and target for NN training:
training_inputs = inputs(ind_use_all,:);
training_target = target(ind_use_all,:);

if nnet1_loadflag == 2
    %%% Run training:
    nnet1 = newfit(training_inputs',training_target',30);
    nnet1=train(nnet1,training_inputs',training_target');
    save([work_path 'nnet1.mat'],'nnet1');
elseif nnet1_loadflag == 1
    load([work_path 'nnet1.mat']);
end

%%%%%%%%%%% Use ANN For Prediction Purposes %%%%%%%%%%%%%
%%% Index for prediction -- find where no NaNs in met data:
ind_sim_all = find(~isnan(prod(inputs,2)));
sim_inputs = inputs(ind_sim_all,:);
%%% Run NN to predict LE
[Y,Pf,Af,E,perf] = sim(nnet1,sim_inputs');
Y = Y';
% Assign predicted data to proper row in ouput (makes rows of predicted
% variable match the rows of the input LE file:
NEE_sim = NaN.*ones(length(data.NEE),1);
NEE_sim(ind_sim_all) = Y;

%%%%%%%%%%%% Plot Results: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(findobj('Tag','NN_results'));
    figure(findobj('Tag','NN_results')); clf;
else
    f1 = figure('Name','NN results vs. measured','Tag','NN_results');clf;
end
x_plot1 = data.Year + (data.dt)./367;
plot(x_plot1(ind_use_all), data.NEE(ind_use_all),'k.'); hold on;
plot(x_plot1(ind_sim_all), NEE_sim(ind_sim_all),'b');
legend('measured','simulated');

%%%%%%%%%%%% Sums and Stats: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    sums(ctr,1) = sum(NEE_sim(data.Year == yr),1).*0.0216;
    
    [RMSE(ctr,1) rRMSE(ctr,1) MAE(ctr,1) BE(ctr,1) R2(ctr,1)] = ...
        model_stats(NEE_sim(data.Year==yr), NEE_cleaned((data.Year==yr)), []);
    ctr = ctr+1;
end

[RMSE_all rRMSE_all MAE_all BE_all R2_all] = model_stats(NEE_sim, NEE_cleaned, []);

%%% Plot stats:
if ~isempty(findobj('Tag','NN_stats'));
    figure(findobj('Tag','NN_stats')); clf;
else
    f2 = figure('Name','NN stats','Tag','NN_stats');clf;
end
subplot(4,1,1);
plot(year_start:1:year_end,sums,'bo','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [mean(sums) mean(sums)],'b--');
title('sums');
grid on; axis auto;
subplot(4,1,2);
plot(year_start:1:year_end, RMSE,'ko','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [RMSE_all RMSE_all],'r--');
title('RMSE');
grid on; axis auto;
subplot(4,1,3);
plot(year_start:1:year_end, R2,'ko','MarkerSize',6,'MarkerFaceColor','g');hold on;
plot([year_start year_end], [R2_all R2_all],'g--');
title('R-squared');
grid on; axis auto;
subplot(4,1,4);
plot(year_start:1:year_end, BE,'ko','MarkerSize',6,'MarkerFaceColor','b');hold on;
plot([year_start year_end], [BE_all BE_all],'b--');
title('BE');
grid on; axis auto;

%% Neural Network #2 - Run Separately for Each Year:
clear inputs target ind_use;

if exist([work_path 'nnet2.mat'],'file') == 2
    nnet2_loadflag = input('NNet 2 exists, enter <1> to load, or <2> to rerun >> ');
else
    nnet2_loadflag = 2;
end
%%% Use the following variables:
% NEE, PAR, Ts5, Ta, SM, VPD, Year, DOY
inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.DOY];
target = NEE_cleaned;
%%%%%%%%%%% Step 1: Initialization and Training of ANN %%%%%%%%%%%%%
%%% Make an index of useable data:
% NEE_cleaned(ind_use,1) = data.NEE(ind_use,1);
%%% Inputs and target for NN training:

if nnet2_loadflag == 2
    NEE_sim2 = NaN.*ones(length(data.NEE),1);
    ctr = 1;
    for yr = year_start:1:year_end
        
        
        %%% Run training: %%%%%%%%%%%
        ind_use(ctr).nnet2 = find(~isnan(prod(inputs,2)) & ~isnan(target) & data.Year == yr);% & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th)) & data.Year ==  );
        training_inputs = inputs(ind_use(ctr).nnet2,:);
        training_target = target(ind_use(ctr).nnet2,:);
        nnet(ctr).nnet2 = newfit(training_inputs',training_target',30);
        nnet(ctr).nnet2=train(nnet(ctr).nnet2,training_inputs',training_target');
        clear training_inputs training_target;
        
        ctr = ctr+1;
    end
    
    
    save([work_path 'nnet2.mat'],'nnet');
elseif nnet2_loadflag == 1
    load([work_path 'nnet2.mat']);
end

%%%%%%%%%%%% Prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    %%% Index for prediction -- find where no NaNs in met data:
    ind_sim = find(~isnan(prod(inputs,2)) & data.Year == yr);
    sim_inputs = inputs(ind_sim,:);
    %%% Run NN to predict LE
    [Y,Pf,Af,E,perf] = sim(nnet(ctr).nnet2,sim_inputs');
    Y = Y';
    % Assign predicted data to proper row in ouput (makes rows of predicted
    % variable match the rows of the input LE file:
    NEE_sim2(ind_sim) = Y;
    clear Y Pf Af E perf ind_sim sim_inputs
    ctr = ctr+1;
end
%%%%%%%%%%%% Plot Results: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(findobj('Tag','NN2_results'));
    figure(findobj('Tag','NN2_results')); clf;
else
    f3 = figure('Name','NN2 results vs. measured','Tag','NN2_results');clf;
end
x_plot1 = data.Year + (data.dt)./367;
plot(x_plot1(ind_use_all), data.NEE(ind_use_all),'k.'); hold on;
plot(x_plot1(ind_sim_all), NEE_sim2(ind_sim_all),'b');
legend('measured','simulated');

%%%%%%%%%%%% Sums and Stats: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    sums2(ctr,1) = sum(NEE_sim2(data.Year == yr),1).*0.0216;
    
    [RMSE2(ctr,1) rRMSE2(ctr,1) MAE2(ctr,1) BE2(ctr,1) R22(ctr,1)] = ...
        model_stats(NEE_sim2(data.Year==yr), NEE_cleaned((data.Year==yr)), []);
    ctr = ctr+1;
end

[RMSE_all2 rRMSE_all2 MAE_all2 BE_all2 R2_all2] = model_stats(NEE_sim2, NEE_cleaned, []);

%%% Plot stats:
if ~isempty(findobj('Tag','NN2_stats'));
    figure(findobj('Tag','NN2_stats')); clf;
else
    f4 = figure('Name','NN2 stats','Tag','NN2_stats');clf;
end
subplot(4,1,1);
plot(year_start:1:year_end,sums2,'bo','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [mean(sums2) mean(sums2)],'b--');
title('sums');
grid on; axis auto;
subplot(4,1,2);
plot(year_start:1:year_end, RMSE2,'ko','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [RMSE_all2 RMSE_all2],'r--');
title('RMSE');
grid on; axis auto;
subplot(4,1,3);
plot(year_start:1:year_end, R22,'ko','MarkerSize',6,'MarkerFaceColor','g');hold on;
plot([year_start year_end], [R2_all2 R2_all2],'g--');
title('R-squared');
grid on; axis auto;
subplot(4,1,4);
plot(year_start:1:year_end, BE2,'ko','MarkerSize',6,'MarkerFaceColor','b');hold on;
plot([year_start year_end], [BE_all2 BE_all2],'b--');
title('BE');
grid on; axis auto;


%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%%% Neural Network #2b - Run Separately for Each Year, remove DOY as a variable:
clear inputs target;

if exist([work_path 'nnet2b.mat'],'file') == 2
    nnet2b_loadflag = input('NNet 2b exists, enter <1> to load, or <2> to rerun >> ');
else
    nnet2b_loadflag = 2;
end
%%% Use the following variables:
% NEE, PAR, Ts5, Ta, SM, VPD, Year, DOY
inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.GDD];
target = NEE_cleaned;
%%%%%%%%%%% Step 1: Initialization and Training of ANN %%%%%%%%%%%%%
%%% Make an index of useable data:
% NEE_cleaned(ind_use,1) = data.NEE(ind_use,1);
%%% Inputs and target for NN training:

if nnet2b_loadflag == 2
    NEE_sim2b = NaN.*ones(length(data.NEE),1);
    ctr = 1;
    for yr = year_start:1:year_end
        
        
        %%% Run training: %%%%%%%%%%%
        ind_use(ctr).nnet2b = find(~isnan(prod(inputs,2)) & ~isnan(target) & data.Year == yr);% & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th)) & data.Year ==  );
        training_inputs = inputs(ind_use(ctr).nnet2b,:);
        training_target = target(ind_use(ctr).nnet2b,:);
        nnet(ctr).nnet2b = newfit(training_inputs',training_target',30);
        nnet(ctr).nnet2b=train(nnet(ctr).nnet2b,training_inputs',training_target');
        clear training_inputs training_target;
        
        ctr = ctr+1;
    end
    
    
    save([work_path 'nnet2b.mat'],'nnet');
elseif nnet2b_loadflag == 1
    load([work_path 'nnet2b.mat']);
end

%%%%%%%%%%%% Prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    %%% Index for prediction -- find where no NaNs in met data:
    ind_sim = find(~isnan(prod(inputs,2)) & data.Year == yr);
    sim_inputs = inputs(ind_sim,:);
    %%% Run NN to predict LE
    [Y,Pf,Af,E,perf] = sim(nnet(ctr).nnet2b,sim_inputs');
    Y = Y';
    % Assign predicted data to proper row in ouput (makes rows of predicted
    % variable match the rows of the input LE file:
    NEE_sim2b(ind_sim) = Y;
    clear Y Pf Af E perf ind_sim sim_inputs
    ctr = ctr+1;
end
%%%%%%%%%%%% Plot Results: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(findobj('Tag','NN2b_results'));
    figure(findobj('Tag','NN2b_results')); clf;
else
    f6 = figure('Name','NN2b results vs. measured','Tag','NN2b_results');clf;
end
x_plot1 = data.Year + (data.dt)./367;
plot(x_plot1(ind_use_all), data.NEE(ind_use_all),'k.'); hold on;
plot(x_plot1(ind_sim_all), NEE_sim2b(ind_sim_all),'b');
legend('measured','simulated');

%%%%%%%%%%%% Sums and Stats: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    sums2b(ctr,1) = sum(NEE_sim2b(data.Year == yr),1).*0.0216;
    
    [RMSE2b(ctr,1) rRMSE2b(ctr,1) MAE2b(ctr,1) BE2b(ctr,1) R22b(ctr,1)] = ...
        model_stats(NEE_sim2b(data.Year==yr), NEE_cleaned((data.Year==yr)), []);
    ctr = ctr+1;
end

[RMSE_all2b rRMSE_all2b MAE_all2b BE_all2b R2_all2b] = model_stats(NEE_sim2b, NEE_cleaned, []);

%%% Plot stats:
if ~isempty(findobj('Tag','NN2b_stats'));
    figure(findobj('Tag','NN2b_stats')); clf;
else
    f7 = figure('Name','NN2b stats','Tag','NN2b_stats');clf;
end
subplot(4,1,1);
plot(year_start:1:year_end,sums2b,'bo','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [mean(sums2b) mean(sums2b)],'b--');
title('sums');
grid on; axis auto;
subplot(4,1,2);
plot(year_start:1:year_end, RMSE2b,'ko','MarkerSize',6,'MarkerFaceColor','r');hold on;
plot([year_start year_end], [RMSE_all2b RMSE_all2b],'r--');
title('RMSE');
grid on; axis auto;
subplot(4,1,3);
plot(year_start:1:year_end, R22b,'ko','MarkerSize',6,'MarkerFaceColor','g');hold on;
plot([year_start year_end], [R2_all2b R2_all2b],'g--');
title('R-squared');
grid on; axis auto;
subplot(4,1,4);
plot(year_start:1:year_end, BE2b,'ko','MarkerSize',6,'MarkerFaceColor','b');hold on;
plot([year_start year_end], [BE_all2b BE_all2b],'b--');
title('BE');
grid on; axis auto;

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%%% Neural Network #2c - Run Separately for Each Year, remove DOY as a variable:
%%% Use 45 nodes instead of 30
clear inputs target;

if exist([work_path 'nnet2c.mat'],'file') == 2
    nnet2c_loadflag = input('NNet 2c exists, enter <1> to load, or <2> to rerun >> ');
else
    nnet2c_loadflag = 2;
end
%%% Use the following variables:
% NEE, PAR, Ts5, Ta, SM, VPD, Year, DOY
inputs = [data.PAR data.Ts5 data.Ta data.SM_a_filled data.VPD data.GDD];
target = NEE_cleaned;
%%%%%%%%%%% Step 1: Initialization and Training of ANN %%%%%%%%%%%%%
%%% Make an index of useable data:
% NEE_cleaned(ind_use,1) = data.NEE(ind_use,1);
%%% Inputs and target for NN training:

if nnet2c_loadflag == 2
    NEE_sim2c = NaN.*ones(length(data.NEE),1);
    ctr = 1;
    for yr = year_start:1:year_end 
        %%% Run training: %%%%%%%%%%%
        ind_use(ctr).nnet2c = find(~isnan(prod(inputs,2)) & ~isnan(target) & data.Year == yr);% & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= Ustar_th)) & data.Year ==  );
        training_inputs = inputs(ind_use(ctr).nnet2c,:);
        training_target = target(ind_use(ctr).nnet2c,:);
        nnet(ctr).nnet2c = newfit(training_inputs',training_target',45);
        nnet(ctr).nnet2c=train(nnet(ctr).nnet2c,training_inputs',training_target');
        clear training_inputs training_target;
        
        ctr = ctr+1;
    end
    
    
    save([work_path 'nnet2c.mat'],'nnet');
elseif nnet2c_loadflag == 1
    load([work_path 'nnet2c.mat']);
end

%%%%%%%%%%%% Prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    %%% Index for prediction -- find where no NaNs in met data:
    ind_sim = find(~isnan(prod(inputs,2)) & data.Year == yr);
    sim_inputs = inputs(ind_sim,:);
    %%% Run NN to predict LE
    [Y,Pf,Af,E,perf] = sim(nnet(ctr).nnet2c,sim_inputs');
    Y = Y';
    % Assign predicted data to proper row in ouput (makes rows of predicted
    % variable match the rows of the input LE file:
    NEE_sim2c(ind_sim) = Y;
    clear Y Pf Af E perf ind_sim sim_inputs
    ctr = ctr+1;
end

%%%%%%%%%%%% Sums and Stats: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 1;
for yr = year_start:1:year_end
    sums2c(ctr,1) = sum(NEE_sim2c(data.Year == yr),1).*0.0216;
    
    [RMSE2c(ctr,1) rRMSE2c(ctr,1) MAE2c(ctr,1) BE2c(ctr,1) R22c(ctr,1)] = ...
        model_stats(NEE_sim2c(data.Year==yr), NEE_cleaned((data.Year==yr)), []);
    ctr = ctr+1;
end

[RMSE_all2c rRMSE_all2c MAE_all2c BE_all2c R2_all2c] = model_stats(NEE_sim2c, NEE_cleaned, []);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compare all models to each other:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compare results of all-years vs. indiv years:
%%%%%%%%%%%% Plot Results: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f5 = start_figure('NN1&2 results vs. measured','NN1&2_results');
% if ~isempty(findobj('Tag','NN1&2_results'));
%     figure(findobj('Tag','NN1&2_results')); clf;
% else
%     f5 = figure('Name','NN1&2 results vs. measured','Tag','NN1&2_results');clf;
% end
x_plot1 = data.Year + (data.dt)./367;
plot(x_plot1(ind_use_all), data.NEE(ind_use_all),'k.'); hold on;
plot(x_plot1(ind_sim_all), NEE_sim(ind_sim_all),'b');
plot(x_plot1(ind_sim_all), NEE_sim2(ind_sim_all),'r');
plot(x_plot1(ind_sim_all), NEE_sim2b(ind_sim_all),'g');
plot(x_plot1(ind_sim_all), NEE_sim2c(ind_sim_all),'Color',clrs(8,:));

legend('measured','simulated nnet1','simulated nnet2','simulated nnet2b','simulated nnet2c');

%%% Just for fun: See what estimated respiration looks like:
ind_RE = find(data.PAR < 15 | (data.PAR > 15 & data.Ts5 < 0.5));
ind_low_SM = find((data.PAR < 15 | (data.PAR > 15 & data.Ts5 < 0.5) ) & data.SM_a_filled < 0.06);

f8 = start_figure('NN1&2 Ts-Re','Ts-Re');
subplot(411);
plot(data.Ts5(ind_RE), NEE_cleaned(ind_RE),'k.');hold on;
plot(data.Ts5(ind_low_SM), NEE_cleaned(ind_low_SM),'r.');
title('Observed data');
subplot(412);
plot(data.Ts5(ind_RE), NEE_sim(ind_RE),'k.');hold on;
plot(data.Ts5(ind_low_SM), NEE_sim(ind_low_SM),'r.');
title('NN1');
subplot(413);
plot(data.Ts5(ind_RE), NEE_sim2(ind_RE),'k.');hold on;
plot(data.Ts5(ind_low_SM), NEE_sim2(ind_low_SM),'r.');
title('NN2');
subplot(414);
plot(data.Ts5(ind_RE), NEE_sim2b(ind_RE),'k.');hold on;
plot(data.Ts5(ind_low_SM), NEE_sim2b(ind_low_SM),'r.');
title('NN2b');

%%% Just for fun: Look for SM effect:
% ind_RE = find(data.PAR < 15 | (data.PAR > 15 & data.Ts5 < 0.5));
f9 = start_figure('NN1&2 Ts-SM-Re','Ts-SM-Re');
subplot(221);
plot3(data.Ts5(ind_RE), data.SM_a_filled(ind_RE), NEE_cleaned(ind_RE),'k.');hold on;
plot3(data.Ts5(ind_low_SM), data.SM_a_filled(ind_low_SM), NEE_cleaned(ind_low_SM),'r.');hold on;
axis tight; grid on;
title('Observed data');

subplot(222);
plot3(data.Ts5(ind_RE), data.SM_a_filled(ind_RE), NEE_sim(ind_RE),'k.');hold on;
plot3(data.Ts5(ind_low_SM), data.SM_a_filled(ind_low_SM), NEE_sim(ind_low_SM),'r.');hold on;
axis tight; grid on;
title('NN1');

subplot(223);
plot3(data.Ts5(ind_RE), data.SM_a_filled(ind_RE), NEE_sim2(ind_RE),'k.');hold on;
plot3(data.Ts5(ind_low_SM), data.SM_a_filled(ind_low_SM), NEE_sim2(ind_low_SM),'r.');hold on;
axis tight; grid on;
title('NN2');

subplot(224);
plot3(data.Ts5(ind_RE), data.SM_a_filled(ind_RE), NEE_sim2b(ind_RE),'k.');hold on;
plot3(data.Ts5(ind_low_SM), data.SM_a_filled(ind_low_SM), NEE_sim2b(ind_low_SM),'r.');hold on;
axis tight; grid on;
title('NN2b');

%%% Compare stats from each:

f10 = start_figure('NN_stats','NN_stats');
subplot(221)
h1(1) = plot(year_start:1:year_end,sums,'bo','MarkerSize',6,'MarkerFaceColor',clrs(1,:));hold on;
h1(2) = plot(year_start:1:year_end,sums2,'ks','MarkerSize',6,'MarkerFaceColor',clrs(2,:));hold on;
h1(3) = plot(year_start:1:year_end,sums2b,'kp','MarkerSize',10,'MarkerFaceColor',clrs(4,:));hold on;
h1(4) = plot(year_start:1:year_end,sums2c,'kv','MarkerSize',6,'MarkerFaceColor',clrs(5,:));hold on;
legend(h1, 'NN1','NN2','NN2b','NN2c')
grid on;title('Sums');
subplot(222);
h1(1) = plot(year_start:1:year_end,RMSE,'bo','MarkerSize',6,'MarkerFaceColor',clrs(1,:));hold on;
h1(2) = plot(year_start:1:year_end,RMSE2,'ks','MarkerSize',6,'MarkerFaceColor',clrs(2,:));hold on;
h1(3) = plot(year_start:1:year_end,RMSE2b,'kp','MarkerSize',10,'MarkerFaceColor',clrs(4,:));hold on;
h1(4) = plot(year_start:1:year_end,RMSE2c,'kv','MarkerSize',6,'MarkerFaceColor',clrs(5,:));hold on;
legend(h1, 'NN1','NN2','NN2b','NN2c')
grid on;title('RMSE');
subplot(223);
h1(1) = plot(year_start:1:year_end,R2,'bo','MarkerSize',6,'MarkerFaceColor',clrs(1,:));hold on;
h1(2) = plot(year_start:1:year_end,R22,'ks','MarkerSize',6,'MarkerFaceColor',clrs(2,:));hold on;
h1(3) = plot(year_start:1:year_end,R22b,'kp','MarkerSize',10,'MarkerFaceColor',clrs(4,:));hold on;
h1(4) = plot(year_start:1:year_end,R22c,'kv','MarkerSize',6,'MarkerFaceColor',clrs(5,:));hold on;
legend(h1, 'NN1','NN2','NN2b','NN2c')
grid on;title('R2');
subplot(224);
h1(1) = plot(year_start:1:year_end,BE,'bo','MarkerSize',6,'MarkerFaceColor',clrs(1,:));hold on;
h1(2) = plot(year_start:1:year_end,BE2,'ks','MarkerSize',6,'MarkerFaceColor',clrs(2,:));hold on;
h1(3) = plot(year_start:1:year_end,BE2b,'kp','MarkerSize',10,'MarkerFaceColor',clrs(4,:));hold on;
h1(4) = plot(year_start:1:year_end,BE2c,'kv','MarkerSize',6,'MarkerFaceColor',clrs(5,:));hold on;
legend(h1, 'NN1','NN2','NN2b','NN2c')
grid on;title('BE');
