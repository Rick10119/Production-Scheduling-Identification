%% Generate multi-day data for inverse optimization in a steel powder plant using an existing MILP model from literature
% Assuming that the internal parameters are the same for each day, but the external electricity prices vary, leading to different production schedules.

%% Referencing the paper by Lu-2021-data-driven
filename = "load_parameters_Lu_milp.xlsx";

% Using data from Lu-2021 for validation
load_parameter = xlsread(filename);

% Energy consumption coefficients
e_np =  load_parameter(:, [2, 4, 6]);

% Material production coefficients
g_np =  load_parameter(:, [1, 3, 5]);

% Material maximum/minimum values (0), raw materials are generally not limited
S_max = load_parameter(:, 7);
S_max(end) = 400;

% Initial material values
S_0 = 0.5 * S_max;
S_0(end) = 0;

% Material target values (change)
S_tar = zeros(size(S_max));
S_tar(end) = 10 * 24; % The bottleneck stage needs to operate for 24 hours.

%% Read prices (July)
data_price;

%% Generate electricity usage data

E_primal_days = [];

for idx_day = 1 : length(Price_days)
    Price = Price_days(:, idx_day);

    load_primal_problem_milp;
    
    P_val = value(E_hn);
    % Record electricity consumption
    E_primal = ones(1, NOFMACHINES) * P_val;
    E_primal = E_primal';
    
    E_primal_days = [E_primal_days, E_primal];
end

%% Differentiate training and cross-validation sets

% First 21 days for training, last 10 days for cross-validation
E_primal_days_train = E_primal_days(:, 1 : 21);
E_primal_days_cv = E_primal_days(:, 22 : end);
Price_days_train = Price_days(:, 1 : 21);
Price_days_cv = Price_days(:, 22 : end);

%% August data for testing set (load baseline)
% Read parameters
parameter_Lu_milp;

% Read prices
data_price_2;

Price_days_test_baseline = Price_days(:, 1 : 10);

% Generate electricity usage data

E_primal_days_test_baseline = [];

for idx_day = 1 : size(Price_days_test_baseline, 2)
    Price = Price_days_test_baseline(:, idx_day);

    load_primal_problem_milp;
    
    P_val = value(E_hn);
    % Record electricity consumption
    E_primal = ones(1, NOFMACHINES) * P_val;
    E_primal = E_primal';
    
    E_primal_days_test_baseline = [E_primal_days_test_baseline, E_primal];
end

%% Save

save("dataset_steelpowder.mat", "E_primal_days_train", "Price_days_train", ...
    "E_primal_days_cv", "Price_days_cv", ...
    "E_primal_days_test_baseline", "Price_days_test_baseline");
