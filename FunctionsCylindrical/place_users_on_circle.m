function User_positions_final=place_users_on_circle(num_users, R,x0,y0)
% Now create the set of points.
t = 2*pi*rand(num_users,1);
r = R*sqrt(rand(num_users,1));


%Function to generate random positions in a circular area
User_positions_final = [x0+r.*cos(t),y0+r.*sin(t), zeros(num_users, 1)];



% 
% theta = linspace(0, 2*pi, num_users + 1);
% theta(end) = [];  % Remove the last angle to avoid overlapping the first point
% 
% % Calculate user positions on the edge of the circle
% x_positions = x0 + R * cos(theta);
% y_positions = y0 + R * sin(theta);
% 
% % Combine x, y positions, with z as zero (ground level)
% User_positions_final = [x_positions(:), y_positions(:), zeros(num_users, 1)];



% % Define the radii where users will be placed
%     radii = [R, 0.8 * R, 0.6 * R, 0.4 * R, 0.2 * R, 0.1 * R];
%     
%     num_users_per_radius=num_users/length(radii);
%     
%     % Initialize the final positions matrix
%     User_positions_final = [];
%     
%     % Loop through each radius
%     for r = radii
%         % Generate equally spaced angles for users on the current radius
%         angles = linspace(0, 2 * pi, num_users_per_radius + 1);
%         angles = angles(1:end-1); % Exclude the last point to avoid overlap
%         
%         % Calculate the x, y positions
%         x = x0 + r * cos(angles);
%         y = y0 + r * sin(angles);
%         
%         % Append these positions with z = 0 to the final positions matrix
%         User_positions_final = [User_positions_final; [x', y', zeros(num_users_per_radius, 1)]];
%     end

end