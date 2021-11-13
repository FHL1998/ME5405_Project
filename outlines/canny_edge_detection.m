function [height, width,output] = canny_edge_detection(input_image)
threshold_low = 0.075;
threshold_high = 0.175;
gassian_blur = fspecial('gaussian', [3 3], 1.5);% Convolution of image by Gaussian Coefficient,其中标准差的取值为1.5
input_image = conv2(input_image, gassian_blur, 'same');

%Filter for horizontal and vertical direction
% prewitt_x = [1, 1, 1; 0, 0, 0; -1, -1, -1];
% prewitt_y = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
%Sobel算子计算梯度。
%相对于其他边缘算子，Sobel算子得出来的边缘粗大明亮
sobel_x = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sobel_y = [1, 2, 1; 0, 0, 0; -1, -2, -1];

%Convolution by image by horizontal and vertical filter
Gradient_x = conv2(input_image, sobel_x, 'same');
Gradient_y = conv2(input_image, sobel_y, 'same');

theta =atan2 (Gradient_y, Gradient_x);%Calculate directions/orientations
theta = theta*180/pi; %convert fron radian to degree
[height,width] = size(input_image);

%Adjustment for negative directions, making all directions positive
for i=1:height
    for j=1:width
        if (theta(i,j)<0) 
            theta(i,j)=360+theta(i,j);
        end
    end
end

theta_mat=zeros(height, width);
%梯度角度θ范围从弧度-π到π，然后把它近似到四个方向，分别代表水平，垂直和两个对角线方向（0°,45°,90°,135°）
%Adjusting directions to nearest 0, 45, 90, or 135 degree
for i = 1  : height
    for j = 1 : width
        if ((theta(i, j) >= 0 ) && (theta(i, j) < 22.5) || (theta(i, j) >= 157.5) && (theta(i, j) < 202.5) || (theta(i, j) >= 337.5) && (theta(i, j) <= 360))
            theta_mat(i, j) = 0;
        elseif ((theta(i, j) >= 22.5) && (theta(i, j) < 67.5) || (theta(i, j) >= 202.5) && (theta(i, j) < 247.5))
            theta_mat(i, j) = 45;
        elseif ((theta(i, j) >= 67.5 && theta(i, j) < 112.5) || (theta(i, j) >= 247.5 && theta(i, j) < 292.5))
            theta_mat(i, j) = 90;
        elseif ((theta(i, j) >= 112.5 && theta(i, j) < 157.5) || (theta(i, j) >= 292.5 && theta(i, j) < 337.5))
            theta_mat(i, j) = 135;
        end
    end
end

%Calculate magnitude
G_magnitude = sqrt((Gradient_x.^2) + (Gradient_y.^2));
G_magnitude =   mat2gray(G_magnitude);
binary_image = zeros (height, width);

%Non-Maximum Supression
% 比较当前点的梯度强度和正负梯度方向点的梯度强度。
% 如果当前点的梯度强度和同方向的其他点的梯度强度相比较是最大，保留其值。否则抑制，即设为0。
for i=2:height-1
    for j=2:width-1
        if (theta_mat(i,j)==0)
            binary_image(i,j) = (G_magnitude(i,j) == max([G_magnitude(i,j), G_magnitude(i,j+1), G_magnitude(i,j-1)]));
        elseif (theta_mat(i,j)==45)
            binary_image(i,j) = (G_magnitude(i,j) == max([G_magnitude(i,j), G_magnitude(i+1,j-1), G_magnitude(i-1,j+1)]));
        elseif (theta_mat(i,j)==90)
            binary_image(i,j) = (G_magnitude(i,j) == max([G_magnitude(i,j), G_magnitude(i+1,j), G_magnitude(i-1,j)]));
        elseif (theta_mat(i,j)==135)
            binary_image(i,j) = (G_magnitude(i,j) == max([G_magnitude(i,j), G_magnitude(i+1,j+1), G_magnitude(i-1,j-1)]));
        end
    end
end
binary_image = binary_image.*G_magnitude;

%Hysteresis Thresholding滞后边界跟踪
threshold_low = threshold_low * max(max(binary_image));
threshold_high = threshold_high * max(max(binary_image));
hysteresis_thresholding_result = zeros (height, width);

for i = 1  : height
    for j = 1 : width
        if (binary_image(i, j) < threshold_low)
            hysteresis_thresholding_result(i, j) = 0;
        elseif (binary_image(i, j) > threshold_high)
            hysteresis_thresholding_result(i, j) = 1;
            %Using 8-connected components
        elseif ( binary_image(i+1,j)>threshold_high || binary_image(i-1,j)>threshold_high || binary_image(i,j+1)>threshold_high || binary_image(i,j-1)>threshold_high || binary_image(i-1, j-1)>threshold_high || binary_image(i-1, j+1)>threshold_high || binary_image(i+1, j+1)>threshold_high || binary_image(i+1, j-1)>threshold_high)
            hysteresis_thresholding_result(i,j) = 1;
        end
    end
end
input = input_image;
output =  hysteresis_thresholding_result;
end

