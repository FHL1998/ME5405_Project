clc;
clear all;
close all;

%% Read the txt file of character 1,covert it into matrix format and display
Image1_txt = fopen('chromo.txt','r'); 
Image1 = convert_txt_image(Image1_txt);
% figure,imshow(Image1),title('Original chromosome image ');

%% Image preprocessing
Image1=imread('image1_origin.jpg');
figure,imshow(Image1),title('Original chromosome image');
pre_process_image1 = pre_process(Image1);
pre_process_image1(33,51)=0;
pre_process_image1(34,51)=0;
pre_process_image1(34,52)=0;
pre_process_image1(35,51)=0;
pre_process_image1(35,52)=0;
figure(2),imshow(pre_process_image1),title('enhancement');

%% Thresholding Operation
%% Binarization operation based on threshold selection of iterative operation
Image1=imread('results/image1_enhancement.jpg');
iteration_thresh_result = iteration_thresh(Image1);
% figure(3),imshow(iteration_thresh_result),title('Image1 Iterative threshold selection');

%% Binarization operation based on fuzzy entropy threshold selection
entropy_thresh_result = fuzzy_entropy(Image1);
% figure(4),imshow(entropy_thresh_result),title('Image1 Fuzzy entropy threshold selection');

%% Binarization operation based on OTSU selection
image1_otsu_thresh_result = otsu_thresh(Image1);
% figure(5),imshow(ostu_thresh_result ),title('Image1 OSTU threshold selection');

%% Image1(chromo) Thinning 
image1_one_pixel = one_pixel_image(image1_otsu_thresh_result);
% figure(6),imshow(image2_one_pixel),title('image1 Image refinement result Zhang Suen');
image1_stentiford_thining = Stentiford_Thining(image1_otsu_thresh_result);
% figure(7),imshow(image1_stentiford_thining),title('image1 Image refinement result Stentiford');

%% Image1 edge extraction
img=image1_otsu_thresh_result; % binary image
image1_morphological =morphology_edge(image1_otsu_thresh_result,strel('square',2)); % Extract edges based on morphology
image1_sobel=edge(img,'sobel'); % Edge detection with Sobel operator
image1_roberts=roberts_edge_detection(image1_otsu_thresh_result); %Edge detection with Roberts operator
image1_prewitt=edge(img,'prewitt'); % Edge detection with Prewitt operator
image1_log=edge(img,'log'); % Edge detection with Log operator
[~,~, image1_canny] = canny_edge_detection(image1_otsu_thresh_result); % Canny edge detection

figure;
set(gcf, 'PaperPositionMode', 'auto');
set(gca,'LooseInset',get(gca,'TightInset'))
subplot(2,3,1), imshow(image1_morphological );
title('morphological');
subplot(2,3,2), imshow(image1_sobel);
title('sobel edge ');
subplot(2,3,3), imshow(image1_roberts);
title('roberts edge ');
subplot(2,3,4), imshow(image1_prewitt);
title('prewitt edge ');
subplot(2,3,5), imshow(image1_log);
title('log edge ');
subplot(2,3,6), imshow(image1_canny);
title('canny edge');

%% Image1 labelling
%% Labelling based on DFS-method
count = 1;
I1_dfs = imcomplement(image1_otsu_thresh_result);    %reverse the value of background and object
I1_label = image1_otsu_thresh_result;
[rows, cols] = size(I1_label);

for i = 1 : rows
    for j = 1 : cols
        if(I1_label(i,j) == 0)     
            count = count + 1;            
            I1_label = dfs_recur(I1_label, i , j, count, 8);       
        end
    end
end

for i = 1: rows
    for j = 1: cols
          I1_label(i, j) = I1_label(i, j) - 1;         
    end
end

img_rgb = label2rgb(I1_label,'hsv',[0 0 0],'shuffle');% colour
img_dfs_back = imcomplement(img_rgb);
figure(9);imshow(img_dfs_back,'InitialMagnification','fit');title("DFS");

%% Labelling based on BFS-method
 I1_reverse = imcomplement(image1_otsu_thresh_result);
 [I1_bfs, num] = BFS(I1_reverse, 4);      
%  [I1_bfs, num] = BFS(I1_reverse, 8);  % uncomment this for using 8-connection component      
img_rgb = label2rgb(I1_bfs,'hsv',[0 0 0],'shuffle');%colour
img_back = imcomplement(img_rgb);
figure(10);imshow(img_back,'InitialMagnification','fit');title("BFS");


%% Labelling based on two-pass method
I1_reverse = imcomplement(image1_otsu_thresh_result);
[s,Ilab] = twopass(I1_reverse);                          
img_rgb = label2rgb(Ilab,'hsv',[0 0 0],'shuffle');% colour
img_back = imcomplement(img_rgb);
figure(11);imshow(img_back,'InitialMagnification','fit');title("Two Pass")


