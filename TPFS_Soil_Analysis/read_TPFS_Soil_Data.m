clear all;
close all;

% ls = addpath_loadstart
ls = '/home/brodeujj/';

path = [ls 'Matlab/Data/TPFS_Soil_Analysis/TPFS_Particle_Size_Analysis.csv'];
fid = fopen(path);

%% First Line has headers:
tline = fgets(fid);
coms = find(tline==',');
coms = [0 coms length(tline)+1];
%%% Extract names:
for i = 1:1:length(coms)-1
    tmp_varname = tline(coms(i)+1:coms(i+1)-1);
    tmp_varname(tmp_varname== '"') = '';
    column_names{1,i} = cellstr(tmp_varname);
    clear tmp_varname;
end
clear tline


ID_list = {};
eofstat = 0;
j = 1;
while eofstat == 0

    tline = fgets(fid);
    coms = find(tline==',');
    coms = [0 coms length(tline)+1];
    %%% get the site ID:
    tmp_ID = tline(1:coms(2)-1);
    if length(tline)> 7
        
    if isempty(find(strcmp(ID_list,tmp_ID)==1));   
        current_ID = tmp_ID;
        ID_list{length(ID_list)+1,1} = tmp_ID;
        row_ctr = 1;
    else
        row_ctr = row_ctr+1;
    end


    %%% Extract numbers:
    for i = 2:1:length(coms)-1
        tmp_var = tline(coms(i)+1:coms(i+1)-1);
        %     tmp_varname(tmp_varname== '"') = '';
        eval([current_ID '(row_ctr,i-1) = str2num(tmp_var);']);
        clear tmp_var;
    end
    clear tline coms
    end
    eofstat = feof(fid);
%     j = 1+1;
end
fclose(fid);
%%% Do extra stats for each variable:
figure(1);clf;figure(2);clf;

for k = 1:1:length(ID_list)
    eval([char(ID_list(k)) '(:,6) = ' char(ID_list(k)) '(:,4) ./ ' char(ID_list(k)) '(:,5);' ]);
eval([char(ID_list(k)) '(:,9) = ' char(ID_list(k)) '(:,3) - ' ...
    char(ID_list(k)) '(:,2);']); 
eval(['tmp_sum = sum(' char(ID_list(k)) '(:,9));']);
eval(['tmp_cum_sum = cumsum(' char(ID_list(k)) '(:,9));']);
eval([char(ID_list(k)) '(:,10) = tmp_cum_sum;'])
eval([char(ID_list(k)) '(:,11) = (tmp_cum_sum./tmp_sum);']);
eval([char(ID_list(k)) '(:,12) = (1 - (tmp_cum_sum./tmp_sum));']);
eval([char(ID_list(k)) '(:,7) = 2.6;']); % assuming particle density of 2.6
eval([char(ID_list(k)) '(:,8) = 1-(' char(ID_list(k)) '(:,6) ./ ' char(ID_list(k)) '(:,7));']);


end
%% Columns for data:
% 1. Seive size (mm)
% 2. mass of container
% 3. mass of soil + container (for each seive)
% 4. mass of soil in crucible
% 5. volume of crucible
% 6. bulk density (g/m3)
% 7. particle density (may be blank)
% 8. porosity (may be blank)
% 9. mass of soil (for each seive)
% 10. cumulative weight of soil caught
% 11. % of soil caught
% 12. % of soil passing
%%%% Here, we're going to replace the actual numbers with a logistical
%%%% function, so that we can get estimates for %sand, silt & clay:
test_x = logspace(-3, 1,400);
ctr = 1;
for k = 1:1:length(ID_list)
    
    eval(['tmp_x_in = ' char(ID_list(k)) '(:,1);'])
        eval(['tmp_y_in = ' char(ID_list(k)) '(:,12);'])
    [coeff_hat(:,ctr), Y_hat(:,ctr), R2(:,ctr), sigma(:,ctr)] = ...
        fitmain([5 50], 'fitlogi6', tmp_x_in, tmp_y_in);
    pred_y(:,ctr) = 1./(1 + exp(coeff_hat(1,ctr)-coeff_hat(2,ctr).*test_x));
    clear tmp_x_in tmp_y_in;
    
    % can we find within these, what the % sand/silt/clay is?
    composition(ctr,1) = 1 - pred_y(find(test_x > 0.02,1,'first'),ctr); % percent sand
    composition(ctr,3) = pred_y(find(test_x > 0.002,1,'first'),ctr); % percent clay
    composition(ctr,2) = 1 - (composition(ctr,1) + composition(ctr,3));% percent silt
   
    eval(['bulk_density(ctr,1) = ' char(ID_list(k)) '(1,6);']);
        eval(['particle_density(ctr,1) = ' char(ID_list(k)) '(1,7);']);
            eval(['porosity(ctr,1) = ' char(ID_list(k)) '(1,8);']);
ctr = ctr+1;
end
composition = composition.*100;
% legend(ID_list)

%%% Perhaps try to fit logistic curves to column 12?

% 
% test_y = 1./(1 + exp(coeff_hat(1)-coeff_hat(2).*test_x));
% figure('Name','TP02 Predicted % Passing Plot');clf
% semilogx(TP02_Ref_1a(:,1), TP02_Ref_1a(:,12)./100,'ro'); hold on;
% semilogx(test_x, test_y,'b.-')
% plot([0.02 0.02],[0 1],'g--')
% plot([0.002 0.002],[0 1],'g--')
% 
% [coeff_hat, Y_hat, R2, sigma] = fitmain([5 100], 'fitlogi6', TP39_Ref_1a(:,1), TP39_Ref_1a(:,12)./100);
% test_y = 1./(1 + exp(coeff_hat(1)-coeff_hat(2).*test_x));
% figure('Name','TP39 Predicted % Passing Plot');clf
% semilogx(TP39_Ref_1a(:,1), TP39_Ref_1a(:,12)./100,'ro'); hold on;
% semilogx(test_x, test_y,'b.-')
% plot([0.02 0.02],[0 1],'g--')
% plot([0.002 0.002],[0 1],'g--')

% Separate different sites and treatments:
ind_TP39r = find(strncmp(ID_list,'TP39_R',6)==1);
ind_TP39d = find(strncmp(ID_list,'TP39_D',6)==1);
ind_TP74r = find(strncmp(ID_list,'TP74',4)==1);
ind_TP02r = find(strncmp(ID_list,'TP02',4)==1);

%%% Plot the cumulative curves for different sites/treatments
figure('Name','Cumulative Passing Curves');clf
for k = 1:1:9
    semilogx(test_x, pred_y(:,ind_TP39r(k)),'Color',[0.5 0.5 0.5]); hold on;
        semilogx(test_x, pred_y(:,ind_TP39d(k)),'Color',[0 0 0]); hold on;
                semilogx(test_x, pred_y(:,ind_TP74r(k)),'Color',[1 0.2 0.5]); hold on;
        semilogx(test_x, pred_y(:,ind_TP02r(k)),'Color',[0 0 1]); hold on;
        plot([0.02 0.02],[0 1],'g--')
plot([0.002 0.002],[0 1],'g--')
        
        

end



%%% Plot % Sand for all samples:
figure(3); clf;
for k = 1:1:length(ID_list)
eval(['plot(k,' char(ID_list(k)) '(10,11),''p'',''Color'',''k'');'])
% eval(['plot(k,' char(ID_list(k)) '(9,11),''.'',''Color'',''b'');'])
hold on; 
end



for i = 1:1:9
   eval(['TP39r_rho_b(i,1) = ' char(ID_list(ind_TP39r(i))) '(1,6);']);
   eval(['TP39d_rho_b(i,1) = ' char(ID_list(ind_TP39d(i))) '(1,6);']);
      eval(['TP74r_rho_b(i,1) = ' char(ID_list(ind_TP74r(i))) '(1,6);']);
         eval(['TP02r_rho_b(i,1) = ' char(ID_list(ind_TP02r(i))) '(1,6);']);
         
    eval(['TP39r_psand(i,1) = ' char(ID_list(ind_TP39r(i))) '(10,11);']);
   eval(['TP39d_psand(i,1) = ' char(ID_list(ind_TP39d(i))) '(10,11);']);
      eval(['TP74r_psand(i,1) = ' char(ID_list(ind_TP74r(i))) '(10,11);']);
         eval(['TP02r_psand(i,1) = ' char(ID_list(ind_TP02r(i))) '(10,11);']);
        
         
end

figure(4);clf
plot(TP39r_psand,'b-p');hold on;
plot(TP39d_psand,'c-p');hold on;
plot(TP74r_psand,'r-p');hold on;
plot(TP02r_psand,'g-p');hold on;


figure(5);clf;
plot([1 1 1], [TP39_Ref_1a(1,6) TP39_Ref_2a(1,6) TP39_Ref_3a(1,6)],'ro');hold on;
plot([1 1 1], [TP39_Ref_1b(1,6) TP39_Ref_2b(1,6) TP39_Ref_3b(1,6)],'bo');hold on;
plot([1 1 1], [TP39_Ref_1c(1,6) TP39_Ref_2c(1,6) TP39_Ref_3c(1,6)],'go');hold on;
plot([2 2 2], [TP39_Dro_1a(1,6) TP39_Dro_2a(1,6) TP39_Dro_3a(1,6)],'ro');hold on;
plot([2 2 2], [TP39_Dro_1b(1,6) TP39_Dro_2b(1,6) TP39_Dro_3b(1,6)],'bo');hold on;
plot([2 2 2], [TP39_Dro_1c(1,6) TP39_Dro_2c(1,6) TP39_Dro_3c(1,6)],'go');hold on;
plot([3 3 3], [TP74_Ref_1a(1,6) TP74_Ref_2a(1,6) TP74_Ref_3a(1,6)],'ro');hold on;
plot([3 3 3], [TP74_Ref_1b(1,6) TP74_Ref_2b(1,6) TP74_Ref_3b(1,6)],'bo');hold on;
plot([3 3 3], [TP74_Ref_1c(1,6) TP74_Ref_2c(1,6) TP74_Ref_3c(1,6)],'go');hold on;
plot([4 4 4], [TP02_Ref_1a(1,6) TP02_Ref_2a(1,6) TP02_Ref_3a(1,6)],'ro');hold on;
plot([4 4 4], [TP02_Ref_1b(1,6) TP02_Ref_2b(1,6) TP02_Ref_3b(1,6)],'bo');hold on;
plot([4 4 4], [TP02_Ref_1c(1,6) TP02_Ref_2c(1,6) TP02_Ref_3c(1,6)],'go');hold on;
set(gca,'XTick',(1:1:4), 'XTickLabel',['TP39_Ref'; 'TP39_Dro' ;'TP74_Ref'; 'TP02_Ref'])
axis([0 5 1.2 1.55])



%% Output:
% Write a file that has the following columns:
%1. Sample Name
%2. % sand
%3. % silt
%4. % clay
%5. bulk density
%6. particle density
%7. porosity
% sample_names = char(ID_list);
% [B IX] = sort(sample_names, 'descend');
data_out = [composition bulk_density particle_density porosity];
titles{1,1} = 'Sample'; titles{2,1} = '% sand'; titles{3,1} = '% silt'; 
titles{4,1} = '% clay'; titles{5,1} = 'bulk density'; titles{6,1} = 'particle density'; 
titles{7,1} = 'porosity';
title_row = char(titles);
format_code = '\n %11s\t';
format_code2 = '%4.2f\t %4.2f\t %4.2f\t %4.3f\t %4.3f\t %4.3f\t';

fid2 = fopen([ls 'Matlab/Data/TPFS_Soil_Analysis/TPFS_Particle_Size_results.dat'],'w');

% Write the column names:
for j = 1:1:length(titles)
h = fprintf(fid2, '%17s\t' , title_row(j,:) );
end
% Write data
for j = 1:1:length(composition)
    
    h1 = fprintf(fid2,format_code, char(ID_list(j)));
    h2 = fprintf(fid2,format_code2,data_out(j,:));
end

fclose(fid2)