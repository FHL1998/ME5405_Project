function [edge_detection_result] = laplacian_edge_detection(input_image)
[height,width]=size(input_image);
edge_detection_result = input_image;
LaplacianNum=0;%经Laplacian操作得到的每个像素的值
LaplacianThreshold=1;%设定阈值
for j=2:height-1 %进行边界提取
    for k=2:width-1
        LaplacianNum=abs(4*input_image(j,k)-input_image(j-1,k)-input_image(j+1,k)-input_image(j,k+1)-input_image(j,k-1));
        if(LaplacianNum > LaplacianThreshold)
            edge_detection_result(j,k)=255;
        else
            edge_detection_result(j,k)=0;
        end
    end
end
end
