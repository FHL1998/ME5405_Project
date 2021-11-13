function [morphological_gradient ] = morphology_edge(input_image,SE)
%inner_edge = input_image -imerode(input_image,SE) - input_image;
%outter_edge = imdilate(input_image,SE) - input_image;
morphological_gradient = imdilate(input_image,SE) - imerode(input_image,SE);
end
