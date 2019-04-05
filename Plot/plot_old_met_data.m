%% This script is used for visual inspection of random met datasets with no
%% header information, to try and pick out which column may be SHF plates.
%%% JJB, June 11, 2008.

path = 'C:\HOME\MATLAB\Data\Data_Docking_Bay\Metfiles0304\';

if exist('m12003_v2','file')==1;
else
m12003_v1 = load([path 'data2003m1.dat']);
m12003_v2 = load([path 'data2003m1mtx.dat']);

m12004_v1 = load([path 'data2004m1.dat']);
m12004_v2 = load([path 'data2004m1mtx.dat']);
end
%%% Plot version 2 data:
fig_ctr = 1;
sp_ctr = 1;
for j = 1:1:74
    figure(fig_ctr); subplot(3,1,sp_ctr)
    plot(m12004_v2(:,j));
    title(['column ' num2str(j)]);
    
    if sp_ctr == 3;
       sp_ctr = 1;
       fig_ctr = fig_ctr+1;
    else
        sp_ctr = sp_ctr + 1;
    end
end