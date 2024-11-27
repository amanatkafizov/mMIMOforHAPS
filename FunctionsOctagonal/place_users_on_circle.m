function User_positions_final=place_users_on_circle(num_users, R,x0,y0,z_height)
% Now create the set of points.
t = 2*pi*rand(num_users,1);
r = R*sqrt(rand(num_users,1));


%Function to generate random positions in a circular area
User_positions_final = [x0+r.*cos(t),y0+r.*sin(t), z_height*ones(num_users, 1)];

% theta = linspace(0, 2*pi, num_users + 1);
% theta(end) = [];  % Remove the last angle to avoid overlapping the first point
% 
% % Calculate user positions on the edge of the circle
% x_positions = x0 + R * cos(theta);
% y_positions = y0 + R * sin(theta);
% 
% % Combine x, y positions, with z as zero (ground level)
% User_positions_final = [x_positions(:), y_positions(:), z_height*ones(num_users, 1)];

end