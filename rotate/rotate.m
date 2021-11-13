function [output] = rotate(img,theta,method)  
theta=theta*pi/180;
[height,width]=size(img);
new_width=round(width*abs(cos(theta))+height*abs(sin(theta)));
new_height=round(width*abs(sin(theta))+height*abs(cos(theta)));
u0=width*sin(theta);   %平移量  
T=[cos(theta),sin(theta);-sin(theta),cos(theta)];   %变换矩阵
output=zeros(new_height,new_width);

for j=1:new_height
    for i=1:new_width     
            coordinate=T*([j;i]-[u0;0]); 
            x=coordinate(1);
            y=coordinate(2); 
            
            if (x>=1 && x<=height)&&(y>=1&&y<=width)    %若变换出的x和y在原图像范围内 
                x_low=floor(x);
                x_up=ceil(x); 
                y_low=floor(y);
                y_up=ceil(y);
                
                if method == "nearest neighbour"
                    if (x-x_low)<=(x_up-x)     %采用最近点法，选取距离最近点的像素赋给新图像     
                        x=x_low; 
                    else
                        x=x_up;     
                    end
                    if (y-y_low)<=(y_up-y)            
                        y=y_low;         
                    else
                        y=y_up;            
                    end
%                     if((x>=1 && x<=new_width)&&(y>=1&&y<=new_height))
                    output(j,i)=img(x,y); 
%                     end
                
                elseif method == "bilinear"
                    p1=img(x_low,y_low);         %双线性插值，p1到p4是（x,y）周围的四个点    
                    p2=img(x_up,y_low);              
                    p3=img(x_low,y_low);            
                    p4=img(x_up,y_up);              
                    s=x-x_low;             
                    t=y-y_low;           
                    output(j,i)=(1-s)*(1-t)*p1+(1-s)*t*p3+(1-t)*s*p2+s*t*p4;         
            
                elseif method == "bicubic"
                    if x>=2 && x<=height-2 && y>=2 && y<=width-2    %若变换出的x和y在原图像范围内      
                        x_1=floor(x)-1; x_2=floor(x);x_3=floor(x)+1;  x_4=floor(x)+2;            
                        y_1=floor(y)-1; y_2=floor(y); y_3=floor(y)+1; y_4=floor(y)+2;          
                        A=[cubic_factor(1+x-x_2),cubic_factor(x-x_2),cubic_factor(1-(x-x_2)),cubic_factor(2-(x-x_2))];        
                        C=[cubic_factor(1+y-y_2),cubic_factor(y-y_2),cubic_factor(1-(y-y_2)),cubic_factor(2-(y-y_2))];          
                        B=[ img(x_1,y_1),img(x_1,y_2),img(x_1,y_3),img(x_1,y_4);      
                        img(x_2,y_1),img(x_2,y_2),img(x_2,y_3),img(x_2,y_4);      
                        img(x_3,y_1),img(x_3,y_2),img(x_3,y_3),img(x_3,y_4);      
                        img(x_4,y_1),img(x_4,y_2),img(x_4,y_3),img(x_4,y_4)];
                        output(j,i)=A*B*C';    
                    end
                end
            end
    end
end
end