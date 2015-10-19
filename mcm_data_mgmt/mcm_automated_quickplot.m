function [] = mcm_automated_quickplot()


% - loads the mcm_mgmt_ini file
% - figures out what sites and data types to process (only want met, CPEC,
% sapflow, trenched and OTT)
% - goes through each site, auto-runs metclean and fluxclean (as needed)
% - runs quickplot function, and then zips the output and mails it off.

ini = mcm_mgmt_ini;

