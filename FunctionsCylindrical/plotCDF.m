function plotCDF(sinr_values, Nfig, titleString, xlabelstring)
    % Function to plot the Cumulative Distribution Function (CDF) of SINR values.
    % Input:
    %   sinr_values - A vector containing SINR values for users.
    
    % Sort the SINR values in ascending order
    sinr_sorted = sort(sinr_values);
    
    % Create a vector for cumulative probabilities
    cdf_values = (1:length(sinr_sorted)) / length(sinr_sorted);
    
    % Plot the CDF
    figure(Nfig);
    plot(sinr_sorted, cdf_values, 'LineWidth', 2);
    grid on;
    xlabel(xlabelstring);
    ylabel('Cumulative Probability');
    title(titleString);
    
    % Set x-axis range and ticks
%     xlim([-10, 40]);           % Limit x-axis to range from -10 to 40
%     xticks(-10:5:40);          % Set x-axis ticks with step size of 5
end
