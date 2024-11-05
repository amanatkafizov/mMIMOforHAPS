%mMIMO for HAPS
clear all;
close all;
clc;

cd 'C:/Users/kafizoa/Dropbox/mMIMO for HAPS/MatlabFiles/Functions'

% User Parameters
Nu = 12; % Number of users per group to select
R = 100e3; % Radius of the circular area (100 km)
num_groups = 10; % Number of groups
group_size = 2 * Nu; % Size of each group (10 x Nu users per group)
alpha=0.2;
P_t=150; %watt


%noise parameters
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
z_height=20000; % Height of the planar array in meters (z-component)


%% compute SINR
SINR_panar=compute_SINR_planar_antenna(Nu,Nt,R,num_groups,group_size,alpha,P_t,P_n,lambda,z_height);
%%
SINR_cylindrical=compute_SINR_cylindrical_antenna(Nu,Nt,R,num_groups,group_size,alpha,P_t,P_n,lambda,z_height);

%%
plotHeatMapSINR(SINR_panar,R,1,'SINR heatmap for planar antenna')
plotHeatMapSINR(SINR_cylindrical,R,2,'SINR heatmap for cylindrical antenna')