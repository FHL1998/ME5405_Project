function[character,char_result]=seperate_character(input_image)
% 功能：获取字符
character=[]; %定义一个空数组用以储存分割结果
segmentation_flag=0; %定义一个分割结束标志位
y1=5;
y2=0.5;
while segmentation_flag==0 %分割未结束进入while循环
    [height,width]=size(input_image); %height 对应行数，width对应列数
    i=0; %遍历开始
    while sum(input_image(:,i+1))~=0 && i<=width-2 %遍历,当遇到全为黑色像素的列时，跳出循环
        i=i+1;
    end
    temp=segment_character_region(imcrop(input_image,[1 1 i height]));%用于返回图像的一个裁剪区域 % imcrop(I,rect) [xmin ymin width height]
    [m1,n1]=size(temp);
    if i<y1 && n1/m1>y2
        input_image(:,1:i)=0; %将输入图像的y坐标置0
        if sum(sum(input_image))~=0
            input_image=segment_character_region(input_image); %用自定义函数切割出最小范围
        else
            character=[];
            segmentation_flag=1;%分割结束
        end
    else
        character=segment_character_region(imcrop(input_image,[1 1 i height]));
        input_image(:,1:i)=0;
        if sum(sum(input_image))~=0
            input_image=segment_character_region(input_image);
            segmentation_flag=1;
        else
            input_image=[];
        end
    end
end
char_result=input_image;
end