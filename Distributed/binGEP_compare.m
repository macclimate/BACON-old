%% Function to compare Bin's model output with measured EC data:

bin = load('C:\HOME\MATLAB\Data\Class_files\Bin\BinGEP_v7_20.gpr');

data = load('C:\HOME\MATLAB\Data\Data_Analysis\M1_allyears\M1output_model4_2006.dat');
GEP = data(:,5);
GEP_g = GEP.*12e-6.*1800;

sum_bin = sum(bin)
sum_GEP = sum(GEP_g)

cs_bin = nancumsum(bin);
cs_GEP = nancumsum(GEP_g);

figure(1)
plot(GEP_g,'b');

hold on;
plot(bin,'r');

figure(2)
plot(cs_GEP,'b');hold on;
plot(cs_bin,'r');
