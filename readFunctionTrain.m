% Copyright 2017 The MathWorks, Inc.
function I = readFunctionTrain(filename)
    % Resize the flowers images to the size required by the network.
    I = imread(filename);
    [height, width, dim] = size(I);
    if isa(I, "logical") == 1
        I = im2uint8(I);
    end
    if dim == 1
        I = cat(3, I, I, I);
    end
    I = imresize(I, [224 224]);
    
%     I = imresize(I, [227 227]);
    % 227 -> AlexNet
end