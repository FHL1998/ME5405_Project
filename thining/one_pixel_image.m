function [img_Thin] = one_pixel_image(img)
int = 1;
[row, col] = size(img);
img_Thin = img;
thin_del = ones(row, col);
while int
    int = 0;
    for i = 2:row-1
        for j = 2:col-1
            p1=img_Thin(i,j);
            p2=img_Thin(i-1,j);p3=img_Thin(i-1,j+1);p4=img_Thin(i,j+1);p5=img_Thin(i+1,j+1);
            p6=img_Thin(i+1,j);p7=img_Thin(i+1,j-1);p8=img_Thin(i,j-1);p9=img_Thin(i-1,j-1);
%             p10=imgThin(i-1,j);
            x = [p1 p2 p3 p4 p5 p6 p7 p8 p9 p2];
%             sum_A = ;
%             x = [imgThin(i,j) imgThin(i-1,j) imgThin(i-1,j+1) imgThin(i,j+1) imgThin(i+1,j+1) ...
%                 imgThin(i+1,j) imgThin(i+1,j-1) imgThin(i,j-1) imgThin(i-1,j-1) imgThin(i-1,j)];
            if (p1 == 1 && sum(x(2:9)) <= 6 && sum(x(2:9)) >= 2 && ...
                                       p2*p4*p6 == 0 && p4*p6*p8 == 0)
                A = 0;
                for k = 2:size(x, 2)-1
                    if x(k) == 0 && x(k+1) == 1
                        A = A+1;
                    end
                end
                if (A == 1)
                    thin_del(i, j)=0;
                    int = 1;
                end
            end
        end
    end
    img_Thin = img_Thin .* thin_del; % the deletion must after all the pixels have been visited
    for i = 2:row-1
        for j = 2:col-1
            p1=img_Thin(i,j);
            p2=img_Thin(i-1,j);p3=img_Thin(i-1,j+1);p4=img_Thin(i,j+1);p5=img_Thin(i+1,j+1);
            p6=img_Thin(i+1,j);p7=img_Thin(i+1,j-1);p8=img_Thin(i,j-1);p9=img_Thin(i-1,j-1);
%             p10=imgThin(i-1,j);
            x = [p1 p2 p3 p4 p5 p6 p7 p8 p9 p2];
%             x = [imgThin(i,j) imgThin(i-1,j) imgThin(i-1,j+1) imgThin(i,j+1) imgThin(i+1,j+1) ...
%                 imgThin(i+1,j) imgThin(i+1,j-1) imgThin(i,j-1) imgThin(i-1,j-1) imgThin(i-1,j)];
            if (img_Thin(i,j) == 1 && sum(x(2:9)) <= 6 && sum(x(2:9)) >= 2 && ...
                                      p2*p4*p8 == 0 && p2*p6*p8 == 0)
                A = 0;
                for k = 2:size(x, 2)-1
                    if x(k) == 0 && x(k+1) == 1
                        A = A+1;
                    end
                end
                if (A == 1)
                    thin_del(i, j) = 0;
                    int = 1;
                end
            end
        end
    end
    img_Thin = img_Thin .* thin_del;
end
end


