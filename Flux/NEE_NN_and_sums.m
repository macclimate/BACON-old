
ind = find(~isnan(GEPraw.*GEP_pred_fixed) & GEPraw > 0);
p = polyfit(GEPraw(ind),GEP_pred_fixed(ind),1)
pred4 = polyval(p,GEPraw(ind));

ind2 = find(~isnan(GEPraw.*GEP_pred) & GEPraw > 0);
p2 = polyfit(GEPraw(ind2),GEP_pred(ind2),1)
pred24 = polyval(p2,GEPraw(ind2));


figure(98);clf
plot(GEPraw,GEP_pred_fixed,'b.')
hold on;
plot([0 35], [0 35],'y--','LineWidth',4)
plot(GEPraw(ind),pred4,'r-','LineWidth',3)
plot(GEPraw(ind2),pred24,'g-','LineWidth',3)
axis([0 40 0 40])
grid on;
set(gca,'YMinorGrid','on')
set(gca,'XMinorGrid','on')

%%%%%%%%%%%%%%%%%%%%%%%%

ind_use = find(~isnan(data.PAR.*data.Ts5.*data.Ta.*data.SM_a_filled.*data.VPD.*data.NEE.*data.Year) & (data.PAR > 15 | (data.PAR<=15 & data.Ustar >= 0.325))  );
% Input and target data for training:
nn_inputs = [data.PAR(ind_use) data.Ts5(ind_use) data.Ta(ind_use) data.SM_a_filled(ind_use) data.VPD(ind_use) data.Year(ind_use)];
nn_target = data.NEE(ind_use);
% Run training:
net = newfit(nn_inputs',nn_target',30);
net=train(net,nn_inputs',nn_target');

%%% Step 2: Use trained NN for prediction purposes:
% Index for prediction -- find where no NaNs in met data:
ind_sim = find(~isnan(data.PAR.*data.Ts5.*data.Ta.*data.SM_a_filled.*data.VPD.*data.Year));
sim_inputs = [data.PAR(ind_sim) data.Ts5(ind_sim) data.Ta(ind_sim) data.SM_a_filled(ind_sim) data.VPD(ind_sim) data.Year(ind_sim)];
% Run NN to predict LE
[Y,Pf,Af,E,perf] = sim(net,sim_inputs');
Y = Y';
% Assign predicted data to proper row in ouput (makes rows of predicted
% variable match the rows of the input LE file:
NN_NEE_est = NaN.*ones(length(data.NEE),1);
NN_NEE_est(ind_sim) = Y;
%%% Fill gaps in LE with predicted data:
% data.NEE_filled = data.LE;
% data.LE_filled(isnan(data.LE_filled),1) = NN_LE_est(isnan(data.LE_filled),1);
NEE_model = RE_model - GEP_model;
figure(96);clf
plot(data.NEE,'k'); hold on;
plot(NN_NEE_est,'b');
plot(NEE_model,'g')
[NEE_stats(1,1) NEE_stats(1,2) NEE_stats(1,3) NEE_stats(1,4)] = model_stats(NN_NEE_est, data.NEE,'off');

NEE_clean = data.NEE;
NEE_clean(data.PAR < 15 & data.Ustar < Ustar_th,1) = NaN;
NEE_filled = NEE_clean;
NEE_filled(isnan(NEE_filled),1) = NEE_model(isnan(NEE_filled),1);



ctr = 1;
for yr = 2003:1:2009
   NEE_sum(ctr,1) = sum(NN_NEE_est(data.Year == yr,1)).*0.0216;
   NEE_model_sum(ctr,1) = sum(NEE_model(data.Year == yr,1)).*0.0216;
NEE_filled_sum(ctr,1) = sum(NEE_filled(data.Year == yr,1)).*0.0216;
   ctr = ctr +1 ; 
end
    

