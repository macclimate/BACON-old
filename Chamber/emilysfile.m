% % set directory- this plots CO2 conc, H20, Temp
'cd C:\DATA';
 acs_plot_HF('C:\DATA\acs-dc-mcm03\MET-DATA','C:\DATA\acs-dc-mcm03\UBC_FLUX\Matlab\xACS_init_all.txt');
 
% % to recalculate 1 day (no plotting)
 'cd C:\DATA';
 ACS_calc_and_save(datenum(2008,12,16),16,'C:\DATA',1,0);
 
% % % to recalculate for more than one day with no plotting
 'cd C:\DATA';
ACS_calc_and_save(datenum(2008,12,01):datenum(2008,12,18),16,'C:\DATA',1,0);

% % % to recalculate for more than one day with plotting
 'cd C:\DATA';
ACS_calc_and_save(datenum(2008,7,4):datenum(2008,7,31),16,'C:\DATA',1,1);

% %to recalculate 1 day with plotting
 'cd C:\DATA';
ACS_calc_and_save(datenum(2008,8,2),16,'C:\DATA',1,1);

%ACS_DC_primer_UA.m file to process flux data
'cd C:\DATA';
inputPath = 'C:\DATA\hhour\Augtest\';
siteID = '*.ACS_Flux_16.mat'
dirInfo = dir([inputPath siteID]);
HHourAll = [];
N = 0;
for i=1:length(dirInfo)
    if dirInfo(i).isdir == 0
        disp(sprintf('Loading file #%d %s%s',i,inputPath,dirInfo(i).name))        
        load(fullfile(inputPath,dirInfo(i).name))
        % extract only periods that had measurements (every 2 hours)
        for j=1:length(HHour)
            if ~isempty(HHour(j).HhourFileName)
                N = N+1;
                try
                    if N == 1 
                        HHourAll = HHour(j);
                    else
                        HHourAll(N) = HHour(j);            
                    end
                catch
                    N = N - 1;
                end
            end
        end
    end
end
% now extract the time vector
tv = zeros(length(HHourAll),1);
for i=1:length(HHourAll)
    % here we are re-creating time vector from the file name.  The new
    % version of acs_calc_and_save does have a proper field TimeVector but
    % the older version didn't and it also output the wrong end time.
    % Solution below works for both the old and the new version
    fileName = HHourAll(i).HhourFileName;
    tv(i) = datenum(2000+str2num(fileName(1:2)),str2num(fileName(3:4)),str2num(fileName(5:6)), 0,str2num(fileName(7:8))*15,0);
end
%stop highlight here.................
% where is my data?
HHourAll(1)               % shows you the root of the data structure array for the first time period
HHourAll(1).Chamber(3).Sample(2) % shows the second repetition (sample) for the third chamber for the first time period
HHourAll(100).Chamber(2).Sample(1) % shows the first sample for the second chamber 100th time period
HHourAll(100).Configuration  % shows the setup values that apply to the 100th time period

% to extract any trace use get_stats_field function
x = get_stats_field(HHourAll,'Chamber(3).Sample(2).efflux');

% to extract all three samples for the chamber #3:
ch1(:,1) = get_stats_field(HHourAll,'Chamber(3).Sample(1).efflux');
ch1(:,2) = get_stats_field(HHourAll,'Chamber(3).Sample(2).efflux');
ch1(:,3) = get_stats_field(HHourAll,'Chamber(3).Sample(3).efflux');

% plot all three repetitions of the same chamber:
plot(tv,ch1);datetick('x')

% turn the zoom function on
zoom on
