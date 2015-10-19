function [SM_adj] = mcm_adjust_SM(site, pit_ID, SM_in, SM_flag)
%%% mcm_adjust_SM.m
%%% usage: [SM_adj] = mcm_adjust_SM(site, SM_in, SM_flag)
%%% This function is used to moderate 30-cm averages predicted for any of
%%% the TPFS sites (more may be added).  Problems with averages arise when
%%% data from only selected depths are used to estimate the average soil
%%% moisture -- usually it leads to overestimation.  This function fixes
%%% these overestimations based on empirical slope values calculated on 7
%%% years of SM data (2003--2009)
%%% Created July 30, 2010 by JJB.
if pit_ID == 1 || pit_ID == 'a'
    pit_ID = 'A';
elseif pit_ID == 2 || pit_ID == 'b'
    pit_ID = 'B';
end

SM_adj = SM_in;
%%% The coefficients (slopes) for cases where 5cm is missing and 10cm is
%%% missing, respectively.  If both 5 and 10 are missing, that observation
%%% will be made NaN.
switch site
    case 'TP39'
        a_divs = [1.44 1.42];
        b_divs = [1.44 1.6];
    case 'TP74'
        a_divs = [1.76 1.53];
        b_divs = [1.67 1.6];
    case 'TP89' % These need to be added!!!!!
        a_divs = [1 1];
        b_divs = [1 1];
    case 'TP02'
        a_divs = [1.31 1.24];
        b_divs = [1.29 1.23];
    case 'TPD'
        a_divs = [1 1];
        b_divs = [1 1];        
    otherwise
        disp('function not set up for this site');
end

switch pit_ID
    case 'A'
        divs = a_divs;
    case 'B'
        divs = b_divs;
    otherwise
        disp('error with pit_ID');
end

SM_adj(SM_flag==0111) = SM_adj(SM_flag==0111)./divs(1,1);
SM_adj(SM_flag==1011) = SM_adj(SM_flag==1011)./divs(1,2);
SM_adj(SM_flag<100) = NaN;
