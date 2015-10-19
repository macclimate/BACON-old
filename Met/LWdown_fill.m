
% Load and trim data:
load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master.mat');
master.data = master.data(master.data(:,1)>=2003 & master.data(:,1)<=2012,:);

PAR = master.data(:,118);
Ta = master.data(:,116);
RH = master.data(:,117);
Rn = master.data(:,121);
WS = master.data(:,119);
LW = master.data(:,53);


% Find usable points for nnet training:
ind_use = find(~isnan(prod([PAR Ta RH Rn WS LW],2)));
nn_inputs = [PAR(ind_use) Ta(ind_use) RH(ind_use) Rn(ind_use) WS(ind_use)];
                nn_target = LW(ind_use,1);
                % Train the NN:
                net = newfit(nn_inputs',nn_target',30);
                net=train(net,nn_inputs',nn_target');
                
                %%% Use the NN to simulate LW_down:
            ind_sim = find(~isnan(PAR.*Ta.*RH.*Rn.*WS));
            sim_inputs = [PAR(ind_sim) Ta(ind_sim) RH(ind_sim) Rn(ind_sim) WS(ind_sim)];
            [LW_pred,Pf,Af,E,perf] = sim(net,sim_inputs');
            LW_pred = LW_pred';
% Plot it:            
figure();clf;            
  plot(LW_pred,'r');hold on;
  plot(LW,'b');
     
  LW_fill = NaN.*ones(length(LW),2);
  LW_fill(:,1) = master.data(:,1);
 LW_fill(:,2) = LW;
 LW_fill(isnan(LW_fill(:,2)),2) = LW_pred(isnan(LW_fill(:,2)));
  
plot(LW_fill(:,2),'m');  
  
%%% Save the output:

save('/1/fielddata/Matlab/Data/Distributed/CLASS/LW_down_fill_2003_2011.mat','LW_fill');