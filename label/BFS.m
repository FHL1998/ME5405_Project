function [connection_result,num] = BFS( input_image ,type)
% 对二值图区域标记
% 输入：I是二值图矩阵
% 输出：tmp是标记矩阵，num是连通区域个数

[m, n] = size(input_image);
connection_result = zeros(m,n);     %标记矩阵
label = 1;
queue = [];  %用二维数组模拟队列
%和当前像素坐标相加得到八个邻域坐标(坐标无序)
neighbour_4 = [-1 0; 1 0; 0 -1; 0 1];
neighbour_8 = [-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];

if type == 4
    for i = 2 : m-1 
        for j = 2 : n-1
            if input_image(i,j) == 1 && connection_result(i,j) == 0 %属于目标区域且未标记才处理          
                connection_result(i,j) = label;
                queue = [i;j];  %记录当前点坐标
                while ~isempty(queue) %队列不空，这里没有出队操作，队列中的每一个元素的4领域都判断一遍
                    index = [queue(1,1),queue(2,1)];  %分别取队列第一行第一列，第二行第一列              
                    for k = 1 : 4               %4邻域搜索
                        current_index = index + neighbour_4(k,:);  %加上每一行的坐标得到周围4邻域的坐标点， (k,:)表示矩阵第k 行的所有元素
                        if current_index(1) >= 2 && current_index(1) <= m - 1 && current_index(2) >= 2 && current_index(2) <= n - 1 %防止坐标越界
                            if input_image(current_index(1),current_index(2)) == 1 && connection_result(current_index(1),current_index(2)) ==0  %如果当前像素邻域像素为1并且标记图像的这个邻域像素没有被标记，那么标记
                                connection_result(current_index(1),current_index(2)) = label;
                                queue = [queue, [current_index(1);current_index(2)]]; %矩阵合并
                            end  
                        end              
                    end
                   queue(:,1) = []; %队列中第一列的坐标出队
                end    
                label = label+1;            
            end
        end
    end
elseif type == 8
        for i = 2 : m-1 
            for j = 2 : n-1
                if input_image(i,j) == 1 && connection_result(i,j) == 0 %属于目标区域且未标记才处理          
                    connection_result(i,j) = label;
                    queue = [i;j];  %记录当前点坐标
                    while ~isempty(queue) %队列不空，这里没有出队操作，队列中的每一个元素的8领域都判断一遍
                        index = [queue(1,1),queue(2,1)];                
                        for k = 1 : 8               %8邻域搜索
                            current_index = index + neighbour_8(k,:);  %加上每一行的坐标得到周围8邻域的坐标点
                            if current_index(1) >= 2 && current_index(1) <= m - 1 && current_index(2) >= 2 && current_index(2) <= n - 1 %防止坐标越界
                                if input_image(current_index(1),current_index(2)) == 1 && connection_result(current_index(1),current_index(2)) ==0  %如果当前像素邻域像素为1并且标记图像的这个邻域像素没有被标记，那么标记
                                    connection_result(current_index(1),current_index(2)) = label;
                                    queue = [queue, [current_index(1);current_index(2)]]; % 横向拼接不换行
                                end  
                            end              
                        end
                       queue(:,1) = []; %队列中第一列的坐标出队，先进先出
                    end    
                    label = label+1;            
                end
            end
        end

end
    num = label - 1; %连通区域的个数（减去背景这个连通区域）
end
