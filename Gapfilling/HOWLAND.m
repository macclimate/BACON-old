function [NEE_final NEE_model R_final GEP_final] = HOWLAND(NEEraw, Ts, PAR, Ta, dt, year,plot_flag)
if nargin == 6;
    plot_flag = 'off';
end    
ind_resp = find(~isnan(Ts) & ~isnan(NEEraw) & ((Ts > 0 & PAR < 15) | Ts < 0));

e = 2.*pi().*dt(ind_resp,1)./365;
cos_e = cos(e);
sin_e = sin(e);
cos_2e = cos(2.*e);
sin_2e = sin(2.*e);

X = [ones(length(cos_e),1) cos_e sin_e cos_2e sin_2e];
[b,bint,r,rint,stats] = regress_analysis(NEEraw(ind_resp),X,0.05);

e_dt = 2.*pi().*dt./365;
resp = b(1) + b(2).*cos(e_dt) + b(3).*sin(e_dt) + b(4).*cos(2.*e_dt) + b(5).*sin(2.*e_dt);


%% GEP
GEPraw = resp - NEEraw;


ind_GEP = find(Ts > 4 & Ta > 0 & PAR > 20 & ~isnan(GEPraw) & ~isnan(PAR));
%%%%%%% GEP - PAR Relationship:
[gep_par_coeff gep_par_y gep_par_r2 gep_par_sigma] = hypmain1([0.01 10 0.1], 'fit_hyp1', PAR(ind_GEP), GEPraw(ind_GEP));
%%%%%%% Predict GEP for all days
GEP_PAR(1:length(GEPraw),1) = NaN;
GEP_PAR = gep_par_coeff(1).*PAR.*gep_par_coeff(2)./(gep_par_coeff(1).*PAR + gep_par_coeff(2));

pw_GEP_PAR = jjb_AB_gapfill(GEP_PAR, GEPraw, (1:1:length(GEP_PAR))',1000, 50, 'off', [], [],'pw');
if strcmp(plot_flag,'on') == 1;
figure(98);clf
plot(pw_GEP_PAR(:,2),'b')
end
    pw_nans = length(find(isnan(pw_GEP_PAR(:,2))));
  
  pw_GEP_PAR(isnan(pw_GEP_PAR),2) = 1;
  try
  GEP_PAR_pw = GEP_PAR .* pw_GEP_PAR(1:length(GEP_PAR),2);
  catch
      disp('stuck here.')
  end
  
%% FILL variables:

NEE_model = resp - GEP_PAR_pw;

R_final(1:length(resp),1) = NaN;
R_final(ind_resp,1) = NEEraw(ind_resp,1);
R_final(isnan(R_final),1) = resp(isnan(R_final),1);

GEP_final = R_final - NEEraw;

GEP_PAR_pw(dt < 85 | dt > 335 | PAR < 20) = 0;
GEP_final(isnan(GEP_final),1) = GEP_PAR_pw(isnan(GEP_final),1);

NEE_final(1:length(resp),1) = NaN;
ind_NEE = find(~isnan(NEEraw));
NEE_final(ind_NEE,1) = NEEraw(ind_NEE,1);
ind_fillNEE = find(isnan(NEE_final));
NEE_final(ind_fillNEE,1) = R_final(ind_fillNEE,1) - GEP_final(ind_fillNEE,1);
  
  

% % dim = jjb_days_in_month(year);
% ctr = 1;
% for month = 1:2:11
%   ind_use =  (ctr:1:ctr+(dim(month).*48) + (dim(month).*48) -1)';
% ind_GEP = find(Ts > 4 & Ta > 0 & PAR > 20 & ~isnan(GEPraw) & ~isnan(PAR));
% 
% end
% ctr = ctr+ind_use;


% for y = 2003:1:2007 % Change this later to the proper