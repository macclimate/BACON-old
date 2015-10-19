load ('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_SM_analysis_data.mat');



% Trim data files:

data = trim_data_files(data, 2010, 2011,1);


PAR = data.PAR;

PAR_2010 = data.PAR(data.Year==2010);
PAR_2011 = data.PAR(data.Year==2011);

plot(PAR_2010,PAR_2011,'b.');


