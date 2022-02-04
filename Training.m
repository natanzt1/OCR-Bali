function status = Training()
    rootFolder = 'training';
    imds = imageDatastore(rootFolder, 'IncludeSubfolders', true,...
        'LabelSource', 'foldernames');

    imds.ReadFcn = @readFunctionTrain;

    %% Split data into training and test sets 
    [trainingImages, testImages] = splitEachLabel(imds, 0.75);

    % net = googlenet; 
    % net = alexnet;
    net = resnet18;
    %net = densenet201(); 

    %% Review Network Architecture 
    % layers = net.Layers;
    inputSize = net.Layers(1).InputSize;

    %% Modify Pre-trained Network 
    % VGG was trained to recognize 1000 classes, we need to modify it to
    % recognize just 5 classes. 
    count = count_class(rootFolder);

    if isa(net,'SeriesNetwork') 
      lgraph = layerGraph(net.Layers); 
    else
      lgraph = layerGraph(net);
    end 

    [learnableLayer,classLayer] = findLayersToReplace(lgraph);

    if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
        newLearnableLayer = fullyConnectedLayer(count, ...
            'Name','new_fc', ...
            'WeightLearnRateFactor',10, ...
            'BiasLearnRateFactor',10);

    elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
        newLearnableLayer = convolution2dLayer(1,count, ...
            'Name','new_conv', ...
            'WeightLearnRateFactor',10, ...
            'BiasLearnRateFactor',10);
    end

    lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);


    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

    % layers = lgraph.Layers;
    % connections = lgraph.Connections;
    % 
    % layers(1:10) = freezeWeights(layers(1:10));
    % lgraph = createLgraphUsingConnections(layers,connections);


    pixelRange = [-30 30];
    scaleRange = [0.9 1.1];
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXTranslation',pixelRange, ...
        'RandYTranslation',pixelRange, ...
        'RandXScale',scaleRange, ...
        'RandYScale',scaleRange);

    augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainingImages, ...
        'DataAugmentation',imageAugmenter);

    augimdsValidation = augmentedImageDatastore(inputSize(1:2),testImages);
    %% Perform Transfer Learning
    % For transfer learning we want to change the weights of the network ever so slightly. How
    % much a network is changed during training is controlled by the learning
    % rates. 
    miniBatchSize = 16;
    valFrequency = floor(numel(trainingImages.Files)/miniBatchSize);
    % valFrequency = 5;
    opts = trainingOptions('sgdm', ...
        'InitialLearnRate', 3e-4,...
        'MaxEpochs', 20, ...
        'MiniBatchSize', miniBatchSize, ...
        'Shuffle','every-epoch', ...
        'ValidationData',augimdsValidation, ...
        'ValidationFrequency',valFrequency, ...
        'Verbose', false, ...
        'Plots','training-progress');

    %% Set custom read function 
    % One of the great things about imageDataStore it lets you specify a
    % "custom" read function, in this case it is simply resizing the input
    % images to 227x227 pixels which is what AlexNet expects. You can do this by
    % specifying a function handle of a function with code to read and
    % pre-process the image. 

    %% Train the Network 
    % This process usually takes about 5-20 minutes on a desktop GPU. 

    [model, info] = trainNetwork(augimdsTrain, lgraph, opts);
    save model;

    %[resnet, info] = trainNetwork(trainingImages, lgraph, opts);
    %save resnet;
    status = 'Training success';
end