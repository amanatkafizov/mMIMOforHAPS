function Resultgain = magnitude_response(theta, phi,alpha_angle,beta_angle,gamma_angle)
    % Parameters
    G_max = 8;      % Maximum gain in dBi
    theta_3dB = 65; % 3dB beamwidth in degrees (elevation)
    phi_3dB = 65;   % 3dB beamwidth in degrees (azimuth)
    SLAv = 30;      % Side Lobe Attenuation (in dB)
    Amax = 30;      % Maximum attenuation (in dB)
 
    
    % Ensure theta and phi are vectors of same size
    assert(numel(theta) == numel(phi), 'Theta and Phi must be vectors of the same size');
    
    
    [theta, phi]=convertLCStoGCS(alpha_angle,beta_angle,gamma_angle,theta,phi);
    
    theta=rad2deg(theta);
    phi=rad2deg(phi);
    
    
    % Calculate the elevation gain (element-wise operations)
    G_theta = -min(12 * ((theta-90) ./ theta_3dB).^2, SLAv);
    
    % Calculate the azimuth gain (element-wise operations)
    G_phi = -min(12 * (phi ./ phi_3dB).^2, Amax);
    
    % Total gain (element-wise sum of G_theta and G_phi)
    gain = -min(-(G_theta + G_phi), Amax); %in dB as G_theta + G_phi decreasing the gain increasing 
    Resultgain=10.^(gain./ 10); % as the gain deacreasing the result gain is also decreasing 
    %Resultgain=gain;
end