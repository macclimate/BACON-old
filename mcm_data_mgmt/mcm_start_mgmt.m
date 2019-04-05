function [] = mcm_start_mgmt

%%  Create and then hide the GUI as it is being constructed.
ls = addpath_loadstart;
window_titles = {'Welcome to the Jungle!!'; ...
                 'BACON: The Smell of Progress!'; ...
                 'Mmmmmmmm BACON'; ...
                 'BACON: Taking Care of Greasy Details since 2009.'; ...
                 'BACON BACON BACON BACON BACON BACON BACON BACON BACON'; ...
                 '~~~~~~~~~~~~~~~~~~~~~~~~ BACON ~~~~~~~~~~~~~~~~~~~~~~~~'; ...
                 };
title_to_use = round(rand(1).*size(window_titles,1));                 
out = mcm_mgmt_ini;       

fmain = figure('Position',[20,70,1000,666],...
    'MenuBar','none','NumberTitle','off',...
    'Name',window_titles{title_to_use,1}, 'Visible','off', 'Resize','off');
%%% Create the background %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hbg = axes('Units','Pixels','Position',[0,0,1000,666],'Visible','off');
axes(hbg);
imshow([ls 'Matlab/Figs/GUI/Bacon_GUI_background_v2.png']);


%%% %%%%%%%% Turn on Diary %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log_filename = [ls 'Documentation/Logs/tmp_BACONlog.txt'];  
assignin('base','log_filename',log_filename);
if exist(log_filename,'file')==2
unix(['rm ' log_filename]);
end
diary(log_filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%% Make Pop-up Buttons: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bt_off = 230;
%%% Step 5 Text:
% Frame:
frame_step5 = uicontrol(fmain,'Position',[15 235 970 210],'Style','frame','BackgroundColor',[1 1 1]);

% Text:
text_step5 = uicontrol(fmain,'Position',[20 340 150 50],'Style','text','String',{'Step 5:'; 'Review Inputs:'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');

%%%% ____________________________________________________________________
%%% popupmenu for Site, and text box to show current selection:
text_step1 = uicontrol(fmain,'Position',[20 500 100 50],'Style','text','String',{'Step 1:'; 'Select Site'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
pop_site = uicontrol(fmain,'Position',[30 470 80 30],'Style','popupmenu', ...
    'String',get_site_list, 'Callback',@pop_site_callback, 'BackgroundColor',[0.8 0.8 0.8]);
text_site_label = uicontrol(fmain,'Position',[20+bt_off 400 210 30],'Style','text','String','Site:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','left');
text_site = uicontrol(fmain,'Position',[240+bt_off 415 100 20],'Style','text','String','',...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',14,'FontWeight','bold');

%%%% ____________________________________________________________________
%%% popupmenu for Data Type, and text box to show current selection:
text_step2 = uicontrol(fmain,'Position',[230 500 130 50],'Style','text','String',{'Step 2:'; 'Select Data Type'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
pop_type = uicontrol(fmain,'Position',[240 470 120 30],'Style','popupmenu', ...
    'String','---', 'Callback',@pop_type_callback, 'BackgroundColor',[0.8 0.8 0.8]);
text_type_label = uicontrol(fmain,'Position',[20+bt_off 360 210 30],'Style','text','String','Data Type:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','left');
text_type = uicontrol(fmain,'Position',[240+bt_off 375 100 20],'Style','text','String','',...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',14,'FontWeight','bold');

%%%% ____________________________________________________________________
%%% popupmenu for Data Process, and text box to show current selection:
text_step3 = uicontrol(fmain,'Position',[550 500 150 50],'Style','text','String',{'Step 3:'; 'Select Data Process'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
pop_proc = uicontrol(fmain,'Position',[500 470 250 30],'Style','popupmenu', ...
    'String','---', 'Callback',@pop_proc_callback, 'BackgroundColor',[0.8 0.8 0.8]);
text_proc_label = uicontrol(fmain,'Position',[20+bt_off 320 210 30],'Style','text','String','Data Process:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','left');
text_proc = uicontrol(fmain,'Position',[240+bt_off 335 200 20],'Style','text','String','',...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',14,'FontWeight','bold');

%%%% ____________________________________________________________________
%%% popupmenu for Year, and text box to show current selection:
text_step4 = uicontrol(fmain,'Position',[850 500 100 50],'Style','text','String',{'Step 4:'; 'Select Year:'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
pop_year = uicontrol(fmain,'Position',[860 470 80 30],'Style','popupmenu', ...
    'String',['---'; get_year_list], 'Callback',@pop_year_callback, 'BackgroundColor',[0.8 0.8 0.8]);
text_proc_label = uicontrol(fmain,'Position',[20+bt_off 280 210 30],'Style','text','String','Year:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','left');
text_year = uicontrol(fmain,'Position',[240+bt_off 295 100 20],'Style','text','String','',...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',14,'FontWeight','bold');

%%%% ____________________________________________________________________
%%% Data Processing Command Text Display:
text_procstring = uicontrol(fmain,'Position',[20+bt_off 240 210 30],'Style','text','String','Data Processing Command:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','left');
text_proc_cmd = uicontrol(fmain,'Position',[240+bt_off 255 450 20],'String','', 'BackgroundColor',[1 1 1],...
    'Style','text','HorizontalAlignment','left','FontSize',14,'FontWeight','bold','ForegroundColor',[0.1 0.1 0.9]);

%%%% ____________________________________________________________________

%%% Step 6 - Pushbutton and Title
rel_shifty = -250;rel_shiftx = -670;
text_step6 = uicontrol(fmain,'Position',[720+rel_shiftx 410+rel_shifty 100 50],'Style','text','String',{'Step 6:'; 'Run Process:'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
push1c = uicontrol(fmain,'Style','pushbutton','Position',[920+rel_shiftx 425+rel_shifty 250 40],...
    'String','Not Ready','Visible','on','BackgroundColor',[0.8 0.8 1],'Callback',@runproc,...
    'FontSize',10,'ForegroundColor',[0.5 0.2 0.2], 'Enable','off','HorizontalAlignment','center');
%%%% ____________________________________________________________________
%%% Step 7 - Batch Processes
% Draw a frame around these items:
frame_extra = uicontrol(fmain,'Position',[670 10 320 140],'Style','frame','BackgroundColor',[1 1 1]);
text_step7 = uicontrol(fmain,'Position',[685 110 300 25],'Style','text','String','Batch Processes:', ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
pop_extra = uicontrol(fmain,'Position',[690 75 280 30],'Style','popupmenu', ...
    'String',['---'; get_extra_list(1)], 'Callback',@pop_extra_callback, 'BackgroundColor',[0.8 0.8 0.8]);
push_extra = uicontrol(fmain,'Style','pushbutton','Position',[750 20 160 30],...
    'String','Click To Run Batch','Visible','on','BackgroundColor',[0.8 0.8 1],'Callback',@runextra,...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2], 'Enable','on','HorizontalAlignment','center');
%%%% ____________________________________________________________________
%%% Step 8: Help Buttons
frame_help = uicontrol(fmain,'Position',[340 10 320 140],'Style','frame','BackgroundColor',[1 1 1]);
text_help = uicontrol(fmain,'Position',[355 110 300 25],'Style','text','String',{'Help & Error Reporting:'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');
% pop_help = uicontrol(fmain,'Position',[365 75 280 30],'Style','popupmenu', ...
%      'String',['---'; get_help_list(1)], 'Callback',@pop_extra_callback, 'BackgroundColor',[0.8 0.8 0.8]);
% Help Button
push_help1 = uicontrol(fmain,'Style','pushbutton','Position',[425 70 160 30],...
    'String','Click Here For Help','Visible','on','BackgroundColor',[0.8 0.8 1],'Callback',@open_help,...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2], 'Enable','on','HorizontalAlignment','center');
% Error Reporting Button
push_err1 = uicontrol(fmain,'Style','pushbutton','Position',[425 20 160 30],...
    'String','Report an Error','Visible','on','BackgroundColor',[0.8 0.8 1],'Callback',@report_error,...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2], 'Enable','on','HorizontalAlignment','center');


%%%% ____________________________________________________________________
%%% Step 9: Open Config File Folder
frame_config = uicontrol(fmain,'Position',[10 10 320 140],'Style','frame','BackgroundColor',[1 1 1]);
text_config = uicontrol(fmain,'Position',[25 110 300 25],'Style','text','String',{'Browse/Open Config Files:'}, ...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2],'FontName','Arial','BackgroundColor',[1 1 1],'FontWeight','bold',...
    'HorizontalAlignment','center');

pop_config1 = uicontrol(fmain,'Position',[30 75 280 30],'Style','popupmenu', ...
    'String',['---'; out.config_opts(:,1)], 'Callback',@pop_config_callback, 'BackgroundColor',[0.8 0.8 0.8]);

push_config1 = uicontrol(fmain,'Style','pushbutton','Position',[95 20 160 30],...
    'String','Click to Open','Visible','on','BackgroundColor',[0.8 0.8 1],'Callback',@open_config,...
    'FontSize',12,'ForegroundColor',[0.5 0.2 0.2], 'Enable','on','HorizontalAlignment','center');
% 


%% ______________________________________________________________________
%%% First thing to do is to see if these is already information in 'base'.
%%% If there is, then we will fill the fields automatically:
first_field_check
%%% _____________________________________________________________________


%% %%%%%%%%%%%%%%%% Callbacks: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Callback for Site popupmenu:
function pop_site_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
        val = get(hObject,'Value');
        if val == 1
 site = '';          
        elseif val >1
site = contents{val,1};            
        end   
%%% Reset all Type and Process Data:
data_type = '';
assignin('base','data_type',data_type);
set(text_type,'String',data_type);
proc = ''; proc_string = '';
assignin('base','proc_string',proc_string);
assignin('base','proc',proc);
set(text_proc,'String',proc);
set(text_proc_cmd,'String',proc_string)
set(pop_proc,'String',['---'; get_proc_list(data_type)],'Value',1);
%%%%%%%%%%%%%%%%%%%%%%%%         
        
        set(pop_type,'String',['---'; get_type_list(site)],'Value',1);
        assignin('base','sitelist',contents);        
        assignin('base','typelist',['---'; get_type_list(site)]);
        set(text_site,'String',site);
        assignin('base','site',site);

check_all_fields;
end

%%% Callback for Type popupmenu:
function pop_type_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
        val = get(hObject,'Value');
        if val == 1
data_type = '';

        elseif val >1
data_type = contents{val,1};
        end
%%% Reset all Process Data:
proc = ''; proc_string = '';
assignin('base','proc_string',proc_string);
assignin('base','proc',proc);
set(text_proc,'String',proc);
set(text_proc_cmd,'String',proc_string)   

%%%%%%%%%%%%%%%%%%%%%%%%  .

        set(pop_proc,'String',['---'; get_proc_list(data_type)],'Value',1);

%         assignin('base','typelist',contents);
        assignin('base','data_type',data_type);
        assignin('base','proclist',['---'; get_proc_list(data_type)]);

        set(text_type,'String',data_type);
        check_all_fields;
end

%%% Callback for Process popupmenu:
function pop_proc_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
        val = get(hObject,'Value');
        if val == 1  
            proc = '';
            proc_string = '';
        elseif val >1
           proc = contents{val,1}; 
        proc_string = get_proc_eval_string(proc);
        end
        
        assignin('base','proc_string',proc_string);
        set(text_proc_cmd,'String',proc_string)        
%         assignin('base','proclist',contents);
        assignin('base','proc',proc);
        set(text_proc,'String',proc);
        check_all_fields;    
end

%%% Callback for Process popupmenu:
function pop_year_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
        val = get(hObject,'Value');
if val == 1
    year = '';
% elseif val == 2
%     year = '999';
elseif val > 1       
       year = contents{val,1};
end
        set(text_year,'String',contents{val,1});
        assignin('base','year',year);
%                 check_all_fields;
        assignin('base','yearlist',contents);
        check_all_fields;    

end


%%% Callback for Run Process button:
    function runproc(hObject,eventdata)
        try site = evalin('base','site'); catch; end
        try year = evalin('base','year'); 
        if strcmp(year,'multiple')==1
            year = [];
        else
            year = str2double(year);
        end
        catch; end
        try data_type = evalin('base','data_type'); catch; end
        try proc_string = evalin('base','proc_string'); catch; end
        
        %%% Now, try and run the proc_string
        try 
           eval(proc_string);
        catch e_eval
%             disp(['error running ' proc_string '.']);
            rethrow(e_eval)
        end
        
    end

%%% Callback for the batch popup box %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pop_extra_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
        val = get(hObject,'Value');
if val == 1
    extra_command = '';
% elseif val == 2
%     year = '999';
elseif val > 1       
       
       extra_opts = get_extra_list(2);
%        right_row = 
       
%        extra_command = contents{val,1};
extra_command = extra_opts{val-1,2};
end
        assignin('base','extra_command',extra_command);
    end

%%% Callback for the batch command button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function runextra(hObject,eventdata)
        try extra_command = evalin('base','extra_command'); catch 
        extra_command = '';
        end
 
        %%% Now, try and run the extra command
        try 
           eval(extra_command);
        catch e_extra
            rethrow(e_extra)
        end
        
    end

%%% Callback for the Config Popup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function pop_config_callback(hObject,eventdata)
        contents = cellstr(get(hObject,'String'));
         val = get(hObject,'Value');
        assignin('base','config_command',contents{val});
 end

%%% Callback for the Config Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function open_config(hObject,eventdata)

        try config_command = evalin('base','config_command');
        catch; config_command = ''; end
        out = mcm_mgmt_ini;
        right_row = find(strcmp(config_command,out.config_opts)==1);
        
        if ~isempty(right_row)
            eval(out.config_opts{right_row,3});
        else           
        end
        
        
 end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% check_all_fields: updates the string in text that shows what process
%%% will be done:
    function check_all_fields
        %         try site = evalin('base','site'); catch; end
        %         try year = evalin('base','year'); catch; end
        %         try data_type = evalin('base','data_type'); catch; end
        % Try and load in the process string.  If it's there, then we can continue.
        % If it's not there, then the check is over and it failed.
        try proc_string = evalin('base','proc_string'); catch; return;  end %proc_string = '';
        try
        if isempty(proc_string)==1
            err_flag = 1;
            fail_str = 'No Process Selected. ';
        else
            % Load all the parameter data:
            try site = evalin('base','site'); catch; end
            try year = evalin('base','year'); catch; end
            try data_type = evalin('base','data_type'); catch; end
            
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%% Aside: If data_type is not empty, then enable the Config
%             %%% Files Browsing Button
%             if isempty(data_type)~=1;
%                 set(push_config1,'Enable','on','String','Browse Config Files');
%             else
%                 set(push_config1,'Enable','off','String','Select Data Type');
%             end
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Get the list of variables needed for the process:
            vars = extract_vars(proc_string);
            % Go through the variables, and see if they are there:
	        fail_str = 'Please Select';
            err_flag = ones(size(vars,1),1);
            success_str = 'Ready to Process';
            for i = 1:1:length(vars)
                try tmp = eval(vars{i,1});  
                    
                if isempty(tmp)==1
                    err_flag(i,1) = 1; 
                else 
                    err_flag(i,1) = 0; 
                end
                
                catch
                err_flag(i,1) = 1; 
                end
                
                if err_flag(i,1) ==1
                    fail_str = [fail_str ' ' vars{i,1} ','];
                end
            end
        end
            if sum(err_flag) == 0
                set(push1c,'Enable','on','String','Ready! -- Click To Run!',...
                    'ForegroundColor',[0.2 0.5 0.2],'FontWeight','bold','FontSize',14);
            else
                set(push1c,'Enable','on','String',fail_str(1:end-1),...
                    'ForegroundColor',[0.5 0.2 0.2],'FontSize',10,'FontWeight','normal');
            end
            
        catch
        end
    end
            
% %%% Step 1:            
%         proc_string_out = convert_proc_string(proc_string);
%         
%         
%         
%             par1 = strfind(proc_string,'(');
%             par2 = strfind(proc_string,')');
%             coms = strfind(proc_string,','); coms = [par1 coms par2];
% out_str = proc_string(1:par1);
%         for i = 1:1:length(coms)-1
%             tmp1 = proc_string(coms(i)+1:coms(i+1)-1);
%             next_str_tmp = eval(tmp1);
%             
%             if strcmp(tmp1,'year')==1
%             next_str_tmp = num2str(next_str_tmp);
%             out_str = [out_str next_str_tmp ','];    
% 
%             else
%             out_str = [out_str '''' next_str_tmp '''' ','];    
%   
%             end
%         clear next_str_tmp;
%         end
%             out_str = [out_str(1:end-1) ');'];
%         
%         catch
%             out_str = proc_string;
%         end
%             
%         set(text_proc_cmd,'String',out_str);        
%         
%         
%         vars = extract_vars(proc_string);
%         for i = 1:1:length(vars)
%         end
%     end

%%% Function that we can use to check 'base' every time we load the GUI
%%% back up.  If there are entries for each field already, then we can just
%%% show the user that they're already in the memory:
    function first_field_check
        fail_flag = 0;
        try site = evalin('base','site'); set(text_site,'String',site);
        sitelist = evalin('base','sitelist'); set(pop_site,'String',sitelist);
        val = find(strcmp(site,sitelist(:,1))==1);set(pop_site,'Value',val);
        catch;  fail_flag = 1; end
        
        try year = evalin('base','year'); set(text_year,'String',year);                
        yearlist = evalin('base','yearlist'); set(pop_year,'String',yearlist);
        val = find(strcmp(num2str(year),yearlist(:,1))==1); 
        if isempty(val)==1
            val = 1;
        end
        set(pop_year,'Value',val);            
        catch; fail_flag = 1;end
        
        try data_type = evalin('base','data_type'); set(text_type,'String',data_type);
        typelist = evalin('base','typelist'); set(pop_type,'String',typelist);
        val = find(strcmp(data_type,typelist(:,1))==1); set(pop_type,'Value',val);
        catch; fail_flag = 1;end
        
        try proc = evalin('base','proc'); set(text_proc,'String',proc);
        proclist = evalin('base','proclist'); set(pop_proc,'String',proclist);  
         val = find(strcmp(proc,proclist(:,1))==1); set(pop_proc,'Value',val);
        catch; fail_flag = 1;end
       
         try proc_string = evalin('base','proc_string'); set(text_proc_cmd,'String',proc_string);
        catch; fail_flag = 1;end       
        
        
    if fail_flag == 0
        
       check_all_fields; 
    end
    
    end


%%%% Help Function Callback:
    function [] = open_help(hObject,eventdata)
%        web('http://goo.gl/97my1','-browser') % generic command
       unix('google-chrome http://goo.gl/97my1');
    end

%%%% Error Reporting Callback:
function [] = report_error(hObject,eventdata)
% Print the settings:
try proc_string = evalin('base','proc_string'); catch;  proc_string = ''; end
try site = evalin('base','site'); catch;  site = ''; end
try data_type = evalin('base','data_type'); catch;  data_type = ''; end
try year = evalin('base','year'); catch;  year = ''; end
disp(['proc_string = ' proc_string]);
disp(['site = ' site]);
disp(['year = ' year]);
disp(['data_type = ' data_type]);
log_filename = evalin('base','log_filename');

try
%%%%%%%%%%%%%%%%%%% Send an email with Error Report details: %%%%%%%%%%
recips = {'jason.brodeur@gmail.com','mac.climate@gmail.com'};
subject = ['BACON ERROR Report - ' datestr(now,1)];
% get error message details from user:
message = inputdlg('Provide Comments on Error:','Error Report',10,{''},'on'); %input('type error report details')
attach = log_filename;
diary off;
sendmail(recips,subject,message,attach)
diary(log_filename);
disp('Error report sent successfully.');
catch
disp('There was an error when trying to send the error report -- OH THE IRONY! Please e-mail the administrator.');
end

end

% %%%% Open Config File Browsing
%     function [] = open_config(hObject,eventdata)
%         path1 = '/1/fielddata/Matlab/Config/';
%          out = mcm_mgmt_ini;
% %         % Evaluate in the data type
% %          try data_type = evalin('base','data_type'); catch; end
% %          
% %          right_row = strcmp(data_type,out.config_loc(:,1));
% %          path2 = char(out.config_loc(right_row==1,2));
% %          
% %          if isempty(data_type)~=1
% %          else
% %              path2 = '';
% %          end
% %             [status,result] = system(['thunar ' path1 path2],'-echo');
%   
% 
%          
%     end

end


%% =======================================================================
%%%%%%%%%%%%%%%% External Functions:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function string_out = get_site_list
out = mcm_mgmt_ini;
string_out = ['---' ;out.site_list];
end

function string_out = get_type_list(site)
if isempty(site)==1
    string_out = {};
else
    out = mcm_mgmt_ini;
    right_row = find(strcmp(out.types_available(:,1),site)==1);
    string_out = out.type_list(out.types_available{right_row,2});
end
end

function string_out = get_proc_list(type)
if isempty(type)==1
    string_out = {};
else
    out = mcm_mgmt_ini;
    right_row = find(strcmp(out.procs_available(:,1),type)==1);
    string_out = out.proc_list(out.procs_available{right_row,2},1);
end
end

function string_out = get_year_list
out = mcm_mgmt_ini;
string_out = out.year_list;
end

function proc_string = get_proc_eval_string(proc)
out = mcm_mgmt_ini;
right_row = find(strcmp(out.proc_list(:,1),proc)==1);
proc_string = out.proc_list{right_row,2};
end

function vars = extract_vars(proc_string)
par1 = strfind(proc_string,'(');
par2 = strfind(proc_string,')');
coms = strfind(proc_string,','); coms = [par1 coms par2];
vars = cell(0,0);

for i = 1:1:length(coms)-1
    tmp1 = proc_string(coms(i)+1:coms(i+1)-1);
    if ~isempty(tmp1) && strcmp(tmp1,'[]')~=1;
        vars{length(vars)+1,1} = tmp1;
    end
    clear tmp1;
end
end


function string_out = get_extra_list(num_cols)
    out = mcm_mgmt_ini;
if num_cols == 2
    string_out = out.extras;
else
   string_out = out.extras(:,1);
end
end

% function string_out = get_help_list(num_cols)
%  try proc = evalin('base','proc'); set(text_proc,'String',proc);
%         proclist = evalin('base','proclist'); set(pop_proc,'String',proclist);  
%          val = find(strcmp(proc,proclist(:,1))==1); set(pop_proc,'Value',val);
%         catch; fail_flag = 1;end
%        
%          try proc_string = evalin('base','proc_string'); set(text_proc_cmd,'String',proc_string);
%         catch; fail_flag = 1;end        
% 
% 
% if fail_flag == 1
%     string_out = {};
% else
%    string_out = out.extras(:,1);
% end
% end

% function out_str = convert_proc_string(proc_string)
% 
% 
% par1 = strfind(proc_string,'(');
% par2 = strfind(proc_string,')');
% coms = strfind(proc_string,','); coms = [par1 coms par2];
% out_str = proc_string(1:par1);
% 
% for i = 1:1:length(coms)-1
%     tmp1 = proc_string(coms(i)+1:coms(i+1)-1);
%     next_str_tmp = eval(tmp1);
%     
%     if strcmp(tmp1,'year')==1
%         next_str_tmp = num2str(next_str_tmp);
%         out_str = [out_str next_str_tmp ','];
%         
%     else
%         out_str = [out_str '''' next_str_tmp '''' ','];
%         
%     end
%     clear next_str_tmp;
% end
% out_str = [out_str(1:end-1) ');'];
% 
% catch
%     out_str = proc_string;
% end
% 
% 
% 
% end
