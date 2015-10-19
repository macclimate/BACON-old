function [SWP] = kohms2SWP(kOhms, Ts)

SWP = kOhms./(0.01306.* (1.062.* (34.21-Ts + 0.01060.*Ts.^2) -kOhms) );

