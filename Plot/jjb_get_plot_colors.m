function [clrs, guide] = jjb_get_plot_colors

clrs = [11 29 138; ... %   1.  dark Blue
    253 127 26; ... %    2. orange
    213 0 25;   ... %    3. dark red
    192 14 198; ... %    4. purple
    25 191 64; ...  %    5. green
    186 191 200; ...%    6. grey
    36 193 227; ... %    7. light blue
    255 183 176; ...%    8. salmon
    102 73 41;   ...%    9. brown
    255 235 11; ... %    10. yellow
    3 97 19; ...    %    11. forest green
    241 16 249; ... %    12. hot purple
    219 151 32;  ...%    13. Burnt Orange
    45 203 175; ... %    14. Teal 
    234 66 15;  ... %    15. Orangered
    234 130 161 ... %    16. Pink
    ]./255;


guide = {1 'Dark Blue'; 2 'Orange'; 3 'Dark Red';4 'Purple';5 'Green';6 'Grey';7 'Light Blue';8 'Salmon'; ...
    9 'Brown';10 'Yellow';11 'Forest Green';12 'Hot Purple';13 'Burnt Orange';14 'Teal';15 'Orangered';16 'Pink'};