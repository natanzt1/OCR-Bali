clear;
%filecitra =  'ContohCitraAksara5.bmp';

%filecitra =  'Aksara_Kompleks_color24bit.bmp';
%filecitra =  'Aksara_Kompleks_monocrom.bmp';
%filecitra =  'aksara6.bmp';
%filecitra =  'karakter.bmp';
%filecitra =  'Aksara_Kompleks_3.jpg';
%filecitra =  'bentuk_baru.bmp';
%filecitra =  'Aksara_Kompleks_5_putih.jpg';
filecitra =  'Aksara_Kompleks_4.jpg'; %ini contoh yg bagus!
%filecitra =  'aksara1.jpg'; %Contoh bagus sederhana 1 baris
citra1 = imread(filecitra);
ukuran = size(citra1);
tinggi_citra = ukuran(1);
lebar_citra = ukuran(2);

ukuranblok = [tinggi_citra lebar_citra];

fungsi = @(block_struct) im2bw(block_struct.data, graythresh(block_struct.data));
BW1 = blockproc(citra1,ukuranblok,fungsi); %menjalankan fungsi blockproc

toleransi_noise = 5;
baris = 0;

while baris <= tinggi_citra
    citra = imcrop(BW1,[0,baris,lebar_citra,1]);
    jum_hitam = lebar_citra - sum(citra);
    if jum_hitam >= toleransi_noise %sudah masuk ke obyek baris aksara
        awal_baris = baris;
        
        while jum_hitam >= toleransi_noise
            baris = baris + 1;
            citra = imcrop(BW1,[0,baris,lebar_citra,1]);
            jum_hitam = lebar_citra - sum(citra);       
        end
        akhir_baris = baris;
    end
    baris = baris + 1;
end

%citra = imcrop(citra1,[pos_x,pos_y,panjang,lebar]);

pos_x = 0;
pos_y = 55;
panjang = 500;
lebar = 40;
%lebar = 300;

pos_y = pos_y + lebar;
%pos_y = pos_y + lebar + 8;
%pos_y = pos_y + lebar;
%pos_y = pos_y + lebar + 8;
%pos_y = pos_y + lebar;
citra = imcrop(citra1,[pos_x,pos_y,panjang,lebar]);
%citra = citra1;


ukuranblok = [180 600]; %ukuran blok citra tinggi=30, lebar=100 pixel
 
%menentukan operasi yang dilakukan pada blok
%dalam hal ini operasi konversi ke citra biner
fungsi = @(block_struct) im2bw(block_struct.data, graythresh(block_struct.data));
BW1 = blockproc(citra,ukuranblok,fungsi); %menjalankan fungsi blockproc
%BW1 = citra; 
BW2 = BW1;
%BW2 = bwmorph(BW1,'thicken',2);
%BW2 = bwmorph(BW1,'thin',1); %operasi morphologi thin
%BW2 = bwmorph(BW1,'diag',2); %operasi morphologi skel

%J = rgb2gray(citra); %konversi citra berwarna I ke citra gray scale J
%T = graythresh(J); %T dihitung secara otomatis berdasarkan citra J
%BW2 = im2bw(J, 0.6); %Konversi gray scale ke citra biner, T=0.6
%BW2 = im2bw(J, T); %Konversi gray scale ke citra biner, T=otomatis

warna = 0;
eps = sqrt(2);
minpts = 3; 

%[pos_xy] = cari_posisi_warna(citra,warna);
[pos_xy] = cari_posisi_warna(BW2,warna);
[idx, isnoise] = Oka_DBSCAN(pos_xy, eps, minpts);
a = max(idx);
%s=size(citra);
s=size(BW2);
hasil = zeros(s(1),s(2));

%mencoba mengurutkan posisi IDX agar Kolom yang paling kiri diakses pertama
%kiri = min(pos_xy(2));


for row = 1:s(1)
   for col=1:s(2)
       hasil(row,col) = 255;
   end
end



pengali = round(250 / (max(max(idx))+1));
%pengali = 5;

bantu = size(idx);
for row = 1:bantu(1)
    baris = pos_xy(row,1);
    kolom = pos_xy(row,2);
    %if idx(row,1) == 21 %coba nyari per karakter 
        hasil(baris,kolom) = idx(row,1)*pengali;
    %end
end

%S = regionprops(hasil);

%BW = ~im2bw(citra, graythresh(citra));
%BW1 = bwmorph(BW,'remove'); %operasi morphologi remove

figure('Position',[300 300 450 330]);
warna_min = min(min(hasil));
warna_maks = max(max(hasil));

%subplot (2,1,1) , 
%imshow (BW1);
%subplot (2,1,2) , 
subplot (1,1,1) , 
imshow(hasil,[warna_min warna_maks]);
%imshow(hasil);

S = regionprops(~BW2,'BoundingBox'); 
OB = regionprops(~BW2,'Image');
%figure;imshow(~BW2);

hold on ;

%for i=1:size(S,1)
%    rectangle('Position', S(i).BoundingBox,'edgecolor','red');
%end

for i=1:size(S,1)
    rectangle('Position', S(i).BoundingBox,'edgecolor','red');
    
    
    %subplot (2,1,i+1) , 
    %imshow(~(OB(6).Image));
end

%imshow(BW1);


%subplot (3,1,1) , 
%imshow (citra);
%subplot (3,1,2) , 
%imshow(hasil,[warna_min warna_maks]);
%subplot (3,1,3) , 
%imshow(BW1);
