function id_posisi = get_posisi(s, idx, jumlah_karakter, pos_xy)
    koordinat_akhir = [];

    koordinat_baris_atas = [];
    koordinat_baris_bawah = [];
    bantu = size(idx);
    for i=1:jumlah_karakter
        koor_kolom = 0;
        koor_baris = 0;
        koor_baris_bwh = 0;
        for row = 1:bantu(1)
            baris = pos_xy(row,1);
            kolom = pos_xy(row,2);
            if idx(row,1) == i
                if koor_kolom < kolom
                    koor_kolom = kolom;
                end

                %mencari koordinat baris (vertikal) paling atas dari
                %masing-masing karakter
                if koor_baris == 0
                    koor_baris = baris;
                elseif koor_baris > baris
                    koor_baris = baris;
                end

                %mencari koordinat baris (vertikal) paling bawah dari
                %masing-masing karakter
                if koor_baris_bwh < baris
                    koor_baris_bwh = baris;
                end
            end
        end
        koordinat_akhir = [koordinat_akhir; koor_kolom];
        koordinat_baris_atas = [koordinat_baris_atas, koor_baris];
        koordinat_baris_bawah = [koordinat_baris_bawah, koor_baris_bwh];
    end

    id_deret = 1;
    batas_samping = (s(2)/jumlah_karakter*0.5);
    array_karakter = [];
    deret = [];
    deret = [deret, id_deret];
    jml_per_deret = [];
    jumlah = 1;
    jumlah_max = 0;
    for i=2:jumlah_karakter
        selisih = koordinat_akhir(i,1)-koordinat_akhir(i-1,1);
        if selisih < batas_samping
            deret = [deret, id_deret];
            jumlah = jumlah+1;
            if jumlah_max < jumlah && jumlah < 4
                jumlah_max = jumlah;
            end
        else
            jml_per_deret = [jml_per_deret, jumlah];
            jumlah = 1;
            id_deret = id_deret+1;
            deret = [deret, id_deret];
        end
    end
    jml_per_deret = [jml_per_deret, jumlah];
    jml_deret = size(jml_per_deret,2);
    index = 1;
    id = [];
    cluster_baris = s(1)/4;
    for i=1:jml_deret            
        switch jml_per_deret(i)
            otherwise
                id_baris = [];
                aks_tengah = 0;
                for j=0:jml_per_deret(i)-1
                    if aks_tengah == 0 && koordinat_baris_atas(index+j) < cluster_baris*2
                        if koordinat_baris_atas(index+j) < cluster_baris
                            id_baris = [id_baris, 3];
                        else
                            id_baris = [id_baris, 1];
                            aks_tengah = 1;
                        end
                    elseif koordinat_baris_bawah(index+j) > cluster_baris*2
%                     elseif koordinat_baris_bawah(index+j) > cluster_baris*3
                        id_baris = [id_baris, 2];
                    elseif koordinat_baris_atas(index+j) < cluster_baris
                        id_baris = [id_baris, 3];
                    else
                        id_baris = [id_baris, 1];
                    end   
                end
                for j=1:jml_per_deret(i)
                    id = [id; i, id_baris(j)];
                end
                index = index+jml_per_deret(i);
                
        end
    end
    id_posisi = id;
    disp(id)
end
