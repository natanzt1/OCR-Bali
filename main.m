function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 03-Jul-2019 01:27:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.ocr_preprocessing_btn,'Enable','off');
set(handles.ocr_biner_btn,'Enable','off');
set(handles.ocr_segmentation_btn,'Enable','off');
set(handles.ocr_recognition_btn,'Enable','off');
set(handles.ocr_pisah_btn,'Enable','off');
set(handles.ocr_save_preprocessing,'Enable','off');
set(handles.ocr_save_biner,'Enable','off');
set(handles.ocr_save_segmentation,'Enable','off');
set(handles.ocr_save_recognition,'Enable','off');
set(handles.ocr_save_pisah,'Enable','off');


% --- Executes on button press in ocr_browse_btn.
function ocr_browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_browse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [nama_file,nama_path] = uigetfile({'*.jpg';'*.bmp';'*.png';'*.tif'},...
        'Buka Citra Kakawin');
    global image1
    if ~isequal(nama_file,0)
        file = [nama_file];
        image = [nama_path,nama_file];
        global image1
        image1 = imread(fullfile(nama_path,nama_file));
%         image1 = imresize(image1, 0.5);
        handles.image = image1;
        axes(handles.axes1);
        imshow(handles.image,[]);
        guidata(hObject,handles);
    else
        return
    end
    set(handles.ocr_preprocessing_btn,'Enable','on');
    set(handles.ocr_biner_btn,'Enable','on');
    set(handles.ocr_segmentation_btn,'Enable','on');
    set(handles.ocr_recognition_btn,'Enable','on');


% --- Executes on button press in ocr_preprocessing_btn.
function ocr_preprocessing_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_preprocessing_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame,stretchlim(frame), []);
    axes(handles.axes2);
    imshow(filecitra);
    guidata(hObject, handles);
    set(handles.ocr_save_preprocessing,'Enable','on');


% --- Executes on button press in ocr_biner_btn.
function ocr_biner_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_biner_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame, stretchlim(frame), []);
    bw = im2bw(filecitra,0.6);
    axes(handles.axes3);
    imshow(bw);
    guidata(hObject, handles);
    set(handles.ocr_save_biner,'Enable','on');
    

% --- Executes on button press in ocr_segmentation_btn.
function ocr_segmentation_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_segmentation_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('Segmentation')
    global image1
    global hasil
    frame = image1;
    filecitra = imadjust(frame,stretchlim(frame), []);

    warna = 0;

    eps = sqrt(2);
    minpts = 3 ;
    axes(handles.axes4);
    
%     count_sloka = crop_citra(filecitra);
    for t = 1:1
%         nama_file_siap = strcat('baris_aksara',int2str(t),'.jpg');  
%         BW1 = imread(nama_file_siap);
        BW2 = imbinarize(filecitra,0.6);

        [pos_xy] = cari_posisi_warna(BW2,warna);
        [idx, isnoise] = Oka_DBSCAN(pos_xy, eps, minpts);
        a = max(idx);
        s = size(BW2);
        hasil = zeros(s(1),s(2));

        for row = 1:s(1)
           for col=1:s(2)
               hasil(row,col) = 255;
           end
        end

        bantu = size(idx);
        jumlah_karakter = 1;
        for row = 1:bantu(1)
            baris = pos_xy(row,1);
            kolom = pos_xy(row,2);
            if idx(row,1) > jumlah_karakter
                jumlah_karakter = jumlah_karakter+1;
            end
            hasil(baris,kolom) = idx(row,1);
        end

       subplot(1,1,t) 
       imshow(hasil,colorcube);
    end
    set(handles.ocr_save_segmentation,'Enable','on');


% --- Executes on button press in ocr_recognition_btn.
function ocr_recognition_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_recognition_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load model
    total = 0;
    id_posisi2 = [];
    disp('Recognition')
    global image1
    frame = image1;
%     frame = getimage(handles.axes1);
    filecitra = imadjust(frame,stretchlim(frame), []);

    warna = 0;

    eps = sqrt(2);
    minpts = 3 ;
%     count_sloka = crop_citra(filecitra);
    for t = 1:1
        disp(t)
%         nama_file_siap = strcat('baris_aksara',int2str(t),'.jpg');
%         BW1 = imread(nama_file_siap);
        BW2 = imbinarize(filecitra,0.6);

        [pos_xy] = cari_posisi_warna(BW2,warna);
        [idx, isnoise] = Oka_DBSCAN(pos_xy, eps, minpts);
        a = max(idx);
        s = size(BW2);
        hasil = zeros(s(1),s(2));

        for row = 1:s(1)
           for col=1:s(2)
               hasil(row,col) = 255;
           end
        end

        bantu = size(idx);
        jumlah_karakter = 1;
        for row = 1:bantu(1)
            baris = pos_xy(row,1);
            kolom = pos_xy(row,2);
            if idx(row,1) > jumlah_karakter
                jumlah_karakter = jumlah_karakter+1;
            end
            hasil(baris,kolom) = idx(row,1);
        end
        id_posisi = get_posisi(s, idx, jumlah_karakter, pos_xy);
        K = regionprops(hasil,'Image');

        for i=1:max(idx)
            image_hasil = logical(1 - K(i).Image);
            testing = TestingCNN(model, image_hasil);
            id_posisi2 = [id_posisi2; id_posisi(i,1), id_posisi(i,2), testing(1), testing(2)];
        end   
    end
    % disp(id_posisi2)
    hasil = bentukkata(id_posisi2);
    set(handles.edit1,'String',hasil);
    disp(hasil)
    set(handles.ocr_save_recognition,'Enable','on');
    set(handles.ocr_save_recognition,'Enable','on');
    set(handles.ocr_pisah_btn,'Enable','on');
    

% --- Executes on button press in ocr_pisah_btn.
function ocr_pisah_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_pisah_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.ocr_save_pisah,'Enable','on');
    string = get(handles.edit1, 'String');
    result = pisahkata(string);
    set(handles.edit2,'String',result);
    set(handles.ocr_save_pisah,'Enable','on');
    

% --- Executes on button press in ocr_save_preprocessing.
function ocr_save_preprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_save_preprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path = uigetdir;
    frame = getimage(handles.axes2);
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.jpg');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.jpeg');
    end
    imwrite(frame, file_name)
    msgbox('Image Save Successfully')


% --- Executes on button press in ocr_save_biner.
function ocr_save_biner_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_save_biner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path = uigetdir;
    frame = getimage(handles.axes3);
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.jpg');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.jpeg');
    end
    imwrite(frame, file_name)
    msgbox('Image Save Successfully')


% --- Executes on button press in ocr_save_segmentation.
function ocr_save_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_save_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hasil
    path = uigetdir;
    frame = hasil;
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.jpg');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.jpeg');
    end
    imwrite(frame, file_name)
    msgbox('Image Save Successfully')


% --- Executes on button press in ocr_save_recognition.
function ocr_save_recognition_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_save_recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path = uigetdir;
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.txt');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.txt');
    end
    result = get(handles.edit1,'String');
    file = fopen(file_name,'wt');
    fprintf(file, '%s', result);
    fclose(file);


% --- Executes on button press in ocr_save_pisah.
function ocr_save_pisah_Callback(hObject, eventdata, handles)
% hObject    handle to ocr_save_pisah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path = uiputfile;
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.txt');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.txt');
    end
    result = get(handles.edit2,'String');
    file = fopen(file_name,'wt');
    fprintf(file, '%s', result);
    fclose(file);


% --- Executes on button press in back_btn.
function back_btn_Callback(hObject, eventdata, handles)
main_menu
close(main)
% hObject    handle to back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
