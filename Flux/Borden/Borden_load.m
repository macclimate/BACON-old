 clear all
% close all

data_path = ('C:\HOME\MATLAB\Data\borden\');

% Load soil data:
soil = dlmread([data_path 'Bor_Soil_Master.csv'],',');
% Load Met data:
met = dlmread([data_path 'Bor_Met_Master.csv'],',');
% Load Flux data:
flux = dlmread([data_path 'Bor_Flux_Master.csv'],',');


% Load header files:
master_hdr = jjb_hdr_read([data_path 'Bor_Master_Columns.csv'],',', 2);
soil_hdr = jjb_hdr_read([data_path 'Bor_Soil_Cols.csv'],',', 1);
met_hdr = jjb_hdr_read([data_path 'Bor_Met_Cols.csv'],',', 1);
flux_hdr = jjb_hdr_read([data_path 'Bor_Flux_Cols.csv'],',', 1);

%% Make a 3 year blank template for 2004-2006:

TV = [make_tv(2004,30); make_tv(2005,30); make_tv(2006,30)];
[Year2004, JD2004, HHMM2004, dt2004] = jjb_makedate(2004, 30);
[Year2005, JD2005, HHMM2005, dt2005] = jjb_makedate(2005, 30);
[Year2006, JD2006, HHMM2006, dt2006] = jjb_makedate(2006, 30);

bor_master(1:length(TV),1:80) = NaN;

bor_master(:,1) = TV;
bor_master(:,2) = [Year2004; Year2005; Year2006];
bor_master(:,3) = [dt2004; dt2005; dt2006];
bor_master(:,3) = (round(100.*bor_master(:,3)))./100;
bor_master(:,4) = [HHMM2004; HHMM2005; HHMM2006];

%% Round dt of each file to 4 decimal places:
met(:,2) = (round(100.*met(:,2)))./100;
soil(:,3) = (round(100.*soil(:,3)))./100;
flux(:,2) = (round(100.*flux(:,2)))./100;
%% Size of each datafile
[r_met c_met] = size(met);
[r_soil c_soil] = size(soil);
[r_flux c_flux] = size(flux);

%%  Match times and fit data for each year separately:

for yr_ctr = 2004:1:2006
    
    % select data for the year:
    ind_met = find(met(:,1) == yr_ctr);
    ind_soil = find(soil(:,1) == yr_ctr);
    ind_flux = find(flux(:,1) == yr_ctr);
    ind_master = find(bor_master(:,2) == yr_ctr);
    
    % find intersect points for each dataset & fill into master file:
    [c1, imet, imaster_m] = intersect(met(ind_met,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_m),5:20) = met(ind_met(imet),4:19);
    
    [c2, isoil, imaster_s] = intersect(soil(ind_soil,3), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_s),21:71) = soil(ind_soil(isoil),5:55);
    
    [c3, iflux, imaster_f] = intersect(flux(ind_flux,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_f),72:78) = flux(ind_flux(iflux),3:9);
    
 %%% because the data quality is poor, sometimes the dt number in the data
 %%% is offset by 0.01. Apply shift and test to see if we can fit these
 %%% numbers in now
 
 [k_met l_met] =setdiff(ind_met,ind_met(imet));
 [k_soil l_soil] =setdiff(ind_soil,ind_soil(isoil));
 [k_flux l_flux] =setdiff(ind_flux,ind_flux(iflux));
 
 if isempty(k_met)==0;
     met(l_met,2) = met(l_met,2)+ 0.01;
     [c1b, imetb, imaster_mb] = intersect(met(l_met,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_mb),5:20) = met(l_met(imetb),4:19);
 end
 
  if isempty(k_soil)==0;
     soil(l_soil,3) = soil(l_soil,3)+ 0.01;
     [c2b, isoilb, imaster_sb] = intersect(soil(l_soil,3), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_sb),21:71) = soil(l_soil(isoilb),5:55);
  end
 
  if isempty(k_flux)==0;
     flux(l_flux,2) = flux(l_flux,2)+ 0.01;
     [c3b, ifluxb, imaster_fb] = intersect(flux(l_flux,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_fb),72:78) = flux(l_flux(ifluxb),3:9);
  end
 
  clear k_met l_met k_soil l_soil k_flux l_flux
  
  [k_met l_met] =setdiff(ind_met,ind_met(imet));
 [k_soil l_soil] =setdiff(ind_soil,ind_soil(isoil));
 [k_flux l_flux] =setdiff(ind_flux,ind_flux(iflux));
 
 if isempty(k_met)==0;
     met(l_met,2) = met(l_met,2)- 0.01;
     [c1b, imetb, imaster_mb] = intersect(met(l_met,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_mb),5:20) = met(l_met(imetb),4:19);
 end
 
  if isempty(k_soil)==0;
     soil(l_soil,3) = soil(l_soil,3)- 0.01;
     [c2b, isoilb, imaster_sb] = intersect(soil(l_soil,3), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_sb),21:71) = soil(l_soil(isoilb),5:55);
  end
 
  if isempty(k_flux)==0;
     flux(l_flux,2) = flux(l_flux,2)- 0.01;
     [c3b, ifluxb, imaster_fb] = intersect(flux(l_flux,2), bor_master(bor_master(:,2)==yr_ctr,3));
    bor_master(ind_master(imaster_fb),72:78) = flux(l_flux(ifluxb),3:9);
  end
  
    clear ind_met ind_soil ind_flux c1 c2 c3 imet isoil iflux imaster_m imaster_s imaster_f;
end

%% Next step: Visually Clean the data -- modify the metclean file to do so:

col_num = str2num(char(master_hdr(:,1)));
var_names = char(master_hdr(:,2));

%% Load Threshold file -- If it does not exist, start creating one
if exist([data_path 'Bor_thresh.dat'])
    thresh = load([data_path 'Bor_thresh.dat']);
    threshflag = 1;
    thresh_out_flag = 1;
    disp('Threshold file exists: Uploading');
    
else
    thresh(1:78,1:3) = NaN;
    thresh(1:78,1) = col_num;
    threshflag = 0;
    thresh_out_flag = 0;
    disp('Threshold file does not exist. A new one will be made now');
end

%% Load file, plot it, and give cleaning options
for i = 5:1:78
    accept = 1;
    figure(1)
    clf;
    plot(bor_master(:,i));
    hold on;
    title(master_hdr(i,:));
    switch threshflag
        case 1
            %%% Load lower and upper limits
            low_lim = thresh(i,2);
            up_lim = thresh(i,3);

        case 0
            low_lim_str = input('Enter Lower Limit: ', 's');
            low_lim = str2double(low_lim_str);

            up_lim_str = input('Enter Upper Limit: ', 's');
            up_lim = str2double(up_lim_str);

            %%% Write new values to thresh matrix
%             thresh_row = find(thresh(:,1) == vars30(i));  %% Select correct row in thresh
            thresh(i,2) = low_lim;
            thresh(i,3) = up_lim;

    end

    %%% Plot lower limit
    line([1 length(bor_master(:,i))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
    %%% Plot lower limit
    line([1 length(bor_master(:,i))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')

    axis([1   length(bor_master(:,i))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
    title(var_names(i,:));

    %% Gives the user a chance to change the thresholds
    response = input('Press enter to accept, "1" to enter new thresholds: ', 's');

    if isempty(response)==1
    accept = 1;
    
    elseif isequal(str2double(response),1)==1;
        accept = 0;
        thresh_out_flag = 1;
    end
    
        while accept == 0;
            %%% New lower limit
            low_lim_new = input('enter new lower limit: ','s');
            low_lim = str2double(low_lim_new);
            thresh(i,2) = low_lim;
            
            %%% New upper limit
            up_lim_new = input('enter new upper limit: ','s');
            up_lim = str2double(up_lim_new);
            thresh(i,3) = up_lim;
            %%% plot again
            figure (1)
            clf;
            plot(bor_master(:,i))
            hold on
            %%% Plot lower limit
            line([1 length(bor_master(:,i))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
            %%% Plot lower limit
            line([1 length(bor_master(:,i))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')

            axis([1   length(bor_master(:,i))    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
            title(var_names(i,:));



            accept_resp = input('hit enter to accept, 1 to change again: ','s');
            if isempty(accept_resp)
                accept = 1;
            else
                accept = 0;
            end
        end
   
    bor_master(bor_master(:,i) > up_lim | bor_master(:,i) < low_lim,i) = NaN;

    clear up_lim low_lim accept_resp accept response;

end

%% Save threshold file
if isequal(thresh_out_flag,1) == 1;
    save([data_path 'Bor_thresh.dat'],'thresh','-ASCII');
end

%% Save master file:

save([data_path 'Bor_master.dat'],'bor_master','-ASCII');

clear all;
close all;

%% Select necessary data 

%% Load Borden Data:
data = load('C:\HOME\MATLAB\Data\borden\Bor_master.dat');

% Variables Needed:
% - Ts - SoilT5a,b,c,d
% - SM - Avg of top 20cm
% - T_air
% - RH
% - ustar
% - PAR
% - WS
% - CO2Flux
% - CO2 Storage (conc)

% Soil temperature for top 5cm:
Ts_raw = [data(:,23) data(:,24) data(:,25) data(:,26)];



%% Spikes in Ts data -- Find and Remove

diff_Ts1 = Ts_raw(1:length(Ts_raw)-1,:) - Ts_raw(2:length(Ts_raw),:);
diff_Ts2(1,1:4) = NaN;
diff_Ts2(2:length(Ts_raw),1:4)= Ts_raw(2:length(Ts_raw),:) - Ts_raw(1:length(Ts_raw)-1,:);

ind_Ts_error1 = find(abs(diff_Ts1(:,1)) > 0.7 & abs(diff_Ts2(1:length(diff_Ts2)-1,1)) > 0.7);
ind_Ts_error2 = find(abs(diff_Ts1(:,2)) > 0.7 & abs(diff_Ts2(1:length(diff_Ts2)-1,2)) > 0.7);
ind_Ts_error3 = find(abs(diff_Ts1(:,3)) > 0.7 & abs(diff_Ts2(1:length(diff_Ts2)-1,3)) > 0.7);
ind_Ts_error4 = find(abs(diff_Ts1(:,4)) > 0.7 & abs(diff_Ts2(1:length(diff_Ts2)-1,4)) > 0.7);

corr_Ts = Ts_raw;

corr_Ts(ind_Ts_error1,1) = NaN;
corr_Ts(ind_Ts_error2,2) = NaN;
corr_Ts(ind_Ts_error3,3) = NaN;
corr_Ts(ind_Ts_error4,4) = NaN;




%% Fill spikes in by linear interpolation
fill_Ts = corr_Ts;
[fill_Ts(:,1)] = jjb_interp_gap(corr_Ts(:,1),(1:1:length(corr_Ts)), 3);
[fill_Ts(:,2)] = jjb_interp_gap(corr_Ts(:,2),(1:1:length(corr_Ts)), 3);
[fill_Ts(:,3)] = jjb_interp_gap(corr_Ts(:,3),(1:1:length(corr_Ts)), 3);
[fill_Ts(:,4)] = jjb_interp_gap(corr_Ts(:,4),(1:1:length(corr_Ts)), 3);

figure(1)
clf;
plot(Ts_raw(:,1),'r')
hold on;
plot(corr_Ts(:,1),'b')
plot(fill_Ts(:,1),'g');

clear Ts_raw corr_Ts ind_Ts_error1 ind_Ts_error2 ind_Ts_error3 ind_Ts_error4;  

%% Average Ts
fill_Ts_t = fill_Ts';
for i = 1:1:length(fill_Ts)
Ts(i) = nanmean(fill_Ts_t(:,i));
end
Ts = Ts';

clear fill_Ts fill_Ts_t i diff_Ts1 diff_Ts2 ;
%% Prepare Soil Moisture
SM5a = data(:,49); SM10a = data(:,50); SM20a = data(:,51);
SM5b = data(:,55); SM10b = data(:,56); SM20b = data(:,57);

figure(6)
clf;
subplot(3,1,1); plot(SM5a,'b'); hold on; plot(SM5b,'r');
subplot(3,1,2); plot(SM10a,'b'); hold on; plot(SM10b,'r');
subplot(3,1,3); plot(SM20a,'b'); hold on; plot(SM20b,'r');


SM5 = (SM5a + SM5b)./2;
SM5(isnan(SM5)) = SM5a(isnan(SM5));
SM5(isnan(SM5)) = SM5b(isnan(SM5));

SM10 = (SM10a + SM10b)./2;
SM10(isnan(SM10)) = SM10a(isnan(SM10));
SM10(isnan(SM10)) = SM10b(isnan(SM10));

SM20 = (SM20a + SM20b)./2;
SM20(isnan(SM20)) = SM20a(isnan(SM20));
SM20(isnan(SM20)) = SM20b(isnan(SM20));

figure(4)
clf
plot(SM5,'bx-')
hold on;
plot(SM10,'rx-')
plot(SM20,'gx-')

%% Remove spikes from Soil Moisture Data:
corr_SM5 = SM5;
corr_SM10 = SM10;
corr_SM20 = SM20;

diff_SM5_1 = SM5(1:length(SM5)-1,:) - SM5(2:length(SM5),:);
diff_SM5_2(1,1) = NaN;
diff_SM5_2(2:length(SM5),1)= SM5(2:length(SM5),1) - SM5(1:length(SM5)-1,1);
ind_SM5_error = find(abs(diff_SM5_1) > 0.03 & abs(diff_SM5_2(1:length(diff_SM5_2)-1)) > 0.03);
% corr_SM5(ind_SM5_error) = NaN;

diff_SM10_1 = SM10(1:length(SM10)-1,1) - SM10(2:length(SM10),1);
diff_SM10_2(1,1) = NaN;
diff_SM10_2(2:length(SM10),1)= SM10(2:length(SM10),1) - SM10(1:length(SM10)-1,1);
ind_SM10_error = find(abs(diff_SM10_1) > 0.03 & abs(diff_SM10_2(1:length(diff_SM10_2)-1)) > 0.03);
% corr_SM10(ind_SM10_error) = NaN;

diff_SM20_1 = SM20(1:length(SM20)-1,1) - SM20(2:length(SM20),1);
diff_SM20_2(1,1) = NaN;
diff_SM20_2(2:length(SM20),1)= SM20(2:length(SM20),1) - SM20(1:length(SM20)-1,1);
ind_SM20_error = find(abs(diff_SM20_1) > 0.02 & abs(diff_SM20_2(1:length(diff_SM20_2)-1)) > 0.02);

corr_SM5(ind_SM5_error) = NaN;
corr_SM10(ind_SM10_error) = NaN;
corr_SM20(ind_SM20_error) = NaN;

clear diff_SM5_1 diff_SM5_2 ind_SM5_error diff_SM10_1 diff_SM10_2 ind_SM10_error;
clear diff_SM20_1 diff_SM20_2 ind_SM20_error;



%% Fill Gaps:

[fill_SM5(:,1)] = jjb_interp_gap(corr_SM5(:,1),(1:1:length(corr_SM5)), 3);
[fill_SM10(:,1)] = jjb_interp_gap(corr_SM10(:,1),(1:1:length(corr_SM10)), 3);
[fill_SM20(:,1)] = jjb_interp_gap(corr_SM20(:,1),(1:1:length(corr_SM20)), 3);

figure(5)
clf
plot(fill_SM5,'bx-')
hold on;
plot(fill_SM10,'rx-')
plot(fill_SM20,'gx-')

clear corr_SM5 corr_SM10 corr_SM20; 

%% Clean soil moisture data and depth-weight average

% %%% predict SM @ 15cm using average of 10 and 20 cm
SM15 = (fill_SM10+fill_SM20)./2;
SM15(isnan(SM15)) = fill_SM10(isnan(SM15));
% %%% average SM @ 5cm and SM @ 15cm to get average for top 20cm
SM = (fill_SM5+SM15)./2;
SM(isnan(SM)) = fill_SM10(isnan(SM));

%% Air Temperature:
T42 = data(:,9);
T33 = data(:,7);
T33(28214,1) = NaN; T33(43470,1) = NaN;

T33(isnan(T33)) = T42(isnan(T33));
figure(7)
clf;
plot(T42,'bx-'); hold on;
plot(T33,'rx-');
Ta = T33;
clear T33 T42;


%% Relative Humidity - get VPD:
RH42 = data(:,10);
RH33 = data(:,8);

RH33(isnan(RH33)) = RH42(isnan(RH33));

figure(8)
clf;
plot(RH42,'bx-'); hold on;
plot(RH33,'rx-');

%% Convert RH into VPD:
esat = 0.6108.*exp((17.27.*Ta)./(237.3+Ta));
e = (RH33.*esat)./100;
VPD = esat-e;
clear RH42 RH33 esat e;

%% PAR, WS, ustar, Air Pressure

PAR = data(:,12);
WS = data(:,5);
ustar = data(:,72);
Pres = data(:,11)./10;
figure(9)
subplot(4,1,1); plot(PAR)
subplot(4,1,2); plot(WS)
subplot(4,1,3); plot(ustar)

%% Fill Pressure:
Pres(isnan(Pres)) = 99;
Ta_fill= Ta;  Ta_fill(isnan(Ta_fill)) = 12;

%% Get CO2 Flux and calculate storage:
FC = data(:,75);  %% data in mg/m2s

CO2 = data(:,77); %% data in ppm/m2s
% Convert CO2conc to mg/m3, FC to umol/m2s
FC = CO2_convert(FC,Ta_fill,Pres,2);
CO2 = CO2_convert(CO2,Ta_fill,Pres,1);

figure(10)
subplot(4,1,1)
plot(FC)
subplot(4,1,2)
plot(CO2)

%%% Shift CO2_top data by one point and take difference to get dc/dt
%%% Also cuts off the extra data point that is created by adding NaN
c1top = [NaN; CO2(1:length(CO2)-1)];
c2top = [CO2(1:length(CO2)-1) ; NaN];

%%% Calculate CO2 storage in column below OPEC system: One-Height approach
%%%*** Note the output of this is in umol/mol NOT IN mg/m^3 ***********
dcdt = (c2top-c1top).*(33/1800).*(1000/44);  %% 1000/44 converts to umol/mol

%% Clean data (remove outliers (greater than +/- 10))
dcdt(dcdt < -10 | dcdt > 10 , 1) = NaN;
FC(abs(FC) > 50) = NaN;
%% NEE
NEE = FC + dcdt;

%% Save necessary variables:

output = [Ta Ts SM PAR WS ustar VPD NEE data(:,2) data(:,3)];
data_path = ('C:\HOME\MATLAB\Data\borden\');
save([data_path 'Bor_E_analysis.dat'],'output','-ASCII');

figure(11)
plot(NEE)
hold on
plot(FC,'r')






