%mMIMO for HAPS
clear all;
close all;
clc;

%cd 'C:/Users/kafizoa/Dropbox/mMIMO for HAPS/MatlabFiles/FunctionsPlanar'

cd '/Users/kafizoa/Dropbox/mMIMO for HAPS/MatlabFiles/FunctionsPlanar'
% User Parameters
Nu = 6; % Number of users per group to select
total_iterations = 10; % Total number of iterations
R = 100e3; % Radius of the circular area (100 km)
num_groups = 1; % Number of groups
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
Nt=196; %number of antenna elements on HAPS
num_elements = 14; % Number of elements along x and y
z_height=20000; % Height of the planar array in meters (z-component)


antenna_array_positions=compute_planar_array_positions(lambda,num_elements,z_height);

% Preallocate space for user positions
user_positions_and_SINR = zeros(num_groups * group_size, 4); % To store all user positions and their SINR



% Step 1: Generate random users in the circular area for all groups
all_users = place_users_on_circle(num_groups * group_size, R,0,0,0); % Generate user positions

ThetaNotTrans=zeros(num_groups * group_size,Nt);
PhiNotTrans=zeros(num_groups * group_size,Nt);
ThetaTrans=zeros(num_groups * group_size,Nt);
PhiTrans=zeros(num_groups * group_size,Nt);
signal_powerAllUsers=zeros(num_groups * group_size,1);
interference_powerAllUsers=zeros(num_groups * group_size,1);
    
% Step 2: For each group, apply the semi-orthogonal user selection algorithm
for group = 1:num_groups
    % Get user positions for this group
     group_users = all_users((group-1)*group_size + 1 : group*group_size, :);
        
     [D,Theta,Phi]=cal_params_channel(antenna_array_positions,group_users,z_height);


     
     alpha_angle=0;
     beta_angle=pi/2;
     gamma_angle=0;
        
     % channel for the group selected 
     [H_group,ThetaTrans_group,RPhiTrans_group] = MIMOHAPSchannel(lambda,D,Theta,Phi,alpha_angle,beta_angle,gamma_angle);


     iterNu=0;
     while(iterNu<group_size)
     ThetaNotTrans((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu,:)=rad2deg(Theta);
     PhiNotTrans((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu,:)=rad2deg(Phi);
     ThetaTrans((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu,:)=ThetaTrans_group;
     PhiTrans((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu,:)=RPhiTrans_group;
%      

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
     
     signal_powerAllUsers((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu, 1)=signal_power;
     interference_powerAllUsers((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu, 1)=singal_inter;
     H_group(selected_indices, :) = [];  % Remove rows corresponding to selected users
     group_users(selected_indices, :) = [];  % Remove rows corresponding to selected users
%         
     % Store the positions of the selected users and their SINR
     user_positions_and_SINR((group-1)*group_size +iterNu+ 1:(group-1)*group_size+iterNu+Nu, :) = [Sel_user_posittion SINR_sel_user];
     
     iterNu=iterNu+Nu;
     end
end



%%
Nfig=4;
titleString='SINR heatmap for planar antenna';
plotHeatMapSINR(user_positions_and_SINR,R,Nfig,titleString)
%%
%Plot the antenna array in 3D space
figure;
scatter3(antenna_array_positions(:,1), antenna_array_positions(:,2), antenna_array_positions(:,3), 'filled');
hold on;
scatter3(all_users(:,1), all_users(:,2), all_users(:,3), 'filled');
xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Z Position (m)');
title('14x14 Planar Antenna Array in the XY Plane at Z = 20000m');
axis equal;
grid on;
