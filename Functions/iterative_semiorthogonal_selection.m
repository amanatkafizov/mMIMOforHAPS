function ResultS_total = iterative_semiorthogonal_selection(H, Nu, alpha)
    % H: K x Nt channel matrix (K users, Nt transmit antennas)
    % Nu: Number of users to be selected per iteration
    % alpha: Threshold for semiorthogonality (small positive constant)

    [K, Nt] = size(H);  % Get the size of the channel matrix
    S_total = {};  % Initialize a cell array to store all selected users
    
    % Iterate until the matrix H becomes empty
    while K >= Nu
        % Apply SUS algorithm to select Nu users
        S0 = semiorthogonal_user_selection(H, Nu, alpha);  
        
        % Store the selected users from this iteration
        S_total{end+1} = S0;
        
        % Remove selected users from H
        H(S0, :) = [];  % Remove rows corresponding to selected users
        
        % Update K to the new number of remaining users
        K = size(H, 1);
    end
    
    % Display the selected users in each iteration
    for i = 1:length(S_total)
        fprintf('Iteration %d: Selected users = \n', i);
        disp(S_total{i});
    end
    ResultS_total=S_total;
end