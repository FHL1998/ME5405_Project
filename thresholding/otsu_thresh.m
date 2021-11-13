function [ostu_thresh_result] = ostu_thresh(input_image)                                  
[height,width]=size(input_image);                           % 图像大小
L =256;
N = height*width;  %number of total gray numbers(pixels number)
for t = 1 : L 
    n_object = 0;
    n_background = 0;
    u_o = 0.0;
    u_b = 0.0;
    input_image = double(input_image) ;                      % 强制转化,否则平均灰度值将无法计算
    for i = 1:height   
        for j = 1:width   
            if input_image(i,j) <= t   
                n_object = n_object + 1;         % 小于阈值的像素点数目
                u_o = u_o + input_image(i,j);    % 目标总灰度
            else   
                n_background = n_background + 1;         % 大于阈值的像素点数目
                u_b = u_b + input_image(i,j);    % 背景总灰度
            end   
        end   
    end
    p_o = n_object / N;                    % 计算两类像素在图像中的分布概率
    p_b = n_background / N;
    u_o = u_o / n_object;
    u_b = u_b / n_background;
    u = p_o * u_o + p_b * u_b; %总体灰度的均值为
    g(t) = p_o * (u_o - u)^2 + p_b * (u_b - u)^2; %总类间方差为
    [~, threshold]= max(g);
end

ostu_thresh_result = zeros(size(input_image));
ostu_thresh_result(input_image>threshold)=1;
ostu_thresh_result(input_image<threshold)=0;
end


