function [] = mcm_fixGUI()

unix('rm /home/arainlab/Desktop/matlabprefs.mat')
movefile('/home/arainlab/.matlab/R2015a/matlabprefs.mat','/home/arainlab/Desktop/matlabprefs.mat');
exit;