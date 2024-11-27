function P_n=calculate_noise_power(B,F_dB,P_density_dBm)

% Convert noise figure to linear scale
F_linear = 10^(F_dB / 10);

% Convert noise power density from dBm/Hz to W/Hz
P_density_W = 10^((P_density_dBm) / 10) * 1e-3;  % Convert from dBm to W

% Calculate the noise power
%P_n = P_density_W * B * F_linear;
P_n = P_density_W * B;

end