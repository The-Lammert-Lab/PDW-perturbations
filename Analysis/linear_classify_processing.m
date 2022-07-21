% linear_classify_processing
% 
% Collect linear classification results into a struct of tables
% 
% OUTPUTS:
%   uitables with classification results for each data set
% 
% See also:
% linear_classify

filenames = {'../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/metrics.csv',...
    '../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv',...
    '../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/metrics.csv'};

gam = {'g14', 'g16', 'g19'};

for i = 1:length(filenames)
    results = linear_classify(filenames{i});

    % Convert struct to table
    tab = structfun(@(x) struct2table(x),results,'UniformOutput',false);
    metrics = fieldnames(tab)';

    % Reset rownames variable each loop
    clear rownames
    
    % Initial table for subsequent joins 
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
    
    % Join tables and update row names
    for ii = metrics
        subnames = tab.(ii{1}).Properties.VariableNames;
        % ST and SL are nested structs
        if isstruct(tab.(ii{1}).(subnames{1}))
            for jj = subnames
                T_new = struct2table(tab.(ii{1}).(jj{1}));
                currnames = T.Properties.RowNames; 
                [T,ileft,iright] = outerjoin(T,T_new,'MergeKeys',true);
                rownames(ileft > 0) = currnames;
                rownames(iright > 0) = {strcat(ii{1}, '_', jj{1})};
                T.Properties.RowNames = rownames;
            end
    
        else
            currnames = T.Properties.RowNames;
            [T,ileft,iright] = outerjoin(T,tab.(ii{1}),'MergeKeys',true);
            rownames(ileft > 0) = currnames;
            rownames(iright > 0) = ii;
            T.Properties.RowNames = rownames;
        end
    end
    
    % Store data
    allResults.(gam{i}) = T;

    % Visualize data
    figure('NumberTitle', 'off', 'Name', gam{i})
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
        'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

end