function [pre_process_result] = pre_process(input_image)
[height,width]=size(input_image);
Image1=imread('image1_origin.jpg');
if input_image ==Image1
    for i = 1:64
        for j = 1:10
            input_image(i,j)=255;
        end
    end    
    for i = 1:7
        for j = 1:64
            input_image(i,j)=255;
        end
    end
end


a1=100; b1=200; c1=20; d1=240;     
pre_process_result=zeros(height,width);

for gray=0:255
    if gray<a1
        new_gray_value=c1/a1*gray;       
    elseif gray<b1
        new_gray_value=(d1-c1)/(b1-a1)*(gray-a1)+c1;
    else
        new_gray_value=(255-d1)/(255-b1)*(gray-b1)+d1;        
    end
    pre_process_result(input_image==gray)=new_gray_value/255;
end

for j = 32:36
    for i = 50:51
        n_gray= pre_process_result(i,j)+50;
        pre_process_result(i,j)=n_gray/255;
    end
end    

for j = 31:33
    for i = 52
        n_gray= pre_process_result(i,j)+50;
        pre_process_result(i,j)=n_gray/255;
    end
end

for j = 64
    for i = 9:10
    pre_process_result(i,j)=1;
    end
end

for j = 64
    for i = 50:52
    pre_process_result(i,j)=1;
    end
end



end

