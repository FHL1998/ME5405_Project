function output_character_region=segment_character_region(input_image)
% 切割字符区域
[height,width]=size(input_image); %get the size of the image
top=1; %
bottom=height;
left=1;
right=width;
while sum(input_image(top,:))==0 && top<=height %元胞数组:访问input_image的第1行(从第一行开始遍历),若全为黑色(0),继续遍历
    top=top+1;
end
while sum(input_image(bottom,:))==0 && bottom>1
    bottom=bottom-1;
end
while sum(input_image(:,left))==0 && left<width
    left=left+1;
end
while sum(input_image(:,right))==0 && right>=1
    right=right-1;
end
new_width=right-left;
new_height=bottom-top;
output_character_region=imcrop(input_image,[left top new_width new_height]);% imcrop(I,rect) [xmin ymin width height]
end

