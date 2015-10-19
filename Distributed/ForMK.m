% load('/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_data_master.mat')
% This will load a variable 'master'
% If you double click 'master' in the Workspace, it will open a preview.
% Alternatively
% You can find the labels in /1/fielddata/Matlab/Config/Master_Files
sites = {'TP39','TPD'};

out_path = '/1/fielddata/Matlab/Data/Distributed/MK/';

for j = 1:1:length(sites)
    site = sites{j};
    for i = 2014:1:2015
        try
        load(['/1/fielddata/Matlab/Data/Master_Files/' site '/' site '_data_master_' num2str(i) '.mat']);
        % Export the numeric array:
        tmp = master.data;
        csvwrite([out_path site '_data_master_' num2str(i) '.csv'],tmp);
        clear tmp;
                    disp(['Worked for ' num2str(i)]);

        catch
            disp(['Didn''t work for ' num2str(i)]);
        end
    
    end
   copyfile(['/1/fielddata/Matlab/Config/Master_Files/' site '_master_list.csv'], ...
       [out_path site '_master_list.csv']); 
   
%    dos(['cp /1/fielddata/Matlab/Config/Master_Files/' site '_master_list.csv' out_path site '_master_list.csv']) 
end


