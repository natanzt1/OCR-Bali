function [pot_row] = crop_citra(image_asal)
%     min_height_char = 50;
    min_height_char = 100;
    toleransi_noise = 1;

    %image1 = imread(image_asal);
    image1 = image_asal;
    image_size = size(image1);
    height_image = image_size(1);
    width_image = image_size(2);

    sizeblok = [height_image width_image];

    fungsi = @(block_struct) im2bw(block_struct.data, graythresh(block_struct.data));
    BW1 = blockproc(image1,sizeblok,fungsi); %run of fuction blockproc


    nrow = 0;
    jum_row = 0;
    while nrow <= height_image
        image_ = imcrop(BW1,[0,nrow,width_image,0]);
        jum_black = width_image - sum(image_);
        if jum_black >= toleransi_noise %sudah masuk ke obyek baris aksara
            first_row = nrow;
            height_crop = 0;
            while ((jum_black >= toleransi_noise) | (height_crop <= min_height_char))
                nrow = nrow + 1;
                height_crop = height_crop + 1;
                image_ = imcrop(BW1,[0,nrow,width_image,0]);
                jum_black = width_image - sum(image_);       
            end
            end_row = nrow;
            jum_row = jum_row + 1;

            if height_crop > min_height_char
                file_name_result = strcat('baris_aksara',int2str(jum_row),'.jpg');    
                image_crop = imcrop(BW1,[0,first_row,width_image,height_crop]);
                imwrite (image_crop,file_name_result);
            end

        end
        nrow = nrow + 1;
        pot_row = jum_row;
end