function [coeff_hat,Y_hat,R2,sigma] = hypmain1(coeff_0,funName,Xin, Yin, stdev_in)

%==========================================================================================
%   THIS PROGRAM DO THE BEST FIT OF RECTANGULAR
%       HYPERBOLA (see also hyp_main.m) 
%       
%       Y = alpha*Q*Amax/(alpha*Q + Amax)
%
%   First created on: 22 Mar 1996 by Paul Yang
%        Modified on: 02 Oct 1997 by Paul Yang 
%
%
%   Input: coeff_0, Xin and Yin
%   Output: coeff_hat,Y_hat, R2, sigma
%
%   Syntex:
%       [coeff_hat,Y_hat,R2,sigma] = hyp_main(coeff_0,funName,Xin, Yin)
%
%   Examle:
%       [coeff_hat,Y_hat,R2,sigma] = hyp_main([0.01 10 0.1],'fit_hyp',PPFD, GEP)
%    
%       coeff_hat = [alpha_hat, Amax_hat, R_hat]
%============================================================================================
%
%   Revisions:
%	01 Oct 1997: forcing it pass the origin (0,0)
if nargin == 4;
     stdev_in = [];  
end

 global X Y stdev;
  
 X = Xin;
 Y = Yin;
 stdev = stdev_in;
 size(Y);
 
 % fmins replaced with fminsearch by Altaf on 25 May 2005
 
 coeff_hat=fminsearch(funName, coeff_0);
 Y_hat=coeff_hat(1)*coeff_hat(2)*X./(coeff_hat(1)*X + coeff_hat(2));
 %plot(X,Y,'co',X,Y_hat,'+')

%% R2 (R_squared)

  res=sum((Y_hat-Y).^2);
  total=sum((Y-mean(Y)).^2);
  R2=1.0-res/total;
  sigma=sqrt(res);
  
   %[coeff,y,r2,sig]=hyp_main([0.1 10 0.1],'fit_hyp',ppfd(indg),GEP(indg));
