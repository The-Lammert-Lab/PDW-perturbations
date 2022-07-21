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


function results = linear_classify(filename)

    [test, train] = split_data(filename);
        
    %% Train w and c
    names = fieldnames(train)';
    names = names(2:end); % Remove 'y' from names
    
    for ii = names
        
        if isstruct(train.(ii{1}))
            subnames = fieldnames(train.(ii{1}))';
            for jj = subnames
                X = train.(ii{1}).(jj{1});
                [w.(ii{1}).(jj{1}), c.(ii{1}).(jj{1})] = classify_bme(train.y,X);
            end
        else
            X = train.(ii{1});
            [w.(ii{1}), c.(ii{1})] = classify_bme(train.y,X);
        end
        
    end
    
    
    %% Evaluate
    for ii = names
        
        if isstruct(test.(ii{1}))
            subnames = fieldnames(test.(ii{1}))';
            for jj = subnames
                X = test.(ii{1}).(jj{1});
                y_hat = (X*w.(ii{1}).(jj{1}))>c.(ii{1}).(jj{1});
                
                TP = sum((test.y==1)&(y_hat==1));
                FP = sum((test.y==0)&(y_hat==1));
                FN = sum((test.y==1)&(y_hat==0));
                TN = sum((test.y==0)&(y_hat==0));
                
                results.(ii{1}).(jj{1}).specificity = TN/(TN+FP);
                results.(ii{1}).(jj{1}).sensitivity = TP/(TP+FN);
                results.(ii{1}).(jj{1}).accuracyBal = (results.(ii{1}).(jj{1}).sensitivity + results.(ii{1}).(jj{1}).specificity)/2;
            end

        else
            X = test.(ii{1});
            y_hat = (X*w.(ii{1}))>c.(ii{1});
            
            TP = sum((test.y==1)&(y_hat==1));
            FP = sum((test.y==0)&(y_hat==1));
            FN = sum((test.y==1)&(y_hat==0));
            TN = sum((test.y==0)&(y_hat==0));
            
            results.(ii{1}).specificity = TN/(TN+FP);
            results.(ii{1}).sensitivity = TP/(TP+FN);
            results.(ii{1}).accuracyBal = (results.(ii{1}).sensitivity + results.(ii{1}).specificity)/2;
        end
    
    end


end %function

