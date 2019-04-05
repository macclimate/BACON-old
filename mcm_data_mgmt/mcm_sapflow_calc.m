function [] = mcm_sapflow_calc(year, site,auto_flag)
% if autoflag = 1, automatically use existing neural networks.
if nargin ==2
    auto_flag = 0;
end

ls = addpath_loadstart;
load_path = [ls 'Matlab/Data/Met/Final_Cleaned/' site '_sapflow/'];
met_path = [ls 'Matlab/Data/Met/Final_Filled/' site '/'];
save_path = [ls 'Matlab/Data/Met/Calculated4/' site '_sapflow/'];
% param_path = [ls 'Matlab/Data/Met/Docs/'];
param_path = [ls 'Matlab/Config/Met/Calculating-SapflowParameters/'];
jjb_check_dirs(save_path,0);


[year_start year_end] = jjb_checkyear(year);
for year_ctr = year_start:1:year_end
    yr_str = num2str(year_ctr);
    %%% Load the master file:
    load([load_path site '_sapflow_met_cleaned_' yr_str '.mat']);
    master.labels = cellstr(master.labels); % Convert labels to cell array
    %%% Load the met data:
    metdata = load([met_path site '_met_filled_' yr_str '.mat']);
    %     metdata.master.labels = cellstr(metdata.master.labels);
    %%% Load the parameter file:
    params = read_params([param_path site '_sapflow_params_' yr_str '.csv']);
    num_sensors = length(params.D_cm);
    %%% Find what column the dT (sapflow) data starts at:
    sap_col_start = find(strncmp('Sap',master.labels,3)==1,1,'first');
    
    %% Calculate Maximum dT
    dt_max_new = NaN.*ones(yr_length(year_ctr,1440),num_sensors);
    dt_max_old = NaN.*ones(yr_length(year_ctr,1440),num_sensors);
    dt_max_hh_new = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    dt_max_hh_old = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    
    dt_max_hh2 = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    for i = 1:1:num_sensors
        col_ind = sap_col_start+i-1; % What column in the master file we're working on.
        % Reshape the column of data to take maximums
        tmp1 = reshape(master.data(:,col_ind),48,[]);
        % Old method - take max dT at any point during the day:
        dt_max_old(:,i) = max(tmp1,[],1);
        % New method - take max dT only during 18th-21st half-hour (pre-dawn)?
        dt_max_new(:,i) = max(tmp1(18:21,:),[],1);
        clear tmp1;
        %%%% Make half-hourly matrices:
        tmp2 = repmat(dt_max_old(:,i)',48,1);
        dt_max_hh_old(:,i) = tmp2(:);
        tmp2 = repmat(dt_max_new(:,i)',48,1);
        dt_max_hh_new(:,i) = tmp2(:);
        clear tmp2;
        % A second hhourly matrix, with the maximum values at every 18th
        % hhour into the day, and NaNs otherwise (replaces lines 892-1086 in original program)
        dt_max_hh2(18:48:length(dt_max_hh2),i) = dt_max_new(:,i);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Right here we'll clarify that we're using the 'new' method results:
    %%% Comment or alter this to change what is used:
    dt_max_hh = dt_max_hh_new;
    %     dt_max = dt_max_new;
    clear *_old;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Clear-Water Correction:
    dT_CW_corr = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    switch site
    case 'TP39'
    CW_param_a = 0.7; CW_param_b = 0.3;  
    case 'TP74'
    CW_param_a = 0.7; CW_param_b = 0.3;  
    end
    
    for i = 1:1:num_sensors
        col_ind = sap_col_start+i-1; % What column in the master file we're working on.
        dT_CW_corr(:,i) = (master.data(:,col_ind) - (CW_param_b.*dt_max_hh(:,i)))./CW_param_a;
    end
    
    %% Manual Adjustments to dT and dT_max, due to voltage regulator adjustment/drift:
    
    ind = find(~isnan(dt_max_hh2(:,1)));
    f1 = figure('Name','dt-max, uncorrected and corrected');
    subplot(2,1,1);
    plot(ind,dt_max_hh2(ind,1:end));
    title('uncorrected')
    legend(num2str((1:1:num_sensors)'),'Location','NorthEastOutside')
    
    switch site
        
        case 'TP39'
            
            switch yr_str
                
                case '2009'
                    for i = 1:1:num_sensors
                        switch i
                            case num2cell([1:12 20:23])
                                volt_adj1 = nanmean(dt_max_hh2(10080:10560,i))./nanmean(dt_max_hh2(11090:11470,i));
                                dt_max_hh2(10560:end,i) = dt_max_hh2(10560:end,i).*volt_adj1;
                                dT_CW_corr(10560:end,i) = dT_CW_corr(10560:end,i).*volt_adj1;
                            case num2cell(13:19);
                                volt_adj1 = nanmean(dt_max_hh2(10080:10560,i))./nanmean(dt_max_hh2(11151:11366,i));
                                dt_max_hh2(11115:11366,i) = dt_max_hh2(11115:11366,i).*volt_adj1;
                                dT_CW_corr(11115:11366,i) = dT_CW_corr(11115:11366,i).*volt_adj1;
                                volt_adj2 = nanmean(dt_max_hh2(10080:10560,i))./nanmean(dt_max_hh2(11376:11856,i));
                                dt_max_hh2(11367:end,i) = dt_max_hh2(11367:end,i).*volt_adj2;
                                dT_CW_corr(11367:end,i) = dT_CW_corr(11367:end,i).*volt_adj2;
                        end
                    end
                case '2010'
                    for i = 1:1:num_sensors
                        switch i
                            case 1
                                volt_adj1 = nanmean(dt_max_hh2(7776:8256,i))./nanmean(dt_max_hh2(9457:9937,i));
                                dt_max_hh2(9457:end,i) = dt_max_hh2(9457:end,i).*volt_adj1; dT_CW_corr(9457:end,i) = dT_CW_corr(9457:end,i).*volt_adj1;
                            case 2
                                volt_adj1 = nanmean(dt_max_hh2(9475:9955,i))./nanmean(dt_max_hh2(8450:8930,i));
                                dt_max_hh2(7939:8933,i) = dt_max_hh2(7939:8933,i).*volt_adj1; dT_CW_corr(7939:8933,i) = dT_CW_corr(7939:8933,i).*volt_adj1;
                            case 4
                                volt_adj1 = nanmean(dt_max_hh2(9447:9927,i))./nanmean(dt_max_hh2(6222:6702,i));
                                dt_max_hh2(4382:6705,i) = dt_max_hh2(4382:6705,i).*volt_adj1; dT_CW_corr(4382:6705,i) = dT_CW_corr(4382:6705,i).*volt_adj1;
                            case {11 12}
                                volt_adj1 = nanmean(dt_max_hh2(6050:6530,i))./nanmean(dt_max_hh2(5548:6028,i));
                                dt_max_hh2(1:6045,i) = dt_max_hh2(1:6045,i).*volt_adj1; dT_CW_corr(1:6045,i) = dT_CW_corr(1:6045,i).*volt_adj1;
                            case num2cell(14:19)
                                volt_adj1 = nanmean(dt_max_hh2(7810:8290,i))./nanmean(dt_max_hh2(8313:8793,i));
                                dt_max_hh2(8313:9435,i) = dt_max_hh2(8313:9435,i).*volt_adj1; dT_CW_corr(8313:9435,i) = dT_CW_corr(8313:9435,i).*volt_adj1;
                                volt_adj2 = nanmean(dt_max_hh2(6100:6580,i))./nanmean(dt_max_hh2(5595:6075,i));
                                dt_max_hh2(1:6098,i) = dt_max_hh2(1:6098,i).*volt_adj2; dT_CW_corr(1:6098,i) = dT_CW_corr(1:6098,i).*volt_adj2;
                        end
                    end
                    
                    
                case '2011'
                    
                    %             for i = 1:1:num_sensors
                    %             volt_adj1 = nanmean(dt_max_hh2(7776:8256,i))./nanmean(dt_max_hh2(9457:9937,i));
                    %             dt_max_hh2(9457:end,i) = dt_max_hh2(9457:end,i).*volt_adj1;
                    %             dT_CW_corr(9457:end,i) = dT_CW_corr(9457:end,i).*volt_adj1;
                    
            end
            
        case 'TP74'
            
            
            switch yr_str
                
                
                case '2009'
                    
                case '2010'
                    
                    
            end
            
            
    end
    
    
    
    figure(f1);
    subplot(2,1,2);
    plot(ind,dt_max_hh2(ind,1:end));
    title('corrected')
    L1 = legend(num2str((1:1:num_sensors)'),'Location','NorthEastOutside');
    set(L1,'Visible','off');
    
    %% Multiply dt and dt max data by 25 - This converts the voltages to actual temperature:
    switch site
        case 'TP39'
            volt_convert_factor = 25;
        case 'TP74' %TP74 data is already reported in degrees C
            volt_convert_factor = 1;
    end
    dt_max_hh2 = dt_max_hh2.*volt_convert_factor;
    dT_CW_corr = dT_CW_corr.*volt_convert_factor;
    
    %% Interpolate the maximum values, and then subtract max from dt values
    %%%% This is what Sam termed the 'golden' data:
    dt_max_hh2_interp = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    dt_norm = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    K = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    
    for i = 1:1:num_sensors
        try
            dt_max_hh2_interp(:,i) = interp_nan(1:1:yr_length(year_ctr,30),dt_max_hh2(:,i));
            dt_max_hh2_interp(1:17,i) = dt_max_hh2_interp(18,i);
            dt_max_hh2_interp(end-29:end,i) = dt_max_hh2_interp(end-30,i);
        catch
            disp(['dt-max for sensor ' num2str(i) ' may be empty.']);
        end
        %%% This dt_norm is equivalent to 'golden' data
        dt_norm(:,i) = dT_CW_corr(:,i) - dt_max_hh2_interp(:,i);
        %%% Calculate the dimensionless paramater K:
        K(:,i) = (-1.*dt_norm(:,i))./dT_CW_corr(:,i);
    end
    %%% Set K < 0 to zero:
    K(K<0) = 0;
    
    %% Calculate Sap Flow Velocity (Js), and do spike removal:
    Js = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    Js_cleaned = Js;
    [sunup_down] = annual_suntimes(site, year_ctr, 0);
    sunup_down(sunup_down>0) = 500;
    for i = 1:1:num_sensors
        
        Js(:,i) = 0.119e-3 .* (K(:,i).^1.231);
        %%% Set Js > 0.0002 to NaN:
        Js(Js(:,i) > 0.0002,i) = NaN;
        %%% Do spike removal on Js -- the problem here is that I'm not particularly
        %%% sure which spike removal scheme we use, since sapflow is quite
        %%% different in nature from Fc.  We may be able to borrow the settings for
        %%% LE spike removal, since the two have similar shapes.
        %         [ind1,Js_cleaned(:,i)] = Papale_spike_removal(Js(:,i),15);
        %         Js_cleaned4(:,i) = mcm_CPEC_outlier_removal('TP39', Js(:,i), 30,'ET');
        
        %%% Currently, we'll attempt to remove spikes in the following manner:
        %%% We will run both the Papale spike removal program and the moving window
        %%% spike removal program, and remove "spikes" only at the data point where
        %%% both methods declare it to be a spike.  This gets rid of a lot of
        %%% problems associated with any one method marking spikes where they
        %%% should not be spikes.
        try
        [ind_Pap2,~] = Papale_spike_removal2(Js(:,i),15, sunup_down);
        [ind_MW,~] = movwin_spike_removal(Js(:,i),3);
        ind_spikes = ind_Pap2~=1 & ind_MW ~= 1;
        Js_cleaned(:,i) = Js(:,i);
        Js_cleaned(ind_spikes,i) = NaN;
        catch
        disp(['Error ocurred calculating spike removal (~line 220) for sensor: ' num2str(i)]);
        Js_cleaned(:,i) = NaN;    
        end
    end
    %%% We can plot some stuff here if we want to....
    % figure(21);clf
    % plot(Js(:,2),'r')
    % hold on;
    % plot(Js_cleaned(:,i),'b')
    % title('Papale spike removal #1');
    % legend('removed','kept');
    %
    % figure(22);clf
    % plot(Js(:,2),'r')
    % hold on;
    % plot(Js_cleaned2(:,i),'b')
    % title('Papale spike removal #2');
    % legend('removed','kept');
    %
    % figure(23);clf
    % plot(Js(:,2),'r')
    % hold on;
    % plot(Js_cleaned3(:,i),'b')
    % title('Moving Window spike removal');
    % legend('removed','kept');
    %
    % figure(24);clf
    % plot(Js(:,2),'r')
    % hold on;
    % plot(Js_cleaned4(:,i),'b')
    % title('mcm_CPEC_outlier_removal (Papale, MovWin)');
    % legend('removed','kept');
    %
    % figure(25);clf
    % plot(Js(:,2),'r')
    % hold on;
    % plot(Js_cleaned5,'b')
    % title('removal only when Papale+MovWin Agrees');
    % legend('removed','kept');
    
    %% Run gap-filling for Js using a neural network (NN):
    %%% For the time being, we're going to use the met tower/pit data to run the gapfilling models:
    %%% It's going to get quite complicated if we have to fill the TP39
    %%% soil variables....
    PAR = metdata.master.data(:,strcmp(metdata.master.labels(:,1),'DownPAR_AbvCnpy')==1);
    RH = metdata.master.data(:,strcmp(metdata.master.labels(:,1),'RelHum_AbvCnpy')==1);
    Ta = metdata.master.data(:,strcmp(metdata.master.labels(:,1),'AirTemp_AbvCnpy')==1);
    SM = metdata.master.data(:,strcmp(metdata.master.labels(:,1),'SM_A_30_filled')==1);
    Ts = metdata.master.data(:,strcmp(metdata.master.labels(:,1),'SoilTemp_5cm')==1);
    VPD = VPD_calc(RH,Ta);
    Js_filled = Js_cleaned;
    
    %%% I guess we ask the user if they want to run the filling, or just
    %%% use the previously-created NNs?  Running the NNs takes a long time,
    %%% so we don't want to do it repeatedly if we don't need to...
    
    % Check to see if nnets already exist for this year:
    if exist([save_path 'nnet/nnet_' yr_str '_Js1.mat'],'file')==2
        disp('Neural Networks Found.');
        if auto_flag == 0
        resp1 = input('Hit <ENTER> to load and use these, or enter <1> to recalculate: > ');
        else
            resp1 = '';
        end
        if isempty(resp1)==1
            resp1 = 0;
        end
    else
        resp1 = 1;
    end
    %%%%%%%% Run gap-filling for each sapflow variable:
    for i = 1:1:num_sensors
        clear net Js_pred
        try
            % Index of usable training points for NN:
            ind_use = find(~isnan(Ts.*PAR.*SM.*VPD.*Js_cleaned(:,i)));
            if resp1 == 1
                
                % Set the inputs (independent) and target (dependent)
                nn_inputs = [PAR(ind_use) Ts(ind_use) SM(ind_use) VPD(ind_use)];
                nn_target = Js_cleaned(ind_use,i);
                % Train the NN:
                net = newfit(nn_inputs',nn_target',30);
                net=train(net,nn_inputs',nn_target');
            else
                load([save_path 'nnet/nnet_' yr_str '_Js' num2str(i) '.mat' ]);
            end
            % Use the NN to simulate sapflow velocity:
            ind_sim = find(~isnan(Ts.*PAR.*SM.*VPD));
            sim_inputs = [PAR(ind_sim) Ts(ind_sim) SM(ind_sim) VPD(ind_sim)];
            [Js_pred,Pf,Af,E,perf] = sim(net,sim_inputs');
            
            % Fill the gaps with the predicted values:
            Js_filled(isnan(Js_filled(:,i)),i) = Js_pred(1,isnan(Js_filled(:,i)));
            % Remove values <0, and try to force nighttime data to 0 (not
            % perfect but the best we have right now):
            Js_filled(isnan(Js_cleaned(:,i))==1 & PAR<5,i) = 0;
            Js_filled(Js_filled(:,i) < 0,i) = 0;
            
            % Plot cleaned and filled on top of each other:
            figure(round(floor((i/6) - (0.95/6)) + 10))
            sp_num = rem(i,6);
            if sp_num == 0
                sp_num = 6;
            elseif sp_num == 1
                clf;
            end
            subplot(3,2,round(sp_num))
            plot(Js_filled(:,i),'r'); hold on;
            plot(Js_cleaned(:,i),'b');
            legend('Js filled','Js cleaned');
            title(['Sensor ' num2str(i)]);
%                         test(1:2,i) = [(round(floor((i/6) - (1/6)) + 10)) round(sp_num)]

            
            if resp1 == 1
                % Save the nnet:
                save([save_path 'nnet/nnet_' yr_str '_Js' num2str(i) '.mat' ],'net');
            end
            
        catch
            disp(['Filling did not work for sensor ' num2str(i)]);
%             test(1:2,i) = [NaN NaN];
            if isempty(ind_use)==1
                disp('seems there is no data for the sensor');
            else
                disp('sensor has data - not sure of the problem.');
            end
        end
    end
    
    
    %% Sap Flow Discharge Calculation (F) - Units = mm/hhour 
    % Changed sw_m2 to AsAw following Granier et al 1987 (i.e. As / Aw)
    F = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    F_mmol = NaN.*ones(yr_length(year_ctr,30),num_sensors);
    MM_H2O = 18.01528e-3; %MM of water (g/mmol)
    rho_w = 1e6;        %density of water (g/m3)
    % 1 m3 of water = rho_w / MM_H2O
    for i = 1:1:num_sensors
        F(:,i) = params.AsAw(i,1).*(Js_filled(:,i)).*1800; % Changed Js_cleaned to Js_filled - 14-Feb-2012
        % Added 20180315 by JJB - Using Js_cleaned and As/Aw, which
        % converts this to a flux [it's actually sw_m2*Js*(rho_w./MM_H2O)/wa_m2 (where wa is wood area)
        F_mmol(:,i) = params.AsAw(i,1).*(Js_cleaned(:,i)).*(rho_w./MM_H2O); % Added 20180315-Using Js_cleaned and sw_m2 to calculate discharge and convert to a flux 
    end
    %%% Can plot F here if we want to.....
    
    %%% In Sam's script she takes daily sum of sapflow, but I'm not going to do
    %%% that here, since it's something that can be done by the user if needed.
    
    %% Save the output:
    %%% Data we will save:
    % dT_CW_corr - The corrected dT (Clearwater + voltage normalization)
    % dt_norm - Interpolated and dt_max-subtracted dT (final, "golden" dT data)
    %%%% xxxx Js - Sap Flow Velocity (uncleaned) ?? <<Maybe not save this one>>
    % Js_cleaned - Sap Flow Velocity (Spike-cleaned)
    % F - Sap Flow Discharge - velocity x sapwood area = m3/s
    % So, our output matrix will basically be size = [yr_length,4*num_sensors];
    tmp_label1 = cell(num_sensors,1);
    tmp_label2 = cell(num_sensors,1);
    tmp_label3 = cell(num_sensors,1);
    tmp_label4 = cell(num_sensors,1);
    tmp_label5 = cell(num_sensors,1);
    tmp_label6 = cell(num_sensors,1); % Added by JJB, 20180315
    
    for i = 1:1:num_sensors
        ni = num2str(i);
        tmp_label1{i,1} = ['dT_corr' ni];
        tmp_label2{i,1} = ['dT_final' ni];
        tmp_label3{i,1} = ['Js_clean' ni];
        tmp_label4{i,1} = ['Js_filled' ni];
        tmp_label5{i,1} = ['F_final' ni];
        tmp_label6{i,1} = ['F_mmol_final' ni]; % Added by JJB, 20180315
    end
    
    %% Make the final cleaned output (master) file, and save it:
    clear master;
    master.data = [dT_CW_corr dt_norm Js_cleaned Js_filled F F_mmol];
    master.labels = [tmp_label1; tmp_label2; tmp_label3; tmp_label4; tmp_label5 ; tmp_label6];
    save([save_path site '_sapflow_calculated_' yr_str '.mat'],'master');
    clear master dt_CW_corr dt_norm Js_cleaned Js_filled F Js dt_max* F_mmol;
    disp(['Master file updated and saved to: ' save_path site '_sapflow_calculated_' yr_str '.mat']);
    
%     %%% Export results to master files as well:
%     disp('Now exporting file to Master File');
%     mcm_data_compiler(year, site,'sapflow');
%     
    
    if year_start~=year_end && auto_flag==0
        junk = input('Press Enter to Continue to Next Year');
    end
end

end

function [out] = read_params(file_in)
A = importdata(file_in, ',', 1);
for i = 2:1:size(A.data,2)
    eval(['out.' A.textdata{1,i} ' = A.data(:,i);'])
end
end