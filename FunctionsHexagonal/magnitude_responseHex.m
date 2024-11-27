function [Resultgain,Resulttheta] = magnitude_responseHex(theta)
    % Parameters
    G_max = 8;      % Maximum gain in dBi
    theta_3dB = 65; % 3dB beamwidth in degrees (elevation)
    Amax = 30;      % Maximum attenuation (in dB)
 
    
    theta=rad2deg(theta);
    Resulttheta=theta;
    % Calculate the elevation gain (element-wise operations)
    G_theta = -min(12 * ((theta-0) ./ theta_3dB).^2, Amax);
       
    % Total gain (element-wise sum of G_theta and G_phi)
    gain =G_max+G_theta; %in dB as G_theta + G_phi decreasing the gain increasing 
    Resultgain=10.^(gain./ 10); % as the gain deacreasing the result gain is also decreasing 
    %Resultgain=gain;
end