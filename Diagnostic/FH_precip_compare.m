%% Runs a quick comparison of rain guages:
clear all
addpath_loadstart
%% Load FH precip data:
fh_ppt = load([loadstart 'Matlab/Data/Met/Organized2/TP_PPT/Column/30min/TP_PPT_2008.019']);
fhtx_ppt = load([loadstart 'Matlab/Data/Met/Organized2/TP_PPT/Column/30min/TP_PPT_2008.013']);

%% Load M1 rain guage data:
 m1_ppt = load([loadstart 'Matlab/Data/Met/Organized2/TP39/Column/30min/TP39_2008.038']);
 m4_ppt = load([loadstart 'Matlab/Data/Met/Organized2/TP74/Column/30min/TP74_2008.014']);


%% Process FH data - Need to sort into cumulative and event-based:
fh_ppt(624:1089) = NaN;
fh_ppt(1:171) = fh_ppt(172);
%%% fix for when it was emptied:
fh_ppt(2180) = fh_ppt(2179);
fh_ppt(2181:length(fh_ppt),1) = fh_ppt(2181:length(fh_ppt),1) + (fh_ppt(2179) - fh_ppt(2181));
%%% reduce it down to the base level
base = 225.07; % The original volume in the can
fh_ppt = fh_ppt - base;


fh_event = fh_ppt;
fh_event2 = fh_ppt;
%%
figure(1)
plot(fh_ppt,'b.-')


%% Event based:
fh_ppt_offset = fh_ppt(2:length(fh_ppt));
hh_diff = fh_ppt_offset - fh_ppt(1:length(fh_ppt)-1); figure(2); plot(hh_diff);
sm_diff = find(abs(hh_diff) > 0 & abs(hh_diff) < 0.5);

hh_diff = [0 ;hh_diff];
hh_diff(hh_diff< 0.5) = 0;

for k = 1:1:length(fh_event)-1
    diff = fh_event(k+1) - fh_event(k);
    diff2 = fh_event2(k+1) - fh_event2(k);
    if diff2 < 0 || isnan(diff2)==1
        fh_event2(k+1) = fh_event2(k);
    end

    if abs(diff) < 0.3 || isnan(diff)==1
        fh_event(k+1) = fh_event(k);
        fh_event2(k+1) = fh_event2(k);
    else

    end
end

figure(7);clf
plot(m1_ppt,'g');hold on;
plot(hh_diff);
save('/home/brodeujj/Desktop/TP_PPT.dat','hh_diff','-ASCII')
save('/home/brodeujj/Desktop/TP39_PPT.dat','m1_ppt','-ASCII')



figure(3); clf;
plot(fh_ppt,'b.-'); hold on;
plot(fh_event,'r.-');m
plot(fh_event2,'g.-');


%%
% figure(5)
% plot(nancumsum(fhtx_ppt)); hold on;
% plot(nancumsum(m1_ppt),'r');
% plot(nancumsum(m4_ppt),'g');
% plot(fh_event2,'c-');

%% Get event-based:
clear diff
diff(1:length(fh_event2),1) = NaN; diff(1,1) = 0;

for k=1:1:length(fh_event2)-1
    diff(k+1,1) = fh_event2(k+1) - fh_event2(k);
end
    
    %%% Plot event-data for comparison
    
    figure(10); clf
    plot(fhtx_ppt,'b.-'); hold on
    plot(diff,'c.-');
    plot(m1_ppt,'r.-');
    plot(m4_ppt,'g.-');    
    
%%% Scatterplot between accum and TX inst
ok_data = find((diff > 0 | fhtx_ppt > 0) & diff < 15);

figure(11); clf;
plot(fhtx_ppt(ok_data),diff(ok_data),'k.'); hold on
line([0 8],[0 8],'Color',[1 0.5 0.2], 'LineStyle','-')
p = polyfit(fhtx_ppt(ok_data),diff(ok_data),1)


