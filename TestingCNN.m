function testing = TestingCNN(model, image)
    number = 1;
    folder_name = 'temp\';

    if ~exist(folder_name, 'dir')
       mkdir(folder_name)
    end
    file_name = strcat(folder_name, int2str(number),'.jpg');

    while isfile(file_name)
         number = number+1;
         file_name = strcat(folder_name, int2str(number),'.jpg');
    end
    imwrite(image, file_name);
    
    image = imread(file_name);
    I = imresize(image, [224 224]);
    
    if isa(I, "logical") == 1
        I = im2uint8(I);
    end
    
    image = cat(3, I, I, I);
    predictedLabels = classify(model, image); 
    disp(predictedLabels)
    hasil = string(predictedLabels);
    testing = kamus_aksara(hasil);
end