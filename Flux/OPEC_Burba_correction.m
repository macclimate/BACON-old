function [S_corr] = OPEC_Burba_correction(Hs, Ta, u, Q, L)

%%% This function calculates the Burba(2008) winter-uptake corection
%%% factor, which occurs with the LI-7500 during cold conditions, when
%%% heating from the instrument increases heat flux in the vicinity of the
%%% instrument, which is not picked up in sensible heat measurements.
%%% Inputs:
% Hs - Sensible Heat Flux (W/m2)
% Ta - Air Temperature (deg. C)
% u - horizontal wind speed (m/s)
% Q - Global SW radiation (W/m2)
% L - Downward LW radiation (W/m2)
%%% Output:
% S_corr - The corrected Heat Flux near the open-path sensor, that should
% be used in place of Hs to recalculate the WPL correction.
%%% Created April 20, 2011 by JJB.


day_flag = zeros(length(Q),1);
day_flag(Q>10,1) = 1;
Tb = NaN.*ones(length(Q),1);
Tt = NaN.*ones(length(Q),1);
Tp = NaN.*ones(length(Q),1);

%%% Li-7500 Dimensional Consants:
l_bot = 0.065;
l_top = 0.045;
l_spar = 0.005;
r_top = 0.0225;
r_spar = 0.0025;
k_air = 0.0243;

% LE_corr = NaN.*ones(length(LE_wpl),1);
% Fc_corr = NaN.*ones(length(Fc_wpl),1);

%% Calculate values of Tb, Tt, Tp
%%%%% DAY TIME:
Tb(day_flag==1,1) = Ta(day_flag==1,1) + 2.8 - 0.0681.*Ta(day_flag==1,1) + 0.0021*Q(day_flag==1,1) - 0.334*u(day_flag==1,1); 
Tt(day_flag==1,1) = Ta(day_flag==1,1) - 0.1 - 0.0044.*Ta(day_flag==1,1) + 0.0011*Q(day_flag==1,1) - 0.022*u(day_flag==1,1); 
Tp(day_flag==1,1) = Ta(day_flag==1,1) + 0.3 - 0.0007.*Ta(day_flag==1,1) + 0.0006*Q(day_flag==1,1) - 0.044*u(day_flag==1,1); 
%%%%%% NIGHT TIME:
Tb(day_flag==0,1) = Ta(day_flag==0,1) + 0.5 - 0.116.*Ta(day_flag==0,1) + 0.0087.*L(day_flag==0,1) - 0.206.*u(day_flag==0,1);
Tt(day_flag==0,1) = Ta(day_flag==0,1) - 1.7 - 0.016.*Ta(day_flag==0,1) + 0.0051.*L(day_flag==0,1) - 0.029.*u(day_flag==0,1);
Tp(day_flag==0,1) = Ta(day_flag==0,1) - 2.1 - 0.020.*Ta(day_flag==0,1) + 0.0070.*L(day_flag==0,1) + 0.026.*u(day_flag==0,1);

%% Now, calculate the heat fluxes from bottom(S_bot), top(S_top) and
%%% spars(Sspars):
del_bot = 0.004.*sqrt(l_bot./u)+0.004;
del_top = 0.0028.*sqrt(l_top./u) + 0.00025./u + 0.0045;
del_spar = 0.0058.*sqrt(l_spar./u);

S_bot = (k_air.*(Tb-Ta)) ./ del_bot;
S_top = (k_air.*(r_top+del_top).*(Tt-Ta)) ./ (r_top.*del_top);
S_spar = (k_air.*(Tp-Ta)) ./ (r_spar .* log((r_spar+del_spar)./r_spar) );

S_corr = Hs + S_bot + S_top + 0.15.*S_spar;

%% Correct the fluxes:
% LE_corr = LE_wpl.*(S_corr./Hs);
% Fc_corr = Fc_wpl.*(LE_corr./LE_wpl).*(S_corr./Hs);

figure(52);clf;
subplot(2,1,1);
plot(S_corr,'k');hold on;
plot(Hs,'g');
legend('Hs-corr','Hs-orig');
subplot(2,1,2);
plot(Hs,S_corr,'k.'); hold on;
xlabel('Hs-orig')
ylabel('Hs-corr');
axis([-200 800 -200 800]);
plot([-200 800],[-200 800],'r--');
