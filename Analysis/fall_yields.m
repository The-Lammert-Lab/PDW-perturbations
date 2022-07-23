% fall_yields
% 
% Get averages and mins of falls and non falls based on percent yields

ratio = load('../Data/Data NEWFALL (reviewer edits)/Gaitcycles combined n20000g0.014_0.019p0.02_0.5/fallratio1419NEWFALL.csv');
yield = load('../Data/Data NEWFALL (reviewer edits)/Gaitcycles combined n20000g0.014_0.019p0.02_0.5/percentYield1419NEWFALL.csv');

falls = ratio ./ (ratio + 1);
nonfalls = 1 - falls;

percentFalls = falls.*yield;
percentNonfalls = nonfalls.*yield;

disp(['average % nonfalls: ',num2str(mean(percentNonfalls,'all'))])

disp(['min % of nonfalls: ',num2str(min(percentNonfalls,[],'all'))])

disp(['average % falls: ',num2str(mean(percentFalls,'all'))])

disp(['min % of falls: ',num2str(min(percentFalls,[],'all'))])



