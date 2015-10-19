function [] = CCP_output(site_num,yr)
% for yr = 2003:1:2007
    if yr >= 2007
        flux_source = 'processed';
        met_source = 'processed';
    elseif yr == 2006 && (site_num == 3 || site_num ==4);
        flux_source = 'master';
        met_source = 'processed';
    else
        flux_source = 'master';
        met_source = 'master';
    end
    %%
    if ispc == 1

        data_loc = 'C:/Home/';
    else

        data_loc = '/home/jayb/'; % this loads and writes data to and from the portable hard disk
    end

    %% Make Sure site and year are in proper format
    site_label = [1 39; 2 74; 3 89; 4 02];
    if ischar(site_num) == true
        site_num = str2double(site_num);
    end
    if ischar(yr) == false
        yr = num2str(yr);
    end
    site = num2str(site_num);
    site_tag = num2str(site_label(find(site_label(:,1) == site_num),2));
    if site == '4'
        site_tag = '02';
    end
    %% Declare Paths

    %%% Processed Met
    load_path_metproc = ([data_loc 'MATLAB/Data/Met/Cleaned3/Met' site '/Met' site '_' yr '.']);  %/Column/30min/
    hdr_path_metproc = ([data_loc 'MATLAB/Data/Met/Raw1/Docs/Met' site '_OutputTemplate.csv']);

    %%% Master Flux and Master Met
    load_path_master = ([data_loc 'MATLAB/Data/Flux/OPEC/Organized2/Met' site '/Column/Met' site '_' yr '.']);
    hdr_path_master = ([data_loc 'MATLAB/Data/Flux/OPEC/Organized2/Docs/Met' site '_FluxColumns.csv']);

    %%% Processed OPEC
    hdr_path_OPECproc = ([data_loc 'MATLAB/Data/Flux/OPEC/Organized2/Docs/OPEC_30min_header.csv']);
    load_path_OPECproc = ([data_loc 'MATLAB/Data/Flux/OPEC/Cleaned3/Met' site '/Column/Met' site '_HHdata_' yr '.']);

    %%% Processed CPEC
    load_path_CPECproc = ([data_loc 'MATLAB/Data/Flux/CPEC/Met' site '/HH_fluxes/']);

    %%% Calculated OPEC Variables path
    calc_path = ([data_loc 'MATLAB/Data/Flux/OPEC/Calculated5/Met' site '/Met' site '_' yr '_']);
    calc_path_met = ([data_loc 'MATLAB/Data/Met/Calculated4/Met' site '/Met' site '_' yr '_']);

    %%% Cleaned OPEC Variables path
    clean_path = ([data_loc 'MATLAB/Data/Flux/OPEC/Cleaned3/Met' site '/Met' site '_' yr '_']);

    %%% Path for filled OPEC variables
    filled_path = ([data_loc 'MATLAB/Data/Flux/OPEC/Filled4/Met' site '/Met' site '_' yr '_']);
filled_met_path = ([data_loc 'MATLAB/Data/Met/Final_Filled/TP' site_tag '/TP' site_tag '_' yr]); 
    %%%
    flux_path = ([data_loc 'MATLAB/Data/Data_Analysis/M' site '_allyears/']);

    %%% Path for list of variables:
    list_path = ([data_loc 'MATLAB/Data/CCP/Template/TP' site_tag '_CCP_List.csv']);

    %%% Path for threshold files:
    thresh_path = ([data_loc 'MATLAB/Data/CCP/threshold/']);

    %% Load Header Files
    %%% Tracker for Processed Met Files
    [hdr_cell_metproc] = jjb_hdr_read(hdr_path_metproc,',',3);
    %%% Tracker for Master Flux and Master Met Files
    [hdr_cell_flux]  = jjb_hdr_read(hdr_path_master,',',2);
    %%% Tracker for Processed OPEC Files
    [hdr_cell_OPEC] = jjb_hdr_read(hdr_path_OPECproc,',',2);

    %% Sort out time variables:
    %%% load timevector:
    % tv = load([data_loc 'MATLAB/Data/Met/Organized2/Met' site '/Column/30min/Met' site '_' yr '.tv']);
    tv = make_tv(str2num(yr),30);
    [year JD HHMM dt]  = jjb_makedate(str2double(yr),30);

    dates = datevec(tv);    % Make datevec from TV
    dates(2:length(dates),2:3) = dates(1:length(dates)-1,2:3);  % Shift 1 spot to make 0030 first entry for each day

    month = dates(:,2);       % Pick out Month Column
    day = dates(:,3);       % Pick out day column
    hour = dates(:,4);
    minute = dates(:,5);




    %% Make Blank Variables:
    %%% Flux:
    FC(1:length(dt),1) = NaN; CO2_top(1:length(dt),1) = NaN; CO2_cpy(1:length(dt),1) = NaN; CO2_bot(1:length(dt),1) = NaN;
    H(1:length(dt),1) = NaN; H_filled(1:length(dt),1) = NaN; LE(1:length(dt),1) = NaN; LE_filled(1:length(dt),1) = NaN;
    ustar(1:length(dt),1) = NaN; H2O(1:length(dt),1) = NaN; SFC(1:length(dt),1) = NaN; G0(1:length(dt),1) = NaN; Jt(1:length(dt),1) = NaN;
    NEP(1:length(dt),1) = NaN; NEP_filled(1:length(dt),1) = NaN; GEP_filled(1:length(dt),1) = NaN; R_filled(1:length(dt),1) = NaN;
    APAR(1:length(dt),1) = NaN; FPAR(1:length(dt),1) = NaN; ZL(1:length(dt),1) = NaN;
    %%% Met:
    Rn(1:length(dt),1) = NaN; SW_down(1:length(dt),1) = NaN; SW_up(1:length(dt),1) = NaN; LW_down(1:length(dt),1) = NaN;
    LW_up(1:length(dt),1) = NaN; PAR_down_top(1:length(dt),1) = NaN; PAR_reflected_top(1:length(dt),1) = NaN; PAR_down_bot(1:length(dt),1) = NaN;
    Rn_bot(1:length(dt),1) = NaN; Tair_top(1:length(dt),1) = NaN; Tair_cpy(1:length(dt),1) = NaN; Tair_bot(1:length(dt),1) = NaN;
    RH_top(1:length(dt),1) = NaN; RH_cpy(1:length(dt),1) = NaN; RH_bot(1:length(dt),1) = NaN;
    WS(1:length(dt),1) = NaN; Wdir(1:length(dt),1) = NaN; APR(1:length(dt),1) = NaN; PPT(1:length(dt),1) = NaN;

    Ts2a(1:length(dt),1) = NaN; Ts2b(1:length(dt),1) = NaN; Ts5a(1:length(dt),1) = NaN; Ts5b(1:length(dt),1) = NaN;
    Ts10a(1:length(dt),1) = NaN; Ts10b(1:length(dt),1) = NaN; Ts20a(1:length(dt),1) = NaN; Ts20b(1:length(dt),1) = NaN;
    Ts50a(1:length(dt),1) = NaN; Ts50b(1:length(dt),1) = NaN; Ts100a(1:length(dt),1) = NaN; Ts100b(1:length(dt),1) = NaN;

    SM5a(1:length(dt),1) = NaN; SM5b(1:length(dt),1) = NaN; SM10a(1:length(dt),1) = NaN; SM10b(1:length(dt),1) = NaN;
    SM20a(1:length(dt),1) = NaN; SM20b(1:length(dt),1) = NaN; SM50a(1:length(dt),1) = NaN; SM50b(1:length(dt),1) = NaN;
    SM100a(1:length(dt),1) = NaN; SM100b(1:length(dt),1) = NaN;

    SHF1(1:length(dt),1) = NaN; SHF2(1:length(dt),1) = NaN;

    % TC1(1:length(dt),1) = NaN; TC2(1:length(dt),1) = NaN; TC3(1:length(dt),1) = NaN; TC4(1:length(dt),1) = NaN; TC5(1:length(dt),1) = NaN; TC6(1:length(dt),1) = NaN;
    %% Load Flux variables

    if site == '1'
        outm = 'output_model4_';
    else
        outm = 'output_model3_';
    end
    
    NEE = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'NEEclean.dat']);
    NEP = NEE.*-1;
    if strcmp(site,'1') == 1;

    flux_vars = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\Output\TP' site_tag '_' yr '_Flux_Results.dat']);
NEP_filled = flux_vars(:,1);
    GEP_filled = flux_vars(:,3);
    R_filled = flux_vars(:,2);
        clear flux_vars;
    else
    flux_vars = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\Output\' 'M' site outm yr '.dat']);
    
    NEP_filled = flux_vars(:,3);
    GEP_filled = flux_vars(:,5);
    R_filled = flux_vars(:,4);
    clear flux_vars;
    
    end
        

    if site  == '1'
        ET_vars = load([flux_path 'M' site '_ETEB_output_' yr '.dat']);
        LE_filled = ET_vars(:,1);
        H_filled = ET_vars(:,2);
        clear ET_vars;
    else
        LE_filled = NaN.*ones(length(dt),1);
        H_filled =  NaN.*ones(length(dt),1);
    end


    switch flux_source

        %%%%%%%%%%% For case where flux files are to be loaded from the master files
        case 'master'
            FC = jjb_load_var(hdr_cell_flux, load_path_master, 'CO2Flux_Top');
            H = jjb_load_var(hdr_cell_flux, load_path_master, 'SensibleHeatFlux'); %%% Sensible Heat Flux
            LE = jjb_load_var(hdr_cell_flux, load_path_master, 'LatentHeatFlux'); %%% Latent Heat Flux
            ustar = jjb_load_var(hdr_cell_flux, load_path_master, 'UStar');
            if site == '1'

                H2O = jjb_load_var(hdr_cell_flux, load_path_master,'H2O_AbvCnpy');
            else
                H2O = jjb_load_var(hdr_cell_flux, load_path_master,'LI_H2O_Abv_Cnpy');
            end

            %         CO2_top = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_AbvCnpy');
            %         CO2_cpy = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_Cnpy');
            %         if site =='1';
            %         CO2_bot = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_BlwCnpy');
            %         end
            try
            SFC = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'dcdt_2h.dat']); %% use filled or raw????
            catch
            SFC = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\YP' site_tag '_' yr 'dcdt_1h.dat']); %% use filled or raw????
            end
            
            Jt = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'Jt.dat']);
            
            G0 = load(['C:\HOME\MATLAB\Data\Met\Calculated4\TP' site_tag '\TP' site_tag '_' yr 'g0.dat']);

            
            if strcmp(yr,'2006') == 1 && (site == '3' || site == '4')
                            CO2_top = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_AbvCnpy');
            CO2_cpy = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_Cnpy');
            end
                
            %         APAR =

            %         NEP = load(
            %         Pres = load([filled_path 'pres_cl.dat']);

            %%%%%%%%%%%% For case where flux files are to be loaded from the processed files
        case 'processed'

            if site == '1'
                if strcmp(year,'2005')==1;
                    FC = jjb_load_var(hdr_cell_flux, load_path_master, 'CO2Flux_Top');
                else
                    FC = load([load_path_CPECproc 'Fc' yr(3:4) '.dat']);
                end
                ustar = load([load_path_CPECproc 'ustr' yr(3:4) '.dat']);
                H = load([load_path_CPECproc 'Hs' yr(3:4) '.dat']);
                LE = load([load_path_CPECproc 'LE' yr(3:4) '.dat']);
                H2O = load([load_path_CPECproc 'H2O' yr(3:4) '.dat']);

                %             CO2_top = load([load_path_CPECproc 'CO2' yr(3:4) '.dat']);
                %             CO2_cpy = jjb_load_var(hdr_cell_metproc, load_path_metproc,'CO2_Cnpy');
                %             if site =='1';
                %             CO2_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc,'CO2_BlwCnpy');
                %             end
            try
            SFC = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'dcdt_2h.dat']); %% use filled or raw????
            catch
            SFC = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'dcdt_1h.dat']); %% use filled or raw????
            end
            
            Jt = load(['C:\HOME\MATLAB\Data\Flux\Final_Calculated\TP' site_tag '\TP' site_tag '_' yr 'Jt.dat']);
            
            G0 = load(['C:\HOME\MATLAB\Data\Met\Calculated4\TP' site_tag '\TP' site_tag '_' yr 'g0.dat']);
                %             Pres = load([filled_path 'pres_cl.dat']);

            else
                FC = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc, 'Fc_wpl');
                ustar = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc, 'u_star');
                H = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc, 'Hs'); %%% Sensible Heat Flux
                LE = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc, 'LE_wpl'); %%% Latent Heat Flux
                H2O = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc, 'h2o_Avg'); %%% Latent Heat Flux

try
                CO2_top = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc,'co2_Avg');
                CO2_cpy = jjb_load_var(hdr_cell_OPEC, load_path_OPECproc,'co2stor_Avg');
catch
            CO2_top = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_AbvCnpy');
            CO2_cpy = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_Cnpy');
end     
                
                SFC = load([calc_path 'dcdt_2h_cleaned.dat']);
                Jt = load([calc_path 'Jt.dat']);
                G0 = load([calc_path_met 'g0.dat']);
                %             Pres = load([filled_path 'pres_cl.dat']);

            end


    end


    %% Load Met Variables
    PPT(1:length(dt),1) = NaN;

    switch met_source
        case 'master'
            Rn = jjb_load_var(hdr_cell_flux, load_path_master, 'NetRad_AbvCnpy');

            PAR_down_top = jjb_load_var(hdr_cell_flux, load_path_master, 'DownPAR_AbvCnpy');
            PAR_reflected_top = jjb_load_var(hdr_cell_flux, load_path_master, 'UpPAR_AbvCnpy');
            PAR_down_bot = jjb_load_var(hdr_cell_flux, load_path_master, 'DownPAR_BlwCnpy');

            Tair_top = jjb_load_var(hdr_cell_flux, load_path_master, 'AirTemp_AbvCnpy');


            RH_top = jjb_load_var(hdr_cell_flux, load_path_master, 'RelHum_AbvCnpy');

            WS = jjb_load_var(hdr_cell_flux, load_path_master, 'WindSpd');
            Wdir = jjb_load_var(hdr_cell_flux, load_path_master, 'WindDir');
            try 
                APR = load([filled_met_path '.APR']);
            catch
             APR = jjb_load_var(hdr_cell_flux, load_path_master, 'Pressure');
            end
            
            PPT = jjb_load_var(hdr_cell_flux, load_path_master, 'Precipitation');

            %         if strcmp(yr,2005) == 1;
            %         CO2_top = load([load_path_CPECproc 'CO2' yr(3:4) '.dat']);
            %         else

            CO2_top = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_AbvCnpy');


            %         end

            CO2_cpy = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_Cnpy');
            if site =='1';
                CO2_bot = jjb_load_var(hdr_cell_flux, load_path_master,'CO2_BlwCnpy');
            end

            if site == '1'

                RH_cpy = jjb_load_var(hdr_cell_flux, load_path_master, 'RelHum_Cnpy');
                RH_bot = jjb_load_var(hdr_cell_flux, load_path_master, 'RelHum_BlwCnpy');
                Tair_bot = jjb_load_var(hdr_cell_flux, load_path_master, 'AirTemp_BlwCnpy');
                Tair_cpy = jjb_load_var(hdr_cell_flux, load_path_master, 'AirTemp_Cnpy');
                SW_down = jjb_load_var(hdr_cell_flux, load_path_master, 'DownShortwaveRad');
                SW_up = jjb_load_var(hdr_cell_flux, load_path_master, 'UpShortwaveRad');
                if strcmp(yr,'2005') ==1
                    LW_down = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownLongwaveRad_AbvCnpy');
                    LW_up = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'UpLongwaveRad_AbvCnpy');
                else

                    LW_down = jjb_load_var(hdr_cell_flux, load_path_master, 'DownLongwaveRad');
                    LW_up = jjb_load_var(hdr_cell_flux, load_path_master, 'UpLongwaveRad');
                end
                Rn_bot = jjb_load_var(hdr_cell_flux, load_path_master, 'NetRad_BlwCnpy');
            end


            %         if site == '1'
            %         RHc = jjb_load_var(hdr_cell_flux, load_path_master, 'RelHum_Cnpy');
            % %         else
            % %             RHc(1:length(RH),1) = NaN;
            %         end
            %         if exist([calc_path_met 'Ts.dat'])
            %             Ts = load([calc_path_met 'Ts.dat']);
            %         end
            if site == '1' && strcmp(yr,'2005') == 1
                Ts2a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_2cm');
                Ts2b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_2cm');
                Ts5a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_5cm');
                Ts5b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_5cm');
                Ts10a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_10cm');
                Ts10b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_10cm');
                Ts20a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_20cm');
                Ts20b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_20cm');
                Ts50a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_50cm');
                Ts50b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_50cm');
                Ts100a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_100cm');
                Ts100b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_100cm');


            else

                Ts2a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_2cm');
                Ts2b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_2cm');
                Ts5a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_5cm');
                Ts5b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_5cm');
                Ts10a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_10cm');
                Ts10b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_10cm');
                Ts20a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_20cm');
                Ts20b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_20cm');
                Ts50a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_50cm');
                Ts50b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_50cm');
                Ts100a = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_A_100cm');
                Ts100b = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilTemp_B_100cm');

            end

            SM5a = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_A_5cm');
            SM5b = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_B_5cm');
            SM10a = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_A_10cm');
            SM10b = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_B_10cm');
            SM20a = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_A_20cm');
            SM20b = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_B_20cm');
            SM50a = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_A_50cm');
            SM50b = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_B_50cm');
            SM100a = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_A_100cm');
            SM100b = jjb_load_var(hdr_cell_flux, load_path_master, 'SM_B_100cm');

            if site == '1'
                try
                    SHF1 = load([load_path_master 'shf1']);
                    SHF2 = load([load_path_master 'shf2']);

                catch
                    try
                        SHF1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_HFT_1');
                        SHF2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_HFT_2');

                    catch
                    end
                end
            else

                SHF1 = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilHeatFlux_1');
                SHF2 = jjb_load_var(hdr_cell_flux, load_path_master, 'SoilHeatFlux_2');

            end




            if site == '2'
                %% Load Tree Thermocouple data for Met 2:
                TC1 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree1_maxBN');
                TC2 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree2_maxBC');
                TC3 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree3_maxBS');
                TC4 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree4_medBN');
                TC5 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree5_medBQN');
                TC6 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree6_medBC');
                TC7 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree7_medBQS');
                TC8 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree8_medBS');
                TC9 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree9_minBN');
                TC10 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree10_minBC');
                TC11 = jjb_load_var(hdr_cell_flux, load_path_master, 'TreeTemp_Tree11_minBS');

            elseif site =='1'
                try
                    TC1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree1_20CmaxBN');
                    TC2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree2_20CmaxBC');
                    TC3 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree3_20CmaxBS');
                    TC4 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree4_30CmaxTN');
                    TC5 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree5_20CmaxTC');
                    TC6 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree6_30CmaxTS');
                    TC7 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree7_19BmedBN');
                    TC8 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree8_19Bmed');
                    TC9 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree9_19BmedBC');
                    TC10 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree10_19BmedBS');
                    TC11 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree11_19BmedBQS');
                    TC12 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree12_29BmedTN');
                    TC13 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree13_29BmedTQN');
                    TC14 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree14_29BmedTC');
                    TC15 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree15_29BmedTS');
                    TC16 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree16_29BmedTQS');
                    TC17 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree17_17minBH');
                    TC18 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree18_17minBC');
                    TC19 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree19_17minBS');
                    TC20 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree20_27AminTN');
                    TC21 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree21_27Amin');
                    TC22 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree22_27Amin');

                catch
                    TC1(1:length(dt),1) = NaN; TC2(1:length(dt),1) = NaN; TC3(1:length(dt),1) = NaN; TC4(1:length(dt),1) = NaN;
                    TC5(1:length(dt),1) = NaN; TC6(1:length(dt),1) = NaN; TC7(1:length(dt),1) = NaN; TC8(1:length(dt),1) = NaN;
                    TC9(1:length(dt),1) = NaN; TC10(1:length(dt),1) = NaN; TC11(1:length(dt),1) = NaN; TC12(1:length(dt),1) = NaN;
                    TC13(1:length(dt),1) = NaN; TC14(1:length(dt),1) = NaN; TC15(1:length(dt),1) = NaN; TC16(1:length(dt),1) = NaN;
                    TC17(1:length(dt),1) = NaN; TC18(1:length(dt),1) = NaN; TC19(1:length(dt),1) = NaN; TC20(1:length(dt),1) = NaN;
                    TC21(1:length(dt),1) = NaN; TC22(1:length(dt),1) = NaN;

                end
            end




        case 'processed'
            %%%
            Rn = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'NetRad_AbvCnpy'); %%% Net Radiation

            PAR_down_top = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownPAR_AbvCnpy');
            PAR_reflected_top = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'UpPAR_AbvCnpy');


            try
                PAR_down_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownPAR_BlwCnpy');
            catch
                PAR_down_bot = NaN.*ones(length(dt),1);
            end
            Tair_top = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'AirTemp_AbvCnpy');

            RH_top = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'RelHum_AbvCnpy');

            WS = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'WindSpd');
            Wdir = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'WindDir');

            if site == '1'
                Tair_cpy = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'AirTemp_Cnpy');
                Tair_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'AirTemp_BlwCnpy');
                RH_cpy = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'RelHum_Cnpy');
                RH_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'RelHum_BlwCnpy');
                SW_down = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownShortwaveRad');
                SW_up = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'UpShortwaveRad');
                LW_down = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'DownLongwaveRad_AbvCnpy');
                LW_up = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'UpLongwaveRad_AbvCnpy');
                Rn_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'NetRad_BlwCnpy');

                CO2_top = load([load_path_CPECproc 'CO2' yr(3:4) '.dat']);
                CO2_cpy = jjb_load_var(hdr_cell_metproc, load_path_metproc,'CO2_Cnpy');
                if site =='1';
                    CO2_bot = jjb_load_var(hdr_cell_metproc, load_path_metproc,'CO2_BlwCnpy');
                end


                if strcmp(yr, '2007') == 1;
                    PPTa = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'RMY_Rain');
                    PPTb = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'CS_Rain'); % M1 - RMY_Rain, CS_Rain %M4 - Rain
                    PPT = [PPTa(1:9150); PPTb(9151:17520)];

                else
                    PPT = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'RMY_Rain');
                end
            elseif site == '4'
                PPT = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'Rain');
            end

            if site == '1'
            try 
                APR = load([filled_met_path '.APR']);
            catch
                APR = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'Pressure');
            end
            else
               try 
                APR = load([filled_met_path '.APR']);
            catch

                APR = load([filled_path 'pres_cl.dat']);
               end
            end
            %% Soil Temp
            Ts2a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_2cm');
            Ts2b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_2cm');
            Ts5a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_5cm');
            Ts5b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_5cm');
            Ts10a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_10cm');
            Ts10b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_10cm');
            Ts20a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_20cm');
            Ts20b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_20cm');
            Ts50a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_50cm');
            Ts50b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_50cm');
            Ts100a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_A_100cm');
            Ts100b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilTemp_B_100cm');
            %% Soil Moisture
            SM5a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_A_5cm');
            SM5b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_5cm');
            SM10a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_A_10cm');
            SM10b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_10cm');
            SM20a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_A_20cm');
            SM20b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_20cm');
            SM50a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_A_50cm');
            SM50b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_50cm');
            try
                SM100a = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_A_100cm');

            catch
                SM100a = NaN.*ones(length(dt),1);
            end


            try
                SM100b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_100cm');
            catch
                try
                    SM100b = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SM_B_80-100cm');
                catch
                    SM100b = NaN.*ones(length(dt),1);
                end
            end


            %% Soil Heat Flux Plates
            if site == '1'
                SHF1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_HFT_1');
                SHF2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_HFT_2');

            else
                SHF1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_1');
                SHF2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'SoilHeatFlux_2');
            end

            %% Tree TCs
            if site == '2'
                %% Load Tree Thermocouple data for Met 2:
                TC1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree1_maxBN');
                TC2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree2_maxBC');
                TC3 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree3_maxBS');
                TC4 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree4_medBN');
                TC5 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree5_medBQN');
                TC6 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree6_medBC');
                TC7 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree7_medBQS');
                TC8 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree8_medBS');
                TC9 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree9_minBN');
                TC10 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree10_minBC');
                TC11 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree11_minBS');

            elseif site == '1'
                TC1 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree1_20CmaxBN');
                TC2 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree2_20CmaxBC');
                TC3 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree3_20CmaxBS');
                TC4 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree4_30CmaxTN');
                TC5 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree5_20CmaxTC');
                TC6 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree6_30CmaxTS');
                TC7 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree7_19BmedBN');
                TC8 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree8_19Bmed');
                TC9 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree9_19BmedBC');
                TC10 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree10_19BmedBS');
                TC11 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree11_19BmedBQS');
                TC12 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree12_29BmedTN');
                TC13 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree13_29BmedTQN');
                TC14 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree14_29BmedTC');
                TC15 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree15_29BmedTS');
                TC16 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree16_29BmedTQS');
                TC17 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree17_17minBH');
                TC18 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree18_17minBC');
                TC19 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree19_17minBS');
                TC20 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree20_27AminTN');
                TC21 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree21_27Amin');
                TC22 = jjb_load_var(hdr_cell_metproc, load_path_metproc, 'TreeTemp_Tree22_27Amin');

            end
    end

    %
    % %% Prepare the headers for each file:
    %
    % [hdr_cell_output] = jjb_hdr_read([data_loc 'MATLAB/Data/CCP/TP' site_tag '_OutputTemplate.csv'],',',2);
    %
    % hdr_cell_output = hdr_cell_output';
    %
    % hdr_cell_output(3:17522,1) = (k);
    % % line1 = char(hdr_cell_output(1,:));

    switch site
        case '1'
            %% Columns 1 - 10    1        2      3       4        5         6     7          8           9          10
            output = [          year    month   day     hour    minute      dt   NEP     GEP_filled  R_filled    NEP_filled];
            %% Columns 11 - 20
            output = [output    FC      CO2_top CO2_cpy CO2_bot SFC         LE   H       LE_filled   H_filled    ustar ];
            %% Columns 21 - 30
            output = [output    H2O     Jt      G0      APAR    FPAR        ZL   Rn      Rn_bot      SW_down     SW_up  ];
            %% Columns 31 - 40
            output = [output    LW_down LW_up   PAR_down_top PAR_reflected_top PAR_down_bot Tair_top Tair_cpy Tair_bot RH_top RH_cpy];
            %% Columns 41 - 50
            output = [output    RH_bot  WS      Wdir    APR     PPT         Ts2a  Ts5a   Ts10a       Ts20a          Ts50a];
            %% Columns 51 - 60
            output = [output    Ts100a  Ts2b   Ts5b     Ts10b  Ts20b        Ts50b Ts100b SM5a        SM10a          SM20a];
            %% Columns 61 - 70
            output = [output    SM50a   SM100a SM5b     SM10b  SM20b        SM50b SM100b SHF1       SHF2            TC1];
            %% Columns 71 - 80
            output = [output     TC2    TC3     TC4     TC5    TC6           TC7  TC8    TC9         TC10           TC11];
            %% Columns 81 - 90
            output = [output    TC12    TC13    TC14     TC15    TC16      TC17     TC18    TC19   TC20   TC21  ];
            %% Columns 91 - 100
            output = [output     TC22 ];



        case '2'
            %% Columns 1 - 10
            output = [          year    month   day     hour    minute      dt   NEP     GEP_filled  R_filled    NEP_filled];
            %% Columns 11 - 20
            output = [output    FC      CO2_top CO2_cpy SFC         LE   H       LE_filled   H_filled    ustar   H2O];
            %% Columns 21 - 30
            output = [output    Jt      G0      APAR    FPAR        ZL   Rn      PAR_down_top PAR_reflected_top PAR_down_bot Tair_top   ];
            %% Columns 31 - 40
            output = [output    RH_top  WS      Wdir    APR     PPT         Ts2a  Ts5a   Ts10a       Ts20a          Ts50a];
            %% Columns 41 - 50
            output = [output    Ts100a  Ts2b   Ts5b     Ts10b  Ts20b        Ts50b Ts100b SM5a        SM10a          SM20a];
            %% Columns 51 - 60
            output = [output    SM50a   SM100a SM5b     SM10b  SM20b        SM50b SM100b SHF1        SHF2           TC1];
            %% Columns 61 - 70
            output = [output    TC2     TC3     TC4     TC5    TC6           TC7     TC8  TC9        TC10            TC11];


        case '3'
            %% Columns 1 - 10
            output = [          year    month   day     hour    minute      dt   NEP     GEP_filled  R_filled    NEP_filled];
            %% Columns 11 - 20
            output = [output    FC      CO2_top CO2_cpy SFC         LE   H       LE_filled   H_filled    ustar   H2O];
            %% Columns 21 - 30
            output = [output    Jt      G0      APAR    FPAR        ZL   Rn      PAR_down_top PAR_reflected_top PAR_down_bot Tair_top   ];
            %% Columns 31 - 40
            output = [output    RH_top  WS      Wdir    APR     PPT         Ts2a  Ts5a   Ts10a       Ts20a          Ts50a];
            %% Columns 41 - 50
            output = [output    Ts100a  Ts2b   Ts5b     Ts10b  Ts20b        Ts50b Ts100b SM5a        SM10a          SM20a];
            %% Columns 51 - 60
            output = [output    SM50a   SM100a SM5b     SM10b  SM20b        SM50b SM100b SHF1       SHF2            ];


        case '4'
            %% Columns 1 - 10
            output = [          year    month   day     hour    minute      dt   NEP     GEP_filled  R_filled    NEP_filled];
            %% Columns 11 - 20
            output = [output    FC      CO2_top CO2_cpy SFC         LE   H       LE_filled   H_filled    ustar   H2O];
            %% Columns 21 - 30
            output = [output    Jt      G0      APAR    FPAR        ZL   Rn      PAR_down_top PAR_reflected_top PAR_down_bot Tair_top   ];
            %% Columns 31 - 40
            output = [output    RH_top  WS      Wdir    APR     PPT         Ts2a  Ts5a   Ts10a       Ts20a          Ts50a];
            %% Columns 41 - 50
            output = [output    Ts100a  Ts2b   Ts5b     Ts10b  Ts20b        Ts50b Ts100b SM5a        SM10a          SM20a];
            %% Columns 51 - 60
            output = [output    SM50a   SM100a SM5b     SM10b  SM20b        SM50b SM100b SHF1       SHF2            ];
    end

    %% Final Check on data:
    [rows cols] = size(output);

    %%% Tracker for Processed Met Files
    [var_list] = jjb_hdr_read(list_path,',',2);

    %%% Title of variable
    var_names = char(var_list(:,1));

    if exist([data_loc 'MATLAB/Data/CCP/threshold/Met' site '_flags_' yr '.dat'])
        flagfile = load([data_loc 'MATLAB/Data/CCP/threshold/Met' site '_flags_' yr '.dat']);
        disp('loading flag file');
    else
        flagfile = ones(cols,1);
        disp('flag file not found.. loading it you dork');
    end
    numnans = NaN*ones(cols,1);



    %% Clean Errors from the Met data:


    %% Load Threshold file -- If it does not exist, start creating one
    if exist([thresh_path 'Met' site '_thresh_' yr '.dat'])==2
        thresh = load([thresh_path 'Met' site '_thresh_' yr '.dat']);
        threshflag = 1;
        thresh_out_flag = 1;
        disp('Threshold file exists: Uploading');

    else
        thresh(1:cols,1:2) = NaN;

        threshflag = 0;
        thresh_out_flag = 0;
        disp('Threshold file does not exist. A new one will be made now');
    end

    %%
    for k = 7:1:cols
        if flagfile(k,1) == 1;
            accept = 1;

            figure(1); clf
            plot(output(:,k)); hold on
            title(var_names(k,:));
            switch threshflag
                case 1
                    %%% Load lower and upper limits
                    low_lim = thresh(k,1);
                    up_lim = thresh(k,2);

                case 0

                    %%% Load lower and upper limits
                    low_lim_str = input('Enter Lower Limit: ', 's');
                    low_lim = str2double(low_lim_str);

                    up_lim_str = input('Enter Upper Limit: ', 's');
                    up_lim = str2double(up_lim_str);

                    %%% Write new values to thresh matrix

                    thresh(k,1) = low_lim;
                    thresh(k,2) = up_lim;
            end


            %%% Plot lower limit
            line([1 length(output(:,k))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
            %%% Plot upper limit
            line([1 length(output(:,k))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')

            %% Gives the user a chance to change the thresholds
            response = input('Press enter to accept, "1" to enter new thresholds: ', 's');

            if isempty(response)==1
                accept = 1;

            elseif isequal(str2double(response),1)==1;
                accept = 0;
                disp('fix this variable');
                thresh_out_flag = 0;
            end
            %%
            while accept == 0;
                %%% New lower limit
                low_lim_new = input('enter new lower limit: ','s');
                low_lim = str2double(low_lim_new);
                thresh(k,1) = low_lim;

                %%% New upper limit
                up_lim_new = input('enter new upper limit: ','s');
                up_lim = str2double(up_lim_new);
                thresh(k,2) = up_lim;
                %%% plot again
                figure (1)
                clf;
                plot(output(:,k))
                hold on
                %%% Plot lower limit
                line([1 length(output(:,k))],[low_lim low_lim],'Color',[1 0 0], 'LineStyle','--')
                %%% Plot lower limit
                line([1 length(output(:,k))],[up_lim up_lim],'Color',[1 0 0], 'LineStyle','--')

                %         axis([1   length(temp_var)    low_lim-2*abs(low_lim)     up_lim+2*abs(up_lim)]);
                title(var_names(k,:));



                accept_resp = input('hit enter to accept, 1 to change again: ','s');
                if isempty(accept_resp)
                    accept = 1;
                else
                    accept = 0;
                end
            end


            %%

            output(output(:,k) > up_lim | output(:,k) < low_lim,k) = NaN;
        else
            output(output(:,k) > thresh(k,2) | output(:,k) < thresh(k,1),k) = NaN;
        end

        %%% Save threshold file
        save([thresh_path 'Met' site '_thresh_' yr '.dat'],'thresh','-ASCII');

    end


    %% Final Changes to data:
    switch site
        case '1'
            switch yr
                case '2007'
                    output(2758:2812,37:38) = NaN; % clean Ta14m&Ta2m for bad data
                    %                 output(7625:7659,50) = NaN; % clean Ts50cmA for bad data
                    output(7625:7659,52) = NaN; % clean Ts2cmB for bad data
                    %                 output(7625:7659,56) = NaN; % clean Ts50cmB for bad data
                    % Fix a switch in SM sensors between 5 and 20cm
                    %                 SM5Btemp = output(7626:17520,65); SM20Btemp = output(7626:17520,63);
                    %                 output(7626:17520,63) = SM5Btemp; output(7626:17520,65) = SM20Btemp;
                    bn = (7626:1:7658);
                    Ts2Atemp = NaN.*ones(length(bn),1); Ts5Atemp = output(bn,49); Ts20Atemp = output(bn,48); Ts50Atemp = output(bn,46); Ts100Atemp = output(bn,47);
                    Ts100Btemp = output(bn,51); Ts10Atemp = output(bn,50);

                    output(bn,47) = Ts5Atemp; output(bn,49) = Ts20Atemp;
                    output(bn,50) = Ts50Atemp; output(bn,51) = Ts100Atemp; output(bn,48) = Ts10Atemp;
                    %
                    Ts2Btemp = output(bn,53); Ts5Btemp = output(bn,54); Ts10Btemp = output(bn,55); Ts20Btemp = output(bn,56); Ts100Atemp = output(bn,47);
                    Ts50Btemp = output(bn,57);
                    output(bn,52) = Ts2Btemp; output(bn,53) = Ts5Btemp; output(bn,54) = Ts10Btemp; output(bn,55) = Ts20Btemp; output(bn,57) = Ts100Btemp; output(bn,56) = Ts50Btemp;
                    %
                    SM5Atemp = NaN.*ones(length(bn),1); SM10Atemp = output(bn,58); SM20Atemp = output(bn,59); SM50Atemp = output(bn,60); SM100Atemp = output(bn,61);
                    output(bn,58) = SM5Atemp; output(bn,59) = SM10Atemp; output(bn,60) = SM20Atemp; output(bn,61) = SM50Atemp;  output(bn,62) = SM100Atemp;

                    SM10Btemp = output(bn,63);SM50Btemp = output(bn,64); SM5Btemp = output(bn,65);SM20Btemp = NaN.*ones(length(bn),1);
                    output(bn,63) = SM5Btemp; output(bn,64) = SM10Btemp; output(bn,65) = SM20Btemp; output(bn,66) = SM50Btemp;

                    output(1:8200,67) = NaN; % SM probe -- before it was installed properly.
                    output(output(:,39)>100,39) = 100; output(output(:,40)>100,40) = 100; output(output(:,41)>100,41) = 100;
                    %%% Deletions and offset adjustments to CPEC concentration data:
                    output(469:944,12) = output(469:944,12)+113.53; %removes offset in CPEC CO2 conc due to filter change
                    output(457:479,12) =  NaN;
                    output(8138:8178,12) = output(8138:8178,12) -92.25;
                    output(2478:2480,12) =  NaN;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,33) < 10,33) = 0;
                    






                case '2006'
                    %                 SM20Atemp = output(:,58);SM10Atemp = output(:,59);
                    %                 output(:,59) = SM10Atemp; output(:,60) = SM20Atemp;
                    %                 output(:,61) = SM50Atemp;
                    % Remove obvious bad data in PAR down blw cnpy
                    output(12250:12600,35) = NaN;
                    output(:,75:80)= NaN; output(:,82:85)= NaN; output(:,89:90)= NaN;
                    output(12284:17520,69:91) = NaN;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,33) < 10,33) = 0;


                case '2005'
                    output(9985:10000,50) = NaN; output(9985:10000,52) = NaN; output(9985:10000,56) = NaN;
                    output(9985:10000,61) = NaN; output(9985:10000,63) = NaN; output(10000,69) = NaN;
                    output(11741,21) = NaN; output(15554:15782,39) = NaN; output(9985:10000,56) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,33) < 10,33) = 0;

                case '2004'
                    output(:,23) = output(:,23)./3.5; %% shrink the G0 data
                    %%% Deletions and offset adjustments to CPEC concentration data:
                    output(800:1327,12) = output(800:1327,12) - 38.8;
                    output(1:799,12) = output(1:799,12) - (38.8+15);
                    output(14963:16013,12) = output(14963:16013,12) +51.92;

                    output(1:1369,13) = output(1:1369,13) - 44.2;
                    output(8134:9724,13) = output(8134:9724,13) - 84.67;
                    output(16793:17222,13) = output(16793:17222,13) - 81;
                    output(16777:16792,13) = output(16777:16792,13) - 42.35;

                    output(1:9725,14) = output(1:9725,14) + 34.3;
                    output(3627:6744,14) = output(3627:6744,14) + 17.41;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,33) < 10,33) = 0;



                case '2003'
                    output(:,14) = NaN;
                    SM10Btemp = output(:,63); SM5Btemp = output(:,64);
                    output(:,63) = SM5Btemp; output(:,64) = SM10Btemp;
                    output(8874:9196,58:67) = NaN; output(9297:9732,58:67) = NaN;
                    %%% Deletions and offset adjustments to CPEC concentration data:
                    output(:,12) = output(:,12) - 31;

                    output(7766:17520,13) = output(7766:17520,13) - 44.2;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,33) < 10,33) = 0;
                    output(output(:,44)==99,44) = NaN;

            end
            %%
        case '2'
            switch yr
                case '2003'

                    SM5Btemp = output(:,56);SM50Btemp = output(:,53);
                    Ts2Btemp = output(:,43);Ts5Btemp = output(:,42);
                    output(1:17520,42) = Ts2Btemp;
                    output(1:17520,43) = Ts5Btemp;
                    output(1:17520,53) = SM5Btemp;
                    output(1:17520,56) = SM50Btemp;
                    CO2_15m = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_15m;

                    %%% Deletions and offset adjustments to OPEC data:
                    output(319:3668,12) = output(319:3668,12)+15;
                    output(3683:4407,12) = output(3683:4407,12)+42;
                    output(4971:7124,12) = output(4971:7124,12)+42;
                    output(7125:17520,12) = output(7125:17520,12)-52;

                    output(1:549,13) = output(1:549,13)+30.1;
                    output(661:985,13) = output(661:985,13)+35.1;
                    output(1345:2711,13) = output(1345:2711,13)+49.0;
                    output(3189:4407,13) = output(3189:4407,13)+66.9;
                    output(4970:5210,13) = output(4970:5210,13)+72.5;
                    output(5798:6055,13) = output(5798:6055,13)+62.9;
                    output(8722:9001,13) = output(8722:9001,13)-53.6;
                    output(9301:10199,13) = NaN;
                    output(10207:17520,13) = output(10207:17520,13)-53.6;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;



                case '2004'
                    output(17456:17492,22) = NaN;
                    output(17456:17492,36:47) = NaN;
                    %                 output(17456:17492,58:59) = NaN;

                    output(17527:17568,22) = NaN;
                    output(17527:17568,36:47) = NaN;
                    CO2_15m = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_15m;
                    %                 output(17527:17568,58:59) = NaN;

                    %%% Deletions and offset adjustments to OPEC data:
                    output(1:1800,12) = output(1:1800,12)-52;
                    output(1:1797,13) = output(1:1797,13)-53.6;
                    output(13509:13529,13) = NaN;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;

                case '2005'
                    Ts2Btemp = output(:,43);Ts5Btemp = output(:,44);Ts10Btemp = output(:,45);Ts20Btemp = output(:,42);
                    output(:,42) = Ts2Btemp; output(:,43) = Ts5Btemp; output(:,44) = Ts10Btemp; output(:,45) = Ts20Btemp;
                    output(4497:5738,36:47) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
                case '2006'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    %%% Deletions and offset adjustments to OPEC data:
                    output(8676:10193,13) = NaN;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
                case '2007'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    output(7849:10205,59:70) = NaN;
                    output(7855:7856,53:57) = NaN;
                    output(12656:17520,58:59) = NaN;
                    output(:,57) = NaN;
                    output(2885:3157,45) = NaN; output(3303:3710,45) = NaN; output(3841:3900,45) = NaN;
                    output(11085:11242,70) = NaN;
                    output(12382:17520,70) = NaN;
                    %%% Deletions and offset adjustments to OPEC data:
                    output(9600:9900,13) = output(9600:9900,13)-148.2;
                    output(9057:9375,13) = output(9057:9375,13)-175.8;
                    %                 output(9092:9200,13) = output(9092:9200,13)-265;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                    output(3147:3150,13) = NaN;
                    output(8589,13) = NaN;
                    output(14476:17520,13) = NaN;
                    output(9376:9590,13) = NaN;
                    output(13137:13545,13) =  output(13137:13545,13)-34;
                    %                 CO2_15m = CO2_convert(output(:,12), output(:,30), APR, 2);
                    %                 output(:,12) = CO2_15m;
                    %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
                    
            end
            %%
        case '3'
            switch yr
                case '2003'
                    CO2_15m = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_15m;
                    output(8477:8491,46) = NaN;
                    output(9190:13806,29) = NaN; % remove bad PAR down data
                    %%% Deletions and offset adjustments to OPEC data:
                    output(319:3668,12) = output(319:3668,12)+15;
                    output(3683:4407,12) = output(3683:4407,12)+42;
                    output(4971:7124,12) = output(4971:7124,12)+42;
                    output(7125:17520,12) = output(7125:17520,12)-52;

                    output(1:549,13) = output(1:549,13)+30.1;
                    output(661:985,13) = output(661:985,13)+35.1;
                    output(1345:2711,13) = output(1345:2711,13)+49.0;
                    output(3189:4407,13) = output(3189:4407,13)+66.9;
                    output(4970:5210,13) = output(4970:5210,13)+72.5;
                    output(5798:6055,13) = output(5798:6055,13)+62.9;
                    output(8722:9001,13) = output(8722:9001,13)-53.6;
                    output(9301:10199,13) = NaN;
                    output(10207:17520,13) = output(10207:17520,13)-53.6;
                    output(:,53) = output(:,53)-0.1465; % removes offset in SM5b sensor:
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;

                case '2004'
                    CO2_15m = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_15m;
                    %% Correction for offset in Ts50B for 2004.
                    output(696:3582,46) = output(696:3582,46)+34.02-3.5;

                    %%% Deletions and offset adjustments to OPEC data:
                    output(1:1800,12) = output(1:1800,12)-52;
                    output(1:1797,13) = output(1:1797,13)-53.6;
                    output(13509:13529,13) = NaN;
                    output(13509:13529,13) = NaN;
                    output(:,53) = output(:,53)-0.1465; % removes offset in SM5b sensor:
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;

                case '2005'
                    output(10042,45) = NaN;
                    % Soil Moisture probes mislabeled:
                    SM5B = output(:,55); SM10B = output(:,53); SM20B = output(:,54);
                    output(:,53) = SM5B;  output(:,54) = SM10B;  output(:,55) = SM20B;
                    output(:,53) = output(:,53)-0.1465; % removes offset in SM5b sensor:
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;

                case '2006'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    
                    output(4242:7234,34) = NaN; output(8655:11651,34) = NaN; 
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    % Soil Moisture probes mislabeled:
                    SM5B = output(:,54); SM10B = output(:,57); SM20B = output(:,53);
                    SM50B = output(:,55); SM100B = output(:,56);
                    output(:,53) = SM5B;  output(:,54) = SM10B;  output(:,55) = SM20B;
                    output(:,56) = SM50B;  output(:,57) = SM100B;
                    output(:,53) = output(:,53)-0.1465; % removes offset in SM5b sensor:


                    %%% Deletions and offset adjustments to OPEC data:
                    output(8676:10193,13) = NaN;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
                case '2007'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    output(7833,36:47) = NaN; output(7795:7796,42:47) = NaN;
                    % Soil Moisture probes mislabeled:
                    SM5Btemp = output(:,54);SM10Btemp = output(:,57);SM20Btemp = output(:,55);SM50Btemp = output(:,53); SM100Btemp = output(:,56);
                    output(:,53) = SM5Btemp;  output(:,54) = SM10Btemp;  output(:,55) = SM20Btemp;
                    output(:,56) = SM50Btemp;  output(:,57) = SM100Btemp;
                    output(:,53) = output(:,53)-0.1465; % removes offset in SM5b sensor:
                    output(4050:17520,53) = NaN;
                    output(7050:17520,29) = NaN; % removes what may be bad data from PAR 2m data:


                    %%% Deletions and offset adjustments to OPEC data:
                    output(9600:9900,13) = output(9600:9900,13)-148.2;
                    output(9057:9375,13) = output(9057:9375,13)-175.8;
                    %                 output(9092:9200,13) = output(9092:9200,13)-175.8;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                    output(3147:3150,13) = NaN;
                    output(8589,13) = NaN;
                    output(14476:17520,13) = NaN;
                    output(9376:9590,13) = NaN;
                    output(13137:13545,13) =  output(13137:13545,13)-34;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
            end
            %%
        case '4'
            switch yr
                case '2003'
                    CO2_top = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_top;
                    SM20Btemp = output(:,56);SM50Btemp = output(:,55);
                    output(:,55) = SM20Btemp;  output(:,56) = SM50Btemp;
                    %%% Deletions and offset adjustments to OPEC data:
                    output(319:3668,12) = output(319:3668,12)+15;
                    output(3683:4407,12) = output(3683:4407,12)+42;
                    output(4971:7124,12) = output(4971:7124,12)+42;
                    output(7125:17520,12) = output(7125:17520,12)-52;

                    output(1:549,13) = output(1:549,13)+30.1;
                    output(661:985,13) = output(661:985,13)+35.1;
                    output(1345:2711,13) = output(1345:2711,13)+49.0;
                    output(3189:4407,13) = output(3189:4407,13)+66.9;
                    output(4970:5210,13) = output(4970:5210,13)+72.5;
                    output(5798:6055,13) = output(5798:6055,13)+62.9;
                    output(8722:9001,13) = output(8722:9001,13)-53.6;
                    output(9301:10199,13) = NaN;
                    output(10207:17520,13) = output(10207:17520,13)-53.6;
                    output(:,59) = output(:,59).*-1;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;

                case '2004'
                    CO2_top = CO2_convert(output(:,12), output(:,30), APR, 4);
                    output(:,12) = CO2_top;
                    SM20Btemp = output(:,56);SM50Btemp = output(:,55);
                    output(:,55) = SM20Btemp;  output(:,56) = SM50Btemp;
                    Ts2Btemp_bef = output(1:5781,45); Ts5Btemp_bef = output(1:5781,44); Ts10Btemp_bef = output(1:5781,42);
                    Ts20Btemp_bef = output(1:5781,43); Ts50Btemp_bef = output(1:5781,46); Ts100Btemp_bef = output(1:5781,47);

                    Ts2Btemp_aft = output(5782:17568,45); Ts5Btemp_aft = output(5782:17568,44); Ts10Btemp_aft = output(5782:17568,46);
                    Ts20Btemp_aft = output(5782:17568,43); Ts50Btemp_aft = output(5782:17568,42); Ts100Btemp_aft = output(5782:17568,47);

                    output(:,42) = [Ts2Btemp_bef; Ts2Btemp_aft]; output(:,43) = [Ts5Btemp_bef; Ts5Btemp_aft];
                    output(:,44) = [Ts10Btemp_bef; Ts10Btemp_aft]; output(:,45) = [Ts20Btemp_bef; Ts20Btemp_aft];
                    output(:,46) = [Ts50Btemp_bef; Ts50Btemp_aft]; output(:,47) = [Ts100Btemp_bef; Ts100Btemp_aft];

                    %%% Deletions and offset adjustments to OPEC data:
                    output(1:1800,12) = output(1:1800,12)-52;
                    output(1:1797,13) = output(1:1797,13)-53.6;
                    output(13509:13529,13) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 10,27) = 0;
                case '2005'
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 20,27) = 0;
                    output(output(6235:6254,27) < 60,27) = 0;                    
                    output(output(7483:7648,27) < 60,27) = 0;                       
                    output(:,53) = NaN;
                    
                case '2006'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    output(1:7235,26) = -1.*output(1:7235,26);
                    PAR_dn_temp = output(7250:17520,28);
                    PAR_up_temp = output(7250:17520,27);
                    output(7250:17520,27) = PAR_dn_temp;
                    output(7250:17520,28) = PAR_up_temp;
                    Ts2Btemp = output(:,47); Ts5Btemp = output(:,45); Ts10Btemp = output(:,46); Ts20Btemp = output(:,43); 
                    Ts50Btemp = output(:,42); Ts100Btemp = output(:,44); 
                    output(:,42) = Ts2Btemp; output(:,43) = Ts5Btemp; output(:,44) = Ts10Btemp; 
                    output(:,45) = Ts20Btemp; output(:,46) = Ts50Btemp; output(:,47) = Ts100Btemp; 

                    SM5Btemp = output(:,56); SM10Btemp = output(:,57); 
                    output(:,53:57) = NaN;
                    output(:,53) = SM5Btemp; output(:,54) = SM10Btemp;
                    
                    %%% Deletions and offset adjustments to OPEC data:
                    output(8676:10193,13) = NaN;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 20,27) = 0;
                case '2007'
                    APR = output(:,34); APR(isnan(APR)) = 99;
                    FC = CO2_convert(output(:,11), output(:,30), APR, 2);
                    output(:,11) = FC;
                    output(7805:7824,42:47) = NaN; output(1:7824,57) = NaN;
                    
                     SM5Btemp_bef = output(1:7799,55);  SM20Btemp_bef = output(1:7799,56); 
                     output(1:7799,53) = SM5Btemp_bef; output(1:7799,55) = SM20Btemp_bef;
                     output(1:7799,54) = NaN; output(1:7799,56:57) = NaN; 
                    
                     SM5Btemp_aft = output(7800:17520,54);  SM10Btemp_aft = output(7800:17520,55); SM20Btemp_aft = output(7800:17520,56);
                     SM50Btemp_aft = output(7800:17520,57); SM100Btemp_aft = output(7800:17520,53);
                     output(7800:17520,53) = SM5Btemp_aft; output(7800:17520,54) = SM10Btemp_aft; output(7800:17520,55) = SM20Btemp_aft;
                     output(7800:17520,56) = SM50Btemp_aft; output(7800:17520,57) = SM100Btemp_aft;
                    %%% Deletions and offset adjustments to OPEC data:
                    output(9600:9900,13) = output(9600:9900,13)-148.2;
                    output(9057:9375,13) = output(9057:9375,13)-175.8;
                    %                 output(9092:9200,13) = output(9092:9200,13)-265;
                    output(1:2234,13) = NaN;
                    output(7304:8576,13) = NaN;
                    output(3147:3150,13) = NaN;
                    output(8589,13) = NaN;
                    output(14476:17520,13) = NaN;
                    output(9376:9590,13) = NaN;
                    output(13137:13545,13) =  output(13137:13545,13)-34;
                                        %%%% Move PAR bottom down to zero:
                    output(output(:,27) < 20,27) = 0;
%                     output(1:7800,53) = NaN;
            end



    end



    %% Plot data
    for i = 1:1:cols
        %     accept = 1;
        %     temp_var = load([load_path 'Met' site '_' year '.' vars30_ext(i,:)]);

        numnans(i,1) = length(find(isnan(output(:,i))));
        flagg = flagfile(i,1);
        switch flagg
            case 1
                figure(1)
                clf;
                plot(output(:,i));
                hold on;
                title([var_names(i,:) ', col: ' num2str(i)]);
                xlabel(['# NaNs: ' num2str(numnans(i,1))])


                %%% Load lower and upper limits
                response = input('Press enter to accept, "1" to not accept: ', 's');
                if isempty(response)==1
                    flagfile(i,1) = 0;
                else
                    flagfile(i,1) = 1;
                end

            case 0
        end
        clear  response;
    end

    %%% Save flagfiles:
    save([thresh_path 'Met' site '_flags_' yr '.dat'],'flagfile','-ASCII');

    %% Check soil variables
    c_list = colormap(lines(8));
% 
%     figure(2);clf
% 
%     switch site
%         case '1'
%             TsA = (46:1:51); TsB = (52:1:57); SMA = (58:1:62); SMB = (63:1:67);
%         case '2'
%             TsA = (36:1:41); TsB = (42:1:47); SMA = (48:1:52); SMB = (53:1:57);
%         case '3'
%             TsA = (36:1:41); TsB = (42:1:47); SMA = (48:1:52); SMB = (53:1:57);
%         case '4'
%             TsA = (36:1:41); TsB = (42:1:47); SMA = (48:1:52); SMB = (53:1:57);
%     end
% 
%     % Plot Pit A Ts
%     subplot(2,1,1)
%     for t = 1:1:6;  plot(output(:,TsA(t)),'-','Color',c_list(t,:));hold on; end
%     legend('2','5','10','20','50','100')
% 
%     % Plot Pit B Ts
%     subplot(2,1,2)
%     for t = 1:1:6;  plot(output(:,TsB(t)),'-','Color',c_list(t,:)); hold on; end
%     legend('2','5','10','20','50','100')
% 
%     figure(3); clf
%     % Plot Pit A SM
%     subplot(2,1,1)
%     for t = 1:1:5;  plot(output(:,SMA(t)),'-','Color',c_list(t,:));hold on; end
%     legend('5','10','20','50','100')
% 
%     % Plot Pit B SM
%     subplot(2,1,2)
%     for t = 1:1:5;  plot(output(:,SMB(t)),'-','Color',c_list(t,:));hold on; end
%     legend('5','10','20','50','100')


    save([data_loc 'MATLAB/Data/CCP/TP' site_tag '_final_' yr '.dat'],'output','-ASCII');

%% Run program to write all variables to column vectors for each year:
jjb_write_columns(output,[data_loc 'MATLAB/Data/Met/Final_Cleaned/TP' site_tag '/' 'TP' site_tag '_' yr]);
%%
    
end

