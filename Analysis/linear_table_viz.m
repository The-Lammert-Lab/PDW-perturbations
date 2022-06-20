%%% For compiling the linear classification data into a nice table. 

%% Old fall critera data
% M = load('../Data/Data n50000g0.014p0.32d13-May22/metrics.csv');
% [~,accBal14,sens14,spec14] = linear_classify_new(M);
% 
% M = load('../Data/Data n50000g0.016p0.32d14-May22/metrics.csv');
% [~,accBal16,sens16,spec16] = linear_classify_new(M);
% 
% % M = load('../Data/Data n50000g0.019p0.32d29-Jun21/fullmetrics.csv');
% % M = M(1:50000,:);
% 
% M = load('../Data/Data n50000g0.019p0.32d20-May22/metrics.csv');
% [~,accBal19,sens19,spec19] = linear_classify_new(M);

%% New fall critera data

M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/metrics.csv');
[~,accBal14,sens14,spec14] = linear_classify_new(M);

M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv');
[~,accBal16,sens16,spec16] = linear_classify_new(M);

M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/metrics.csv');
[~,accBal19,sens19,spec19] = linear_classify_new(M);

%% Table

Metric = {'Step Length Variability';'Step Length Average';'Step Length Asymmetry';...
    'Step Time Variability';'Step Time Average';'Step Time Asymmetry';...
    'Jacobian Eigenvalues';'IC phi and theta';'Lvar + Lmean';...
    'Lvar + Tvar';'Combined step metrics'};

% T = table(accBal14,accBal16,accBal19,sens14,sens16,sens19,...
%     spec14,spec16,spec19,'RowNames',Metric);
% 
% T = renamevars(T,["accBal14","sens14","spec14","accBal16","sens16","spec16",...
%     "accBal19","sens19","spec19"],...
%     ["0.014 bal accuracy", "0.014 sensitivity", "0.014 specificity",...
%     "0.016 bal accuracy", "0.016 sensitivity", "0.016 specificity",...
%     "0.019 bal accuracy", "0.019 sensitivity", "0.019 specificity"]);


T = table(accBal14,sens14,spec14,accBal16,sens16,spec16,...
    accBal19,sens19,spec19,'RowNames',Metric);

T = renamevars(T,["accBal14","sens14","spec14","accBal16","sens16","spec16",...
    "accBal19","sens19","spec19"],...
    ["0.014 bal accuracy", "0.014 sensitivity", "0.014 specificity",...
    "0.016 bal accuracy", "0.016 sensitivity", "0.016 specificity",...
    "0.019 bal accuracy", "0.019 sensitivity", "0.019 specificity"]);

figure
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

uicontrol('Style', 'text', 'Position', [20 100 200 20], 'String', 'New fall criteria');


%%
% M = load('../Data/Data n50000g0.019p0.32d29-Jun21/fullmetrics.csv');
% [~,accBal50,sens50,spec50] = linear_classify(M);
% 
% M = M(1:50000,:);
% [~,accBal25,sens25,spec25] = linear_classify(M);
% 
% T = table(accBal50,accBal25,sens50,sens25,...
%     spec50,spec25,'RowNames',Metric);
% 
% T = renamevars(T,["accBal50","sens50","spec50","accBal25","sens25","spec25"],...
%     ["n=50k bal accuracy", "n=50k sensitivity", "n=50k specificity",...
%     "n=25k bal accuracy", "n=25k sensitivity", "n=25k specificity"]);
% 
% figure
% uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
%     'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
% 
% uicontrol('Style', 'text', 'Position', [20 100 200 20], 'String', 'gamma = 0.019 only');

