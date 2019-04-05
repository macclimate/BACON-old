function [H2O_conv] = H2O_convert(H2O_in,rho_air,conv_flag, skip_flag)
% H2O_convert.m
% usage [H2O_conv] = H2O_convert(H2O_in,rho_air,conv_flag)
% rho_air is inputted in g/m3
% Conversion Flags:
% 1 - g/m3 to mmol/mol
% 2 - mmol/mol to g/m3
if nargin == 3
    skip_flag = 0;
end
resp = 1;
if skip_flag ==0
    a = length(find(rho_air < 2));
    
    if ~isempty(a) && max(a)>0
        plot(a)
        disp('air density may be in kg/m3 -- g/m3 is required');
        resp = input('Enter <1> to continue, anything else to end');
    end
else
end

if resp ==1;
    
    switch conv_flag
        
        case 1
            H2O_conv = (1611.111./rho_air).*H2O_in;
        case 2
            H2O_conv = (rho_air./1611.111).*H2O_in;
            
    end
    
else
    disp('conversion not done.');
    H2O_conv = [];
end