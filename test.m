clc;
clear all;
close all;


%% Read the txt file of character 1,covert it into matrix format and display
%character_txt=textread('D:\MSc Course\ME5405\chromo.txt','r'','%s',64);% read image data from txt file
%chatacter_matrix=uint8(cell2mat(character_txt))
character1_txt = fopen('D:\MSc Course\ME5405\chromo.txt','r');  % open txt file
character1_cell = textscan(character1_txt,'%s',64);                                      % read formatted data from text file 
chatacter1_matrix = uint8(cell2mat(character1_cell{1,1}));                          % transfer cell to matrix and decode it into unsigned integer  

% uint8('0')=48,uint8('9')=57,uint8('A')=65,uint8('0')=66,uint8('V')=86,uint8(10)=10
% convert 0~255 to 0~31

for x = 1:64 % traverse along length
    for y = 1:64
        if(chatacter1_matrix(x,y) >= uint8('0') && chatacter1_matrix(x,y) <= uint8('9'))
            chatacter1_matrix(x,y) = chatacter1_matrix(x,y) - uint8('0');
        elseif(chatacter1_matrix(x,y) >= uint8('A') && chatacter1_matrix(x,y)<=uint8('V')) 
            chatacter1_matrix(x,y)=chatacter1_matrix(x,y) - uint8('A') + (uint8('9') - uint8('0')+1); 
        else
            disp('Traverse 	Error:Out of Range')         %report error when out of range
        end
    end
end
chatacter1_image1 = mat2gray(chatacter1_matrix);
figure(1),imshow(chatacter1_image1,'InitialMagnification', 'fit');
imwrite(chatacter1_image1,'image_origin.jpg','jpg');
Image = Image=im2double(imread('frose.jpg'));

[height,width,color]=size(Image);
edgeImage=zeros(height,width,color);
for c=1:color
    for x=1:width-1
        for y=1:height-1
            edgeImage(y,x,c)=abs(Image(y,x+1,c)-Image(y,x,c))+abs(Image(y+1,x,c)-Image(y,x,c));
        end
    end
end
sharpImage=Image+edgeImage;
subplot(131),imshow(Image),title('原图像');
subplot(132),imshow(edgeImage),title('梯度图像');
subplot(133),imshow(sharpImage),title('锐化图像');


% 
chatacter1_image1_gray =imread('image_origin.jpg');
figure(2),imshow(chatacter1_image1_gray ,'InitialMagnification', 'fit');

image1_thresholding_result_OSTU = imbinarize(chatacter1_image1_gray );
figure(7),imshow(double(image1_thresholding_result_OSTU));
%% 基于模糊熵阈值选择进行二值化操作
%隶属度 为0或1时，最清晰，取值为0.5时，最模糊
% image1_preprocessing_result = medfilt2((chatacter1_image1),[3,3]);
% figure(3),imshow(image1_preprocessing_result);
% image1_thresholding_result = Otsu(NewImage);
% figure(3),imshow(image1_thresholding_result);
image2_preprocessing_result = chatacter1_image1;
T=(max(image2_preprocessing_result(:))+min(image2_preprocessing_result(:)))/2;
equal=false;
while ~equal
    rb=find(image2_preprocessing_result>=T);
    ro=find(image2_preprocessing_result<T);
    NewT=(mean(image2_preprocessing_result(image2_preprocessing_result>=T))+mean(image2_preprocessing_result(image2_preprocessing_result<T)))/2;
    equal=abs(NewT-T)<1/256;
    T=NewT;
end
result=imbinarize(image2_preprocessing_result,T);
figure,imshow(result),title('迭代方法二值化图像 ');

%% Functions of Image 1
function [txt_image] = convert_txt_matrix(txt_file)
txt_cell = textscan(txt_file,'%s',64);                                      % read formatted data from text file 
txt_matrix = uint8(cell2mat(txt_cell{1,1}));                          % transfer cell to matrix and decode it into unsigned integer  
% uint8('0')=48,uint8('9')=57,uint8('A')=65,uint8('0')=66,uint8('V')=86,uint8(10)=10
% convert 0~255 to 0~32
for x = 1:64 % traverse along length
    for y = 1:64
        if(txt_matrix(x,y) >= uint8('0') && txt_matrix(x,y) <= uint8('9'))
            txt_matrix(x,y) = txt_matrix(x,y) - uint8('0');
        elseif(txt_matrix(x,y) >= uint8('A') && txt_matrix(x,y)<=uint8('V')) 
            txt_matrix(x,y)=txt_matrix(x,y) - uint8('A') + (uint8('9') - uint8('0')+1); 
        else
            disp('Traverse 	Error:Out of Range')         %report error when out of range
        end
    end
end
txt_image = mat2gray(txt_matrix);
end