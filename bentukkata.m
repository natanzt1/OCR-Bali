function bentuk_kata = bentukkata(kata)
    %kata = [1, 1, "na", "na";
    %       1, 3, "ulu", "i";
    %        1, 3, "cecek", "ng";
    %        2, 1, "taleng", "e";
    %        3, 1, "da", "da";
    %        3, 3, "ra", "r";
    %        4, 1, "tedong", "a"
    %        5, 1, "ta", "ta";
    %        5, 2, "suku", "u";
    %        6, 1, "bisah", "h"];

    %kata = [1, 1, "taleng", "e";
    %        2, 1, "ma", "m";
    %        2, 2, "ka", "k";
    %        3, 1, "tedong", "o"];

    label = {'cluster', 'urutan', 'aksara', 'bunyi'};
                        %1 = pengawak
                        %2 = gantungan
                        %3 = sandang sastra
    
    
    s = size(kata);
    jml_kolom = str2double(kata(s(1)));
    jml_kluster = jml_kolom;

    s = size(kata);
    baris = s(1); %jumlah_baris
    list_cluster = [];
    bentuk_kata = '';

    for i = 1:baris
        list_cluster = [list_cluster,kata(i,1)];
    end

    flag_taleng = 0;
    flag_p = 0;
    flag_s = 0;
    flag_o = 0;

    temp_vokal= '';

    for i = 1:jml_kluster
    
        %loop dilakukan berdasarkan jumlah kluster
        %kata dibentuk per kluster dulu

        temp_kata = ' ';
        temp_utama = ' ';
        temp_bawah = ' ';
        temp_bawah_vok = ' ';
        temp_atas_kons = ' ';
        temp_atas_vok = ' ';

        %cek adanya aksara pengawak, sandang, gantungan
        %loop dilakukan berdasarkan jumlah baris yang ada
        for j = 1:baris
            if int2str(i) == kata(j,1)
               if kata(j,2) == "1"
                   if kata(j,3) == "taleng"
                       flag_taleng = 1;
                   elseif kata(j,3) == "tedong" & flag_taleng == 2
                       flag_o = 1;
                   elseif kata(j,3) == "bisah" | kata(j,3) == "adeg"
                       temp_utama = kata(j,3);
                   elseif kata(j,3) == "pa gantung"
                       temp_utama = kata(j,4);
                       kata_utama = char(temp_utama);
                       temp_utama = kata_utama(1:end-1);
                       flag_p = 1;
                   else
                       temp_utama = kata(j,4);
                       kata_utama = char(temp_utama);
                       temp_utama = kata_utama(1:end-1);

                       if flag_taleng == 2
                           temp_vokal = "e";
                       else
                           temp_vokal = kata_utama(end-0:end);
                       end                       
                   end
               elseif kata(j,2) == "2"
                   if kata(j,4) == "ya" | kata(j,4) == "wa" | kata(j,4) == "u"
                       if kata(j,4) == "ya"
                           temp_bawah_vok = "ia";
                       elseif kata(j,4) == "wa"
                           temp_bawah_vok = "ua";
                       else
                           temp_bawah_vok = kata(j,4);
                       end
                   else
                       temp_bawah = kata(j,4);
                       kata_utama = char(temp_bawah);
                       temp_bawah = kata_utama(1:end-1);
                   end
               elseif kata(j,2) == "3"
                   if kata(j,4) == "ng" | kata(j,4) == "r"
                       temp_atas_kons = kata(j,4);
                   else
                       temp_atas_vok = kata(j,4);
                   end
               end
            end   
        end

        %pembentukan kata
        if flag_p == 1
            potong_kata = char(bentuk_kata);
            vokal = potong_kata(end-0:end);
            bentuk_kata = potong_kata(1:end-1);
            flag_p = 0;
            if vokal == 'u' | vokal == "u"
                temp_utama = "s";
                flag_s = 0;
            end
        end

        if temp_bawah == ' ' & temp_bawah_vok == ' ' & temp_atas_kons == ' ' & temp_atas_vok == ' ' %ketika kluster hanya ada pengawak

            if flag_taleng == 1
                temp_vokal = "e";
                flag_taleng = 2;
                continue

            elseif flag_o == 1
                bentuk_kata = tedong(bentuk_kata);
                flag_taleng = 0;
                flag_o = 0;
                continue

            elseif temp_utama == "adeg"
                bentuk_kata = adeg(bentuk_kata);
                continue

            elseif temp_utama == "bisah"
                temp_utama = "h";

            else
                temp_utama = aksara_tengah(temp_utama,temp_vokal);
            end        

        elseif temp_bawah == ' ' & temp_bawah_vok == ' ' %ketika gantungan tidak ditemukan, maka dicek sandangnya       

            temp_utama = aksara_atas(temp_utama, temp_vokal, temp_atas_vok, temp_atas_kons);

        elseif temp_atas_vok == ' ' & temp_atas_kons == ' ' %ketika sandang tidak ada dalam kluster, maka dicek gantungannya

            temp_utama = aksara_bawah(temp_utama, temp_vokal, temp_bawah_vok, temp_bawah);

        else

            temp_utama = aksara_lengkap(temp_utama, temp_vokal,temp_bawah, temp_bawah_vok, temp_atas_vok, temp_atas_kons);

        end

        temp_kata = temp_utama;

        bentuk_kata = strcat(bentuk_kata, temp_kata);

    end

%     disp(join(bentuk_kata));

    function utama = adeg(bentuk_kata)
        potong_kata = char(bentuk_kata);
        bentuk_kata = potong_kata(1:end-1);
        utama = bentuk_kata;
    end

    function utama=aksara_tengah(temp_utama, temp_vokal)
        if temp_utama == "adeg"

        elseif  temp_utama == "a"
            temp_utama = temp_utama;   
        else
            temp_utama = strcat(temp_utama,temp_vokal);
        end
        utama = temp_utama;
    end

    function utama=aksara_atas(temp_utama, temp_vokal, temp_atas_vok, temp_atas_kons)
        if temp_atas_vok == ' ' %pengecekan sandang ng dan r
            temp_utama = strcat(temp_utama, temp_vokal);
            temp_utama = strcat(temp_utama, temp_atas_kons);

        elseif temp_atas_kons == ' '
            temp_utama = strcat(temp_utama, temp_atas_vok);

        else
            temp_utama = strcat(temp_utama, temp_atas_vok);
            temp_utama = strcat(temp_utama, temp_atas_kons);
        end

        utama = temp_utama;
    end

    function utama = aksara_bawah(temp_utama, temp_vokal, temp_bawah_vok, temp_bawah)

        if temp_bawah_vok == ' '
            temp_utama = strcat(temp_utama, temp_bawah);
            temp_utama = strcat(temp_utama, temp_vokal);
        elseif temp_bawah == ' '
            temp_utama = strcat(temp_utama, temp_bawah_vok);
        else
            temp_utama = strcat(temp_utama, temp_bawah);
            temp_utama = strcat(temp_utama, temp_bawah_vok);
        end

        utama = temp_utama;
    end

    function utama=aksara_lengkap(temp_utama, temp_vokal, temp_bawah, temp_bawah_vok, temp_atas_vok, temp_atas_kons)
        if temp_bawah_vok == ' '
            temp_utama = strcat(temp_utama, temp_bawah);
        elseif temp_bawah == ' '
            temp_utama = strcat(temp_utama, temp_bawah_vok);
        else
            temp_utama = strcat(temp_utama, temp_bawah);
            temp_utama = strcat(temp_utama, temp_bawah_vok);
        end

        if temp_atas_vok == ' ' %pengecekan sandang ng dan r
            temp_utama = strcat(temp_utama, temp_atas_kons);

        elseif temp_atas_kons == ' '
            temp_utama = strcat(temp_utama, temp_atas_vok);

        else
            temp_utama = strcat(temp_utama, temp_atas_vok);
            temp_utama = strcat(temp_utama, temp_atas_kons);
        end

        utama = temp_utama;
    end

    function utama = tedong(bentuk_kata)
        potong_kata = char(bentuk_kata);
        akhir_kata = potong_kata(end-2:end);
%         disp(akhir_kata)
        awal_kata = potong_kata(1:end-3);
%         disp(awal_kata)
        potong_kata = strrep(akhir_kata, 'e', 'o');
        bentuk_kata = strcat(awal_kata, potong_kata);

        utama = bentuk_kata;
    end
end