%% Input the number of stages and return the g values for each stage and the bottleneck stage number (for a steel powder plant)
function [g, idx_bottleneck] = aggregate_get_g(NOFMECHINES)

% Read original parameters
% Original machine parameters (g, P_max, S_max/0/tar)
filename = "load_parameters_Lu.xlsx";
B = xlsread(filename);
% Material production coefficients
g =  B(:, 7)';

NOFMECHINES_original = 10;

% Aggregate or combine some stages based on the number of stages
%% Split stages
if NOFMECHINES > NOFMECHINES_original
    % If the number of machines is greater than the actual number of machines, split the stage with the maximum Pmax (except for the bottleneck stage)
    % Manually specify the splitting order
    idx_disol = [1, 1, 3, 6, 13];
    idx_Key = [8, 9, 10, 11, 11];
    
    % Split stages
    for idx = 1 : NOFMECHINES - length(g)
        g(idx_disol(idx)) = 2 * g(idx_disol(idx));
        g = [g(1 : idx_disol(idx)), g(idx_disol(idx) : end)];
    end
    idx_bottleneck = idx_Key(NOFMECHINES - NOFMECHINES_original);
    % Bottleneck stage
end

%% 10 stages: unchanged
if NOFMECHINES == NOFMECHINES_original
    idx_bottleneck = 7;
end

%% Aggregate stages with 3 or more
if NOFMECHINES < NOFMECHINES_original && NOFMECHINES >= 3
    idx_agg = [10, 3, 4, 7, 4, 2, 2];
    idx_Key = [7, 6, 5, 5, 4, 3, 2];
    
    % Split stages
    for idx = 1 : NOFMECHINES_original - NOFMECHINES
        g(idx_agg(idx) - 1) = 1 / (1 / g(idx_agg(idx)) + 1 / g(idx_agg(idx) - 1));
        g = [g(1 : idx_agg(idx)-1), g(idx_agg(idx)+1 : end)];
    end
    idx_bottleneck = idx_Key(NOFMECHINES_original - NOFMECHINES);
    % Bottleneck stage
end

%% Aggregate stages to less than 3
if NOFMECHINES < 3
    [g, ~] = aggregate_get_g(3);
    
    switch NOFMECHINES
        case 2.5
            g(2) = 1 / (1 / g(2) + 1 / g(3));
            g = g(1 : 2);    
            idx_bottleneck = 2;
        case 1.5
            g(2) = 1 / (1 / g(2) + 1 / g(1));
            g = g(2 : 3);
            idx_bottleneck = 1;
        case 1
            g(2) = 1 / (1 / g(2) + 1 / g(3));
            g(2) = 1 / (1 / g(2) + 1 / g(1));
            g = g(2);
            idx_bottleneck = 1;
        otherwise
            disp('Input error')
    end
    
end
