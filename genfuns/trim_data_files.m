function [data_out] = trim_data_files(data_in,year_start,year_end, extra_flag)
%%% trim_data_files.m
%%% usage: [data_out] = trim_data_files(data_in,year_start,year_end, extra_flag)
%%% This function will trim a structure data file to include data only from
%%% years inclusive of year_start:year_end
%%% If a 4th input argument is entered as 1, then this function will also
%%% calculated additional data variables, such as VPD and GDD and add it to
%%% the output structure file.

if nargin < 3
    disp('At least 3 input arguments needed > trim_data_files(data_in,year_start, year_end, extra_flag')
end
if nargin ==3
    disp('Extra stats (GDD, VPD, etc.) can be calculated by adding 4th argument == 1');
    extra_flag = 0;
end

var_names = fieldnames(data_in);
data_out = struct;
% tmp_year = data.Year;
yr_list = find(data_in.Year >= year_start & data_in.Year <= year_end);

for i = 1:1:length(var_names)
    error_flag = 0;
    try
        eval(['data_out.' char(var_names(i)) ' = data_in.' char(var_names(i)) '(yr_list,:);']);
    catch
        error_flag = 1;
    end
    
    if error_flag == 1 && strcmp(char(var_names(i)),'site')==1
        data_out.site = data_in.site;
    end
end

%%%% Extra variables (if extra_flag == 1):
if extra_flag == 1;
    if isfield(data_out, 'VPD')==0
        data_out.VPD = VPD_calc(data_out.RH, data_out.Ta);
    end
    if isfield(data_out,'GDD') == 0
        [junk, data_out.GDD] = GDD_calc(data_out.Ta,10,48,year_start:1:year_end);
    end
    if isfield(data_out,'REW') == 0
        [data_out.REW] = VWC_to_REW(data_out.SM_a_filled);
    end
   
    if isfield(data_out,'RE_flag') == 0
        try
            [data_out.RE_flag, data_out.GEP_flag] = mcm_GEP_RE_flag(data_out.site, data_out.PAR, data_out.dt, data_out.Ts5, data_out.Ts2, data_out.Ta, data_out.GDD,data_out.Year);
        catch
            disp('Error calculating RE, GEP flags -- Probably you did not specify data.site before running');
        end
    end
    data_out.recnum = NaN.*ones(length(data_out.Year),1);
    data_out.recnum_all = NaN.*ones(length(data_out.Year),1);
    
    for yr = year_start:1:year_end
        data_out.recnum(data_out.Year==yr,1) = (1:1:yr_length(yr,30))';
    end
    data_out.recnum_all = (1:1:length(data_out.Year))';
    %     if isfield(data_out, 'site')==0
    %         data_out.site = site;
    %     end
    data_out.year_start = year_start;
    data_out.year_end = year_end;
end

