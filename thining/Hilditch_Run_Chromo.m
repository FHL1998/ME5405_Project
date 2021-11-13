clear all;
clc;

%Display the image

%read the original text file to a 64*64 matrix
fileID = fopen('chromo.txt');
im1_ori = fscanf(fileID,'%s');
im1_ori = reshape(im1_ori, [64,64]);
im1_ori = im1_ori';
fclose(fileID);

%convert each element from 32 base to dec
for j = 1:64
    for i = 1:64
        im1_ori(i,j) = base2dec(im1_ori(i,j),32);
    end
end

%convert char matrix to num matrix
im1_ori = 256/32*double(im1_ori);
im1_bin = imbinarize(im1_ori/256);
%convert logical im1_bin to double
%im2_bin = double(im1_bin);
img=pre_process(im1_ori)
img_bin=imbinarize(img);
imshow(img_bin);
%Use the first part to open txt image file then img=imgpre_process(im1_ori) then img_bin=imbinarize(img)
%% read the pre-processed binary image (since it is black obj and white background we need to reverse it)

PIC = ~im1_bin;

%% Enlarge the PIC one pixel 
[imageRow, imageCol] = size(PIC);
midPIC = zeros([imageRow+4, imageCol+4]);
midPIC(3:end-2, 3:end-2) = PIC;
PIC = midPIC;

PIC2 = PIC;                   % pic2 copy

%% Hilditch
C = 1;    % variable

while C
    C = 0;  
    [row, col] = find(PIC == 1);    % save all the value 1 pixel positions
    PIC_DEL = ones(size(PIC));
    count = 0; % the number of pixels that we need to cancel
    
    for i = 1:length(row)
        
        % find pixel = 1
        X = row(i);
        Y = col(i);
        
        % 3*3 matrix
        % X4 X3 X2
        % X5 P  X1
        % X6 X7 X8
        P = [PIC(X, Y+1), PIC(X-1, Y+1), PIC(X-1, Y), ...
             PIC(X-1, Y-1), PIC(X, Y-1), PIC(X+1, Y-1), ...
             PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
        
        % condition2：
        C2 = P(1) + P(3) + P(5) + (7);
        if C2 == 4
            continue;
        end
        
        % condition3：
        if sum(P(1:8)) < 2
            continue;
        end
        
        % condition4：
        w = 0;
        for m = X-1:X+1
            for n = Y-1:Y+1
                if m == X && n == Y
                    continue;
                end
                if PIC(m, n) == 1 && PIC_DEL(m, n) == 1
                    w = w + 1;
                end
            end
        end
        if w < 1
            continue;
        end
        
        % condition5：
        
        if c_number(P) ~= 1
            continue;
        end
        
        % condition6：
        if PIC_DEL(X-1, Y) == 0
            P3 = [PIC(X, Y+1), PIC(X-1, Y+1), 0, ...
                  PIC(X-1, Y-1), PIC(X, Y-1), PIC(X+1, Y-1), ...
                  PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
             if c_number(P3) ~= 1
                 continue;
             end
        end
        
        % condition6：X5
        if PIC_DEL(X, Y-1) == 0
            P5 = [PIC(X, Y+1), PIC(X-1, Y+1), PIC(X-1, Y), ...
                  PIC(X-1, Y-1), 0, PIC(X+1, Y-1), ...
                  PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
             if c_number(P5) ~= 1
                 continue;
             end
        end
        
        PIC_DEL(X, Y) = 0;
        count = count + 1;
    end
    if count ~= 0
        PIC = PIC .* PIC_DEL;   
        C = 1;
    end
end

Out0 = bwmorph(PIC2, 'thin', inf);
%figure('name', 'bwmorph'); imshow(Out0);

%% comparing thr result
close all;
figure('name', 'Original image'); imshow(PIC2);
figure('name', 'Hilditch'); imshow(PIC);
clc


function result=c_number(P)
N = 0;
for k = 1:4
    temp = ~P(2*k-1) - ~P(2*k-1)*~P(2*k)*~P(2*k+1);
    N = N + temp;
end
result = N;
end

    