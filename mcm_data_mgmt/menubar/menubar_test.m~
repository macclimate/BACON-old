function varargout = test(varargin)
% GUI Example showing the menubar function
%
% The Menu is build in code-line 47 to 62
%


% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 16-Dec-2010 14:27:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);

menu_panel1=uicontextmenu;
set(handles.uipanel1,'UIContextMenu',menu_panel1);
hchild=uimenu(menu_panel1, 'Label', 'Random Pixels');
uimenu(hchild, 'Label', 'Red','Callback',@(h1,h2)redpixels(h1,h2,handles));
uimenu(hchild, 'Label', 'Blue','Callback',@(h1,h2)bluepixels(h1,h2,handles));
hchild=uimenu(menu_panel1, 'Label', 'Clear','Callback','test(''clearpixels'',hObject,eventdata,guidata(hObject))');
hchild=uimenu(menu_panel1, 'Label', 'Help');
uimenu(hchild, 'Label', 'Info','Callback','disp(''Info callback'')');
hchild=uimenu(hchild, 'Label', 'SubInfo');
uimenu(hchild, 'Label', 'SubSubInfo');

menu_panel2=uicontextmenu;
set(handles.uipanel2,'UIContextMenu',menu_panel2);
hchild=uimenu(menu_panel2, 'Label', 'Random Lines');
uimenu(hchild, 'Label', 'Green','Callback',@(h1,h2)greenlines(h1,h2,handles));
uimenu(hchild, 'Label', 'Yellow','Callback',@(h1,h2)yellowlines(h1,h2,handles));
hchild=uimenu(menu_panel2, 'Label', 'Clear','Callback','test(''clearlines'',hObject,eventdata,guidata(hObject))');

menubar;
menubar('start');

function redpixels(hObject,eventdata,handles)
I=zeros(40,100,3);
I(:,:,1)=rand(40,100);
imshow(I,'parent',handles.axes1);


function bluepixels(hObject,eventdata,handles)
I=zeros(40,100,3);
I(:,:,3)=rand(40,100);
imshow(I,'parent',handles.axes1);


function clearpixels(hObject,eventdata,handles)
cla(handles.axes1);
axis(handles.axes1,'on');

function greenlines(hObject,eventdata,handles)
plot(handles.axes2,rand(2,10),rand(2,10),'g');


function yellowlines(hObject,eventdata,handles)
plot(handles.axes2,rand(2,10),rand(2,10),'y');


function clearlines(hObject,eventdata,handles)
cla(handles.axes2);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
