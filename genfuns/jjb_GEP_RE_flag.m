function [RE_flag GEP_flag] = jjb_GEP_RE_flag(site, PAR, dt, Ts5, Ts2, Ta, GDD,Year)
% jjb_GEP_RE_flag.m
% usage: jjb_GEP_RE_flag(PAR, dt, Ts5, Ta, GDD)
%%% This function returns flags indicating the presence of respiration
%%% and/or photosynthesis in a given half-hour, and whether this data point
%%% should be used to parameterize either of the models.
%%% Flag meanings:
% 0 = do not model or parameterize for RE/GEP at this data point
% 1 = model only (do use this point to parameterize)
% 2 = model and parameterize with this point.
%%% So, anything that has a flag ==2 will be used to parameterize, while
%%% anything >0 will be used to model.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Commented out on April 21, 2011 by JJB, in favour of new
%%%%  formulation:
% RE_flag = ones(length(PAR),1);
% GEP_flag = NaN.*ones(length(PAR),1);
% ind_GEP = find(PAR >= 15 & ((dt > 85 & dt < 330 & (GDD > 8 | Ts5 >= 1 & Ta > 2)) ...
%     | dt > 330 & Ts5 >= 1.25 & Ta > 2));
%
% RE_flag(ind_GEP) = NaN;
% GEP_flag(ind_GEP) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Formulation #2 -- Much simpler formulation, based on Ta and Ts:
RE_flag = ones(length(PAR),1);
GEP_flag = zeros(length(PAR),1);
%%% Flags will now be either 0, 1 or 2.
% 0 = do not model or parameterize for RE/GEP at this data point
% 1 = model only (do use this point to parameterize)
% 2 = model and parameterize with this point.
%%% So, anything that has a flag ==2 will be used to parameterize, while
%%% anything >0 will be used to model.

%%% Step 1: Photosynthesis
% Get cumulative Temperature:
cum_Ta = NaN.*ones(length(Ta),1);
ind_newyrs = find(dt < 1.03);
ind_newyrs = [ind_newyrs; length(Ta)+1];
for j = 1:1:length(ind_newyrs)-1
    Ta_tmp = Ta(ind_newyrs(j):ind_newyrs(j+1)-1);
    Ta_tmp(1:3000) = NaN; % changed from Ta_tmp(1:3500) = NaN;
    Ta_tmp(Ta_tmp<5)= 0;
    cum_Ta(ind_newyrs(j):ind_newyrs(j+1)-1,1) = nancumsum(Ta_tmp);
end

switch site
    case 'TP39'
        ind_GEP_param = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 & ((cum_Ta>1400 & Ts5 > 0.5)| cum_Ta > 2000) ) | (dt>=200 & dt<340 & Ts5>2 & Ta > 2)));
        ind_GEP_model = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 &( (cum_Ta>800 & (Ts5 > 0.5 | Ta > 5))| (cum_Ta > 1500) ) ) | (dt>=200 & dt< 350 & Ts5>2 & Ta > 0)  ));
    case 'TP74'
        ind_GEP_param = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 & ((cum_Ta>1000 & Ts5 > 0.5)| cum_Ta > 1500) ) | (dt>=200 & dt<340 & Ts5>2 & Ta > 2)));
        ind_GEP_model = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 &( (cum_Ta>800 & (Ts5 > 0.5 | Ta > 5))| (cum_Ta > 1500) ) ) | (dt>=200 & dt< 350 & Ts5>1 & Ta > -1)  ));
    case 'TP89'
        ind_GEP_param = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 & ((cum_Ta>1400 & Ts5 > 0.5)| cum_Ta > 2000) ) | (dt>=200 & dt<340 & Ts5>2 & Ta > 2)));
        ind_GEP_model = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 &( (cum_Ta>800 & (Ts5 > 0.5 | Ta > 5))| (cum_Ta > 1500) ) ) | (dt>=200 & Ts5>2 & Ta > 0)  ));
    case 'TP02'
        ind_GEP_param = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 & ((cum_Ta>1000 & Ts5 > 0.5)| cum_Ta > 1500) ) | (dt>=200 & dt<340 & Ts5>1.5 & Ta > 1.5)));
        ind_GEP_model = find(PAR>=15 & ((dt>65 & dt<=200 & Ta > 1 &( (cum_Ta>800 & (Ts5 > 0.5 | Ta > 5))| (cum_Ta > 1500) ) ) | (dt>=200 & Ts5>0.5 & Ta > -2)  ));
    case 'TPD'
        for i = min(Year):1:max(Year)
            [gs_params] = params(i, 'TPD', 'GS_Dates'); % [gs_start gs_end];
            %         ind_GEP_param(Year==i) = find(PAR>=15 & (dt>gs_params(1) & dt<=gs_params(2)));
            %         ind_GEP_model(Year==i) = find(PAR>=15 & (dt>gs_params(1) & dt<=gs_params(2)));
            ind_GEP_param_tmp = find(PAR>=15 & Year == i & (dt>gs_params(1) & dt<=gs_params(2)));
            ind_GEP_model_tmp = find(PAR>=15 & Year == i & (dt>gs_params(1) & dt<=gs_params(2)));
            ind_GEP_param = [ind_GEP_param; ind_GEP_param_tmp];
            ind_GEP_model = [ind_GEP_model; ind_GEP_model_tmp];
        end
end
GEP_flag(ind_GEP_model) = 1;
GEP_flag(ind_GEP_param) = 2;

%%% Step 2: Respiration
ind_RE = find(GEP_flag == 0 & ((PAR < 15) | ... % all night time (growing and non-growing periods)
    (PAR > 15 & (Ts5 < 2 & Ta < 0) | (Ts5 < 0.5 & Ta < 0))) ); % covers daytime during non-growing periods
RE_flag(ind_RE) = 2;