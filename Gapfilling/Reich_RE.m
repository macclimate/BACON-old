function [RE_short RE_long fR] = Reich_RE(RE_in, Ts_in, year_in, plot_flag, costfun, NEE_std)
%%% Note: RE_short and RE_long are PREDICTED values -- not filled.
%%%
if plot_flag == 1
else
    fR = [];
end

if isempty(NEE_std)==1
    NEE_std = ones(length(RE_in),1);
end

yr_str = num2str(year_in);
options.min_method ='NM'; options.f_coeff = [];options.costfun = costfun;

win_size = round(15*48/2); % 15 days of hhours (divided by 2 to make one-sided)
incr = (5*48); % increment by 5 days
% len_data = yr_length(year,30);
% Wrap the variables around so we can start interval centre on the start of
% the data:
wrap_RE = [RE_in(end-win_size+1:end,1); RE_in; RE_in(1:win_size,1)];
wrap_Ts = [Ts_in(end-win_size+1:end,1); Ts_in; Ts_in(1:win_size,1)];
wrap_NEE_std = [NEE_std(end-win_size+1:end,1); NEE_std; NEE_std(1:win_size,1)];
% Set the centres for windows:
centres = (1:incr:length(RE_in))';
if centres(end) < length(RE_in); centres = [centres; length(RE_in)]; end
centres = centres + win_size;
% RE_pred = NaN.*ones(length(wrap_RE),1);
%% Step 1a: Windowed Parameterization for Eo (Eo_short):
for i = 1:1:length(centres)
%     if i == 75;
%         disp('hold')
%     end
    try
        RE_temp = wrap_RE(centres(i)-win_size:centres(i)+win_size);
        Ts_temp = wrap_Ts(centres(i)-win_size:centres(i)+win_size);
        NEE_std_temp = wrap_NEE_std(centres(i)-win_size:centres(i)+win_size);
        ind_use = find(~isnan(RE_temp.*NEE_std_temp));
        RE_use = RE_temp(ind_use);
        Ts_use = Ts_temp(ind_use);
        NEE_std_use = NEE_std_temp(ind_use);
        num_pts(i,1) = length(RE_use);
        if num_pts(i,1) < 20
            c_hat_RE(i,1:2) = NaN;
            stats_RE(i,1:2) = NaN;
            rel_error_RE(i,1) = NaN;
        elseif (max(Ts_use) - min(Ts_use)) < 4
            c_hat_RE(i,1:2) = NaN;
            stats_RE(i,1:2) = NaN;
            rel_error_RE(i,1) = NaN;
            
        else
            clear global;
            % Run parameterization, gather c_hat values:
            [c_hat_RE(i,:), y_hat(i).RE, y_pred(i).RE, stats(i).RE, sigma(i).RE, err(i).RE, exitflag(i).RE, num_iter(i).RE] = ...
                fitresp([10 100], 'fitresp_1C', Ts_use , RE_use, wrap_Ts(centres(i)-win_size:centres(i)+win_size),NEE_std_use, options);
            % gather stats:
            stats_RE(i,1:2) = [stats(i).RE.rRMSE stats(i).RE.MAE];
            rel_error_RE(i,1) = std(y_pred(i).RE)./nanmean(y_pred(i).RE);
        end
    catch
        disp(i);
    end
    %     RE_pred(centres(i)-win_size:centres(i)+win_size) = y_pred(i).RE;
end

%% Step 1b: All-year parametization for Eo (Eo_long):
RE_param = RE_in(~isnan(RE_in.*NEE_std));
Ts_param = Ts_in(~isnan(RE_in.*NEE_std));
NEE_param = NEE_std(~isnan(RE_in.*NEE_std));
% Run parameterization, gather c_hat values:
clear global;
[c_hat_RE_all, y_hat_RE_all, y_pred_RE_all, stats_RE_all, sigma_RE_all, err_RE_all, exitflag_RE_all, num_iter_RE_all] = ...
    fitresp([10 100], 'fitresp_1C', Ts_param , RE_param, Ts_in,NEE_param, options);

%% Step 2: Select the proper value of Eo_short:
%%% Filter out to use only good periods (Eo 0-450, rel error < %50)
ind_use_Eo = find(c_hat_RE(:,2) > 0 & c_hat_RE(:,2) < 450 & rel_error_RE < 0.5);
Eo_use = c_hat_RE(ind_use_Eo,2);
error_use = rel_error_RE(ind_use_Eo);
stats_use = stats_RE(ind_use_Eo,:);
%%% Approach 1: Use the 3 periods with the smallest relative root mean
%%% square error (rRMSE).  Changed from relative error.
[sort_error ind_sort_error] = sort(stats_use(:,1),'ascend');
try
    Eo_short1 = mean(Eo_use(ind_sort_error(1:3)));
catch
    Eo_short1 = NaN;
end
%%% Approach 2: Use all periods, but weight by the relative error:
% tot_error = sum(rel_error_RE(ind_use_Eo));
weight1 = (1./error_use)./(sum(1./error_use)); % weight using rel error
weight2 = (1./stats_use(:,1))./(sum(1./stats_use(:,1))); % weight using rRMSE
Eo_short2a = sum(Eo_use.*weight1);
Eo_short2b = sum(Eo_use.*weight2);

disp(['Eo_short1 = ' num2str(Eo_short1)]);
disp(['Eo_short2a = ' num2str(Eo_short2a)]);
disp(['Eo_short2b = ' num2str(Eo_short2b)]);

%%% Select values for Eo short and long
Eo_short = Eo_short2b;
Eo_long = c_hat_RE_all(1,2);

if plot_flag == 1;
%%% Plot results for Eo:
fR(1) = figure(1);clf;
plot(centres(ind_use_Eo,1),Eo_use(:,1),'.-'); hold on;
plot([1 centres(end)], [Eo_long Eo_long],'r--');
plot([1 centres(end)], [Eo_short Eo_short],'g--');
legend('E_{0,used}','E_{0,long}', 'E_{0,short}');
title(['Year = ' yr_str '; E_{0} estimates']);
set(gca, 'FontSize', 14);

fR(2) = figure(2);clf;
[AX h1 h2] = plotyy((1:1:length(Ts_in)),Ts_in, (1:1:length(Ts_in)), y_pred_RE_all,@line, @line);hold on;
set(get(AX(2),'YLabel'), 'String','Re','FontSize', 16,'Color', [0 0.6 0])
set(get(AX(1),'YLabel'), 'String','Ts','FontSize', 16, 'Color','b')
% Set y ticks and labels:
set(AX(2),'YTick', [0:5:15]', 'YTickLabel',{'0';'5';'10';'15'},'FontSize',16)
set(AX(1),'YTick', [-5:10:25]', 'YTickLabel',{'-5';'5';'15';'25'},'FontSize',16)
set(AX(1),'XLim',[1 length(Ts_in)],'YLim',[-5 25])
set(AX(2),'XLim',[1 length(Ts_in)])
title(['Year = ' yr_str '; RE (all year) & Ts']);
set(AX(2), 'FontSize', 14);
set(AX(1), 'FontSize', 14);
end
% disp('Eo done');

%% Step 3: Windowed parameterization for Rref, using Eo_short and Eo_long:
%%% Instead of using strict 4 day window (like in Richardson), use a total
%%% of 100 available data points, and place that value of Rref at the arithmetic m
%%% mean of the data points index value:
win_size2 = 100;
incr2 = 25;
ind_use = find(~isnan(RE_in.*NEE_std));
%%% Wrap the data:
RE_wrap2 = [RE_in(ind_use(end-(win_size2/2 -1):end),1); RE_in(ind_use); RE_in(ind_use(1:win_size2/2),1)];
Ts_wrap2 = [Ts_in(ind_use(end-(win_size2/2 -1):end),1); Ts_in(ind_use); Ts_in(ind_use(1:win_size2/2),1)];
NEE_std_wrap2 = [NEE_std(ind_use(end-(win_size2/2 -1):end),1); NEE_std(ind_use); NEE_std(ind_use(1:win_size2/2),1)];
ind_wrap2 = [ind_use(end-(win_size2/2 -1):end,1)-length(RE_in); ind_use; ind_use(1:win_size2/2,1)+length(RE_in)];

st_pts = (1:incr2:length(ind_wrap2)- win_size2)';

for j = 1:1:length(st_pts)
    RE_temp = RE_wrap2(st_pts(j):st_pts(j)+win_size2-1,1);
    Ts_temp = Ts_wrap2(st_pts(j):st_pts(j)+win_size2-1,1);
    ind_temp = ind_wrap2(st_pts(j):st_pts(j)+win_size2-1,1);
    NEE_std_temp = NEE_std_wrap2(st_pts(j):st_pts(j)+win_size2-1,1);
    
    data_centre(j,1) = round(mean(ind_temp));
    % Run Rref parameterization for Eo_long:
    clear global;
    options.f_coeff = [NaN, Eo_long];
    [c_hat_Rref_long(j,:), y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = ...
        fitresp([10 Eo_long], 'fitresp_1C', Ts_temp , RE_temp, Ts_temp,NEE_std_temp, options);
    stats_Rref_long(j,1:2) = [stats.rRMSE stats.MAE];
    % Run Rref parameterization for Eo_short:
    clear stats global;
    options.f_coeff = [NaN, Eo_short];
    [c_hat_Rref_short(j,:), y_hat, y_pred, stats, sigma, err, exitflag, num_iter] = ...
        fitresp([10 Eo_short], 'fitresp_1C', Ts_temp , RE_temp, Ts_temp,NEE_std_temp, options);
    stats_Rref_short(j,1:2) = [stats.rRMSE stats.MAE];
    clear stats global;
end
%%% Can we linearly interpolate the values in between?
xi = (1:1:length(RE_in))';
first_Rref_long = c_hat_Rref_long(find(~isnan(c_hat_Rref_long),1,'first'),1);
Rref_long_interp = interp1(data_centre,c_hat_Rref_long(:,1),xi,'linear',first_Rref_long);
first_Rref_short = c_hat_Rref_short(find(~isnan(c_hat_Rref_short),1,'first'),1);
Rref_short_interp = interp1(data_centre,c_hat_Rref_short(:,1),xi,'linear',first_Rref_short);

if plot_flag == 1;
fR(3) = figure(3);clf;
plot(data_centre,c_hat_Rref_long(:,1),'bo');hold on;
f4(1) = plot(xi, Rref_long_interp,'b--');
plot(data_centre,c_hat_Rref_short(:,1),'ro');hold on;
f4(2) = plot(xi, Rref_short_interp,'r--');
legend(f4,'Rref_{Eo,long}', 'Rref_{Eo,short}');
title(['Year = ' yr_str '; Rref']);
set(gca, 'FontSize', 14);
end
% tic;
%%% Step 4: Evaluate each set of parameters to get estimates of RE:
RE_long = NaN.*ones(length(RE_in),1);
RE_short = NaN.*ones(length(RE_in),1);
for k = 1:1:length(RE_in)
    RE_long(k,1) = fitresp_1C([Rref_long_interp(k,1) Eo_long],Ts_in(k,1));
    RE_short(k,1) = fitresp_1C([Rref_short_interp(k,1) Eo_short],Ts_in(k,1));
end
% t = toc
%%% Plot both estimates:
if plot_flag == 1;
fR(4) = figure(4);clf;
[AX h1 h2] = plotyy((1:1:length(Ts_in)),RE_long, (1:1:length(Ts_in)), RE_short,@line, @line);hold on;
set(get(AX(2),'YLabel'), 'String','RE_{short}','FontSize', 16,'Color', [0 0.6 0])
set(get(AX(1),'YLabel'), 'String','RE_{long}','FontSize', 16, 'Color','b')
% Set y ticks and labels:
% set(AX(2),'YTick', [0:5:15]', 'YTickLabel',{'0';'5';'10';'15'},'FontSize',16)
% set(AX(1),'YTick', [0:5:15]',
% 'YTickLabel',{'0';'5';'10';'15'},'FontSize',16)
set(AX(1),'YTick', [0:2:16]', 'YTickLabel',{0:2:16},'FontSize',16)
set(AX(2),'YTick', [0:2:16]', 'YTickLabel',{0:2:16},'FontSize',16)
set(AX(1),'XLim',[1 length(Ts_in)],'YLim',[0 12])
set(AX(2),'XLim',[1 length(Ts_in)],'YLim',[0 12])
title(['Year = ' yr_str '; Estimates RE']);
set(AX(2), 'FontSize', 14);
set(AX(1), 'FontSize', 14);
end
end