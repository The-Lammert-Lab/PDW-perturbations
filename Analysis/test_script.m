function T = test_script(results)

tab = structfun(@(x) struct2table(x),results,'UniformOutput',false);
metrics = fieldnames(tab)';

count = 0;
for ii = metrics
    count = count + 1;
    subnames = fieldnames(results.(ii{1}));
    if ~isstruct(tab.(ii{1}).(subnames{1}))
        T = tab.(ii{1});
        T.Properties.RowNames = metrics(count);
        metrics = metrics(1:end ~= count);
        break
    end
end

for ii = metrics
    subnames = tab.(ii{1}).Properties.VariableNames;
    if isstruct(tab.(ii{1}).(subnames{1}))
        for jj = subnames
            T_new = struct2table(tab.(ii{1}).(jj{1}));
            rownames = [T.Properties.RowNames; strcat(ii{1}, '_', jj{1})]; 
            T = outerjoin(T,T_new,'MergeKeys',true);
            T.Properties.RowNames = rownames;
        end

    else
        rownames = [T.Properties.RowNames; ii];
        T = outerjoin(T,tab.(ii{1}),'MergeKeys',true);
        T.Properties.RowNames = rownames;
    end
end

T

% filename = '../../Working folder copy (DO NOT DELETE -- HAS DATA)/Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv';