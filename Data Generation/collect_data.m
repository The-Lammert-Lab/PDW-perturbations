% collect_data
% 
% Collect data from perturb_pdw.m
% Synthesize kinematic metrics and other relevant data
% and save all files to csv
% 
% ARGUMENTS:
%   
%   n: 1 x 1 scalar,
%       the number of trials to simulate.
% 
%   gam: 1 x 1 scalar, 
%       the slope value in radians.       
% 
%   pert: 1 x 1 scalar, 
%       percent by which to perturb the ICs
%       0 <= pert <= 1
% 
% OUTPUTS:
% 
%   y: n x 1 numerical vector, 
%       vector of 1s and 0s representing falls and nonfalls, respectively.
% 
%   IC: n x 2 numerical vector, 
%       Initial condition theta (:,1) and phi (:,2) 
%       values for each non-discard trial.
% 
%   IC_fall: ? x 2 numerical vector,
%       Initial condition theta (:,1) and phi (:,2) for all early fall trials.
%       length is unknown but can be estimated from percent yield data.
%   
%   stepT_metrics: n x 3 numerical vector, 
%       Step time variability (standard deviation), mean, and 
%       asymmetry, respectively.
%   
%   stepL_metrics: n x 3 numerical vector, 
%       Step length variability (standard deviation), mean, and 
%       asymmetry, respectively.
% 
%   fall_steps: ? x 2 numerical vector,
%       Number of steps each trial took before a fall. 
%       length is unknown because early falls are counted too. 
% 
%   jac_eig: n x 2 numerical vector,
%       Jacobian eigenvalues of theta for each trial
% 
%   pert_perc: 4 x 100 numerical vector, 
%       Percent perturbation experienced by each IC variable.
%       [theta; thetadot; phi; phidot].
% 
%   yield: 1 x 1 scalar, 
%       percent yield.
% 
% CSVs saved:
% 
%   'metrics.csv' = [y jac_eig stepT_metrics stepL_metrics IC];
%     
%   'IC_fall_data.csv' = IC_fall
%     
%   'fall_steps_data.csv' = fall_steps
%     
%   'perturbationPercent.csv' = pert_perc
%     
%   'percentYield.csv' = yield
% 
% See also:
% perturb_pdw
% Jac_eig_pdw
% heatmap_loop

function [y, IC, IC_fall, stepT_metrics, stepL_metrics, fall_steps, jac_eig, pert_perc, yield] = collect_data(n,gam,pert)

    arguments
        n (1,1) {mustBePositive, mustBeInteger}
        gam (1,1) double {mustBeGreaterThan(gam,0.001), mustBeLessThanOrEqual(gam, 0.019)}
        pert (1,1) double {mustBeGreaterThanOrEqual(pert,0), mustBeLessThanOrEqual(pert, 1)}
    end

    %% Initialization 
    [y, stepL_var, stepL_mean, stepL_asym, stepL_Lmean, stepL_Rmean,...
        stepT_var, stepT_mean, stepT_asym, stepT_Lmean, stepT_Rmean] = deal(zeros(n,1));
    [IC, jac_eig] = deal(zeros(n,2));
    pert_perc = zeros(4,n);
    fall_steps = [];
    IC_fall = [];
    
    count_all = 0; % Falls + non-falls + early falls.
    count = 0; % Only falls and non-falls (not early falls).

    stepLim = 6; % Number of steps for cutoff
    steps = 50; % Number of steps model takes before outcome = nonfall

    f = waitbar(0, 'Simulation progress: 0%');

    %% Loop
    while count < n
        [outcome, fallIndex, pert_percent, y0_init, ...
            step_inds, step_length, step_time] = perturb_pdw(steps,gam,pert);
        count_all = count_all+1;
    
        switch outcome
            case 'fall'
                [~,idx] = min(abs(step_inds - fallIndex));
                fall_steps = [fall_steps; idx];
                
                % Early falls 
                % Data not used in manuscript, but collected out of curiosity.
                if fall_steps(end) < stepLim
                    IC_fall = [IC_fall; y0_init(1,1), y0_init(3,1)];
                else
                    count = count + 1;
                    y(count) = 1;
                    %%% Jacobian %%%
                    jac_eig(count,:) = Jac_eig_pdw(gam,y0_init);
                    %%% Initial condition %%%
                    % theta then phi.
                    IC(count,:) = [y0_init(1,1), y0_init(3,1)];
                    pert_perc(:,count) = pert_percent;
                    %%% Step time %%%
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
                y(count) = 0;
                %%% Jacobian %%%
                jac_eig(count,:) = Jac_eig_pdw(gam,y0_init);
                %%% Initial condition %%%
                % theta then phi.
                IC(count,:) = [y0_init(1,1), y0_init(3,1)];
                pert_perc(:,count) = pert_percent;
                %%% Step time %%%
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

        waitbar(count/n, f, sprintf('Simulation progress: %d%%', floor(count/n*100)))

    end
    
    close(f)
    
    %% Output Values
    
    yield = (count/count_all)*100;
    stepL_metrics = [stepL_var, stepL_mean, stepL_asym];
    stepT_metrics = [stepT_var, stepT_mean, stepT_asym];
    
    %% Save data
    
    d = date;
    d = d([1:6,10:11]);
    temp = 0;
    foldername = strcat('../Data/Data n',num2str(n),'g',num2str(gam),'p',num2str(pert),'d',num2str(d));
    
    % So it doesn't error if there's accidentally a folder with same name
    while exist(foldername,'dir') == 7
        temp = temp + 1;
        foldername = strcat(foldername,num2str(temp));
    end
    
    mkdir(foldername);
    
    % %% Values in M in order of appearance
    % y = n-by-1 (column 1)
    % jac_eig = n-by-2 (columns 2-3)
    % stepT_metrics = n-by-3 (columns 4-6)
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