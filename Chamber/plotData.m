function status = plotData(dataVar)

for countChan = 1:1:dataVar.header.NumOfChans
    figure(countChan)    
    
    hold on
    plot(dataVar.data(:,countChan))
    xlabel('Samples')
    ylabel(dataVar.header.chanInfo(countChan).units)
    title(dataVar.header.chanInfo(countChan).name)
    set(gcf, 'Name', dataVar.header.chanInfo(countChan).name)
    hold off
end


    
