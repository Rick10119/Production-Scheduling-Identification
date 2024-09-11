%% Linear Programming Problem Solved by Industrial Users for Production Scheduling per Hour (based on mSTN model)

% Set parameters
% (g, P_max, S_max/0/tar)
% Load parameters
% load("data_prepare/primal_parameter_Lu.mat");
% load("data_prepare/primal_parameter_Lu_agg.mat");

%% Example Parameters

% Number of intervals
NOFINTERVALS = 24;

% Length of each interval
delta_t = 24 / NOFINTERVALS;

% Number of machines
NOFMACHINES = length(g);

%% Variable Setup
% Other electricity consumption
P_0 = zeros(NOFINTERVALS, 1);

%% Variable Setup
% if ~exist('P')
% Machine power
P = sdpvar(NOFINTERVALS, NOFMACHINES, 'full');

% Material quantity (0 interval is the initial value, set to 0, the following intervals are the values at the end of intervals 1-24) with a dimension one more than the number of machines
S = sdpvar(NOFINTERVALS + 1, NOFMACHINES + 1, 'full');

% Machine parameters
P_max_td = P_max;
g_td = g;
S_0_td = S_0;
S_tar_td = S_tar;
S_max_td = S_max;
S_max_td(end) = S_max_td(end) + 1;

% Original problem constraints
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

%% Solve
ops = sdpsettings('debug', 1, 'solver', 'gurobi', 'savesolveroutput', 1, 'savesolverinput', 1);

sol = optimize(Constraints_primal, Z_primal, ops);

%% Record Results
P_val = value(P);
S_val = value(S);
