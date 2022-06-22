function gaitCycles(n)


gam = [0.014; 0.016; 0.019];
pert = (0.02:0.06:0.50)';

conds = length(gam)*length(pert);
c = 0;
d = 0;
[falls, non_falls, tot_trials, percent_yield, TV, GV] = deal(zeros(conds,1));
[m1, m2, m3, m4, m5, m6] = deal(zeros(n,conds));
[p1, p2, p3, p4] = deal(zeros(length(pert),n));

for itor = 1:length(gam)
    for jtor = 1:length(pert)
        
        c = c+1;
        % BE SURE OUTPUTS MATCH BECAUSE THEY CHANGED. 
        [y, ~, ~, stepT_metrics, stepL_metrics, ~, ~, pert_percent, yield] = ts_data_novis(n,gam(itor),pert(jtor));

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
        
        % Perturbation data
        if gam(itor) == max(gam)
            d = d+1;
            p1(d,:) = pert_percent(1,:);
            p2(d,:) = pert_percent(2,:);
            p3(d,:) = pert_percent(3,:);
            p4(d,:) = pert_percent(4,:);
        end
        
    end
end


% Store raw data
mat = [m1 m2 m3 m4 m5 m6];

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

processed = [gamma perturbation fall_ratio GV TV percent_yield];
filename = strcat('gaitCyclesProcessed',num2str(min(gam)),'_',num2str(max(gam)),...
   '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
fullname = fullfile(foldername,filename);
writematrix(processed, fullname);

% writematrix(processed,'gaitCyclesProcessed19.csv');
% p_data = [p1; zeros(1,n); p2; zeros(1,n); p3; zeros(1,n); p4];
% writematrix(p_data,'gaitCyclesPertDataXXX.csv');

filename = strcat('gaitCyclesRaw',num2str(min(gam)),'_',num2str(max(gam)),...
   '_',num2str(min(pert)),'_',num2str(max(pert)),'.csv');
fullname = fullfile(foldername,filename);
writematrix(mat,fullname);



%% Viz

% Graph
tbl = table(TV,perturbation,gamma);
figure(1)
h = heatmap(tbl,'gamma','perturbation','ColorVariable','TV');
h.YLabel = 'Perturbation (%)';
h.XLabel = 'Gamma (rad.)';
h.CellLabelFormat = '%.6f';
h.Title = ['Total variation of ', num2str(n),' samples'];

tbl = table(GV,perturbation,gamma);
figure(2)
h = heatmap(tbl,'gamma','perturbation','ColorVariable','GV');
h.YLabel = 'Perturbation (%)';
h.XLabel = 'Gamma (rad.)';
h.CellLabelFormat = '%.6f';
h.Title = ['Generalized variance of ', num2str(n),' samples'];

tbl = table(fall_ratio,perturbation,gamma);
figure(3)
h = heatmap(tbl,'gamma','perturbation','ColorVariable','fall_ratio');
h.YLabel = 'Perturbation (%)';
h.XLabel = 'Gamma (rad.)';
h.CellLabelFormat = '%.4f';
h.Title = ['Fall to non-fall ratio of ', num2str(n),' samples'];

tbl = table(percent_yield,perturbation,gamma);
figure(4)
h = heatmap(tbl,'gamma','perturbation','ColorVariable','percent_yield');
axs = struct(gca); %ignore warning that this should be avoided
cb = axs.Colorbar;
cb.TickLabels = append(cb.TickLabels,"%");
h.YLabel = 'Perturbation (%)';
h.XLabel = 'Gamma (rad.)';
h.CellLabelFormat = '%.2f%%';
h.Title = ['Percent yield of ', num2str(n),' samples'] ;


map = brewermap(2,'Set1');
for itor = 1:length(pert)
    
    bin_edges = -pert(itor)*100:pert(itor)*100;    
    p1g = p1(itor,:)';
    p2g = p2(itor,:)';
    p3g = p3(itor,:)';
    p4g = p4(itor,:)';
    
    figure(4+itor)
    t = tiledlayout('flow');
    
    nexttile
    hold on
    histogram(p1g(y==0),bin_edges,'FaceColor',map(2,:),'facealpha',.5,'edgecolor','none')
    histogram(p1g(y==1),bin_edges,'FaceColor',map(1,:),'facealpha',.5,'edgecolor','none')
    title('\theta','Fontsize', 18)
    
    nexttile
    hold on
    histogram(p2g(y==0),bin_edges,'FaceColor',map(2,:),'facealpha',.5,'edgecolor','none')
    histogram(p2g(y==1),bin_edges,'FaceColor',map(1,:),'facealpha',.5,'edgecolor','none')
    title('$\dot{\theta}$','Interpreter','latex','Fontsize',18)
    legend('non-falls','falls','Location','northeast')
    
    nexttile
    hold on
    histogram(p3g(y==0),bin_edges,'FaceColor',map(2,:),'facealpha',.5,'edgecolor','none')
    histogram(p3g(y==1),bin_edges,'FaceColor',map(1,:),'facealpha',.5,'edgecolor','none')
    title('\phi','Fontsize', 18)
    
    nexttile
    hold on
    histogram(p4g(y==0),bin_edges,'FaceColor',map(2,:),'facealpha',.5,'edgecolor','none')
    histogram(p4g(y==1),bin_edges,'FaceColor',map(1,:),'facealpha',.5,'edgecolor','none')
    title('$\dot{\phi}$','Interpreter','latex','Fontsize',18)
    
    title(t, ['Distribution of \pm', num2str(pert(itor)*100),'% perturbation size at \gamma = ', num2str(max(gam))],'fontsize',23)
    xlabel(t, 'Perturbation magnitude (%)','fontsize',20)
    ylabel(t, 'Frequency','fontsize',20)
    
end


% eof


%%%% OLD
% % Calculate variance
% m1v = var(m1);
% m2v = var(m2);
% m3v = var(m3);
% m4v = var(m4);
% m5v = var(m5);
% m6v = var(m6);
% 
% % Sum and store the variance of the normalized metrics from each setting 
% for itor = 1:conds
%     sum_norm_var(itor) = m1v(itor) + m2v(itor) + m3v(itor) + m4v(itor) + m5v(itor) + m6v(itor);
% end


% Save processed data
% trials_run = repelem(n,conds)';
% matrix = [sum_norm_var falls non_falls tot_trials trials_run gamma perturbation];
% writematrix(matrix,'gaitCycles6wvar.csv');

