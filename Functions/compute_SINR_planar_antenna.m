function Result=compute_SINR_planar_antenna(Nu,Nt,R,num_groups,group_size,alpha,P_t,P_n,lambda,z_height)


cd 'C:/Users/kafizoa/Dropbox/mMIMO for HAPS/MatlabFiles/Functions'
num_elements = Nt/14; % Number of elements along x and y


antenna_array_positions=compute_planar_array_positions(lambda,num_elements,z_height);

% Preallocate space for user positions
user_positions_and_SINR = zeros(num_groups * Nu, 4); % To store all user positions and their SINR
%user_positions_and_SINR = zeros(num_groups * group_size, 4); % To store all user positions and their SINR


% Step 1: Generate random users in the circular area for all groups
all_users = place_users_on_circle(num_groups * group_size, R,0,0); % Generate user positions
    
% Step 2: For each group, apply the semi-orthogonal user selection algorithm
for group = 1:num_groups
    % Get user positions for this group
     group_users = all_users((group-1)*group_size + 1 : group*group_size, :);
        
     [D,Theta,Phi]=cal_params_channel(antenna_array_positions,group_users);
     
      alpha_angle=0;
      beta_angle=3*pi/2;
      gamma_angle=0;
        
     % channel for the group selected 
     H_group = MIMOHAPSchannel(lambda,D,Theta,Phi,alpha_angle,beta_angle,gamma_angle);
%      
%      iterNu=0;
%      while(iterNu<group_size)
     % Step 3: Apply the semi-orthogonal selection algorithm
     selected_indices = semi_orthogonal_selection(H_group, Nu, alpha);
     
     H=H_group(selected_indices,:); %first select the channels of the corresponding selected Nu users
     
     Sel_user_posittion=group_users(selected_indices,:); %positions of the corresponding selected Nu users
     
     % Step 1: Compute the raw ZF beamforming matrix
     B_ZF_raw = H' * inv(H * H');

     % Step 2: Normalize each column of B_ZF_raw to obtain the final ZF precoding matrix
     B_ZF = zeros(size(B_ZF_raw)); % Preallocate the ZF precoding matrix

     for i = 1:Nu
        B_ZF(:,i) = B_ZF_raw(:,i) / norm(B_ZF_raw(:,i)); % Normalize each column
     end
     
     [SINR_sel_user, signal_power,singal_inter, signal_noise] = calculate_sinr(H, B_ZF, P_t, P_n); %SINR of selected users
     
        
     % Store the positions of the selected users and their SINR
     user_positions_and_SINR((group-1)*Nu +1:(group-1)*Nu+Nu, :) = [Sel_user_posittion SINR_sel_user];
     
%      H_group(selected_indices, :) = [];  % Remove rows corresponding to selected users
%      group_users(selected_indices, :) = [];  % Remove rows corresponding to selected users
%         
%      % Store the positions of the selected users and their SINR
%      user_positions_and_SINR((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu, :) = [Sel_user_posittion SINR_sel_user];
%      
%      iterNu=iterNu+Nu;
%      end

end

Result=user_positions_and_SINR;
end
