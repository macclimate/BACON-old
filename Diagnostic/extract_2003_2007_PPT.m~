clearvars;
pth = '/1/fielddata/Matlab/Data/CCP/old_CCP/';
hdr = jjb_hdr_read([pth 'TP39_CCP_conversion_template.csv'],',',5);
% PPT is col 45
PPT_out = NaN.*ones(17568,5);
for yr = 2003:1:2007
    clear ppt;
   tmp = load([pth  'TP39_final_' num2str(yr) '.dat']);
ppt = tmp(:,45);   
   PPT_out(1:length(tmp),yr-2002) = ppt;
end

%%%%%%% Correct to UTC time:
PPT_all = [NaN.*ones(8,1); PPT_out(1:17520,1);PPT_out(1:17568,2);PPT_out(1:17520,3);PPT_out(1:17520,4)  ;PPT_out(1:17520-8,5); ];    

PPT_corr{1,1} = PPT_all(1:17520,1);
PPT_corr{2,1} = PPT_all(17521:17521+17568-1,1);
PPT_corr{3,1} = PPT_all(17521+17568:17521+17568+17520-1,1);
PPT_corr{4,1} = PPT_all(17521+17568+17520:17520+17521+17568+17520-1,1);
PPT_corr{5,1} = PPT_all(17520+17521+17568+17520:end,1);

for yr = 2003:1:2007
ppt = PPT_corr{yr-2002,1};   
save(['/1/fielddata/Matlab/Data/Met/Final_Cleaned/TP39_PPT_2003-2007/TP39_PPT_met_cleaned_' num2str(yr) '.mat'],'ppt')
end


figure(1);clf;
plot(PPT_out);
legend(num2str((2003:1:2007)'));

nansum(PPT_out)
