function [pos_XY] = cari_posisi_warna(huruf, warna)
    BW = huruf;
    s=size(BW);
    nrow = 0;
    pos_XY = [];
    for col=1:s(2)
        for row = 1:s(1)
          if BW(row,col) == warna
              nrow = nrow+1;
              pos_XY(nrow,1) = row;
              pos_XY(nrow,2) = col;
              pos_XY(nrow,3) = BW(row,col);
          end
       end
    end
end

