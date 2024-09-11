% boxplot: run plot_rmse_methods first

h = boxplot(total_table' * 100);

% Set colors for different results
colors = ['r', 'b']; % r for red, b for blue
for i = 1:size(h, 2)
    color = colors(mod(i - 1, length(colors)) + 1); % Cycle through colors
    set(h(:, i), 'Color', color);
end

% Axis properties
ax = gca;
ax.XLim = [0, 9];    
ax.YLim = [0, 40];   
  
set(gca, "YGrid", "on");

% Set ticks
ax.XTick = [1.5:2:7.5];

% Set x-axis labels
xticklabels({'PSI', 'MLP', 'LSTM', 'SVR'});

% Font settings
ax.FontSize = 13.5;
ax.FontName = 'Times New Roman';

hold on
h1 = plot(NaN, NaN, 'r-');
h2 = plot(NaN, NaN, 'b-');
legend([h1, h2], "Cement plant", "Steel powder manufactory",...
    'fontsize', 13.5, ...
    'Orientation', 'vertical', ...
    'FontName', 'Times New Roman'); 

% Set y-axis label and title
ylabel('Normalized RMSE (%)', 'FontSize', 13.5, 'FontName', 'Times New Roman', 'FontWeight', 'bold');

% Figure size
figureUnits = 'centimeters';
figureWidth = 10;
figureHeight = figureWidth * 4 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

set(gcf, 'PaperSize', [10, 10]);

saveas(gcf, 'accuracy.pdf');
