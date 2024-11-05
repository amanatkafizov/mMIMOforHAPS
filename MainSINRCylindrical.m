%mMIMO for HAPS
clear all;
close all;
clc;

cd 'C:/Users/kafizoa/Dropbox/mMIMO for HAPS/MatlabFiles/Functions'

% User Parameters
Nu = 12; % Number of users per group to select
R = 100e3; % Radius of the circular area (100 km)
num_groups = 10; % Number of groups
group_size = 1 * Nu; % Size of each group (10 x Nu users per group)
alpha=0.2;
P_t=150; %watt


%noise 
% Given parameters
B = 18e6;               % Bandwidth in Hz (18 MHz)
F_dB = 5;               % Noise figure in dB
P_density_dBm = -174;   % Noise power density in dBm/Hz
P_n=calculate_noise_power(B,F_dB,P_density_dBm);



% Antenna parameters 
fc=2.5e9;
speed_light=3e8;
bandwidth=18e6;
lambda=speed_light/fc;
Nh = 31;         % Number of horizontal elements on each circular array
Nv = 6;          % Number of vertical circular arrays (stacks)
Nb = 10;         % Number of bottom elements
Nt=Nh*Nv+Nb; % total number of antenna elements on HAPS
z_height=20000; % Height of the planar array in meters (z-component)


[antenna_array_positions, angle_circle]=compute_cylindrical_array_positions(lambda,Nh,Nv,Nb,z_height);

% Preallocate space for user positions
% user_positions_and_SINR = zeros(num_groups * Nu, 4); % To store all user positions and their SINR

user_positions_and_SINR = zeros(num_groups * group_size, 4); % To store all user positions and their SINR

% Step 1: Generate random users in the circular area for all groups
all_users = place_users_on_circle(num_groups * group_size, R,0,0); % Generate user positions
    
% Step 2: For each group, apply the semi-orthogonal user selection algorithm
for group = 1:num_groups
    % Get user positions for this group
     group_users = all_users((group-1)*group_size + 1 : group*group_size, :);
     
     
     %Channel parameters for all antenna elements
     [D,Theta,Phi]=cal_params_channel(antenna_array_positions,group_users);
     
     
      %instantiate a channel for a group user
     H_group=zeros(size(D));
     
     % channel for the bottom part for the group selected 
     % local to global transformation parameters for 3GGP radiation pattern
      alpha_angleb=0;
      beta_angleb=3*pi/2;
      gamma_angleb=0;
     H_group(:,end-Nb+1:end) = MIMOHAPSchannel(lambda,D(:,end-Nb+1:end),Theta(:,end-Nb+1:end),Phi(:,end-Nb+1:end), alpha_angleb, beta_angleb, gamma_angleb);
     
     % channel for the cylindrical surface part for the group selected 
     for k=1:Nh
       % local to global transformation parameters for 3GGP radiation pattern
       alpha_anglec=angle_circle(k);
       beta_anglec=0;
       gamma_anglec=0;
       H_group(:,k:Nh:end-Nb) = MIMOHAPSchannel(lambda,D(:,k:Nh:end-Nb),Theta(:,k:Nh:end-Nb),Phi(:,k:Nh:end-Nb), alpha_anglec, beta_anglec, gamma_anglec); 
     end
     

     iterNu=0;
     while(iterNu<group_size)
     
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
%      user_positions_and_SINR((group-1)*Nu +1:(group-1)*Nu+Nu, :) = [Sel_user_posittion SINR_sel_user];
     
     H_group(selected_indices, :) = [];  % Remove rows corresponding to selected users
     group_users(selected_indices, :) = [];  % Remove rows corresponding to selected users
        
     % Store the positions of the selected users and their SINR
     user_positions_and_SINR((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu, :) = [Sel_user_posittion SINR_sel_user];
     
     iterNu=iterNu+Nu;
     end
end



%%
Nfig=1;
titleString='SINR heatmap for cylindrical antenna';
plotHeatMapSINR(user_positions_and_SINR,R,Nfig,titleString)
%%
% Plot the antenna array in 3D space
figure;
scatter3(antenna_array_positions(:,1), antenna_array_positions(:,2), antenna_array_positions(:,3), 'filled');
hold on;
scatter3(user_positions_and_SINR(:,1), user_positions_and_SINR(:,2), user_positions_and_SINR(:,3), 'filled');
xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Z Position (m)');
title('14x14 Planar Antenna Array in the XY Plane at Z = 20000m');
axis equal;
grid on;
