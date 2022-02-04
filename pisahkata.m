function result = pisahkata(string)
    conn = koneksi; %koneksi database
    exec(conn, "DELETE FROM tb_hasil_sementara");
    hasil = pisah_kata(string, conn);
    result = hasil{1};
    %tb_hasil_sementara = ['id_hasil_sementara','id_kalimat', 'id_kata', 'hasil_kata', 'kata_ke', 'pos_akhir','sisa_kata', 'parrent'];
    global tb_hasil_sementara;
    tb_hasil_sementara = [0,0,0,"",0,"","",""]; 
end

function [kata_, p_awal, p_akhir, len_kata, last_id, stts] = cek_kata_db (hasil, pos_awal, kata_k, in_p_loop, sisa, parrent, conn)
    %sqlquery = ["SELECT * FROM tb_kata_bali WHERE kata_bali = " num2str(hasil)];
    stts = 0;
    cekDB = fetch(conn, "SELECT*FROM tb_kata_bali WHERE kata_bali = '"+hasil+"' ");
%     disp(cekDB)
    kata_=0;
    p_awal=0;
    p_akhir=0;
    len_kata=0;
    last_id=0;
    stts=0;
    
    if isempty(cekDB) == false
        p_awal = pos_awal;
        
        lihat_kata = fetch(conn,"SELECT*FROM tb_kata_bali WHERE kata_bali = '"+hasil+"'");
        id_ = lihat_kata.id_kata_bali;
        kata_ = lihat_kata.kata_bali;
        len_kata = strlength(kata_);
        p_akhir = p_awal + len_kata -1;
                
        %data = table(1,id_,kata_,kata_k,p_akhir,sisa,parrent,'VariableNames',{'id_kalimat', 'id_kata', 'hasil_kata', 'kata_ke', 'pos_akhir','sisa_kata', 'parrent'});
        %simpan_kata = sqlwrite(conn, 'tb_hasil_sementara', data)
        
        %parrent = int2str(parrent);
        
        cek = fetch(conn, "SELECT*FROM tb_hasil_sementara");
        if isempty(cek)
            parrent = int2str(parrent);
        end
        
        if isempty(sisa)
            sisa = "";
        end
        
        if parrent == 0
            parrent = int2str(parrent);
        end
        
        kata_size = size(kata_);
        if kata_size(1) > 1
            kata_ = kata_{1,1};
        end
        
        size_p = size(p_akhir);
        if size_p(1) > 1
            p_akhir = p_akhir(1);
        end
        
        
        c = {1,kata_,kata_k,p_akhir,sisa,parrent};
        colnames = {'id_kalimat', 'hasil_kata', 'kata_ke', 'pos_akhir','sisa_kata', 'parrent'};
        data = cell2table(c,'VariableNames',colnames);
        tableName= 'tb_hasil_sementara';
        sqlwrite(conn, tableName, data);
        
        %exec(conn, "INSERT INTO tb_hasil_sementara (id_hasil_kata, id_kalimat, id_kata, hasil_kata, kata_ke, pos_akhir, sisa_kata, parrent) VALUES ('',1,"+id_+",'"+kata_+"',"+kata_k+","+p_akhir+",'"+sisa+"',"+parrent+")");
      
        
        %%
        last_id = fetch(conn, "select id_hasil_kata from tb_hasil_sementara order by id_hasil_kata DESC limit 1");
        last_id = last_id.id_hasil_kata;
        exec(conn, "UPDATE tb_hasil_sementara SET parrent = CONCAT(parrent, '/', '"+last_id+"') WHERE id_hasil_kata = '"+last_id+"'");
        
        %update(conn,tablename,colnames,data,whereclause)
                
        stts = 1;
        
    end

end

function ListJawaban = cek_sekali(in_kata, in_pos_awal, in_p_loop, in_kata_ke, len, parrent, conn)
    index = 0;

    for a=1:in_p_loop-1
        in_kata = char(in_kata);
        %hasil = extractBetween(in_kata,in_pos_awal+1,a+1);
        
        hasil = in_kata(in_pos_awal+1:a+1);
        
        sisa = in_kata(a+2:strlength(in_kata));
        [kata_, p_awal, p_akhir, len_kata, last_id, stts] = cek_kata_db(hasil, in_pos_awal, in_kata_ke, in_p_loop, sisa, parrent,conn);
        hasil_kata = kata_;
        hasil_pos_akhir = p_akhir;
        
        if stts == 1
            pos_temp = p_awal+len_kata-1;
            len_kata = len_kata;
            pos_akh = p_akhir;
            
            size_len = size(len_kata);
            if size_len(1) > 1
                len_kata = len_kata(1);
            end
            
            
            ListJawaban = [in_p_loop, len_kata, in_kata_ke, pos_akh, hasil_kata, last_id, stts, last_id];
%             disp(ListJawaban)
            index = index + 1;
        else
            ListJawaban = [0,0, 0, 0, "0", 0, 0, 0];
        end
    end
end

function hasil2 = pisah_kata(kata,conn)
    
    pos_awal = 0;
    in_kata_ke = 1;
    len = strlength(kata);
    p_loop = len;
    jml_kata = 0;
    cek_sekali_lagi = [];
    jumlah_kesamaan = 0;
    kata_ke = 0;
    selesai = 0;
    parrent = 0;
    sebelumsisa = "";
    stts = 0;
    IdTerakhir = 0;
    sudah = 0;
    hasil2 = [];
    
    while selesai < 1
        
        %sqlquery = ['SELECT * FROM tb_hasil_sementara WHERE kata_ke = ' num2str(kata_ke)];
        RowData = fetch(conn, "SELECT*FROM tb_hasil_sementara WHERE kata_ke = "+kata_ke);
        ukuran = size(RowData);
        ukuran = ukuran(1);
        
        if(ukuran == 0 && sudah == 1)
            Jawaban = fetch(conn, "SELECT*FROM tb_hasil_sementara WHERE sisa_kata IS NULL");
            
            %Masih ERROR disini
            for i = 1:height(Jawaban)
                JawabanHasil = Jawaban.parrent(i);
                JawabanParrent = strrep(JawabanHasil,"/",",");
                
                Final = fetch(conn, "SELECT GROUP_CONCAT(hasil_kata SEPARATOR ' ') as hasil FROM tb_hasil_sementara WHERE id_hasil_kata IN ("+JawabanParrent+")");
                Final.hasil = strrep(' .', '.', Final.hasil);
                Final.hasil = strrep(' ,', ',', Final.hasil);
                Final.hasil = strrep(' - ', '-', Final.hasil);
                
                hasil2 = [hasil2,Final.hasil];
            end
            
            selesai = 1;
            if isempty(hasil2) == false
                hasil2 = hasil2;
            else
                hasil2 = [hasil2, "Kata tidak ditemukan"];
            end
            
        elseif(ukuran==0)
            listHasil = [];
            listHasil = cek_sekali(kata, pos_awal, p_loop, kata_ke, len, parrent,conn);
            sudah = 1;
%             disp('cek ke DB');
        end
        
        index = 0;
        vars = {'id_hasil_kata', 'sisa_kata', 'parrent'};
        data_t = RowData(:, vars);
        data_t = table2cell(data_t);
        for row = 1:ukuran
            if index == 0
                kata_ke = kata_ke + 1;
            end
            index = index+1;
            
           
            if isempty(row) == false
                vars = {'id_hasil_kata', 'sisa_kata', 'parrent'};
                kata = data_t{row,2};
                
                if isempty(kata)
                    kata = "";
                    disp("kata kosong")
                else
                    
                    cek_sekali_ = cek_sekali(kata, pos_awal, strlength(kata), kata_ke, strlength(kata), data_t{row,3}, conn);

                    ID = data_t{row,1};
                    
                    datat = cek_sekali_{1,7};

                    if datat == 1
                        exec(conn, "UPDATE tb_hasil_sementara SET status = 1 WHERE id_hasil_kata="+ID+"");               
                    end
                end
                
            end
        
        sebelumsisa = kata;
            
        end
        
    end
    
    if(selesai==1 && kata ~= "")
        hasil2 = [hasil2,"Kata Tidak Ditemukan"];
    end
end
