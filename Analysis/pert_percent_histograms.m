% pert_percent_histograms
% 
% Plot histograms of the percent perturbation experienced by each
% IC variable for all provided data sets.
% 
% Assumes number of trials is the same across data sets.

addpath('../Brewermap colors');

%% Load Data

P = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/metrics.csv');
yall = M(:,1);

P(end+1:end+4,:) = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv');
yall(:,end+1) = M(:,1);

P(end+1:end+4,:) = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/metrics.csv');
yall(:,end+1) = M(:,1);

%% Prepare 
num_datasets = size(yall,2);

pert = 0.50;
gam = [0.014, 0.016, 0.019];
p_ind = (1:4:size(P,1));
bin_edges = -pert*100:pert*100;

map = brewermap(40,'Greys');
light = 25;
alpha = 0.75;

%% Plot
figure
t = tiledlayout(4,num_datasets,'TileSpacing','Compact');
for i = 1:num_datasets
    
    % Get perturbations applied to each IC at current gamma
    theta = P(p_ind(i),:)';
    thetadot = P(p_ind(i)+1,:)';
    phi = P(p_ind(i)+2,:)';
    phidot = P(p_ind(i)+3,:)';
    
    % Fall/nonfall
    y = yall(:,i);
    
    % Plot onto specific tiles for 4 x num_datasets grid.
    nexttile(i)
    hold on
    histogram(theta(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(theta(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\theta \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize', 18)

    
    nexttile(i+num_datasets)
    hold on
    histogram(thetadot(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(thetadot(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\dot{\theta} \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize',18)

    
    nexttile(i+2*num_datasets)
    hold on
    histogram(phi(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(phi(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\phi \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize', 18)

    
    nexttile(i+3*num_datasets)
    hold on
    histogram(phidot(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(phidot(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\dot{\phi} \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize',18)    

end

% Place legend in the top right corner
nexttile(num_datasets)
legend('Non-falls','Falls','Location','northeast','Fontsize',20)

% Axes labels
xlabel(t, 'Perturbation magnitude (%)','fontsize',20)
ylabel(t, 'Frequency','fontsize',20)

