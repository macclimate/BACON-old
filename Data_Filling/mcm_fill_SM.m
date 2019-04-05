function [SMfill] = mcm_fill_SM(site_list, SM_in)
%%% mcm_fill_SM.m
%%% usage: [SMfill] = mcm_fill_SM(site_list, SM_in)
%%%
%%% Notes: we know that SM_in will contain averaged 30cm values for each
%%% site, and it should be in the order supplied by site_list

for i = 1:1:size(site_list,1)
    site = site_list{i,:};
    disp(['Filling SM for site: ' site]);
    switch site
        case 'TP39'; pref = {'TP39';'TP74';'TP02';'TP89'};
        case 'TP74'; pref = {'TP74';'TP39';'TP02';'TP89'};
        case 'TP89'; pref = {'TP89';'TP39';'TP74';'TP02'};
        case 'TP02'; pref = {'TP02';'TP39';'TP74';'TP89'};
        case 'TPD'; pref = {'TP02';'TP39';'TP74'};
    end
    
    %%% Figure out what order in SM we are going to fill data from:
    for j = 1:1:length(pref)
        try
        order(j,1) = mcm_find_right_col(site_list, pref(j));% find(strcmp(char(pref(j)),char(site_list))==1);
        catch
        end
    end
    %%% Filled data starts as input data:
    SMfill(i).SM30a = SM_in(i).SM30a;
    SMfill(i).SM30b = SM_in(i).SM30b;
    %%% Report the number of gaps for each pit:
    nan(1,1) = length(find(isnan(SMfill(i).SM30a)));
    disp(['Original data for Pit A has ' num2str(nan(1,1)) ' gaps']);
    nan(1,2) = length(find(isnan(SMfill(i).SM30b)));
    disp(['Original data for Pit B has ' num2str(nan(1,2)) ' gaps']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Step 1: Use interpolation to fill gaps as large as 3 data points:
    try SMfill(i).SM30a = jjb_interp_gap(SMfill(i).SM30a); catch; SMfill(i).SM30a = SMfill(i).SM30a; end
    try SMfill(i).SM30b = jjb_interp_gap(SMfill(i).SM30b); catch; SMfill(i).SM30a = SMfill(i).SM30a; end
    % Report numbers missing now:
    nan(2,1) = length(find(isnan(SMfill(i).SM30a)));
    disp(['After Interp, Pit A has ' num2str(nan(2,1)) ' gaps']);
    nan(2,2) = length(find(isnan(SMfill(i).SM30b)));
    disp(['After Interp, Pit B has ' num2str(nan(2,2)) ' gaps']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Step 2: Fill first from one pit to another (from same site), and then
    %%% from the other sites, using a linear regression to correct for offsets
    
    for j = 1:1:length(order)
        
        %%% Fill within same site, different pits:
        if i == order(j,1) % Case where we're filling back on same site:
            [coeff_SM30a tmp_est_SM30a] = est_regress(SMfill(order(j,1)).SM30b, SMfill(i).SM30a);
            [coeff_SM30b tmp_est_SM30b] = est_regress(SMfill(order(j,1)).SM30a, SMfill(i).SM30b);
            %%% Fill Pit A with estimated from Pit B (if slope is OK):
            if coeff_SM30a(2,1) > 0.59 && coeff_SM30a(2,1) < 1.5
                SMfill(i).SM30a(isnan(SMfill(i).SM30a),1) = tmp_est_SM30a(isnan(SMfill(i).SM30a),1);
            else
                disp('Slope is bad for filling pit A with pit B. Not using.');
                SMfill(i).SM30a = SMfill(i).SM30a;
            end
            %%% Fill Pit B with estimated from Pit A (if slope is OK):
            if coeff_SM30b(2,1) > 0.59 && coeff_SM30b(2,1) < 1.5
                SMfill(i).SM30b(isnan(SMfill(i).SM30b),1) = tmp_est_SM30b(isnan(SMfill(i).SM30b),1);
            else
                disp('Slope is bad for filling pit B with pit A. Not using.');
                SMfill(i).SM30b = SMfill(i).SM30b;
            end
            % Report numbers missing now:
            nan(3,1) = length(find(isnan(SMfill(i).SM30a)));
            disp(['After fill from Pit B, Pit A has ' num2str(nan(3,1)) ' gaps']);
            nan(3,2) = length(find(isnan(SMfill(i).SM30b)));
            disp(['After fill from Pit A, Pit B has ' num2str(nan(3,2)) ' gaps']);
            
        else
            %%% Fill from other sites:
            %%% Fill Pit A:
            [coeff_SM30a1 tmp_est_SM30a1] = est_regress(SM_in(order(j,1)).SM30a,SMfill(i).SM30a);
            [coeff_SM30a2 tmp_est_SM30a2] = est_regress(SM_in(order(j,1)).SM30b, SMfill(i).SM30a);
            if coeff_SM30a1(2,1) > 0.59 && coeff_SM30a1(2,1) < 1.5
                SMfill(i).SM30a(isnan(SMfill(i).SM30a),1) = tmp_est_SM30a1(isnan(SMfill(i).SM30a),1);
            else
                SMfill(i).SM30a = SMfill(i).SM30a;
            end
            if coeff_SM30a2(2,1) > 0.59 && coeff_SM30a2(2,1) < 1.5
                SMfill(i).SM30a(isnan(SMfill(i).SM30a),1) = tmp_est_SM30a2(isnan(SMfill(i).SM30a),1);
            else
                SMfill(i).SM30a = SMfill(i).SM30a;
            end
            
            %%% Fill Pit B:
            [coeff_SM30b1 tmp_est_SM30b1] = est_regress(SM_in(order(j,1)).SM30a, SMfill(i).SM30b);
            [coeff_SM30b2 tmp_est_SM30b2] = est_regress(SM_in(order(j,1)).SM30b, SMfill(i).SM30b);
            if coeff_SM30b1(2,1) > 0.59 && coeff_SM30b1(2,1) < 1.5
                SMfill(i).SM30b(isnan(SMfill(i).SM30b),1) = tmp_est_SM30b1(isnan(SMfill(i).SM30b),1);
            else
                SMfill(i).SM30b = SMfill(i).SM30b;
            end
            if coeff_SM30b2(2,1) > 0.59 && coeff_SM30b2(2,1) < 1.5
                SMfill(i).SM30b(isnan(SMfill(i).SM30b),1) = tmp_est_SM30b2(isnan(SMfill(i).SM30b),1);
            else
                SMfill(i).SM30b = SMfill(i).SM30b;
            end
        end
    end
    
    ind = find(isnan(SMfill(i).SM30a(1:10)));
    if ~isempty(ind)
        fill_in = find(~isnan(SMfill(i).SM30a),1,'first');
        if ~isempty(fill_in)
        SMfill(i).SM30a(ind,1) = SMfill(i).SM30a(fill_in,1);
        end
        clear ind fill_in;
    end
    ind = find(isnan(SMfill(i).SM30b(1:10)));
    if ~isempty(ind)
        fill_in = find(~isnan(SMfill(i).SM30b),1,'first');
        if ~isempty(fill_in)
        SMfill(i).SM30b(ind,1) = SMfill(i).SM30b(fill_in,1);
        end
        clear ind fill_in;
    end
    
    % Report numbers missing now:
    nan(4,1) = length(find(isnan(SMfill(i).SM30a)));
    disp(['After filling from other sites, Pit A has ' num2str(nan(4,1)) ' gaps']);
    nan(4,2) = length(find(isnan(SMfill(i).SM30b)));
    disp(['After filling from other sites, Pit B has ' num2str(nan(4,2)) ' gaps']);
      
end
end
%%%%%%%%%%%%%%%%%%%%%% END OF FUNCTION %%%%%%%%%%%%%%%%%%%%
    function [coeff est_out] = est_regress(x, y)
        % x is the variable that you are trying to fill,
        % y is the variable that you are trying to fill from.
        ind_good_data = find(~isnan(x)& ~isnan(y));
        M_SM = [ones(length(ind_good_data),1), x(ind_good_data,1)];
        coeff = M_SM\y(ind_good_data,1); % first is intercept, second is slope
        est_out = coeff(1) + x.*coeff(2);
    end
