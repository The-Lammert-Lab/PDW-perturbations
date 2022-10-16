% linear_classify
% 
% Perform linear classification on data from PDW simulations.
% 
% ARGUMENTS:
% 
%   filename: char, the path to the `metrics.csv` data set
% 
% OUTPUTS:
% 
%   results: struct, the linear classification 
%       balanced accuracy, sensitivity, and specificity
%       for every field in test data. 
% 
% See also: 
% split_data
% linear_classify_processing

function results = linear_classify(filename)

    arguments
        filename char
    end

    % Get test and train sets
    [test, train] = split_data(filename);
        
    %% Train w and c
    names = fieldnames(train);
    names = names(1:end ~= find([names{:}] == 'y')); % remove y from names
    
    for ii = 1:length(names)

        % ST and SL are substructs
        if isstruct(train.(names{ii}))
            subnames = fieldnames(train.(names{ii}));
            for jj = 1:length(subnames)
                X = train.(names{ii}).(subnames{jj});
                % Create structs of w and c with associated fieldnames
                [w.(names{ii}).(subnames{jj}), c.(names{ii}).(subnames{jj})] = classify_params(train.y,X);
            end
        else
            X = train.(names{ii});
            % Create structs of w and c with associated fieldnames
            [w.(names{ii}), c.(names{ii})] = classify_params(train.y,X);
        end

    end
    
    
    %% Evaluate
    for ii = 1:length(names)
        
        % ST and SL are substructs
        if isstruct(test.(names{ii}))
            subnames = fieldnames(test.(names{ii}));
            for jj = 1:length(subnames)
                % Get prediction 
                X = test.(names{ii}).(subnames{jj});
                y_hat = (X*w.(names{ii}).(subnames{jj}))>c.(names{ii}).(subnames{jj});
                
                % True/False Positive/Negatives 
                TP = sum((test.y==1)&(y_hat==1));
                FP = sum((test.y==0)&(y_hat==1));
                FN = sum((test.y==1)&(y_hat==0));
                TN = sum((test.y==0)&(y_hat==0));
                
                % Add results to same fields
                results.(names{ii}).(subnames{jj}).specificity = TN/(TN+FP);
                results.(names{ii}).(subnames{jj}).sensitivity = TP/(TP+FN);
                results.(names{ii}).(subnames{jj}).accuracyBal = ...
                    (results.(names{ii}).(subnames{jj}).sensitivity ...
                    + results.(names{ii}).(subnames{jj}).specificity)/2;
            end

        else
            % Get prediction
            X = test.(names{ii});
            y_hat = (X*w.(names{ii}))>c.(names{ii});
            
            % True/False Positive/Negatives 
            TP = sum((test.y==1)&(y_hat==1));
            FP = sum((test.y==0)&(y_hat==1));
            FN = sum((test.y==1)&(y_hat==0));
            TN = sum((test.y==0)&(y_hat==0));
            
            % Add results to same fields
            results.(names{ii}).specificity = TN/(TN+FP);
            results.(names{ii}).sensitivity = TP/(TP+FN);
            results.(names{ii}).accuracyBal = ...
                (results.(names{ii}).sensitivity + ...
                results.(names{ii}).specificity)/2;
        end
    
    end


end %function

