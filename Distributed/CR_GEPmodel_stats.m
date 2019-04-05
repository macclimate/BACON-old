alpha = 0.05

[GEP_reg(1).b,GEP_reg(1).bint,GEP_reg(1).r,GEP_reg(1).rint,GEP_reg(1).stats] = regress_analysis(GEP2003_bavg(1:16,2),[GEP2003_bavg(1:16,1) ones(16,1)],alpha);

[GEP_reg(2).b,GEP_reg(2).bint,GEP_reg(2).r,GEP_reg(2).rint,GEP_reg(2).stats] = regress_analysis(GEP2004_bavg(1:16,2),[GEP2004_bavg(1:16,1) ones(16,1)],alpha);

[GEP_reg(3).b,GEP_reg(3).bint,GEP_reg(3).r,GEP_reg(3).rint,GEP_reg(3).stats] = regress_analysis(GEP2005_bavg(1:16,2),[GEP2005_bavg(1:16,1) ones(16,1)],alpha);

[GEP_reg(4).b,GEP_reg(4).bint,GEP_reg(4).r,GEP_reg(4).rint,GEP_reg(4).stats] = regress_analysis(GEPa_bavg(1:16,2),[GEPa_bavg(1:16,1) ones(16,1)],alpha);

for jk = 1:1:4
%     sl_int(jk,:) = GEP_reg(jk).b;
%     stats(jk,:) = GEP_reg(jk).stats;
    stats1_16(jk,1:2) = GEP_reg(jk).b;
    stats1_16(jk,3) = GEP_reg(jk).stats(1,1);
    
end

%% Calculate More Stats
% RMSE
RMSE(1,1) = (sum((GEP2003_bavg(1:16,2)- GEP2003_bavg(1:16,1)).^2))./14;
RMSE(2,1) = (sum((GEP2004_bavg(1:16,2)- GEP2004_bavg(1:16,1)).^2))./14;
RMSE(3,1) = (sum((GEP2005_bavg(1:16,2)- GEP2005_bavg(1:16,1)).^2))./14;
RMSE(4,1) = (sum((GEPa_bavg(1:16,2)- GEPa_bavg(1:16,1)).^2))./14;

stats1_16 = [stats1_16 RMSE];
%% Calculate same stats but for high GEP
[GEP_reg2(1).b,GEP_reg2(1).bint,GEP_reg2(1).r,GEP_reg2(1).rint,GEP_reg2(1).stats] = regress_analysis(GEP2003_bavg(17:34,2),[GEP2003_bavg(17:34,1) ones(18,1)],alpha);

[GEP_reg2(2).b,GEP_reg2(2).bint,GEP_reg2(2).r,GEP_reg2(2).rint,GEP_reg2(2).stats] = regress_analysis(GEP2004_bavg(17:34,2),[GEP2004_bavg(17:34,1) ones(18,1)],alpha);

[GEP_reg2(3).b,GEP_reg2(3).bint,GEP_reg2(3).r,GEP_reg2(3).rint,GEP_reg2(3).stats] = regress_analysis(GEP2005_bavg(17:32,2),[GEP2005_bavg(17:32,1) ones(16,1)],alpha);

[GEP_reg2(4).b,GEP_reg2(4).bint,GEP_reg2(4).r,GEP_reg2(4).rint,GEP_reg2(4).stats] = regress_analysis(GEPa_bavg(17:34,2),[GEPa_bavg(17:34,1) ones(18,1)],alpha);


for jk = 1:1:4
%     sl_int2(jk,:) = GEP_reg2(jk).b;
%     stats2(jk,:) = GEP_reg2(jk).stats;
     stats17_34(jk,1:2) = GEP_reg2(jk).b;
    stats17_34(jk,3) = GEP_reg2(jk).stats(1,1);
end

%% Calculate More Stats
% RMSE
RMSE2(1,1) = (sum((GEP2003_bavg(17:34,2)- GEP2003_bavg(17:34,1)).^2))./16;
RMSE2(2,1) = (sum((GEP2004_bavg(17:34,2)- GEP2004_bavg(17:34,1)).^2))./16;
RMSE2(3,1) = (sum((GEP2005_bavg(17:32,2)- GEP2005_bavg(17:32,1)).^2))./16;
RMSE2(4,1) = (sum((GEPa_bavg(17:34,2)- GEPa_bavg(17:34,1)).^2))./16;

stats17_34 = [stats17_34 RMSE2];

%% RMSE for all data:
RMSEall(1,1) = (sum((GEP2003_bavg(1:34,2)- GEP2003_bavg(1:34,1)).^2))./32;
RMSEall(2,1) = (sum((GEP2004_bavg(1:34,2)- GEP2004_bavg(1:34,1)).^2))./32;
RMSEall(3,1) = (sum((GEP2005_bavg(1:32,2)- GEP2005_bavg(1:32,1)).^2))./32;
RMSEall(4,1) = (sum((GEPa_bavg(1:34,2)- GEPa_bavg(1:34,1)).^2))./32;
