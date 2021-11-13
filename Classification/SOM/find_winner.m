function [winner_vector, winner_idx, winner_distance] = find_winner(data, x)

winner_vector = data(:,1);
winner_distance = norm(x-winner_vector);
winner_idx = 1;
for j = 1:length(data(1,:));
    distance = norm(x - data(:,j)); % Calculate the distance
    if (distance <= winner_distance) % Update the winner neuron
        winner_distance = distance;
        winner_vector = data(:,j);
        winner_idx = j;
    end
end
end

