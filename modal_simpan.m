function varargout = modal_simpan(varargin)
% MODAL_SIMPAN MATLAB code for modal_simpan.fig
%      MODAL_SIMPAN by itself, creates a new MODAL_SIMPAN or raises the
%      existing singleton*.
%
%      H = MODAL_SIMPAN returns the handle to a new MODAL_SIMPAN or the handle to
%      the existing singleton*.
%
%      MODAL_SIMPAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODAL_SIMPAN.M with the given input arguments.
%
%      MODAL_SIMPAN('Property','Value',...) creates a new MODAL_SIMPAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before modal_simpan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to modal_simpan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modal_simpan

% Last Modified by GUIDE v2.5 12-Apr-2019 07:47:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modal_simpan_OpeningFcn, ...
                   'gui_OutputFcn',  @modal_simpan_OutputFcn, ...
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

% --- Executes just before modal_simpan is made visible.
function modal_simpan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to modal_simpan (see VARARGIN)

% Choose default command line output for modal_simpan

conn = database('ocr', 'root', '', 'com.mysql.jdbc.Driver', 'jdbc:mysql://127.0.0.1:3306/ocr');
    
%test select data
curs = exec(conn,'SELECT nama from tb_jenis_karakter');
curs = fetch(curs);
nama = curs.Data;

global image;
handles.image = varargin{1};
image = handles.image;
axes(handles.axes1);
cla('reset');
imshow(handles.image,[]);
set(handles.dropdown, 'String', nama)




% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3)
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes modal_simpan wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = modal_simpan_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% The figure can be deleted now


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    
    % Update handles structure
    guidata(hObject, handles);
    
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
    nama = get(handles.edit1, 'String');
    setappdata(handles.edit1, 'nama_aks', nama);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in simpan_btn.
function simpan_btn_Callback(hObject, eventdata, handles)
% hObject    handle to simpan_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    %inisialisasi koneksi db
    %ocr = nama database
    
    %nama_aks = getappdata(handles.edit1, 'nama_aks');
    contents = get(handles.dropdown,'String'); 
    nama_karakter = contents{get(handles.dropdown,'Value')};
    close;
    
    %conn = database('ocr', 'root', '', 'com.mysql.jdbc.Driver', 'jdbc:mysql://127.0.0.1:3306/ocr');

    %test select data
    %curs = exec(conn,'SELECT max(id) from tb_karakter');
    %curs = fetch(curs);
    %last_id = curs.Data(1);
    %last_id = last_id{1};
    %tf = isnan(last_id);
    
    %if tf == true
        %last_id = 1;
    %else
        %last_id = last_id+1;
    %end
    
    %insert data
    %file_name = strcat('per_karakter\karakter_',int2str(last_id),'.jpg');
    %imwrite(handles.image, file_name);
    %tableName = 'tb_karakter';
    %colName = {'nama', 'gambar_aksara'};
    %data = {nama_aks, file_name};
    %insert(conn, tableName , colName, data)
    number = 1;
    folder_name = strcat('dataset\',nama_karakter, '\');
    
    if ~exist(folder_name, 'dir')
       mkdir(folder_name)
    end
    file_name = strcat(folder_name, int2str(number),'.jpg');
    
    while isfile(file_name)
         number = number+1;
         file_name = strcat(folder_name, int2str(number),'.jpg');
    end
    imwrite(handles.image, file_name);
    close;


% --- Executes on selection change in dropdown.
function dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropdown


% --- Executes during object creation, after setting all properties.
function dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
