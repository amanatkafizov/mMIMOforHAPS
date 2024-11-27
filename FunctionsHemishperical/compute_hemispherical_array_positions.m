function hemispherical_array_positions = compute_hemispherical_array_positions(Nt, z_height, lambda)
    % Function to compute the positions of mMIMO antenna elements for a hemispherical antenna array.
    % Input:
    %   Nt           - Number of antenna elements
    %   z_height     - Height of the hemisphere in meters
    %   lambda       - Wavelength in meters
    
    % Initial radius estimate
    radius = sqrt((Nt * lambda^2) / (8 * pi)); % Estimate radius dynamically
    element_spacing = lambda / 2; % Spacing constraint
    hemispherical_array_positions = [];
    
    while true
        % Calculate angular divisions for theta and phi
        num_theta = floor(pi * radius / (2 * element_spacing)); % Theta divisions
        theta = linspace(0, pi/2, num_theta + 1); % Elevation: 0 to pi/2
        
        for k = 2:length(theta) % Skip theta=0
            % Calculate phi divisions for this theta
            num_phi = floor(2 * pi * radius * sin(theta(k)) / element_spacing);
            phi = linspace(0, 2 * pi, num_phi + 1);
            
            % Convert spherical to Cartesian coordinates
            x_positions = radius * sin(theta(k)) * cos(phi(1:end-1))';
            y_positions = radius * sin(theta(k)) * sin(phi(1:end-1))';
            z_positions = -radius * cos(theta(k)) * ones(length(phi(1:end-1)), 1);
            
            % Shift hemisphere upwards
            z_positions = z_positions + z_height;
            
            % Append new positions
            new_positions = [x_positions, y_positions, z_positions];
            hemispherical_array_positions = [hemispherical_array_positions; new_positions];
            
            % Break early if we exceed Nt elements
            if size(hemispherical_array_positions, 1) >= Nt
                break;
            end
        end
        
        % Check if we have exactly Nt elements
        if size(hemispherical_array_positions, 1) == Nt
            break;
        elseif size(hemispherical_array_positions, 1) > Nt
            % Resample to match Nt
            idx = randperm(size(hemispherical_array_positions, 1), Nt);
            hemispherical_array_positions = hemispherical_array_positions(idx, :);
            break;
        else
            % Increase radius slightly to place more elements
            radius = radius * 1.01;
        end
    end
    
    % Plot the hemispherical antenna array
    figure;
    scatter3(hemispherical_array_positions(:, 1), hemispherical_array_positions(:, 2), hemispherical_array_positions(:, 3), 'filled');
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    zlabel('Z Position (m)');
    title(['Hemispherical Antenna Array with Radius = ', num2str(radius), ...
        ' m, Height = ', num2str(z_height), ' m, Spacing = ', num2str(element_spacing), ' m']);
    axis equal;
    grid on;
end
