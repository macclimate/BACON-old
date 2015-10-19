%%%CLEANED DATA%%%

%load chamber data
chamber_data = dlmread('C:\DATA\chamber_data\hhour_all_current.csv');       %%change here%%

%Clean for 2008
cleaned_Ch1_08 = output_2008(:,16);
cleaned_Ch1_08(cleaned_Ch1_08==0,1) = NaN;

cleaned_Ch2_08 = output_2008(:,26);
cleaned_Ch2_08(cleaned_Ch2_08==0,1) = NaN;

cleaned_Ch3_08 = output_2008(:,36);
cleaned_Ch3_08(cleaned_Ch3_08==0,1) = NaN;

cleaned_Ch4_08 = output_2008(:,46);
cleaned_Ch4_08(cleaned_Ch4_08==0,1) = NaN;

%Clean for 2009
cleaned_Ch1_09 = output_2009(:,16);
cleaned_Ch1_09(cleaned_Ch1_09==0,1) = NaN;

cleaned_Ch2_09 = output_2009(:,26);
cleaned_Ch2_09(cleaned_Ch2_09==0,1) = NaN;

cleaned_Ch3_09 = output_2009(:,36);
cleaned_Ch3_09(cleaned_Ch3_09==0,1) = NaN;

cleaned_Ch4_09 = output_2009(:,46);
cleaned_Ch4_09(cleaned_Ch4_09==0,1) = NaN;

cleaned_Ch5_09 = output_2009(:,46);
cleaned_Ch5_09(cleaned_Ch5_09==0,1) = NaN;

cleaned_Ch6_09 = output_2009(:,46);
cleaned_Ch6_09(cleaned_Ch6_09==0,1) = NaN;


%Plot Clean Data

% figure(22); 
% hold on;
% subplot (4,1,1);
% hold on;
% plot(cleaned_Ch1_08 , 'r')
% plot(cleaned_Ch1_09 , 'r')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch1')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch1',1)
% 
% hold on;
% subplot (4,1,2);
% hold on;
% plot(cleaned_Ch2_08 , 'b')
% plot(cleaned_Ch2_09 , 'b')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch2')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch2',1)
% 
% hold on;
% subplot (4,1,3);
% hold on;
% plot(cleaned_Ch3_08 , 'g')
% plot(cleaned_Ch3_09 , 'g')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch3')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch3',1)
% 
% hold on;
% subplot (4,1,4);
% hold on;
% plot(cleaned_Ch4_08 , 'c')
% plot(cleaned_Ch4_09 , 'c')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch4')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch4',1)
% 
% hold on;
% subplot (4,1,5);
% hold on;
% plot(cleaned_Ch5_08 , 'm')
% plot(cleaned_Ch5_09 , 'c')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch5')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch5',1)
% 
% hold on;
% subplot (4,1,6);
% hold on;
% plot(cleaned_Ch6_08 , 'k')
% plot(cleaned_Ch6_09 , 'c')
% %axis([0 18000 -20 35]);
% title('Soil CO2 Efflux Ch6')
% xlabel('HHOUR')
% ylabel ('Soil CO2 Efflux (umol C m-2 s-1)');
% legend('Ch6',1)


