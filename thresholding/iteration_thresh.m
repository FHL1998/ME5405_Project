function [iteration_thresh_result] = iteration_thresh(input_image)
thresh=(max(input_image(:))+min(input_image(:)))/2;
iteration_flag=false;
while ~iteration_flag
    new_thresh=(mean(input_image(input_image>=thresh))+mean(input_image(input_image<thresh)))/2;
    iteration_flag=abs(new_thresh-thresh)<1;
    thresh=new_thresh;
end
iteration_thresh_result= zeros(size(input_image));
iteration_thresh_result(input_image>thresh)=1;
end
