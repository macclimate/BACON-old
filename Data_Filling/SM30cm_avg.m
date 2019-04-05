function [SM_avg use_flag] = SM30cm_avg(SM5, SM10, SM20, SM50)
% SM30cm_avg - averages soil moisture inputs from 4 probes at depth in a
% soil profile, and obtains a 30cm (root zone) average for these.
% Edited June 1, 2010 by jjb to include 'use_flag' - a vector of 0 or 1 to
% indicate whether or not both 5 and 10cm SM data was present (1), or if
% one was missing (0), or if all depths are present (2).

SM_avg = NaN.*ones(length(SM5),1);
use_flag = 1111.*ones(length(SM5),1);
use_flag(isnan(SM5),1) = use_flag(isnan(SM5),1)     - 1000;
use_flag(isnan(SM10),1) = use_flag(isnan(SM10),1)   - 100;
use_flag(isnan(SM20),1) = use_flag(isnan(SM20),1)   - 10;
use_flag(isnan(SM50),1) = use_flag(isnan(SM50),1)   - 1;

%%% estimate value at 30cm:
SM30(:,1) = (((SM50 - SM20)./30).*10)+SM20;
SM15(:,1) = mean([SM10'; SM20']);
SM25(:,1) = mean([SM20'; SM30']);
SM7p5(:,1) = mean([SM5'; SM10']);
SM12p5(:,1) = mean([SM5'; SM20']);
SM17p5(:,1) = mean([SM5'; SM30']);
SM20(:,1) = mean([SM10'; SM30']);

SM_depths = [5 7.5 10 12.5 15 17.5 20 25];
SM_all = [SM5 SM7p5 SM10 SM12p5 SM15 SM17p5 SM20 SM25];
SM_list = [~isnan(SM5) ~isnan(SM7p5) ~isnan(SM10) ~isnan(SM12p5) ~isnan(SM15) ~isnan(SM17p5) ~isnan(SM20) ~isnan(SM25)];

for i = 1:1:length(SM_avg)
    good_cols = find(SM_list(i,:)==1);
    if length(good_cols) > 2
        wt(1) = SM_depths(good_cols(1)) + (SM_depths(good_cols(2)) - SM_depths(good_cols(1)))./2;
        for k = 2:1:length(good_cols)-1
            wt(k) = (SM_depths(good_cols(k)) - SM_depths(good_cols(k-1)))./2 + (SM_depths(good_cols(k+1)) - SM_depths(good_cols(k)))./2;
        end
        wt(k+1) = (30- SM_depths(k+1)) + (SM_depths(good_cols(k+1)) - SM_depths(good_cols(k)))./2;
        wt = wt./30;

        SM_avg(i,1) = sum(SM_all(i,good_cols).*wt);
        clear wt good_cols;

    else
        SM_avg(i,1) = NaN;
    end

end
