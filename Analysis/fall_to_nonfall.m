%%% Calculate fall to non-fall ratio

M = load('../Data/Data n50000g0.014p0.32d13-May22/metrics.csv');
y = M(:,1);

M = load('../Data/Data n50000g0.014p0.32d21-May22 - NEWFALL/metrics.csv');
y(:,size(y,2)+1) = M(:,1);

M = load('../Data/Data n50000g0.016p0.32d14-May22/metrics.csv');
y(:,size(y,2)+1) = M(:,1);

M = load('../Data/Data n50000g0.016p0.32d22-May22 - NEWFALL/metrics.csv');
y(:,size(y,2)+1) = M(:,1);

M = load('../Data/Data n50000g0.019p0.32d20-May22/metrics.csv');
y(:,size(y,2)+1) = M(:,1);

M = load('../Data/Data n50000g0.019p0.32d23-May22 - NEWFALL/metrics.csv');
y(:,size(y,2)+1) = M(:,1);

% 0 = non-fall, 1 = fall

nonfalls = zeros(size(y,2),1);
falls = zeros(size(y,2),1);

for i = 1:size(y,2)
    nonfalls(i) = sum(y(:,i)==0);
    falls(i) = sum(y(:,i)==1);
end

ratio = falls ./ nonfalls;

gam = {'fall:nonfall 0.014';'fall:nonfall 0.016';'fall:nonfall 0.019'};

T = table(ratio(1:2:end),ratio(2:2:end),'RowNames',gam);

T = renamevars(T,["Var1","Var2"],...
    ["Old fall criteria", "New fall criteria"]);

figure
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);





