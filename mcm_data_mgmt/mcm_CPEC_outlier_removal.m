function [array_out] = mcm_CPEC_outlier_removal(site, array_in, min_int, var_type, repeatflag)
if nargin < 4;
    commandwindow;
    min_int = input('Enter time interval for measurements (i.e. 10 or 30): ');
    var_type = input('Enter variable to clean (Fc, H, LE): ' ,s);
    repeatflag = 0;
end
if nargin == 4
    repeatflag = 0;
end

%%%%%%%%% PARAMETERS
switch var_type
    case 'Fc'
        switch site
            case 'TP39'
                top_cut = 25; bot_cut = -45; z = 5; win_size = 30; sdev_mult = 3;
            case 'TP74'
                top_cut = 25; bot_cut = -45; z = 5; win_size = 30; sdev_mult = 3;
            case 'TP89'
                top_cut = 25; bot_cut = -55; z = 5; win_size = 30; sdev_mult = 3;
            case 'TP02'
                top_cut = 15; bot_cut = -30; z = 5; win_size = 30; sdev_mult = 3;
            case 'TPD'
                top_cut = 25; bot_cut = -45; z = 5; win_size = 30; sdev_mult = 3;
                
        end
        
    case 'H'
        switch site
            case 'TP39'
                top_cut = 800; bot_cut = -200; z = 15; win_size = 30; sdev_mult = 3;
            case 'TP74'
                top_cut = 700; bot_cut = -100; z = 9; win_size = 30; sdev_mult = 3;
            case 'TP89'
                top_cut = 800; bot_cut = -200; z = 9; win_size = 30; sdev_mult = 3;
            case 'TP02'
                top_cut = 500; bot_cut = -100; z = 9; win_size = 30; sdev_mult = 3;
            case 'TPD'
                top_cut = 800; bot_cut = -200; z = 15; win_size = 30; sdev_mult = 6;
        end
        
    case 'LE'
        switch site
            case 'TP39'
                top_cut = 700; bot_cut = -100; z = 15; win_size = 30; sdev_mult = 5.5;
            case 'TP74'
                top_cut = 650; bot_cut = -100; z = 11; win_size = 30; sdev_mult = 5.5;
            case 'TP89'
                top_cut = 800; bot_cut = -100; z = 9; win_size = 30; sdev_mult = 3.5;
            case 'TP02'
                top_cut = 650; bot_cut = -100; z = 11; win_size = 30; sdev_mult = 5.5;
            case 'TPD'
                top_cut = 650; bot_cut = -100; z = 15; win_size = 30; sdev_mult = 5.5;
                
        end
        
    case 'ET'
        switch site
            case 'TP39'
                top_cut = 0.3; bot_cut = 0;  z = 15; win_size = 30;  sdev_mult = 5.5;
            case 'TP74'
                top_cut = 0.3; bot_cut = 0;  z = 15; win_size = 30;  sdev_mult = 5.5;
        end
        
    case 'SFVEL'
        switch site
            case 'TP39'
                top_cut = 0.00016; bot_cut = 0;  z = 11; win_size = 30;  sdev_mult = 5.5;
            case 'TP74'
                top_cut = 0.00016; bot_cut = 0;  z = 11; win_size = 30;  sdev_mult = 5.5;
        end
        
    case 'H_Gapfill'
        switch site
            case 'TP39'
                top_cut = 800; bot_cut = -200; %z = 9; win_size = 30; sdev_mult = 3;
            case 'TP74'
                top_cut = 700; bot_cut = -100; %z = 9; win_size = 30; sdev_mult = 3;
            case 'TP89'
                top_cut = 800; bot_cut = -200; %z = 9; win_size = 30; sdev_mult = 3;
            case 'TP02'
                top_cut = 500; bot_cut = -100; %z = 9; win_size = 30; sdev_mult = 3;
            case 'TPD'
                top_cut = 800; bot_cut = -200; %z = 11; win_size = 30; sdev_mult = 4;
        end
        array_out = array_in;
        array_out(array_out<bot_cut | array_out > top_cut) = NaN;
        return
end

array_in(array_in > top_cut | array_in < bot_cut) = NaN;
orig_data = array_in;

%%% Take spikes out for a first time:
switch var_type
    case 'Fc'
        [junk array_in] = Papale_spike_removal(array_in, z);
        [junk array_in] = Papale_spike_removal(array_in, z);
        [junk array_in] = Papale_spike_removal(array_in, z);
    case 'H'
        [junk array_in] = Papale_spike_removal(array_in, z);
    case 'LE'
        [junk array_in] = Papale_spike_removal(array_in, z);
    case 'ET'
        [junk array_in] = Papale_spike_removal(array_in, z);
        
end

%%% This will allow the user to repeat the spike removal procedure if for a
%%% given instance it is deemed as needed:
if repeatflag >0
    for i = 1:1:repeatflag
        [junk array_in] = Papale_spike_removal(array_in, z);
    end
end


%%%% Use the ensemble method:
[array_clean1 upthresh1 downthresh1] = mcm_CPEC_ensemble_clean(array_in, sdev_mult, win_size, min_int);
[array_clean2 upthresh2 downthresh2] = mcm_CPEC_ensemble_clean(array_clean1, sdev_mult, win_size, min_int);

%%%% Back to spike removal:
switch var_type
    case 'Fc'
        [junk array_out] = Papale_spike_removal(array_clean2, z); %cov2 = length(find(~isnan(array_out2)==1))./length(array_clean1);
    case 'H'
        array_out = array_in; %
        %        array_out = array_clean1;
    case 'LE'
        array_out = array_in; %
        %        array_out = array_clean1;
    case 'ET'
        array_out = array_in;
end

% Plot results:
switch var_type
    case 'Fc'
        figure('Name', ['Spike Removal for ' var_type ' for site ' site]); clf
        plot(orig_data,'.-','Color',[0.8 0.8 0.8]); hold on;
        plot(array_in,'.-','Color',[0.3 0.3 0.3]);
        plot(array_clean2,'b.-');
        plot(array_out,'g.-');
        plot(find(isnan(array_out)),orig_data(isnan(array_out)==1),'ro','MarkerSize',5);
        legend('orig', 'first spike rem.', 'ens clean', 'final', 'missing points')
        
    case 'H'
        figure('Name', ['Spike Removal for ' var_type ' for site ' site]); clf
        plot(orig_data,'.-','Color',[0.8 0.8 0.8]); hold on;
        plot(array_clean1,'b.-');
        plot(array_out,'g.-');
        plot(find(isnan(array_out)),orig_data(isnan(array_out)==1),'ro','MarkerSize',5);
        legend('orig', 'first ens clean.', 'second ens clean', 'missing points')
        
    case 'LE'
        figure('Name', ['Spike Removal for ' var_type ' for site ' site]); clf
        plot(orig_data,'.-','Color',[0.8 0.8 0.8]); hold on;
        plot(array_clean1,'b.-');
        plot(array_out,'g.-');
        plot(find(isnan(array_out)),orig_data(isnan(array_out)==1),'ro','MarkerSize',5);
        
        legend('orig', 'first ens clean.', 'second ens clean', 'missing points')
        
    case 'ET'
        figure('Name', ['Spike Removal for ' var_type ' for site ' site]); clf
        plot(orig_data,'.-','Color',[0.8 0.8 0.8]); hold on;
        plot(array_clean1,'b.-');
        plot(array_out,'g.-');
        plot(find(isnan(array_out)),orig_data(isnan(array_out)==1),'ro','MarkerSize',5);
        
        legend('orig', 'first ens clean.', 'second ens clean', 'missing points')
        
end


