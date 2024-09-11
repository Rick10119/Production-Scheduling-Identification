%% Read PJM2022 August electricity price data

%% Market prices and other parameters
% Read system energy price data
% Time interval length, 1 hour
delta_t = 1;
day_price = 1; % Selected number of days
hour_init = 1; % Starting from the first time slot of the day
NOFSLOTS = 24 / delta_t;

% Read prices for all days of this month (August)
Price_days = [];
for day_price = 1 : 10

    start_row = (day_price-1) * 24 + hour_init + 1; % Starting row
    filename = 'rt_hrl_lmps_202208.xlsx';
    sheet = 'sheet1'; % Sheet name
    xlRange = "I" + start_row + ":I" + (start_row + NOFSLOTS - 1); % Range
    Price = xlsread(filename, sheet, xlRange); % Capacity price, mileage price
    Price_days = [Price_days, Price];

end
clear Price filename sheet xlRange start_row hour_init day_price NOFSLOTS delta_t

% Convert prices to $/kWh
Price_days = Price_days * 1e-3;
