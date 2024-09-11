%% Plot typical load curves for a cement plant

total_energy_baseline = [];

index_day = 5;

%% Machine learning methods

load("ml_results\predict_MLP_20240828_baseline.mat");
E_inverse_days = predict_y;

total_energy_baseline = [total_energy_baseline, reshape(E_inverse_days(:, index_day), 24, 1)];
total_energy_baseline(18) = 0;

load("ml_results\predict_LSTM_20240828_baseline.mat");
E_inverse_days = predict_y;
total_energy_baseline = [total_energy_baseline, reshape(E_inverse_days(:, index_day), 24, 1)];

load("ml_results\predict_SVR_20240828_baseline.mat");
E_inverse_days = y_predict;
total_energy_baseline = [total_energy_baseline, reshape(E_inverse_days(:, index_day), 24, 1)];

%% Proposed method
NOFSTAGES = 5;
load('test_Golmo_gen_4stages_120.mat');
cal_rmse_test_baseline;
total_energy_baseline = [total_energy_baseline, reshape(E_inverse_days(:, index_day), 24, 1)];

% True value
load("..\data_prepare\dataset_cement.mat");
total_energy_baseline = [total_energy_baseline, reshape(E_primal_days_test_baseline(:, index_day), 24, 1)];

%% Plot

linewidth = 1;
plot(1:24, total_energy_baseline(:, 5), "-oblack", 'linewidth', linewidth); hold on;
plot(1:24, total_energy_baseline(:, 1), "-->m", 'linewidth', linewidth); hold on;
plot(1:24, total_energy_baseline(:, 2), "--<b", 'linewidth', linewidth); hold on;
plot(1:24, total_energy_baseline(:, 3), "--xg", 'linewidth', linewidth); hold on;
plot(1:24, total_energy_baseline(:, 4), "--*r", 'linewidth', linewidth); hold on;

legend('True value', 'MLP', 'LSTM', 'SVR', 'PSI', ...    
    'fontsize', 13.5, ...
    'Location', 'SouthWest', ...
    'Orientation', 'vertical', ...
    'FontName', 'Times New Roman'); 

% Set figure parameters
x1 = xlabel('Hour', 'FontSize', 13.5, 'FontName', 'Times New Roman', 'FontWeight', 'bold');          
y1 = ylabel('Energy Consumption (MWh)', 'FontSize', 13.5, 'FontName', 'Times New Roman', 'FontWeight', 'bold');

% Figure size
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% Axis properties
ax = gca;
ax.XLim = [0, 25];     
ax.YLim = [0, 40];     
  
% Font and size
ax.FontSize = 13.5;

% Set ticks
ax.XTick = [1:24];

% Adjust labels
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [18, 10]);

saveas(gcf, 'typical_load_cement.pdf');
