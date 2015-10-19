
% DO NOT RUN THIS PROGRAM!
% This program contains samples of program lines that can be used to
% process, plot and check data from ACS-DC systems.
% Use cut and paste to grab the lines and execute them in the Matlab
% command window.  In same cases you'll need to highlight a group of
% statements (in example below everything between 
% "%---- Start highlight here" and %---- Stop highlight here
% will need to be highlighted using mouse and then executed by pressing F9.

% You'll need to edit this program to correct the data paths.
% Make a backup copy of this file before doing any edits.

% Please read the following comments.

% Copy all the UBC matlab functions including this program 
% into one folder (example c:\ubc)
%
% Start Matlab
% Type "cd c:\ubc" at the Matlab command prompt
% this tells Matlab where the functions are.  There are alternative ways to
% put the functions on the path (type "help path" in Matlab for more help)

% You'll need to change the path name in each of the examples below
% to match the path of your data.
% 

% Make sure that you have a backup of your data before running
% acs_calc_and_save samples below!!!!!  These calculations will
% overwrite the existing *.mat files.  The acs_calc_and_save program that
% is shipped with this file is a newer version of the one that was compiled
% in 2006/2007 so the results will most likely be the same or better (some
% bugs were removed from the previous version).

% (c) Zoran Nesic           File created:       Jan 22, 2008
%                           Last modification:  Jan 22, 2008


%     
% how to plot HF data (raw data plotting)
acs_plot_HF('D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA','D:\Zoran\acs_init_all.txt')


%==========================================================================
% NOTE: acs_calc_and_save commands will overwrite the data in the ...\hhour
% folder (*.mat).  Make sure that you have backups just in case
%==========================================================================

% to recalculate one day (no plotting)
acs_calc_and_save(datenum(2007,9,1),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,0);

% to recalculate many days (no plotting) (Sep 1 - Sep 10)
acs_calc_and_save(datenum(2007,9,1):datenum(2007,9,10),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,0);

% to recalculate one day (with plotting)
% Plotting function is very important for data quality control.  Make sure
% your slopes and line fits are good before using the final data.
acs_calc_and_save(datenum(2007,9,1),16,'D:\Paul_Data\CR_Chambers\ACS_DC\MET-DATA',1,1);

% Once the data is calculated and viewed we can proceed with the processing
% of the final results.

% load all mat files for UA1 (your path will be different! Change before
% running the lines below).  To run multiple lines:
% - highlight them with mouse
% - press F9


%==============================================================
%---- Start highlight here
inputPath = 'E:\Site_DATA\PortableChambers\Data from U of A\20070613\acs-dc01\MET-DATA\hhour\';
siteID = '*.ACS_Flux_UA1.mat'
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


%---- Stop highlight here
%==============================================================



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




    