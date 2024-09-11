%% Given a model, run results on training and testing sets

%% Run the forward problem with fitted parameters
% (g, P_max, S_max/0/tar)
S_tar = result_S_tar(end, :);
S_max = result_S_max(end, :);
P_max = result_P_max(end, :);
S_0 = result_S_0(end, :);
g = result_g(end, :);

% Forward problem
J_P_test = []; % Power error
J_baseline_test = []; % Load baseline error

%% Test set errors, load baseline error

NOFDAYS = size(E_primal_days_test_baseline, 2);
Price_days = Price_days_test_baseline;
E_primal_days = E_primal_days_test_baseline;

E_inverse_days = [];

for idx_day = 1:NOFDAYS
    % Training set prices
    Price = Price_days(:, idx_day);
    % Forward problem
    load_primal_problem;

    % Calculate differences
    P_val = value(P);
    S_val = value(S);
    E_inverse = P_val * ones(NOFMACHINES, 1) * delta_t;
    E_inverse_days = [E_inverse_days, E_inverse];

    % Energy consumption of the original problem
    E_primal = E_primal_days(:, idx_day);

    J_baseline_test = [J_baseline_test, mean(mean((E_inverse - E_primal).^2))];
end

% Calculate errors
% Daily relative error
rmse_baseline = sqrt(((J_baseline_test)));
