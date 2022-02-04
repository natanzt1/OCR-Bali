function varargout = tambah_sample(varargin)
% TAMBAH_SAMPLE MATLAB code for tambah_sample.fig
%      TAMBAH_SAMPLE, by itself, creates a new TAMBAH_SAMPLE or raises the existing
%      singleton*.
%
%      H = TAMBAH_SAMPLE returns the handle to a new TAMBAH_SAMPLE or the handle to
%      the existing singleton*.
%
%      TAMBAH_SAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAMBAH_SAMPLE.M with the given input arguments.
%
%      TAMBAH_SAMPLE('Property','Value',...) creates a new TAMBAH_SAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tambah_sample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tambah_sample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tambah_sample

% Last Modified by GUIDE v2.5 03-Jul-2019 01:33:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tambah_sample_OpeningFcn, ...
                   'gui_OutputFcn',  @tambah_sample_OutputFcn, ...
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


% --- Executes just before tambah_sample is made visible.
function tambah_sample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tambah_sample (see VARARGIN)

% Choose default command line output for tambah_sample
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tambah_sample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tambah_sample_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.tambah_preprocessing_btn,'Enable','off');
set(handles.tambah_biner_btn,'Enable','off');
set(handles.tambah_segmentation_btn,'Enable','off');
set(handles.daftar_btn,'Enable','off');
set(handles.tambah_save_preprocessing,'Enable','off');
set(handles.tambah_save_biner,'Enable','off');
set(handles.tambah_save_segmentation,'Enable','off');


% --- Executes on button press in tambah_browse_btn.
function tambah_browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_browse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [nama_file,nama_path] = uigetfile({'*.jpg';'*.bmp';'*.png';'*.tif'},...
        'Buka Citra Kakawin');
    
    if ~isequal(nama_file,0)
        file = [nama_file];
        image = [nama_path,nama_file];
        global image1
        image1 = imread(fullfile(nama_path,nama_file));
        image1 = imresize(image1, 0.5);
        handles.image = image1;
        axes(handles.axes1);
        imshow(handles.image,[]);
        guidata(hObject,handles);
    else
        return
    end
    set(handles.tambah_preprocessing_btn,'Enable','on');
    set(handles.tambah_biner_btn,'Enable','on');
    set(handles.tambah_segmentation_btn,'Enable','on');
    set(handles.daftar_btn,'Enable','on');


% --- Executes on button press in tambah_preprocessing_btn.
function tambah_preprocessing_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_preprocessing_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame,stretchlim(frame), []);
    axes(handles.axes2);
    imshow(filecitra);
    guidata(hObject, handles);
    set(handles.tambah_save_preprocessing,'Enable','on');
    
% --- Executes on button press in tambah_biner_btn.
function tambah_biner_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_biner_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame, stretchlim(frame), []);
    bw = im2bw(filecitra,0.6);
    axes(handles.axes3);
    imshow(bw);
    guidata(hObject, handles);
    set(handles.tambah_save_biner,'Enable','on');


% --- Executes on button press in tambah_segmentation_btn.
function tambah_segmentation_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_segmentation_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame,stretchlim(frame), []);

    warna = 0;

    eps = sqrt(2);
    minpts = 3 ;
    axes(handles.axes4);
    
    count_sloka = crop_citra(filecitra);
    for t = 1:count_sloka
        nama_file_siap = strcat('baris_aksara',int2str(t),'.jpg');  
        BW1 = imread(nama_file_siap);
        BW2 = imbinarize(BW1,0.6);

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

        subplot (1,1,t)
        imshow(hasil,colorcube);
    end
    set(handles.tambah_save_segmentation,'Enable','on');
    
    


% --- Executes on button press in daftar_btn.
function daftar_btn_Callback(hObject, eventdata, handles)
% hObject    handle to daftar_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global image1
    frame = image1;
    filecitra = imadjust(frame,stretchlim(frame), []);

    warna = 0;

    eps = sqrt(2);
    minpts = 3 ;

    count_sloka = crop_citra(filecitra);
    for t = 1:count_sloka
        nama_file_siap = strcat('baris_aksara',int2str(t),'.jpg');  
        BW1 = imread(nama_file_siap);
        BW2 = imbinarize(BW1,0.6);

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
            handles.image = image_hasil;
            modal_simpan(image_hasil)
        end   
    end



% --- Executes on button press in tambah_save_preprocessing.
function tambah_save_preprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_save_preprocessing (see GCBO)
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


% --- Executes on button press in tambah_save_biner.
function tambah_save_biner_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_save_biner (see GCBO)
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


% --- Executes on button press in tambah_save_segmentation.
function tambah_save_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to tambah_save_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path = uigetdir;
    frame = getimage(handles.axes4);
    number = 1;
    file_name = strcat(path, '/', int2str(number),'.jpg');
    while isfile(file_name)
         number = number+1;
         file_name = strcat(path, int2str(number),'.jpeg');
    end
    imwrite(frame, file_name)
    msgbox('Image Save Successfully')


% --- Executes on button press in back_btn.
function back_btn_Callback(hObject, eventdata, handles)
main_menu
close(tambah_sample)
% hObject    handle to back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
