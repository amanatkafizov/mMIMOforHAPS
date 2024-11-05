function planar_array_positions=compute_planar_array_positions(lambda,num_elements,z_height)


% Parameters
spacing = 0.5 * lambda; % Element spacing in meters

% Create a grid of positions for the array elements
% Range of indices centered around 0
index_range = -(num_elements-1)/2 : (num_elements-1)/2;

% Generate x and y coordinates (planar array centered at (0, 0))
[x_grid, y_grid] = meshgrid(index_range, index_range);

% Scale x and y coordinates by the spacing between elements
x_positions = spacing * x_grid;
y_positions = spacing * y_grid;

% z-component is fixed for all elements
z_positions = z_height * ones(size(x_grid));

% Combine the x, y, z coordinates into a 3D array of positions
antenna_positions = [x_positions(:), y_positions(:), z_positions(:)];


% Plot the antenna array in 3D space
figure;
scatter3(antenna_positions(:,1), antenna_positions(:,2), antenna_positions(:,3), 'filled');
xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Z Position (m)');
title('14x14 Planar Antenna Array in the XY Plane at Z = 20000m');
axis equal;
grid on;

planar_array_positions=antenna_positions;

end