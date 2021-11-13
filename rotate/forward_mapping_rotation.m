function [output] = forward_mapping_rotation(input_image,theta)
%绕图像中心点正向映射的实现
theta=theta*pi/180;
[height,width]=size(input_image); %width对应x,height对应y
R=[cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1];
new_height=round(width*abs(sin(theta))+height*abs(cos(theta)));
new_width=round(width*abs(cos(theta))+height*abs(sin(theta)));

output=zeros(new_height,new_width); %初始化新位图
T1=[1 0 -0.5*width;0 -1 0.5*height;0 0 1];
T3=[1 0 0.5*new_width;0 -1 0.5*new_height;0 0 1];
for i3=1:width%遍历原图像中的x点
    for j3=1: height%遍历原图像中的y点
        new_coordinate=T3*R*T1*[i3;j3;1];
        new_x=round(new_coordinate(1));
        new_y=round(new_coordinate(2));
        if((new_x>=1 && new_x<=new_width)&&(new_y>=1&&new_y<=new_height))
            output(new_y,new_x)=input_image(j3,i3);
        end
    end
end
end

