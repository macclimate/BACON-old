function [] = movwin_Reichstein_uth(Fc, T, Ustar, RE_flag, win_size, int)
% win_size is full size of window in data points (2*length of one end of
% window to the data point)

Fc_wrap = [Fc(end-win_size/2+1:end); Fc; Fc(1:win_size/2)];
T_wrap = [T(end-win_size/2+1:end); T; T(1:win_size/2)];
Ustar_wrap = [Ustar(end-win_size/2+1:end); Ustar; Ustar(1:win_size/2)];
RE_flag_wrap = [RE_flag(end-win_size/2+1:end); RE_flag; RE_flag(1:win_size/2)];


centres = (1:int:length(Fc))';

for j = 1:1:length(centres)
   Fc_in = Fc_wrap(centres(j)-win_size/2:centres(j)+win_size/2,1);
   T_in = T_wrap(centres(j)-win_size/2:centres(j)+win_size/2,1);
   Ustar_in = Ustar_wrap(centres(j)-win_size/2:centres(j)+win_size/2,1);
   RE_flag_in = RE_flag_wrap(centres(j)-win_size/2:centres(j)+win_size/2,1);
   
   [T_mean Ustar_mean Fc_mean Fc_ratio u_th_est final_u_th(1,j)] = Reichsten_uth(Fc_in, T_in, Ustar_in, RE_flag_in);

   clear *_in *_mean Fc_ratio u_th_est;
end




end