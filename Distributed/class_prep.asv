clear all
close all
    for site = 1%2:1:4
    for yr = 2007; %2003:1:2007
        
        
        disp(['site: ' num2str(site)])
program = 'Class';% yr = 2003; site = 2; 

%%
if yr == 2007
flux_source = 'processed';
met_source = 'processed';
else
flux_source = 'master';
met_source = 'master';
end
%%

if ispc == 1
    save_path = 'C:\HOME\MATLAB\Data\Class_files\';
else
    save_path = '/home/jayb/Data/Class_files/';
%     path = '/home/jayb/MATLAB/Data/Data_Analysis/M1_allyears/';
end


% save_path = 'C:\HOME\MATLAB\Data\Class_files\';

%%

[junk(:,1) junk(:,2) junk(:,3) junk(:,4)]  = jjb_makedate(str2double(num2str(yr)),30);
test_vars = jjb_flux_load('Soil', num2str(yr), num2str(2), flux_source, met_source);

vars_out = jjb_class_load(program, yr, site, flux_source, met_source);

[nans num_nans] = findnans(vars_out);

%% Fill gaps (if possible)
% switch yr
%     case 2007
        if site == 1
%                 night_SW = find(isnan(vars_out(:,3)) & vars_out(:,10) < 2);
%                 plot(vars_out(vars_out(:,10) < 2 ,3))
                m2_data = jjb_flux_load('Analysis', num2str(yr), num2str(2), flux_source, met_source); 
                m3_data = jjb_flux_load('Analysis', num2str(yr), num2str(3), flux_source, met_source);
                m4_data = jjb_flux_load('Analysis', num2str(yr), num2str(4), flux_source, met_source);                
                % fill Tair
                vars_out(nans(5).ind,5) = m2_data(nans(5).ind,1); [nans num_nans] = findnans(vars_out);            
                % fill RH
                vars_out(nans(6).ind,6) = m2_data(nans(6).ind,15); [nans num_nans] = findnans(vars_out);               
                % fill Pressure
                if ~isempty(nans(7).ind)
                vars_out(nans(7).ind,7) = m4_data(nans(7).ind,20); [nans num_nans] = findnans(vars_out);
                vars_out(nans(7).ind,7) = m3_data(nans(7).ind,20); [nans num_nans] = findnans(vars_out);
                vars_out(nans(7).ind,7) = m2_data(nans(7).ind,20); [nans num_nans] = findnans(vars_out);
                pres_fill = jjb_interp_gap(vars_out(:,7),(1:1:length(junk))',3);
                vars_out(nans(7).ind,7) = pres_fill(nans(7).ind,1); [nans num_nans] = findnans(vars_out);
                vars_out(nans(7).ind,7) = 99; [nans num_nans] = findnans(vars_out);
                end
                % fill PPT
                vars_out(nans(8).ind,8) = m4_data(nans(8).ind,21); [nans num_nans] = findnans(vars_out);     
                vars_out(nans(8).ind,8) = 0;    [nans num_nans] = findnans(vars_out); 
                % fill WS
                vars_out(nans(9).ind,9) = m2_data(nans(9).ind,3); [nans num_nans] = findnans(vars_out);
                
                % fill PAR down
                vars_out(nans(10).ind,10) = m2_data(nans(10).ind,2); [nans num_nans] = findnans(vars_out);
                % fill Rn
                vars_out(nans(11).ind,11) = m2_data(nans(11).ind,4); [nans num_nans] = findnans(vars_out);
   
                %% Fill SW using windowed linear relationship with PAR:
                [SW_filled SW_model] = jjb_WLR_gapfill(vars_out(:,10), vars_out(:,3), 12000, 'on',[-500 2500], [-200 1200]);
                vars_out(:,3) = SW_filled; [nans num_nans] = findnans(vars_out);

                %% Fill LW 
                LW_fill = jjb_interp_gap(vars_out(:,4),(1:1:length(junk))',3);
                vars_out(:,4) = LW_fill; [nans num_nans] = findnans(vars_out);
%%               
                % fill LWdown
%                 vars_out(nans(3).ind,3) = LW_model(nans(5).ind,1); [nans num_nans] = findnans(vars_out);         
 if yr == 2006 || yr == 2007 || yr == 2005
     LW_model = load(['C:\HOME\MATLAB\Data\Class_files\met1_' num2str(yr) '.lw']);
     vars_out(nans(4).ind,4) = LW_model(nans(4).ind,1); [nans num_nans] = findnans(vars_out);
     
     
     
     
     

 end
                
 else
     m1_data = load([save_path 'M1_' num2str(yr) 'allvars.dat']);
% fill SWdown
                vars_out(nans(3).ind,3) = m1_data(nans(3).ind,3); [nans num_nans] = findnans(vars_out);                   
% fill LWdown
                vars_out(nans(4).ind,4) = m1_data(nans(4).ind,4); [nans num_nans] = findnans(vars_out);                   
                  
                  
                % fill Tair
                vars_out(nans(5).ind,5) = m1_data(nans(5).ind,5); [nans num_nans] = findnans(vars_out);            
                % fill RH
                vars_out(nans(6).ind,6) = m1_data(nans(6).ind,6); [nans num_nans] = findnans(vars_out);               
                % fill Pressure
                vars_out(nans(7).ind,7) = m1_data(nans(7).ind,7); [nans num_nans] = findnans(vars_out);                              
                % fill PPT
                vars_out(nans(8).ind,8) = m1_data(nans(8).ind,8); [nans num_nans] = findnans(vars_out);                              
                % fill WS
                vars_out(nans(9).ind,9) = m1_data(nans(9).ind,9); [nans num_nans] = findnans(vars_out);                              
                % PAR_down
                vars_out(nans(10).ind,10) = m1_data(nans(10).ind,10); [nans num_nans] = findnans(vars_out);                              
                % fill Rn
                vars_out(nans(11).ind,11) = m1_data(nans(11).ind,11); [nans num_nans] = findnans(vars_out);                              
                  
                  
                  
                  
                  
                  
% plot(m2_data(:,1))
% abc = find(isnan(m2_data(:,1)));
        end
% end

%% Calculate VP using RH:
T_air = vars_out(:,5); RH = vars_out(:,6);
esat = 0.6108.*exp((17.27.*T_air)./(237.3+T_air));
e = (RH.*esat)./100;

% T_test = (-30:1:30);
% esat_test = 0.6108.*exp((17.27.*T_test)./(237.3+T_test));
% esat_test2 = 0.6108.*exp((17.27.*T_test)./(273.3+T_test));
% figure(4)
% plot(T_test,esat_test,'.-')
% hold on
% plot(T_test,esat_test2,'r.-')

%% Calculate specific humidity from RH and P
APR = vars_out(:,7);
rho_a = (APR*1000)./(287.0028.*(T_air+273));
rho_v = (e*1000)./(461.5.*(T_air+273))*1000;
q = rho_v./rho_a;

exten = create_label((1:1:20)',3);
if site == 1
forbin = [vars_out(:,5) e vars_out(:,9) vars_out(:,8) vars_out(:,3)];

save([save_path 'For_Bin/vars_' num2str(yr) '.dat'],'forbin','-ASCII')



for m = 1:1:5
    outvar = forbin(:,m);
% save([save_path 'For_Bin\vars_' num2str(yr) '.' exten(m,:)],'outvar','-ASCII');
fout=fopen([save_path 'For_Bin/vars_' num2str(yr) '.' exten(m,:)],'w');
fprintf (fout,'%f\r\n', outvar);  
fclose(fout)

clear outvar;

end

% Save all variables so that they can be used to fill other sites
all_out = [vars_out e q];
save([save_path 'M1_' num2str(yr) 'allvars.dat'],'all_out','-ASCII')

end


%%
%           1SW             2LW           3T_air  4q      5APR           6PPT          7 WS
foraa = [vars_out(:,3) vars_out(:,4) vars_out(:,5) q  vars_out(:,7)  vars_out(:,8)  vars_out(:,9)];
save([save_path 'For_AA/M' num2str(site) '/' num2str(yr) '/' 'input_M' num2str(site) num2str(yr) '.dat'],'foraa','-ASCII')

for m = 1:1:7
    outvar = foraa(:,m);
fout=fopen([save_path 'For_AA/M' num2str(site) '/' num2str(yr) '/' 'input_M' num2str(site) num2str(yr) '.' exten(m,:)],'w');
fprintf (fout,'%f\r\n', outvar);  
fclose(fout)

clear outvar;

end

%%
model_testvars = [vars_out(:,1) vars_out(:,2) vars_out(:,10) vars_out(:,11) test_vars];
save([save_path 'For_AA/M' num2str(site) '/' num2str(yr) '/' 'verify_M' num2str(site) num2str(yr) '.dat'],'model_testvars','-ASCII')

[r2 c2] = size(model_testvars);

for m = 1:1:c2
    outvar = model_testvars(:,m);
fout=fopen([save_path 'For_AA/M' num2str(site) '/' num2str(yr) '/' 'verify_M' num2str(site) num2str(yr) '.' exten(m,:)],'w');
fprintf (fout,'%f\r\n', outvar);  
fclose(fout)

clear outvar;

clear junk
end
    end
end