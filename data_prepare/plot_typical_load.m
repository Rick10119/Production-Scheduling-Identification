%% Illustrative Price and Energy Consumption at Various Stages of a Steel Powder Plant on a Certain Day

% Load parameters
parameter_Lu_milp;

% Load prices (August)
data_price_2;

% First 10 days as the test set
Price_days_test = Price_days(:, 1 : 10);

% Generate electricity usage data
idx_day = 5;

Price = Price_days_test(:, idx_day);

load_primal_problem_milp;

%% Plot
linewidth = 2;

% Actual energy consumption
bar(P_val', 0.4,'stacked','DisplayName','P_val');
hold on;

y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

yyaxis right
plot(1:24, 1e3 * Price, "-.g", 'linewidth', linewidth);

ax = gca;
ax.YLim = [0, 300];
ax.YColor = 'black';

legend('Blender','Classifier','Crusher', ...
    'Classifier', ...
    'Crusher', ...
    'Separator', ...
    'Dryer', ...
    'Dehydrator', ...
    'Atomizer', ...
    'Reduction', ...
    'Price', ...
    'fontsize',13.5, ...
    'Location','EastOutside', ...
    'Orientation','vertical', ...
    'FontName', 'Times New Roman');

x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
y1 = ylabel('Electricity Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

% Figure size
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.6 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% Axis properties
ax = gca;
ax.XLim = [0, 25];
ax.FontSize = 13.5;
ax.XTick = [1:24];
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 7.8]);

saveas(gcf,'typical_load.pdf');
