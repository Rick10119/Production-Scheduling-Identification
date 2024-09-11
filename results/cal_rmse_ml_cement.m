%% Calculate metrics for machine learning methods' results (% cement)

J_baseline_test = []; % Load baseline error
J_P_test = []; % Power error

% Power response error
load("..\data_prepare\dataset_cement.mat");

NOFDAYS = size(E_primal_days_test_baseline, 2);
Price_days = Price_days_test_baseline;
E_primal_days = E_primal_days_test_baseline;

for idx_day = 1:NOFDAYS
    % Training set prices
    Price = Price_days(:, idx_day);
    E_inverse = E_inverse_days(:, idx_day);
    
    % Energy consumption of the original problem
    E_primal = E_primal_days(:, idx_day);

    J_P_test = [J_P_test, mean(mean((E_inverse - E_primal).^2))];
end

% Calculate errors
% Mean relative deviation

% rmse_cement = sqrt((mean(J_P_test)))

% Daily relative errors
rmse_cement = sqrt(((J_P_test)));
