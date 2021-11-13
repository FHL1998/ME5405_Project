function [Image1] = image1_anti_noise(input_image)
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
Image1=input_image;
end


