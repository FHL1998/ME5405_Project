function [s,outImg,t] = twopass( inputImg )
%Connectivity_Label Self-made connected area analysis function
%   [ outImg, labels ] = MyBwLabel( inputImg )
%   inputIg: The input image requires a two-valued image with a maximum value of 255.
%   outputImg: The output image, different connectivity areas;
%   labels：The number of connected areas.
%

%% in project 
    t1 = clock;
    labels = 1;
    outImg = double( inputImg );
    [height , width] = size( inputImg );

    %% first pass
    for i = 1:height
        for j = 1:width
            if inputImg(i,j) > 0  % If it is the foreground point, it is statistically processed.
                neighbors = [];  % Record the fore fore fore fore forequent points in the required neighborhood, followed by rows, columns, and values.
                if (i-1 > 0)
%                     8-connectivity extra part
%                     if (j-1 > 0 && inputImg(i-1,j-1) > 0)
%                         neighbors = [neighbors ; i-1 , j-1 , outImg(i-1,j-1)];
%                     end
                    
                    if inputImg(i-1,j) > 0
                        neighbors = [neighbors ; i-1 , j , outImg(i-1,j)];
                    end
                    
                elseif (j-1) > 0 && inputImg(i,j-1) > 0
                    neighbors = [neighbors ; i , j-1 , outImg(i,j-1)];
                end

                if isempty(neighbors)
                    labels = labels + 1;
                    outImg(i,j) = labels;
                else
                    outImg(i,j) = min(neighbors(:,3));    % The third column of neighbors is the previously stored label value of the upper or left (or upper left) point, where the smaller value of the upper and left (and upper left) label is output
                end
            end
        end
    end

    %% second pass
    % Find all the non-zero elements in the matrix, 
    %and return the linear indices of these elements (linear indices: by column) into the vector. 
    %r is the abscissa of a point, c is the ordinate (ri, ci)
    [r , c] = find( outImg ~= 0 );    
    for i = 1:length( r )
        if r(i)-1 > 0
            up = r(i)-1;
        else
            up = r(i);
        end
        if r(i)+1 <= height
            down = r(i)+1;
        else
            down = r(i);
        end
        if c(i)-1 > 0
            left = c(i)-1;
        else
            left = c(i);
        end
        if c(i)+1 <= width
            right = c(i)+1;
        else
            right = c(i);
        end

        connect = outImg(up:down , left:right);       % Find the 8-neighborhood of this point (ri, ci)
        
        [r1 , c1] = find( connect ~= 0 );        % Find coordinates that are not equal to 0 in the neighborhood
        if ~isempty(r1)
            connect = connect(:);                 % Convert 3*3 matrix to 9*1 column vector
            connect( connect == 0 ) = [];          %Remove non-zero

            minV = min(connect);            % Find the smallest label value
            connect( connect == minV ) = [];    % Remove the tmpM == minV
            for kk = 1:1:length(connect)
                outImg( outImg == connect(kk) ) = minV;    % Change the original value of tmpM(kk) in outimg to minV
            end
        end
    end

    u = unique(outImg);        % List all the different label values of outImg
    for i = 2:1:length(u)
        outImg(outImg == u(i)) = i-1;  % Reset the label value to 1.2.3.4......
    end
    
    label_num=unique(outImg(outImg>0));
    num=numel(label_num);
    
    t2 = clock;
    t = etime(t2,t1);
 %% segement (bounding box)
%  s(num) = struct('Image',[],'address',[],'Centroid',[],'BoundingBox',[]);
 s(num) = struct('Image',[],'address',[]);
 % address: address of all the pixels in the same connected area
 % centroid: each connected area's center address
 % according to the all address and center address => calculate the
 % bounding box
  for i=1:num
     [r,c] = find(outImg==label_num(i));
%      s(i).address = [r,c];

     r_ = r-min(r)+1;
     c_ = c-min(c)+1;
     s(i).Image = zeros(max(r_),max(c_));
%      s(i).boundingbox=[min(c)-0.5,min(r)-0.5,max(c_),max(r_)];
     for q=1:size(r_)
             s(i).Image(r_(q),c_(q))=1;
             s(i).Image=logical(s(i).Image);
     end  
%      s(i).Centroid=[mean(c),mean(r)];
     
 end
 
end