ls = addpath_loadstart;
site = 'TP74';

load([ls 'Matlab/Data/Master_Files/' site '/' site '_data_master.mat']);
clrs = jjb_get_plot_colors;
GEP_cols = (12:3:21);
RE_cols = (13:3:22);
NEE_cols = (14:3:23);
ind = find(master.data(:,1)>=2003 & master.data(:,1)<=2010); 
models = {'FCRN';'ANN';'SS-New';'SS-Old'};
figure(1);clf;figure(2);clf;figure(3);clf;
for i = 1:1:length(GEP_cols)
    figure(1);
    h1(i) = plot(master.data(ind,GEP_cols(i)),'-','Color',clrs(i,:));
    hold on;
        figure(2);
    h2(i) = plot(master.data(ind,RE_cols(i)),'-','Color',clrs(i,:));
    hold on;
        figure(3);
    h3(i) = plot(master.data(ind,NEE_cols(i)),'-','Color',clrs(i,:));
    hold on;
end
figure(1);legend(h1,models);title('GEP');
figure(2);legend(h2,models);title('RE');
figure(3);legend(h3,models);title('NEE');