% % linear_table_clean_viz

filenames = {'../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/metrics.csv',...
    '../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv',...
    '../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/metrics.csv'};

gam = {'low', 'mid', 'high'};

for i = 1:length(filenames)
    results = linear_classify_clean(filenames{i});
    allResults.(gam{i}) = results;
end

