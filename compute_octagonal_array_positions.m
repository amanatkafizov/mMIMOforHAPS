function hexagonal_array_positions = compute_octagonal_array_positions(lambda, Ns,Nb, Nc, Nr, z_height)
    % Function to compute the positions of mMIMO antenna elements for a hexagonal array structure.
    %
    % Input:
    %   lambda    - Wavelength (in meters), used for spacing
    %   Nb        - Number of elements on the bottom panel (hexagonal)
    %   Nc        - Number of elements per row on each side panel (30 for 6 panels)
    %   Nr        - Number of rows on each side panel
    %   radius    - Radius of the side panel placement (in meters)
    %   z_height  - Height of the array (in meters)
    %
    % Output:
    %   hexagonal_array_positions - Nx3 matrix of element positions (x, y, z)
    
    % Element spacing
    element_spacing = lambda / 2;
    
    %% Bottom Panel: Hexagonal Array
    % Create hexagonal lattice points
    num_elements=sqrt(Nb);
    
    index_range = -(num_elements-1)/2 : (num_elements-1)/2;

   % Generate x and y coordinates (planar array centered at (0, 0))
   [x_grid, y_grid] = meshgrid(index_range, index_range);

   % Scale x and y coordinates by the spacing between elements
   x_positions = element_spacing * x_grid;
   y_positions = element_spacing * y_grid;

   % z-component is fixed for all elements
   z_positions = (z_height-Nr*element_spacing) * ones(size(x_grid));

   % Combine the x, y, z coordinates into a 3D array of positions
   bottom_panel_positions = [x_positions(:), y_positions(:), z_positions(:)];
    
    
    %% Side Panels: Tilted Hexagonal Arrays
    tilt_angle = 23; % Tilt angle in degrees
    tilt_angle_rad = deg2rad(tilt_angle); % Convert to radians
    side_panel_positions = [];
    
    
    radius=(Nc-1)*element_spacing+4*element_spacing;
    
    for panel = 1:Ns
        % Compute rotation angle for the current panel
        rotation_angle = (panel - 1) * 2 * pi / Ns; % 60-degree increments
        
        % Base coordinates for the side panel
        x_positions_side = element_spacing * (-(Nc-1)/2:(Nc-1)/2);
        z_positions_side = -element_spacing * (0:(Nr-1));
        [x_side, z_side] = meshgrid(x_positions_side, z_positions_side);
        y_side = zeros(size(x_side)); % Initial y-coordinates
        
        % Tilt the side panel downward by 23 degrees
        z_tilted = z_side * cos(tilt_angle_rad) - y_side * sin(tilt_angle_rad);
        y_tilted = z_side * sin(tilt_angle_rad) + y_side * cos(tilt_angle_rad);
        
        y_tilted=y_tilted+radius;
        
        % Rotate the side panel around the z-axis
        x_rotated = x_side * cos(rotation_angle) - y_tilted * sin(rotation_angle);
        y_rotated = x_side * sin(rotation_angle) + y_tilted * cos(rotation_angle);
        
        % Shift to correct height and radius
        z_rotated = z_tilted + z_height;
%         y_rotated = y_rotated + radius * cos(rotation_angle);
%         x_rotated = x_rotated + radius * sin(rotation_angle);
        
        % Combine positions for the current side panel
        panel_positions = [x_rotated(:), y_rotated(:), z_rotated(:)];
        % Keep only the first 30 elements for each panel
        panel_positions = panel_positions(1:30, :);
        side_panel_positions = [side_panel_positions; panel_positions];
    end
    
    %% Combine Bottom and Side Panels
    hexagonal_array_positions = [side_panel_positions; bottom_panel_positions];
    
   
%     
%     
%     
    %%
    %% Plot the Hexagonal Antenna Array
    figure;
    scatter3(hexagonal_array_positions(:,1), hexagonal_array_positions(:,2), hexagonal_array_positions(:,3), 'filled');
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    zlabel('Z Position (m)');
    title('Hexagonal Antenna Array Structure');
    axis equal;
    grid on;
end
