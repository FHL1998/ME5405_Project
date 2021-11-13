
function [outBinary] = Stentiford_Thining(input_image)

% Template Type
T1 = [0,1,1]';
T2 = T1';
T3 = [ 1,1,0]';
T4 = T3';

[row,col] = size(input_image);

ouImg = input_image;
S = [1 3 5 7];
checKVal = 2;
template = 1;
outBinary  =zeros(row, col);
con = 5;

while (con < 15)
    for i = 2:row-1
        for j = 2:col-1
            window = input_image(i-1:i+1,j-1:j+1);
            if (template == 1)
                andOp1 = isequal(window(:,2),T1);
                matchTemplate = andOp1;
            end
            if (template == 2)
                andOp1 = isequal(window(2,:),T2);
                matchTemplate = andOp1;
            end
            if (template == 3)
                andOp1 = isequal(window(:,2),T3);
                matchTemplate = andOp1;
            end
            if (template == 4)
                andOp1 = isequal(window(2,:),T4);
                matchTemplate = andOp1;
            end
            % Connectivity number
            [Cn, EndPoint] = connectivityFun(window);

            if input_image(i,j)==1
                if ((matchTemplate) == 1)
                    if Cn == 1
                        if (EndPoint ~= 0)
                            outBinary(i,j) = 1;
                        end
                    end
                end
            end
        end
    end
    checKVal = sum(sum(outBinary));
    if (checKVal==0)
        con = con+1;
    end

    binVal = outBinary==1;
    input_image(binVal) = 0;
    outBinary  =zeros(row, col);
    template = template+1;

    %     Iteration
    if template == 5
%         figure(1), imshow(input_image,[]);title('Output Thinning Image');
%         imwrite(input_image,'results/thining/image2_stentiford.jpg');
        outBinary  =zeros(row, col);
        template = 1;
    end
end
thinning_rate=ThinningRate(input_image)
end

function [Cn, endPoint] = connectivityFun(inwindow)
i=2;j=2;
N0 = inwindow(i,j);
N1 = inwindow(i,j+1);
N2 = inwindow(i-1,j+1);
N3 = inwindow(i-1,j);
N4 = inwindow(i-1,j-1);
N5 = inwindow(i,j-1);
N6 = inwindow(i+1,j-1);
N7 = inwindow(i+1,j);
N8 = inwindow(i+1,j+1);

% arr = [(N1-(N3*N1*N2)) (N3-(N5*N3*N4)) (N5-(N7*N5*N6)) (N7-(N1*N7*N8))];
val = [N1 N2 N3 N4 N5 N6 N7 N8];
arr = [N1<N2 N2<N3 N3<N4 N4<N5 N5<N6 N6<N7 N7<N8 N8<N1];
Cn = sum(arr);
endPoint = abs(N0 - sum(val));
end


function thinning_rate = ThinningRate(skeleton)
tm1 = 0;
tm2 = 0;
[m,n] = size(skeleton);
for i = 2:n
    for j =2:m
        if j>0
            tc = skeleton(i-1,j-1)*skeleton(i,j-1) + skeleton(i-1,j)*skeleton(i-1,j-1);
        elseif j<m-1
            tc = skeleton(i-1,j)*skeleton(i-1,j+1) + skeleton(i-1,j-1)*skeleton(i,j+1)+1;
        else
            tc = skeleton(i-1,j)*skeleton(i,j+1) + skeleton(i-1,j+1)*skeleton(i,j+1);
        end
    end
    tm1 = tc+1;
    tm2 = 4 * ((max(m, n)-1)*2);
end
thinning_rate =1-tm1/tm2
end
