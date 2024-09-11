%% Add Constraints from the Original Problem to the Inverse Problem, similar to load_primal_problem
%% Only some parameters from the original problem are now variables

%% Constraints
Constraints_primal = [];

% Power range constraints
Constraints_primal = [Constraints_primal, -P <= 0];
Constraints_primal = [Constraints_primal, P <= repmat(P_max_td, NOFINTERVALS, 1)];

% Material target (end of interval)
Constraints_primal = [Constraints_primal, S_0_td + S_tar_td - S(end, :) <= 0];

% Material balance constraints (per interval)
% First interval, given initial value
Constraints_primal = [Constraints_primal, S(1, :) == S_0_td];
% Subsequent intervals
% Intermediate steps (note the dimension difference between P and S by 1)
Constraints_primal = [Constraints_primal, S(2:end, 2:end-1) - S(1:end-1, 2:end-1) - ...
    P(:, 1:end-1) .* repmat(g_td(1:end-1), NOFINTERVALS, 1) + ...
    P(:, 2:end) .* repmat(g_td(2:end), NOFINTERVALS, 1) == 0];

% First step (note the dimension difference between P and S by 1)
Constraints_primal = [Constraints_primal, S(2:end, 1) - S(1:end-1, 1) ...
    + P(:, 1) .* repmat(g_td(1), NOFINTERVALS, 1) == 0];

% Last step (note the dimension difference between P and S by 1)
Constraints_primal = [Constraints_primal, S(2:end, end) - S(1:end-1, end) - ...
    P(:, end) .* repmat(g_td(end), NOFINTERVALS, 1) == 0];

% Material storage constraints (can ignore the first and last)
Constraints_primal = [Constraints_primal, -S <= 0];

Constraints_primal = [Constraints_primal, S <= repmat(S_max_td, NOFINTERVALS + 1, 1)];

%% Objective Function
Z_primal = Price' * (P * ones(NOFMACHINES, 1)) * delta_t;
