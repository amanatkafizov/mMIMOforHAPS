function [Result_antenna_array_positions, Result_alpha_angle]=compute_cylindrical_array_positions(lambda,Nh,Nv,Nb,z_height)

dh = 0.5 * lambda;  % Horizontal spacing between neighboring elements
dv = 0.5 * lambda;  % Vertical spacing between adjacent circular arrays
db = 0.5 * lambda;  % Spacing for the bottom elements
r = Nh * dh / (2 * pi);  % Radius of the circular array

% Initialize arrays to store positions
alpha_angle=[];
x = [];  % x-coordinates
y = [];  % y-coordinates
z = [];  % z-coordinates

% Generate positions for the cylindrical surface
for v = 0:Nv-1
    z_level = v * dv;  % Vertical level
    for h = 0:Nh-1
        theta = 2 * pi * h / Nh;  % Angle around the circle
        x_h = r * cos(theta);     % x-coordinate
        y_h = r * sin(theta);     % y-coordinate
        z_h =z_height+z_level;            % z-coordinate
        
        % Store the coordinates
        alpha_angle=[alpha_angle; theta];
        x = [x; x_h];
        y = [y; y_h];
        z = [z; z_h];
    end
end

% Generate positions for the bottom elements
for b = 0:Nb-1
    theta_b = 2 * pi * b / Nb;  % Angle around the bottom
    x_b = db * cos(theta_b);    % x-coordinate
    y_b = db * sin(theta_b);    % y-coordinate
    z_b = z_height-dv;                  % Set z to slightly below the cylinder
    
    % Store the bottom element coordinates
    x = [x; x_b];
    y = [y; y_b];
    z = [z; z_b];
end

Result_alpha_angle=alpha_angle;
Result_antenna_array_positions=[x y z];

% Plot the array
figure;
scatter3(Result_antenna_array_positions(end-Nb+1:end,1), Result_antenna_array_positions(end-Nb+1:end,2), Result_antenna_array_positions(end-Nb+1:end,3), 'filled');
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');
title('Cylindrical Antenna Array');
axis equal;
grid on;


end