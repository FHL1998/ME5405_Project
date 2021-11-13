function S=cubic_factor(x)

if 0<=abs(x)&& abs(x)<1
    S=1-2.*abs(x).^2+abs(x).^3;
elseif 1<=abs(x) && abs(x)<2
    S=4-8.*abs(x)+5.*abs(x).^2-abs(x).^3;
else
    S=0;
end

