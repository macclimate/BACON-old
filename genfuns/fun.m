function [q] =fun(a,c)
ii=find(y==0);
jj=find(y~=0);
q=zeros(size(y));
q(ii)=exp((x-a)./c)*ones(size(ii))+exp((x-a)./c)*ones(size(ii));
q(jj)=(exp(-x./y(jj)).*exp((x-a)./c)+ exp((x-a)./y(jj)).*exp((x-a)./c))

% function [y] = fun(x,z,a,c,d)
% 
% ii=find(x==0);
% jj=find(x~=0);
% y=zeros(size(x));
% y(ii)=exp(-c*(z+d)/a)*ones(size(ii));
% y(jj)=(1-exp(-c*(z+d)./x(jj))).*exp(-c*(z+d)/a);

