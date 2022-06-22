function [y, IC, IC_fall, stepT_metrics, stepL_metrics, fall_steps, jac_eig, pert_perc, yield] = ts_data_novis(n,gam,pert)

    [stepL_var, stepL_mean, stepL_asym, stepL_Lmean, stepL_Rmean,...
        stepT_var, stepT_mean, stepT_asym, stepT_Lmean, stepT_Rmean] = deal(zeros(1,n));
    
    [IC, jac_eig] = deal(zeros(n,2));
    pert_perc = zeros(4,n);
    
    count_fall = 0;
    count_nonfall = 0;
    count_fallIC = 0;
    count_all = 0;
    count_allfalls = 0;
    count = 0;
    stepLim = 6; % Number of steps for cutoff
    steps = 50; % Number of steps model takes before outcome = nonfall
    view = 0; % Run model animation: view = 1
    
    while count < n
        [outcome, fallIndex, pert_percent, y0_init, ...
            step_inds, step_length, step_time] = perturb_pdw(steps,gam,pert,view);
        count_all = count_all+1;
    
        switch outcome
            case 'fall'
                count_allfalls = count_allfalls + 1;
                fall_ind(count_allfalls) = fallIndex;
                [~,idx] = min(abs(step_inds - fall_ind(count_allfalls)));
                fall_steps(count_allfalls,1) = idx;
    
                nz = find(step_inds ~= 0);
                if fallIndex <= step_inds(nz(end)) && step_inds(stepLim) == 0
                    count_fallIC = count_fallIC + 1;
                    % Store initial theta and initial phi values.
                    IC_fall(count_fallIC,:) = [y0_init(1,1), y0_init(3,1)];
    
                elseif fallIndex >= step_inds(stepLim) && step_inds(stepLim) ~= 0
                    count = count + 1;
                    count_fall = count_fall + 1;
                    falls(count_fall) = count;
                    %%% Jacobian %%%
                    jac_eig(count,:) = Jac_edited(gam,y0_init);
                    %%% Initial condition %%%
                    IC(count,1) = y0_init(1,1); % Initial theta value
                    IC(count,2) = y0_init(3,1); % Initial phi value
                    pert_perc(:,count) = pert_percent;
                    %%% Step time 2 %%%
                    stepT_var(count) = std(step_time(1:stepLim-1));
                    stepT_mean(count) = mean(step_time(1:stepLim-1));
                    stepT_Rmean(count) = mean(step_time(1:2:stepLim-1));
                    stepT_Lmean(count) = mean(step_time(2:2:stepLim-1));
                    stepT_asym(count) = stepT_Rmean(count) - stepT_Lmean(count);
                    %%% Step length %%%
                    stepL_var(count) = std(step_length(1:stepLim-1));
                    stepL_mean(count) = mean(step_length(1:stepLim-1));
                    stepL_Rmean(count) = mean(step_length(1:2:stepLim-1));
                    stepL_Lmean(count) = mean(step_length(2:2:stepLim-1));
                    stepL_asym(count) = stepL_Rmean(count) - stepL_Lmean(count);
    
                end
            case 'nonfall' % non-falls
                count = count + 1;
                count_nonfall = count_nonfall + 1;
                nonfalls(count_nonfall) = count;
                %%% Jacobian %%%
                jac_eig(count,:) = Jac_edited(gam,y0_init);
                %%% Initial condition %%%
                IC(count,1) = y0_init(1,1); % Initial theta value
                IC(count,2) = y0_init(3,1); % Initial phi value
                pert_perc(:,count) = pert_percent;
                %%% Step time 2 %%%
                stepT_var(count) = std(step_time(1:stepLim-1));
                stepT_mean(count) = mean(step_time(1:stepLim-1));
                stepT_Rmean(count) = mean(step_time(1:2:stepLim-1));
                stepT_Lmean(count) = mean(step_time(2:2:stepLim-1));
                stepT_asym(count) = stepT_Rmean(count) - stepT_Lmean(count);
                %%% Step length %%%
                stepL_var(count) = std(step_length(1:stepLim-1));
                stepL_mean(count) = mean(step_length(1:stepLim-1));
                stepL_Rmean(count) = mean(step_length(1:2:stepLim-1));
                stepL_Lmean(count) = mean(step_length(2:2:stepLim-1));
                stepL_asym(count) = stepL_Rmean(count) - stepL_Lmean(count);
        end
    end
    
    %% Output Values
    
    yield = (count/count_all)*100;
    
    stepL_metrics = [stepL_var, stepL_mean, stepL_asym];
    
    stepT_metrics = [stepT_var, stepT_mean, stepT_asym];
    
    % Create 1/0 labels
    y = sort([nonfalls falls])';
    
    [idx,loc] = ismember(nonfalls,y);
    out = loc(idx);
    
    y(out) = 0; % nonfalls
    y(y~=0) = 1; % falls
    
    
    %% Save data
    
    d = date;
    d = d([1:6,10:11]);
    temp = 0;
    foldername = strcat('Data n',num2str(n),'g',num2str(gam),'p',num2str(pert),'d',num2str(d));
    
    % So it doesn't error if there's accidentally a folder with same name
    while exist(foldername,'dir') == 7
        temp = temp + 1;
        foldername = strcat(foldername,num2str(temp));
    end
    
    mkdir(foldername);
    
    % %% Make a massive matrix of all metrics (not fall_steps) and save to csv %%%
    % %% Values in order of appearance
    % y = n-by-1 (column 1)
    % jac_eig = n-by-2 (columns 2-3)
    % stepT_metrics2 = n-by-3 (columns 4-6)
    % stepL_metrics = n-by-3 (columns 7-9)
    % IC = n-by-1 (column 10-11)
    
    M = [y jac_eig stepT_metrics stepL_metrics IC];
    filename = 'metrics.csv';
    fullname = fullfile(foldername,filename);
    writematrix(M, fullname);
    
    filename = 'IC_fall_data.csv';
    fullname = fullfile(foldername,filename);
    writematrix(IC_fall, fullname);
    
    filename = 'fall_steps_data.csv';
    fullname = fullfile(foldername,filename);
    writematrix(fall_steps, fullname);
    
    filename = 'perturbationPercent.csv';
    fullname = fullfile(foldername,filename);
    writematrix(pert_perc, fullname);
    
    filename = 'percentYield.csv';
    fullname = fullfile(foldername,filename);
    writematrix(yield, fullname);

end







