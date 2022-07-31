% fall_yields
% 
% Get averages and mins of falls and non falls based on percent yields

%% Load data
filename = ['../Data/HeatmapData_n20000g0.016_0.019p0.02_0.5d01-Jun22/' ...
    'HeatmapProcessed_0.014_0.019_0.02_0.5.csv'];

full_data = readtable(filename);

% How many perturbations at each gamma. 
% Should always be the same so only need first value.
[pert_tot, ~] = find(diff(table2array(full_data(:,1))) ~= 0, 1, 'first');

% Get gamma values from table.
gam = unique(table2array(full_data(:,1)));

ratio = reshape(table2array(full_data(:,3)), [pert_tot, length(gam)]);
yield = reshape(table2array(full_data(:,4)), [pert_tot, length(gam)]);

%% Calculate
falls = ratio ./ (ratio + 1);
nonfalls = 1 - falls;

percentFalls = falls.*yield;
percentNonfalls = nonfalls.*yield;

%% Print
disp(['average % nonfalls: ',num2str(mean(percentNonfalls,'all')), '%'])

disp(['min % of nonfalls: ',num2str(min(percentNonfalls,[],'all')), '%'])

disp(['average % falls: ',num2str(mean(percentFalls,'all')), '%'])

disp(['min % of falls: ',num2str(min(percentFalls,[],'all')), '%'])