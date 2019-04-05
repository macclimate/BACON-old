%%% CCP_to_Organized.m
%%% This function takes data submitted for CCP archives, and converts it to
%%% organized data files in the current format, so that it may be used with
%%% the mcm_start_mgmt program and associated matlab scripts
% clear all
% close all
% ls = addpath_loadstart;
% 
% site_list = {'TP39';'TP74';'TP89';'TP02'};
% % old_site_tag = {'m1'};
% 
% for site_ctr = 1:1:length(site_list);
%     site = char(site_list(site_ctr));
%     if site_ctr == 1
%         num_cols = 110;
%         num_yr_loops = 5;
%     else
%         num_cols = 60;
%         num_yr_loops = 6;
%     end
%     
%     % At this point, we will leave the data in its original timecode (which is
%     % god-knows-what, then we will convert it into UTC while running
%     % mcm_metfixer.
%     
%     %%% TP39
%     % For TP39, we are only updating data for years 2002--2006, since 2007 has
%     % been processed from scratch.
%     
%     path_2002 = [ls 'Matlab/Data/Met/Pre_2007_Master_Files/'];
% %old     path_CCP = [ls 'Matlab/Data/CCP/Final_dat/'];
%     path_CCP = [ls 'Matlab/Data/Master_Files/' site '/'];
% 
%     path_trans = [ls 'Matlab/Data/Met/Pre_2007_Master_Files/Translation_files/'];
%     output_dir = [ls 'Matlab/Data/Met/Organized2/' site '/'];
%     
%     
% %old     load_info(:,1) = {['data2002m' num2str(site_ctr) 'ALL.dat']; [site '_final_2003.dat'];[site '_final_2004.dat'];[site '_final_2005.dat'];[site '_final_2006.dat'];[site '_final_2007.dat']};
%    load_info(:,1) = {['data2002m' num2str(site_ctr) 'ALL.dat']; [site '_data_master_2003.mat'];[site '_data_master_2004.mat'];[site '_data_master_2005.mat'];[site '_data_master_2006.mat'];[site '_data_master_2007.mat']};
% 
%     %load_info(1:6,2) = {110;110;110;110;110;110};
%     load_info(1:6,3) = {2002;2003;2004;2005;2006;2007};
%     load_info(:,4) = {[site '_2002_met.csv'];[site '_CCP_met.csv'];[site '_CCP_met.csv'];[site '_CCP_met.csv'];[site '_CCP_met.csv'];[site '_CCP_met.csv']};
%     clear output_hdr;
%     output_hdr = jjb_hdr_read([ls 'Matlab/Data/Met/Raw1/Docs/' site '_OutputTemplate.csv']);
%     
%     
%     for j = 1:1:num_yr_loops % This will go from 2002--2006 for TP39, 2002--2007 for others:
%         clear met_master TV hdr tmp yr path year JD HHMM master;
%         if j ==1
%             path = path_2002;
%         else
%             path = path_CCP;
%         end
%         yr = load_info{j,3};
%         %     num_cols = load_info{j,2};
%         
%         % template:
%         met_master(1:yr_length(yr),1:num_cols) = NaN;
%         % Load data file:
%         %old         tmp = load([path char(load_info(j,1))]);
%         if j ==1
%         tmp = load([path char(load_info(j,1))]);
%         else
%         tmp2 = load([path char(load_info(j,1))]); tmp = tmp2.master.data; clear tmp2;
%         end
%         % Load translator file:
%         hdr = jjb_hdr_read([path_trans char(load_info(j,4))]);
%         % titles in column 2 correspond to columns in original file
%         % titles in column 4 corresponds to columns we want the data to go to in final master
%         % Put time variables into first 4 columns:
%         TV = make_tv(yr,30);
%         [year JD HHMM] =jjb_makedate(yr,30);
%         met_master(:,1:4) = [TV year JD HHMM];
%         
%         % Move data between files:
%         for i = 1:1:length(hdr)
%             if isempty(hdr{i,3})==1
%             else
%                 col_in_final = str2num(hdr{i,3});
%                 col_in_orig  = str2num(hdr{i,1});
%                 met_master(:,col_in_final) = tmp(:,col_in_orig);
%             end
%         end
%         
%         % Now, save the files to /Organized2/Column/30min and /HH_Files
%         %%%%%%% Save the master file %%%%%%%%%%%%%%%%%%%%%
%         save([output_dir 'Master/' site 'master' num2str(yr) '.dat'],'met_master','-ASCII'); %% removed '-DOUBLE'
%         %%% Also save the file in .mat format
%         save([output_dir 'Master/' site 'master' num2str(yr) '.mat'],'met_master'); %% removed '-DOUBLE'
%         %%% Master file:
%         master(1).data = met_master;
%         master(1).labels = output_hdr(:,2);
%         save([output_dir 'HH_Files/' site '_HH_' num2str(yr) '.mat'],'master');
%         %%% output to columns:
%         exten = create_label([1:1:num_cols]',3);
%         right_cols = [];
%         for k = 1:1:length(output_hdr)
%             if str2num(output_hdr{k,3})==30
%                 right_cols = [right_cols; k];
%             end
%         end
%         right_cols = [1;2;3;4; right_cols];
%         
%         for k = 1:1:length(right_cols)
%             fout = fopen([output_dir 'Column/30min/' site '_' num2str(yr) '.' exten(right_cols(k),:)],'w');
%             aout = NaN.*ones(yr_length(yr),1);
%             fprintf (fout,'%f\r\n', aout);
%             clear aout;
%             fclose(fout);
%             bv = load([output_dir 'Column/30min/' site '_' num2str(yr) '.' exten(right_cols(k),:)]);
%             bv(:,1) = met_master(:,right_cols(k));
%             save([output_dir 'Column/30min/' site '_' num2str(yr) '.' exten(right_cols(k),:)],'bv','-ASCII');
%             clear bv;
%         end   
%     end
% end

%% OPEC DATA
%%% Now, we can do similar work, but this time, we want to take all of the
%%% OPEC data out of the master files, and place them into appropriate
%%% places in /Matlab/Data/OPEC/<site>/... 
%%% We have the following data and directories 
%%% ../Cleaned/ : 
%%% ../Final_Cleaned/ : H, LE, CO2top, Fc, Ustar, H2O, CO2cpy (from met)
%%% ../Final_Calculated/: NEE, dcdt, Jt - (All these from storage calc)
ls = addpath_loadstart;

site_list = {'TP39';'TP74';'TP89';'TP02'};
clear load_info; 
co2_top_tags = {'';'CO2_15m';'CO2_15m';'CO2_2m'};
co2_cpy_tags = {'';'CO2_9.2m';'CO2_9.2m';'CO2_0m'};
OPEC_load_info(1:7,1) = {2002;2003;2004;2005;2006;2007;2008};


for site_ctr = 2:1:4
    site = char(site_list(site_ctr));
    load_path = [ls 'Matlab/Data/Master_Files/' site '/'];
    save_path = [ls 'Matlab/Data/Flux/OPEC/' site '/'];
    
    for j = 1:1:length(OPEC_load_info) % goes through all years
        yr = OPEC_load_info{j,1};
        load([load_path site '_data_master_' num2str(yr) '.mat']);
        
        if yr == 2008;
            suffix = '_OPEC';
            CO2_top_name = 'CO2_OPEC';
        else 
            suffix = '';
            CO2_top_name = char(co2_top_tags(site_ctr,1));
        end
        
%         CO2_top = load_from_master(master,CO2_top_name);
%         CO2_cpy = load_from_master(master,char(co2_cpy_tags(site_ctr,1)));
%         Fc = load_from_master(master,['FC' suffix]);
%         SFC = load_from_master(master,['SFC' suffix]);
%         NEE = load_from_master(master,['NEE' suffix]);    
        UStar = load_from_master(master,['Ustar' suffix]);        
%         H2O = load_from_master(master,['H2O' suffix]);    
%         LE =  load_from_master(master,['LE' suffix]);   
%         H =  load_from_master(master,['H' suffix]);
%         Jt = load_from_master(master,'Heat Storage');
    
        % Save data to /Final_Cleaned/:
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.CO2_irga'],'CO2_top','-ASCII');
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.CO2_cpy'],'CO2_cpy','-ASCII');
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.Fc'],'Fc','-ASCII');
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.H2O_irga'],'H2O','-ASCII');
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.LE'],'LE','-ASCII');
%         save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.Hs'],'H','-ASCII');
        save([save_path 'Final_Cleaned/' site '_' num2str(yr) '.Ustar'],'UStar','-ASCII');
        
        clear master UStar;
%         master.data = [Fc LE H CO2_top CO2_cpy H2O];
%         master.lables = {'Fc';'LE';'Hs';'CO2_irga';'CO2_cpy';'H2O_irga'};
%         save([save_path 'Final_Cleaned/' site '_OPEC_cleaned_' num2str(yr) '.mat'],'master');
%         clear master
        
        % Save data to /Final_Calculated/:
%         save([save_path 'Final_Calculated/' site '_' num2str(yr) '.dcdt'],'SFC','-ASCII');
%         save([save_path 'Final_Calculated/' site '_' num2str(yr) '.Jt'],'Jt','-ASCII');
%         save([save_path 'Final_Calculated/' site '_' num2str(yr) '.NEE_raw'],'NEE','-ASCII');        
        
    end
    
end

