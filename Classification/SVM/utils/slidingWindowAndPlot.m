function [L] = slidingWindowAndPlot(DirTI, imNum, step, cellSize, classifier, confMat)

imTestSet = imageSet(DirTI);
% figure; imshow(imTestSet.ImageLocation{imNum});
I = imbinarize(imcomplement(imread(imTestSet.ImageLocation{imNum})));
I = imresize(I,[26 78],'bilinear');

threshold =  100;

% Apply sliding window approach and identify features

numTestImages = 1;
coordXY = [];
% for i =1:3
%     for j = 1:3
%         imT = I(26*(i-1)+1:i*26,26*(j-1)+1:j*26)
%         figure,imshow(imT)
for i = 1:step(1):(size(I,1) - 23) % 1:1:3
    for j = 1 % 1:1:3
%         imT = I(i:i+25,j:j+25)
        imT = I(1:26,26*(i-1)+1:i*26);
        figure,imshow(imT)
        if sum(sum(imT==0)) > 30
%             disp('Character detected!')
            featuresTest(numTestImages,:) = extractHOGFeatures(imT,'CellSize',cellSize);
            coordXY(numTestImages,:) = [i,j];
            numTestImages = numTestImages + 1;
        end
    end
end
size(featuresTest)
% Find the likelyhood of each letter to be present in each image
[predictTestLabel,scores] = predict(classifier, featuresTest);
caracter_detected=scores >= 0;
maxScoresIm = max(scores);
% disp(size(scores))
count = 0;
for j = 1:size(scores, 1)
    for i = 1:size(scores, 2)
        disp(['Label: ' predictTestLabel(i) '. Max score: ' num2str(maxScoresIm(i))])
        if caracter_detected(j, i)
            count = count+1;
            LableFound(count) = char(i+1);
            disp(['Max score for ' char(i+1) ' is ' num2str(maxScoresIm(i))])
            disp(['Sizes: ' num2str(size(coordXY)) ' ' num2str([i, j])])
            C = coordXY(j,:);
            coord4Lable(count,:) = C(randi(size(C,1)),:);
            position(count,:) = [(coord4Lable(count, 1)) (coord4Lable(count,2)) 6 6];
        end
    end
end

figure;

for i = 1:count
%     subplot(1,count,i);
%     subplot(1,5,i);
%     imshow(I(position(i,1):position(i,1)+20,position(i,2):position(i,2)+20));
    hold on;
    imshow(I);
    drawSquare(position(i, 2), position(i, 1), 21, 'b', LableFound(i))
%     cmPos = double(LableFound(i))-96;
%     confid(i) = confMat(cmPos,cmPos)/sum(confMat(cmPos,:))*100;
%     title(LableFound(i));
%     xlabel({round(confid(i)) '%'});
%     if i > 5
%         break;
%     end;
end

L = LableFound;

end
