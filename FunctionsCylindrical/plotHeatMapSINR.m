function plotHeatMapSINR(user_positions_and_SINR, R,Nfig,titleString)
    % Given matrix of user positions and SINR values
    data = user_positions_and_SINR;  % Replace with your actual data
    x = data(:, 1);  % X coordinates
    y = data(:, 2);  % Y coordinates
    sinr = data(:, 4);  % SINR values

    % Circular coverage area specifications
    grid_size = 2000;  % Grid size of 2x2 km²

    % Define the grid
    x_grid_edges = -R:grid_size:R;  % X-axis grid edges
    y_grid_edges = -R:grid_size:R;  % Y-axis grid edges

    % Preallocate matrix for average SINR in each grid
    avg_sinr_grid = nan(length(y_grid_edges)-1, length(x_grid_edges)-1);

    % Loop through each grid cell and calculate the average SINR
    for i = 1:length(x_grid_edges)-1
        for j = 1:length(y_grid_edges)-1
            % Compute the center of the current grid cell
            x_center = (x_grid_edges(i) + x_grid_edges(i+1)) / 2;
            y_center = (y_grid_edges(j) + y_grid_edges(j+1)) / 2;

            % Check if the center of the grid cell is within the circular area
            if sqrt(x_center^2 + y_center^2) <= R
                % Find the users within this grid cell
                in_grid = x >= x_grid_edges(i) & x < x_grid_edges(i+1) & ...
                          y >= y_grid_edges(j) & y < y_grid_edges(j+1);

                % If there are users in this grid cell, calculate average SINR
                if sum(in_grid) > 0
                    avg_sinr_grid(j, i) = mean(sinr(in_grid));  % Average SINR
                else
                    avg_sinr_grid(j, i) = NaN;  % No users in this grid
                end
            end
        end
    end
    
    
    
   % Plot the heatmap, masking NaN values to exclude cells outside the circle
figure(Nfig);

% Display the heatmap
h = imagesc(x_grid_edges, y_grid_edges, avg_sinr_grid);

% Set color for NaN values to be transparent
set(h, 'AlphaData', ~isnan(avg_sinr_grid));  % NaN values will be transparent
set(gca, 'YDir', 'normal');  % Fix the Y-axis direction

% Color settings
colorbar;                 % Show color scale
%caxis([0, 30]);           % Set color scale limits

% Title and axis labels
title(titleString);
xlabel('X (m)');
ylabel('Y (m)');
axis equal;  % Keep the scale the same on both axes

% Add contour overlay on the heatmap, skipping NaN values
hold on;
contour(x_grid_edges(1:end-1), y_grid_edges(1:end-1), avg_sinr_grid, ...
    'LineColor', 'black', 'ShowText', 'on', 'LevelList', 0:2.5:50);
hold off;
    
end
