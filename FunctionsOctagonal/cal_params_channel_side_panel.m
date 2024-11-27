
function [ResultD,ResultTheta]=cal_params_channel_side_panel(antenna_array_positions,Ns,Nc,Nr,group_users,z_height)

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
Nps=Nc*Nr; % total number of antennas per side

thetaAntenna=deg2rad(113);
phiAntenna=deg2rad([90 135 225 270 315 45]);

% Loop through each user and calculate the distance, azimuth, and elevation
for user_idx = 1:M
    for side_idx=1:Ns
       for antenna_idx = 1:Nps
        % Extract the coordinates for the user and antenna element
        user_pos = group_users(user_idx, :);       % (1x3) [x_u, y_u, z_u]
        antenna_pos = antenna_array_positions((side_idx-1)*Nps+antenna_idx, :); % (1x3) [x_a, y_a, z_a]
        
        % Calculate the distance using Euclidean formula
        distances(user_idx, (side_idx-1)*Nps+antenna_idx) = sqrt(sum((user_pos - antenna_pos).^2));
 
        
        antenna_direction = [sin(thetaAntenna)*cos(phiAntenna(side_idx)), sin(thetaAntenna)*sin(phiAntenna(side_idx)), cos(thetaAntenna)];
        antenna_direction_hat=antenna_direction/norm(antenna_direction);
        user_direction=[user_pos(1),user_pos(2),user_pos(3)-z_height];

        % Normalize the position vector to get ρhat
        user_direction_hat = user_direction / norm(user_direction);
        % Compute the zenith angle using the dot product
        zenith_angle= acos(dot(user_direction_hat, antenna_direction_hat)); % this gives you the angle from 0 to 180;
        
        elevations(user_idx, (side_idx-1)*Nps+antenna_idx)=zenith_angle; %this gives you the angle from 0 to 90;





       end
    end
end

ResultD=distances;
ResultTheta=elevations;

end