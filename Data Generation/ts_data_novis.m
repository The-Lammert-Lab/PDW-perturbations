function [y, IC, IC_fall, stepT_metrics, stepL_metrics, fall_steps, jac_eig, pert_perc, yield, stepT_metrics2] = ts_data_novis(n,gam,pert)


% function [M, IC_fall, fall_steps, pert_perc, yield] = ts_data_novis(n,gam,pert)

% function [y, IC, IC_fall, stepT_metrics, stepL_metrics, fall_steps, eig_spec_EE3, jac_eig, pert_perc, count_all] = ts_data_novis(n,gam,pert)


if nargin < 1
    n = 1000;
end

if nargin < 2
    gam = 0.019;
end

if nargin < 3
    pert = 0.32;
end

[stepL_var, stepL_mean, stepL_asym, stepL_Lmean, stepL_Rmean,...
    stepT_var, stepT_mean, stepT_asym, stepT_Lmean, stepT_Rmean,...
    stepT_var2, stepT_mean2, stepT_asym2, stepT_Lmean2, stepT_Rmean2] = deal(zeros(1,n));

[IC, jac_eig] = deal(zeros(n,2));
pert_perc = zeros(4,n);

countf = 0;
countw = 0;
count_fallIC = 0;
count_all = 0;
count_allfalls = 0;
count = 0;
stepLim = 6; % Number of steps for cutoff

while count < n
    [temp, pert_percent, y0_init, step_time, step_inds, step_length, step_time2] = gen_eigs_newfall(50,gam,pert);
    sz = size(temp); % To check the output size of the simulation (3 is a falling trial).
    count_all = count_all+1;
    
    if sz(2) == 3 % only falls
        count_allfalls = count_allfalls + 1;
        fall_ind(count_allfalls) = temp(1,3); % temp(1,3) is first fall index
        [~,idx] = min(abs(step_inds - fall_ind(count_allfalls)));
        fall_steps(count_allfalls,1) = idx;
        
        nz = find(step_inds ~= 0);
        if temp(1,3) <= step_inds(nz(end)) && step_inds(stepLim) == 0
            count_fallIC = count_fallIC + 1;
            IC_fall(count_fallIC,1) = y0_init(1,1); % Initial theta value
            IC_fall(count_fallIC,2) = y0_init(3,1); % Initial phi value
            
        elseif temp(1,3) >= step_inds(stepLim) && step_inds(stepLim) ~= 0
            count = count + 1;
            countf = countf + 1;
            fall1(countf) = count;
%             THETA(1:length(temp),count) = temp(:,1);
%             PHI(1:length(temp),count) = temp(:,2);
%             %%% XCorr %%%
%             xx = [THETA(1:step_inds(stepLim-1),count) PHI(1:step_inds(stepLim-1),count)];
%             a = xcorr_xx(xx);
%             eig_spec_EE3(count,:) = a(3).EE;
            %%% Jacobian %%%
            jac_eig(count,:) = Jac_edited(gam,y0_init);
            %%% Initial condition %%%
            IC(count,1) = y0_init(1,1); % Initial theta value
            IC(count,2) = y0_init(3,1); % Initial phi value
            pert_perc(:,count) = pert_percent;
            %%% Step time %%%
            stepT_var(count) = std(step_time(1:stepLim-1));
            stepT_mean(count) = mean(step_time(1:stepLim-1));
            stepT_Rmean(count) = mean(step_time(1:2:stepLim-1));
            stepT_Lmean(count) = mean(step_time(2:2:stepLim-1));
            stepT_asym(count) = stepT_Rmean(count) - stepT_Lmean(count);
            %%% Step time 2 %%%
            stepT_var2(count) = std(step_time2(1:stepLim-1));
            stepT_mean2(count) = mean(step_time2(1:stepLim-1));
            stepT_Rmean2(count) = mean(step_time2(1:2:stepLim-1));
            stepT_Lmean2(count) = mean(step_time2(2:2:stepLim-1));
            stepT_asym2(count) = stepT_Rmean2(count) - stepT_Lmean2(count);
            %%% Step length %%%
            stepL_var(count) = std(step_length(1:stepLim-1));
            stepL_mean(count) = mean(step_length(1:stepLim-1));
            stepL_Rmean(count) = mean(step_length(1:2:stepLim-1));
            stepL_Lmean(count) = mean(step_length(2:2:stepLim-1));
            stepL_asym(count) = stepL_Rmean(count) - stepL_Lmean(count);
            
%             if fall_steps(count_allfalls,1) == 10
%                 format long
%                 y0_init
%             end

%             if pert_percent(1) > 20 || pert_percent(3) < -17
%                 format long
%                 y0_init
%                 pert_percent
%                 
%             end
            
        end
    else % non-falls
        count = count + 1;
        countw = countw + 1;
        fall0(countw) = count;
%         THETA(1:length(temp),count) = temp(:,1);
%         PHI(1:length(temp),count) = temp(:,2);
%         %%% XCorr %%%
%         xx = [THETA(1:step_inds(stepLim-1),count) PHI(1:step_inds(stepLim-1),count)];
%         a = xcorr_xx(xx);
%         eig_spec_EE3(count,:) = a(3).EE;
        %%% Jacobian %%%
        jac_eig(count,:) = Jac_edited(gam,y0_init);
        %%% Initial condition %%%
        IC(count,1) = y0_init(1,1); % Initial theta value
        IC(count,2) = y0_init(3,1); % Initial phi value
        pert_perc(:,count) = pert_percent;
        %%% Step time %%%
        stepT_var(count) = std(step_time(1:stepLim-1));
        stepT_mean(count) = mean(step_time(1:stepLim-1));
        stepT_Rmean(count) = mean(step_time(1:2:stepLim-1));
        stepT_Lmean(count) = mean(step_time(2:2:stepLim-1));
        stepT_asym(count) = stepT_Rmean(count) - stepT_Lmean(count);
        %%% Step time 2 %%%
        stepT_var2(count) = std(step_time2(1:stepLim-1));
        stepT_mean2(count) = mean(step_time2(1:stepLim-1));
        stepT_Rmean2(count) = mean(step_time2(1:2:stepLim-1));
        stepT_Lmean2(count) = mean(step_time2(2:2:stepLim-1));
        stepT_asym2(count) = stepT_Rmean2(count) - stepT_Lmean2(count);
        %%% Step length %%%
        stepL_var(count) = std(step_length(1:stepLim-1));
        stepL_mean(count) = mean(step_length(1:stepLim-1));
        stepL_Rmean(count) = mean(step_length(1:2:stepLim-1));
        stepL_Lmean(count) = mean(step_length(2:2:stepLim-1));
        stepL_asym(count) = stepL_Rmean(count) - stepL_Lmean(count);
        
%         if abs(pert_percent(1)) > 25 && abs(pert_percent(2)) > 25 && abs(pert_percent(3)) > 25 && abs(pert_percent(4)) > 25
%             format long
%             y0_init
%             pert_percent
%         end

        if pert_percent(1) > 20 || pert_percent(3) < -17
            format long
            y0_init
            pert_percent
            
        end



    end
end

% disp('total number of falls:')
% countf
% 
% disp('total number of  non-falls:')
% countw
% 
% disp('number of trials counted:')
% countf + countw

%%%%% Output values %%%%%

yield = (count/count_all)*100;

stepT_metrics(:,1) = stepT_var;
stepT_metrics(:,2) = stepT_mean;
stepT_metrics(:,3) = stepT_asym;

stepL_metrics(:,1) = stepL_var;
stepL_metrics(:,2) = stepL_mean;
stepL_metrics(:,3) = stepL_asym;

stepT_metrics2(:,1) = stepT_var2;
stepT_metrics2(:,2) = stepT_mean2;
stepT_metrics2(:,3) = stepT_asym2;

% Create 1/0 labels 
y = sort([fall0 fall1])';

[idx,loc] = ismember(fall0,y);
out = loc(idx);

y(out) = 0;
y(y~=0) = 1;


%%% Save data

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

M = [y jac_eig stepT_metrics2 stepL_metrics IC];
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











