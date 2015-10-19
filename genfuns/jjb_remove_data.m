function [tracker] = jjb_remove_data(data)
%%% This function allows the user to manually scroll through

tracker = ones(length(data),1); % tracker is a column of ones -- if data deemed bad, will be changed to NaNs

tracker(isnan(data),1)  = NaN;


figure(10); clf;
plot(1:1:length(data),data,'k.-'); hold on;
st = input('select starting point for manual cleaning: ');
if isempty(st)==1
    %%% exit without doing anything
    st = 1;
end

en = input('select end point: ');
if isempty(en)==1
    %%% exit without doing anything
    en = length(data);

end

ctr = st;

while ctr <=en
% for loop2 = st:en
    if ~isnan(data(ctr,1))
        figure(11);clf;
        clf; plot(1:1:length(data),data,'k.-'); hold on;
        plot_min = min(data(ctr-50:ctr+400));
        plot_max = max(data(ctr-50:ctr+400));
        axis([ctr-50 ctr+400 plot_min plot_max])
        plot(ctr,data(ctr,1),'MarkerEdgeColor','r','Marker','o','MarkerSize',10)
        decision = input('0 to remove, enter to keep, 1 to go backwards, 3 to skip ahead by 30 points, 10 to go backwards 10, 999 to go to end: ');

        if decision == 0
            data(ctr,1) = NaN;
            tracker(ctr,1) = NaN;
            ctr = ctr+1;
        elseif decision == 3
            ctr = ctr+30;
            
        elseif decision == 1
            ctr = ctr-1;    
            
        elseif decision == 10
            ctr = ctr - 10;
            
        elseif decision == 999;
            ctr = en;
            
        else
            ctr = ctr+1;
        end
    else
        ctr = ctr + 1;    
        
    end


clear decision;
end

%
%     save(['C:\HOME\MATLAB\Data\Met\Cleaned3\Met2\Met2_2007.' ext],'data','-ASCII');
%     save(['C:\HOME\MATLAB\Data\Met\Organized2\Docs\M2_2007_Ts_tracker\Met2_2007.' ext],'tracker','-ASCII');