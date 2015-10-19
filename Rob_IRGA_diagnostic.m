load_path = '/home0/arainlab/Desktop/Debugging_biomet/';

load([load_path 'csat_07050848.mat']);
load([load_path 'irga_07050848.mat']);

w =  csat.align(:,3); % w data is column 3
c = irga.align(:,1); % CO2 data is column 1

wc_before = cov(w,c);

x = 1.0185;
b = 3.0591;

c1 = c*x-b;


%%%%

path_to_data = '/1/fielddata/SiteData/TP39/MET-DATA/data/';
day_to_load = '101019/';
hhour_to_load = '10101976.';
%%% Load files:
[csat_data csat_header] = fr_read_Digital2_file([path_to_data day_to_load hhour_to_load 'DMCM5']);
[irga_data irga_header] = fr_read_Digital2_file([path_to_data day_to_load hhour_to_load 'DMCM4']);
%%% Make sure each file is the same length:
min_length = min(length(csat_data), length(irga_data));
w = csat_data(1:min_length,3);
c = irga_data(1:min_length,1);

wc_before = cov(w,c);

x = 1.0185;
b = 3.0591;

c1 = c*x-b;

wc_after = cov(w,c1);


