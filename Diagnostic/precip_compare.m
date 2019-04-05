%% precip_compare
%%% This script is run to compare precipitation measured at M1, M4 and
%%% delhi station.  

% clear all
%% Load met precip data:

load_dir = 'C:\HOME\MATLAB\Data\Flux\OPEC\Organized2\';
ctr = 1;

M1_Precip(1:17568,1:5) = NaN;
M4_Precip(1:17568,1:5) = NaN;

for i = 2002:1:2006
    if i == 2004;
        len = 17568;
    else
        len = 17520;
    end
    
    yr_str = num2str(i);
%%% Met 1
M1_Precip(1:len,ctr) = load([load_dir 'Met1\Column\Met1_' yr_str '.036']);
M4_Precip(1:len,ctr) = load([load_dir 'Met4\Column\Met4_' yr_str '.029']);

ctr = ctr+1;                  
end

%% Load Delhi Daily data

Delhi_Precip(:,:) = dlmread('C:\HOME\MATLAB\Data\Ancillary Data\Delhi_Day_Precip_2002_2006.csv',',');

%% Reshape met data to make daily averages

for j = 1:1:ctr-1
    M1_P_res = reshape(M1_Precip(:,j),48,[]);
    M4_P_res = reshape(M4_Precip(:,j),48,[]);
    for k = 1:1:366
        M1_P_dsum1(1,k) = nansum(M1_P_res(:,k));
        M4_P_dsum1(1,k) = nansum(M4_P_res(:,k));
    end

M1_P_dsum(1:366,j) = M1_P_dsum1(1,1:366);
M4_P_dsum(1:366,j) = M4_P_dsum1(1,1:366);

end
clear M4_P_dsum1 M4_P_res M1_P_dsum1 M1_P_res

%% Plot for one year (2005) for inspection and comparison:
figure(1)
plot(Delhi_Precip(:,4))
hold on;
plot(M1_P_dsum(:,4),'r');
plot(M4_P_dsum(:,4),'g');

%% Sum up for entire year:

for m = 1:1:ctr-1
Delhi_yr_tot(1,m) = nansum(Delhi_Precip(:,m));
Del_rain_days = find(Delhi_Precip(:,m)~=0 & ~isnan(Delhi_Precip(:,m)));
Delhi_yr_tot(2,m) = length(Del_rain_days);

M1_yr_tot(1,m) = nansum(M1_P_dsum(:,m));
M1_rain_days = find(M1_P_dsum(:,m)~=0 & ~isnan(M1_P_dsum(:,m)));
M1_yr_tot(2,m) = length(M1_rain_days);

M4_yr_tot(1,m) = nansum(M4_P_dsum(:,m));
M4_rain_days = find(M4_P_dsum(:,m)~=0 & ~isnan(M4_P_dsum(:,m)));
M4_yr_tot(2,m) = length(M4_rain_days);

clear Del_rain_days M1_rain_days M4_rain_days;
end


