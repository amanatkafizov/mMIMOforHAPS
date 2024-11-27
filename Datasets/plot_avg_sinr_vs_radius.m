function [ResultAvgSINR,Result_bin_centers]=plot_avg_sinr_vs_radius(user_positions_and_SINR, R, num_bins)
    % Input:
    %   user_positions_and_SINR - Nx4 matrix, first 3 columns: x, y, z, 4th column: SINR
    %   R - Radius of the circular area
    %   num_bins - Number of bins to divide the radius into

    % Extract positions and SINR values
    x = user_positions_and_SINR(:, 1);
    y = user_positions_and_SINR(:, 2);
    z = user_positions_and_SINR(:, 3);
    SINR = user_positions_and_SINR(:, 4);
    
    % Compute radial distances
    r = sqrt(x.^2 + y.^2 + z.^2);
    
    % Define radius bins
    bin_edges = linspace(0, R, num_bins + 1);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
    
    % Initialize array to store average SINR values
    avg_sinr = zeros(1, num_bins);
    
    % Calculate average SINR for each bin
    for i = 1:num_bins
        % Find indices of users in the current bin
        indices_in_bin = (r >= bin_edges(i)) & (r < bin_edges(i+1));
        
        % Calculate average SINR for users in the bin
        if any(indices_in_bin)
            avg_sinr(i) = mean(SINR(indices_in_bin));
        else
            avg_sinr(i) = NaN; % Handle empty bins
        end
    end
    
    ResultAvgSINR=avg_sinr;
    Result_bin_centers=bin_centers;
    
%     % Plot the results
%     figure;
%     plot(bin_centers, avg_sinr, '-o', 'LineWidth', 1.5);
%     xlabel('Radius r (m)');
%     ylabel('Average SINR (dB)');
%     title('Average SINR vs Radius');
%     grid on;
end
