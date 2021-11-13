%% Use the generated SOM to classify the test images 

% Number of test samples
num_test_samples = length(Test_data(1,:));

test_SOM_label = zeros(num_test_samples,1);
for i = 1:num_test_samples   
     current_test_sample = Test_data(:,i);
    [winner_output_neuron, winner_output_idx, winner_output_distance] = find_winner(train_weights, current_test_sample);    
    % Label the test sample with the one corresponding to the winner neuron
    test_SOM_label(i) = train_SOM_labels(winner_output_idx);   
end

%% Calculate the recognition rate for the whole test sate
error_rate = get_error_rate(test_SOM_label, Test_label);
accuracy = 1 - error_rate

    