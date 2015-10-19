function [s,x,outputTable] = acs_mat2dat(metdataPath, wildcard)

% if ischar(metdataPath)
%     metdataPath = eval(metdataPath);
% end
% 
% if ischar(wildcard)
%     wildcard = eval(wildcard);
% end
% 
% EndTimeGMT EndTimeMtn Chamber1/smpl1 Chamber1/smpl2 Chamber1/smpl3  Chamber1/airTem
%         Chamber2/smpl1 .....
%         Chamber3/smpl1 .....
%         Tc1 ... Tc10

s = dir(fullfile(metdataPath,wildcard));
for i=1:length(s)  % cycle through all files that match wildcard
    outputTable = sprintf('%s ','EndDateGMT EndTimeGMT EndDateMtn EndTimeMtn');
    outputTable = [ outputTable sprintf('%s ','CH1_1_flux CH1_1_dcdt CH1_2_flux CH1_2_dcdt CH1_3_flux CH1_3_dcdt')];
    outputTable = [ outputTable sprintf('%s ','CH2_1_flux CH2_1_dcdt CH2_2_flux CH2_2_dcdt CH2_3_flux CH2_3_dcdt')];
    outputTable = [ outputTable sprintf('%s ','CH3_1_flux CH3_1_dcdt CH3_2_flux CH3_2_dcdt CH3_3_flux CH3_3_dcdt')];    
    outputTable = [ outputTable sprintf('%s \n','Tlicor Plicor Tc1 Tc2 Tc3 Tc4 Tc5 Tc6 Tc7 Tc8 Tc9 Tc10')];
    x=load(fullfile(metdataPath,s(i).name));
    for currentHHour = 1:length(x.HHour)
        try
            outputChar = [];
            fileName = x.HHour(currentHHour).HhourFileName;
            endTime = datenum(2000+str2num(fileName(1:2)),str2num(fileName(3:4)),str2num(fileName(5:6)), 0,str2num(fileName(7:8))*15,0);
            outputChar = [outputChar sprintf('%s  %s   ',datestr(endTime,0),datestr(endTime-7/24,0))];
            for chamberNum = 1:3
                for sampleNum = 1:3
                    outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).Chamber(chamberNum).Sample(sampleNum).efflux)];
                    outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).Chamber(chamberNum).Sample(sampleNum).dcdt)];
                end % sampleNum
            end % chamberNum
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tlicor.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Plicor.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc1.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc2.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc3.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc4.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc5.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc6.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc7.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc8.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc9.avg)];
            outputChar = [outputChar sprintf('%8.4f  ',x.HHour(currentHHour).DataHF.Channel.Tc10.avg)];
            outputTable = [outputTable outputChar sprintf('\n')];
        catch
        end
    end % currentHHour
    try
        fid = fopen(fullfile(metdataPath,[s(i).name(1:end-4) '.dat']),'wt');
        fprintf(fid,'%s',outputTable);
        fclose(fid);
    catch
    end
end % i - file counter
