function [GDD_daily, GDD_hh] = GDD_calc(Ta_in, T_base, pts_per_day,yrs)

if nargin == 3 
    yrs = [];
end

if nargin == 2 || isempty(pts_per_day)
    pts_per_day = 48;
end

if nargin == 1 || isempty(T_base)
    T_base = 10;
end
%%% Calculate daily-averaged stats:
[junk1 junk2 junk3 daily_max daily_min daily_std nans_per_day] = daily_stats(Ta_in, pts_per_day);

%%% Sets and T lower than T_base to Tbase:
daily_min(daily_min < T_base,1) = T_base;
daily_max(daily_max < T_base,1) = T_base;
%%% Any temp higher than 30 equal to 30:
daily_max(daily_max > 30,1) = 30;
%%% Calculates Growing Degree Days:
GDD = ((daily_max + daily_min)./ 2) - T_base;
GDD_hh = NaN.*ones(length(Ta_in),1);



if length(GDD) == 365 || length(GDD) == 366;
    num_days = length(GDD);
    GDD_daily(:,1) = cumsum(GDD);
    for k = 1:1:length(GDD)
       GDD_hh(k*48-47: k*48,1) = GDD_daily(k,1);
    end
    
elseif length(GDD) > 366
    if isempty(yrs)
    [yrs] = input('Enter Years GDD is being calculated for (e.g. [2003:1:2008] ): ');
    end
    ctr = 1;
for j = 1:1:length(yrs)
    num_days(j) = yr_length(yrs(j))./48;
    GDD_daily(ctr:ctr+num_days(j)-1,1) = cumsum(GDD(ctr:ctr+num_days(j)-1,1));
    for k = 1:1:num_days(j)
       GDD_hh((ctr+k-1)*48-47: (ctr+k-1)*48,1) = GDD_daily(ctr+k-1,1);
    end
    
    
    ctr = ctr+num_days(j);
end
end



%%% Daily values:
% GDD_daily(:,1) = cumsum(GDD);

%%% hhourly values:
% if length(Ta_in) == 17568
%     num_days = 366;
% elseif length(Ta_in) == 17520
%     num_days = 365;
% elseif length(Ta_in) > 17568
%     [yrs] = input('Enter Years being calculated (e.g. [2003:1:2008] ): ');
% for j = 1:1:length(yrs)
%     num_days(j) = yr_length(yrs(j));
% end
% end
% GDD_hh = NaN.*ones(length(Ta_in),1);
% 
% 
% ctr_yr = 0;
% for yr_ctr = 1:1:length(num_days)
% ctr_day = 1;
%     
%     for i = 1:1:num_days(yr_ctr)
%     GDD_hh((ctr_yr+ctr_day)*48 - 47: (ctr_yr+ctr_day)*48,1) = GDD_daily(ctr_yr+ctr_day,1);
%     
%     ctr_day = ctr_day + 1;
%     end
%     
%     ctr_yr = ctr_yr + num_days(yr_ctr);
% end
