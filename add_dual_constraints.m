%% Dual Problem Constraints and Prior Assumptions
Constraints_dual = [];

% Constraints corresponding to P_t_i
Constraints_dual = [Constraints_dual, repmat(Price * delta_t, 1, NOFMACHINES) - mu_P_min + mu_P_max ...
    + lambda_S(2:end, 1:NOFMACHINES) .* repmat(g_td, NOFINTERVALS, 1) ...
    - lambda_S(2:end, 2:NOFMACHINES+1) .* repmat(g_td, NOFINTERVALS, 1) == 0];

% Constraints corresponding to S_t_i (t ~= T)
Constraints_dual = [Constraints_dual, lambda_S(1:end-1, :) - lambda_S(2:end, :) ...
    - mu_S_min(1:end-1, :) + mu_S_max(1:end-1, :) == 0];
% Constraints corresponding to S_t_i (t = T)
Constraints_dual = [Constraints_dual, -mu_S_T + lambda_S(end, :) ...
    - mu_S_min(end, :) + mu_S_max(end, :) == 0];

% Non-negativity of dual variables (lambda does not need to be non-negative)
Constraints_dual = [Constraints_dual, mu_P_max >= 0];
Constraints_dual = [Constraints_dual, mu_P_min >= 0];
Constraints_dual = [Constraints_dual, mu_S_T >= 0];
Constraints_dual = [Constraints_dual, mu_S_max >= 0];
Constraints_dual = [Constraints_dual, mu_S_min >= 0];

% Dual Problem Objective Function
g_dual = -sum(mu_P_max * P_max_td') ...
    + mu_S_T * (S_0_td + S_tar_td)' ...
    - sum(mu_S_max * S_max_td') ...
    - sum(lambda_S(1, :) * S_0_td');
