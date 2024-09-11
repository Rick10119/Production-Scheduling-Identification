%% Test Main Program
clc; clear;

% Load dataset_steelpowder data, electricity consumption in each time period
load("data_prepare/dataset_steelpowder.mat");

% Differentiate models based on the number of machines, 1.5 and 2.5 represent two ways of aggregating 2 stages
for NOFSTAGES = [2.5 3 4 5 6 7 8 9 10]
    
    % Read stage data
    [g, idx_bottleneck] = aggregate_get_g(NOFSTAGES);
    
    % Inverse optimization
    inverse_optimization;
    
    % Save results
    save("results/test_Lu_gen_" + 2 * NOFSTAGES + "stages_120.mat");
    
    yalmip('clear');
    
end
