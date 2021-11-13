%% Create a map and show the weights of the output neurons

figure
% Set the indice to plot the figures column by column 
idx = reshape(1:nb_neurons,10,[])';
idx=idx(:);
for i = 1:nb_neurons
    h = subplot(10,10,idx(i));
    
    % Increase the size of each picture displayed
    p = get(h, 'pos');
    p(3) = p(3) + 0.015;
    set(h, 'pos', p);
    
    % Reshape the weight of the neuron into a 26x26 matrix
    picture = reshape(train_weights(:,i),26,26);
    imshow(double(picture)/255);
end
