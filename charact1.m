clc;
clear all;
close all;

%% Implementation of Image2
%% Read the txt file of character 1, covert it into matrix format and display
Image2_txt = fopen('charact1.txt','r'); 
Image2 = convert_txt_image(Image2_txt);
imwrite(Image2,'results/image2_origin.jpg','jpg');
% figure(1),imshow(Image2),title('Original character image');


%% Image preprocessing
Image2=imread('image2_origin.jpg');
figure(2),imshow(Image2),title('Original character image');


%% Thresholding
%% Binarization operation based on threshold selection of iterative operation
Image2=imread('results/image2_origin.jpg');
iteration_thresh_result = iteration_thresh(Image2);
% figure(3),imshow(iteration_thresh_result),title('Image2 iteration threshold selection');

%% Binarization operation based on fuzzy entropy threshold selection
entropy_thresh_result = fuzzy_entropy(Image2);
% figure(4),imshow(entropy_thresh_result),title('Image2 Fuzzy entropy threshold selection');
%% Binary operation based on OTSU selection
image2_otsu_thresh_result = otsu_thresh(Image2);
% figure(5),imshow(image2_otsu_thresh_result ),title('Image2 OSTU threshold selection');

%% Image2 ÕºœÒ±ﬂ‘µÃ·»°
image2_morphological =morphology_edge(image2_otsu_thresh_result,strel('square',2)); % Extract edges based on morphology
image2_sobel=edge(image2_otsu_thresh_result,'sobel'); % Edge detection with Sobel operator
image2_roberts=roberts_edge_detection(image2_otsu_thresh_result); %Edge detection with Roberts operator
image2_prewitt=edge(image2_otsu_thresh_result,'prewitt'); % Edge detection with Prewitt operator
image2_log=edge(image2_otsu_thresh_result,'log'); % Edge detection with Log operator
[~,~, image2_canny] = canny_edge_detection(image2_otsu_thresh_result); % Canny edge detection

figure;
set(gcf, 'PaperPositionMode', 'auto');
set(gca,'LooseInset',get(gca,'TightInset'))
subplot(2,3,1), imshow(image2_morphological );
title('morphological');
subplot(2,3,2), imshow(image2_sobel);
title('sobel edge');
subplot(2,3,3), imshow(image2_roberts);
title('roberts edge');
subplot(2,3,4), imshow(image2_prewitt);
title('prewitt edge');
subplot(2,3,5), imshow(image2_log);
title('log edge');
subplot(2,3,6), imshow(image2_canny);
title('canny edge');


%% Image2 image thining
image2_one_pixel = one_pixel_image(image2_otsu_thresh_result);
% figure(6),imshow(image2_one_pixel),title('image2 Image refinement result Zhang Suen');
image2_stentiford_thining = Stentiford_Thining(image2_otsu_thresh_result);
% figure(7),imshow(image2_stentiford_thining),title('image2 Image refinement result Stentiford');

%% Image2 labelling
%% Image2 labelling based on BFS
 [I2_bfs, num] = BFS(image2_otsu_thresh_result, 8);
 % [I2_bfs, num] = BFS(image2_otsu_thresh_result, 4);
% colour 
img2_bfs = label2rgb(I2_bfs,'hsv',[0 0 0],'shuffle');
figure(6);imshow(img2_bfs,'InitialMagnification','fit');
%% Image2 labelling based on Two pass method
[s,I2lab] = twopass(image2_otsu_thresh_result);                           
% colour
img2_rgb = label2rgb(I2lab,'hsv',[0 0 0],'shuffle');
figure;imshow(img2_rgb,'InitialMagnification','fit');title("two-pass");

%% Segmentation after two pass labelling
%% Image2 labelling based on dfs method
 [I2_bfs, num] = BFS(image2_otsu_thresh_result, 8);
 % [I2_bfs, num] = BFS(image2_otsu_thresh_result, 4);
% colour 
img2_bfs = label2rgb(I2_bfs,'hsv',[0 0 0],'shuffle');
figure(6);imshow(img2_bfs,'InitialMagnification','fit');

%% Image2 labelling based on two-pass method
[s,I2lab] = twopass(image2_otsu_thresh_result);                           
% colour
img2_rgb = label2rgb(I2lab,'hsv',[0 0 0],'shuffle');
figure;imshow(img2_rgb,'InitialMagnification','fit');title("two-pass");

%% Image2 use seperate 
%segment
c1 = s(1).Image;
c2 = s(2).Image;
c3 = s(3).Image;
c4 = s(4).Image;
c5 = s(5).Image;
c6 = s(6).Image;

%padding
c1_enlarged = enlarge_char_frame(c1);
c2_enlarged = enlarge_char_frame(c2);
c3_enlarged = enlarge_char_frame(c3);
c4_enlarged = enlarge_char_frame(c4);
c5_enlarged = enlarge_char_frame(c5);
c6_enlarged = enlarge_char_frame(c6);

% figure;
% subplot(2,3,1);imshow(c1_enlarged,'InitialMagnification','fit');
% subplot(2,3,2);imshow(c2_enlarged,'InitialMagnification','fit');
% subplot(2,3,3);imshow(c3_enlarged,'InitialMagnification','fit');
% subplot(2,3,4);imshow(c4_enlarged,'InitialMagnification','fit');
% subplot(2,3,5);imshow(c5_enlarged,'InitialMagnification','fit');
% subplot(2,3,6);imshow(c6_enlarged,'InitialMagnification','fit');

%% Segmentation of individual characters
character_region = segment_character_region(image2_otsu_thresh_result);
% figure(10),imshow(character_region),title('Character Region of Image 2');

% First divide the original image into 2 new images based on the horizontal central axis
[height,width] = size(character_region);
half_height = round(height/2);
first_half_character_region = segment_character_region(imcrop(character_region,[1 1 width half_height]));
second_half_character_region = segment_character_region(imcrop(character_region,[1 half_height width half_height]));

% Respectively locate the character string area of the newly generated 2 images 
% and generate a new image to facilitate the subsequent segmentation of
% individual characters.
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

% enlarge character into size of (26,26)
char1 =enlarge_char_frame(char1); char2 =enlarge_char_frame(char2); char3 =enlarge_char_frame(char3);
char4 =enlarge_char_frame(char4); char5 =enlarge_char_frame(char5); char6 =enlarge_char_frame(char6); 

%% Rearrangement of characters 451236
characters_origin = {char4 char5 char1 char2 char3 char6};
[height,width] = size(char1);
new_arrange_image = zeros(height, 6*width);
for i = 1:6
    current_image = characters_origin(i);
    current_image = current_image{1,1};
    new_arrange_image(1:height,1+width*(i-1):width*i)= current_image(1:height,1:width);
    if i==6
    figure;imshow(new_arrange_image),title('image2 rearrange result');
    imwrite(new_arrange_image,'results/rearrange/rearrange.jpg')
    end
end

%% Realization of image rotation 30°„ around the center point
foward_mapping_rotation=forward_mapping_rotation(new_arrange_image, -30);
reverse_mapping_rotation=reverse_mapping_rotation(new_arrange_image, -30);
rotation_result_nearest_neighbour = rotate(new_arrange_image,30,"nearest neighbour");
rotation_result_bilinear = rotate(new_arrange_image,30,"bilinear");
rotation_result_bicubic = rotate(new_arrange_image,30,"bicubic");
figure;imshow(foward_mapping_rotation),title('image2 foward mapping rotation result');
figure;imshow(reverse_mapping_rotation),title('image2 reverse mapping rotation result');
figure;imshow(rotation_result_nearest_neighbour),title('image2 nearest neighbour');
figure;imshow(rotation_result_bilinear),title('image2 rotation result bilinear');
figure;imshow(rotation_result_bicubic),title('image2 result bicubic');

