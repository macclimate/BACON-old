cd C:\ubc_PC_setup\Site_Specific\TP02;
clear all
close all
for j = 1:1:48
    hour = floor(j./2);
    hhour = rem(j,2).*30;
[Stats(j).New, HF(j).Data] = yf_calc_module_main(datenum(2009,03,05,hour, hhour,0),'mcm3',2);
end


for j = 1:1:48
    Fc(j) = Stats(j).New.MainEddy