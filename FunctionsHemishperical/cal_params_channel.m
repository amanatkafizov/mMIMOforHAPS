
function [ResultD,ResultTheta,ResultPhi]=cal_params_channel(antenna_array_positions,group_users,z_height)

% Example inputs: planar_array_positions (Nx3) for N antenna elements
% and group_users (Mx3) for M users.
% Nx3 matrix of antenna positions (x, y, z) for N elements
% Mx3 matrix of user positions (x, y, z) for M users

% Number of antenna elements and users
N = size(antenna_array_positions, 1); % Number of antenna elements
M = size(group_users, 1); % Number of users

% Initialize distance, azimuth, and elevation matrices
distances = zeros(M, N);    % Distance for each user to each antenna element
azimuths = zeros(M, N);     % Azimuth angles for each user to each antenna element
elevations = zeros(M, N);   % Elevation angles for each user to each antenna element

% Loop through each user and calculate the distance, azimuth, and elevation
for user_idx = 1:M
    for antenna_idx = 1:N
        % Extract the coordinates for the user and antenna element
        user_pos = group_users(user_idx, :);       % (1x3) [x_u, y_u, z_u]
        antenna_pos = antenna_array_positions(antenna_idx, :); % (1x3) [x_a, y_a, z_a]
        
        % Calculate the distance using Euclidean formula
        distances(user_idx, antenna_idx) = sqrt(sum((user_pos - antenna_pos).^2));
        
%         % Calculate azimuth angle
        delta_x = user_pos(1)-antenna_pos(1);
        delta_y = user_pos(2)-antenna_pos(2);
        delta_z = user_pos(3)-antenna_pos(3);
        horizontal_distance = sqrt(delta_x^2 + delta_y^2);
        azimuths(user_idx, antenna_idx) = atan2(delta_y,delta_x);  % Angle in radians
%         
        % Calculate elevation angle
        %elevations(user_idx, antenna_idx) = deg2rad(atan2d(delta_z,horizontal_distance));  % Angle in radians
        elevations(user_idx, antenna_idx) = atan2(horizontal_distance,delta_z);  % Angle in radians
        
%         Thetak=atan2(sqrt(user_pos(1)^2+user_pos(2)^2),user_pos(3)-z_height);
%         Phik=atan2(user_pos(2),user_pos(1));
%         Thetam=atan2(sqrt(antenna_pos(1)^2+antenna_pos(2)^2),antenna_pos(3)-z_height);
%         Phim=atan2(antenna_pos(2),antenna_pos(1));
%         elevations(user_idx, antenna_idx) = acos(sin(Thetak)*sin(Thetam)*cos(Phik)*cos(Phim)+sin(Thetak)*sin(Thetam)*sin(Phik)*sin(Phim)+cos(Thetak)*cos(Thetam));
        antenna_direction = [antenna_pos(1), antenna_pos(2), antenna_pos(3)-z_height];
        antenna_direction_hat=antenna_direction/norm(antenna_direction);
        user_direction=[user_pos(1),user_pos(2),user_pos(3)-z_height];

        % Normalize the position vector to get ρhat
        user_direction_hat = user_direction / norm(user_direction);
        % Compute the zenith angle using the dot product
        zenith_angle= acos(dot(user_direction_hat, antenna_direction_hat)); % this gives you the angle from 0 to 180;
        
        elevations(user_idx, antenna_idx)=zenith_angle; %this gives you the angle from -90 to 90;





    end
end

ResultD=distances;
ResultTheta=elevations;
ResultPhi=azimuths;

end