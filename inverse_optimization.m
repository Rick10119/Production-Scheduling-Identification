%% Fitting Load Model Parameters based on Historical Electricity Data and Prices

NOFMACHINES = length(g);

% Variable naming and initialization
add_varDef_and_initVal;

for idx_itr = 0:210 % 10 * NOFDAYS
    % Solve the inverse problem for the idx_day day
    idx_day = mod(idx_itr, NOFDAYS) + 1;

    % Read price and electricity consumption information for the day
    Price = Price_days_train(:, idx_day);
    E_primal = E_primal_days_train(:, idx_day);

    %% Inverse problem constraints
    % In the inverse optimization problem to infer factory production model parameters based on meter data, add constraints from the original problem, dual problem constraints (including strong duality conditions)

Constraints = [];

% Dual problem variables and constraints
add_dual_constraints;
% Add dual constraints
Constraints = [Constraints, Constraints_dual];

% Original problem variables and constraints
add_primal_constraints;
% Add original problem constraints
Constraints = [Constraints, Constraints_primal];

% Equality of objective function values (only need the dual function and original function values to be equal, no need to be equal to real data)
Constraints = [Constraints, g_dual == Z_primal];

% Prior constraints
add_grid_priori;
Constraints = [Constraints, Constraints_priori];

    %% Inverse Problem Objective Function

    Z = sum(sum((P_max_td - P_max_ref).^2)) ...
        + sum(sum((S_0_td - S_0_ref).^2)) ...
        + sum(sum((S_tar_td - S_tar_ref).^2)) ...
        + sum(sum((S_max_td - S_max_ref).^2));

    % New loss function part for faster convergence
    J_theta = sum((P * ones(NOFMACHINES, 1) * delta_t - E_primal).^2);

    % Learning rate gradually decreases (adaptive)
    if (idx_itr > 3 * NOFDAYS) && isAdapt == 0
        isAdapt = 1;
        idx_itr_Adapt = idx_itr;
    end

    % If adaptation has started, reduce the weight of J_theta
    if isAdapt
        alpha = (1 / (idx_itr - idx_itr_Adapt + 1))^(0.5);
    else
        alpha = 1;
    end

    % First loop does not need to consider ref values
    if idx_itr <= NOFDAYS
        Z = 1e3;
    end

    Z_total = alpha * J_theta + Z;

    %% Solve

    % Set solving time
    TimeLimit = 1;
    ops = sdpsettings('debug', 1, 'solver', 'gurobi', ...
        'verbose', 0, ...
        'gurobi.NonConvex', 2, ...
        'allownonconvex', 1, ...
        'gurobi.TimeLimit', TimeLimit, 'usex0', 1);
    ops.gurobi.TuneTimeLimit = TimeLimit;
    sol = optimize(Constraints, Z_total, ops);

    disp("Iteration " + idx_itr + "; Training Loss Z: " + value(Z) + "; Training Loss J_theta: " + value(J_theta))

    % Record loss functions
    result_Z = [result_Z; value(Z)];
    result_J_theta = [result_J_theta; value(J_theta)];

    % Record iteration process
    result_S_tar = [result_S_tar; value(S_tar_td)];
    result_S_max = [result_S_max; value(S_max_td)];
    result_P_max = [result_P_max; value(P_max_td)];
    result_S_0 = [result_S_0; value(S_0_td)];
    result_g = [result_g; value(g_td)];

    if idx_itr > NOFDAYS
        S_tar_ref = mean(result_S_tar(end - NOFDAYS + 1 : end, :));
        P_max_ref = mean(result_P_max(end - NOFDAYS + 1 : end, :));
        S_max_ref = mean(result_S_max(end - NOFDAYS + 1 : end, :));
        S_0_ref = mean(result_S_0(end - NOFDAYS + 1 : end, :));
        g_ref = mean(result_g(end - NOFDAYS + 1 : end, :));
    else
        S_tar_ref = value(S_tar_td);
        P_max_ref = value(P_max_td);
        S_max_ref = value(S_max_td);
        S_0_ref = value(S_0_td);
        g_ref = value(g_td);
    end

    % Convergence criterion: change in loss function over the past NOFDAYS period
    err = 1e-2;
    if idx_itr > NOFDAYS && mean(abs(result_Z(end - NOFDAYS + 1 : end))) < err
        break;
    end
end
