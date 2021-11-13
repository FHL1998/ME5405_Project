function[output_character_region] = enlarge_char_frame(input_image)
%为单独字符添加黑色边缘像素
aim_height = 26;
aim_width = 26;
[height,width]= size(input_image); 
delta_height = aim_height-height;
delta_width = aim_width-width;
output_character_region = zeros(aim_height,aim_width); 
output_character_region(1+round(delta_height/2):height+round(delta_height/2),1+round(delta_width/2):width+round(delta_width/2)) = input_image(1:height,1:width);
end

