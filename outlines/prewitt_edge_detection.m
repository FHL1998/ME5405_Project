function [edge_detection_result] = prewitt_edge_detection(input_image)
[height,width]=size(input_image);
edge_detection_result = input_image;
PrewittNum=0;
PrewittThreshold=2.8;%设定阈值
for j=2:height-1 %进行边界提取
    for k=2:width-1
        PrewittNum=abs(input_image(j-1,k+1)-input_image(j+1,k+1)+input_image(j-1,k)-input_image(j+1,k)+input_image(j-1,k-1)-input_image(j+1,k-1))+abs(input_image(j-1,k+1)+input_image(j,k+1)+input_image(j+1,k+1)-input_image(j-1,k-1)-input_image(j,k-1)-input_image(j+1,k-1));
        if(PrewittNum > PrewittThreshold)
            edge_detection_result(j,k)=255;
        else
            edge_detection_result(j,k)=0;
        end
    end
end
