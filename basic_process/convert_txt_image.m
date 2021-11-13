function [txt_image] = convert_txt_image(txt_file)
txt_cell = textscan(txt_file,'%s',64);                                      % read formatted data from text file 
txt_matrix = uint8(cell2mat(txt_cell{1,1}));                          % transfer cell to matrix and decode it into unsigned integer  
% uint8('0')=48,uint8('9')=57,uint8('A')=65,uint8('0')=66,uint8('V')=86,uint8(10)=10
% convert 0~255 to 0~32
for x = 1:64 % traverse along length
    for y = 1:64
        if(txt_matrix(x,y) >= uint8('0') && txt_matrix(x,y) <= uint8('9'))
            txt_matrix(x,y) = txt_matrix(x,y) - uint8('0');
        elseif(txt_matrix(x,y) >= uint8('A') && txt_matrix(x,y)<=uint8('V')) 
            txt_matrix(x,y)=txt_matrix(x,y) - uint8('A') + (uint8('9') - uint8('0')+1); 
        else
            disp('Traverse 	Error:Out of Range')         %report error when out of range
        end
    end
end
txt_image = mat2gray(txt_matrix);
end

