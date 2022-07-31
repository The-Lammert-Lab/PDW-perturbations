% heatmap_loop
% 
% Call collect_data over a range of perturbation
% values for each gamma value of interest.
% 
% ARGUMENTS:
% 
%   n: 1 x 1 scalar, 
%       the number of trials each collect_data call produces. 
% 
%   savetype: char,
%       either 'csv' or 'mat'. 
%       Indicates the filetype to save metrics in collect_data as.
% 
% Saved CSVs
% 
%   gaitCyclesProcessed  = [gamma perturbation fall_ratio percent_yield]  
% 
%   gaitCyclesMetrics = ST and SL var, mean, asym separated by NaN columns.
% 
% See also:
% collect_data

function heatmap_loop(n, savetype)

    arguments 
        n (1,1) {mustBePositive, mustBeInteger}
        savetype char {mustBeMember(savetype,["mat","csv"])}
    end

    %% Initialization
    
    gam = [0.014; 0.016; 0.019];
    pert = (0.02:0.06:0.50)';
    
    conds = length(gam)*length(pert);
    c = 0;
    d = 0;
    [falls, non_falls, tot_trials, percent_yield] = deal(zeros(conds,1));
    [ST_var, ST_mean, ST_asym, SL_var, SL_mean, SL_asym] = deal(zeros(n,conds));
    
    %% Loop
    for itor = 1:length(gam)
        for jtor = 1:length(pert)
            
            c = c+1;
            [y, ~, ~, stepT_metrics, stepL_metrics, ~, ~, ~, yield] = collect_data(n,gam(itor),pert(jtor), savetype);
    
            % Simulation data
            falls(c) = sum(y==1);
            non_falls(c) = sum(y==0);
            tot_trials(c) = length(y);
            percent_yield(c) = yield;
            
            % Store metrics
            ST_var(:,c) = stepT_metrics(:,1);
            ST_mean(:,c) = stepT_metrics(:,2);
            ST_asym(:,c) = stepT_metrics(:,3);
            SL_var(:,c) = stepL_metrics(:,1);
            SL_mean(:,c) = stepL_metrics(:,2);
            SL_asym(:,c) = stepL_metrics(:,3);  
            
        end
    end
    
    %% Save data
    
    % Create useful things
    gamma = repelem(gam,length(pert));
    perturbation = string(repmat(pert*100,length(gam),1));
    pm = repelem("\pm",length(perturbation),1);
    perturbation = append(pm,perturbation);
    
    % Separate metrics with NaNs
    mat = [ST_var, NaN(n,1), ST_mean, NaN(n,1), ST_asym, NaN(n,1), ...
        SL_var, NaN(n,1), SL_mean, NaN(n,1), SL_asym];
    
    fall_ratio = falls./non_falls;
    
    % Write files
    
    d = date;
    d = d([1:6,10:11]);
    temp = 0;
    foldername = strcat('../Data/HeatmapData_n',num2str(n),...
        'g',num2str(min(gam)),'_',num2str(max(gam)),...
        'p',num2str(min(pert)),'_',num2str(max(pert)),'d',num2str(d));
    
    % So it doesn't error if there's accidentally a folder with same name
    while exist(foldername,'dir') == 7
        temp = temp + 1;
        foldername = strcat(foldername,num2str(temp));
    end
    
    mkdir(foldername);
    
    % Used for heatmap figures
    processed = [gamma perturbation fall_ratio percent_yield];
    filename = strcat('HeatmapProcessed_',num2str(min(gam)),'_',num2str(max(gam)),...
       '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
    fullname = fullfile(foldername,filename);
    writematrix(processed, fullname);
    
    % Might as well save the metrics. 
    % Not used in analysis b/c data saved in output of collect_data.m, too. 
    filename = strcat('HeatmapMetrics_',num2str(min(gam)),'_',num2str(max(gam)),...
       '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
    fullname = fullfile(foldername,filename);
    writematrix(mat,fullname);

end
