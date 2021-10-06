clc;
clear all;
close all;

%% Read the txt file of character 1,covert it into matrix format and display
Image1_txt = fopen('chromo.txt','r'); 
Image1 = convert_txt_image(Image1_txt);


% figure(1),imshow(Image1),title('ԭʼͼ��Ⱦɫ��');


% imwrite(Image1,'results/image1_origin.jpg','jpg');
% imwrite(Image2,'results/image2_origin.jpg','jpg');

%% ͼ��Ԥ����
Image1=imread('image1_origin.jpg');
% G = imfilter(Image1, fspecial('gaussian',[3,3],1), 'replicate');
pre_process_image1 = pre_process(Image1);
% figure(2),imshow(pre_process_image1),title('enhancement');
% imwrite(pre_process_image1,'results/image1_enhancement.jpg','jpg');


%% ���ڵ����������ֵѡ����ж�ֵ������
Image1=imread('results/image1_enhancement.jpg');
iteration_thresh_result = iteration_thresh(Image1);
% figure(3),imshow(iteration_thresh_result),title('Image1 ������ֵѡ��');


%% ����ģ������ֵѡ����ж�ֵ������
entropy_thresh_result = fuzzy_entropy(Image1);
% figure(4),imshow(entropy_thresh_result),title('Image1 ģ������ֵѡ��');

%% ����OSTUѡ����ж�ֵ������
ostu_thresh_result = ostu_thresh(Image1);
% figure(5),imshow(ostu_thresh_result ),title('Image1 OSTU��ֵѡ��');


% CC = bwconncomp(ostu_thresh_result);
% L = labelmatrix(CC);
% 
% figure(5),imshow(L),title('label_result');


%% Implementation of Image2
Image2_txt = fopen('charact1.txt','r'); 
Image2 = convert_txt_image(Image2_txt);
figure(7),imshow(Image2),title('ԭʼͼ���ַ�');

%% ͼ��Ԥ����
Image2=imread('image2_origin.jpg');

%% ���ڵ����������ֵѡ����ж�ֵ������
image2_iteration_thresh_result = iteration_thresh(Image2);
figure(8),imshow(image2_iteration_thresh_result),title('Image2 ������ֵѡ��');
imwrite(image2_iteration_thresh_result,'results/thresholding/image2_iteration_thresh.jpg','jpg');

%% ����ģ������ֵѡ����ж�ֵ������
image2_entropy_thresh_result = fuzzy_entropy(Image2);
figure(9),imshow(image2_entropy_thresh_result),title('Image2 ģ������ֵѡ��');
imwrite(image2_entropy_thresh_result,'results/thresholding/image2_entropy_thresh.jpg','jpg');

%% ����OSTUѡ����ж�ֵ������
image2_ostu_thresh_result = ostu_thresh(Image2);
figure(10),imshow(image2_ostu_thresh_result),title('Image2 OSTU��ֵѡ��');
imwrite(image2_ostu_thresh_result,'results/thresholding/image2_ostu_thresh.jpg','jpg');


%% Image2 ͼ��ϸ��
image2_one_pixel = one_pixel_image(image2_ostu_thresh_result);
figure(11),imshow(image2_one_pixel),title('image2 ͼ��ϸ�����1');
imwrite(image2_one_pixel,'results/thining/image2_one_pixel.jpg');


image2_stentiford_thining = Stentiford_Thining(image2_ostu_thresh_result);
% figure(12),imshow(image2_stentiford_thining),title('image2 ͼ��ϸ�����2');

%% Image2 ͼ���Ե��ȡ
[height,width, input,canny_edge_detection_result]  = canny_edge_detection(image2_ostu_thresh_result);
figure;imshow(canny_edge_detection_result );
[x_coordinate, y_coordinate] = meshgrid(1:width, 1:height);
figure;mesh(y_coordinate,x_coordinate,input);
xlabel('y');ylabel('x');zlabel('Gray Scale');axis tight
saveas(gcf,'results/outlines/image2_mesh.jpg');

figure;mesh(y_coordinate,x_coordinate,canny_edge_detection_result);
xlabel('y');ylabel('x');zlabel('Gray Scale');axis tight
saveas(gcf,'results/outlines/image2_canny_edge.jpg');

%% �����ַ��ķָ�
character_region = segment_character_region(image2_ostu_thresh_result);
% figure(17),imshow(character_region),title('Character Region of Image 2');



%�Ƚ�ԭͼ����ˮƽ������Ϊ��׼�ָ�Ϊ2����ͼ��
[height,width] = size(character_region);
half_height = round(height/2);
first_half_character_region = segment_character_region(imcrop(character_region,[1 1 width half_height]));
second_half_character_region = segment_character_region(imcrop(character_region,[1 half_height width half_height]));
% figure(18),imshow(first_half_character_region),title('First half character Region of Image 2');
% figure(19),imshow(second_half_character_region),title('Second half character Region of Image 2');

%�ֱ�λ������2��ͼ���ַ������������µ�ͼ���Ա��ں����ĵ����ַ��ķָ�

[char1,first_half_character_region]=seperate_character(first_half_character_region);
[char2,first_half_character_region]=seperate_character(first_half_character_region);
[char3,first_half_character_region]=seperate_character(first_half_character_region);
[char4,second_half_character_region]=seperate_character(second_half_character_region);
[char5,second_half_character_region]=seperate_character(second_half_character_region);
[char6,second_half_character_region]=seperate_character(second_half_character_region);

% figure(12),imshow(char1),title('1st Character ');
% figure(13),imshow(char2),title('2nd Character');
% figure(14),imshow(char3),title('3rd Character');
% figure(15),imshow(char4),title('4th Character');
% figure(16),imshow(char5),title('5th Character');
% figure(17),imshow(char6),title('6th Character');

char1 =enlarge_char_frame(char1); char2 =enlarge_char_frame(char2); char3 =enlarge_char_frame(char3);
char4 =enlarge_char_frame(char4);
char5 =enlarge_char_frame(char5); char6 =enlarge_char_frame(char6); 

% imwrite(char1,'results/seperated_character/1.jpg');
% imwrite(char2,'results/seperated_character/2.jpg');
% imwrite(char3,'results/seperated_character/3.jpg');
% imwrite(char4,'results/seperated_character/4.jpg');
% imwrite(char5,'results/seperated_character/5.jpg');
% imwrite(char6,'results/seperated_character/6.jpg')



