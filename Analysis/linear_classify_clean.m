%%% A readable and correct linear classification function

% y = n-by-1 (column 1) 
% jac_eig = n-by-2 (columns 2-3)
% stepT_metrics2 = n-by-3 (columns 4-6)
% stepL_metrics = n-by-3 (columns 7-9)
% IC = n-by-1 (column 10-11)


function results = linear_classify_clean(filename)

%% Prep 

% Load data
M = readtable(filename);


% Useful variables
halfM = height(M)/2;

Mtrain = M(1:halfM,:);
Mtest = M(halfM+1:end,:);

% Training set
S_train = struct('y',Mtrain.Var1,'eigenvalues',[Mtrain.Var2, Mtrain.Var3],...
    'ICpt',[Mtrain.Var10, Mtrain.Var11]);

S_train.ST.Var = Mtrain.Var4;
S_train.ST.Mean = Mtrain.Var5;
S_train.ST.Asym = Mtrain.Var6;

S_train.SL.Var = Mtrain.Var7;
S_train.SL.Mean = Mtrain.Var8;
S_train.SL.Asym = Mtrain.Var9;

% Test set
S_test = struct('y',Mtest.Var1,'eigenvalues',[Mtest.Var2, Mtest.Var3],...
    'ICpt',[Mtest.Var10, Mtest.Var11]);

S_test.ST.Var = Mtest.Var4;
S_test.ST.Mean = Mtest.Var5;
S_test.ST.Asym = Mtest.Var6;

S_test.SL.Var = Mtest.Var7;
S_test.SL.Mean = Mtest.Var8;
S_test.SL.Asym = Mtest.Var9;

% Normalize step length and time metrics
stepMetOrder = fieldnames(S_train.ST)'; % Fieldnames before creating "combinedNorm"
count = 0;
for ii = stepMetOrder
    count = count + 1;
    S_train.ST.combinedNorm(:,count) = (S_train.ST.(ii{1}) - min(S_train.ST.(ii{1})))./range(S_train.ST.(ii{1}));
    S_test.ST.combinedNorm(:,count) = (S_test.ST.(ii{1}) - min(S_test.ST.(ii{1})))./range(S_test.ST.(ii{1}));

    S_train.SL.combinedNorm(:,count) = (S_train.SL.(ii{1}) - min(S_train.SL.(ii{1})))./range(S_train.SL.(ii{1}));
    S_test.SL.combinedNorm(:,count) = (S_test.SL.(ii{1}) - min(S_test.SL.(ii{1})))./range(S_test.SL.(ii{1}));
end

% Create separate field with all combined norms together
S_train.ST_SL_normCombAll = [S_train.ST.combinedNorm, S_train.SL.combinedNorm];
S_test.ST_SL_normCombAll = [S_test.ST.combinedNorm, S_test.SL.combinedNorm];

S_train.SL_var_mean = [S_train.SL.Var, S_train.SL.Mean];
S_test.SL_var_mean = [S_test.SL.Var, S_test.SL.Mean];

S_train.ST_SL_var = [S_train.ST.Var, S_train.SL.Var];
S_test.ST_SL_var = [S_test.ST.Var, S_test.SL.Var];

% This should be neater, but it's here for now.
S_train.SL_var_meanNorm = [S_train.SL.combinedNorm(:,1), S_train.SL.combinedNorm(:,2)];
S_test.SL_var_meanNorm = [S_test.SL.combinedNorm(:,1), S_test.SL.combinedNorm(:,2)];

S_train.ST_SL_varNorm = [S_train.ST.combinedNorm(:,1), S_train.SL.combinedNorm(:,1)];
S_test.ST_SL_varNorm = [S_test.ST.combinedNorm(:,1), S_test.SL.combinedNorm(:,1)];

%% Classification

% Train w and c
names = fieldnames(S_train)';
names = names(2:end); % Remove 'y' from names

for ii = names
    
    if isstruct(S_train.(ii{1}))
        subnames = fieldnames(S_train.(ii{1}))';
        for jj = subnames
            X = S_train.(ii{1}).(jj{1});
            [w.(ii{1}).(jj{1}), c.(ii{1}).(jj{1})] = classify_bme(S_train.y,X);
        end
    else
        X = S_train.(ii{1});
        [w.(ii{1}), c.(ii{1})] = classify_bme(S_train.y,X);
    end
    
end


% Evaluate
for ii = names
    
    if isstruct(S_test.(ii{1}))
        subnames = fieldnames(S_test.(ii{1}))';
        for jj = subnames
            X = S_test.(ii{1}).(jj{1});
            y_hat = (X*w.(ii{1}).(jj{1}))>c.(ii{1}).(jj{1});
            
            TP = sum((S_test.y==1)&(y_hat==1));
            FP = sum((S_test.y==0)&(y_hat==1));
            FN = sum((S_test.y==1)&(y_hat==0));
            TN = sum((S_test.y==0)&(y_hat==0));
            
            results.(ii{1}).(jj{1}).specificity = TN/(TN+FP);
            results.(ii{1}).(jj{1}).sensitivity = TP/(TP+FN);
            results.(ii{1}).(jj{1}).accuracyBal = (results.(ii{1}).(jj{1}).sensitivity + results.(ii{1}).(jj{1}).specificity)/2;
            
        end
    else
        X = S_test.(ii{1});
        y_hat = (X*w.(ii{1}))>c.(ii{1});
        
        TP = sum((S_test.y==1)&(y_hat==1));
        FP = sum((S_test.y==0)&(y_hat==1));
        FN = sum((S_test.y==1)&(y_hat==0));
        TN = sum((S_test.y==0)&(y_hat==0));
        
        results.(ii{1}).specificity = TN/(TN+FP);
        results.(ii{1}).sensitivity = TP/(TP+FN);
        results.(ii{1}).accuracyBal = (results.(ii{1}).sensitivity + results.(ii{1}).specificity)/2;
        
    end

end


end %function

