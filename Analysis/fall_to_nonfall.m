% fall_to_nonfall
% 
% Calculate fall to non-fall ratio from 1/0 data. 
% Visualize in table. 

M = load('../Data/Data n50000g0.014p0.5d03-Jun22/metrics.csv');
y = M(:,1);

M = load('../Data/Data n50000g0.016p0.5d04-Jun22/metrics.csv');
y(:,end+1) = M(:,1);

M = load('../Data/Data n50000g0.019p0.5d05-Jun22/metrics.csv');
y(:,end+1) = M(:,1);

% 0 = non-fall, 1 = fall

nonfalls = zeros(size(y,2),1);
falls = zeros(size(y,2),1);

for i = 1:size(y,2)
    nonfalls(i) = sum(y(:,i)==0);
    falls(i) = sum(y(:,i)==1);
end

ratio = falls ./ nonfalls;

gam = {'fall:nonfall 0.014';'fall:nonfall 0.016';'fall:nonfall 0.019'};

T = table(ratio,'RowNames',gam);

figure
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
