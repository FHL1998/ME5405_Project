function [output] = reverse_mapping_rotation(input_image,theta)
%绕图像中心点逆向映射的实现
theta=theta*pi/180;
[height,width]=size(input_image);
%R=[cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1];
R=[cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1];
new_width=round(width*abs(cos(theta))+height*abs(sin(theta)));
new_height=round(width*abs(sin(theta))+height*abs(cos(theta)));

output=zeros(new_height,new_width); %初始化新位图
T1=[1 0 -0.5*width;0 -1 0.5*height;0 0 1];
T3=[1 0 0.5*new_width;0 -1 0.5*new_height;0 0 1];
for  i4=1: new_width%遍历x
    for j4=1:new_height%遍历新图中的y
        old_coordinate=inv(T1)*inv(R)*inv(T3)*[i4;j4;1];
        old_x=round(old_coordinate(1));
        old_y=round(old_coordinate(2));
        if((old_x>=1&&old_x<=width)&&(old_y>=1&&old_y<=height))
            output(j4,i4)=input_image(old_y,old_x);
        end
    end
end
end

