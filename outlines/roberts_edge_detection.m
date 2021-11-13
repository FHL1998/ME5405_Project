function [edge_detection_result] = roberts_edge_detection(input_image)
[height,width]=size(input_image);
edge_detection_result = input_image;
robertsNum=0;
robertThreshold=0.2;
for j=1:height-1
    for k=1:width-1
        robertsNum = abs(input_image(j,k)-input_image(j+1,k+1)) + abs(input_image(j+1,k)-input_image(j,k+1));
        if(robertsNum > robertThreshold)
            edge_detection_result(j,k)=255;
        else
            edge_detection_result(j,k)=0;
        end
    end

end
end

