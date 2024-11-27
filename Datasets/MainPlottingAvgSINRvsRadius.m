close all;
clear all;
clc;
R = 100e3; % Radius of the circular area (100 km)

SINR_pl=load('Planar.mat').user_positions_and_SINR;
SINR_cyl=load('Cylindrical.mat').user_positions_and_SINR;
SINR_hem=load('SINRHemispherical.mat').user_positions_and_SINR;
SINR_hex=load('Hexagonal.mat').user_positions_and_SINR;


bin_number=20;

[AvgSINR_pl,bin_centers_pl]=plot_avg_sinr_vs_radius(SINR_pl, R, bin_number);
[AvgSINR_cyl,bin_centers_cyl]=plot_avg_sinr_vs_radius(SINR_cyl, R, bin_number);
[AvgSINR_hem,bin_centers_hem]=plot_avg_sinr_vs_radius(SINR_hem, R, bin_number);
[AvgSINR_hex,bin_centers_hex]=plot_avg_sinr_vs_radius(SINR_hex, R, bin_number);


% Plot the results
figure;
plot(bin_centers_pl, AvgSINR_pl, '-o', 'LineWidth', 1.5); % Plot for planar
hold on;
plot(bin_centers_cyl, AvgSINR_cyl, '-o', 'LineWidth', 1.5); % Plot for cylindrical
hold on;
plot(bin_centers_hem, AvgSINR_hem, '-o', 'LineWidth', 1.5); % Plot for hemispherical
hold on;
plot(bin_centers_hex, AvgSINR_hex, '-o', 'LineWidth', 1.5); % Plot for hexagonal

% Add labels and title
xlabel('Radius r (m)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Average SINR (dB)', 'FontSize', 14, 'FontWeight', 'bold');
title('Average SINR vs Radius', 'FontSize', 16, 'FontWeight', 'bold');

% Add grid
grid on;

% Add legend
legend('Planar', 'Cylindrical', 'Hemispherical', 'Hexagonal', 'FontSize', 20, 'Location', 'best');

% Set axis font size
set(gca, 'FontSize', 20);

