Testing_set = readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\image2_SOM_testing');
Testing_all=ones(6,676);

for i=1:6
    Testing_all(i,:)=reshape(Testing_set{i},[1,676]);
end
Testing_data_mat = Testing_all.';

for i = 1:6
    current_test_sample = Testing_data_mat(:,i);
    % Determine the winner neuron : the closest neuron of the SOM from the
    [winner_output_neuron, winner_output_idx, winner_output_distance] = find_winner(train_weights, current_test_sample);
    % Label the test sample with the one corresponding to the winner neuron
    testing_SOM_label(i) = train_SOM_labels(winner_output_idx); 
    
end