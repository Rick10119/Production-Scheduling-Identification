%% Calculate test set errors for different methods

total_table = [];

%% Machine Learning Methods

% MLP
load("ml_results\predict_MLP_20240828_baseline.mat"); E_inverse_days = predict_y;
cal_rmse_ml_cement;% cement

load("ml_results\predict_MLP_20230226_baseline.mat"); E_inverse_days = predict_y;
cal_rmse_ml_steelpowder;% steelpowder

total_table = [total_table; rmse_cement; rmse_steelpowder];

% LSTM
load("ml_results\predict_LSTM_20240828_baseline.mat"); E_inverse_days = predict_y;
cal_rmse_ml_cement;

load("ml_results\predict_LSTM_20230226_baseline.mat"); E_inverse_days = predict_y;
cal_rmse_ml_steelpowder;

total_table = [total_table; rmse_cement; rmse_steelpowder];

% SVR
load("ml_results\predict_svr_20240828_baseline.mat"); E_inverse_days = y_predict;
cal_rmse_ml_cement;

load("ml_results\predict_SVR_20230226_baseline.mat"); E_inverse_days = y_predict;
cal_rmse_ml_steelpowder;

total_table = [total_table; rmse_cement; rmse_steelpowder];

%% Proposed Methods
% Steel powder
NOFSTAGES = 5;
load("0227_no_assumption_e/test_Lu_gen_" + 2*NOFSTAGES + "stages_120.mat");
load("..\data_prepare\dataset_steelpowder.mat");
cal_rmse_test;
maxE_steel = max(E_primal);
rmse_steel = rmse_baseline;

% Cement plant
load('test_Golmo_gen_4stages_120.mat');
load("..\data_prepare\dataset_cement.mat");
cal_rmse_test;
maxE_cement = max(E_primal);
rmse_cement = rmse_baseline;
total_table = [rmse_cement; rmse_steel; total_table];

% Normalize
total_table(1:2:end, :) = total_table(1:2:end, :) / maxE_cement;
total_table(2:2:end, :) = total_table(2:2:end, :) / maxE_steel;

save("total_table_methods.mat", 'total_table');
