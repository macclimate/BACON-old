function [] = jjb_monthly_anomalies(data, start_year, end_year)

start_year = 2003;
end_year = 2009;
ctr = 1;
for year = start_year:1:end_year
tmp = jjb_days_in_month(year);
mon_starts = (cumsum([0; tmp(1:11)])+1);
mon_ends = (cumsum(tmp(1:12))+1);    

% ctr = 1;
for month = 1:1:12
    ind = find(TP39.data.Year == year & TP39.data.dt>=mon_starts(month) & TP39.data.dt < mon_ends(month));
    PAR_mean(ctr,month) = nanmean(TP39.data.PAR(ind));
     Ta_mean(ctr,month) = nanmean(TP39.data.Ta(ind));  
      Ts_mean(ctr,month) = nanmean(TP39.data.Ts5(ind));  
       VPD_mean(ctr,month) = nanmean(TP39.data.VPD(ind));  
     NEE_mean(ctr,month) = nanmean(TP39.filled.NEEfilled(ind));  
        SM_mean(ctr,month) = nanmean(TP39.data.SM_a(ind));
        GEP_mean(ctr,month) = nanmean(TP39.filled.GEPfilled(ind));
       RE_mean(ctr,month) =  nanmean(TP39.filled.Rfilled(ind));
       
    clear ind;
     
end
ctr = ctr+1;
end
for month = 1:1:12
PAR_anom(:,month) = (PAR_mean(:,month)- mean(PAR_mean(:,month)))./std(PAR_mean(:,month));
Ta_anom(:,month) = (Ta_mean(:,month)- mean(Ta_mean(:,month)))./std(Ta_mean(:,month));
Ts_anom(:,month) = (Ts_mean(:,month)- mean(Ts_mean(:,month)))./std(Ts_mean(:,month));
VPD_anom(:,month) = (VPD_mean(:,month)- mean(VPD_mean(:,month)))./std(VPD_mean(:,month));
NEE_anom(:,month) = (NEE_mean(:,month)- mean(NEE_mean(:,month)))./std(NEE_mean(:,month));
SM_anom(:,month) = (SM_mean(:,month)- mean(SM_mean(:,month)))./std(SM_mean(:,month));
GEP_anom(:,month) = (GEP_mean(:,month)- mean(GEP_mean(:,month)))./std(GEP_mean(:,month));
RE_anom(:,month) = (RE_mean(:,month)- mean(RE_mean(:,month)))./std(RE_mean(:,month));
end
PAR_anom2 = reshape(PAR_anom',[],1);
Ta_anom2 = reshape(Ta_anom',[],1);
Ts_anom2 = reshape(Ts_anom',[],1);
VPD_anom2 = reshape(VPD_anom',[],1);
NEE_anom2 = reshape(NEE_anom',[],1);
SM_anom2 = reshape(SM_anom',[],1);
GEP_anom2 = reshape(GEP_anom',[],1);
RE_anom2 = reshape(RE_anom',[],1);

TP39.monthly.PAR_anom = PAR_anom2;
TP39.monthly.Ta_anom = Ta_anom2;
TP39.monthly.Ts_anom = Ts_anom2;
TP39.monthly.VPD_anom = VPD_anom2;
TP39.monthly.NEE_anom = NEE_anom2;
TP39.monthly.SM_anom = SM_anom2;
TP39.monthly.GEP_anom = GEP_anom2;
TP39.monthly.RE_anom = RE_anom2;