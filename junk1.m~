site = 'TP39';
%%% Paths:
ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
save_path = [ls 'Matlab/Data/Flux/CPEC/' site '/Final_Calculated/'];
footprint_path = [ls 'Matlab/Data/Flux/Footprint/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load gapfilling file and make appropriate adjustments:
load([load_path site '_gapfill_data_in.mat']);
data = trim_data_files(data,2003, 2009,1);
data.site = site;
close all

%% Run Stuff
% master = mcm_Gapfill_ANN_JJB1(data,1,0);

% out = mcm_Gapfill_LRC_Lasslop(data,1,0);
out = mcm_Gapfill_LRC_Lasslop_JJB1(data,1,0);
close all;
out = mcm_Gapfill_NR_LRC_JJB1(data,1,0);



%%% Checking c_hat outputs:
c_hat_check =  [0,0.0120526820339713];
c_hat_check2 =  [0.0754927487014847,9.05358048754935e-11];
% c_hat_check = [0.0101883119636404,131666133612026];
% c_hat_check2 = [0.101883119636404,20];
options.f_coeff = [];
fixed_coeff = [];
coeffs_to_fix = [];

PAR_in = (0:50:2400)';
out = fitGEP_1H1(c_hat_check,PAR_in);
out2 = fitGEP_1H1(c_hat_check2,PAR_in);

f3 = figure();clf
plot(PAR_in, out,'b-');hold on;
plot(PAR_in, out2,'r-');hold on;

clear global;
PAR_in = (0:50:2400)';
chats = [0.05 1; 0.05 5; 0.05 20; 0.05 40];% min alpha, max beta
options.f_coeff = [];
fixed_coeff = [];
coeffs_to_fix = [];
PAR_in = (0:50:2400)';
for i = 1:1:4
    out(:,i) = fitGEP_1H1(chats(i,1:2),PAR_in);
end
figure();clf;
plot(out);


%% Test the NR Hyperbola:
PAR_in = (0:50:2400)';
Ts_in = zeros(length(PAR_in),2);
% c_hat_test = [0.2 40 0.5 0; 0.3 40 0.5 0;  0.4 40 0.2 0;  0.2 80 0.4 0;];
c_hat_test = [0.0118194492488767,15.3856915390042,0.998199861334373,0;0.0686456206896389,32.7768786800136,0.741796619315468,0;...
    0.140132144584517,48.5209942081854,0.641388787478425,0;0.0492530363936293,41.2719180715846,0.500000186529501,0];
figure(1);clf;
for i = 1:1:4
test_out(:,i) = fitGEP_NR_LRC(c_hat_test(i,:),[PAR_in Ts_in]);
figure(1);
plot(PAR_in,test_out(:,i),'Color',clrs(i,:)); hold on;
end

legend({'.01 15 0.99';'.06 33 0.74';'.14 49 0.64';'.05 41 0.5'});