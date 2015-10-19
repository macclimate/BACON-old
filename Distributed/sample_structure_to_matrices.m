% file will load up as 'data'
load('/home/brodeujj/1/fielddata/Matlab/Data/Master_Files/TP39/TP39_AA_analysis_data.mat')
data = trim_data_files(data,2003,2009);

col_numbers = fieldnames(data);
data_matrix = NaN.*ones(length(data.Year),length(col_numbers));

for i = 1:1:length(col_numbers)
   eval(['data_matrix(:,i) = data.' char(col_numbers(i)) ';']); 
    
    
end

for j = 2003:1:2009
    eval(['data_' num2str(j) ' = data_matrix(data_matrix(:,1)==j,:);']);
end