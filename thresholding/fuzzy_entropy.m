function [entropy_thresh_result]=fuzzy_entropy(input_image)
hist = imhist(input_image);
bottom=min(input_image(:))+1;  %图像的最小灰度值
top=max(input_image(:))+1; %图像的最大灰度值
C=double(top-bottom); % 常数C取图像的最大灰度值-最小灰度值，从而保证模糊属性隶属度的取值范围
S=zeros(256,1);
J=10^10;
for t=bottom+1:top-1
    miu_o=0;
    for j=bottom:t
        miu_o=miu_o+hist(j)*double(j);
    end
    pixel_num=sum((bottom:t));
    miu_o=miu_o/pixel_num;
    for j=bottom:t
        miu_f=1/(1+abs(double(j)-miu_o)/C);
        S(j)=-miu_f*log(miu_f)-(1-miu_f)*log(1-miu_f);
    end        
    miu_b=0;
    for j=t+1:top
        miu_b=miu_b+hist(j)*double(j);
    end
    pixel_num=sum(hist(t+1:top));
    miu_b=miu_b/pixel_num;
    for j=t+1:top
        miu_f=1/(1+abs(double(j)-miu_b)/C);
        S(j)=-miu_f*log(miu_f)-(1-miu_f)*log(1-miu_f);
    end
    current_J = sum(hist(bottom:top).*S(bottom:top));
    if current_J<J
        J=current_J;        
        thresh=t;
    end           
end
entropy_thresh_result = zeros(size(input_image));
entropy_thresh_result(input_image>thresh)=1;
end

