% TP74_sapflow_path = 'D:/sapflow/';
% TP39_sapflow_path = 'D:/sapflow/';
% TP74_met_path = 'D:/sapflow/';
% TP39_met_path = 'D:/sapflow/';

%%% Data Computer %%%%%%%%%%%%%%%%%%%
TP74_sapflow_path = '/1/fielddata/Matlab/Data/Met/Calculated4/TP74_sapflow/';
TP39_sapflow_path = '/1/fielddata/Matlab/Data/Met/Calculated4/TP39_sapflow/';
TP74_met_path = '/1/fielddata/Matlab/Data/Master_Files/TP74/';
TP39_met_path = '/1/fielddata/Matlab/Data/Master_Files/TP39/';
%%%%%%%%%%%%%%%%%%%



% Load sapflow data:
TP74_2011sf = load([TP74_sapflow_path 'TP74_sapflow_calculated_2011.mat']);
TP39_2009sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2009.mat']);
TP39_2010sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2010.mat']);
TP39_2011sf = load([TP39_sapflow_path 'TP39_sapflow_calculated_2011.mat']);

% Load met data: 
TP74_2011met = load([TP74_met_path 'TP74_data_master_2011.mat']);
TP39_2009met = load([TP39_met_path 'TP39_data_master_2009.mat']);
TP39_2010met = load([TP39_met_path 'TP39_data_master_2010.mat']);
TP39_2011met = load([TP39_met_path 'TP39_data_master_2011.mat']);


% TP74 2011 Js:
%figure(1);clf;
%plot(TP74_2011sf.master.data(:,34:48)); hold on;
%plot(TP74_2011met.master.data(:,107)./1000,'k--');
%title('TP74 Js 2011 and Soil Moisture');
%xlabel('Time');
%ylabel('Sapflow Velocity (m/s)');

% TP39 2011 Js:
%figure(2);clf;
%plot(TP39_2011sf.master.data(:,47:69)); hold on;
%plot(TP39_2011met.master.data(:,131)./1000,'k--');
%title('TP39 Js 2011 and Soil Moisture');
%xlabel('Time');
%ylabel('Sapflow Velocity (m/s)');
%TP39 2011 - just column 51 (sensor 5)
%figure(8);clf;
%x1 = [1:17520];
%y1 =(TP39_2011sf.master.data(:,51));
%y2 = (TP39_2011met.master.data(:,131));
%[AX,H1,H2] = plotyy(x1,y1,x1,y2,'plot');
%set(get(AX(1),'Ylabel'),'String','Sapflow Velocity (m/s)');
%set(get(AX(2),'Ylabel'),'String','Soil moisture @30cm (m3/m3)'); 
%xlabel('Time)'); 
%title('TP39 2011 - (Sensor 5, DBH=43.3cm) Js and Soil Moisture'); 

%TP39 2010 Js:
%figure(3);clf;
%plot(TP39_2010sf.master.data(:,47:69)); hold on;
%plot(TP39_2010met.master.data(:,131)./1000,'k--');
%title('TP39 Js 2010 and Soil Moisture');
%xlabel('Time');
%ylabel('Sapflow Velocity (m/s)');
%TP39 2010 Js - specific columns
%figure(9);clf;
%x1 = [1:17520];
%y3 =(TP39_2010sf.master.data(:,48:51));
%y4 = (TP39_2010met.master.data(:,131));
%[AX,H1,H2] = plotyy(x1,y3,x1,y4,'plot');
%set(get(AX(1),'Ylabel'),'String','Sapflow Velocity (m/s)');
%set(get(AX(2),'Ylabel'),'String','Soil moisture @30cm (m3/m3)'); 
%xlabel('Time)'); 
%title('TP39 2010 - Js and Soil Moisture');

%TP39 2010 Js:
%figure(4);clf;
%plot(TP39_2009sf.master.data(:,47:69)); hold on;
%plot(TP39_2009met.master.data(:,131)./1000,'k--');
%title('TP39 Js 2009 and Soil Moisture');
%xlabel('Time');
%ylabel('Sapflow Velocity (m/s)');
%TP39 2009 Js - specific columns
%figure(10);clf;
%x1 = [1:17520];
%y3 =(TP39_2009sf.master.data(:,49:54));
%y4 = (TP39_2009met.master.data(:,131));
%[AX,H1,H2] = plotyy(x1,y3,x1,y4,'plot');
%set(get(AX(1),'Ylabel'),'String','Sapflow Velocity (m/s)');
%set(get(AX(2),'Ylabel'),'String','Soil moisture @30cm (m3/m3)'); 
%xlabel('Time)'); 
%title('TP39 2009 - Js and Soil Moisture');

%%
%Convert latent heat flux (W/m2) to mm/day
TP74_2011_Eunits = TP74_2011met.master.data(:,30); %W/m2
TP39_2011_Eunits = TP39_2011met.master.data(:,30); %W/m2
TP39_2010_Eunits = TP39_2010met.master.data(:,30); %W/m2
TP39_2009_Eunits = TP39_2009met.master.data(:,30); %W/m2

LV_7411 = 2.501-(0.002361.*(TP74_2011met.master.data(:,92))); %Mj/kg
LV_3911 = 2.501-(0.002361.*(TP39_2011met.master.data(:,116))); %Mj/kg
LV_3910 = 2.501-(0.002361.*(TP39_2010met.master.data(:,116))); %Mj/kg
LV_3909 = 2.501-(0.002361.*(TP39_2009met.master.data(:,116))); %Mj/kg

TP74_2011_E = (TP74_2011_Eunits./(LV_7411.*1000000)).*(60*30); %mm/hhour
TP39_2011_E = (TP39_2011_Eunits./(LV_3911.*1000000)).*(60*30); %mm/hhour
TP39_2010_E = (TP39_2010_Eunits./(LV_3910.*1000000)).*(60*30); %mm/hhour
TP39_2009_E = (TP39_2009_Eunits./(LV_3909.*1000000)).*(60*30); %mm/hour

TP74_2011_E_tmp = reshape(TP74_2011_E,48,[]);
TP74_2011_E_day = sum(TP74_2011_E_tmp',2);

test = sum(TP74_2011_E_tmp);

%Plot E converted into mm/day
figure(5);
plot(TP74_2011_E,'r'); hold on;
plot(TP39_2011_E,'b');
plot(TP39_2010_E,'b--');
plot(TP39_2009_E,'b.-');

%%
%TP74 2011 Convert to transpirationn

BA = 0.003224; %Basal area (m2/m2) or 37.3 (m2/ha)
dw = 1000; % Water Density (kg/m3)

sw1_7411 = 0.005359607; %Sapwood area of tree at 1.3m (m2)
sw2_7411 = 0.006812268;
sw3_7411 = 0.008671775;
sw4_7411 = 0.002228591;
sw5_7411 = 0.005822565;
sw6_7411 = 0.008671775;
sw7_7411 = 0.003852016;
sw8_7411 = 0.003682669;
sw9_7411 = 0.005865701;
sw10_7411 = 0.004167444;
sw11_7411 = 0.004203336;
sw12_7411 = 0.009440194;
sw13_7411 = 0.005196482;
sw14_7411 = 0.005156134;
sw15_7411 = 0.007314926;
sw16_7411 = 0.006217113;
w1_7411 = 0.026769861; %Total wood area of tree at 1.3m (m2)
w2_7411 = 0.033208952;
w3_7411 = 0.041252961;
w4_7411 = 0.012165883;
w5_7411 = 0.028839194;
w6_7411 = 0.041252961;
w7_7411 = 0.019894368;
w8_7411 = 0.019106551;
w9_7411 = 0.029031135;
w10_7411 = 0.021352545;
w11_7411 = 0.021517748;
w12_7411 = 0.044523914;
w13_7411 = 0.026036475
w14_7411 = 0.025854721;
w15_7411 = 0.035403142;
w16_7411 = 0.03058958;
sw_w1_7411 = sw1_7411/w1_7411; %Ratio of sapwood area to tree wood area (m2/m2)
sw_w2_7411 = sw2_7411/w2_7411;
sw_w3_7411 = sw3_7411/w3_7411;
sw_w4_7411 = sw4_7411/w4_7411;
sw_w5_7411 = sw5_7411/w5_7411;
sw_w6_7411 = sw6_7411/w6_7411;
sw_w7_7411 = sw7_7411/w7_7411;
sw_w8_7411 = sw8_7411/w8_7411;
sw_w9_7411 = sw9_7411/w9_7411;
sw_w10_7411 = sw10_7411/w10_7411;
sw_w11_7411 = sw11_7411/w11_7411;
sw_w12_7411 = sw12_7411/w12_7411;
sw_w13_7411 = sw13_7411/w13_7411;
sw_w14_7411 = sw14_7411/w14_7411;
sw_w15_7411 = sw15_7411/w15_7411;
sw_w16_7411 = sw16_7411/w16_7411;
%Transpiration per unit ground area (kg/m2/s) PER TREE
T1_7411 = (dw.*(TP74_2011sf.master.data(:,49)).*(sw_w1_7411));
T2_7411 = (dw.*(TP74_2011sf.master.data(:,50)).*(sw_w2_7411));
T3_7411 = (dw.*(TP74_2011sf.master.data(:,51)).*(sw_w3_7411));
T4_7411 = (dw.*(TP74_2011sf.master.data(:,52)).*(sw_w4_7411));
T5_7411 = (dw.*(TP74_2011sf.master.data(:,53)).*(sw_w5_7411));
T6_7411 = (dw.*(TP74_2011sf.master.data(:,54)).*(sw_w6_7411));
T7_7411 = (dw.*(TP74_2011sf.master.data(:,55)).*(sw_w7_7411));
T8_7411 = (dw.*(TP74_2011sf.master.data(:,56)).*(sw_w8_7411));
T9_7411 = (dw.*(TP74_2011sf.master.data(:,57)).*(sw_w9_7411));
T10_7411 = (dw.*(TP74_2011sf.master.data(:,58)).*(sw_w10_7411));
%T11_7411 = (dw.*(TP74_2011sf.master.data(:,59)).*(sw_w11_7411)); % ALL NAN?????
T12_7411 = (dw.*(TP74_2011sf.master.data(:,60)).*(sw_w12_7411));
T13_7411 = (dw.*(TP74_2011sf.master.data(:,61)).*(sw_w13_7411));
T14_7411 = (dw.*(TP74_2011sf.master.data(:,62)).*(sw_w14_7411));
T15_7411 = (dw.*(TP74_2011sf.master.data(:,63)).*(sw_w15_7411));
T16_7411 = (dw.*(TP74_2011sf.master.data(:,64)).*(sw_w16_7411));

%Transpiration per unit ground area (mm/day)
Ec_7411sum = T1_7411+T2_7411+T3_7411+T4_7411+T5_7411+T6_7411+T7_7411+T8_7411+T9_7411+T10_7411+T12_7411+T13_7411+T14_7411+T15_7411+T16_7411;
Ec_7411units = ((Ec_7411sum./15).*BA)*1800; %units: kg/m2/s
Ec_7411rs = reshape(Ec_7411units,48,[]);
Ec_7411_day = sum(Ec_7411rs',2);
figure(10);
plot(Ec_7411_day);


%%
%TP39 2011 Convert to transpirationn

BA = 0.0037; %Basal area (m2/m2) or 37 (m2/ha)
dw = 1000; % Water Density (kg/m3)

%Sapwood area of tree at 1.3m (m2)
sw1_3911 = 0.025839537;
sw2_3911 = 0.011835456;
sw3_3911 = 0.027531562;
sw4_3911 = 0.046612865;
sw5_3911 = 0.035767464;
sw6_3911 = 0.038696572;
sw7_3911 = 0.027480952;
sw8_3911 = 0.020766876;
sw9_3911 = 0.01801359;
sw10_3911 = 0.032463668;
sw11_3911 = 0.018214642;
sw12_3911 = 0.027531562;
sw13_3911 = 0.061711055;
sw14_3911 = 0.040615435;
sw15_3911 = 0.024585399;
sw16_3911 = 0.037846724;
sw17_3911 = 0.044080528;
sw18_3911 = 0.024871767;
sw19_3911 = 0.029282864;
sw20_3911 = 0.026479512;
sw22_3911 = 0.013863927;
sw23_3911 = 0.030180862;
%Total wood area of tree at 1.3m (m2)
w1_3911 = 0.110053733;
w2_3911 = 0.054557041;
w3_3911 = 0.116509376;
w4_3911 = 0.187014141;
w5_3911 = 0.147403022;
w6_3911 = 0.158207971;
w7_3911 = 0.116316878;
w8_3911 = 0.090428337;
w9_3911 = 0.079577472;
w10_3911 = 0.135107347;
w11_3911 = 0.080375236;
w12_3911 = 0.116509376;
w13_3911 = 0.240651903;
w14_3911 = 0.165241108;
w15_3911 = 0.105241206;
w16_3911 = 0.15508185;
w17_3911 = 0.177857638;
w18_3911 = 0.10634224;
w19_3911 = 0.123149002;
w20_3911 = 0.112500343;
w22_3911 = 0.062891747;
w23_3911 = 0.126537809;
%Ratio of sapwood area to tree wood area (m2/m2)
sw_w1_3911 = sw1_3911/w1_3911; 
sw_w2_3911 = sw2_3911/w2_3911;
sw_w3_3911 = sw3_3911/w3_3911;
sw_w4_3911 = sw4_3911/w4_3911;
sw_w5_3911 = sw5_3911/w5_3911;
sw_w6_3911 = sw6_3911/w6_3911;
sw_w7_3911 = sw7_3911/w7_3911;
sw_w8_3911 = sw8_3911/w8_3911;
sw_w9_3911 = sw9_3911/w9_3911;
sw_w10_3911 = sw10_3911/w10_3911;
sw_w11_3911 = sw11_3911/w11_3911;
sw_w12_3911 = sw12_3911/w12_3911;
sw_w13_3911 = sw13_3911/w13_3911;
sw_w14_3911 = sw14_3911/w14_3911;
sw_w15_3911 = sw15_3911/w15_3911;
sw_w16_3911 = sw16_3911/w16_3911;
sw_w17_3911 = sw17_3911/w17_3911;
sw_w18_3911 = sw18_3911/w18_3911;
sw_w19_3911 = sw19_3911/w19_3911;
sw_w20_3911 = sw20_3911/w20_3911;
sw_w22_3911 = sw22_3911/w22_3911;
sw_w23_3911 = sw23_3911/w23_3911;
%Transpiration per unit ground area (kg/m2/s) PER TREE
T1_3911 = (dw.*(TP39_2010sf.master.data(:,70)).*(sw_w1_3911));
T2_3911 = (dw.*(TP39_2010sf.master.data(:,71)).*(sw_w2_3911));
T3_3911 = (dw.*(TP39_2010sf.master.data(:,72)).*(sw_w3_3911));
T4_3911 = (dw.*(TP39_2010sf.master.data(:,73)).*(sw_w4_3911));
T5_3911 = (dw.*(TP39_2010sf.master.data(:,74)).*(sw_w5_3911));
%T6_3911 = (dw.*(TP39_2010sf.master.data(:,75)).*(sw_w6_3911));
%T7_3911 = (dw.*(TP39_2010sf.master.data(:,76)).*(sw_w7_3911));
T8_3911 = (dw.*(TP39_2010sf.master.data(:,77)).*(sw_w8_3911));
T9_3911 = (dw.*(TP39_2010sf.master.data(:,78)).*(sw_w9_3911));
T10_3911 = (dw.*(TP39_2010sf.master.data(:,79)).*(sw_w10_3911));
T11_3911 = (dw.*(TP39_2010sf.master.data(:,80)).*(sw_w11_3911));
T12_3911 = (dw.*(TP39_2010sf.master.data(:,81)).*(sw_w12_3911));
T13_3911 = (dw.*(TP39_2010sf.master.data(:,82)).*(sw_w13_3911));
T14_3911 = (dw.*(TP39_2010sf.master.data(:,83)).*(sw_w14_3911));
T15_3911 = (dw.*(TP39_2010sf.master.data(:,84)).*(sw_w15_3911));
T16_3911 = (dw.*(TP39_2010sf.master.data(:,85)).*(sw_w16_3911));
T17_3911 = (dw.*(TP39_2010sf.master.data(:,86)).*(sw_w17_3911));
T18_3911 = (dw.*(TP39_2010sf.master.data(:,87)).*(sw_w18_3911));
T19_3911 = (dw.*(TP39_2010sf.master.data(:,88)).*(sw_w19_3911));
T20_3911 = (dw.*(TP39_2010sf.master.data(:,89)).*(sw_w20_3911));
%T22_3911 = (dw.*(TP39_2010sf.master.data(:,91)).*(sw_w22_3911));
%T23_3911 = (dw.*(TP39_2010sf.master.data(:,92)).*(sw_w23_3911));

%Transpiration per unit ground area (mm/day)
Ec_3911sum = T1_3911+T2_3911+T3_3911+T4_3911+T5_3911+T8_3911+T9_3911+T10_3911+T11_3911+T12_3911+T13_3911+T14_3911+T15_3911+T16_3911+T17_3911+T18_3911+T19_3911+T20_3911;
Ec_3911units = (Ec_3911sum./18).*BA; %units: kg/m2/s
Ec_3911 = Ec_3911units.*(60*60*24);  %units: mm/day
figure(2);
plot(Ec_3911);

%%
%TP39 2010 Convert to transpirationn

BA = 0.0037; %Basal area (m2/m2) or 37 (m2/ha)
dw = 1000; % Water Density (kg/m3)

%Sapwood area of tree at 1.3m (m2)
sw1_3910 = 0.025618718;
sw2_3910 = 0.011727488;
sw3_3910 = 0.02707969;
sw4_3910 = 0.047675762;
sw5_3910 = 0.036129198;
sw6_3910 = 0.038215569;
sw7_3910 = 0.027715615;
sw8_3910 = 0.020183307;
sw9_3910 = 0.017747898;
sw10_3910 = 0.031952418;
sw11_3910 = 0.017876408;
sw12_3910 = 0.026499687;
sw13_3910 = 0.061755081;
sw14_3910 = 0.039871794;
sw15_3910 = 0.025595037;
sw16_3910 = 0.040389578;
sw17_3910 = 0.043919544;
sw18_3910 = 0.02457024;
sw19_3910 = 0.02911785;
sw20_3910 = 0.026204644;
sw22_3910 = 0.013573694;
sw23_3910 = 0.030619543;
%Total wood area of tree at 1.3m (m2)
w1_3910 = 0.109208128;
w2_3910 = 0.054109551;
w3_3910 = 0.114789372;
w4_3910 = 0.19084225;
w5_3910 = 0.148742105;
w6_3910 = 0.156439492;
w7_3910 = 0.117209136;
w8_3910 = 0.088141309;
w9_3910 = 0.078521828;
w10_3910 = 0.133193601;
w11_3910 = 0.079032619;
w12_3910 = 0.112577371;
w13_3910 = 0.240806192;
w14_3910 = 0.162519553;
w15_3910 = 0.109117399;
w16_3910 = 0.164415062;
w17_3910 = 0.177273775;
w18_3910 = 0.105182887;
w19_3910 = 0.122525145;
w20_3910 = 0.111450269;
w22_3910 = 0.061707234;
w23_3910 = 0.128189547;
%Ratio of sapwood area to tree wood area (m2/m2)
sw_w1_3910 = sw1_3910/w1_3910; 
sw_w2_3910 = sw2_3910/w2_3910;
sw_w3_3910 = sw3_3910/w3_3910;
sw_w4_3910 = sw4_3910/w4_3910;
sw_w5_3910 = sw5_3910/w5_3910;
sw_w6_3910 = sw6_3910/w6_3910;
sw_w7_3910 = sw7_3910/w7_3910;
sw_w8_3910 = sw8_3910/w8_3910;
sw_w9_3910 = sw9_3910/w9_3910;
sw_w10_3910 = sw10_3910/w10_3910;
sw_w11_3910 = sw11_3910/w11_3910;
sw_w12_3910 = sw12_3910/w12_3910;
sw_w13_3910 = sw13_3910/w13_3910;
sw_w14_3910 = sw14_3910/w14_3910;
sw_w15_3910 = sw15_3910/w15_3910;
sw_w16_3910 = sw16_3910/w16_3910;
sw_w17_3910 = sw17_3910/w17_3910;
sw_w18_3910 = sw18_3910/w18_3910;
sw_w19_3910 = sw19_3910/w19_3910;
sw_w20_3910 = sw20_3910/w20_3910;
sw_w22_3910 = sw22_3910/w22_3910;
sw_w23_3910 = sw23_3910/w23_3910;
%Transpiration per unit ground area (kg/m2/s) PER TREE
T1_3910 = (dw.*(TP39_2010sf.master.data(:,70)).*(sw_w1_3910));
T2_3910 = (dw.*(TP39_2010sf.master.data(:,71)).*(sw_w2_3910));
T3_3910 = (dw.*(TP39_2010sf.master.data(:,72)).*(sw_w3_3910));
T4_3910 = (dw.*(TP39_2010sf.master.data(:,73)).*(sw_w4_3910));
T5_3910 = (dw.*(TP39_2010sf.master.data(:,74)).*(sw_w5_3910));
%T6_3910 = (dw.*(TP39_2010sf.master.data(:,75)).*(sw_w6_3910));
%T7_3910 = (dw.*(TP39_2010sf.master.data(:,76)).*(sw_w7_3910));
T8_3910 = (dw.*(TP39_2010sf.master.data(:,77)).*(sw_w8_3910));
T9_3910 = (dw.*(TP39_2010sf.master.data(:,78)).*(sw_w9_3910));
T10_3910 = (dw.*(TP39_2010sf.master.data(:,79)).*(sw_w10_3910));
T11_3910 = (dw.*(TP39_2010sf.master.data(:,80)).*(sw_w11_3910));
T12_3910 = (dw.*(TP39_2010sf.master.data(:,81)).*(sw_w12_3910));
T13_3910 = (dw.*(TP39_2010sf.master.data(:,82)).*(sw_w13_3910));
T14_3910 = (dw.*(TP39_2010sf.master.data(:,83)).*(sw_w14_3910));
T15_3910 = (dw.*(TP39_2010sf.master.data(:,84)).*(sw_w15_3910));
T16_3910 = (dw.*(TP39_2010sf.master.data(:,85)).*(sw_w16_3910));
T17_3910 = (dw.*(TP39_2010sf.master.data(:,86)).*(sw_w17_3910));
T18_3910 = (dw.*(TP39_2010sf.master.data(:,87)).*(sw_w18_3910));
T19_3910 = (dw.*(TP39_2010sf.master.data(:,88)).*(sw_w19_3910));
T20_3910 = (dw.*(TP39_2010sf.master.data(:,89)).*(sw_w20_3910));
%T22_3910 = (dw.*(TP39_2010sf.master.data(:,91)).*(sw_w22_3910));
%T23_3910 = (dw.*(TP39_2010sf.master.data(:,92)).*(sw_w23_3910));

%Transpiration per unit ground area (mm/day)
Ec_3910sum = T1_3910+T2_3910+T3_3910+T4_3910+T5_3910+T8_3910+T9_3910+T10_3910+T11_3910+T12_3910+T13_3910+T14_3910+T15_3910+T16_3910+T17_3910+T18_3910+T19_3910+T20_3910;
Ec_3910units = (Ec_3910sum./18).*BA; %units: kg/m2/s
Ec_3910 = Ec_3910units.*(60*60*24);  %units: mm/day
figure(3);
plot(Ec_3910);

%%
%TP39 2009 Convert to transpirationn

BA = 0.0037; %Basal area (m2/m2) or 37 (m2/ha)
dw = 1000; % Water Density (kg/m3)

%Sapwood area of tree at 1.3m (m2)
sw1_3909 = 0.024279102;
sw2_3909 = 0.011680066;
sw3_3909 = 0.025178724;
sw4_3909 = 0.043490419;
sw5_3909 = 0.032418783;
sw6_3909 = 0.03591098;
sw7_3909 = 0.025942199;
sw8_3909 = 0.020183307;
sw9_3909 = 0.016862082;
sw10_3909 = 0.029948972;
sw11_3909 = 0.017599402;
sw12_3909 = 0.026251109;
sw13_3909 = 0.059368954;
sw14_3909 = 0.038348817;
sw15_3909 = 0.02405701;
sw16_3909 = 0.036465737;
sw17_3909 = 0.040480665;
sw18_3909 = 0.022963379;
sw19_3909 = 0.027825924;
sw20_3909 = 0.025330415;
sw22_3909 = 0.013541385;
sw23_3909 = 0.030619543;
%Total wood area of tree at 1.3m (m2)
w1_3909 = 0.104062027;
w2_3909 = 0.053912826;
w3_3909 = 0.107520918;
w4_3909 = 0.175716197;
w5_3909 = 0.135004458;
w6_3909 = 0.147934332;
w7_3909 = 0.110446523;
w8_3909 = 0.088141234;
w9_3909 = 0.074990539;
w10_3909 = 0.1256636;
w11_3909 = 0.077931067;
w12_3909 = 0.110446523;
w13_3909 = 0.232427395;
w14_3909 = 0.156929489;
w15_3909 = 0.103263089;
w16_3909 = 0.149986575;
w17_3909 = 0.159608983;
w18_3909 = 0.09897972;
w19_3909 = 0.117628198;
w20_3909 = 0.108102897;
w22_3909 = 0.061575164;
w23_3909 = 0.128189438;
%Ratio of sapwood area to tree wood area (m2/m2)
sw_w1_3909 = sw1_3909/w1_3909; 
sw_w2_3909 = sw2_3909/w2_3909;
sw_w3_3909 = sw3_3909/w3_3909;
sw_w4_3909 = sw4_3909/w4_3909;
sw_w5_3909 = sw5_3909/w5_3909;
sw_w6_3909 = sw6_3909/w6_3909;
sw_w7_3909 = sw7_3909/w7_3909;
sw_w8_3909 = sw8_3909/w8_3909;
sw_w9_3909 = sw9_3909/w9_3909;
sw_w10_3909 = sw10_3909/w10_3909;
sw_w11_3909 = sw11_3909/w11_3909;
sw_w12_3909 = sw12_3909/w12_3909;
sw_w13_3909 = sw13_3909/w13_3909;
sw_w14_3909 = sw14_3909/w14_3909;
sw_w15_3909 = sw15_3909/w15_3909;
sw_w16_3909 = sw16_3909/w16_3909;
sw_w17_3909 = sw17_3909/w17_3909;
sw_w18_3909 = sw18_3909/w18_3909;
sw_w19_3909 = sw19_3909/w19_3909;
sw_w20_3909 = sw20_3909/w20_3909;
sw_w22_3909 = sw22_3909/w22_3909;
sw_w23_3909 = sw23_3909/w23_3909;
%Transpiration per unit ground area (kg/m2/s) PER TREE
T1_3909 = (dw.*(TP39_2009sf.master.data(:,70)).*(sw_w1_3909));
T2_3909 = (dw.*(TP39_2009sf.master.data(:,71)).*(sw_w2_3909));
T3_3909 = (dw.*(TP39_2009sf.master.data(:,72)).*(sw_w3_3909));
T4_3909 = (dw.*(TP39_2009sf.master.data(:,73)).*(sw_w4_3909));
T5_3909 = (dw.*(TP39_2009sf.master.data(:,74)).*(sw_w5_3909));
T6_3909 = (dw.*(TP39_2009sf.master.data(:,75)).*(sw_w6_3909));
T7_3909 = (dw.*(TP39_2009sf.master.data(:,76)).*(sw_w7_3909));
T8_3909 = (dw.*(TP39_2009sf.master.data(:,77)).*(sw_w8_3909));
T9_3909 = (dw.*(TP39_2009sf.master.data(:,78)).*(sw_w9_3909));
T10_3909 = (dw.*(TP39_2009sf.master.data(:,79)).*(sw_w10_3909));
T11_3909 = (dw.*(TP39_2009sf.master.data(:,80)).*(sw_w11_3909));
T12_3909 = (dw.*(TP39_2009sf.master.data(:,81)).*(sw_w12_3909));
T13_3909 = (dw.*(TP39_2009sf.master.data(:,82)).*(sw_w13_3909));
T14_3909 = (dw.*(TP39_2009sf.master.data(:,83)).*(sw_w14_3909));
T15_3909 = (dw.*(TP39_2009sf.master.data(:,84)).*(sw_w15_3909));
T16_3909 = (dw.*(TP39_2009sf.master.data(:,85)).*(sw_w16_3909));
T17_3909 = (dw.*(TP39_2009sf.master.data(:,86)).*(sw_w17_3909));
T18_3909 = (dw.*(TP39_2009sf.master.data(:,87)).*(sw_w18_3909));
T19_3909 = (dw.*(TP39_2009sf.master.data(:,88)).*(sw_w19_3909));
T20_3909 = (dw.*(TP39_2009sf.master.data(:,89)).*(sw_w20_3909));
T22_3909 = (dw.*(TP39_2009sf.master.data(:,91)).*(sw_w22_3909));
%T23_3909 = (dw.*(TP39_2009sf.master.data(:,92)).*(sw_w23_3909));

%Transpiration per unit ground area (mm/day)
Ec_3909sum = T1_3909+T2_3909+T3_3909+T4_3909+T5_3909+T6_3909+T7_3909+T8_3909+T9_3909+T10_3909+T11_3909+T12_3909+T13_3909+T14_3909+T15_3909+T16_3909+T17_3909+T18_3909+T19_3909+T20_3909+T22_3909;
Ec_3909units = (Ec_3909sum./22).*BA; %units: kg/m2/s
Ec_3909 = (Ec_3909units).*(60*60*24);  %units: mm/day
figure(4);
plot(Ec_3909);