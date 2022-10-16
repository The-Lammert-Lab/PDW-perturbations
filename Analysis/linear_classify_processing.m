% linear_classify_processing
% 
% Collect linear classification results into a struct of tables
% 
% OUTPUTS:
%   uitables with classification results for each data set
% 
% See also:
% linear_classify

filenames = {'../Data/Data_n50000g0.014p0.5d03-Jun22/metrics.csv',...
    '../Data/Data_n50000g0.016p0.5d04-Jun22/metrics.csv',...
    '../Data/Data_n50000g0.019p0.5d05-Jun22/metrics.csv'};

gam = {'g14', 'g16', 'g19'};

for i = 1:length(filenames)
    results = linear_classify(filenames{i});

    % Convert struct to table
    tab = structfun(@(x) struct2table(x),results,'UniformOutput',false);
    metrics = fieldnames(tab);

    % Reset rownames variable each loop
    clear rownames
    
    % Initial table for subsequent joins 
    % Loop to avoid issues with a nested struct
    count = 0;
    for ii = 1:length(metrics)
        count = count + 1;
        subnames = fieldnames(results.(metrics{ii}));
        if ~isstruct(tab.(metrics{ii}).(subnames{1}))
            T = tab.(metrics{ii});
            T.Properties.RowNames = metrics(count);
            % Remove this one from the subsequent joins
            metrics = metrics(1:end ~= count);
            break
        end
    end
    
    % Join tables and update row names
    for ii = 1:length(metrics)
        subnames = tab.(metrics{ii}).Properties.VariableNames;
        % ST and SL are nested structs
        if isstruct(tab.(metrics{ii}).(subnames{1}))
            for jj = 1:length(subnames)
                % Nested struct not converted initially
                T_new = struct2table(tab.(metrics{ii}).(subnames{jj}));

                % Save table organization and join
                currnames = T.Properties.RowNames; 
                [T,ileft,iright] = outerjoin(T,T_new,'MergeKeys',true);

                % Match metric names properly
                rownames(ileft > 0) = currnames;
                rownames(iright > 0) = {strcat(metrics{ii}, '_', subnames{jj})};
                T.Properties.RowNames = rownames;
            end
    
        else
            % Save table organization and join
            currnames = T.Properties.RowNames;
            [T,ileft,iright] = outerjoin(T,tab.(metrics{ii}),'MergeKeys',true);

            % Match metric names properly
            rownames(ileft > 0) = currnames;
            rownames(iright > 0) = metrics(ii);
            T.Properties.RowNames = rownames;
        end
    end
    
    T = sortrows(T,'RowNames');

    % Store data
    allResults.(gam{i}) = T;

    % Visualize data
    figure('NumberTitle', 'off', 'Name', gam{i})
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
        'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

end