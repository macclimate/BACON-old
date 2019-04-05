
clear all;
load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_gapfill_data_in.mat')

data = trim_data_files(data,2003,2017,1);

inputs = [data.Ta data.WS data.RH data.PAR];
target = data.Rn;

        ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target));
        training_inputs = inputs(ind_use_all,:);
        training_target = target(ind_use_all,:);
        nnet_TP39.net = newfit(training_inputs',training_target',30);
%         nnet.net.trainParam.showWindow = false;
        nnet_TP39.net =train(nnet_TP39.net,training_inputs',training_target');
        %%% Prediction:
        %%% Index for prediction -- find where no NaNs in met data:
        ind_sim_all = find(~isnan(prod(inputs,2)));
        sim_inputs = inputs(ind_sim_all,:);
        %%% Run NN to predict
%         [Y,Pf,Af,E,perf] = sim(nnet_TP39.net,sim_inputs');
%         Y = Y';
%         % Assign predicted data to proper row in ouput
%         figure(1);clf;
%         plot(data.Rn,'b');hold on;
%         plot(Y,'r')
%         
%         figure(2);clf;
%         plot(Y,'r');hold on;
%         plot(data.Rn,'b');hold on;
%   
%         
%         figure(3);clf
%     plot(data.PAR,data.SW_down,'k.');
    
    
%     nnet2.net = newfit(training_inputs',training_target',10);
% %         nnet.net.trainParam.showWindow = false;
%         nnet2.net =train(nnet2.net,training_inputs',training_target');
%         %%% Prediction:
%         %%% Index for prediction -- find where no NaNs in met data:
% 
%         %%% Run NN to predict
%         [Y2,Pf,Af,E,perf] = sim(nnet2.net,sim_inputs');
%         Y2 = Y2';
%         disp('completed successfully.');
                save('/1/fielddata/Matlab/Data/Met/Final_Filled/Rn_nnet/TP39_nnet.mat','nnet_TP39');
%% TP74        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear data;
        load('/1/fielddata/Matlab/Data/Master_Files/TP74/TP74_gapfill_data_in.mat')

data = trim_data_files(data,2003,2017,1);

inputs = [data.Ta data.WS data.RH data.PAR];
target = data.Rn;

        ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target));
        training_inputs = inputs(ind_use_all,:);
        training_target = target(ind_use_all,:);
        nnet_TP74.net = newfit(training_inputs',training_target',30);
%         nnet.net.trainParam.showWindow = false;
        nnet_TP74.net =train(nnet_TP74.net,training_inputs',training_target');
                save('/1/fielddata/Matlab/Data/Met/Final_Filled/Rn_nnet/TP74_nnet.mat','nnet_TP74');

%% TP89        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear data;
        load('/1/fielddata/Matlab/Data/Master_Files/TP89/TP89_gapfill_data_in.mat')

data = trim_data_files(data,2003,2008,1);

inputs = [data.Ta data.WS data.RH data.PAR];
target = data.Rn;

        ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target));
        training_inputs = inputs(ind_use_all,:);
        training_target = target(ind_use_all,:);
        nnet_TP89.net = newfit(training_inputs',training_target',30);
%         nnet.net.trainParam.showWindow = false;
        nnet_TP89.net =train(nnet_TP89.net,training_inputs',training_target');
                        save('/1/fielddata/Matlab/Data/Met/Final_Filled/Rn_nnet/TP89_nnet.mat','nnet_TP89');

%% TP02        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear data;
        load('/1/fielddata/Matlab/Data/Master_Files/TP02/TP02_gapfill_data_in.mat')

data = trim_data_files(data,2003,2017,1);

inputs = [data.Ta data.WS data.RH data.PAR];
target = data.Rn;

        ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target));
        training_inputs = inputs(ind_use_all,:);
        training_target = target(ind_use_all,:);
        nnet_TP02.net = newfit(training_inputs',training_target',30);
%         nnet.net.trainParam.showWindow = false;
        nnet_TP02.net =train(nnet_TP02.net,training_inputs',training_target');
              save('/1/fielddata/Matlab/Data/Met/Final_Filled/Rn_nnet/TP02_nnet.mat','nnet_TP02');
  
%% TPD: -- Update this at a later point:

        clear data;
       try  
          load('/1/fielddata/Matlab/Data/Master_Files/TPD/TPD_gapfill_data_in.mat')
data = trim_data_files(data,2012,2017,1);
       catch
        load('/1/fielddata/Matlab/Data/Met/Final_Cleaned/TPD/TPD_met_cleaned_2012.mat')
master.labels = cellstr(master.labels);
data.Ta = master.data(:,strcmp(master.labels(:,1),'AirTemp_AbvCnpy')==1);
data.WS = master.data(:,strcmp(master.labels(:,1),'WindSpd')==1);
data.RH = master.data(:,strcmp(master.labels(:,1),'RelHum_AbvCnpy')==1);
data.PAR = master.data(:,strcmp(master.labels(:,1),'DownPAR_AbvCnpy')==1);
data.Rn = master.data(:,strcmp(master.labels(:,1),'NetRad_AbvCnpy')==1);
       end

inputs = [data.Ta data.WS data.RH data.PAR];
target = data.Rn;

        ind_use_all = find(~isnan(prod(inputs,2)) & ~isnan(target));
        training_inputs = inputs(ind_use_all,:);
        training_target = target(ind_use_all,:);
        nnet_TPD.net = newfit(training_inputs',training_target',30);
%         nnet.net.trainParam.showWindow = false;
        nnet_TPD.net =train(nnet_TPD.net,training_inputs',training_target');
        save('/1/fielddata/Matlab/Data/Met/Final_Filled/Rn_nnet/TPD_nnet.mat','nnet_TPD');

%% SAVE:        
        