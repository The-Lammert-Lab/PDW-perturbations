function heatmap_loop(n)
%%%%%%%%% Repeatedly call collect_data.m and save outputs %%%%%%%%%%

%% Initialization

gam = [0.014; 0.016; 0.019];
pert = (0.02:0.06:0.50)';

conds = length(gam)*length(pert);
c = 0;
d = 0;
[falls, non_falls, tot_trials, percent_yield, TV, GV] = deal(zeros(conds,1));
[m1, m2, m3, m4, m5, m6] = deal(zeros(n,conds));

%% Loop
for itor = 1:length(gam)
    for jtor = 1:length(pert)
        
        c = c+1;
        [y, ~, ~, stepT_metrics, stepL_metrics, ~, ~, ~, yield] = collect_data(n,gam(itor),pert(jtor));

        % Simulation data
        falls(c) = sum(y==1);
        non_falls(c) = sum(y==0);
        tot_trials(c) = length(y);
        percent_yield(c) = yield;
        
        % Store metrics
        m1(:,c) = stepT_metrics(:,1);
        m2(:,c) = stepT_metrics(:,2);
        m3(:,c) = stepT_metrics(:,3);
        m4(:,c) = stepL_metrics(:,1);
        m5(:,c) = stepL_metrics(:,2);
        m6(:,c) = stepL_metrics(:,3);  
        
    end
end

% Store raw data
mat = [m1 m2 m3 m4 m5 m6];

%% Old/Defunked analysis idea

% Globally normalize metrics 
m1 = (m1-min(min(m1)))./range(m1,'all');
m2 = (m2-min(min(m2)))./range(m2,'all');
m3 = (m3-min(min(m3)))./range(m3,'all');
m4 = (m4-min(min(m4)))./range(m4,'all');
m5 = (m5-min(min(m5)))./range(m5,'all');
m6 = (m6-min(min(m6)))./range(m6,'all');

for itor = 1:conds
    
    X = [m1(:,itor) m2(:,itor) m3(:,itor) m4(:,itor) m5(:,itor) m6(:,itor)];
    S = cov(X);
    
    % Total Variation
    TV(itor) = trace(S)/6;
    
    % Generalized Variance
    GV(itor) = det(S)^(1/6);
    
end

%% Save data

% Create useful things
gamma = repelem(gam,length(pert));
perturbation = string(repmat(pert*100,length(gam),1));
pm = repelem("\pm",length(perturbation),1);
perturbation = append(pm,perturbation);

fall_ratio = falls./non_falls;

% Save other data

d = date;
d = d([1:6,10:11]);
temp = 0;
foldername = strcat('Gaitcycles data n',num2str(n),...
    'g',num2str(min(gam)),'_',num2str(max(gam)),...
    'p',num2str(min(pert)),'_',num2str(max(pert)),'d',num2str(d));

% So it doesn't error if there's accidentally a folder with same name
while exist(foldername,'dir') == 7
    temp = temp + 1;
    foldername = strcat(foldername,num2str(temp));
end

mkdir(foldername);

% Ultimately not used. 
processed = [gamma perturbation fall_ratio GV TV percent_yield];
filename = strcat('gaitCyclesProcessed',num2str(min(gam)),'_',num2str(max(gam)),...
   '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
fullname = fullfile(foldername,filename);
writematrix(processed, fullname);

% Used for heatmap figures. 
filename = strcat('gaitCyclesRaw',num2str(min(gam)),'_',num2str(max(gam)),...
   '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
fullname = fullfile(foldername,filename);
writematrix(mat,fullname);

