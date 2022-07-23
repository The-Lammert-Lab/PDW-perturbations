% split_data
% 
% Halve data set into a testing and training set.
% Create desired combinations of metrics for analysis
% 
% ARGUMENTS:
% 
%   filename: char, the path to the `metrics.csv` data set
% 
% OUTPUTS:
% 
%   test: struct, half of the data set organized into readable fieldnames.
%       Fieldnames are identical to `train`.
% 
%   train: struct, other half of the data set organized into readable fieldnames
%       Fieldnames are identical to `test`.
% 
% See also:
% linear_classify
% linear_classify_processing

function [test, train] = split_data(filename)

    arguments
        filename char
    end

    % Organization of data matrix M:
    % 
    % y = n-by-1 (column 1) 
    % jac_eig = n-by-2 (columns 2-3)
    % stepT_metrics = n-by-3 (columns 4-6)
    % stepL_metrics = n-by-3 (columns 7-9)
    % IC = n-by-1 (column 10-11)
    
    %% Load data
    M = readtable(filename);

    if mod(height(M),2) ~= 0
        M = M(1:height(M)-1,:);
    end
    
    %% Format into structs
    all = struct('y',M.Var1,'eigenvalues',[M.Var2, M.Var3],'ICpt',[M.Var10, M.Var11]);
    
    % Split
    % Data is completely random, so split is directly in half.
    train = structfun(@(x) x(1:length(x)/2,:), all, 'UniformOutput', false);
    test = structfun(@(x) x((length(x)/2)+1:end,:), all, 'UniformOutput', false);

    % Add nested structs
    all.ST.Var = M.Var4;
    all.ST.Mean = M.Var5;
    all.ST.Asym = M.Var6;

    all.SL.Var = M.Var7;
    all.SL.Mean = M.Var8;
    all.SL.Asym = M.Var9;

    % Split nested structs into test and train
    for ii = fieldnames(all)'
        if isstruct(all.(ii{1}))
            test.(ii{1}) = structfun(@(x) x((length(x)/2)+1:end,:), all.(ii{1}), 'UniformOutput', false);
            train.(ii{1}) = structfun(@(x) x(1:length(x)/2,:), all.(ii{1}), 'UniformOutput', false);
        end
    end

    %% Normalize step length and time metrics
    stepMetOrder = fieldnames(train.ST)'; % Fieldnames before creating "combinedNorm"
    count = 0;
    for ii = stepMetOrder
        count = count + 1;
        train.ST.combinedNorm(:,count) = (train.ST.(ii{1}) - min(train.ST.(ii{1})))./range(train.ST.(ii{1}));
        test.ST.combinedNorm(:,count) = (test.ST.(ii{1}) - min(test.ST.(ii{1})))./range(test.ST.(ii{1}));
    
        train.SL.combinedNorm(:,count) = (train.SL.(ii{1}) - min(train.SL.(ii{1})))./range(train.SL.(ii{1}));
        test.SL.combinedNorm(:,count) = (test.SL.(ii{1}) - min(test.SL.(ii{1})))./range(test.SL.(ii{1}));
    end
    
    %% Additional fields

    % All combined norms together
    train.ST_SL_normCombAll = [train.ST.combinedNorm, train.SL.combinedNorm];
    test.ST_SL_normCombAll = [test.ST.combinedNorm, test.SL.combinedNorm];
    
    % Step length variability and mean
    train.SL_var_mean = [train.SL.Var, train.SL.Mean];
    test.SL_var_mean = [test.SL.Var, test.SL.Mean];
    
    % Step time and step length variability
    train.ST_SL_var = [train.ST.Var, train.SL.Var];
    test.ST_SL_var = [test.ST.Var, test.SL.Var];
    
    % Step length variability and mean normalized
    train.SL_var_meanNorm = [train.SL.combinedNorm(:,1), train.SL.combinedNorm(:,2)];
    test.SL_var_meanNorm = [test.SL.combinedNorm(:,1), test.SL.combinedNorm(:,2)];
    
    % Step time and step length variability normalized
    train.ST_SL_varNorm = [train.ST.combinedNorm(:,1), train.SL.combinedNorm(:,1)];
    test.ST_SL_varNorm = [test.ST.combinedNorm(:,1), test.SL.combinedNorm(:,1)];

end