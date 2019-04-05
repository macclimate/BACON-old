function [] = jjb_master2col(year, site, type)
%% jjb_master2col.m
% This script is used to create single column vectors for flux and
% meteorological data from a master yearly column.
% Created July 31, 2007 by JJB


%% Make Sure site and year are in string format
if ischar(site) == false
    site = num2str(site);
end
if ischar(year) == false
    year = num2str(year);
end
%% Declare Paths
m_path = ['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Met' site '\Master\M' site '_' year '_Master.csv'];
out_path = ['C:\Home\Matlab\Data\Flux\OPEC\Organized2\Met' site '\Column\'];
%% Processing
if type == 'csv'

    a = dlmread(m_path,',');
    [rows cols] = size(a)
    
    for j = 1:cols
        bv = a(:,j);
        ext = create_label(j,3);
        save ([out_path 'Met' site '_' year '.' ext], 'bv','-ASCII');
        clear bv ext;
    end

end
