%ACS_DC_primer_UA.m file to process flux data
'cd C:\DATA';
inputPath = 'C:\DATA\hhour\HHourAll\';
siteID = '*.ACS_Flux_16.mat'
dirInfo = dir([inputPath siteID]);
HHourAll = [];
N = 0;
ctr = 0;
for i=1:length(dirInfo)
    if dirInfo(i).isdir == 0
        disp(sprintf('Loading file #%d %s%s',i,inputPath,dirInfo(i).name))
        load(fullfile(inputPath,dirInfo(i).name))
        % extract only periods that had measurements (every 2 hours)
        for j=1:length(HHour)
            if ~isempty(HHour(j).HhourFileName)
                N = N+1;
                ctr = ctr + 1;
                try
                    if N == 1
                        HHourAll = HHour(j);
                    else
                        HHourAll(ctr) = HHour(j);
                    end
%                     data2(N,1) = HHour(j).TimeVector;
                    col = 2;
                    for chamber_ctr = 1:1:4
                        for sample_ctr = 1:1:3
                            tmp1(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.avg;
                            tmp2(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.min;
                            tmp3(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.max;
                            tmp4(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).Channel.co2.std;
                            tmp5(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).airTemperature;
                            tmp6(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).airPressure;
                            tmp7(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).dcdt;
                            tmp8(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).rsquare;
                            tmp9(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).rmse;
                            tmp10(sample_ctr,1) = HHour(j).Chamber(chamber_ctr).Sample(sample_ctr).efflux;           
                        end
                        data2(N,1) = HHour(j).TimeVector;
                        data2(N,(((chamber_ctr-1).*10)+2)) = nanmean(tmp1);
                        data2(N,(((chamber_ctr-1).*10)+3)) = nanmean(tmp2);
                        data2(N,(((chamber_ctr-1).*10)+4)) = nanmean(tmp3);
                        data2(N,(((chamber_ctr-1).*10)+5)) = nanmean(tmp4);
                        data2(N,(((chamber_ctr-1).*10)+6)) = nanmean(tmp5);
                        data2(N,(((chamber_ctr-1).*10)+7)) = nanmean(tmp6);
                        data2(N,(((chamber_ctr-1).*10)+8)) = nanmean(tmp7);
                        data2(N,(((chamber_ctr-1).*10)+9)) = nanmean(tmp8);
                        data2(N,(((chamber_ctr-1).*10)+10)) = nanmean(tmp9);
                        data2(N,(((chamber_ctr-1).*10)+11)) = nanmean(tmp10);
                        clear tmp*
                    end
%                     tv(N) = HHour(j).TimeVector;
%                     Data_ch1(N,1:x) = [HHour(j).Chamber(1)]
% 
%                     Data(N).TimeVector = HHour(j).TimeVector;
%                     Data(N).Chamber = HHour(j).Chamber;
                catch
                    N = N - 1;
                end
            end
        end
        clear HHourAll ;
        ctr = 0;
    end
end
% now extract the time vector
% tv = zeros(length(HHourAll),1);
% for i=1:length(HHourAll)
%     % here we are re-creating time vector from the file name.  The new
%     % version of acs_calc_and_save does have a proper field TimeVector but
%     % the older version didn't and it also output the wrong end time.
%     % Solution below works for both the old and the new version
%     fileName = HHourAll(i).HhourFileName;
%     tv(i) = datenum(2000+str2num(fileName(1:2)),str2num(fileName(3:4)),str2num(fileName(5:6)), 0,str2num(fileName(7:8))*15,0);
% end

%% This section changes the timevector to dates, which will be columns 1-5
%% in final data file:
tvs = datevec(data2(:,1));

[rows cols] = size(data2);
data_final(1:rows, 1:cols+4) = NaN;
data_final(:,:) = [tvs(:,1:5) data2(:,2:cols)];
clear data2;

%% Saves the final data file:
filename = input('give file a name, please: ','s');
save_path = ['C:\DATA\condensed\' filename '.csv']
dlmwrite(save_path, data_final, ',')