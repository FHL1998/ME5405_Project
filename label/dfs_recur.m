function [input_image] = dfs_recur(input_image, i, j,count, mode)

[rows, cols] = size(input_image);

%     if(i <= 0 || j <= 0 || i > rows || j > cols || input_image(i,j) ~= 1 )       %If the point is outside the boundary or the value of the point is not the value of the target point, return directly
%         return;
%     end

% if(i > 0 && j > 0 && i <= rows && j <= cols && input_image(i,j) == 1 )    %% test 用
if(i > 0 && j > 0 && i <= rows && j <= cols && input_image(i,j) == 0 )    %% project 用     0为object
    input_image(i,j) = count;                %Assign the point to count
    
    %Recurse to the top, bottom, left, and right points of the point
    if(mode == 4)
        input_image = dfs_recur(input_image, i + 1, j , count, mode);       %% 下
        input_image = dfs_recur(input_image, i , j + 1 , count, mode);        %% 右
        input_image = dfs_recur(input_image, i - 1, j , count, mode);       %% 上
        input_image = dfs_recur(input_image, i, j - 1 , count, mode);         %% 左
    
    elseif(mode == 8)
        input_image = dfs_recur(input_image, i + 1, j , count, mode);       %% 下
        input_image = dfs_recur(input_image, i , j + 1 , count, mode);        %% 右
        input_image = dfs_recur(input_image, i - 1, j , count, mode);       %% 上
        input_image = dfs_recur(input_image, i, j - 1 , count, mode);         %% 左
        input_image = dfs_recur(input_image, i-1, j-1, count, mode);
        input_image = dfs_recur(input_image, i+1, j-1, count, mode);
        input_image = dfs_recur(input_image, i-1, j+1, count, mode);
        input_image = dfs_recur(input_image, i+1, j+1, count, mode);
    end
    
end

end

