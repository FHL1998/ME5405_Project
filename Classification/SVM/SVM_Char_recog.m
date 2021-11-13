clc;
clear all;
close all;
%% Digit Classification Using HOG Features
% This example shows how to classify digits using HOG features and a
% multiclass SVM classifier.
%
% Copyright 2013-2015 The MathWorks, Inc.

% Edited by Huajing Zhao  for character classification using EMNIST 
% dataset, 2017-12-11

%%
% The example uses the |fitcecoc| function from the Statistics and Machine
% Learning Toolbox(TM) and the |extractHOGFeatures| function from the
% Computer Vision System Toolbox(TM).

%% Digit Data Set
% % Load training and test data using |imageDatastore|.
% syntheticDir   = fullfile(toolboxdir('vision'), 'visiondata','digits','synthetic');
% handwrittenDir = fullfile(toolboxdir('vision'), 'visiondata','digits','handwritten');
% 
% % |imageDatastore| recursively scans the directory tree containing the
% % images. Folder names are automatically used as labels for each image.
% trainingSet = imageDatastore(syntheticDir,   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% testSet     = imageDatastore(handwrittenDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 

%%
% You need to put your own folders of test and training dataset of images
% under current folder. Here we used images abstracted from dataset 
% using select_train.m. Each sub-folders for train/test named 1-3 A-B 
trainingSet = imageDatastore('./dataset/train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
testSet = imageDatastore('./dataset/test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
countEachLabel(trainingSet)
countEachLabel(testSet)
%%
% Show a few of the training and test images

figure;

subplot(2,3,1);
imshow(trainingSet.Files{1});
title('training example 1')

subplot(2,3,2);
imshow(trainingSet.Files{764});
title('training example 2')

subplot(2,3,3);
imshow(trainingSet.Files{1528});
title('training example 3')

subplot(2,3,4);
imshow(testSet.Files{1});
title('test example 1')

subplot(2,3,5);
imshow(testSet.Files{255});
title('test example 2')

subplot(2,3,6);
imshow(testSet.Files{510});
title('test example 3')

%% Pre-process the images
% Prior to training and testing a classifier, a pre-processing step is
% applied to remove noise artifacts introduced while collecting the image
% samples. This provides better feature vectors for training the
% classifier.

% Show pre-processing results
% exTestImage = readimage(testSet,37);
% processedImage = imbinarize(exTestImage);
% processedImage = exTestImage;
% 
% figure;
% subplot(1,2,1),imshow(exTestImage)
% subplot(1,2,2),imshow(processedImage)

%% Using HOG Features
% The data used to train the classifier are HOG feature vectors extracted
% from the training images. Therefore, it is important to make sure the HOG
% feature vector encodes the right amount of information about the object.
% The |extractHOGFeatures| function returns a visualization output that can
% help form some intuition about just what the "right amount of
% information" means. By varying the HOG cell size parameter and
% visualizing the result, you can see the effect the cell size parameter
% has on the amount of shape information encoded in the feature vector:

img = readimage(trainingSet, 206);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

% Show the original image
figure; 
subplot(1,4,1); imshow(img,'InitialMagnification', 'fit');
title({'original image';'character 1'})

% Visualize the HOG features
subplot(1,4,2);  
plot(vis2x2); 
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});

subplot(1,4,3);
plot(vis4x4); 
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});

subplot(1,4,4);
plot(vis8x8); 
title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});
%%
% The visualization shows that a cell size of [8 8] does not encode much
% shape information, while a cell size of [2 2] encodes a lot of shape
% information but increases the dimensionality of the HOG feature vector
% significantly. A good compromise is a 4-by-4 cell size. This size setting
% encodes enough spatial information to visually identify a digit shape
% while limiting the number of dimensions in the HOG feature vector, which
% helps speed up training. In practice, the HOG parameters should be varied
% with repeated classifier training and testing to identify the optimal
% parameter settings.

cellSize = [8 8];
hogFeatureSize = length(hog_8x8) ;

%% Train a Digit Classifier
% Digit classification is a multiclass classification problem, where you
% have to classify an image into one out of the ten possible digit classes.
% In this example, the |fitcecoc| function from the Statistics and Machine
% Learning Toolbox(TM) is used to create a multiclass classifier using
% binary SVMs.
%
% Start by extracting HOG features from the training set. These features
% will be used to train the classifier.

% Loop over the trainingSet and extract HOG features from each image. A
% similar procedure will be used to extract features from the testSet.

numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingSet, i);
    %img = rgb2gray(img);
    % Apply pre-processing steps
    % img = imbinarize(img);
    % img = img;
    trainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);  
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

%%
% Next, train a classifier using the extracted features. 

% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
% classifier = fitcecoc(trainingFeatures, trainingLabels);
% classifier = fitcecoc(trainingFeatures, trainingLabels,'Coding','onevsone');
template1 = templateSVM('KernelFunction','gaussian', 'SaveSupportVectors',true);
template2 = templateSVM('KernelFunction','linear', 'SaveSupportVectors',true);
template3 = templateSVM('KernelFunction','polynomial', 'SaveSupportVectors',true);

classifier = fitcecoc(trainingFeatures, trainingLabels, 'Coding','onevsall', 'Learners',template2);

%% Evaluate the Digit Classifier
% Evaluate the digit classifier using images from the test set, and
% generate a confusion matrix to quantify the classifier accuracy.
% 
% As in the training step, first extract HOG features from the test images.
% These features will be used to make predictions using the trained
% classifier.

% Extract HOG features from the test set. The procedure is similar to what
% was shown earlier and is encapsulated as a helper function for brevity.
[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet_gray(testSet, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

helperDisplayConfusionMatrix_char(confMat)
fprintf('Confusion Matrix Done! \n')

plotconfusion(testLabels,predictedLabels)

total_accuracy = trace(confMat)/(254*6);

%%
% The table shows the confusion matrix in percentage form. The columns of
% the matrix represent the predicted labels, while the rows represent the
% known labels. Training with a more representative data set like MNIST [2] or
% SVHN [3], which contain thousands of handwritten characters, is likely to
% produce a better classifier compared with the one created using this
% synthetic data set.
%% Predict the letters on test images

fprintf('Analysing test images... \n')
img1 = imbinarize(imcomplement(imread('test_image/rearrange.jpg')));
% img1 = imresize(img1,[26 78],'bilinear');
step = [1,1];
labels = [];
scores = {};
figure, imshow(img1)
for i = 1:step(1):(size(img1,1) - 20) % 1:1:3
    imT = img1(1:26,26*(i-1)+1:i*26);
    figure,imshow(imT)
    if sum(sum(imT==0)) > 30
        disp('Character detected!')
        features_test = extractHOGFeatures(imT,'CellSize',cellSize);
        [predictTestLabel,test_scores] = predict(classifier, features_test);
        max_score = max(test_scores);
        labels=[labels predictTestLabel];
        scores=[scores max_score];
        coordXY = [i];
%         numTestImages = numTestImages + 1;
    end
end
% features = extractHOGFeatures(img1,'CellSize',cellSize);
figure,imshow(img1)
[predictTestLabel,scores] = predict(classifier, features_test)
drawSquare(5, 3, 17, 'b', labels(1))
drawSquare(31, 3, 17, 'b', labels(2))
drawSquare(58, 3, 17, 'b', labels(3))
drawSquare(83, 3, 17, 'b', labels(4))
drawSquare(109, 3, 17, 'b', labels(5))
drawSquare(135, 3, 17, 'b', labels(6))

% caracter_detected=scores >= 0;
% maxScoresIm = max(scores);
% disp(['Size of scores: ' size(scores)])
% for i = 1:size(scores, 1)
%      disp(['Label: ' predictTestLabel(i) 'Max score: ' num2str(maxScoresIm(i))])
% end
    
% DirTI   = fullfile('./test_image/');
% step = [1,1];
% % First or second test image?
% imNum = 7;
% % Run the Sliding window function
% [L] = slidingWindowAndPlot(DirTI, imNum, step, cellSize, classifier, confMat)

%% Accuracy 
accuracy = (sum(testLabels == predictedLabels)/length(testLabels));
disp(['Total accuracy: ' num2str(100*accuracy) ' %.']);
displayEndOfDemoMessage(mfilename)
%% Summary
% This example illustrated the basic procedure for creating a multiclass
% object classifier using the |extractHOGfeatures| function from the
% Computer Vision System Toolbox and the |fitcecoc| function from the
% Statistics and Machine Learning Toolbox(TM). Although HOG features and an
% ECOC classifier were used here, other features and machine learning
% algorithms can be used in the same way. For instance, you can explore
% using different feature types for training the classifier; or you can see
% the effect of using other machine learning algorithms available in the
% Statistics and Machine Learning Toolbox(TM) such as k-nearest neighbors.


