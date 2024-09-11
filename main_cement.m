%% Main Program (Cement Plant)
clc; clear;

% Load data, electricity consumption in each time period
load("data_prepare/dataset_cement.mat"); % Cement data from Golmo_2020

% Original machine parameters (g)
filename = "data_prepare/load_parameters_Golmo_milp.xlsx";
B = xlsread(filename);
% Material production coefficient
g = B(:, 3)' ./ B(:, 4)';
NOFSTAGES = length(g);
NOFMECHINES_original = length(g);
idx_bottleneck = 2; % Bottleneck stage index (although not used)

% Inverse optimization
inverse_optimization;

save("results/test_Golmo_gen_" + 4 + "stages_120.mat");

yalmip('clear');
