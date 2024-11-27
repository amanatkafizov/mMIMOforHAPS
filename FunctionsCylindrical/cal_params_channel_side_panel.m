
function [ResultD,ResultTheta]=cal_params_channel_side_panel(antenna_array_positions,group_users,z_height)


% Number of antenna elements and users
N = size(antenna_array_positions, 1); % Number of antenna elements
M = size(group_users, 1); % Number of users

% Initialize distance, azimuth, and elevation matrices
distances = zeros(M, N);    % Distance for each user to each antenna element
elevations = zeros(M, N);   % Elevation angles for each user to each antenna element

% Loop through each user and calculate the distance, azimuth, and elevation
for user_idx = 1:M
    for antenna_idx = 1:N
        % Extract the coordinates for the user and antenna element
        user_pos = group_users(user_idx, :);       % (1x3) [x_u, y_u, z_u]
        antenna_pos = antenna_array_positions(antenna_idx, :); % (1x3) [x_a, y_a, z_a]
        
        % Calculate the distance using Euclidean formula
        distances(user_idx, antenna_idx) = sqrt(sum((user_pos - antenna_pos).^2));
        
        phiAntenna = atan2(antenna_pos(2),antenna_pos(1));  % Angle in radians
        thetaAntenna=deg2rad(90);
        
        antenna_direction = [sin(thetaAntenna)*cos(phiAntenna), sin(thetaAntenna)*sin(phiAntenna), cos(thetaAntenna)];
        antenna_direction_hat=antenna_direction/norm(antenna_direction);
        user_direction=[user_pos(1),user_pos(2),user_pos(3)-z_height];

        % Normalize the position vector to get ρhat
        user_direction_hat = user_direction / norm(user_direction);
        % Compute the zenith angle using the dot product
        zenith_angle= acos(dot(user_direction_hat, antenna_direction_hat)); % this gives you the angle from 0 to 180;
        
        elevations(user_idx, antenna_idx)=zenith_angle; %this gives you the angle from 0 to 90;


    end
end

ResultD=distances;
ResultTheta=elevations;

end