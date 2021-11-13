function drawSquare(x_corr, y_corr, window_size, color, label)
hold on
y_corr = y_corr+18
plot3([x_corr, x_corr+window_size], [y_corr-window_size, y_corr-window_size], [1 1], 'Color', color)
plot3([x_corr, x_corr+window_size], [y_corr, y_corr], [1 1], 'Color', color)

plot3([x_corr, x_corr], [y_corr-window_size, y_corr], [1 1], 'Color', color)
plot3([x_corr+window_size, x_corr+window_size], [y_corr-window_size, y_corr], [1 1], 'Color', color)

text(x_corr+window_size/2, y_corr+3, 1, label, 'FontSize', 12, 'Color', color)