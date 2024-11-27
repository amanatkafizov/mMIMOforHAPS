function ResultS0 = semi_orthogonal_selection(H_group, Nu, alpha)
    % H: M x Nt channel matrix (M users, Nt transmit antennas)
    % Nu: Number of users to be selected
    % alpha: Threshold for semiorthogonality (small positive constant)

    [M, Nt] = size(H_group);  % Get the size of the channel matrix
    S0 = [];  % Initialize the set of selected users
    T = 1:M;  % Initial set of all users
    i = 1;  % Initialize index for the selected users
    
    g = zeros(M, Nt);  % Initialize orthogonalized channel vectors for all users
    % Step 2: Loop until M users are selected or T is empty
 if(M<=Nu)
        ResultS0=T;
 else
    while length(S0) < Nu && ~isempty(T)
        
        % Step 2a: Calculate g_k for each user k in T
        for k = T
            h_k = H_group(k, :);  % Get the channel vector for user k
            
            if i == 1
                % When i = 1, g_k = h_k
                g(k, :) = h_k;
            else
                % Orthogonalize h_k with respect to the subspace spanned by g(1:i-1)
                g_k = h_k;
                for j = 1:i-1
                    g_k = g_k - ((h_k * g(S0(j), :)') / (norm(g(S0(j), :))^2)) * g(S0(j), :);
                end
                g(k, :) = g_k;  % Store orthogonalized vector
            end
        end
        
        % Step 3: Select the ith user with the maximum norm of g_k
        [~, pi_i] = max(vecnorm(g(T, :), 2, 2));  % Select user with max ||g_k||
        pi_i = T(pi_i);  % User index
        
        % Add selected user to S0
        S0 = [S0, pi_i];
        
        g_pi_i = g(pi_i, :);  % The orthogonalized vector of the selected user
        h_pi_i= H_group(pi_i, :); 
        
        % Step 4: Update T by removing non-semiorthogonal users
        if(length(S0) < Nu)
           T_new = [];
        
           for k = T
              if k ~= pi_i
                % Check semiorthogonality condition
                h_k = H_group(k, :);
                if (((h_k * g_pi_i') / (norm(h_k) * norm(g_pi_i))) < alpha)
                    T_new = [T_new, k];  % Keep user k in the set if semiorthogonal
                end
              end
            end
        
        T = T_new;  % Update the set of remaining users
        
        end
        i = i + 1;  % Increment the user selection index
    end
    ResultS0=S0;
end
end

% 
% 
% function ResultS0 = semi_orthogonal_selection(H, Nu, alpha)
%     % H: M x Nt channel matrix (M users, Nt transmit antennas)
%     % Nu: Number of users to be selected
%     % alpha: Threshold for semiorthogonality (small positive constant)
% 
%     [M, Nt] = size(H);  % Get the size of the channel matrix
%     S0 = [];  % Initialize the set of selected users
%     T = 1:M;  % Initial set of all users
%     i = 1;  % Initialize index for the selected users
%     
%     % Step 2: Loop until M users are selected or T is empty
%     while length(S0) < Nu && ~isempty(T)
%         g = zeros(M, Nt);  % Initialize orthogonalized channel vectors for all users
%         
%         % Step 2a: Calculate g_k for each user k in T
%         for k = T
%             h_k = H(k, :);  % Get the channel vector for user k
%             
%             if i == 1
%                 % When i = 1, g_k = h_k
%                 g(k, :) = h_k;
%             else
%                 % Orthogonalize h_k with respect to the subspace spanned by g(1:i-1)
%                 g_k = h_k;
%                 for j = 1:i-1
%                     g_k = g_k - ((h_k * g(S0(j), :)') / (norm(g(S0(j), :))^2)) * g(S0(j), :);
%                 end
%                 g(k, :) = g_k;  % Store orthogonalized vector
%             end
%         end
%         
%         % Step 3: Select the user with the maximum norm of g_k
%         [~, pi_i] = max(vecnorm(g(T, :), 2, 2));  % Select user with max ||g_k||
%         pi_i = T(pi_i);  % User index
%         
%         % Add selected user to S0
%         S0 = [S0, pi_i];
%         
%         % Step 4: Update T by removing non-semiorthogonal users
%         T_new = [];
%         g_pi_i = g(pi_i, :);  % The orthogonalized vector of the selected user
%         
%         for k = T
%             if k ~= pi_i
%                 % Check semiorthogonality condition
%                 h_k = H(k, :);
%                 if abs(h_k * g_pi_i' / (norm(h_k) * norm(g_pi_i))) < alpha
%                     T_new = [T_new, k];  % Keep user k in the set if semiorthogonal
%                 end
%             end
%         end
%         
%         T = T_new;  % Update the set of remaining users
%         i = i + 1;  % Increment the user selection index
%     end
%     ResultS0=S0;
% end



