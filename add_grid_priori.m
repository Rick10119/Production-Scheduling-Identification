%% Prior Assumptions
M = 1e3; % Large number
Constraints_priori = [];
% Limit variable sizes
% Basic parameter constraints (when there are original problem constraints, non-negativity constraints may not be necessary)
Constraints_priori = [Constraints_priori, P_max_td <= M];
Constraints_priori = [Constraints_priori, g_td <= M];
Constraints_priori = [Constraints_priori, S_0_td <= M];
Constraints_priori = [Constraints_priori, S_max_td <= M];

% Dual variable constraints
Constraints_priori = [Constraints_priori, mu_P_max <= M];
Constraints_priori = [Constraints_priori, mu_P_min <= M];
Constraints_priori = [Constraints_priori, mu_S_T <= M];
Constraints_priori = [Constraints_priori, mu_S_max <= M];
Constraints_priori = [Constraints_priori, mu_S_min <= M];

% Material conservation assumption (middle interval target is 0, first and last are negative and positive)
Constraints_priori = [Constraints_priori, S_tar_td(2:end-1) == 0];
Constraints_priori = [Constraints_priori, S_tar_td(end) >= 0];
Constraints_priori = [Constraints_priori, S_tar_td(1) == -S_tar_td(end) - 100];

% Maximum power previously observed (in historical data on these days)
Constraints_priori = [Constraints_priori, P_max_td * ones(NOFMACHINES, 1) * delta_t == max_E_t];
