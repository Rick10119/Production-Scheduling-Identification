%% Variable Definition and Initialization

% Number of intervals
NOFINTERVALS = 24;
% Length of each interval
delta_t = 24 / NOFINTERVALS;
% Whether to start adaptation
isAdapt = 0;
idx_itr_Adapt = 0;

%% Variable Setup

% Machine parameters
P_max_td = sdpvar(1, NOFMACHINES, 'full');
S_0_td = sdpvar(1, NOFMACHINES + 1, 'full');
S_tar_td = sdpvar(1, NOFMACHINES + 1, 'full');
S_max_td = sdpvar(1, NOFMACHINES + 1, 'full');

% Other electricity consumption
P_0 = zeros(NOFINTERVALS, 1);
% Machine power
P = sdpvar(NOFINTERVALS, NOFMACHINES, 'full');
% Material quantity (0 interval is the initial value, set to 0, the following intervals are the values at the end of intervals 1-24) with a dimension one more than the number of machines
S = sdpvar(NOFINTERVALS + 1, NOFMACHINES + 1, 'full');

% Dual variables
mu_P_max = sdpvar(NOFINTERVALS, NOFMACHINES, 'full');
mu_P_min = sdpvar(NOFINTERVALS, NOFMACHINES, 'full');
mu_S_T = sdpvar(1, NOFMACHINES + 1, 'full');
lambda_S = sdpvar(NOFINTERVALS + 1, NOFMACHINES + 1, 'full'); % 0 ~ T
mu_S_max = sdpvar(NOFINTERVALS + 1, NOFMACHINES + 1, 'full');
mu_S_min = sdpvar(NOFINTERVALS + 1, NOFMACHINES + 1, 'full');

% Some known information (commented out to indicate to be solved (already defined as variables))
g_init = g;
g_td = g;

%% Iterative Parameter Solving

% Number of days in the data
NOFDAYS = size(E_primal_days_train, 2);

% Maximum electricity consumption in the data (used for prior determination of the sum of P_max)
max_E_t = max(max(E_primal_days_train));

% Initialization
result_S_tar = [];
result_S_max = [];
result_P_max = [];
result_S_0 = [];
result_g = [];
result_Z = 1e3;
result_J_theta = 1e3;

% Initialization, estimated value is 0
S_tar_ref = zeros(1, NOFMACHINES + 1);
P_max_ref = zeros(1, NOFMACHINES);
S_max_ref = zeros(1, NOFMACHINES + 1);
S_0_ref = zeros(1, NOFMACHINES + 1);
g_ref = zeros(1, NOFMACHINES);
