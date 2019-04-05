% This script prepared data to be distributed to the fish hatchery people
clear all
close all
loadstart = addpath_loadstart;
year = 2008;
[Year, JD, HHMM, dt] = jjb_makedate(2008, 30);
[Mon Day] = make_Mon_Day(2008, 30);

% load PPT data:
PPT = load([loadstart 'Matlab/Data/Met/Final_Filled/TP_PPT/TP_PPT_2008_UTC.dat']);
PAR = load([loadstart 'Matlab/Data/Met/Final_Filled/TP39/TP39_2008.PAR']);
Ta = load([loadstart 'Matlab/Data/Met/Final_Filled/TP39/TP39_2008.Ta']);
RH = load([loadstart 'Matlab/Data/Met/Final_Filled/TP39/TP39_2008.RH']);
WS = load([loadstart 'Matlab/Data/Met/Final_Filled/TP39/TP39_2008.WS']);

Final = [Year JD Mon Day HHMM PPT Ta RH PAR WS];
[rows cols] = size(Final);
Final_EST = [Final(1:end,1:5) [Final(11:end,6:cols); NaN.*ones(10,cols-6+1)]];


A(1,1)  = cellstr('Year'); A(2,1)  = cellstr('JD'); A(3,1)  = cellstr('Month'); 
A(4,1)  = cellstr('Day'); A(5,1)  = cellstr('HHMM'); A(6,1)  = cellstr('PPT'); 
A(7,1)  = cellstr('Ta'); A(8,1)  = cellstr('RH'); A(9,1)  = cellstr('PAR'); 
A(10,1)  = cellstr('WS'); 
AA = char(A);
format_code = '\n %4.0f\t %3.0f\t %2.0f\t %2.0f\t %4.0f\t %4.2f\t %3.1f\t %4.1f\t %5.1f\t %4.2f\t';

Preamble(1,1) =cellstr(['Fish Hatchery and TP39 half-hourly data for year: ' num2str(year)]);
Preamble(2,1) =cellstr('All variables are listed in EST timecode (GMT-5)');
Preamble(3,1) =cellstr('Variable Explanation: ');
Preamble(4,1) =cellstr('col 1: Year ');
Preamble(5,1) =cellstr('col 2: JD ');
Preamble(6,1) =cellstr('col 3: Month ');
Preamble(7,1) =cellstr('col 4: Day ');
Preamble(8,1) =cellstr('col 5: HHMM - 24hr daily clock');
Preamble(9,1) =cellstr('col 6: PPT - half hourly precipitation accumulation (mm) at Fish Hatchery');
Preamble(10,1) =cellstr('col 7: Ta - 1/2 hour average air temperature at 28m height at TP39 station');
Preamble(11,1) =cellstr('col 8: RH - 1/2 hour average relative humidity at 28m height at TP39 station');
Preamble(12,1) =cellstr('col 9: PAR - 1/2 hour average downwelling photosyntheically active radiation (sunshine) at 28m height at TP39 station');
Preamble(13,1) =cellstr('col 10: WS - 1/2 hour Windspeed at 28m height at TP39 station');
Preamble(14,1) =cellstr('Data is property of McMaster University, Climate Change Research Group');
Preamble(15,1) =cellstr('For further inquiries, please contact Dr. Altaf Arain: 905-525-9140 ext. 27941');
Preamble(16,1) = cellstr(' ');

Pre_char = char(Preamble);

fid = fopen([loadstart 'Matlab/Data/Distributed/For_FH_2008.dat'],'w');


for i = 1:1:length(Preamble)
    h3 = fprintf(fid,'%117s\n',Pre_char(i,:));
end


for j = 1:1:length(A)
h = fprintf(fid, '%6s\t' , AA(j,:) );
end


for j = 1:1:length(Year)
    h2 = fprintf(fid,format_code,Final_EST(j,:));
end


fclose(fid)