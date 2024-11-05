function  [Resultgamma,Resultsignal,Resultinter,Resultnoise] = calculate_sinr(H, B, P_t, P_n)
    % H: Nu x Nt channel matrix (Nu users, Nt antennas)
    % B: Nt x Nu beamforming matrix (each column is a beamforming vector for user u)
    % P_t: Total transmit power
    % P_n: Noise power
    % gamma_u: SINR vector for all Nu users
    
    [Nu, Nt] = size(H);  % Nu is the number of users, Nt is the number of transmit antennas
    
    % Uniform power distribution among users
    p_u = P_t / Nu;  % Transmit power for each user
    
    % Initialize SINR vector for all users
    gamma_u = zeros(Nu, 1);
    
    % Loop over each user to calculate SINR
    for u = 1:Nu
        % Desired signal power for user u
        signal_power = abs(H(u, :) * B(:, u))^2 * p_u;
        
        % Interference from all other users i ≠ u
        interference_power = 0;
        for i = 1:Nu
            if i ~= u
                interference_power = interference_power + (abs(H(u, :) * B(:, i))^2) * (P_t / Nu);
            end
        end
        interference_power=0;
        
        % SINR calculation for user u
        gamma_u(u) = 10*log10(signal_power / (P_n + interference_power));
    end
    Resultsignal=10*log10(signal_power/1e-3);
    Resultinter=10*log10(interference_power/1e-3);
    Resultnoise=10*log10(P_n/1e-3);
    Resultgamma=gamma_u;
end