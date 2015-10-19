function [out] = mcm_get_fluxsystem_info(site, datatype)

%%
switch datatype
    case 'varnames'
        switch site
            case {'TP74', 'TP02'}
                % if strcmp(site, 'TP74') == 1 || strcmp(site, 'TP02') == 1
                vars(1).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Fc';             vars(1).name = 'Fc';            vars(1).ylabel = '\mumol m^{-2} s^{-1}';
                vars(2).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Ustar';          vars(2).name = 'Ustar';         vars(2).ylabel = 'm s^{-1}';
                vars(3).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Hs';             vars(3).name = 'Hs';            vars(3).ylabel = 'W m^{-2}';
                vars(4).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Htc';            vars(4).name = 'Htc';vars(4).ylabel = 'W m^{-2}';
                vars(5).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_L';           vars(5).name = 'LE_L';vars(5).ylabel = 'W m^{-2}';
                vars(6).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_K';           vars(6).name = 'LE_K';vars(6).ylabel = 'W m^{-2}';
                vars(7).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.Penergy';      vars(7).name = 'Penergy';vars(7).ylabel = 'W m^{-2}';
                vars(8).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.WUE';          vars(8).name = 'WUE';   vars(8).ylabel = '?';
                vars(9).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.HR_coeff';     vars(9).name = 'HR_coeff';vars(9).ylabel = '?';
                vars(10).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_L';         vars(10).name = 'B_L';vars(10).ylabel = '?';
                vars(11).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_K';         vars(11).name = 'B_K';vars(11).ylabel = '?';
                vars(12).path = 'MainEddy.Three_Rotations.Angles.Eta';      vars(12).name = 'Eta';  vars(12).ylabel = 'degrees';
                vars(13).path = 'MainEddy.Three_Rotations.Angles.Theta';    vars(13).name = 'Theta';vars(13).ylabel = 'degrees';
                vars(14).path = 'MainEddy.Three_Rotations.Angles.Beta';     vars(14).name = 'Beta';vars(14).ylabel = 'degrees';
                vars(15).path = 'MiscVariables.BarometricP';                vars(15).name = 'BarometricP';vars(15).ylabel = 'kPa';
                vars(16).path = 'MiscVariables.Tair';                       vars(16).name = 'Tair';vars(16).ylabel = '^oC';
                vars(17).path = 'Instrument(1,3).Avg(1)';   vars(17).name = 'CO2_irga';     vars(17).ylabel = '\mumol';
                vars(18).path = 'Instrument(1,3).Avg(2)';   vars(18).name = 'H2O_irga';vars(18).ylabel = 'mmol';
                vars(19).path = 'Instrument(1,4).Avg(1)';   vars(19).name = 'u'; vars(19).ylabel = 'm s^{-1}';
                vars(20).path = 'Instrument(1,4).Avg(2)';   vars(20).name = 'v'; vars(20).ylabel = 'm s^{-1}';
                vars(21).path = 'Instrument(1,4).Avg(3)';   vars(21).name = 'w'; vars(21).ylabel = 'm s^{-1}';
                vars(22).path = 'Instrument(1,4).Avg(4)';   vars(22).name = 'T_s';vars(22).ylabel = '^oC';
                vars(23).path = 'Instrument(1,4).Std(1)';   vars(23).name = 'u_std';vars(23).ylabel = 'm s^{-1}';
                vars(24).path = 'Instrument(1,4).Std(2)';   vars(24).name = 'v_std';vars(24).ylabel = 'm s^{-1}';
                vars(25).path = 'Instrument(1,4).Std(3)';   vars(25).name = 'w_std';vars(25).ylabel = 'm s^{-1}';
                vars(26).path = 'Instrument(1,4).Std(4)';   vars(26).name = 'Ts_std';vars(26).ylabel = '^oC';
                %%% Added these on June 20, 2011 (JJB):
                vars(27).path = 'Instrument(1,3).Avg(3)';   vars(27).name = 'T_irga';vars(27).ylabel = '^oC';
                vars(28).path = 'Instrument(1,3).Avg(4)';   vars(28).name = 'P_irga';vars(28).ylabel = 'kPa';
                vars(29).path = 'Instrument(1,3).Std(1)';   vars(29).name = 'CO2_std';vars(29).ylabel = '\mumol';
                vars(30).path = 'Instrument(1,3).Std(2)';   vars(30).name = 'H2O_std';vars(30).ylabel = 'mmol';
                
            case 'TPD'
                vars(1).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Fc';             vars(1).name = 'Fc';            vars(1).ylabel = '\mumol m^{-2} s^{-1}';
                vars(2).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Ustar';          vars(2).name = 'Ustar';         vars(2).ylabel = 'm s^{-1}';
                vars(3).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Hs';             vars(3).name = 'Hs';            vars(3).ylabel = 'W m^{-2}';
                vars(4).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Htc';            vars(4).name = 'Htc';vars(4).ylabel = 'W m^{-2}';
                vars(5).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_L';           vars(5).name = 'LE_L';vars(5).ylabel = 'W m^{-2}';
                vars(6).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_K';           vars(6).name = 'LE_K';vars(6).ylabel = 'W m^{-2}';
                vars(7).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.Penergy';      vars(7).name = 'Penergy';vars(7).ylabel = 'W m^{-2}';
                vars(8).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.WUE';          vars(8).name = 'WUE';   vars(8).ylabel = '?';
                vars(9).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.HR_coeff';     vars(9).name = 'HR_coeff';vars(9).ylabel = '?';
                vars(10).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_L';         vars(10).name = 'B_L';vars(10).ylabel = '?';
                vars(11).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_K';         vars(11).name = 'B_K';vars(11).ylabel = '?';
                vars(12).path = 'MainEddy.Three_Rotations.Angles.Eta';      vars(12).name = 'Eta';  vars(12).ylabel = 'degrees';
                vars(13).path = 'MainEddy.Three_Rotations.Angles.Theta';    vars(13).name = 'Theta';vars(13).ylabel = 'degrees';
                vars(14).path = 'MainEddy.Three_Rotations.Angles.Beta';     vars(14).name = 'Beta';vars(14).ylabel = 'degrees';
                vars(15).path = 'MiscVariables.BarometricP';                vars(15).name = 'BarometricP';vars(15).ylabel = 'kPa';
                vars(16).path = 'MiscVariables.Tair';                       vars(16).name = 'Tair';vars(16).ylabel = '^oC';
                vars(17).path = 'Instrument(1,1).Avg(1)';   vars(17).name = 'CO2_irga';     vars(17).ylabel = '\mumol';
                vars(18).path = 'Instrument(1,1).Avg(2)';   vars(18).name = 'H2O_irga';vars(18).ylabel = 'mmol';
                vars(19).path = 'Instrument(1,2).Avg(1)';   vars(19).name = 'u'; vars(19).ylabel = 'm s^{-1}';
                vars(20).path = 'Instrument(1,2).Avg(2)';   vars(20).name = 'v'; vars(20).ylabel = 'm s^{-1}';
                vars(21).path = 'Instrument(1,2).Avg(3)';   vars(21).name = 'w'; vars(21).ylabel = 'm s^{-1}';
                vars(22).path = 'Instrument(1,2).Avg(4)';   vars(22).name = 'T_s';vars(22).ylabel = '^oC';
                vars(23).path = 'Instrument(1,2).Std(1)';   vars(23).name = 'u_std';vars(23).ylabel = 'm s^{-1}';
                vars(24).path = 'Instrument(1,2).Std(2)';   vars(24).name = 'v_std';vars(24).ylabel = 'm s^{-1}';
                vars(25).path = 'Instrument(1,2).Std(3)';   vars(25).name = 'w_std';vars(25).ylabel = 'm s^{-1}';
                vars(26).path = 'Instrument(1,2).Std(4)';   vars(26).name = 'Ts_std';vars(26).ylabel = '^oC';
                vars(27).path = 'Instrument(1,1).Avg(3)';   vars(27).name = 'T_irga';vars(27).ylabel = '^oC';
                vars(28).path = 'Instrument(1,1).Avg(5)';   vars(28).name = 'P_irga';vars(28).ylabel = 'kPa';
                vars(29).path = 'Instrument(1,1).Std(1)';   vars(29).name = 'CO2_std';vars(29).ylabel = '\mumol';
                vars(30).path = 'Instrument(1,1).Std(2)';   vars(30).name = 'H2O_std';vars(30).ylabel = 'mmol';
                                
                
                % elseif strcmp(site, 'TP39') == 1
            case 'TP39'
                vars(1).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Fc';             vars(1).name = 'Fc';vars(1).ylabel = '\mumol m^{-2} s^{-1}';
                vars(2).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Ustar';          vars(2).name = 'Ustar';vars(2).ylabel = 'm s^{-1}';
                vars(3).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Hs';             vars(3).name = 'Hs';vars(3).ylabel = 'W m^{-2}';
                vars(4).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.Htc';            vars(4).name = 'Htc';vars(4).ylabel = 'W m^{-2}';
                vars(5).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_L';           vars(5).name = 'LE_L';vars(5).ylabel = 'W m^{-2}';
                vars(6).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.LE_K';           vars(6).name = 'LE_K';vars(6).ylabel = 'W m^{-2}';
                vars(7).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.Penergy';      vars(7).name = 'Penergy';vars(7).ylabel = 'W m^{-2}';
                vars(8).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.WUE';          vars(8).name = 'WUE';vars(8).ylabel = '?';
                vars(9).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.HR_coeff';     vars(9).name = 'HR_coeff';vars(9).ylabel = '?';
                vars(10).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_L';         vars(10).name = 'B_L';vars(10).ylabel = '?';
                vars(11).path = 'MainEddy.Three_Rotations.LinDtr.Fluxes.MiscVariables.B_K';         vars(11).name = 'B_K';vars(11).ylabel = '?';
                vars(12).path = 'MainEddy.Three_Rotations.Angles.Eta';      vars(12).name = 'Eta';vars(12).ylabel = 'degrees';
                vars(13).path = 'MainEddy.Three_Rotations.Angles.Theta';    vars(13).name = 'Theta';vars(13).ylabel = 'degrees';
                vars(14).path = 'MainEddy.Three_Rotations.Angles.Beta';     vars(14).name = 'Beta';vars(14).ylabel = 'degrees';
                vars(15).path = 'MiscVariables.BarometricP';                vars(15).name = 'BarometricP';vars(15).ylabel = 'kPa';
                vars(16).path = 'MiscVariables.Tair';                       vars(16).name = 'Tair';vars(16).ylabel = '^oC';
                vars(17).path = 'Instrument(1,1).Avg(1)';   vars(17).name = 'CO2_irga';vars(17).ylabel = '\mumol';
                vars(18).path = 'Instrument(1,1).Avg(2)';   vars(18).name = 'H2O_irga';vars(18).ylabel = 'mmol';
                vars(19).path = 'Instrument(1,2).Avg(1)';   vars(19).name = 'u';vars(19).ylabel = 'm s^{-1}';
                vars(20).path = 'Instrument(1,2).Avg(2)';   vars(20).name = 'v';vars(20).ylabel = 'm s^{-1}';
                vars(21).path = 'Instrument(1,2).Avg(3)';   vars(21).name = 'w';vars(21).ylabel = 'm s^{-1}';
                vars(22).path = 'Instrument(1,2).Avg(4)';   vars(22).name = 'T_s';vars(22).ylabel = '^oC';
                vars(23).path = 'Instrument(1,2).Std(1)';   vars(23).name = 'u_std';vars(23).ylabel = 'm s^{-1}';
                vars(24).path = 'Instrument(1,2).Std(2)';   vars(24).name = 'v_std';vars(24).ylabel = 'm s^{-1}';
                vars(25).path = 'Instrument(1,2).Std(3)';   vars(25).name = 'w_std';vars(25).ylabel = 'm s^{-1}';
                vars(26).path = 'Instrument(1,2).Std(4)';   vars(26).name = 'Ts_std'; vars(26).ylabel = '^oC';
                %%% Added these on June 20, 2011 (JJB):
                vars(27).path = 'Instrument(1,1).Avg(3)';   vars(27).name = 'T_irga';vars(27).ylabel = '^oC';
                vars(28).path = 'Instrument(1,1).Avg(4)';   vars(28).name = 'P_irga';vars(28).ylabel = 'kPa';
                vars(29).path = 'Instrument(1,1).Std(1)';   vars(29).name = 'CO2_std';vars(29).ylabel = '\mumol';
                vars(30).path = 'Instrument(1,1).Std(2)';   vars(30).name = 'H2O_std';vars(30).ylabel = 'mmol';
                
                
                % elseif strcmp(site, 'TP39_chamber') == 1
            case 'TP39_chamber'
                vars(1).path = 'airTemperature';            vars(1).name = 'Ta';
                vars(2).path = 'airPressure';               vars(2).name = 'APR';
                vars(3).path = 'dcdt';                      vars(3).name = 'dcdt';
                vars(4).path = 'rsquared';                  vars(4).name = 'rsquared';
                vars(5).path = 'rmse';                      vars(5).name = 'rmse';
                vars(6).path = 'efflux';                    vars(6).name = 'efflux';
                vars(7).path = 'Channel.co2.avg';           vars(7).name = 'CO2_avg';
                vars(8).path = 'Channel.h2o.avg';           vars(8).name = 'H2O_avg';
                vars(9).path = 'Channel.Tlicor.avg';        vars(9).name = 'T_licor';
                vars(10).path = 'Channel.Plicor.avg';       vars(10).name = 'P_licor';
                vars(11).path = 'LE';                       vars(11).name = 'LE';
                
                % else
            otherwise
                disp('Cannot find the proper site in mcm_get_varnames... ' );
                vars = struct;
        end
        out = vars;
        
        % ****************************************************************
    case 'data_extensions' % for mcm_extract_datafiles
        switch site
            case 'TP39';                tag = {'.DMCM4', '.DMCM5'};
            case 'TP74';                tag = {'.DMCM21', '.DMCM22', '.DMCM23'};
            case 'TP02';                tag = {'.DMCM31', '.DMCM32', '.DMCM33'};
            case 'TP39_chamber';        tag = {'.DACS16'};
            case 'TPD';                tag = {'.DMCM41', '.DMCM42', '.DMCM43'};    
        end
        out = tag;
        
        % ****************************************************************
    case 'hhour_field_extensions' % for mcm_extract_hhourfiles
        switch site
            case 'TP39';                tag = {'.hHJP02.mat'};
            case 'TP74';                tag = {'.hMCM2.mat'};
            case 'TP02';                tag = {'.hMCM3.mat'};
            case 'TP39_chamber';        tag = {'.ACS_Flux_16.mat'};
            case 'TPD';                tag = {'.hMCM4.mat'};
        end
        out = tag;
        
        % ****************************************************************
    case 'hhour_extensions' % for use in mcm_CPEC_mat2annual,mcm_chamber_mat2annual 
        switch site
            case 'TP39';                tag = 'hMCM1.mat';
            case 'TP74';                tag = 'hMCM2.mat';
            case 'TP02';                tag = 'hMCM3.mat';
            case 'TP39_chamber';        tag = 'ACS_Flux_16.mat'; 
            case 'TPD';                tag = 'hMCM4.mat';    
        end
        out = tag;
        % ****************************************************************
    case 'chamber_settings' % for use in mcm_chamber_mat2annual 
        switch site
            case 'TP39_chamber';        
                out.maxNch = 8; % maximum number of chambers
                out. num_samples = 3; % number of samples per chamber per hhour
                
        end
        
        
        
end
