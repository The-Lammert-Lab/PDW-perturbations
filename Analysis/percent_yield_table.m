%%% Make table of percent yields

M = load('../Data/Data n50000g0.014p0.32d13-May22/percentYield.csv');

M(1,2) = load('../Data/Data n50000g0.014p0.32d21-May22 - NEWFALL/percentYield.csv');

M(2,1) = load('../Data/Data n50000g0.016p0.32d14-May22/percentYield.csv');

M(2,2) = load('../Data/Data n50000g0.016p0.32d22-May22 - NEWFALL/percentYield.csv');

M(3,1) = load('../Data/Data n50000g0.019p0.32d20-May22/percentYield.csv');

M(3,2) = load('../Data/Data n50000g0.019p0.32d23-May22 - NEWFALL/percentYield.csv');


gam = {'Percent yield at 0.014';'Percent yield at 0.016';'Percent yield at 0.019'};

T = table(M(:,1),M(:,2),'RowNames',gam);

T = renamevars(T,["Var1","Var2"],...
    ["Old fall criteria", "New fall criteria"]);

figure
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

