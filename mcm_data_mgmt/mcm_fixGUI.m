function [] = mcm_fixGUI()

unix('rm /home0/arainlab/Desktop/matlabprefs.mat')
movefile('/home0/arainlab/.matlab/R2009b/matlabprefs.mat','/home0/arainlab/Desktop/matlabprefs.mat');
exit;