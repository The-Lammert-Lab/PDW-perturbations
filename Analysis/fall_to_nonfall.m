% fall_to_nonfall
% 
% Calculate fall to non-fall ratio from 1/0 data. 
% Visualize in table. 

%% Load data
% Path to folders with data (n must be the same)
foldernames = {'../Data/Data_n50000g0.014p0.5d03-Jun22/', ...
    '../Data/Data_n50000g0.016p0.5d04-Jun22/', ...
    '../Data/Data_n50000g0.019p0.5d05-Jun22/'};

n = str2double(char(extractBetween(foldernames{1},'n','g')));

y = NaN(n,length(foldernames));

% Populate y
for i = 1:length(foldernames)
    y(:,i) = load(strcat(foldernames{i},'outcomes.csv'));
end

%% Calculate
% 0 = non-fall, 1 = fall
nonfalls = zeros(size(y,2),1);
falls = zeros(size(y,2),1);

for i = 1:size(y,2)
    nonfalls(i) = sum(y(:,i)==0);
    falls(i) = sum(y(:,i)==1);
end

ratio = falls ./ nonfalls;

%% Table
% Rownames
fnf = repmat({'fall:nonfall '},[length(foldernames),1]);
gam = strcat(fnf, char(extractBetween(foldernames,'g','p')));

T = table(ratio,'RowNames',gam);

figure
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
