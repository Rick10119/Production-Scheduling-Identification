%% STN model code implementation (including objective function and solving process)
% Parameters: load_parameter (read from Excel in the upper-level code)
% Input: External electricity prices (read in the upper-level code)
% Output: Optimal solutions for variables in the STN model
% Detailed model reference: lu_Data-driven_2021: R. Lu, R. Bai, Y. Huang, Y. Li, J. Jiang, and Y. Ding, "Data-driven real-time price-based demand response for industrial facilities energy management,” Appl. Energy, vol. 283, p. 116291, Feb. 2021.

%% Other parameters

NOFMACHINES = size(load_parameter, 1);
NOFINTERVALS = 24;
NOFPOINTS = (size(load_parameter, 2) - 1) / 2;

%% Variable Setup

% Machine operating states
I_hnp = binvar(NOFPOINTS, NOFMACHINES, NOFINTERVALS, 'full');

% Machine energy consumption
E_hn = sdpvar(NOFMACHINES, NOFINTERVALS, 'full');

% Material quantity (0 time interval for initial value, set to 0, followed by values at time intervals 1-24)
S_hn = sdpvar(NOFMACHINES, NOFINTERVALS + 1, 'full');

%% Constraints
Constraints = [];

% Unique operating states (1)
temp = reshape(sum(I_hnp),  NOFMACHINES, NOFINTERVALS);
Constraints = [Constraints, temp == ones(NOFMACHINES, NOFINTERVALS)];

% Energy consumption decomposition constraint (2)
temp = reshape(sum(I_hnp .* repmat(e_np', 1, 1, 24)), NOFMACHINES, NOFINTERVALS);
Constraints = [Constraints, E_hn == temp];

% Material change constraints (5, 6, 7)
% Initial value given for the first time interval
Constraints = [Constraints, S_hn(:, 1) == S_0];
% Subsequent time intervals
temp = reshape(sum(I_hnp .* repmat(g_np', 1, 1, 24)), NOFMACHINES, NOFINTERVALS);
% Non-terminal intervals
Constraints = [Constraints, S_hn(1 : end-1, 2 : end) - S_hn(1 : end-1, 1 : end - 1) - ...
    temp(1 : end-1, 1 : end) + temp(2 : end, 1 : end) == 0];
% Terminal intervals (note the dimension difference between P and S)
Constraints = [Constraints, S_hn(end, 2 : end) - S_hn(end, 1 : end-1) - ...
    temp(end, 1 : end) == 0];

% Material storage constraints (first and last intervals can be ignored)
Constraints = [Constraints, - S_hn <= 0];

Constraints = [Constraints, S_hn <= repmat(S_max, 1, NOFINTERVALS + 1)];

% Material target (end time interval)
Constraints = [Constraints, S_0 + S_tar - S_hn(:, end) <= 0];

%% Objective Function
Z_primal = sum(E_hn) * Price;

%% Solve
ops = sdpsettings('debug',1,'solver','GUROBI','savesolveroutput',1,'savesolverinput',1);

sol = optimize(Constraints, Z_primal, ops);

%% Record variable values
P_val = value(E_hn);
S_val = value(S_hn);
I_val = value(I_hnp);
